﻿package slide.easing;
	
class SmootherStep {
	
	public static inline function easeIn(t:Float):Float {
		return 2 * easeInOut(t / 2);
	}
	
	public static inline function easeOut(t:Float):Float {
		return 2 * easeInOut(t / 2 + 0.5) - 1;
	}

	public static inline function easeInOut(t:Float):Float {
		return t * t * t * (t * (t * 6 - 15) + 10);
	}

	public static inline function easeOutIn(t:Float):Float {
        return t < 0.5 ? easeOut(2 * t) / 2 : 0.5 + easeIn(2 * t - 1) / 2;
	}
		
}