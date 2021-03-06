package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import lime.math.Matrix3;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;

@:access(openfl.display.Stage)
@:allow(openfl.display.Stage)


class CairoRenderer extends AbstractRenderer {
	
	
	private var cairo:Cairo;
	
	
	public function new (width:Int, height:Int, cairo:Cairo) {
		
		super (width, height);
		
		this.cairo = cairo;
		
		renderSession = new RenderSession ();
		renderSession.cairo = cairo;
		renderSession.roundPixels = true;
		renderSession.renderer = this;
		//#if !neko
		//renderSession.maskManager = new MaskManager (renderSession);
		//#end
		
	}
	
	
	public override function render (stage:Stage):Void {
		
		cairo.transform (new Matrix3 ());
		
		if (stage.__clearBeforeRender) {
			
			cairo.setSourceRGB (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2]);
			cairo.paint ();
			
		}
		
		stage.__renderCairo (renderSession);
		
	}
	
	
}