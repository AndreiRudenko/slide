package slide.easing;
	
class Quart {
	
	public static inline function easeIn(t:Float):Float {
		return t * t * t * t;
	}
	
	public static inline function easeOut(t:Float):Float {
		return 1 - (t -= 1) * t * t * t;
	}

	public static inline function easeInOut(t:Float):Float {
		return t <= 0.5 ? t * t * t * t * 8 : (1 - (t = t * 2 - 2) * t * t * t) / 2 + 0.5;
	}
		
}
