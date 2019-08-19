package slide.actions;

import slide.tweens.Tween;


@:access(slide.tweens.Tween)
class TweenAction<T> {


	public var active(default, null):Bool;
	public var complete(default, null):Bool;

	public var time(default, null):Float;
	public var position(default, null):Float;
	public var duration(default, null):Float;

	var _tween:Tween<T>;
	var _inited:Bool;

	var _prev:TweenAction<T>;
	var _next:TweenAction<T>;


	public function new(tween:Tween<T>, duration:Float) {

		active = false;
		complete = false;

		time = 0;
		position = 0;
		this.duration = duration;

		_tween = tween;
		_inited = false;

	}

	public function start(time:Float) {

		if(!active) {

			active = true;
			complete = false;
			
			this.time = 0;
			position = 0;

			if(!_inited) {
				init();
				_inited = true;
			}

			if(duration > 0) {
				advance(time);
			} else {
				finish();
			}

		}

	}
	
	public function stop() {

		active = false;

	}

	function step(dt:Float) {

		if(active) {
			advance(dt);
		}

	}

	function advance(t:Float) {

		if(t > 0) {
			
			time += t * _tween.timescale;
			
			if(time >= duration) {
				_tween._time_remains = time - duration;
				finish();
			} else {
				position = (_tween._backwards ? duration - time : time) / duration;
				apply(_tween._easing(position));
			}

		}

	}

	function finish() {

		stop();
		complete = true;
		time = duration;
		position = _tween._backwards ? 0 : 1;
		apply(position);

	}

	function init() {}
	function apply(t:Float) {}


}
