package slide.tweens;

class TweenSingleBy<T> extends TweenEmpty {

	var target:T;
	
	var getProp:T->Float;
	var setProp:(T, Float)->Void;

	var from:Float = 0;
	var amount:Float;
	var difference:Float = 0;

	public function new(target:T, getProp:T->Float, setProp:(T, Float)->Void, amount:Float, duration:Float, easing:(t:Float)->Float) {
		super(duration, easing);

		this.target = target;

		this.getProp = getProp;
		this.setProp = setProp;

		this.amount = amount;

		buildStartValues();
	}
	
	override function buildStartValues() {
		from = getProp(target);
		difference = amount;
	}

	override function positionChanged(position:Float) {
		final value = from + difference * position;
		setProp(target, value);
	}

}