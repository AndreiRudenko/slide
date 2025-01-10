package slide.tweens;

class TweenEmpty extends TweenBase {

	var group:TweenGroup;
	
	var time:Float = 0;
	var duration:Float;

	var easing:Float->Float;

	public function new(duration:Float, ?easing:Float->Float) {
		this.duration = duration;
		this.easing = easing;
		if (easing == null) this.easing = slide.easing.Linear.none;
	}
	
	final public function start(group:TweenGroup, startTime:Float = 0, overrideStartValues:Bool = true) {
		startInternal(group, startTime, overrideStartValues, false);
	}

	final function startInternal(group:TweenGroup, startTime:Float, overrideStartValues:Bool, reverse:Bool) {
		if (isStarted) return;

		if (group == null) {
			trace("Tween: Group is null when starting tween. Ignoring start request.");
			return;
		}

		if (isInfinityRepeat() && duration <= 0) {
			trace("Tween has infinite repeat and duration of 0, ignoring start call");
			return;
		}

		if (overrideStartValues) {
			buildStartValues();
		}
		
		resetState();

		isStarted = true;
		isReverse = reverse;
		time = startTime;

		this.group = group;
		group.tweenStarted(this);

		callOnStart();
	}

	final public function stop() {
		if (!isStarted) return;

		isStarted = false;
		isUpdating = false;

		group.tweenStopped(this);
		group = null;

		callOnStop();
	}

	final public function complete() {
		if (isComplete) return;
		if (isStarted) stop();

		isComplete = true;
		time = duration;

		positionChanged(getEndPosition());
		callOnComplete();
	}

	public function reset() {
		if (isPaused) resume();
		if (isStarted) stop();

		resetState();

		positionChanged(getStartPosition());
		callOnReset();
	}

	public function update(elapsed:Float):Float {
		if (!isStarted || isPaused || elapsed <= 0) return 0;

		isUpdating = true;
		time += elapsed;

		var overflowTime = 0.0;
		var wasRepeat = false;
		var wasComplete = false;
		var progress = 0.0;

		while (time >= duration) {
			progress = getPositionFrom(time);

			if (!canRepeat() || duration <= 0) {
				overflowTime = time - duration;
				wasComplete = true;
				break;
			}

			if (isYoyo) {
				isReverse = !isReverse;
			}

			time -= duration;
			repeatIndex++;
			wasRepeat = true;
		}

		if (time > 0) {
			progress = getPositionFrom(time);
		}

		positionChanged(easing(progress));
		callOnUpdate();
		if (!isUpdating) return 0;

		if (wasRepeat) {
			callOnRepeat();
			if (!isUpdating) return 0;
		}

		if (wasComplete) {
			complete();
			return overflowTime;
		}

		isUpdating = false;
		return 0;
	}

	final function getPositionFrom(t:Float):Float {
		if (duration <= 0) return isReverse ? 1 : 0;
		return clamp((isReverse ? duration - t : t) / duration, 0, 1);
	}

	final function getStartPosition():Float {
		return isReverse ? 1 : 0;
	}

	final function getEndPosition():Float {
		return isReverse ? 0 : 1;
	}

	final function clamp(v:Float, min:Float, max:Float):Float {
		return Math.min(max, Math.max(min, v));
	}

	function resetState() {
		isStarted = false;
		isComplete = false;
		isUpdating = false;
		isReverse = false;

		time = 0;
		repeatIndex = 0;
	}

	function buildStartValues() {}
	function positionChanged(position:Float) {}

}