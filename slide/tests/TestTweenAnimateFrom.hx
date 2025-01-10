package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenAnimateFrom extends TestTweenAnimate {

	function createTween(value:Float = 100, duration:Float = 1):Tween {
		testObject.x = value;
		return tweenManager.animateFrom(testObject, {x: 0}, duration);
	}

	function createTweenMultipleValues (x:Float = 100, y:Float = 200, duration:Float = 1):Tween {
		testObject.x = x;
		testObject.y = y;
		return tweenManager.animateFrom(testObject, {x: 0, y: 0}, duration);
	}
	
}
