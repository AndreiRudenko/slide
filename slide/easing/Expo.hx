package slide.easing;


class Expo {

	
    public static inline function easeIn(t:Float):Float {

		return Math.pow(2, 10 * (t - 1));

	}
	
	public static inline function easeOut(t:Float):Float {

		return -Math.pow(2, -10 * t) + 1;

	}

	public static inline function easeInOut(t:Float):Float {

		return t < 0.5 ? Math.pow(2, 10 * (t * 2 - 1)) / 2 : (-Math.pow(2, -10 * (t * 2 - 1)) + 2) / 2;

	}


}
