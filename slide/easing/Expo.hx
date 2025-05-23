﻿package slide.easing;

class Expo {
	
    public static inline function easeIn(t:Float):Float {
		return Math.pow(2, 10 * (t - 1));
	}
	
	public static inline function easeOut(t:Float):Float {
		return 1 - easeIn(1 - t);
	}

	public static inline function easeInOut(t:Float):Float {
        return t < 0.5 ? easeIn(2 * t) / 2 : 0.5 + easeOut(2 * t - 1) / 2;
	}

	public static inline function easeOutIn(t:Float):Float {
        return t < 0.5 ? easeOut(2 * t) / 2 : 0.5 + easeIn(2 * t - 1) / 2;
	}

}
