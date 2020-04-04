package slide.easing;
	
class SmoothStep {
	
	public static inline function easeIn(t:Float):Float {
		return 2 * easeInOut(t / 2);
	}
	
	public static inline function easeOut(t:Float):Float {
		return 2 * easeInOut(t / 2 + 0.5) - 1;
	}

	public static inline function easeInOut(t:Float):Float {
		return t * t * (t * -2 + 3);
	}
		
}