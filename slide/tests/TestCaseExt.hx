package;

import haxe.unit.TestCase;
import slide.Tween;

typedef TweenState = {
	?started:Bool,
	?complete:Bool,
	?paused:Bool,
	?reverse:Bool,
	?yoyo:Bool,
	?repeatCount:Int,
	?repeatIndex:Int
}

class Vector3 {
	public var x:Float;
	public var y:Float;
	public var z:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}

class TestCaseExt extends TestCase {

	function getDefaultState():TweenState {
		return {
			started: false,
			complete: false,
			paused: false,
			// reverse: false,
			yoyo: false,
			repeatCount: 0,
			repeatIndex: 0
		};
	}

	function getDefaultStateWith(tweenState:TweenState):TweenState {
		final resultState = getDefaultState();

		for (k in Reflect.fields(tweenState)) {
			if (!Reflect.hasField(resultState, k)) {
				throw "Invalid field: " + k;
			}

			Reflect.setField(resultState, k, Reflect.field(tweenState, k));
		}
		return resultState;
	}
	
	function getTweenState(tween:Tween):TweenState {
		return {
			started: tween.isStarted,
			complete: tween.isComplete,
			paused: tween.isPaused,
			// reverse: tween.isReverse,
			yoyo: tween.isYoyo,
			repeatCount: tween.repeatCount,
			repeatIndex: tween.repeatIndex
		};
	}

	function assertTweenState(tween:Tween, expected:TweenState, ?c : haxe.PosInfos) : Void {
		currentTest.done = true;
		var actual = getTweenState(tween);
		for (k in Reflect.fields(expected)) {
			if (Reflect.field(expected, k) != Reflect.field(actual, k)) {
				currentTest.success = false;
				currentTest.error = "expected '" + k + "' to be '" + Reflect.field(expected, k) + "' but was '" + Reflect.field(actual, k) + "'";
				currentTest.posInfos = c;
				throw currentTest;
			}
		}
	}
	
	function assertEqualsWithEpsilon(expected:Float , actual:Float, epsilon:Float = 0.0001,  ?c : haxe.PosInfos ) : Void {
		currentTest.done = true;
		if (Math.abs(expected - actual) > epsilon) {
			currentTest.success = false;
			currentTest.error   = "expected '" + expected + "' but was '" + actual + "'";
			currentTest.posInfos = c;
			throw currentTest;
		}
	}

	function throwAssertError(message:String, ?c : haxe.PosInfos) : Void {
		currentTest.done = true;
		currentTest.success = false;
		currentTest.error = message;
		currentTest.posInfos = c;
		throw currentTest;
	}

	function assertExistInArray<T>(expected:Array<T>, actual:Array<T>, ?c : haxe.PosInfos) : Void {
		currentTest.done = true;
		for (e in expected) {
			if (actual.indexOf(e) == -1) {
				currentTest.success = false;
				currentTest.error = "expected '" + e + "' but was not found";
				currentTest.posInfos = c;
				throw currentTest;
			}
		}
	}

	function assertEqualArrays<T>(expected:Array<T>, actual:Array<T>, ?c : haxe.PosInfos) : Void {
		currentTest.done = true;
		if (expected.length != actual.length) {
			currentTest.success = false;
			currentTest.error = "expected array length '" + expected.length + "' but was '" + actual.length + "'";
			currentTest.posInfos = c;
			throw currentTest;
		}
		for (i in 0...expected.length) {
			if (expected[i] != actual[i]) {
				currentTest.success = false;
				currentTest.error = "expected '" + expected[i] + "' but was '" + actual[i] + "'";
				currentTest.posInfos = c;
				throw currentTest;
			}
		}
	}

	function assertEqualArraysEpsilon(expected:Array<Float>, actual:Array<Float>, epsilon:Float = 0.0001, ?c : haxe.PosInfos) : Void {
		currentTest.done = true;
		if (expected.length != actual.length) {
			currentTest.success = false;
			currentTest.error = "expected array length '" + expected.length + "' but was '" + actual.length + "'";
			currentTest.posInfos = c;
			throw currentTest;
		}
		for (i in 0...expected.length) {
			if (Math.abs(expected[i] - actual[i]) > epsilon) {
				currentTest.success = false;
				currentTest.error = "expected '" + expected[i] + "' but was '" + actual[i] + "'";
				currentTest.posInfos = c;
				throw currentTest;
			}
		}
	}

}
