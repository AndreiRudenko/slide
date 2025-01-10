package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenParallel extends TestTween {

	function createTween(value:Float = 100, duration:Float = 1):Tween {
		return tweenManager.parallel([
			tweenManager.animateTo(testObject, { x: value }, duration),
		]);
	}

	function createTweenMultipleValues (x:Float = 100, y:Float = 200, duration:Float = 1):Tween {
		return tweenManager.parallel([
			tweenManager.animateTo(testObject, { x: x }, duration),
			tweenManager.animateTo(testObject, { y: y }, duration),
		]);
	}
	
}
