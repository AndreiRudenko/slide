package slide.easing;
	
	
class Sine {
	

	public static inline function easeIn(t:Float):Float {

		return -Math.cos(PI2 * t) + 1;

	}
	
	public static inline function easeOut(t:Float):Float {

		return Math.sin(PI2 * t);

	}

	public static inline function easeInOut(t:Float):Float {

		return -Math.cos(PI * t) / 2 + 0.5;

	}
	
		
}