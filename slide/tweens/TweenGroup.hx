package slide.tweens;

interface TweenGroup {

	@:allow(slide.Tween)
	private function tweenStarted(tween:Tween):Void;
	@:allow(slide.Tween)
	private function tweenStopped(tween:Tween):Void;

}