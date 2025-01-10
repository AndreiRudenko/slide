package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenAnimateAlong extends TestTweenAnimate {

	function createTween(value:Float = 100, duration:Float = 1):Tween {
		return tweenManager.animateAlong(testObject, {x: [0, value]}, duration);
	}

	function createTweenMultipleValues (x:Float = 100, y:Float = 200, duration:Float = 1):Tween {
		return tweenManager.animateAlong(testObject, {x: [0, x], y: [0, y]}, duration);
	}

	function testStartSingleValueWithTime() {
		var tween = tweenManager.animateAlong(testObject, {x: [100]}, 1);

		tween.start(tweenManager, 0.5);
		tween.update(0.1);
		assertEqualsWithEpsilon(100, testObject.x);
	}

	function testStartThreeValuesWithTime() {
		var tween = tweenManager.animateAlong(testObject, {x: [0, 50, 100]}, 1);

		tween.start(tweenManager, 0.5);
		tween.update(0.1);
		assertEqualsWithEpsilon(60, testObject.x);
	}
	
	function testStartMultipleSingleValueWithTime() {
		var tween = tweenManager.animateAlong(testObject, {x: [100], y: [200]}, 1);

		tween.start(tweenManager, 0.5);
		tween.update(0.1);
		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testStartMultipleThreeValuesWithTime() {
		var tween = tweenManager.animateAlong(testObject, {x: [0, 50, 100], y: [0, 100, 200]}, 1);

		tween.start(tweenManager, 0.5);
		tween.update(0.1);
		assertEqualsWithEpsilon(60, testObject.x);
		assertEqualsWithEpsilon(120, testObject.y);
	}

}
