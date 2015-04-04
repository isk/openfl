package openfl._legacy.display; #if openfl_legacy


import haxe.io.Bytes;
import haxe.CallStack;
import haxe.Timer;
import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.display.DisplayObjectContainer;
import openfl.display.OpenGLView;
import openfl.display.Stage3D;
import openfl.display.StageAlign;
import openfl.display.StageDisplayState;
import openfl.display.StageScaleMode;
import openfl.events.FocusEvent;
import openfl.events.JoystickEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.SystemEvent;
import openfl.events.TouchEvent;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.SoundChannel;
//import openfl.net.URLLoader;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLFramebuffer;
import openfl._legacy.system.ScreenMode;
import openfl.ui.Keyboard;
import openfl.Lib;
import openfl.Vector;

#if android
import openfl._legacy.utils.JNI;
#end

@:access(lime.graphics.opengl.GL)


class Stage extends DisplayObjectContainer implements IModule {
	
	
	@:noCompletion public static var __earlyWakeup = 0.005;
	@:noCompletion public static var __exiting = false;
	
	public static var OrientationPortrait = 1;
	public static var OrientationPortraitUpsideDown = 2;
	public static var OrientationLandscapeRight = 3;
	public static var OrientationLandscapeLeft = 4;
	public static var OrientationFaceUp = 5;
	public static var OrientationFaceDown = 6;
	public static var OrientationPortraitAny = 7;	// This and below for use with setFixedOrientation() on iOS
	public static var OrientationLandscapeAny = 8;
	public static var OrientationAny = 9;

	public var allowsFullScreen:Bool;
	public var autos3d (get, set):Bool;
	public var active (default, null):Bool;
	public var align (get, set):StageAlign;
	public var color (get, set):Int;
	public var displayState (get, set):StageDisplayState;
	public var dpiScale (get, null):Float;
	public var focus (get, set):InteractiveObject;
	public var frameRate (default, set): Float;
	public var isOpenGL (get, null):Bool;
	public var onKey:Int -> Bool -> Int -> Int -> Void; 
	public var onQuit:Void -> Void; 
	public var pauseWhenDeactivated:Bool;
	public var quality (get, set):StageQuality;
	public var renderRequest:Void -> Void; 
	public var scaleMode (get, set):StageScaleMode;
	public var softKeyboardRect (get, null):Rectangle;
	public var stage3Ds (default, null):Vector<Stage3D>;
	public var stageFocusRect (get, set):Bool;
	public var stageHeight (get, null):Int;
	public var stageWidth (get, null):Int;
	
	@:noCompletion private static var efLeftDown = 0x0001;
	@:noCompletion private static var efShiftDown = 0x0002;
	@:noCompletion private static var efCtrlDown = 0x0004;
	@:noCompletion private static var efAltDown = 0x0008;
	@:noCompletion private static var efCommandDown = 0x0010;
	@:noCompletion private static var efLocationRight = 0x4000;
	@:noCompletion private static var efNoNativeClick = 0x10000;
	@:noCompletion private static var sClickEvents = [ "click", "middleClick", "rightClick" ];
	@:noCompletion private static var sDownEvents = [ "mouseDown", "middleMouseDown", "rightMouseDown" ];
	@:noCompletion private static var sUpEvents = [ "mouseUp", "middleMouseUp", "rightMouseUp" ];
	
	@:noCompletion private static var __mouseChanges:Array<String> = [ MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_OVER, MouseEvent.ROLL_OUT, MouseEvent.ROLL_OVER ];
	@:noCompletion private static var __touchChanges:Array<String> = [ TouchEvent.TOUCH_OUT, TouchEvent.TOUCH_OVER,	TouchEvent.TOUCH_ROLL_OUT, TouchEvent.TOUCH_ROLL_OVER ];
	
