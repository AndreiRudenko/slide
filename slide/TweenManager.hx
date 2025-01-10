package slide;

import haxe.macro.Expr;

import slide.tweens.TweenObserver;
import slide.tweens.TweenEmpty;
import slide.tweens.TweenSingle;
import slide.tweens.TweenSingleBy;
import slide.tweens.TweenSingleAlong;
import slide.tweens.TweenMultiple;
import slide.tweens.TweenMultipleBy;
import slide.tweens.TweenMultipleAlong;
import slide.tweens.TweenParallel;
import slide.tweens.TweenSequence;

interface ITweenManager {
	function animateTo(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateFrom(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateFromTo(target:Dynamic, startProps:Dynamic, endProps:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateBy(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateAlong(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function delay(duration:Float, ?onComplete:()->Void):Tween;
	function sequence(tweens:Array<Tween>, ?onComplete:()->Void):Tween;
	function parallel(tweens:Array<Tween>, ?onComplete:()->Void):Tween;
	function update(elapsed:Float):Void;
	function stopAll():Void;
	function completeAll():Void;
}

/* 
example usage:
final obj = { x : 0.0, y : 0.0 };

final tween = tweenManager.animateTo(obj, { x: 100 }, 1, Quad.easeIn);
final tween = tweenManager.animateTo(obj, { x: 300, y: 200 }, 1, Quad.easeIn);

final tween = tweenManager.animateFrom(obj, { x: 100 }, 1, Quad.easeIn);
final tween = tweenManager.animateFrom(obj, { x: 100, y: 200 }, 1, Quad.easeIn);

final tween = tweenManager.animateFromTo(obj, { x: 100 }, { x: 200 }, 1, Quad.easeIn);
final tween = tweenManager.animateFromTo(obj, { x: 100, y: 200 }, { x: 200, y: 300 }, 1, Quad.easeIn);

final tween = tweenManager.animateBy(obj, { x: 100 }, 1, Quad.easeIn);
final tween = tweenManager.animateBy(obj, { x: 100, y: 200 }, 1, Quad.easeIn);

final tween = tweenManager.animateAlong(obj, { x: [100, 200, 50] }, 1, Quad.easeIn);
final tween = tweenManager.animateAlong(obj, { x: [100, 200, 50], y: [200, 300, 100, 500] }, 1, Quad.easeIn);

final tween = tweenManager.sequence([
	tweenManager.animateTo(obj, { x: 100 }, 1),
	tweenManager.delay(0.5),
	tweenManager.animateTo(obj, { x: 100, y: 200 }, 1)
]);

final tween = tweenManager.parallel([
	tweenManager.animateTo(obj, { x: 100 }, 1),
	tweenManager.animateTo(obj2, { x: 100, y: 200 }, 1)
]);

final tween = tweenManager.delay(0.5, doSomething);

final tween = tweenManager.animateTo(obj, { x: 100 }, 1, Quad.easeIn);
tween.stop();

tweenManager.stopAll();
tweenManager.completeAll();

interface TweenManager implements TweenGroup {
	function animateTo(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateFrom(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateFromTo(target:Dynamic, startProps:Dynamic, endProps:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateBy(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function animateAlong(target:Dynamic, props:Dynamic, duration:Float, ?ease:Float->Float, ?onComplete:Void->Void):Tween;
	function delay(duration:Float, ?onComplete:()->Void):Tween;
	function sequence(tweens:Array<Tween>, ?onComplete:()->Void):Tween;
	function parallel(tweens:Array<Tween>, ?onComplete:()->Void):Tween;
	function update(elapsed:Float):Void;
	function stopAll():Void;
	function completeAll():Void;
}

interface Tween {
	var isStarted(default, null):Bool;
	var isComplete(default, null):Bool;
	var isPaused(default, null):Bool;
	var isYoyo(default, null):Bool;
	
	var repeatCount(default, null):Int;
	var repeatIndex(default, null):Int;

	function start(group:TweenGroup, startTime:Float = 0, overrideStartValues:Bool = true):Void;
	function stop():Void;
	function complete():Void;
	function reset():Void;
	function pause():Void;
	function resume():Void;

	function update(elapsed:Float):Float;

	function repeat(times:Int = -1):Tween;
	function yoyo(v:Bool = true):Tween;

	function onRepeat(fn:Void->Void):Tween;
	function onComplete(fn:Void->Void):Tween;
	function onUpdate(fn:Void->Void):Tween;
	function onStart(fn:Void->Void):Tween;
	function onStop(fn:Void->Void):Tween;
	function onReset(fn:Void->Void):Tween;
	function onPause(fn:Void->Void):Tween;
	function onResume(fn:Void->Void):Tween;
}



methods:

class Obj2 {
	var position:Vector2;

	public function setPositon(x:Float, y:Float) {
		position.x = x;
		position.y = y;
	}

	public function getPositon():Vector2 {
		return position;
	}
}

var obj = new Obj2();
var pos = obj.getPositon();
var t = tweenManager.animateTo(pos, { x: 100, y: 200 }, 1).onUpdate(function() {
	obj.setPositon(pos.x, pos.y);
});

*/

class TweenManager implements TweenObserver {

	final commandQueue:Array<TweenManagerCommand> = [];
	final tweenList:Array<Tween> = [];

	var isIterating:Bool = false;

	public function new() {}
	
	public macro function animateTo(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ?ease:ExprOf<Float->Float>, ?onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		return macro $self.buildTweenTo($target, $props, $duration, $ease, $onComplete, false);
	}
	
	public macro function animateFrom(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ?ease:ExprOf<Float->Float>, ?onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		return macro $self.buildTweenTo($target, $props, $duration, $ease, $onComplete, true);
	}

	public macro function animateFromTo(self:Expr, target:Expr, startProps:Expr, endProps:Expr, duration:ExprOf<Float>, ?ease:ExprOf<Float->Float>, ?onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		return macro $self.buildTweenFromTo($target, $startProps, $endProps, $duration, $ease, $onComplete);
	}

	public macro function animateBy(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ?ease:ExprOf<Float->Float>, ?onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		return macro $self.buildTweenBy($target, $props, $duration, $ease, $onComplete);
	}

	public macro function animateAlong(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ?ease:ExprOf<Float->Float>, ?onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		return macro $self.buildTweenAlong($target, $props, $duration, $ease, $onComplete);
	}

	public function delay(duration:Float, ?onComplete:()->Void):Tween {
		final tween = new TweenEmpty(duration);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	public function sequence(tweens:Array<Tween>, ?onComplete:()->Void):Tween {
		final tween = new TweenSequence(tweens);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	public function parallel(tweens:Array<Tween>, ?onComplete:()->Void):Tween {
		final tween = new TweenParallel(tweens);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	public function update(elapsed:Float) {
		isIterating = true;

		for (tween in tweenList) {
			tween.update(elapsed);
		}

		isIterating = false;

		executeCommandQueue();
	}

	public function stopAll():Void {
		isIterating = true;
		for (tween in tweenList) {
			tween.stop();
		}
		isIterating = false;

		executeCommandQueue();
	}

	public function completeAll():Void {
		isIterating = true;
		for (tween in tweenList) {
			tween.complete();
		}
		isIterating = false;
		
		executeCommandQueue();
	}

	function onTweenStarted(obj:Tween):Void {
		addTween(obj);
	}

	function onTweenStopped(obj:Tween):Void {
		removeTween(obj);
	}

	function addTween(obj:Tween):Void {
		if (isIterating) {
			addQueueCommand(TweenManagerCommandType.ADD, obj);
			return;
		}

		tweenList.push(obj);
	}

	function removeTween(obj:Tween):Void {
		if (isIterating) {
			addQueueCommand(TweenManagerCommandType.REMOVE, obj);
			return;
		}

		tweenList.remove(obj);
	}

	function addQueueCommand(type:TweenManagerCommandType, object:Tween):Void {
		commandQueue.push(new TweenManagerCommand(type, object));
	}

	function executeCommandQueue():Void {
		if (commandQueue.length == 0) return;

		for (command in commandQueue) {
			switch (command.type) {
				case TweenManagerCommandType.ADD:
					addTween(command.object);
				case TweenManagerCommandType.REMOVE:
					removeTween(command.object);
			}
		}

		commandQueue.splice(0, commandQueue.length);
	}

	// region Helpers
	
	@:noCompletion
	public function animateSingle<T>(target:T, getProp:T->Float, setProp:(T, Float)->Void, targetValue:Float, duration:Float, ?easing:(t:Float)->Float, ?onComplete:()->Void, swapFromTo:Bool):Tween {
		final tween = new TweenSingle(target, getProp, setProp, targetValue, duration, easing, swapFromTo);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	@:noCompletion
	public function animateMultiple<T>(target:T, getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, targetValues:Array<Float>, duration:Float, ?easing:(t:Float)->Float, ?onComplete:()->Void, swapFromTo:Bool):Tween {
		final tween = new TweenMultiple(target, getProp, setProp, targetValues, duration, easing, swapFromTo);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}
	
	@:noCompletion
	public function animateSingleBy<T>(target:T, getProp:T->Float, setProp:(T, Float)->Void, amount:Float, duration:Float, ?easing:(t:Float)->Float, ?onComplete:()->Void):Tween {
		final tween = new TweenSingleBy(target, getProp, setProp, amount, duration, easing);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	@:noCompletion
	public function animateMultipleBy<T>(target:T, getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, amount:Array<Float>, duration:Float, ?easing:(t:Float)->Float, ?onComplete:()->Void):Tween {
		final tween = new TweenMultipleBy(target, getProp, setProp, amount, duration, easing);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	@:noCompletion
	public function animateSingleAlong<T>(target:T, getProp:T->Float, setProp:(T, Float)->Void, values:Array<Float>, duration:Float, ?easing:(t:Float)->Float, ?onComplete:()->Void):Tween {
		final tween = new TweenSingleAlong(target, getProp, setProp, values, duration, easing);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	@:noCompletion
	public function animateMultipleAlong<T>(target:T, getProp:T->Array<Float>->Void, setProp:T->Array<Float>->Void, values:Array<Array<Float>>, duration:Float, ?easing:(t:Float)->Float, ?onComplete:()->Void):Tween {
		final tween = new TweenMultipleAlong(target, getProp, setProp, values, duration, easing);
		tween.setObserver(this);
		tween.onComplete(onComplete);
		return tween;
	}

	// region Macros
	
	@:noCompletion
	public macro function buildTweenTo(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ease:ExprOf<Float->Float>, onComplete:ExprOf<Void->Void>, swapFromTo:ExprOf<Bool>):ExprOf<Tween> {
		final fields:Array<String> = [];
		final values:Array<Expr> = [];

		extractProps(props, fields, values);

		if (fields.length > 1) {
			final getExprs:Array<Expr> = [];
			final setExprs:Array<Expr> = [];

			for (i in 0...fields.length) {
				final fieldName = fields[i];
				getExprs.push(macro v[$v{i}] = t.$fieldName);
				setExprs.push(macro t.$fieldName = v[$v{i}]);
			}

			return macro {
				$self.animateMultiple(
					$target, 
					function(t, v) { $a{getExprs}; },
					function(t, v) { $a{setExprs}; },
					$a{values}, 
					$duration, 
					$ease,
					$onComplete,
					$swapFromTo
				);
			};
		} else {

			final fieldName = fields[0];
			final value = values[0];

			return macro {
				$self.animateSingle(
					$target, 
					function(t) { return t.$fieldName; },
					function(t, v) { t.$fieldName = v; },
					$value, 
					$duration, 
					$ease,
					$onComplete,
					$swapFromTo
				);
			};
		}
	}

	@:noCompletion
	public macro function buildTweenFromTo(self:Expr, target:Expr, startProps:Expr, endProps:Expr, duration:ExprOf<Float>, ease:ExprOf<Float->Float>, onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		final startFields:Array<String> = [];
		final startValues:Array<Expr> = [];
		final endFields:Array<String> = [];
		final endValues:Array<Expr> = [];

		extractProps(startProps, startFields, startValues);
		extractProps(endProps, endFields, endValues);

		for (f in startFields) {
			if (endFields.indexOf(f) == -1) {
				throw('Field ${f} not found in end fields');
			}
		}

		for (f in endFields) {
			if (startFields.indexOf(f) == -1) {
				throw('Field ${f} not found in start fields');
			}
		}

		if (startFields.length > 1) {
			final getExprs:Array<Expr> = [];
			final setExprs:Array<Expr> = [];

			for (i in 0...startFields.length) {
				final fieldName = startFields[i];
				final startValue = startValues[i];

				getExprs.push(macro v[$v{i}] = $startValue);
				setExprs.push(macro t.$fieldName = v[$v{i}]);
			}

			return macro {
				$self.animateMultiple(
					$target, 
					function(t, v) { $a{getExprs}; },
					function(t, v) { $a{setExprs}; },
					$a{endValues}, 
					$duration, 
					$ease,
					$onComplete,
					false
				);
			};
		} else {

			final fieldName = startFields[0];
			final startValue = startValues[0];
			final endValue = endValues[0];

			return macro {
				$self.animateSingle(
					$target, 
					function(t) { return $startValue; },
					function(t, v) { t.$fieldName = v; },
					$endValue, 
					$duration, 
					$ease,
					$onComplete,
					false
				);
			};
		}
	}

	@:noCompletion
	public macro function buildTweenBy(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ease:ExprOf<Float->Float>, onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		final fields:Array<String> = [];
		final values:Array<Expr> = [];

		extractProps(props, fields, values);

		if (fields.length > 1) {

			final getExprs:Array<Expr> = [];
			final setExprs:Array<Expr> = [];

			for (i in 0...fields.length) {
				final fieldName = fields[i];
				getExprs.push(macro v[$v{i}] = t.$fieldName);
				setExprs.push(macro t.$fieldName = v[$v{i}]);
			}

			return macro {
				$self.animateMultipleBy(
					$target, 
					function(t, v) { $a{getExprs}; },
					function(t, v) { $a{setExprs}; },
					$a{values}, 
					$duration, 
					$ease,
					$onComplete
				);
			};
		} else {

			final fieldName = fields[0];
			final value = values[0];

			return macro {
				$self.animateSingleBy(
					$target, 
					function(t) { return t.$fieldName; },
					function(t, v) { t.$fieldName = v; },
					$value, 
					$duration, 
					$ease,
					$onComplete
				);
			};
		}
	}

	@:noCompletion
	public macro function buildTweenAlong(self:Expr, target:Expr, props:Expr, duration:ExprOf<Float>, ease:ExprOf<Float->Float>, onComplete:ExprOf<Void->Void>):ExprOf<Tween> {
		final fields:Array<String> = [];
		final values:Array<Expr> = [];

		extractProps(props, fields, values);

		if (fields.length > 1) {
			final getExprs:Array<Expr> = [];
			final setExprs:Array<Expr> = [];

			for (i in 0...fields.length) {
				final fieldName = fields[i];
				getExprs.push(macro v[$v{i}] = t.$fieldName);
				setExprs.push(macro t.$fieldName = v[$v{i}]);
			}

			return macro {
				$self.animateMultipleAlong(
					$target, 
					function(t, v) { $a{getExprs}; },
					function(t, v) { $a{setExprs}; },
					$a{values}, 
					$duration, 
					$ease,
					$onComplete
				);
			};
		} else {
			final fieldName = fields[0];
			final value = values[0];

			return macro {
				$self.animateSingleAlong(
					$target, 
					function(t) { return t.$fieldName; },
					function(t, v) { t.$fieldName = v; },
					$value, 
					$duration, 
					$ease,
					$onComplete
				);
			};
		}
	}


	@:noCompletion
	public static function extractProps(props:Expr, fields:Array<String>, values:Array<Expr>) {
		switch (props.expr) {
			case EObjectDecl(obj):
				for (o in obj) {
					if(fields.indexOf(o.field) != -1) {
						throw('Field ${o.field} already exists');
					}
					fields.push(o.field);
					values.push(o.expr);
				}
			case _:
				trace(props);
				throw('Invalid expression in props');
		}
	}

}

private class TweenManagerCommand {
	public var type:TweenManagerCommandType;
	public var object:Tween;

	public function new(type:TweenManagerCommandType, object:Tween) {
		this.type = type;
		this.object = object;
	}
}

@:noCompletion enum abstract TweenManagerCommandType(Int) {
	var ADD;
	var REMOVE;
}