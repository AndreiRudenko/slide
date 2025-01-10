package;

import TestCaseExt.Vector3;
import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

abstract class TestTween extends TestCaseExt {

	var tweenManager:TweenManager;
	var testObject:Vector3;

    override function setup() {
		tweenManager = new TweenManager();
		testObject = new Vector3();
	}

	abstract function createTween(value:Float = 100, duration:Float = 1):Tween;
	abstract function createTweenMultipleValues(x:Float = 100, y:Float = 200, duration:Float = 1):Tween;

	// region control

	function testStart() {
		var tween = createTween();

		assertTweenState(tween, getDefaultState());

		tween.start(tweenManager);

		assertTweenState(tween, getDefaultStateWith({started: true}));
	}

	function testStop() {
		var tween = createTween();

		tween.start(tweenManager);
		tween.stop();

		assertTweenState(tween, getDefaultState());
	}

	function testStartStopStart() {
		var tween = createTween();

		tween.start(tweenManager);
		tween.stop();
		tween.start(tweenManager);

		assertTweenState(tween, getDefaultStateWith({started: true}));
	}

	function testStartPaused() {
		var tween = createTween();

		tween.pause();
		tween.start(tweenManager);

		assertTweenState(tween, getDefaultStateWith({started: true, paused: true}));
	}

	function testPause() {
		var tween = createTween();

		tween.pause();

		assertTweenState(tween, getDefaultStateWith({paused: true}));
	}

	function testPauseReset() {
		var tween = createTween();

		tween.pause();
		tween.reset();

		assertTweenState(tween, getDefaultState());
	}

	function testResume() {
		var tween = createTween();

		tween.pause();
		tween.resume();

		assertTweenState(tween, getDefaultState());
	}

