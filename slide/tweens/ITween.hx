package slide.tweens;


interface ITween {


	public var active(default, null):Bool;
	public var complete(default, null):Bool;
	
	public function start(time:Float = 0):ITween;
	public function stop(complete:Bool = false):Void;
	public function step(dt:Float):Void;

	public function onStart(f:Void->Void):ITween;
	public function onStop(f:Void->Void):ITween;
	public function onUpdate(f:Void->Void):ITween;
	public function onRepeat(f:Void->Void):ITween;
	public function onComplete(f:Void->Void):ITween;
	public function repeat(times:Int = -1):ITween;
	public function reflect():ITween;
	public function then(tween:Tween<Dynamic>):ITween;


}
