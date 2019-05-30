package slide;


import haxe.ds.ObjectMap;

import slide.tweens.Tween;
import slide.tweens.TweenFn;
import slide.tweens.TweenObject;


@:allow(slide.tweens.Tween)
@:access(slide.tweens.Tween)
class Slide {


	static var _active_tweens:Array<Tween<Dynamic>> = [];
	static var _targets:ObjectMap<Dynamic, Array<Tween<Dynamic>>> = new ObjectMap();
	static var _check_time:Int = 0;


	public static function tween<T>(target:T, manual_update:Bool = false):TweenObject<T> {

		return new TweenObject(target, manual_update);
		
	}

	public static function fun<T>(target:T, manual_update:Bool = false):TweenFn<T> {

		return new TweenFn(target, manual_update);

	}

	public static function stop(target:Dynamic) {
		
		var tweens = _targets.get(target);

		if(tweens != null) {
			for (t in tweens) {
				t.stop();
			}
		}

	}

	public static function step(time:Float) {

		for (s in _active_tweens) {
			s.step(time);
		}

		_check_time++;
		if(_check_time > 60) {
			_check_time = 0;
			var n = _active_tweens.length;
			while(n-- > 0) {
				if(!_active_tweens[n].active) {
					_active_tweens[n].drop();
					_active_tweens.splice(n, 1);
				}
			}
		}

	}

	static function add_target_tween<T>(tween:Tween<T>, target:T) {

		var _target_tweens = _targets.get(target);
		if(_target_tweens == null) {
			_target_tweens = [];
			_targets.set(target, _target_tweens);
		}
		
		_target_tweens.push(tween);

	}

	static function remove_target_tween<T>(tween:Tween<T>, target:T) {

		var target_tweens = _targets.get(target);

		if(target_tweens != null) {
			target_tweens.remove(tween);
			if(target_tweens.length == 0) {
				_targets.remove(target);
			}
		}

	}

	static function add_tween<T>(tween:Tween<T>) {

		_active_tweens.push(tween);

	}


}