	#if android
	@:noCompletion private var __hatValue:Int;
	#end
	@:noCompletion private var __joyAxisData:Map <Int, Array <Float>>;
	@:noCompletion private var __dragBounds:Rectangle;
	@:noCompletion private var __dragObject:Sprite;
	@:noCompletion private var __dragOffsetX:Float;
	@:noCompletion private var __dragOffsetY:Float;
	@:noCompletion private var __focusOverObjects:Array<InteractiveObject>;
	@:noCompletion private var __framePeriod:Float;
	@:noCompletion private var __invalid:Bool;
	@:noCompletion private var __lastClickTime:Int;
	@:noCompletion private var __lastDown:Array<InteractiveObject>;
	@:noCompletion private var __lastRender:Float;
	@:noCompletion private var __mouseOverObjects:Array<InteractiveObject>;
	@:noCompletion private var __nextRender:Float;
	@:noCompletion private var __softKeyboardRect:Rectangle;
	@:noCompletion private var __touchInfo:Map <Int, TouchInfo>;
	
	
	static inline public var etUnknown = 0;
	static inline public var etKeyDown = 1;
	static inline public var etChar = 2;
	static inline public var etKeyUp = 3;
	static inline public var etMouseMove = 4;
	static inline public var etMouseDown = 5;
	static inline public var etMouseClick = 6;
	static inline public var etMouseUp = 7;
	static inline public var etResize = 8;
	static inline public var etPoll = 9;
	static inline public var etQuit = 10;
	static inline public var etFocus = 11;
	static inline public var etShouldRotate = 12;
	static inline public var etDestroyHandler = 13;
	static inline public var etRedraw = 14;
	static inline public var etTouchBegin = 15;
	static inline public var etTouchMove = 16;
	static inline public var etTouchEnd = 17;
	static inline public var etTouchTap = 18;
	static inline public var etChange = 19;
	//static inline public var efLeftDown = 0x0001;
	//static inline public var efShiftDown = 0x0002;
	//static inline public var efCtrlDown = 0x0004;
	//static inline public var efAltDown = 0x0008;
	//static inline public var efCommandDown = 0x0010;
	static inline public var efMiddleDown = 0x0020;
	static inline public var efRightDown = 0x0040;
	//static inline public var efLocationRight = 0x4000;
	static inline public var efPrimaryTouch = 0x8000;
	
	
	public function new (width:Int, height:Int, color:Int) {
		
		var handle = openfl_legacy_managed_stage_create (width, height, 0x00000080);
		
		super (handle, "Stage");
		
		__mouseOverObjects = [];
		__focusOverObjects = [];
		active = true;
		allowsFullScreen = true;
		pauseWhenDeactivated = true;
		
		#if android
		__hatValue = 0;
		renderRequest = openfl_legacy_stage_request_render;
		#else
		renderRequest = null;
		#end
		
		#if ios
		GL.defaultFramebuffer = new GLFramebuffer (GL.getParameter (GL.FRAMEBUFFER_BINDING), GL.version);
		#end
		
		openfl_legacy_set_stage_handler (__handle, __processStageEvent, width, height);
		__invalid = false;
		__lastRender = 0;
		__lastDown = [];
		__lastClickTime = 0;
		__nextRender = 0;
		this.frameRate = 100;
		__touchInfo = new Map <Int, TouchInfo> ();
		__joyAxisData = new Map <Int, Array<Float>> ();
		
		stage3Ds = new Vector ();
		stage3Ds.push (new Stage3D ());
		
		#if(cpp && (safeMode || debug))
 		untyped __global__.__hxcpp_set_critical_error_handler( function(message:String) { throw message; } );
 		#end
		
		openfl_legacy_managed_stage_pump_event (handle, { type: etResize, x: width, y: height });
		
		opaqueBackground = color;
	}
	
	
	public static dynamic function getOrientation ():Int {
		
		return 0;
		//return openfl_legacy_stage_get_orientation ();
		
	}
	
	
	public static dynamic function getNormalOrientation ():Int {
		
		return 0;
		//return openfl_legacy_stage_get_normal_orientation ();
		
	}
	
	
	public function init (context:RenderContext):Void {
		
		/*switch (context) {
			
			case OPENGL (gl):
				
				__renderer = new GLRenderer (stageWidth, stageHeight, gl);
			
			case CANVAS (context):
				
				__renderer = new CanvasRenderer (stageWidth, stageHeight, context);
			
			case DOM (element):
				
				__renderer = new DOMRenderer (stageWidth, stageHeight, element);
			
			default:
			
		}*/
		
	}
	
	
	public function invalidate ():Void {
		
		__invalid = true;
		
	}
	
	
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		
		
	}
	
	
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		
		
	}
	
	
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		
		
	}
	
	
	public function onGamepadConnect (gamepad:Gamepad):Void {
		
		
		
	}
	
	
	public function onGamepadDisconnect (gamepad:Gamepad):Void {
		
		
		
	}
	
	
	public function onKeyDown (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		//__onKey (KeyboardEvent.KEY_DOWN, keyCode, modifier);
		
	}
	
	
	public function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		//__onKey (KeyboardEvent.KEY_UP, keyCode, modifier);
		
	}
	
	
	public function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		/*var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
			
		}
		
		__onMouse (type, x, y, button);*/
		
	}
	
	
	public function onMouseMove (x:Float, y:Float):Void {
		
		//__onMouse (MouseEvent.MOUSE_MOVE, x, y, 0);
		
	}
	
	
	public function onMouseMoveRelative (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		/*var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
			
		}
		
		__onMouse (type, x, y, button);*/
		
	}
	
	
	public function onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		//__onMouseWheel (deltaX, deltaY);
		
	}
	
	
	public function onRenderContextLost ():Void {
		
		
		
	}
	
	
	public function onRenderContextRestored (context:RenderContext):Void {
		
		
		
	}
	
	
	public function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		//__onTouch (TouchEvent.TOUCH_MOVE, x, y, id);
		
	}
	
	
	public function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		//__onTouch (TouchEvent.TOUCH_END, x, y, id);
		
	}
	
	
	public function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		//__onTouch (TouchEvent.TOUCH_BEGIN, x, y, id);
		
	}
	
	
	public function onWindowActivate ():Void {
		
		//var event = new Event (Event.ACTIVATE);
		//__broadcast (event, true);
		
	}
	
	
	public function onWindowClose ():Void {
		
		
		
	}
	
	
	public function onWindowDeactivate ():Void {
		
		//var event = new Event (Event.DEACTIVATE);
		//__broadcast (event, true);
		
	}
	
	
	public function onWindowFocusIn ():Void {
		
		
		
	}
	
	
	public function onWindowFocusOut ():Void {
		
		
		
	}
	
	
	public function onWindowFullscreen ():Void {
		
		
		
	}
	
	
	public function onWindowMinimize ():Void {
		
		
		
	}
	
	
	public function onWindowMove (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onWindowResize (width:Int, height:Int):Void {
		
		openfl_legacy_managed_stage_pump_event (__handle, { type: etResize, x: width, y: height });
		
		
		/*stageWidth = width;
		stageHeight = height;
		
		if (__renderer != null) {
			
			__renderer.resize (width, height);
			
		}
		
		var event = new Event (Event.RESIZE);
		__broadcast (event, false);*/
		
	}
	
	
	public function onWindowRestore ():Void {
		
		
		
	}
	
	
	public function render (context:RenderContext):Void {
		
		__render (true);
		
		/*if (__rendering) return;
		__rendering = true;
		
		__broadcast (new Event (Event.ENTER_FRAME), true);
		
		if (__invalidated) {
			
			__invalidated = false;
			__broadcast (new Event (Event.RENDER), true);
			
		}
		
		__renderable = true;
		__update (false, true);
		
		if (__renderer != null) {
			
			__renderer.render (this);
			
		}
		
		__rendering = false;*/
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		
		
	}
	
	
	public function resize (width:Int, height:Int):Void {
		
		//openfl_legacy_stage_resize_window (__handle, width, height);
		
	}
	
	
	public function setResolution (width:Int, height:Int):Void {
		//openfl_legacy_stage_set_resolution(__handle, width, height);
	}
	
	
	public function setScreenMode (mode:ScreenMode):Void {
		//openfl_legacy_stage_set_screenmode(__handle, mode.width, mode.height, mode.refreshRate, 0);
	}
	
	
	public function setFullscreen (full:Bool):Void {
		//openfl_legacy_stage_set_fullscreen(__handle, full);
	}
	
	
	public static function setFixedOrientation (orientation:Int):Void {
		
		// If you set this, you don't need to set the 'shouldRotateInterface' function.
		openfl_legacy_stage_set_fixed_orientation (orientation);
		
	}
	
	
	public static dynamic function shouldRotateInterface (orientation:Int):Bool {
		
		return orientation == OrientationPortrait;
		
	}
	
	
	public function showCursor (show:Bool):Void {
		
		//openfl_legacy_stage_show_cursor (__handle, show);
		
	}
	
	
	@:noCompletion private function __checkFocusInOuts (event:Dynamic, stack:Array<InteractiveObject>):Void {
		
		var newLength = stack.length;
		var newObject = newLength > 0 ? stack[newLength - 1] : null;
		var oldLength = __focusOverObjects.length;
		var oldObject = oldLength > 0 ? __focusOverObjects[oldLength - 1] : null;
		
		if (newObject != oldObject) {
			
			if (oldObject != null) {
				
				var focusOut = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, newObject, event.flags > 0, event.code);
				focusOut.target = oldObject;
				oldObject.__fireEvent (focusOut);
				
			}
			
			if (newObject != null) {
				
				var focusIn = new FocusEvent (FocusEvent.FOCUS_IN, true, false, oldObject, event.flags > 0, event.code);
				focusIn.target = newObject;
				newObject.__fireEvent (focusIn);
				
			}
			
			__focusOverObjects = stack;
			
		}
		
	}
	
	
	@:noCompletion private function __checkInOuts (event:MouseEvent, stack:Array<InteractiveObject>, touchInfo:TouchInfo = null):Bool {
		
		var prev = (touchInfo == null ? __mouseOverObjects : touchInfo.touchOverObjects);
		var events = (touchInfo == null ? __mouseChanges : __touchChanges);
		
		var newLength = stack.length;
		var newObject = newLength > 0 ? stack[newLength - 1] : null;
		var oldLength = prev.length;
		var oldObject = oldLength > 0 ? prev[oldLength - 1] : null;
		
		if (newObject != oldObject) {
			
			if (oldObject != null) {
				
				oldObject.__fireEvent (event.__createSimilar (events[0], newObject, oldObject));
				
			}
			
			if (newObject != null) {
				
				newObject.__fireEvent (event.__createSimilar (events[1], newObject, newObject));
				
			}
			
			var common = 0;
			while (common < newLength && common < oldLength && stack[common] == prev[common]) {
				
				common++;
				
			}
			
			var rollOut = event.__createSimilar (events[2], newObject, oldObject);
			
			var i = oldLength - 1;
			while (i >= common) {
				
				prev[i].__dispatchEvent (rollOut);
				i--;
				
			}
			
			var rollOver = event.__createSimilar (events[3], oldObject);
			
			var i = newLength - 1;
			while (i >= common) {
				
				stack[i].__dispatchEvent (rollOver);
				i--;
				
			}
			
			if (touchInfo == null) {
				
				__mouseOverObjects = stack;
				
			} else {
				
				touchInfo.touchOverObjects = stack;
				
			}
			
			return false;
			
		}
		
		return true;
		
	}
	
	
	@:noCompletion private function __checkRender ():Void {
		
		if (frameRate > 0) {
			
			var now = Timer.stamp ();
			if (now >= __nextRender) {
				
				__lastRender = now;
				
				while (__nextRender < __lastRender) {
					
					__nextRender += __framePeriod;
					
				}
				
				if (renderRequest != null) {
					
					renderRequest ();
					
				} else {
					
					__render (true);
					
				}
				
			}
			
		} #if emscripten else {
			
			__render (true);
			
		}
		#end
		
	}
	
	
	#if android
	#if no_traces
	@:functionCode("try {")
	@:functionTailCode(' } catch(Dynamic e) { __hx_dump_stack(); }')
	#else
	@:noCompletion @:keep private function dummyTrace ():Void { trace (""); }
	@:functionCode("try {")
	@:functionTailCode(' } catch(Dynamic e) { __hx_dump_stack(); ::haxe::Log_obj::trace(HX_CSTRING("Uncaught exception: ") + e,hx::SourceInfo(HX_CSTRING("Stage.hx"),0,HX_CSTRING("flash.display.Stage"),HX_CSTRING("__doProcessStageEvent"))); } return 0;')
	#end
	#end
	@:noCompletion private function __doProcessStageEvent (event:Dynamic):Float {
		
		var result = 0.0;
		var type = Std.int (Reflect.field (event, "type"));
		
		try {
			
			switch (type) {
				
				case 2: // etChar
					
					if (onKey != null)
						untyped onKey (event.code, event.down, event.char, event.flags);
				
				case 1: // etKeyDown
					
					__onKey (event, KeyboardEvent.KEY_DOWN);
				
				case 3: // etKeyUp
					
					__onKey (event, KeyboardEvent.KEY_UP);
				
				case 4: // etMouseMove
					
					__onMouse (event, MouseEvent.MOUSE_MOVE, true);
				
				case 5: // etMouseDown
					
					__onMouse (event, MouseEvent.MOUSE_DOWN, true);
				
				case 6: // etMouseClick
					
					__onMouse (event, MouseEvent.CLICK, true);
				
				case 7: // etMouseUp
					
					__onMouse (event, MouseEvent.MOUSE_UP, true);
				
				case 8: // etResize
					
					__onResize (event.x, event.y);
					if (renderRequest == null) {
						
						__render (false);
						
					}
				
				case 9: // etPoll
					
					//__pollTimers ();
				
				case 10: // etQuit
					
					if (onQuit != null)
						onQuit ();
				
				case 11: // etFocus
					
					__onFocus (event);
				
				case 12: // etShouldRotate
					
					if (shouldRotateInterface (event.value))
						event.result = 2;
				
				case 14: // etRedraw
					
					__render (true);
				
				case 15: // etTouchBegin
					
					var touchInfo = new TouchInfo ();
					__touchInfo.set (event.value, touchInfo);
					__onTouch (event, TouchEvent.TOUCH_BEGIN, touchInfo);
					
					if ((event.flags & 0x8000) > 0) {
						
						__onMouse (event, MouseEvent.MOUSE_DOWN, false);
						
					}
				
				case 16: // etTouchMove
					
					var touchInfo = __touchInfo.get (event.value);
					__onTouch (event, TouchEvent.TOUCH_MOVE, touchInfo);

					if ((event.flags & 0x8000) > 0) {
						
						__onMouse (event, MouseEvent.MOUSE_MOVE, false);
						
					}
				
				case 17: // etTouchEnd
					
					var touchInfo = __touchInfo.get (event.value);
					__onTouch (event, TouchEvent.TOUCH_END, touchInfo);
					__touchInfo.remove (event.value);
					
					if ((event.flags & 0x8000) > 0) {
						
						__onMouse (event, MouseEvent.MOUSE_UP, false);
						
					}
				
				case 18: // etTouchTap
					
					//_onTouchTap (event.TouchEvent.TOUCH_TAP);
				
				case 19: // etChange
					
					__onChange (event);
				
				case 20: // etActivate
					
					__setActive (true);
				
				case 21: // etDeactivate
					
					__setActive (false);
				
				case 22: // etGotInputFocus
					
					__dispatchEvent (new Event (FocusEvent.FOCUS_IN));
				
				case 23: // etLostInputFocus
					
					__dispatchEvent (new Event (FocusEvent.FOCUS_OUT));
				
				case 24: // etJoyAxisMove
					
					__onJoystick (event, JoystickEvent.AXIS_MOVE);
				
				case 25: // etJoyBallMove
					
					__onJoystick (event, JoystickEvent.BALL_MOVE);
				
				case 26: // etJoyHatMove
					
					__onJoystick (event, JoystickEvent.HAT_MOVE);
				
				case 27: // etJoyButtonDown
					
					__onJoystick (event, JoystickEvent.BUTTON_DOWN);
				
				case 28: // etJoyButtonUp
					
					__onJoystick (event, JoystickEvent.BUTTON_UP);
				
				case 29: //etJoyDeviceAdded

			        __onJoystick (event, JoystickEvent.DEVICE_ADDED);

		        case 30: //etJoyDeviceRemoved

		    	    __onJoystick (event, JoystickEvent.DEVICE_REMOVED);

				case 31: // etSysWM
					
					__onSysWM (event);
				
				case 32: // etRenderContextLost
					
					__onRenderContext (false);
				
				case 33: // etRenderContextRestored
					
					__onRenderContext (true);
				
				// TODO: user, sys_wm, sound_finished
				
			}
			
		} catch (error:Dynamic) {
			
			Lib.rethrow (error);
			
		}
		
		result = __updateNextWake ();
		return result;
		
	}
	
	
	@:noCompletion private function __processStageEvent (event:Dynamic):Dynamic {
		
		__doProcessStageEvent (event);
		return null;
		
	}
	
	
	@:noCompletion private function __drag (mouse:Point):Void {
		
		var parent = __dragObject.parent;
		if (parent != null) {
			
			mouse = parent.globalToLocal (mouse);
			
		}
		
		var x = mouse.x + __dragOffsetX;
		var y = mouse.y + __dragOffsetY;
		
		if (__dragBounds != null) {
			
			if (x < __dragBounds.x) {
				
				x = __dragBounds.x;
				
			} else if (x > __dragBounds.right) {
				
				x = __dragBounds.right;
				
			}
			
			if (y < __dragBounds.y) {
				
				y = __dragBounds.y;
				
			} else if (y > __dragBounds.bottom) {
				
				y = __dragBounds.bottom;
				
			}
			
		}
		
		__dragObject.x = x;
		__dragObject.y = y;
		
	}
	
	
	@:noCompletion private function __nextFrameDue (otherTimers:Float) {
		
		if (!active && pauseWhenDeactivated) {
			
			return otherTimers;
			
		}
		
		if (frameRate > 0) {
			
			var next = __nextRender - Timer.stamp () - __earlyWakeup;
			if (next < otherTimers) {
				
				return next;
				
			}
			
		}
		
		return otherTimers;
		
	}
	
	
	@:noCompletion private function __onChange (event:Dynamic):Void {
		
		var object = __findByID (event.id);
		
		if (object != null) {
			
			object.__fireEvent (new Event (Event.CHANGE, true));
			
		}
		
	}
	
	
	@:noCompletion private function __onFocus (event:Dynamic):Void {
		
		var stack = new Array<InteractiveObject>();
		var object = __findByID (event.id);
		
		if (object != null) {
			
			object.__getInteractiveObjectStack (stack);
			
		}
		
		if (stack.length > 0 && (event.value == 1 || event.value == 2)) {
			
			var object = stack[0];
			var focusEvent = new FocusEvent (event.value == 1 ? FocusEvent.MOUSE_FOCUS_CHANGE : FocusEvent.KEY_FOCUS_CHANGE, true, true, __focusOverObjects.length == 0 ? null : __focusOverObjects[0], event.flags > 0, event.code);
			object.__fireEvent (focusEvent);
			
			if (focusEvent.__getIsCancelled ()) {
				
				event.result = 1;
				return;
				
			}
			
		}
		
		stack.reverse ();
		__checkFocusInOuts (event, stack);
		
	}
	
	
	@:noCompletion private function __onJoystick (event:Dynamic, type:String):Void {
		
		var joystickEvent:JoystickEvent = null;
		
		switch (type) {
			
			case JoystickEvent.AXIS_MOVE:
				
				var data = __joyAxisData.get (event.id);
				if (data == null) {
					
					data = [ 0.0, 0.0, 0.0, 0.0 ];
					
				}
				
				var value:Float = event.value / 32767; // Range: -32768 to 32767
				if (value < -1) value = -1;
				
				while (data.length < event.code) {
					
					data.push (0);
					
				}
				
				var cachedAxisData:String = '';
				if (__joyAxisData.exists(event.id)) cachedAxisData = __joyAxisData.get(event.id).toString();
				data[event.code] = value;
				if (__joyAxisData.exists(event.id)) {
				
					__joyAxisData.set (event.id, data);
				
					if (__joyAxisData.get(event.id).toString() == cachedAxisData) { //check if anything has changed from previous registered state. If not, dismiss the event
						
						return;
					
					} else {
						
						joystickEvent = new JoystickEvent (type, false, false, event.id, 0, data[0], data[1], data[2]);
						joystickEvent.axis = data.copy ();
							
					}
				} else {
					
					__joyAxisData.set (event.id, data);
					joystickEvent = new JoystickEvent (type, false, false, event.id, 0, data[0], data[1], data[2]);
					joystickEvent.axis = data.copy ();
				}
				
			case JoystickEvent.BALL_MOVE:
				
				joystickEvent = new JoystickEvent (type, false, false, event.id, event.code, event.x, event.y);
			
		    case JoystickEvent.DEVICE_ADDED:
		
		        joystickEvent = new JoystickEvent (type, false, false, event.id); 

		    case JoystickEvent.DEVICE_REMOVED:

		        joystickEvent = new JoystickEvent (type, false, false, event.id);

			case JoystickEvent.HAT_MOVE:
				
				var x = 0;
				var y = 0;
				
				if (event.value & 0x01 != 0) {
					
					y = -1;
					
				} else if (event.value & 0x04 != 0) {
					
					y = 1;
					
				}
				
				if (event.value & 0x02 != 0) {
					
					x = 1;
					
				} else if (event.value & 0x08 != 0) {
					
					x = -1;
					
				}
				
				joystickEvent = new JoystickEvent (type, false, false, event.id, event.code, x, y);
				
			default:
				
				#if android
				if (event.code >= 19 && event.code <= 22) {
					
					if (type == JoystickEvent.BUTTON_DOWN) {
						
						switch (event.code) {
							
							case 19: __hatValue |= 0x01; //up
							case 20: __hatValue |= 0x04; //down
							case 21: __hatValue |= 0x08; //left
							case 22: __hatValue |= 0x02; //right
							
						}
						
					} else {
						
						switch (event.code) {
							
							case 19: __hatValue &= ~0x01; //up
							case 20: __hatValue &= ~0x04; //down
							case 21: __hatValue &= ~0x08; //left
							case 22: __hatValue &= ~0x02; //right
							
						}
						
					}
					
					event.value = __hatValue;
					__onJoystick (event, JoystickEvent.HAT_MOVE);
					return;
					
				} else {
					
					event.code -= 96;
					
				}
				#end
				
				joystickEvent = new JoystickEvent (type, false, false, event.id, event.code);
			
		}
		
		__dispatchEvent (joystickEvent);
		
	}
	
	
	@:noCompletion private function __onKey (event:Dynamic, type:String):Void {
		
		var stack = new Array<InteractiveObject> ();
		var object = __findByID (event.id);
		
		if (object != null) {
			
			object.__getInteractiveObjectStack (stack);
			
		}
		
		if (stack.length > 0) {
			
			var value = event.value;
			if (event.value >= 96 && event.value <= 122) event.value -= 32;
			
			var object = stack[0];
			var flags:Int = event.flags;
			
			var keyboardEvent = new KeyboardEvent (type, true, true, event.code, event.value, ((flags & efLocationRight) == 0) ? 1 : 0, (flags & efCtrlDown) != 0, (flags & efAltDown) != 0, (flags & efShiftDown) != 0);
			object.__fireEvent (keyboardEvent);
			
			if (keyboardEvent.__getIsCancelled ()) {
				
				event.result = 1;
				
			} else {
				
				#if desktop
				#if (windows || linux)
				if (flags & efAltDown > 0 && type == KeyboardEvent.KEY_DOWN && event.code == Keyboard.ENTER) {
				#elseif (mac)
				if (flags & efCtrlDown > 0 && flags & efCommandDown > 0 && type == KeyboardEvent.KEY_DOWN && event.value == Keyboard.F) {
				#end
					
					if (displayState == StageDisplayState.NORMAL) {
						
						displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
						
					} else {
						
						displayState = StageDisplayState.NORMAL;
						
					}
					
				}
				#end
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __onMouse (event:Dynamic, type:String, fromMouse:Bool):Void {
		
		var button:Int = event.value;
		
		if (!fromMouse)
			button = 0;
		
		var wheel = 0;
		
		if (type == MouseEvent.MOUSE_DOWN) {
			
			if (button > 2) {
				
				return;
				
			}
			
			type = sDownEvents[button];
			
		} else if (type == MouseEvent.MOUSE_UP) {
			
			if (button > 2) {
				
				type = MouseEvent.MOUSE_WHEEL;
				wheel = button == 3 ? 1 : -1;
				
			} else {
				
				type = sUpEvents[button];
				
			}
			
		}
		
		if (__dragObject != null) {
			
			__drag (new Point (event.x, event.y));
			
		}
		
		var stack = new Array<InteractiveObject> ();
		var object = __findByID (event.id);
		
		if (object != null) {
			
			object.__getInteractiveObjectStack (stack);
			
		}
		
		var local:Point = null;
		
		if (stack.length > 0) {
			
			var object = stack[0];
			stack.reverse ();
			local = object.globalToLocal (new Point (event.x, event.y));
			var mouseEvent = MouseEvent.__create (type, event, local, object);
			mouseEvent.delta = wheel;
			
			if (fromMouse || (event.flags & 0x8000) > 0) {
				
				__checkInOuts (mouseEvent, stack);
				
			}
			
			object.__fireEvent (mouseEvent);
			
		} else {
			
			local = new Point (event.x, event.y);
			var mouseEvent = MouseEvent.__create (type, event, local, null);
			mouseEvent.delta = wheel;
			
			if (fromMouse || (event.flags & 0x8000) > 0) {
				
				__checkInOuts (mouseEvent, stack);
				
			}
			
		}
		
		var clickObject = stack.length > 0 ? stack[stack.length - 1] : this;
		
		if ((type == MouseEvent.MOUSE_DOWN || type == MouseEvent.MIDDLE_MOUSE_DOWN || type == MouseEvent.RIGHT_MOUSE_DOWN) && button < 3) {
			
			__lastDown[button] = clickObject;
			
		} else if ((type == MouseEvent.MOUSE_UP || type == MouseEvent.MIDDLE_MOUSE_UP || type == MouseEvent.RIGHT_MOUSE_UP) && button < 3) {
			
			if (clickObject == __lastDown[button]) {
				
				var mouseEvent = MouseEvent.__create (sClickEvents[button], event, local, clickObject);
				clickObject.__fireEvent (mouseEvent);
				
				if (button == 0 && clickObject.doubleClickEnabled) {
					
					var now = Lib.getTimer ();
					if (now - __lastClickTime < 500) {
						
						var mouseEvent = MouseEvent.__create (MouseEvent.DOUBLE_CLICK, event, local, clickObject);
						clickObject.__fireEvent (mouseEvent);
						__lastClickTime = 0;
						
					} else {
						
						__lastClickTime = now;
						
					}
					
				}
				
			}
			
			__lastDown[button] = null;
			
		}
		
	}
	
	
	@:noCompletion private function __onRenderContext (active:Bool):Void {
		
		#if ios
		GL.defaultFramebuffer = active ? new GLFramebuffer (GL.getParameter (GL.FRAMEBUFFER_BINDING), GL.version) : null;
		#end
		
		var event = new Event (!active ? OpenGLView.CONTEXT_LOST : OpenGLView.CONTEXT_RESTORED);
		__dispatchEvent (event);
		
	}
	
	
	@:noCompletion private function __onResize (width:Float, height:Float):Void {
		
		var event = new Event (Event.RESIZE);
		__dispatchEvent (event);
		
	}
	
	
	@:noCompletion private function __onSysWM (event:Dynamic):Void {
		
		var event = new SystemEvent (SystemEvent.SYSTEM, false, false, event.value);
		__dispatchEvent (event);
		
	}
	
	
	@:noCompletion private function __onTouch (event:Dynamic, type:String, touchInfo:TouchInfo):Void {
		
		var stack = new Array<InteractiveObject> ();
		var object = __findByID (event.id);
		
		if (object != null) {
			
			object.__getInteractiveObjectStack (stack);
			
		}
		
		if (stack.length > 0) {
			
			var object = stack[0];
			stack.reverse ();
			var local = object.globalToLocal (new Point (event.x, event.y));
			var touchEvent = TouchEvent.__create (type, event, local, object, event.scaleX, event.scaleY);
			touchEvent.touchPointID = event.value;
			touchEvent.isPrimaryTouchPoint = (event.flags & 0x8000) > 0;
			
			__checkInOuts (touchEvent, stack, touchInfo);
			object.__fireEvent (touchEvent);
				
		} else {
			
			var touchEvent = TouchEvent.__create (type, event, new Point (event.x, event.y), null, event.scaleX, event.scaleY);
			touchEvent.touchPointID = event.value;
			touchEvent.isPrimaryTouchPoint = (event.flags & 0x8000) > 0;
			__checkInOuts (touchEvent, stack, touchInfo);
			
		}
		
	}
	
	
	@:noCompletion public function __pollTimers ():Void {
		
		if (__exiting) {
			
			return;
			
		}
		
		#if !java
		Timer.__checkTimers ();
		#end
		//SoundChannel.__pollComplete ();
		//URLLoader.__pollData ();
		__checkRender ();
		
	}
	
	
	@:noCompletion public function __render (sendEnterFrame:Bool):Void {
		
		if (!active) {
			
			return;
			
		}
		
		if (sendEnterFrame) {
			
			__broadcast (new Event (Event.ENTER_FRAME));
			
		}
		
		if (__invalid) {
			
			__invalid = false;
			__broadcast (new Event (Event.RENDER));
			
		}
		
		openfl_legacy_render_stage (__handle);
		
	}
	
	
	@:noCompletion public function __setActive (value:Bool):Void {
		
		if (active != value) {
			
			active = value;
			
			if (!active) {
				
				__lastRender = Timer.stamp ();
				__nextRender = __lastRender + __framePeriod;
				
			}
			
			var event = new Event (active ? Event.ACTIVATE : Event.DEACTIVATE);
			__broadcast (event);
			
			if (value) {
				
				__pollTimers ();
				
				#if android
				var focus = get_focus ();
				if (focus != null && focus.needsSoftKeyboard) {
					
					Timer.delay (function () {
						
						if (focus == get_focus()) {
							
							requestSoftKeyboard ();
							
						}
						
					}, 100);
					
				}
				#end
				
			} else {
				
				#if android
				__dismissSoftKeyboard ();
				#end
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __startDrag (sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void {
		
		__dragBounds = (bounds == null) ? null : bounds.clone ();
		__dragObject = sprite;
		
		if (__dragObject != null) {
			
			if (lockCenter) {
				
				__dragOffsetX = -__dragObject.width / 2;
				__dragOffsetY = -__dragObject.height / 2;
				
			} else {
				
				var mouse = new Point (mouseX, mouseY);
				var parent = __dragObject.parent;
				
				if (parent != null) {
					
					mouse = parent.globalToLocal (mouse);
					
				}
				
				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __stopDrag (sprite:Sprite):Void {
		
		__dragBounds = null;
		__dragObject = null;
		
	}
	
	
	@:noCompletion public function __updateNextWake ():Float {
		
		return 0;
		
		#if java
		return 0;
		#else
		var nextWake = Timer.__nextWake (315000000.0);
		
		/*if (nextWake > 0.001 && SoundChannel.__dynamicSoundCount > 0) {
			
			nextWake = 0.001;
			
		}*/
		
		/*if (nextWake > 0.02 && (SoundChannel.__completePending () || URLLoader.__loadPending ())) {
			
			nextWake = (active || !pauseWhenDeactivated) ? 0.020 : 0.500;
			
		}*/
		
		nextWake = __nextFrameDue (nextWake);
		//openfl_legacy_stage_set_next_wake (__handle, nextWake);
		return nextWake;
		#end
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_align ():StageAlign {
		
		var i:Int = openfl_legacy_stage_get_align (__handle);
		return Type.createEnumIndex (StageAlign, i);
		
	}
	
	
	private function set_align (value:StageAlign):StageAlign {
		
		openfl_legacy_stage_set_align (__handle, Type.enumIndex (value));
		return value;
		
	}
	
	
	private function get_color ():Int {
		
		return opaqueBackground;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		return opaqueBackground = value;
		
	}
	
	
	private function get_displayState ():StageDisplayState {
		
		var i:Int = openfl_legacy_stage_get_display_state (__handle);
		return Type.createEnumIndex (StageDisplayState, i);
		
	}
	
	
	private function set_displayState (value:StageDisplayState):StageDisplayState {
		
		openfl_legacy_stage_set_display_state (__handle, Type.enumIndex (value));
		return value;
		
	}
	
	
	private function get_dpiScale ():Float {
		
		return 1;
		//return openfl_legacy_stage_get_dpi_scale (__handle);
		
	}
	
	
	private function get_focus ():InteractiveObject {
		
		return null;
		//var id = openfl_legacy_stage_get_focus_id (__handle);
		//var object = __findByID (id);
		//return cast object;
		
	}
	
	
	private function set_focus (value:InteractiveObject):InteractiveObject {
		
		if (value == null) {
			
			//openfl_legacy_stage_set_focus (__handle, null, 0);
			
		} else {
			
			//openfl_legacy_stage_set_focus (__handle, value.__handle, 0);
			
		}
		
		return value;
		
	}
	
	
	private function set_frameRate (value:Float):Float {
		
		frameRate = value;
		__framePeriod = (frameRate <= 0 ? frameRate : 1.0 / frameRate);
		__nextRender = __lastRender + __framePeriod;
		return value;
		
	}
	
	
	private function get_isOpenGL ():Bool {
		
		return true;
		//return openfl_legacy_stage_is_opengl (__handle);
		
	}
	
	
	private function get_quality ():StageQuality {
		
		var i:Int = openfl_legacy_stage_get_quality (__handle);
		return Type.createEnumIndex (StageQuality, i);
		
	}
	
	
	private function set_quality (value:StageQuality):StageQuality {
		
		openfl_legacy_stage_set_quality (__handle, Type.enumIndex (value));
		return value;
		
	}
	
	
	private function get_scaleMode ():StageScaleMode {
		
		var i:Int = openfl_legacy_stage_get_scale_mode (__handle);
		return Type.createEnumIndex (StageScaleMode, i);
		
	}
	
	
	private function set_scaleMode (value:StageScaleMode):StageScaleMode {
		
		openfl_legacy_stage_set_scale_mode (__handle, Type.enumIndex (value));
		return value;
		
	}
	
	
	private function get_softKeyboardRect ():Rectangle {
		
		if (__softKeyboardRect == null) {
			
			__softKeyboardRect = new Rectangle ();
			
		}
		
		#if (ios || android)
		var height = #if android openfl_legacy_get_softkeyboardheight (); #else openfl_legacy_stage_get_keyboard_height (__handle); #end
		
		if (height > 0) {
			
			__softKeyboardRect.x = 0;
			__softKeyboardRect.y = stageHeight - height;
			__softKeyboardRect.width = stageWidth;
			__softKeyboardRect.height = height;
			
		} else {
			
			__softKeyboardRect.x = 0;
			__softKeyboardRect.y = 0;
			__softKeyboardRect.width = 0;
			__softKeyboardRect.height = 0;
			
		}
		#end
		
		return __softKeyboardRect;
		
	}
	
	
	private override function get_stage ():Stage {
		
		return this;
		
	}
	
	
	private function get_stageFocusRect ():Bool { return openfl_legacy_stage_get_focus_rect (__handle); }
	private function set_stageFocusRect (value:Bool):Bool {
		
		openfl_legacy_stage_set_focus_rect (__handle, value);
		return value;
		
	}


	private function get_autos3d ():Bool { return openfl_legacy_stage_get_autos3d (__handle); }
	private function set_autos3d (value:Bool):Bool {
		
		openfl_legacy_stage_set_autos3d (__handle, value);
		return value;
		
	}
	
	
	private function get_stageHeight ():Int {
		
		return Std.int (cast (openfl_legacy_stage_get_stage_height (__handle), Float));
		
	}
	
	
	private function get_stageWidth ():Int {
		
		return Std.int (cast (openfl_legacy_stage_get_stage_width (__handle), Float));
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var openfl_legacy_set_stage_handler = Lib.load ("openfl-legacy", "openfl_legacy_set_stage_handler", 4);
	private static var openfl_legacy_render_stage = Lib.load ("openfl-legacy", "openfl_legacy_render_stage", 1);
	private static var openfl_legacy_stage_get_autos3d = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_autos3d", 1);
	private static var openfl_legacy_stage_set_autos3d = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_autos3d", 2);
	//private static var openfl_legacy_stage_get_focus_id = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_focus_id", 1);
	//private static var openfl_legacy_stage_set_focus = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_focus", 3);
	private static var openfl_legacy_stage_get_focus_rect = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_focus_rect", 1);
	private static var openfl_legacy_stage_set_focus_rect = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_focus_rect", 2);
	//private static var openfl_legacy_stage_is_opengl = Lib.load ("openfl-legacy", "openfl_legacy_stage_is_opengl", 1);
	#if ios
	private static var openfl_legacy_stage_get_keyboard_height = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_keyboard_height", 1);
	#end
	private static var openfl_legacy_stage_get_stage_width = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_stage_width", 1);
	private static var openfl_legacy_stage_get_stage_height = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_stage_height", 1);
	//private static var openfl_legacy_stage_get_dpi_scale = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_dpi_scale", 1);
	private static var openfl_legacy_stage_get_scale_mode = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_scale_mode", 1);
	private static var openfl_legacy_stage_set_scale_mode = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_scale_mode", 2);
	private static var openfl_legacy_stage_get_align = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_align", 1);
	private static var openfl_legacy_stage_set_align = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_align", 2);
	private static var openfl_legacy_stage_get_quality = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_quality", 1);
	private static var openfl_legacy_stage_set_quality = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_quality", 2);
	private static var openfl_legacy_stage_get_display_state = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_display_state", 1);
	private static var openfl_legacy_stage_set_display_state = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_display_state", 2);
	//private static var openfl_legacy_stage_set_next_wake = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_next_wake", 2);
	private static var openfl_legacy_stage_request_render = Lib.load ("openfl-legacy", "openfl_legacy_stage_request_render", 0);
	//private static var openfl_legacy_stage_resize_window = Lib.load ("openfl-legacy", "openfl_legacy_stage_resize_window", 3);
	//private static var openfl_legacy_stage_set_resolution = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_resolution", 3);
	//private static var openfl_legacy_stage_set_screenmode = Lib.load("lime","openfl_legacy_stage_set_screenmode", 5);
	//private static var openfl_legacy_stage_set_fullscreen = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_fullscreen", 2);
	//private static var openfl_legacy_stage_show_cursor = Lib.load ("openfl-legacy", "openfl_legacy_stage_show_cursor", 2);
	private static var openfl_legacy_stage_set_fixed_orientation = Lib.load ("openfl-legacy", "openfl_legacy_stage_set_fixed_orientation", 1);
	//private static var openfl_legacy_stage_get_orientation = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_orientation", 0);
	//private static var openfl_legacy_stage_get_normal_orientation = Lib.load ("openfl-legacy", "openfl_legacy_stage_get_normal_orientation", 0);
	private static var openfl_legacy_managed_stage_create = Lib.load ("openfl-legacy", "openfl_legacy_managed_stage_create", 3);
	private static var openfl_legacy_managed_stage_pump_event:Dynamic = Lib.load ("openfl-legacy", "openfl_legacy_managed_stage_pump_event", 2);
	
	
	#if android
	private static var openfl_legacy_get_softkeyboardheight = JNI.createStaticMethod ("org.haxe.lime.GameActivity", "getSoftKeyboardHeight", "()F");
	#end
	
	
}


class TouchInfo {
	
	
	public var touchOverObjects:Array<InteractiveObject>;
	
	
	public function new () {
		
		touchOverObjects = [];
		
	}
	
	
}


#end