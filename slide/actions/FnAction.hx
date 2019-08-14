package slide.actions;

import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class FnAction<T> extends TweenAction<T> {


	var from:Array<Float>;
	var current:Array<Float>;
	var difference:Array<Float>;
	var fn:T->Array<Float>->Void;


	public function new(tween:Tween<T>, fn:T->Array<Float>->Void, duration:Float, from:Array<Float> = null, to:Array<Float> = null) {

		super(tween, duration);

		this.fn = fn;
		difference = [];
		current = [];

		if(from != null && to != null) {
			this.from = from.copy();
			for (i in 0...from.length) {
				difference[i] = to[i] - from[i];
			}
		} else {	
			from = [];
		}
		
	}

	override function apply(t:Float) {

		var n:Float = 0;
		for (i in 0...from.length) {
			n = from[i] + difference[i] * t;
			current[i] = n;
		}
		
		fn(_tween.target, current);

	}


}
