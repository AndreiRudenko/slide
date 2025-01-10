package;

import TestCaseExt.Vector3;
import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenAnimateParallel extends TestTweenAnimate {

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

	// region parallel in parallel

	function testParallelInParallel() {
		final tween = tweenManager.parallel([
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 100 }, 1.0),
				tweenManager.animateTo(testObject, { y: 200 }, 1.0),
			])
		]);

		tween.start();

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(50, testObject.x);
		assertEqualsWithEpsilon(100, testObject.y);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testParallelInParallelZeroDuration() {
		final tween = tweenManager.parallel([
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 100 }, 0.0),
				tweenManager.animateTo(testObject, { y: 200 }, 0.0),
			])
		]);

		tween.start();

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testParallelInParallelOneZeroDuration() {
		final tween = tweenManager.parallel([
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			]),
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { y: 200 }, 1),
			])
		]);

		tween.start();

		tweenManager.update(0.1);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(20, testObject.y);
	}

	function testParallelInParallelZeroDurationRepeated() {
		final tween = tweenManager.parallel([
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 100 }, 0.0),
				tweenManager.animateTo(testObject, { y: 200 }, 0.0),
			])
		]);

		tween.repeat(-1);
		tween.start();

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertEquals(0, tween.repeatIndex);
	}

	function testParallelInParallelOnrZeroDurationRepeated() {
		final tween = tweenManager.parallel([
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			]),
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { y: 200 }, 0.1),
			])
		]);

		tween.repeat(-1);
		tween.start();

		tweenManager.update(0.2);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertEquals(2, tween.repeatIndex);
	}
	

	function testParallelInParallelDuration() {
		final tween = tweenManager.parallel([
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 100 }, 1.0),
				tweenManager.animateTo(testObject, { y: 200 }, 0.6),
			])
		]);

		tween.start();

		tweenManager.update(0.6);
		assertTweenState(tween, getDefaultStateWith({started: true}));

		tweenManager.update(0.4);
		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	// region sequence in parallel

	function testSequenceInParallel() {
		final tween = tweenManager.parallel([
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { x: 100 }, 0.4),
				tweenManager.animateTo(testObject, { y: 200 }, 0.6),
			])
		]);

		tween.start();

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200/6, testObject.y);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testSequenceInParallelZeroDuration() {
		final tween = tweenManager.parallel([
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { x: 100 }, 0.0),
				tweenManager.animateTo(testObject, { y: 200 }, 0.0),
			])
		]);

		tween.start();

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testSequenceInParallelOneZeroDuration() {
		final tween = tweenManager.parallel([
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			]),
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { y: 200 }, 1),
			])
		]);

		tween.start();

		tweenManager.update(0.1);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(20, testObject.y);
	}
	
}
