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
class TweenFn<T> extends Tween<T> implements ITween {


	public function start(time:Float = 0):TweenFn<T> {

		begin(time);

		return this;

	}

	public macro function update<T>(self:Expr, duration:ExprOf<Float>, start:ExprOf<Array<Float>> = null, end:ExprOf<Array<Float>> = null, manual_update:Bool = false):ExprOf<TweenFn<T>> {

		return macro {
			
			$self._update(
				slide.tweens.Tween.get_fn(null, $start, $end),
				$duration,
				$start,
				$end
			);

		};

	}

	@:noCompletion 
	public function _update(fn:T->Array<Float>->Void, duration:Float, start:Array<Float> = null, end:Array<Float> = null):TweenFn<T> {

		add_action(new FnAction(this, fn, duration, start, end));

		return this;

	}

	public macro function set(self:Expr, values:Array<Expr>):ExprOf<TweenFn<T>> {

		return macro {

			$self.call(
				function(t){
					t($a{values});
				}
			);

		};

	}

	public function wait(duration:Float):TweenFn<T> {

		add_action(new TweenAction<T>(this, duration));

		return this;

	}

	public function call(fn:T->Void):TweenFn<T> {

		add_action(new CallAction(this, fn));

		return this;

	}

	public function label(name:String):TweenFn<T> {

		// add_action(new CallAction(this, fn));

		return this;

	}

	public function onstart(f:Void->Void):TweenFn<T> {

		_onstart = f;

		return this;

	}

	public function onstop(f:Void->Void):TweenFn<T> {

		_onstop = f;

		return this;

	}

	public function onupdate(f:Void->Void):TweenFn<T> {

		_onupdate = f;

		return this;

	}

	public function onrepeat(f:Void->Void):TweenFn<T> {

		_onrepeat = f;

		return this;

	}

	public function oncomplete(f:Void->Void):TweenFn<T> {

		_oncomplete = f;

		return this;

	}

	public function repeat(times:Int = -1):TweenFn<T> {

		_repeat = times;
		
		return this;

	}

	public function reflect():TweenFn<T> {

		_reflect = true;
		
		return this;

	}

	public function then(tween:Tween<Dynamic>):TweenFn<T> {

		_next_tween = tween;

		return this;

	}

	public function ease(easing:EaseFunc):TweenFn<T> {

		_easing = easing;

		return this;

	}


}