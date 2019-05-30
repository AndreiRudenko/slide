package slide.easing;
	
	
class Quint {
	

	public static inline function easeIn(t:Float):Float {

		return t * t * t * t * t;

	}
	
	public static inline function easeOut(t:Float):Float {

		return (t = t - 1) * t * t * t * t + 1;

	}

	public static inline function easeInOut(t:Float):Float {

		return ((t *= 2) < 1) ? (t * t * t * t * t) / 2 : ((t -= 2) * t * t * t * t + 2) / 2;

	}
	

}
