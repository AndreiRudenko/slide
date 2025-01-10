package slide.tweens;

class TweenMultipleBy<T> extends TweenEmpty {

	var target:T;
	
	var getProp:T->Array<Float>->Void;
	var setProp:T->Array<Float>->Void;

	var from:Array<Float> = [];
	var difference:Array<Float> = [];
	var current:Array<Float> = [];

	var amount:Array<Float>;

	public function new(target:T, getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, amount:Array<Float>, duration:Float, easing:(t:Float)->Float) {
		super(duration, easing);

		this.target = target;

		this.getProp = getProp;
		this.setProp = setProp;

		this.amount = amount;

		buildStartValues();
	}
	
	override function buildStartValues() {
		getProp(target, from);

		for (i in 0...amount.length) {
			difference[i] = amount[i];
		}
	}

	override function positionChanged(position:Float) {
		for (i in 0...from.length) {
			current[i] = from[i] + difference[i] * position;
		}

		setProp(target, current);
	}

}