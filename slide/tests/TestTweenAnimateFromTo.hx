package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenAnimateFromTo extends TestTweenAnimate {

	function createTween(value:Float = 100, duration:Float = 1):Tween {
		return tweenManager.animateFromTo(testObject, {x: 0}, {x: value}, duration);
	}

	function createTweenMultipleValues (x:Float = 100, y:Float = 200, duration:Float = 1):Tween {
		return tweenManager.animateFromTo(testObject, {x: 0, y: 0}, {x: x, y: y}, duration);
	}
		
}
