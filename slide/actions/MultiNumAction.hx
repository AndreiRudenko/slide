package slide.actions;


import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class MultiNumAction<T> extends TweenAction<T> {


	var _get_prop:T->Array<Float>->Void;
	var _set_prop:T->Array<Float>->Void;

	var _from:Array<Float>;
	var _difference:Array<Float>;
	var _current:Array<Float>;
	var _to:Array<Float>;

	var _reverse:Bool;


	public function new(tween:Tween<T>, get_prop:T->Array<Float>->Void, set_prop:T->Array<Float>->Void, values:Array<Float>, duration:Float, reverse:Bool) {

		super(tween, duration);

		_get_prop = get_prop;
		_set_prop = set_prop;
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
			_get_prop(_tween.target, _to);
		} else {
			_get_prop(_tween.target, _from);
		}


		for (i in 0..._from.length) {
			_difference[i] = _to[i%_to.length] - _from[i];
		}

	}

	override function apply(t:Float) {
		
		for (i in 0..._from.length) {
			_current[i] = _from[i] + _difference[i] * t;
		}

		_set_prop(_tween.target, _current);

	}

}
