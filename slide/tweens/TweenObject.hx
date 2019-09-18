package slide.tweens;

import haxe.macro.Expr;
import haxe.macro.Context;

import slide.tweens.Tween;
import slide.actions.TweenAction;
import slide.actions.NumAction;
import slide.actions.MultiNumAction;
import slide.actions.CallAction;
import slide.actions.FnAction;


@:access(slide.actions.TweenAction)
class TweenObject<T> extends Tween<T> implements ITween {


	public function start(time:Float = 0):TweenObject<T> {

		begin(time);

		return this;

	}

	public macro function to(self:Expr, props:Expr, duration:ExprOf<Float>):ExprOf<TweenObject<T>> {

		return macro $self._pm(null, $props, $duration, false);

	}

	public macro function from(self:Expr, _props:Expr, duration:ExprOf<Float>) {

		return macro $self._pm(null, $_props, $duration, true);

	}

	public macro function fromTo(self:Expr, start:Expr, end:Expr, duration:ExprOf<Float>) {

		return macro $self._pm($start, $end, $duration, false);

	}

	public macro function mt(self:Expr, _name:ExprOf<String>, duration:ExprOf<Float>, start:ExprOf<Array<Float>> = null, end:ExprOf<Array<Float>> = null):ExprOf<TweenAction<T>> {

		return macro {

			$self._mt(
				slide.tweens.Tween.getFn($_name, $start, $end),
				$duration,
				$start,
				$end
			);

		};

	}

	public macro function set<T>(self:ExprOf<T>, expr:Expr):ExprOf<TweenObject<T>> {

		var fieldNames:Array<String> = [];
		var values:Array<Expr> = [];

		slide.tweens.Tween.getProps(expr, fieldNames, values);

		var exprs:Array<Expr> = [];
		var fname:String;
		var fvalue:Expr;

		for (j in 0...fieldNames.length) {
			fname = fieldNames[j];
			fvalue = values[j];
			exprs.push(macro t.$fname = $fvalue);
		}

		return macro {

			$self.call(
				function(t){
					$a{exprs};
				}
			);

		};

	}

	public function wait(duration:Float):TweenObject<T> {

		addAction(new TweenAction<T>(this, duration));

		return this;

	}

	public function call(fn:T->Void):TweenObject<T> {

		addAction(new CallAction(this, fn));

		return this;

	}

	@:noCompletion
	public macro function _pm<T>(self:ExprOf<T>, start:Expr, end:Expr, duration:ExprOf<Float>, backwards:ExprOf<Bool>):ExprOf<TweenObject<T>> {

		var propFields:Array<String> = [];
		var fromValues:Array<Expr> = [];
		var toValues:Array<Expr> = [];

		var isTargetArray = switch (Context.typeof(self)) {
			case TInst(_, p): 
				switch (p[0]) {
					case TInst(_.get() => t, _): t.name == 'Array';
					case _: false;
				}
			case _: throw 'Invalid object type';
		}

		slide.tweens.Tween.getProps(end, propFields, toValues);

		var hasStart = switch (start.expr) {
			case EConst(CIdent("null")): false;
			case _: true;
		}

		if(hasStart) {
			var startFields:Array<String> = [];
			slide.tweens.Tween.getProps(start, startFields, fromValues);

			for (ef in propFields) {
				if(startFields.indexOf(ef) == -1) {
					throw('Field $ef not exist in start props');
				}
			}
			for (sf in startFields) {
				if(propFields.indexOf(sf) == -1) {
					throw('Field $sf not exist in end props');
				}
			}
		}

		if(isTargetArray || propFields.length > 1) {

			function handleGetset(props:Array<String>, st:Array<Expr>, set:Bool, ta:Bool) {

				var hs = st.length > 0;
				var ret:Expr;
				var exprs:Array<Expr> = [];

				var len = props.length;
				var fname:String;

				for (j in 0...len) {
					fname = props[j];
					exprs.push(
						if(ta) {
							if(set) {
								macro v[i * $v{len} + $v{j}] = t[i].$fname;
							} else {
								if(hs) {
									macro t[i].$fname = ${st[j]};
								} else {
									macro t[i].$fname = v[i * $v{len} + $v{j}];
								}
							}
						} else {
							if(set) {
								macro v[$v{j}] = t.$fname;
							} else {
								if(hs) {
									macro t.$fname = ${st[j]};
								} else {
									macro t.$fname = v[$v{j}];
								}
							}
						}
					);
				}

				ret = if(ta) {
					macro {for (i in 0...t.length) {$a{exprs}}};
				} else {
					macro $a{exprs};
				}

				return ret;
				
			}

			return macro {
				$self._propMult(
					function(t,v){
						${handleGetset(propFields, fromValues, true, isTargetArray)};
					},
					function(t,v){
						${handleGetset(propFields, fromValues, false, isTargetArray)};
					},
					$a{toValues},
					$duration,
					$backwards
				);
			};
		} else {
			var fname = propFields[0];
			var fv = toValues[0];

			function handleGet(props:Array<String>, st:Array<Expr>) {

				if(st.length > 0) {
					return macro ${st[0]};
				} else {
					var f = props[0];
					return macro t.$f;
				}

			}

			return macro {
				$self._prop(
					function(t){
						return ${handleGet(propFields, fromValues)};
					},
					function(t,v){
						t.$fname = v;
					},
					$fv,
					$duration,
					$backwards
				);
			};
		}

	}

	@:noCompletion 
	public function _prop(getProp:T->Float, setProp:T->Float->Void, value:Float, duration:Float, backwards:Bool):TweenObject<T> {

		addAction(new NumAction<T>(this, getProp, setProp, value, duration, backwards));

		return this;

	}

	@:noCompletion 
	public function _propMult(getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, values:Array<Float>, duration:Float, backwards:Bool):TweenObject<T> {

		addAction(new MultiNumAction<T>(this, getProp, setProp, values, duration, backwards));

		return this;

	}

	@:noCompletion 
	public function _mt(fn:T->Array<Float>->Void, duration:Float, start:Array<Float> = null, end:Array<Float> = null):TweenObject<T> {

		addAction(new FnAction(this, fn, duration, start, end));

		return this;

	}

	public function onStart(f:Void->Void):TweenObject<T> {

		_onStart = f;

		return this;

	}

	public function onStop(f:Void->Void):TweenObject<T> {

		_onStop = f;

		return this;

	}

	public function onPause(f:Void->Void):TweenObject<T> {

		_onPause = f;

		return this;

	}

	public function onResume(f:Void->Void):TweenObject<T> {

		_onResume = f;

		return this;

	}

	public function onUpdate(f:Void->Void):TweenObject<T> {

		_onUpdate = f;

		return this;

	}

	public function onRepeat(f:Void->Void):TweenObject<T> {

		_onRepeat = f;

		return this;

	}

	public function onComplete(f:Void->Void):TweenObject<T> {

		_onComplete = f;

		return this;

	}

	public function repeat(times:Int = -1):TweenObject<T> {

		_repeat = times;
		
		return this;

	}

	public function reflect():TweenObject<T> {

		_reflect = true;
		
		return this;

	}

	public function then(tween:Tween<Dynamic>):TweenObject<T> {

		_nextTween = tween;

		return this;

	}

	public function ease(easing:EaseFunc):TweenObject<T> {

		_easing = easing;

		return this;

	}


}