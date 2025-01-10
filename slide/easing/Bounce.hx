package slide.easing;

class Bounce {

	public static inline function easeIn(t:Float):Float {
		return 1 - easeOut(1 - t);
	}
	
	public static inline function easeOut(t:Float):Float {
		if (t < 1 / 2.75) {
			return (7.5625 * t * t);
		} else if (t < 2 / 2.75) {
			return (7.5625 * (t -= 1.5 / 2.75) * t + 0.75);
		} else if (t < 2.5 / 2.75) {
			return (7.5625 * (t -= 2.25 / 2.75) * t + 0.9375);
		} else {
			return (7.5625 * (t -= 2.625 / 2.75) * t + 0.984375);
		}
	}

	public static inline function easeInOut(t:Float):Float {
        return t < 0.5 ? easeIn(2 * t) / 2 : 0.5 + easeOut(2 * t - 1) / 2;
	}

	public static inline function easeOutIn(t:Float):Float {
        return t < 0.5 ? easeOut(2 * t) / 2 : 0.5 + easeIn(2 * t - 1) / 2;
	}
		
}