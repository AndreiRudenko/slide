package slide.tweens;

class TweenParallel extends TweenBase implements TweenGroup {

	var tweens:Array<Tween>;
	var activeTweens:Array<Tween> = [];
	var toRemove:Array<Tween> = [];
	var group:TweenGroup;

	public function new(tweens:Array<Tween>) {
		this.tweens = tweens;
	}

	final public function start(group:TweenGroup, startTime:Float = 0, overrideStartValues:Bool = true) {
		startInternal(group, startTime, overrideStartValues, false);
	}

	final function startInternal(group:TweenGroup, startTime:Float, overrideStartValues:Bool, reverse:Bool) {
		if (isStarted) return;
		
		if (group == null) {
			trace("TweenParallel: Group is null when starting tween. Ignoring start request.");
			return;
		}

		if (tweens.length == 0) {
			trace("TweenParallel: No tweens in sequence. Ignoring start request.");
			return;
		}

		resetState();

		isStarted = true;

		isReverse = reverse;

		copyTweensToActive();
		startTweens(startTime, overrideStartValues, isReverse);

		this.group = group;
		group.tweenStarted(this);

		callOnStart();
	}

	public function stop() {
		if (!isStarted) return;

		isStarted = false;
		isUpdating = false;

		group.tweenStopped(this);
		group = null;

		for (a in tweens) {
			a.stop();
		}

		callOnStop();
	}

	public function complete() {
		if (isComplete) return;
		if (isStarted) stop();

		isComplete = true;

		for (t in activeTweens) {
			t.complete();
		}

		callOnComplete();
	}
	
	public function reset() {
		if (isPaused) resume();
		if (isStarted) stop();

		resetState();

		for (a in activeTweens) {
			a.reset();
		}
		
		callOnReset();
	}
	
	public function update(elapsed:Float):Float {
		if (!isStarted || isPaused || elapsed <= 0) return 0;

		isUpdating = true;

		var isCompleteAll = true;
		var overflowTime = elapsed;
		var wasRepeat = false;
		var wasComplete = false;

		for (tween in activeTweens) {
			final currOverflow = tween.update(elapsed);
			if (tween.isComplete) {
				if (overflowTime > currOverflow) {
					overflowTime = currOverflow;
				}
				continue;
			}
			isCompleteAll = false;
		}

		while (isCompleteAll) {
			if (!canRepeat() || overflowTime == elapsed) { // In case of infinite repeat
				wasComplete = true;
				break;
			}

			repeatIndex++;
			if (isYoyo) isReverse = !isReverse;
			wasRepeat = true;

			startTweens(0, false, isReverse);

			final updateTime = overflowTime;

			for (tween in activeTweens) {
				final currOverflow = tween.update(updateTime);
				if (tween.isComplete) {
					if (overflowTime > currOverflow) {
						overflowTime = currOverflow;
					}
					continue;
				}
				isCompleteAll = false;
			}
		}

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

		removeCompletedTweens();

		isUpdating = false;
		return 0;
	}

	function removeCompletedTweens() {
		var i = 0;
		while (i < activeTweens.length) {
			if (activeTweens[i].isComplete) {
				activeTweens.splice(i, 1);
			} else {
				i++;
			}
		}
	}

	function startTweens(startTime:Float, overrideStartValues:Bool, reverse:Bool){
		for (a in activeTweens) {
			a.startInternal(this, startTime, overrideStartValues, reverse);
		}
	}

	function copyTweensToActive() {
		if (tweens.length == activeTweens.length) return;
		
		for (i in 0...tweens.length) {
			activeTweens[i] = tweens[i];
		}
	}

	function isAllTweensComplete() {
		for (a in activeTweens) {
			if (!a.isComplete) {
				return false;
			}
		}
		return true;
	}

	function resetState() {
		isStarted = false;
		isComplete = false;
		isUpdating = false;
		isReverse = false;

		repeatIndex = 0;
	}

	function tweenStarted(obj:Tween) {}
	function tweenStopped(obj:Tween) {}

}