	function testUpdate() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);

		assertEqualsWithEpsilon(50, testObject.x);
	}

	function testUpdateWithNoDuration() {
		var tween = createTween(100, 0);

		tween.start(tweenManager);
		tween.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
	}

	function testUpdateWithNoDurationRepeat() {
		var tween = createTween(100, 0);
		tween.repeat(1);

		tween.start(tweenManager);
		tween.update(0.5);

		assertEqualsWithEpsilon(100, testObject.x);
		assertTweenState(tween, getDefaultStateWith({started: false, complete: true, repeatCount: 1}));
	}

	function testUpdateWithNoElapsed() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0);

		assertEqualsWithEpsilon(0, testObject.x);
	}

	function testUpdateStop() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);
		tween.stop();
		tween.update(0.5);

		assertEqualsWithEpsilon(50, testObject.x);
	}

	function testUpdatePause() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);
		tween.pause();
		tween.update(0.5);

		assertEqualsWithEpsilon(50, testObject.x);
	}

	function testUpdateResume() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.pause();
		tween.update(0.5);
		tween.resume();
		tween.update(0.5);

		assertEqualsWithEpsilon(50, testObject.x);
	}

	function testUpdateReset() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);

		assertEqualsWithEpsilon(50, testObject.x);

		tween.reset();

		assertTweenState(tween, getDefaultState());
		assertEqualsWithEpsilon(0, testObject.x);
	}

	function testUpdateResetPaused() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);
		tween.pause();
		tween.reset();

		assertTweenState(tween, getDefaultState());
		assertEqualsWithEpsilon(0, testObject.x);
	}

	function testUpdateIsComplete() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);

		assertTweenState(tween, getDefaultStateWith({started: true}));

		tween.update(0.5);

		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	function testUpdateComplete() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		tween.update(0.5);
		tween.complete();

		assertTweenState(tween, getDefaultStateWith({complete: true}));
		assertEqualsWithEpsilon(100, testObject.x);
	}

	// region callbacks

	function testOnStart() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onStart(() -> {called = true;});

		tween.start(tweenManager);

		assertTrue(called);
	}

	function testOnStop() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onStop(() -> {called = true;});

		tween.start(tweenManager);
		tween.stop();

		assertTrue(called);
	}

	function testOnPause() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onPause(() -> {called = true;});

		tween.pause();

		assertTrue(called);
	}

	function testOnResume() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onResume(() -> {called = true;});

		tween.pause();
		tween.resume();

		assertTrue(called);
	}

	function testOnUpdate() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onUpdate(() -> {called = true;});

		tween.start(tweenManager);
		tween.update(0.5);

		assertTrue(called);
	}

	function testOnRepeat() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onRepeat(() -> {called = true;});
		tween.repeat(1);

		tween.start(tweenManager);
		tween.update(1);

		assertTrue(called);
	}

	function testOnComplete() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onComplete(() -> {called = true;});

		tween.start(tweenManager);
		tween.update(1);

		assertTrue(called);
	}

	function testOnReset() {
		var tween = createTween(100, 1);
		var called = false;
		tween.onReset(() -> {called = true;});

		tween.start(tweenManager);
		tween.reset();

		assertTrue(called);
	}

	// region callback order

	function testOnStartOrder() {
		var order = [];

		function resetOrder() {
			order.splice(0, order.length);
		}

		function createTweenWithCallbacks() {
			var tween = createTween(100, 1);
			tween.onStart(function() {
				order.push("start");
			});
			tween.onStop(function() {
				order.push("stop");
			});
			tween.onPause(function() {
				order.push("pause");
			});
			tween.onResume(function() {
				order.push("resume");
			});
			tween.onComplete(function() {
				order.push("complete");
			});
			tween.onUpdate(function() {
				order.push("update");
			});
			tween.onReset(function() {
				order.push("reset");
			});
			tween.onRepeat(function() {
				order.push("repeat");
			});
			return tween;
		}

		resetOrder();
		var tween = createTweenWithCallbacks();
		tween.pause();
		tween.resume();
		assertEqualArrays(["pause", "resume"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.stop();
		assertEqualArrays(["start", "stop"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.reset();
		assertEqualArrays(["start", "stop", "reset"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.complete();
		assertEqualArrays(["start", "stop", "complete"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.update(0.5);
		tween.stop();
		assertEqualArrays(["start", "update", "stop"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.update(0.5);
		tween.reset();
		assertEqualArrays(["start", "update", "stop", "reset"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.update(1);
		assertEqualArrays(["start", "update", "stop", "complete"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.start(tweenManager);
		tween.update(1);
		tween.reset();
		assertEqualArrays(["start", "update", "stop", "complete", "reset"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.repeat(1);
		tween.start(tweenManager);
		tween.update(1);
		assertEqualArrays(["start", "update", "repeat"], order);

		resetOrder();
		tween = createTweenWithCallbacks();
		tween.repeat(1);
		tween.start(tweenManager);
		tween.update(1);
		tween.update(1);
		assertEqualArrays(["start", "update", "repeat", "update", "stop", "complete"], order);
	}

	// region state change on callback
	// some silly tests in case someone wants to do something like this

	// onStart

	function testStopOnStart() {
		var tween = createTween();
		tween.onStart(() -> {tween.stop();});

		tween.start(tweenManager);
		assertTweenState(tween, getDefaultState());
	}
	
	function testPauseOnStart() {
		var tween = createTween();
		tween.onStart(() -> {tween.pause();});

		tween.start(tweenManager);

		assertTweenState(tween, getDefaultStateWith({started: true, paused: true}));
	}

	function testResumeOnStart() {
		var tween = createTween();
		tween.onStart(() -> {tween.resume();});

		tween.pause();
		tween.start(tweenManager);
		
		assertTweenState(tween, getDefaultStateWith({started:true}));
	}

	function testResetOnStart() {
		var tween = createTween();
		tween.onStart(() -> {tween.reset();});

		tween.start(tweenManager);
		
		assertTweenState(tween, getDefaultState());
	}

	function testCompleteOnStart() {
		var tween = createTween();
		tween.onStart(() -> {tween.complete();});

		tween.start(tweenManager);

		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	// onStop

	function testStartOnStop() {
		var tween = createTween();
		tween.onStop(() -> {tween.start(tweenManager);});

		tween.start(tweenManager);
		tween.stop();

		assertTweenState(tween, getDefaultStateWith({started: true}));
	}

	function testPauseOnStop() {
		var tween = createTween();
		tween.onStop(() -> {tween.pause();});

		tween.start(tweenManager);
		tween.stop();
		
		assertTweenState(tween, getDefaultStateWith({paused: true}));
	}

	function testResumeOnStop() {
		var tween = createTween();
		tween.onStop(() -> {tween.resume();});

		tween.pause();
		tween.start(tweenManager);
		tween.stop();

		assertTweenState(tween, getDefaultState());
	}

	function testResetOnStop() {
		var tween = createTween();
		tween.onStop(() -> {tween.reset();});

		tween.start(tweenManager);
		tween.stop();
		assertFalse(tween.isStarted);
	}

	function testCompleteOnStop() {
		var tween = createTween();
		tween.onStop(() -> {tween.complete();});

		tween.start(tweenManager);
		tween.stop();

		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	// onPause

	function testStartOnPause() {
		var tween = createTween();
		tween.onPause(() -> {tween.start(tweenManager);});

		tween.pause();

		assertTweenState(tween, getDefaultStateWith({started: true, paused: true}));
	}

	function testStopOnPause() {
		var tween = createTween();
		tween.onPause(() -> {tween.stop();});

		tween.start(tweenManager);
		tween.pause();

		assertTweenState(tween, getDefaultStateWith({paused: true}));
	}

	function testResumeOnPause() {
		var tween = createTween();
		tween.onPause(() -> {tween.resume();});

		tween.pause();
		tween.start(tweenManager);

		assertTweenState(tween, getDefaultStateWith({started: true}));
	}

	function testResetOnPause() {
		var tween = createTween();
		tween.onPause(() -> {tween.reset();});

		tween.start(tweenManager);
		tween.pause();

		assertTweenState(tween, getDefaultState());
	}

	function testCompleteOnPause() {
		var tween = createTween();
		tween.onPause(() -> {tween.complete();});

		tween.start(tweenManager);
		tween.pause();

		assertTweenState(tween, getDefaultStateWith({complete: true, paused: true}));
	}

	// onResume

	function testStartOnResume() {
		var tween = createTween();
		tween.onResume(() -> {tween.start(tweenManager);});

		tween.pause();
		tween.resume();

		assertTweenState(tween, getDefaultStateWith({started: true}));
	}

	function testStopOnResume() {
		var tween = createTween();
		tween.onResume(() -> {tween.stop();});

		tween.pause();
		tween.start(tweenManager);
		tween.resume();

		assertTweenState(tween, getDefaultState());
	}

	function testPauseOnResume() {
		var tween = createTween();
		tween.onResume(() -> {tween.pause();});

		tween.pause();
		tween.start(tweenManager);
		tween.resume();
		assertTrue(tween.isPaused);
	}

	function testResetOnResume() {
		var tween = createTween();
		tween.onResume(() -> {tween.reset();});

		tween.pause();
		tween.start(tweenManager);
		tween.resume();

		assertTweenState(tween, getDefaultState());
	}

	function testCompleteOnResume() {
		var tween = createTween();
		tween.onResume(() -> {tween.complete();});

		tween.pause();
		tween.start(tweenManager);
		tween.resume();

		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	// onReset

	function testStartOnReset() {
		var tween = createTween();
		tween.onReset(() -> {tween.start(tweenManager);});

		tween.start(tweenManager);
		tween.reset();

		assertTweenState(tween, getDefaultStateWith({started: true}));
	}

	function testStopOnReset() {
		var tween = createTween();
		tween.onReset(() -> {tween.stop();});

		tween.start(tweenManager);
		tween.reset();

		assertTweenState(tween, getDefaultState());
	}

	function testPauseOnReset() {
		var tween = createTween();
		tween.onReset(() -> {tween.pause();});

		tween.start(tweenManager);
		tween.reset();
		
		assertTweenState(tween, getDefaultStateWith({paused: true}));
	}

	function testResumeOnReset() {
		var tween = createTween();
		tween.onReset(() -> {tween.resume();});

		tween.pause();
		tween.start(tweenManager);
		tween.reset();
		
		assertTweenState(tween, getDefaultState());
	}

	function testCompleteOnReset() {
		var tween = createTween();
		tween.onReset(() -> {tween.complete();});

		tween.start(tweenManager);
		tween.reset();
		
		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	// onComplete

	function testStartOnComplete() {
		var tween = createTween(100, 1);
		tween.onComplete(() -> {tween.start(tweenManager);});

		tween.start(tweenManager);
		tween.update(1);
		
		assertTweenState(tween, getDefaultStateWith({started: true}));
	}
	
	function testPauseOnComplete() {
		var tween = createTween(100, 1);
		tween.onComplete(() -> {tween.pause();});

		tween.start(tweenManager);
		tween.update(1);
		
		assertTweenState(tween, getDefaultStateWith({paused: true, complete: true}));
	}

	function testResumeOnComplete() {
		var tween = createTween(100, 1);
		tween.onComplete(() -> {tween.resume();});

		tween.start(tweenManager);
		tween.update(1);
		
		assertTweenState(tween, getDefaultStateWith({complete: true}));
	}

	function testResetOnComplete() {
		var tween = createTween(100, 1);
		tween.onComplete(() -> {tween.reset();});

		tween.start(tweenManager);
		tween.update(1);
		
		assertTweenState(tween, getDefaultState());
	}

	// region overflow time

	function testOverflowTime() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		var overflow = tween.update(1.1);

		assertEqualsWithEpsilon(0.1, overflow);
	}

	function testOverflowTimeWithNoDuration() {
		var tween = createTween(100, 0);

		tween.start(tweenManager);
		var overflow = tween.update(1.1);

		assertEqualsWithEpsilon(1.1, overflow);
	}

	function testOverflowTimeWithNoElapsed() {
		var tween = createTween(100, 1);

		tween.start(tweenManager);
		var overflow = tween.update(0);

		assertEqualsWithEpsilon(0, overflow);
	}

	function testOverflowTimeRepeat() {
		var tween = createTween(100, 1);
		tween.repeat(1);

		tween.start(tweenManager);
		var overflow = tween.update(2.1);

		assertEqualsWithEpsilon(0.1, overflow);
	}

}
