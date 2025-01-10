package slide;

import slide.tweens.TweenGroup;

interface Tween {
	var isStarted(default, null):Bool;
	var isComplete(default, null):Bool;
	var isPaused(default, null):Bool;
	var isYoyo(default, null):Bool;
	
	var repeatCount(default, null):Int;
	var repeatIndex(default, null):Int;

	function start(group:TweenGroup, startTime:Float = 0, overrideStartValues:Bool = true):Void;
	private function startInternal(group:TweenGroup, startTime:Float, overrideStartValues:Bool, flipReverse:Bool):Void;
	function stop():Void;
	function complete():Void;
	function reset():Void;
	function pause():Void;
	function resume():Void;

	function update(elapsed:Float):Float;

	function repeat(times:Int = -1):Tween;
	function yoyo(v:Bool = true):Tween;

	function onRepeat(fn:Void->Void):Tween;
	function onComplete(fn:Void->Void):Tween;
	function onUpdate(fn:Void->Void):Tween;
	function onStart(fn:Void->Void):Tween;
	function onStop(fn:Void->Void):Tween;
	function onReset(fn:Void->Void):Tween;
	function onPause(fn:Void->Void):Tween;
	function onResume(fn:Void->Void):Tween;
}
