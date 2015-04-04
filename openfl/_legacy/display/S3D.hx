package openfl._legacy.display; #if openfl_legacy

import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.display.S3DView;

class S3D {
	private static var openfl_legacy_get_s3d_supported:Void->Bool;
	private static var openfl_legacy_get_s3d_enabled:Void->Bool;
	private static var openfl_legacy_set_s3d_enabled:Bool->Void;
	private static var openfl_legacy_gl_s3d_get_eye_separation:Void->Float;
	private static var openfl_legacy_gl_s3d_set_eye_separation:Float->Void;
	private static var openfl_legacy_gl_s3d_get_focal_length:Void->Float;
	private static var openfl_legacy_gl_s3d_set_focal_length:Float->Void;

	public static var enabled (get, set):Bool;
	public static var supported (get, null):Bool;

	public static var eyeSeparation (get, set):Float;
	public static var focalLength (get, set):Float;

	public static function get_supported () {
		if (openfl_legacy_get_s3d_supported == null)
			return false;

		return openfl_legacy_get_s3d_supported ();
	}

	public static function get_enabled () {
		if (openfl_legacy_get_s3d_enabled == null)
			return false;

		return openfl_legacy_get_s3d_enabled ();
	}

	public static function set_enabled (enabled:Bool) {
		if (openfl_legacy_set_s3d_enabled == null)
			return false;
			
		openfl_legacy_set_s3d_enabled (enabled);
		return enabled;
	}

	public static function get_eyeSeparation ():Float {
		if (openfl_legacy_gl_s3d_get_eye_separation == null)
			return 0;

		return openfl_legacy_gl_s3d_get_eye_separation ();
	}

	public static function set_eyeSeparation (separation:Float):Float {
		if (openfl_legacy_gl_s3d_set_eye_separation != null)
			openfl_legacy_gl_s3d_set_eye_separation (separation);
			
		return separation;
	}

	public static function get_focalLength ():Float {
		if (openfl_legacy_gl_s3d_get_focal_length == null)
			return 0.0;

		return openfl_legacy_gl_s3d_get_focal_length ();
	}

	public static function set_focalLength (length:Float):Float {
		if (openfl_legacy_gl_s3d_set_focal_length != null)
			openfl_legacy_gl_s3d_set_focal_length (length);

		return length;
	}

	public static function __init__ () {
		openfl_legacy_get_s3d_enabled = Lib.load ("openfl-legacy", "openfl_legacy_get_s3d_enabled", 0);
		openfl_legacy_set_s3d_enabled = Lib.load ("openfl-legacy", "openfl_legacy_set_s3d_enabled", 1);
		openfl_legacy_get_s3d_supported = Lib.load ("openfl-legacy", "openfl_legacy_get_s3d_supported", 0);
		openfl_legacy_gl_s3d_get_eye_separation = Lib.load ("openfl-legacy", "openfl_legacy_gl_s3d_get_eye_separation", 0);
		openfl_legacy_gl_s3d_set_eye_separation = Lib.load ("openfl-legacy", "openfl_legacy_gl_s3d_set_eye_separation", 1);
		openfl_legacy_gl_s3d_get_focal_length = Lib.load ("openfl-legacy", "openfl_legacy_gl_s3d_get_focal_length", 0);
		openfl_legacy_gl_s3d_set_focal_length = Lib.load ("openfl-legacy", "openfl_legacy_gl_s3d_set_focal_length", 1);
	}
}


#end