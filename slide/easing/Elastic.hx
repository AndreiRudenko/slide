package slide.easing;

class Elastic {

	static var AMPLITUDE:Float = 1;
	static var PERIOD:Float = 0.4;

	public static inline function easeIn(t:Float):Float {
		return -(AMPLITUDE * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t - (PERIOD / (2 * Math.PI) * Math.asin(1 / AMPLITUDE))) * (2 * Math.PI) / PERIOD));
	}
	
	public static inline function easeOut(t:Float):Float {
		return (AMPLITUDE * Math.pow(2, -10 * t) * Math.sin((t - (PERIOD / (2 * Math.PI) * Math.asin(1 / AMPLITUDE))) * (2 * Math.PI) / PERIOD) + 1);
	}

	public static inline function easeInOut(t:Float):Float {
		if (t < 0.5) {
			return -0.5 * (Math.pow(2, 10 * (t -= 0.5)) * Math.sin((t - (PERIOD / 4)) * (2 * Math.PI) / PERIOD));
		}
		return Math.pow(2, -10 * (t -= 0.5)) * Math.sin((t - (PERIOD / 4)) * (2 * Math.PI) / PERIOD) * 0.5 + 1;
	}
		
}