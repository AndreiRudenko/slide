package slide.tweens;

class TweenSingleAlong<T> extends TweenEmpty {

	var target:T;
	
	var getProp:T->Float;
	var setProp:(T, Float)->Void;

	var values:Array<Float>;

	public function new(target:T, getProp:T->Float, setProp:(T, Float)->Void, values:Array<Float>, duration:Float, easing:(t:Float)->Float) {
		super(duration, easing);

		this.target = target;

		this.getProp = getProp;
		this.setProp = setProp;

		this.values = values;

		if (values.length == 0) {
			throw "TweenSingleAlong: Values array must not be empty";
		}
	}

	override function positionChanged(position:Float) {
		setProp(target, getValueAt(values, position));
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

}