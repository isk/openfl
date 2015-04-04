package openfl._legacy.text; #if openfl_legacy


import openfl.display.InteractiveObject;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.Lib;

@:access(openfl._legacy.text.Font)


class TextField extends InteractiveObject {
	
	
	public var antiAliasType:AntiAliasType;
	public var autoSize (get, set):TextFieldAutoSize;
	public var background (get, set):Bool;
	public var backgroundColor (get, set):Int;
	public var border (get, set):Bool;
	public var borderColor (get, set):Int;
	public var bottomScrollV (get, null):Int;
	public var defaultTextFormat (get, set):TextFormat;
	public var displayAsPassword (get, set):Bool;
	public var embedFonts (get, set):Bool;
	public var gridFitType:GridFitType;
	public var htmlText (get, set):String;
	public var maxChars (get, set):Int;
	public var maxScrollH (get, null):Int;
	public var maxScrollV (get, null):Int;
	public var multiline (get, set):Bool;
	public var numLines (get, null):Int;
	public var scrollH (get, set):Int;
	public var scrollV (get, set):Int;
	public var selectable (get, set):Bool;
	public var sharpness:Float;
	public var text (get, set):String;
	public var textColor (get, set):Int;
	public var textHeight (get, null):Float;
	public var textWidth (get, null):Float;
	public var type (get, set):TextFieldType;
	public var wordWrap (get, set):Bool;
	
