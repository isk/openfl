package openfl._legacy.display; #if openfl_legacy


import openfl.Lib;


class GraphicsSolidFill extends IGraphicsData implements IGraphicsFill {
	
	
	public var alpha:Float;
	public var color:UInt;
	
	
	public function new (color:Int = 0, alpha:Float = 1.0) {
		
		this.color = color;
		this.alpha = alpha;
		
		super (openfl_legacy_graphics_solid_fill_create (color, alpha));
		
	}
	
	
	private static var openfl_legacy_graphics_solid_fill_create = Lib.load ("openfl-legacy", "openfl_legacy_graphics_solid_fill_create", 2);
	
	
}


#end