package slide.easing;

class Quad {

	public static inline function easeIn(t:Float):Float {
		return t * t;
	}
	
	public static inline function easeOut(t:Float):Float {
		return -t * (t - 2);
	}

	public static inline function easeInOut(t:Float):Float {
		return t <= 0.5 ? t * t * 2 : 1 - (--t) * t * 2;
	}
	
}
