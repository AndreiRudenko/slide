package slide.tweens;

interface TweenObserver {

	@:allow(slide.Tween)
	private function onTweenStarted(tween:Tween):Void;
	@:allow(slide.Tween)
	private function onTweenStopped(tween:Tween):Void;

}