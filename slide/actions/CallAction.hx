package slide.actions;

import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class CallAction<T> extends TweenAction<T> {


	var _callFn:T->Void;


	public function new(tween:Tween<T>, fn:T->Void) {

		super(tween, 0);

		_callFn = fn;

	}

	override function start(t:Float) {

		_callFn(_tween.target);
		complete = true;

	}


}
