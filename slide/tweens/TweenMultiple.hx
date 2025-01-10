package slide.tweens;

class TweenMultiple<T> extends TweenEmpty {

	var target:T;
	
	var getProps:T->Array<Float>->Void;
	var setProps:T->Array<Float>->Void;

	var from:Array<Float> = [];
	var difference:Array<Float> = [];
	var current:Array<Float> = [];
	var to:Array<Float> = [];
	var targetValues:Array<Float>;

	var swapFromTo:Bool = false;

	public function new(target:T, getProps:T->Array<Float>->Void, setProps:T->Array<Float>->Void, targetValues:Array<Float>, duration:Float, easing:(t:Float)->Float, swapFromTo:Bool) {
		super(duration, easing);

		this.target = target;

		this.getProps = getProps;
		this.setProps = setProps;

		this.targetValues = targetValues;

		this.swapFromTo = swapFromTo;

		buildStartValues();
	}
	
	override function buildStartValues() {
		if (swapFromTo) {
			setTargetValuesTo(from);
			getProps(target, to);
		} else {
			getProps(target, from);
			setTargetValuesTo(to);
		}

		for (i in 0...from.length) {
			difference[i] = to[i] - from[i];
		}
	}

	override function positionChanged(position:Float) {
		for (i in 0...from.length) {
			current[i] = from[i] + difference[i] * position;
		}

		setProps(target, current);
	}

	function setTargetValuesTo(arr:Array<Float>) {
		for (i in 0...targetValues.length) {
			arr[i] = targetValues[i];
		}
	}

}