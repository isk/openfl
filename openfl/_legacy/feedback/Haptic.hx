package openfl._legacy.feedback; #if openfl_legacy


import openfl.Lib;


class Haptic {
	
	
	public static function vibrate (period:Int = 0, duration:Int = 1000):Void {
		
		#if cpp
		openfl_legacy_haptic_vibrate (period, duration);
		#end
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if cpp
	static var openfl_legacy_haptic_vibrate = Lib.load ("openfl-legacy", "openfl_legacy_haptic_vibrate", 2);
	#end
	
	
}


#end