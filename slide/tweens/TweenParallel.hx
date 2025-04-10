package slide.tweens;

class TweenParallel extends TweenBase implements TweenObserver {

	final tweens:Array<Tween>;
	var activeTweens:Array<Tween> = [];
	var toRemove:Array<Tween> = [];

	public function new(tweens:Array<Tween>) {
		this.tweens = tweens;
		setObserverForTweens();
	}

	override final function start(startTime:Float = 0, overrideStartValues:Bool = true) {
		startInternal(startTime, overrideStartValues, false);
	}

	override final function startInternal(startTime:Float, overrideStartValues:Bool, reverse:Bool) {
		if (isStarted) return;

		if (tweens.length == 0) {
			trace("TweenParallel: No tweens in sequence. Ignoring start request.");
			return;
		}

		resetState();

		isStarted = true;

		isReverse = reverse;

		copyTweensToActive();
		startTweens(startTime, overrideStartValues, isReverse);

		observer?.onTweenStarted(this);

		callOnStart();
	}

	override function stop() {
		if (!isStarted) return;

		isStarted = false;
		isUpdating = false;

		observer?.onTweenStopped(this);

		for (a in tweens) {
			a.stop();
		}

		callOnStop();
	}

	override function complete() {
		if (isComplete) return;
		if (isStarted) stop();

		isComplete = true;

		for (t in activeTweens) {
			t.complete();
		}

		callOnComplete();
	}
	
	override function reset() {
		if (isPaused) resume();
		if (isStarted) stop();

		resetState();

		for (a in activeTweens) {
			a.reset();
		}
		
		callOnReset();
	}
	
	override function update(elapsed:Float):Float {
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
			a.startInternal(startTime, overrideStartValues, reverse);
		}
	}

	function copyTweensToActive() {
		if (tweens.length == activeTweens.length) return;
		
		for (i in 0...tweens.length) {
			activeTweens[i] = tweens[i];
		}
	}


	function setObserverForTweens() {
		for (t in tweens) {
			t.setObserver(this);
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

	function onTweenStarted(tween:Tween) {}
	function onTweenStopped(tween:Tween) {}

}