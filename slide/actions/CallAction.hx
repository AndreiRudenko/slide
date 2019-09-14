package slide.actions;

import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class CallAction<T> extends TweenAction<T> {


	var callFn:T->Void;


	public function new(tween:Tween<T>, fn:T->Void) {

		super(tween, 0);

		callFn = fn;

	}

	override function start(t:Float) {

		callFn(_tween.target);
		complete = true;

	}


}
