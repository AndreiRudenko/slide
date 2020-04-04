package slide.easing;
	
class Cubic {
	
	public static inline function easeIn(t:Float):Float {
		return t * t * t;
	}
	
	public static inline function easeOut(t:Float):Float {
		return 1 + (--t) * t * t;
	}

	public static inline function easeInOut(t:Float):Float {
		return t <= 0.5 ? t * t * t * 4 : 1 + (--t) * t * t * 4;
	}
	
}