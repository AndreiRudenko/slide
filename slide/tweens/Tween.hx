package slide.tweens;

import haxe.macro.Expr;
import slide.actions.TweenAction;


typedef EaseFunc = Float->Float;


@:access(slide.actions.TweenAction)
class Tween<T> {


	public var target(default, null):T;

	public var active(default, null):Bool;
	public var complete(default, null):Bool;
	public var paused(default, set):Bool;
	public var timescale(default, set):Float;

	var _nextTween:Tween<Dynamic>;

	var _onStart:Void->Void;
	var _onStop:Void->Void;
	var _onPause:Void->Void;
	var _onResume:Void->Void;
	var _onUpdate:Void->Void;
	var _onRepeat:Void->Void;
	var _onComplete:Void->Void;

	var _added:Bool;
	var _reflect:Bool;
	var _backwards:Bool;
	var _repeat:Int;
	var _timeRemains:Float;
	var _duration:Float;

	var _manualUpdate:Bool;
	var _easing:EaseFunc;

	var _action:TweenAction<T>;

	var _head:TweenAction<T>;
	var _tail:TweenAction<T>;


	public function new(target:T, manualUpdate:Bool) {

		this.target = target;

		_manualUpdate = manualUpdate;

		active = false;
		complete = false;
		paused = false;
		timescale = 1;

		_added = false;
		_reflect = false;
		_backwards = false;
		_repeat = 0;
		_timeRemains = 0;
		_duration = 0;
		
		_easing = slide.easing.Linear.none;
	}

	public function stop(complete:Bool = false) {

		if(active) {
			if(_onStop != null) {
				_onStop();
			}

			_action.stop();

			if(complete) {
				_action.finish();
				var next = _action;
				while((next = _backwards ? next._prev : next._next) != null) {
					next.start(next.duration);
				}
				_action = _backwards ? _tail : _head; 
			}

			active = false;
		}

	}

	public function step(dt:Float) {

		if(!active || paused) {
			return;
		}

		if(dt > 0) {
			_action.step(dt);
			checkNext();
		}

	}

	function begin(time:Float = 0) {

		if(!active) {

			if(_onStart != null) {
				_onStart();
			}

			_timeRemains = time;

			if(_head == null) {
				stop();
				finish();
				nextTween();
			} else {
				active = true;
				complete = false;
				_backwards = false;

				init();

				_action = _head;
				_action.start(time);

				checkNext();
			}

		}

	}

	function init() {
		
		if(!_added && !_manualUpdate) {
			Slide.addTween(this);
			Slide.addTargetTween(this, target);
			_added = true;
		}
		
	}

	function drop() {

		Slide.removeTargetTween(this, target);
		_added = false;

	}

	inline function checkNext() {
		
		while(_action.complete && active) {
			nextAction();
		}

	}

	function nextAction() {

		var next = _backwards ? _action._prev : _action._next;

		if(next != null) {
			_action = next;
			_action.start(_timeRemains);
		} else {
			if(_repeat != 0) {
				if(_repeat < 0 && _duration <= 0) {
					throw('Infinity loop, tween duration is 0 with infinity repeat');
				}

				if(_onRepeat != null) {
					_onRepeat();
				}

				if(_reflect) {
					_backwards = !_backwards;
				}

				if(_repeat > 0) {
					_repeat--;
				}

				_action = _backwards ? _tail : _head; 
				_action.start(_timeRemains);
			} else {
				stop();
				finish();
				nextTween();
			}
		}

	}

	inline function finish() {

		complete = true;
		
		if(_onComplete != null) {
			_onComplete();
		}

	}

	inline function nextTween() {
		
		if(_nextTween != null) {
			_nextTween.begin(_timeRemains);
		}

	}

	function addAction(a:TweenAction<T>):TweenAction<T> {

		_duration += a.duration;

		if (_tail != null) {
			_tail._next = a;
			a._prev = _tail;
		} else{
			_head = a;
		}

		_tail = a;

		return a;

	}

	function set_paused(v:Bool):Bool {
		
		if(v != paused) {
			if(paused) {
				if(_onResume != null) {
					_onResume();
				}
			} else {
				if(_onPause != null) {
					_onPause();
				}
			}
		}

		return paused = v;

	}

	function set_timescale(v:Float):Float {
		
		if(v < 0) {
			v = 0;
		}

		return timescale = v;

	}

	@:noCompletion
	public static macro function getFn(name:String, start:ExprOf<Array<Float>> = null, end:ExprOf<Array<Float>> = null) {

		var startLen = switch (start.expr) {
			case EArrayDecl(a): a.length;
			case _: 0;
		}

		var endLen = switch (end.expr) {
			case EArrayDecl(a): a.length;
			case _: 0;
		}

		if(startLen != endLen) {
			throw('Start & end args count must be same');
		}
		
		var fv:Array<Expr> = [];
		
		for (i in 0...startLen) {
			fv.push(macro v[$v{i}]);
		}

		var fn:Expr;

		if(name == null) {
			fn = macro t($a{fv});
		} else {
			fn = macro t.$name($a{fv});
		}

		return macro {
			function(t, v){
				$fn;
			}
		};

	}

	@:noCompletion
	public static function getProps(props:Expr, fields:Array<String>, values:Array<Expr>) {
		
		switch (props.expr) {
			case EObjectDecl(obj):
				for (o in obj) {
					if(fields.indexOf(o.field) != -1) {
						throw('Property ${o.field} already exists');
					}
					fields.push(o.field);
					values.push(o.expr);
				}
			case _:
				trace(props);
				throw('Invalid expression in props');
		}

	}


}
