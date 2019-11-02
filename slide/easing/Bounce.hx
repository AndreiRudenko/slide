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

		if (t < 0.5) {
			return easeIn(t * 2) * 0.5;
		} else {
			return easeOut(t * 2 - 1) * 0.5 + 0.5;
		}

	}	
	
		
}