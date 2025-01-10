package slide.tweens;

class TweenMultipleAlong<T> extends TweenEmpty {

	var target:T;
	
	var getProp:T->Array<Float>->Void;
	var setProp:T->Array<Float>->Void;

	var current:Array<Float> = [];
	var values:Array<Array<Float>> = [];

	public function new(target:T, getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, values:Array<Array<Float>>, duration:Float, easing:(t:Float)->Float) {
		super(duration, easing);

		this.target = target;

		this.getProp = getProp;
		this.setProp = setProp;

		this.values = values;

		if (hasEmptyValues(values)) {
			throw "TweenMultipleAlong: Values array must not be empty";
		}
	}

	override function positionChanged(position:Float) {
		for (i in 0...values.length) {
			current[i] = getValueAt(values[i], position);
		}

		setProp(target, current);
	}

	function getValueAt(arr:Array<Float>, position:Float):Float {
		final index = (arr.length - 1) * position;
		final lowerIndex = Std.int(index);
		final upperIndex = lowerIndex + 1;
	
		if (upperIndex >= arr.length) {
			return arr[lowerIndex];
		}
	
		final fraction = index - lowerIndex;
		return arr[lowerIndex] * (1 - fraction) + arr[upperIndex] * fraction;
	}

	function hasEmptyValues(arr:Array<Array<Float>>):Bool {
		for (i in 0...arr.length) {
			if (arr[i].length == 0) {
				return true;
			}
		}

		return false;
	}

}