	private var __embedFonts:Bool;
	
	
	public function new () {
		
		super (openfl_legacy_text_field_create (), "TextField");
		
		gridFitType = GridFitType.PIXEL;
		sharpness = 0;
		embedFonts = false;
		
	}
	
	
	public function appendText (text:String):Void {
		
		openfl_legacy_text_field_set_text (__handle, openfl_legacy_text_field_get_text (__handle) + text);
		
	}
	
	
	public function getLineOffset (lineIndex:Int):Int {
		
		return openfl_legacy_text_field_get_line_offset (__handle, lineIndex);
		
	}
	
	
	public function getLineText (lineIndex:Int):String {
		
		return openfl_legacy_text_field_get_line_text (__handle, lineIndex);
		
	}
	
	
	public function getLineMetrics (lineIndex:Int):TextLineMetrics {
		
		var result = new TextLineMetrics ();
		openfl_legacy_text_field_get_line_metrics (__handle, lineIndex, result);
		return result;
		
	}
	
	
	public function getTextFormat (beginIndex:Int = -1, endIndex:Int = -1):TextFormat {
		
		var result = new TextFormat ();
		openfl_legacy_text_field_get_text_format (__handle, result, beginIndex, endIndex);
		
		for (font in Font.__registeredFonts) {
			
			if (result.font == font.__fontPath) {
				
				result.font = font.fontName;
				
			}
			
		}
		
		return result;
		
	}
	
	
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String):Void {
		
		openfl.Lib.notImplemented ("TextField.replaceText");
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int):Void {
		
		openfl.Lib.notImplemented ("TextField.setSelection");
		
	}
	
	
	public function setTextFormat (format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void {
		
		if (format != null) {
			
			for (font in Font.__registeredFonts) {
				
				if (font.__fontPath != null && format.font == font.fontName) {
					
					format.font = font.__fontPath;
					
				}
				
			}
			
		}
		
		openfl_legacy_text_field_set_text_format (__handle, format, beginIndex, endIndex);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_autoSize ():TextFieldAutoSize { return Type.createEnumIndex (TextFieldAutoSize, openfl_legacy_text_field_get_auto_size (__handle)); }
	private function set_autoSize (value:TextFieldAutoSize):TextFieldAutoSize { openfl_legacy_text_field_set_auto_size (__handle, Type.enumIndex (value)); return value; }
	private function get_background ():Bool { return openfl_legacy_text_field_get_background (__handle); }
	private function set_background (value:Bool):Bool { openfl_legacy_text_field_set_background (__handle, value); return value; }
	private function get_backgroundColor ():Int { return openfl_legacy_text_field_get_background_color (__handle); }
	private function set_backgroundColor (value:Int):Int { openfl_legacy_text_field_set_background_color (__handle, value); return value; }
	private function get_border ():Bool { return openfl_legacy_text_field_get_border (__handle); }
	private function set_border (value:Bool):Bool { openfl_legacy_text_field_set_border (__handle, value); return value; }
	private function get_borderColor ():Int { return openfl_legacy_text_field_get_border_color (__handle); }
	private function set_borderColor (value:Int):Int { openfl_legacy_text_field_set_border_color (__handle, value); return value; }
	private function get_bottomScrollV ():Int { return openfl_legacy_text_field_get_bottom_scroll_v (__handle); }
	
	
	private function get_defaultTextFormat ():TextFormat { 
		
		var result = new TextFormat();
		openfl_legacy_text_field_get_def_text_format (__handle, result);
		
		for (font in Font.__registeredFonts) {
			
			if (result.font == font.__fontPath) {
				
				result.font = font.fontName;
				
			}
			
		}
		
		return result;
	
	}
	
	
	private function set_defaultTextFormat (value:TextFormat):TextFormat {
		
		if (value != null) {
			
			for (font in Font.__registeredFonts) {
				
				if (font.__fontPath != null && value.font == font.fontName) {
					
					value.font = font.__fontPath;
					
				}
				
			}
			
		}
		
		openfl_legacy_text_field_set_def_text_format (__handle, value);
		return value;
		
	}
	
	
	private function get_displayAsPassword ():Bool { return openfl_legacy_text_field_get_display_as_password (__handle); }
	private function set_displayAsPassword (value:Bool):Bool { openfl_legacy_text_field_set_display_as_password (__handle, value); return value; }
	private function get_embedFonts ():Bool { return openfl_legacy_text_field_get_embed_fonts (__handle); }
	private function set_embedFonts (value:Bool):Bool { openfl_legacy_text_field_set_embed_fonts (__handle, value); return value; }
	private function get_htmlText ():String { return StringTools.replace (openfl_legacy_text_field_get_html_text (__handle), "\n", "<br/>"); }
	private function set_htmlText (value:String):String	{ openfl_legacy_text_field_set_html_text (__handle, value); return value; }
	private function get_maxChars ():Int { return openfl_legacy_text_field_get_max_chars (__handle); }
	private function set_maxChars (value:Int):Int { openfl_legacy_text_field_set_max_chars (__handle, value); return value; }
	private function get_maxScrollH ():Int { return openfl_legacy_text_field_get_max_scroll_h (__handle); }
	private function get_maxScrollV ():Int { return openfl_legacy_text_field_get_max_scroll_v (__handle); }
	private function get_multiline ():Bool { return openfl_legacy_text_field_get_multiline (__handle); }
	private function set_multiline (value:Bool):Bool { openfl_legacy_text_field_set_multiline (__handle, value); return value; }
	private function get_numLines ():Int { return openfl_legacy_text_field_get_num_lines (__handle); }
	private function get_scrollH ():Int { return openfl_legacy_text_field_get_scroll_h (__handle); }
	private function set_scrollH (value:Int):Int { openfl_legacy_text_field_set_scroll_h (__handle, value); return value; }
	private function get_scrollV ():Int { return openfl_legacy_text_field_get_scroll_v (__handle); }
	private function set_scrollV (value:Int):Int { openfl_legacy_text_field_set_scroll_v (__handle, value); return value; }
	private function get_selectable ():Bool { return openfl_legacy_text_field_get_selectable (__handle); }
	private function set_selectable (value:Bool):Bool { openfl_legacy_text_field_set_selectable (__handle, value); return value; }
	private function get_text ():String { return openfl_legacy_text_field_get_text (__handle); }
	private function set_text (value:String):String { openfl_legacy_text_field_set_text (__handle, value); return value; }
	private function get_textColor ():Int { return openfl_legacy_text_field_get_text_color (__handle); }
	private function set_textColor (value:Int):Int { openfl_legacy_text_field_set_text_color (__handle, value); return value; }
	private function get_textWidth ():Float { return openfl_legacy_text_field_get_text_width (__handle); }
	private function get_textHeight ():Float { return openfl_legacy_text_field_get_text_height (__handle); }
	private function get_type ():TextFieldType { return openfl_legacy_text_field_get_type (__handle) ? TextFieldType.INPUT : TextFieldType.DYNAMIC; }
	private function set_type (value:TextFieldType):TextFieldType { openfl_legacy_text_field_set_type (__handle, value == TextFieldType.INPUT); return value; }
	private function get_wordWrap ():Bool { return openfl_legacy_text_field_get_word_wrap (__handle); }
	private function set_wordWrap (value:Bool):Bool { openfl_legacy_text_field_set_word_wrap (__handle, value); return value; }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var openfl_legacy_text_field_create = Lib.load ("openfl-legacy", "openfl_legacy_text_field_create", 0);
	private static var openfl_legacy_text_field_get_text = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_text", 1);
	private static var openfl_legacy_text_field_set_text = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_text", 2);
	private static var openfl_legacy_text_field_get_html_text = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_html_text", 1);
	private static var openfl_legacy_text_field_set_html_text = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_html_text", 2);
	private static var openfl_legacy_text_field_get_text_color = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_text_color", 1);
	private static var openfl_legacy_text_field_set_text_color = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_text_color", 2);
	private static var openfl_legacy_text_field_get_selectable = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_selectable", 1);
	private static var openfl_legacy_text_field_set_selectable = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_selectable", 2);
	private static var openfl_legacy_text_field_get_display_as_password = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_display_as_password", 1);
	private static var openfl_legacy_text_field_set_display_as_password = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_display_as_password", 2);
	private static var openfl_legacy_text_field_get_embed_fonts = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_embed_fonts", 1);
	private static var openfl_legacy_text_field_set_embed_fonts = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_embed_fonts", 2);
	private static var openfl_legacy_text_field_get_def_text_format = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_def_text_format", 2);
	private static var openfl_legacy_text_field_set_def_text_format = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_def_text_format", 2);
	private static var openfl_legacy_text_field_get_auto_size = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_auto_size", 1);
	private static var openfl_legacy_text_field_set_auto_size = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_auto_size", 2);
	private static var openfl_legacy_text_field_get_type = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_type", 1);
	private static var openfl_legacy_text_field_set_type = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_type", 2);
	private static var openfl_legacy_text_field_get_multiline = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_multiline", 1);
	private static var openfl_legacy_text_field_set_multiline = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_multiline", 2);
	private static var openfl_legacy_text_field_get_word_wrap = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_word_wrap", 1);
	private static var openfl_legacy_text_field_set_word_wrap = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_word_wrap", 2);
	private static var openfl_legacy_text_field_get_border = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_border", 1);
	private static var openfl_legacy_text_field_set_border = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_border", 2);
	private static var openfl_legacy_text_field_get_border_color = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_border_color", 1);
	private static var openfl_legacy_text_field_set_border_color = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_border_color", 2);
	private static var openfl_legacy_text_field_get_background = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_background", 1);
	private static var openfl_legacy_text_field_set_background = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_background", 2);
	private static var openfl_legacy_text_field_get_background_color = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_background_color", 1);
	private static var openfl_legacy_text_field_set_background_color = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_background_color", 2);
	private static var openfl_legacy_text_field_get_text_width = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_text_width", 1);
	private static var openfl_legacy_text_field_get_text_height = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_text_height", 1);
	private static var openfl_legacy_text_field_get_text_format = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_text_format", 4);
	private static var openfl_legacy_text_field_set_text_format = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_text_format", 4);
	private static var openfl_legacy_text_field_get_max_scroll_v = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_max_scroll_v", 1);
	private static var openfl_legacy_text_field_get_max_scroll_h = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_max_scroll_h", 1);
	private static var openfl_legacy_text_field_get_bottom_scroll_v = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_bottom_scroll_v", 1);
	private static var openfl_legacy_text_field_get_scroll_h = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_scroll_h", 1);
	private static var openfl_legacy_text_field_set_scroll_h = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_scroll_h", 2);
	private static var openfl_legacy_text_field_get_scroll_v = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_scroll_v", 1);
	private static var openfl_legacy_text_field_set_scroll_v = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_scroll_v", 2);
	private static var openfl_legacy_text_field_get_num_lines = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_num_lines", 1);
	private static var openfl_legacy_text_field_get_max_chars = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_max_chars", 1);
	private static var openfl_legacy_text_field_set_max_chars = Lib.load ("openfl-legacy", "openfl_legacy_text_field_set_max_chars", 2);
	private static var openfl_legacy_text_field_get_line_text = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_line_text", 2);
	private static var openfl_legacy_text_field_get_line_metrics = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_line_metrics", 3);
	private static var openfl_legacy_text_field_get_line_offset = Lib.load ("openfl-legacy", "openfl_legacy_text_field_get_line_offset", 2);
	
	
}


#end
