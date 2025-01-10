package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenAnimateBy extends TestTweenAnimate {

	function createTween(value:Float = 100, duration:Float = 1):Tween {
		return tweenManager.animateBy(testObject, {x: value}, duration);
	}

	function createTweenMultipleValues (x:Float = 100, y:Float = 200, duration:Float = 1):Tween {
		return tweenManager.animateBy(testObject, {x: x, y: y}, duration);
	}
	
}