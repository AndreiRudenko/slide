package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

private class TestObject {

	public var x:Float;
	public var y:Float;

	public function new() {
		x = 0;
		y = 0;
	}
}

class TestTweenManager extends TestCaseExt {

	var tweenManager:TweenManager;
	var testObject:TestObject;

    override function setup() {
		tweenManager = new TweenManager();
		testObject = new TestObject();
	}

	// region Lifecycle

	function testStopAllAnimateTweens() {
		tweenManager.animateTo(testObject, {x: 100}, 1).start();
		tweenManager.animateTo(testObject, {y: 100}, 1).start();

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		tweenManager.stopAll();
		tweenManager.update(1);
		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testStopAllSequenceTweens() {
		tweenManager.sequence([
			tweenManager.animateTo(testObject, {x: 100}, 1),
			tweenManager.animateTo(testObject, {y: 100}, 1)
		]).start();

		tweenManager.sequence([
			tweenManager.animateTo(testObject, {x: 200}, 1),
			tweenManager.animateTo(testObject, {y: 300}, 1)
		]).start();

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		tweenManager.stopAll();
		tweenManager.update(1);
		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testStopAllParallelTweens() {
		tweenManager.parallel([
			tweenManager.animateTo(testObject, {x: 100}, 1),
			tweenManager.animateTo(testObject, {y: 100}, 1)
		]).start();

		tweenManager.parallel([
			tweenManager.animateTo(testObject, {x: 200}, 1),
			tweenManager.animateTo(testObject, {y: 300}, 1)
		]).start();

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		tweenManager.stopAll();
		tweenManager.update(1);
		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testCompleteAllAnimateTweens() {
		tweenManager.animateTo(testObject, {x: 100}, 1).start();
		tweenManager.animateTo(testObject, {y: 100}, 1).start();

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		tweenManager.completeAll();
		tweenManager.update(1);
		assertEquals(0, @:privateAccess tweenManager.tweenList.length);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(100, testObject.y);
	}

	function testCompleteAllSequenceTweens() {
		tweenManager.sequence([
			tweenManager.animateTo(testObject, {x: 100}, 1),
			tweenManager.animateTo(testObject, {y: 200}, 1)
		]).start();

		var testObject2 = new TestObject();
		tweenManager.sequence([
			tweenManager.animateTo(testObject2, {x: 200}, 1),
			tweenManager.animateTo(testObject2, {y: 300}, 1)
		]).start();

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		tweenManager.completeAll();
		tweenManager.update(1);
		assertEquals(0, @:privateAccess tweenManager.tweenList.length);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertEqualsWithEpsilon(200, testObject2.x);
		assertEqualsWithEpsilon(300, testObject2.y);
	}

	function testCompleteAllParallelTweens() {
		tweenManager.parallel([
			tweenManager.animateTo(testObject, {x: 100}, 1),
			tweenManager.animateTo(testObject, {y: 200}, 1)
		]).start();

		var testObject2 = new TestObject();
		tweenManager.parallel([
			tweenManager.animateTo(testObject2, {x: 200}, 1),
			tweenManager.animateTo(testObject2, {y: 300}, 1)
		]).start();

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		tweenManager.completeAll();
		tweenManager.update(1);
		assertEquals(0, @:privateAccess tweenManager.tweenList.length);

		assertEqualsWithEpsilon(100, testObject.x);
		assertEqualsWithEpsilon(200, testObject.y);

		assertEqualsWithEpsilon(200, testObject2.x);
		assertEqualsWithEpsilon(300, testObject2.y);
	}

	function testStartStopMultipleTimes() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);
		tween.start();
		tween.stop();

		tween.start();
		tween.stop();

		assertEquals(0, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(1);

		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testStartOnUpdate() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);

		tween.onUpdate(() -> {
			var tween2 = tweenManager.animateTo(testObject, {y: 100}, 1);
			tween2.start();
		});

		tween.start();

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(0.25);

		assertEquals(2, @:privateAccess tweenManager.tweenList.length);
		
		tweenManager.update(0.25);
		assertEquals(3, @:privateAccess tweenManager.tweenList.length);

	}

	function testStopOnUpdate() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);

		tween.onUpdate(() -> {
			tween.stop();
		});

		tween.start();

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(0.5);

		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testCompleteOnUpdate() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);

		tween.onUpdate(() -> {
			tween.complete();
		});

		tween.start();

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(0.5);

		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testStopOnRepeat() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);
		tween.repeat(2);

		tween.onRepeat(() -> {
			tween.stop();
		});

		tween.start();

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(0.5);

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(1);

		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
	}

	function testCompleteOnRepeat() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);
		tween.repeat(2);

		tween.onRepeat(() -> {
			tween.complete();
		});

		tween.start();

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(0.5);

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(1);

		assertEquals(0, @:privateAccess tweenManager.tweenList.length);
		assertTrue(tween.isComplete);
	}

	function testStartStopOnUpdate() {
		var tween = tweenManager.animateTo(testObject, {x: 100}, 1);

		tween.onUpdate(() -> {
			var tween2 = tweenManager.animateTo(testObject, {y: 100}, 1);
			tween2.start();
			tween2.stop();
		});

		tween.start();

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);

		tweenManager.update(0.5);

		assertEquals(1, @:privateAccess tweenManager.tweenList.length);
	}


		
}
