package slide.tweens;

class TweenSingle<T> extends TweenEmpty {

	static var idCounter:Int = 0;
	var id:Int;

	var target:T;
	
	var getProp:T->Float;
	var setProp:(T, Float)->Void;

	var from:Float = 0;
	var to:Float = 0;
	var difference:Float = 0;
	var targetValue:Float;

	var swapFromTo:Bool = false;

	public function new(target:T, getProp:T->Float, setProp:(T, Float)->Void, targetValue:Float, duration:Float, easing:(t:Float)->Float, swapFromTo:Bool) {
		super(duration, easing);

		id = idCounter++;

		this.target = target;

		this.getProp = getProp;
		this.setProp = setProp;

		this.targetValue = targetValue;

		this.swapFromTo = swapFromTo;

		buildStartValues();
	}

	override function buildStartValues() {
		if (swapFromTo) {
			from = targetValue;
			to = getProp(target);
		} else {
			from = getProp(target);
			to = targetValue;
		}

		difference = to - from;
	}

	override function positionChanged(position:Float) {
		final value = from + difference * position;
		setProp(target, value);
	}

}