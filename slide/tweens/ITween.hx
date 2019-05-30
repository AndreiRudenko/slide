package slide.tweens;



interface ITween {

	public var active   	(default, null):Bool;
	public var complete   	(default, null):Bool;
	
	// private var _time_remains:Float;
	// private var _duration:Float;
	// private var _added:Bool;
	// private var _backwards:Bool;

	public function start(time:Float = 0):ITween;
	// public function goto(time:Float):Void;
	public function stop(complete:Bool = false):Void;
	public function step(dt:Float):Void;

	public function onstart(f:Void->Void):ITween;
	public function onstop(f:Void->Void):ITween;
	public function onupdate(f:Void->Void):ITween;
	public function onrepeat(f:Void->Void):ITween;
	public function oncomplete(f:Void->Void):ITween;
	public function repeat(times:Int = -1):ITween;
	public function reflect():ITween;
	public function then(tween:Tween<Dynamic>):ITween;


	// private function _start(time:Float):Void;
	// private function _stop(complete:Bool):Void;
	// private function _step(dt:Float):Void;
	// private function drop():Void;
	


}
