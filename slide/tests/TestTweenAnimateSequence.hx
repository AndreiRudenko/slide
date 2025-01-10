package;

import TestCaseExt.Vector3;
import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenAnimateSequence extends TestTweenAnimate {

	function createTween(value:Float = 100, duration:Float = 1):Tween {
		final ratio = 0.4;
		final ratio2 = 0.6;
		return tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: value*ratio }, duration*ratio),
			tweenManager.animateTo(testObject, { x: value }, duration*ratio2)
		]);
	}

	function createTweenMultipleValues (x:Float = 100, y:Float = 200, duration:Float = 1):Tween {
		final ratio = 0.4;
		final ratio2 = 0.6;
		return tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: x*ratio, y: y*ratio }, duration*ratio),
			tweenManager.animateTo(testObject, { x: x, y: y }, duration*ratio2)
		]);
	}

	// function testEmptySequence() {
	// 	final tween = tweenManager.sequence([]);
	// 	tween.start(tweenManager);
	// 	tweenManager.update(0.5);
	// 	assertTweenState(tween, getDefaultState());
	// }

	// region sequence in sequence

	function testSequenceInSequence() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.4),
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { y: 200 }, 0.6),
				tweenManager.animateTo(testObject, { x: 0 }, 1)
			])
		]);

		tween.start(tweenManager);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200/6, testObject.y);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		tweenManager.update(1);

		assertEqualsWithEpsilon(0, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testSequenceInSequenceZeroDuration() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { y: 200 }, 0),
				tweenManager.animateTo(testObject, { x: 0 }, 0)
			])
		]);

		tween.start(tweenManager);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(0, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testSequenceInSequenceZeroDurationRepeat() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { y: 200 }, 0),
				tweenManager.animateTo(testObject, { x: 0 }, 0)
			])
		]);

		tween.repeat(-1);
		tween.start(tweenManager);

		tweenManager.update(0.6);

		assertEqualsWithEpsilon(0, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertEquals(0, tween.repeatIndex);
	}

	function testSequenceInSequenceDuration() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.4),
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { y: 200 }, 0.6),
				tweenManager.animateTo(testObject, { x: 0 }, 1)
			])
		]);

		tween.start(tweenManager);

		tweenManager.update(2);
		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}
	
	function testSequenceInSequenceDurationMultipleUpdate() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.4),
			tweenManager.sequence([
				tweenManager.animateTo(testObject, { y: 200 }, 0.6),
				tweenManager.animateTo(testObject, { x: 0 }, 1)
			])
		]);

		tween.start(tweenManager);

		tweenManager.update(1);
		assertTweenState(tween, getDefaultStateWith({started: true}));

		tweenManager.update(1);
		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	// region parallel in sequence

	function testParallelInSequence() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.5),
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 0 }, 0.5),
				tweenManager.animateTo(testObject, { y: 200 }, 0.25)
			])
		]);

		tween.start(tweenManager);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(0, testObject.y);

		tweenManager.update(0.25);

		assertEqualsWithEpsilon(50, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		tweenManager.update(0.25);

		assertEqualsWithEpsilon(0, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	function testParallelInSequenceZeroDuration() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 0 }, 0),
				tweenManager.animateTo(testObject, { y: 200 }, 0)
			])
		]);

		tween.start(tweenManager);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(0, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);
	}

	function testParallelInSequenceZeroDurationRepeat() {
		final tween = tweenManager.sequence([
			tweenManager.animateTo(testObject, { x: 100 }, 0.0),
			tweenManager.parallel([
				tweenManager.animateTo(testObject, { x: 0 }, 0),
				tweenManager.animateTo(testObject, { y: 200 }, 0)
			])
		]);

		tween.repeat(-1);
		tween.start(tweenManager);

		tweenManager.update(0.5);

		assertEqualsWithEpsilon(0, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertEquals(0, tween.repeatIndex);
	}
}
