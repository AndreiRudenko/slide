package slide.actions;

import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class FnAction<T> extends TweenAction<T> {


	var _from:Array<Float>;
	var _current:Array<Float>;
	var _difference:Array<Float>;
	var _fn:T->Array<Float>->Void;


	public function new(tween:Tween<T>, fn:T->Array<Float>->Void, duration:Float, from:Array<Float> = null, to:Array<Float> = null) {

		super(tween, duration);

		_fn = fn;
		_difference = [];
		_current = [];

		if(from != null && to != null) {
			_from = from.copy();
			for (i in 0..._from.length) {
				_difference[i] = to[i] - _from[i];
			}
		} else {	
			_from = [];
		}
		
	}

	override function apply(t:Float) {

		var n:Float = 0;
		for (i in 0..._from.length) {
			n = _from[i] + _difference[i] * t;
			_current[i] = n;
		}
		
		_fn(_tween.target, _current);

	}


}
