package slide.tweens;

abstract class TweenBase implements Tween {
	
	public var isStarted(default, null):Bool = false;
	public var isPaused(default, null):Bool = false;
	public var isComplete(default, null):Bool = false;
	public var isYoyo(default, null):Bool = false;
	
	public var repeatIndex(default, null):Int = 0;
	public var repeatCount(default, null):Int = 0;

	var reverseMotion:Bool = false;
	var isUpdating:Bool = false;
	var isReverse:Bool = false;

	var onUpdateCallback:Void->Void;
	var onRepeatCallback:Void->Void;
	var onCompleteCallback:Void->Void;
	var onStartCallback:Void->Void;
	var onStopCallback:Void->Void;
	var onResetCallback:Void->Void;
	var onPauseCallback:Void->Void;
	var onResumeCallback:Void->Void;

	abstract public function start(group:TweenGroup, startTime:Float = 0, overrideStartValues:Bool = true):Void;
	abstract function startInternal(group:TweenGroup, startTime:Float, overrideStartValues:Bool, flipReverse:Bool):Void;
	abstract public function stop():Void;
	abstract public function reset():Void;
	abstract public function complete():Void;
	abstract public function update(elapsed:Float):Float;

	public function pause() {
		isPaused = true;
		callOnPause();
	}

	public function resume() {
		isPaused = false;
		callOnResume();
	}

	final public function repeat(times:Int = -1):Tween {
		if (isStarted) throw('Cant change repeat count while tween is active.');
		repeatCount = times;
		return this;
	}

	final public function yoyo(v:Bool = true):Tween {
		if (isStarted) throw('Cant change yoyo while tween is active.');
		isYoyo = v;
		return this;
	}

	final public function onUpdate(fn:Void->Void):Tween {
		onUpdateCallback = fn;
		return this;
	}

	final public function onRepeat(fn:Void->Void):Tween {
		onRepeatCallback = fn;
		return this;
	}

	final public function onComplete(fn:Void->Void):Tween {
		onCompleteCallback = fn;
		return this;
	}

	final public function onStart(fn:Void->Void):Tween {
		onStartCallback = fn;
		return this;
	}

	final public function onStop(fn:Void->Void):Tween {
		onStopCallback = fn;
		return this;
	}

	final public function onPause(fn:Void->Void):Tween {
		onPauseCallback = fn;
		return this;
	}

	final public function onResume(fn:Void->Void):Tween {
		onResumeCallback = fn;
		return this;
	}

	final public function onReset(fn:Void->Void):Tween {
		onResetCallback = fn;
		return this;
	}

	inline function callOnUpdate() {
		if (onUpdateCallback != null) onUpdateCallback();
	}

	inline function callOnRepeat() {
		if (onRepeatCallback != null) onRepeatCallback();
	}

	inline function callOnComplete() {
		if (onCompleteCallback != null) onCompleteCallback();
	}

	inline function callOnStart() {
		if (onStartCallback != null) onStartCallback();
	}

	inline function callOnStop() {
		if (onStopCallback != null) onStopCallback();
	}

	inline function callOnPause() {
		if (onPauseCallback != null) onPauseCallback();
	}

	inline function callOnResume() {
		if (onResumeCallback != null) onResumeCallback();
	}

	inline function callOnReset() {
		if (onResetCallback != null) onResetCallback();
	}

	inline function isInfinityRepeat():Bool {
		return repeatCount < 0;
	}
	
	inline function canRepeat():Bool {
		return isInfinityRepeat() || repeatIndex < repeatCount;
	}

	inline function calculateReverseMotion(flipReverse:Bool):Bool {
		return flipReverse ? !isReverse : isReverse;
	}

}