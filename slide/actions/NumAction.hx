package slide.actions;

import slide.tweens.Tween;

@:access(slide.tweens.Tween)
class NumAction<T> extends TweenAction<T> {

	var _getProp:T->Float;
	var _setProp:T->Float->Void;

	var _from:Float;
	var _difference:Float;
	var _to:Float;

	var _reverse:Bool;

	public function new(tween:Tween<T>, getProp:T->Float, setProp:T->Float->Void, value:Float, duration:Float, reverse:Bool) {
		super(tween, duration);

		_tween = tween;

		_getProp = getProp;
		_setProp = setProp;
		_to = value;
		_reverse = reverse;
	}

	override function init() {
		if(_reverse) {
			_from = _to;
			_to = _getProp(_tween.target);
		} else {
			_from = _getProp(_tween.target);
		}

		_difference = _to - _from;
	}

	override function apply(t:Float) {
		var v = _from + _difference * t;
		_setProp(_tween.target, v);
	}

}
