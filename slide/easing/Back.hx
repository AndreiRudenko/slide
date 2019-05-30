package slide.easing;
	
	
class Back {
	

	public static inline function easeIn(t:Float):Float {

		return t * t * (2.70158 * t - 1.70158);

	}
	
	public static inline function easeOut(t:Float):Float {

		return 1 - (--t) * (t) * (-2.70158 * t - 1.70158);

	}

	public static inline function easeInOut(t:Float):Float {

		t *= 2;
		if (t < 1) {
			return t * t * (2.70158 * t - 1.70158) / 2;
		}
		t--;
		return (1 - (--t) * (t) * (-2.70158 * t - 1.70158)) / 2 + 0.5;

	}	


}