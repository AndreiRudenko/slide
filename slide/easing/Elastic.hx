package slide.easing;

class Elastic {

	static var AMPLITUDE:Float = 1;
	static var PERIOD:Float = 0.4;

	public static inline function easeIn(t:Float):Float {
		return -(AMPLITUDE * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t - (PERIOD / (2 * Math.PI) * Math.asin(1 / AMPLITUDE))) * (2 * Math.PI) / PERIOD));
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