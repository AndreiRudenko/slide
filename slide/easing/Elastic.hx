package slide.easing;


class Elastic {
	

	static var amplitude:Float = 1;
	static var period:Float = 0.4;


	public static inline function easeIn(t:Float):Float {

		return -(amplitude * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t - (period / (2 * Math.PI) * Math.asin(1 / amplitude))) * (2 * Math.PI) / period));

	}
	
	public static inline function easeOut(t:Float):Float {

		return (amplitude * Math.pow(2, -10 * t) * Math.sin((t - (period / (2 * Math.PI) * Math.asin(1 / amplitude))) * (2 * Math.PI) / period) + 1);

	}

	public static inline function easeInOut(t:Float):Float {

		if (t < 0.5) {
			return -0.5 * (Math.pow(2, 10 * (t -= 0.5)) * Math.sin((t - (period / 4)) * (2 * Math.PI) / period));
		}
		return Math.pow(2, -10 * (t -= 0.5)) * Math.sin((t - (period / 4)) * (2 * Math.PI) / period) * 0.5 + 1;

	}

		
}