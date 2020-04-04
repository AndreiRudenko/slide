package slide;

import haxe.ds.ObjectMap;

import slide.tweens.Tween;
import slide.tweens.TweenFn;
import slide.tweens.TweenObject;

@:allow(slide.tweens.Tween)
@:access(slide.tweens.Tween)
class Slide {

	static var _activeTweens:Array<Tween<Dynamic>> = [];
	static var _targets:ObjectMap<Dynamic, Array<Tween<Dynamic>>> = new ObjectMap();
	static var _checkTime:Int = 0;

	public static function tween<T>(target:T, manualUpdate:Bool = false):TweenObject<T> {
		return new TweenObject(target, manualUpdate);
	}

	public static function fun<T>(target:T, manualUpdate:Bool = false):TweenFn<T> {
		return new TweenFn(target, manualUpdate);
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
		for (s in _activeTweens) {
			s.step(time);
		}

		_checkTime++;
		if(_checkTime > 60) {
			_checkTime = 0;
			var n = _activeTweens.length;
			while(n-- > 0) {
				if(!_activeTweens[n].active) {
					_activeTweens[n].drop();
					_activeTweens.splice(n, 1);
				}
			}
		}
	}

	static function addTargetTween<T>(tween:Tween<T>, target:T) {
		var _targetTweens = _targets.get(target);
		if(_targetTweens == null) {
			_targetTweens = [];
			_targets.set(target, _targetTweens);
		}
		
		_targetTweens.push(tween);
	}

	static function removeTargetTween<T>(tween:Tween<T>, target:T) {
		var targetTweens = _targets.get(target);

		if(targetTweens != null) {
			targetTweens.remove(tween);
			if(targetTweens.length == 0) {
				_targets.remove(target);
			}
		}
	}

	static function addTween<T>(tween:Tween<T>) {
		_activeTweens.push(tween);
	}

}
