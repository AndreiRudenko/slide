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

	var _next_tween:Tween<Dynamic>;

	var _onstart:Void->Void;
	var _onstop:Void->Void;
	var _onpause:Void->Void;
	var _onresume:Void->Void;
	var _onupdate:Void->Void;
	var _onrepeat:Void->Void;
	var _oncomplete:Void->Void;

	var _added:Bool;
	var _reflect:Bool;
	var _backwards:Bool;
	var _repeat:Int;
	var _time_remains:Float;
	var _duration:Float;

	var _manual_update:Bool;
	var _easing:EaseFunc;

	var _action:TweenAction<T>;

	var _head:TweenAction<T>;
	var _tail:TweenAction<T>;


	public function new(target:T, manual_update:Bool) {

		this.target = target;

		_manual_update = manual_update;

		active = false;
		complete = false;
		paused = false;
		timescale = 1;

		_added = false;
		_reflect = false;
		_backwards = false;
		_repeat = 0;
		_time_remains = 0;
		_duration = 0;
		
		_easing = slide.easing.Linear.none;
	}

	public function stop(complete:Bool = false) {

		if(active) {
			if(_onstop != null) {
				_onstop();
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
			check_next();
		}

	}

	function begin(time:Float = 0) {

		if(!active) {

			if(_onstart != null) {
				_onstart();
			}

			_time_remains = time;

			if(_head == null) {
				stop();
				finish();
				next_tween();
			} else {
				active = true;
				complete = false;
				_backwards = false;

				init();

				_action = _head;
				_action.start(time);

				check_next();
			}

		}

	}

	function init() {
		
		if(!_added && !_manual_update) {
			Slide.add_tween(this);
			Slide.add_target_tween(this, target);
			_added = true;
		}
		
	}

	function drop() {

		Slide.remove_target_tween(this, target);
		_added = false;

	}

	inline function check_next() {
		
		while(_action.complete && active) {
			next_action();
		}

	}

	function next_action() {

		var next = _backwards ? _action._prev : _action._next;

		if(next != null) {
			_action = next;
			_action.start(_time_remains);
		} else {
			if(_repeat != 0) {
				if(_repeat < 0 && _duration <= 0) {
					throw('Infinity loop, tween duration is 0 with infinity repeat');
				}

				if(_onrepeat != null) {
					_onrepeat();
				}

				if(_reflect) {
					_backwards = !_backwards;
				}

				if(_repeat > 0) {
					_repeat--;
				}

				_action = _backwards ? _tail : _head; 
				_action.start(_time_remains);
			} else {
				stop();
				finish();
				next_tween();
			}
		}

	}

	inline function finish() {

		complete = true;
		
		if(_oncomplete != null) {
			_oncomplete();
		}

	}

	inline function next_tween() {
		
		if(_next_tween != null) {
			_next_tween.begin(_time_remains);
		}

	}

	function add_action(a:TweenAction<T>):TweenAction<T> {

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
				if(_onresume != null) {
					_onresume();
				}
			} else {
				if(_onpause != null) {
					_onpause();
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
	public static macro function get_fn(name:String, start:ExprOf<Array<Float>> = null, end:ExprOf<Array<Float>> = null) {

		var start_len = switch (start.expr) {
			case EArrayDecl(a): a.length;
			case _: 0;
		}

		var end_len = switch (end.expr) {
			case EArrayDecl(a): a.length;
			case _: 0;
		}

		if(start_len != end_len) {
			throw('Start & end args count must be same');
		}
		
		var fv:Array<Expr> = [];
		
		for (i in 0...start_len) {
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
	public static function get_props(props:Expr, fields:Array<String>, values:Array<Expr>) {
		
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
