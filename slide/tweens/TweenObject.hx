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

	public macro function from_to(self:Expr, start:Expr, end:Expr, duration:ExprOf<Float>) {

		return macro $self._pm($start, $end, $duration, false);

	}

	public macro function mt(self:Expr, _name:ExprOf<String>, duration:ExprOf<Float>, start:ExprOf<Array<Float>> = null, end:ExprOf<Array<Float>> = null):ExprOf<TweenAction<T>> {

		return macro {

			$self._mt(
				slide.tweens.Tween.get_fn($_name, $start, $end),
				$duration,
				$start,
				$end
			);

		};

	}

	public macro function set<T>(self:ExprOf<T>, expr:Expr):ExprOf<TweenObject<T>> {

		var field_names:Array<String> = [];
		var values:Array<Expr> = [];

		slide.tweens.Tween.get_props(expr, field_names, values);

		var exprs:Array<Expr> = [];
		var fname:String;
		var fvalue:Expr;

		for (j in 0...field_names.length) {
			fname = field_names[j];
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

		add_action(new TweenAction<T>(this, duration));

		return this;

	}

	public function call(fn:T->Void):TweenObject<T> {

		add_action(new CallAction(this, fn));

		return this;

	}

	@:noCompletion
	public macro function _pm<T>(self:ExprOf<T>, start:Expr, end:Expr, duration:ExprOf<Float>, backwards:ExprOf<Bool>):ExprOf<TweenObject<T>> {

		var prop_fields:Array<String> = [];
		var from_values:Array<Expr> = [];
		var to_values:Array<Expr> = [];

		var is_target_array = switch (Context.typeof(self)) {
			case TInst(_, p): 
				switch (p[0]) {
					case TInst(_.get() => t, _): t.name == 'Array';
					case _: false;
				}
			case _: throw 'Invalid object type';
		}

		slide.tweens.Tween.get_props(end, prop_fields, to_values);

		var has_start = switch (start.expr) {
			case EConst(CIdent("null")): false;
			case _: true;
		}

		if(has_start) {
			var start_fields:Array<String> = [];
			slide.tweens.Tween.get_props(start, start_fields, from_values);

			for (ef in prop_fields) {
				if(start_fields.indexOf(ef) == -1) {
					throw('Field $ef not exist in start props');
				}
			}
			for (sf in start_fields) {
				if(prop_fields.indexOf(sf) == -1) {
					throw('Field $sf not exist in end props');
				}
			}
		}

		if(is_target_array || prop_fields.length > 1) {

			function handle_getset(props:Array<String>, st:Array<Expr>, set:Bool, ta:Bool) {

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
				$self._prop_mult(
					function(t,v){
						${handle_getset(prop_fields, from_values, true, is_target_array)};
					},
					function(t,v){
						${handle_getset(prop_fields, from_values, false, is_target_array)};
					},
					$a{to_values},
					$duration,
					$backwards
				);
			};
		} else {
			var fname = prop_fields[0];
			var fv = to_values[0];

			function handle_get(props:Array<String>, st:Array<Expr>) {

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
						return ${handle_get(prop_fields, from_values)};
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
	public function _prop(get_prop:T->Float, set_prop:T->Float->Void, value:Float, duration:Float, backwards:Bool):TweenObject<T> {

		add_action(new NumAction<T>(this, get_prop, set_prop, value, duration, backwards));

		return this;

	}

	@:noCompletion 
	public function _prop_mult(get_prop:T->Array<Float>->Void, set_prop:T->Array<Float>->Void, values:Array<Float>, duration:Float, backwards:Bool):TweenObject<T> {

		add_action(new MultiNumAction<T>(this, get_prop, set_prop, values, duration, backwards));

		return this;

	}

	@:noCompletion 
	public function _mt(fn:T->Array<Float>->Void, duration:Float, start:Array<Float> = null, end:Array<Float> = null):TweenObject<T> {

		add_action(new FnAction(this, fn, duration, start, end));

		return this;

	}

	public function onstart(f:Void->Void):TweenObject<T> {

		_onstart = f;

		return this;

	}

	public function onstop(f:Void->Void):TweenObject<T> {

		_onstop = f;

		return this;

	}

	public function onupdate(f:Void->Void):TweenObject<T> {

		_onupdate = f;

		return this;

	}

	public function onrepeat(f:Void->Void):TweenObject<T> {

		_onrepeat = f;

		return this;

	}

	public function oncomplete(f:Void->Void):TweenObject<T> {

		_oncomplete = f;

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

		_next_tween = tween;

		return this;

	}

	public function ease(easing:EaseFunc):TweenObject<T> {

		_easing = easing;

		return this;

	}


}