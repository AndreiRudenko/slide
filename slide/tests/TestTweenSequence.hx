package;

import haxe.unit.TestCase;
import slide.TweenManager;
import slide.Tween;

class TestTweenSequence extends TestTween {

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
	
}
