package slide.easing;
	
	
class Sine {
	

	public static inline function easeIn(t:Float):Float {

		return 1 - Math.cos(t * Math.PI / 2);

	}
	
	public static inline function easeOut(t:Float):Float {

		return Math.sin(t * Math.PI / 2);

	}

	public static inline function easeInOut(t:Float):Float {

		return -0.5 * (Math.cos(Math.PI * t) - 1);

	}
	
		
}