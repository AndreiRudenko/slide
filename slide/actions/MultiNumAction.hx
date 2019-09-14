package slide.actions;

import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class MultiNumAction<T> extends TweenAction<T> {


	var _getProp:T->Array<Float>->Void;
	var _setProp:T->Array<Float>->Void;

	var _from:Array<Float>;
	var _difference:Array<Float>;
	var _current:Array<Float>;
	var _to:Array<Float>;

	var _reverse:Bool;


	public function new(tween:Tween<T>, getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, values:Array<Float>, duration:Float, reverse:Bool) {

		super(tween, duration);

		_getProp = getProp;
		_setProp = setProp;
		_from = [];
		_difference = [];
		_current = [];
		_to = values;
		_reverse = reverse;

	}

	override function init() {

		if(_reverse) {
			var tmp = _from;
			_from = _to;
			_to = tmp;
			_getProp(_tween.target, _to);
		} else {
			_getProp(_tween.target, _from);
		}


		for (i in 0..._from.length) {
			_difference[i] = _to[i%_to.length] - _from[i];
		}

	}

	override function apply(t:Float) {
		
		for (i in 0..._from.length) {
			_current[i] = _from[i] + _difference[i] * t;
		}

		_setProp(_tween.target, _current);

	}
	

}
