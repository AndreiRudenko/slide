package slide.tweens;

class TweenSequence extends TweenBase implements TweenGroup {

	var tweens:Array<Tween>;

	var currentTweenIndex:Int = 0;
	var currentTween:Tween;
	var group:TweenGroup;

	var overrideStartValues:Bool = true;

	public function new(tweens:Array<Tween>) {
		this.tweens = tweens;
	}

	final public function start(group:TweenGroup, startTime:Float = 0, overrideStartValues:Bool = true) {
		startInternal(group, startTime, overrideStartValues, false);
	}

	final function startInternal(group:TweenGroup, startTime:Float, overrideStartValues:Bool, reverse:Bool) {
		if (isStarted) return;

		if (group == null) {
			trace("TweenSequence: Group is null when starting tween. Ignoring start request.");
			return;
		}

		if (tweens.length == 0) {
			trace("TweenSequence: No tweens in sequence. Ignoring start request.");
			return;
		}
		
		resetState();

		isStarted = true;

		this.overrideStartValues = overrideStartValues;

		isReverse = reverse;

		currentTweenIndex = getStartTweenIndex();
		currentTween = getTween(currentTweenIndex);

		currentTween.startInternal(this, startTime, overrideStartValues, isReverse);

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

		for (t in tweens) {
			t.stop();
		}

		callOnStop();
	}

	public function complete() {
		if (isComplete) return;
		if (isStarted) stop();

		isComplete = true;

		for (t in tweens) {
			t.complete();
		}

		currentTweenIndex = getEndTweenIndex();
		currentTween = getTween(currentTweenIndex);

		callOnComplete();
	}

	public function reset() {
		if (isPaused) resume();
		if (isStarted) stop();

		resetState();

		currentTweenIndex = getStartTweenIndex();
		currentTween = getTween(currentTweenIndex);

		var i = tweens.length - 1;
		while (i >= 0) {
			getTween(i).reset();
			i--;
		}

		callOnReset();
	}
	
	public function update(elapsed:Float):Float {
		if (!isStarted || isPaused || elapsed <= 0) return 0;

		isUpdating = true;

		var overflowTime = currentTween.update(elapsed);
		var updatedTweenCount = 1;
		var wasRepeat = false;
		var wasComplete = false;


		while (currentTween.isComplete) {
			currentTweenIndex += getMovementDirection();

			if (indexInBounds(currentTweenIndex)) {
				currentTween = getTween(currentTweenIndex);
				currentTween.startInternal(this, 0, overrideStartValues, isReverse);
				overflowTime = currentTween.update(overflowTime);
				updatedTweenCount++;
				continue;
			}

			if (
				!canRepeat() || 
				overflowTime == elapsed && updatedTweenCount == tweens.length // In case of infinite repeat
			) {
				wasComplete = true;
				break;
			}

			overrideStartValues = false;
			repeatIndex++;
			if (isYoyo) isReverse = !isReverse;
			wasRepeat = true;
			
			// if (isReverse && tweens.length > 1) {
			// 	final nextTweenIndex = getStartTweenIndex();
			// 	final nextTween = getTween(nextTweenIndex);
			// 	nextTween.reset();
			// }

			currentTweenIndex = getStartTweenIndex();
			currentTween = getTween(currentTweenIndex);
			currentTween.startInternal(this, 0, overrideStartValues, isReverse); // TODO: move after repeat callback?
			overflowTime = currentTween.update(overflowTime);
			updatedTweenCount++;
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

		isUpdating = false;
		return 0;
	}

	final function indexInBounds(idx:Int):Bool {
		return idx >= 0 && idx < tweens.length;
	}

	final function getStartTweenIndex():Int {
		return isReverse ? tweens.length - 1 : 0;
	}

	final function getEndTweenIndex():Int {
		return isReverse ? 0 : tweens.length - 1;
	}

	final function getTween(idx:Int):Tween {
		return tweens[idx];
	}

	final function getMovementDirection():Int {
		return isReverse ? -1 : 1;
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