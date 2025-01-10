package;

import TestCaseExt.Vector3;
import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

abstract class TestTweenAnimate extends TestCaseExt {

	var tweenManager:TweenManager;
	var testObject:Vector3;

    override function setup() {
		tweenManager = new TweenManager();
		testObject = new Vector3();
	}

	abstract function createTween(value:Float = 100, duration:Float = 1):Tween;
	abstract function createTweenMultipleValues(x:Float = 100, y:Float = 200, duration:Float = 1):Tween;

	// region start single value

	function testStartWithTime() {
		var tween = createTween(100, 1);

		tween.start(0.5);
		tween.update(0.1);
		assertEqualsWithEpsilon(60, testObject.x);
	}

	function testStartWithNoOverrideStartValues() {
		var tween = createTween(100, 1);
		testObject.x = 50;

		tween.start(0, false);
		tween.update(0.1);
		assertEqualsWithEpsilon(10, testObject.x);
	}
	
	// region start multiple values

	function testMultipleValuesStartWithTime() {
		var tween1 = createTweenMultipleValues(100, 200, 1);

		tween1.start(0.5);
		tween1.update(0.1);
		assertEqualsWithEpsilon(60, testObject.x);
		assertEqualsWithEpsilon(120, testObject.y);
	}

	function testMultipleValuesStartWithNoOverrideStartValues() {
		var tween1 = createTweenMultipleValues(100, 200, 1);
		testObject.x = 50;
		testObject.y = 100;

		tween1.start(0, false);
		tween1.update(0.1);
		assertEqualsWithEpsilon(10, testObject.x);
		assertEqualsWithEpsilon(20, testObject.y);
	}

	// region animateTo single value

	function testAnimateTo() {
		var tween = createTween(100, 1);

		tween.start(0);
		tween.update(0.1);
		assertEqualsWithEpsilon(10, testObject.x);
	}

	function testAnimateToNegativeValue() {
		var tween = tweenManager.animateTo(testObject, {x: -100}, 1);

		tween.start(0);
		tween.update(0.1);
		assertEqualsWithEpsilon(-10, testObject.x);
	}

	function testAnimateToRepeat() {
		var tween = createTween(100, 1);
		tween.repeat(1);

		tween.start();
		tween.update(1.1);
		assertEqualsWithEpsilon(10, testObject.x);
	}

	function testAnimateToRepeatYoyo() {
		var tween = createTween(100, 1);
		tween.repeat(1);
		tween.yoyo();

		tween.start();
		tween.update(1.1);
		assertEqualsWithEpsilon(90, testObject.x);
	}

	// region animateTo multiple values

	function testMultipleValuesAnimateTo() {
		var tween1 = createTweenMultipleValues(100, 200, 1);

		tween1.start();
		tween1.update(0.1);
		assertEqualsWithEpsilon(10, testObject.x);
		assertEqualsWithEpsilon(20, testObject.y);
	}

	function testMultipleValuesAnimateToNegativeValue() {
		var tween1 = tweenManager.animateTo(testObject, {x: -100, y: -200}, 1);

		tween1.start();
		tween1.update(0.1);
		assertEqualsWithEpsilon(-10, testObject.x);
		assertEqualsWithEpsilon(-20, testObject.y);
	}

	function testMultipleValuesAnimateToRepeat() {
		var tween1 = createTweenMultipleValues(100, 200, 1);
		tween1.repeat(1);

		tween1.start();
		tween1.update(1.1);
		assertEqualsWithEpsilon(10, testObject.x);
		assertEqualsWithEpsilon(20, testObject.y);
		tween1.update(0.5);
		assertEqualsWithEpsilon(60, testObject.x);
		assertEqualsWithEpsilon(120, testObject.y);
	}

	function testMultipleValuesAnimateToRepeatYoyo() {
		var tween1 = createTweenMultipleValues(100, 200, 1);
		tween1.repeat(1);
		tween1.yoyo();

		tween1.start();
		tween1.update(1.1);
		assertEqualsWithEpsilon(90, testObject.x);
		assertEqualsWithEpsilon(180, testObject.y);
		tween1.update(0.5);
		assertEqualsWithEpsilon(40, testObject.x);
		assertEqualsWithEpsilon(80, testObject.y);
	}

	// region animateTo easing
	
	var easing = slide.easing.Quad.easeIn;

	function getEasingValue(time:Float, value:Float):Float {
		return easing(time) * value;
	}

	function testAnimateToEasing() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1, easing);

		tween.start();
		tween.update(0.4);
		assertEqualsWithEpsilon(getEasingValue(0.4, 100), testObject.x);
	}

	function testAnimateToEasingRepeat() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1, easing);
		tween.repeat(1);

		tween.start();
		tween.update(1.4);
		assertEqualsWithEpsilon(getEasingValue(0.4, 100), testObject.x);
	}

	function testAnimateToEasingRepeatYoyo() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1, easing);
		tween.repeat(1);
		tween.yoyo();

		tween.start();
		tween.update(1.4);
		assertEqualsWithEpsilon(getEasingValue(0.6, 100), testObject.x);
	}

	// region animateTo multiple values easing

	function testMultipleValuesAnimateToEasing() {
		var tween1 = tweenManager.animateTo(testObject, {x: 100, y: 200}, 1, easing);

		tween1.start();
		tween1.update(0.4);
		assertEqualsWithEpsilon(getEasingValue(0.4, 100), testObject.x);
		assertEqualsWithEpsilon(getEasingValue(0.4, 200), testObject.y);
	}

	function testMultipleValuesAnimateToEasingRepeat() {
		var tween1 = tweenManager.animateTo(testObject, {x: 100, y: 200}, 1, easing);
		tween1.repeat(1);

		tween1.start();
		tween1.update(1.4);
		assertEqualsWithEpsilon(getEasingValue(0.4, 100), testObject.x);
		assertEqualsWithEpsilon(getEasingValue(0.4, 200), testObject.y);
	}

	function testMultipleValuesAnimateToEasingRepeatYoyo() {
		var tween1 = tweenManager.animateTo(testObject, {x: 100, y: 200}, 1, easing);
		tween1.repeat(1);
		tween1.yoyo();

		tween1.start();
		tween1.update(1.4);
		assertEqualsWithEpsilon(getEasingValue(0.6, 100), testObject.x);
		assertEqualsWithEpsilon(getEasingValue(0.6, 200), testObject.y);
	}

}
