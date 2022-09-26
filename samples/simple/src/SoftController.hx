import peote.ui.event.PointerEvent;
import peote.ui.interactive.UIElement;
import peote.view.Color;
import peote.ui.style.RoundBorderStyle;
import lime.ui.Window;
import haxe.CallStack;
import peote.ui.PeoteUIDisplay;
import peote.view.PeoteView;
import lime.app.Application;

class SoftController extends Application {
	var peoteView:PeoteView;
	var uiDisplay:PeoteUIDisplay;
	var grid:Grid<Pad>;

	override function onWindowCreate():Void {
		switch (window.context.type) {
			case WEBGL, OPENGL, OPENGLES:
				try
					startSample(window)
				catch (_)
					trace(CallStack.toString(CallStack.exceptionStack()), _);
				default:
					throw("Sorry, only works with OpenGL.");
				}
			}
			
	public function startSample(window:Window) {
		peoteView = new PeoteView(window);
		uiDisplay = new PeoteUIDisplay(20, 20, window.width - 40, window.height - 40, Color.GREY1);
		peoteView.addDisplay(uiDisplay);
		PeoteUIDisplay.registerEvents(window);
		
		var roundBorderStyle = new RoundBorderStyle();
		roundBorderStyle.borderRadius = 3.0;
		roundBorderStyle.color = 0x999999FF;
		var padSize = 48;
		var padGap = 6;
		var gridWidth = 8;
		var gridHeight = 4;

		grid = new  Grid<Pad>((x:Int, y:Int) -> {
			new Pad({
				pixel_y: (y * padSize) + padGap,
				pixel_x: (x * padSize) + padGap,
				pixel_w: padSize,
				pixel_h: padSize,
				grid_y: y,
				grid_x: x,
				color_on: 0xffffffFF,
				color_off: 0x999999FF,
				color_hover: 0xee6666FF
			}, roundBorderStyle,
			onPadClicked);
		},
		gridWidth,
		gridHeight);
		
		for(pad in grid.cells){
			uiDisplay.add(pad.element);
		}
	}
	var lastPressed:Pad = null;
	function onPadClicked(pad_clicked:Pad){
		if(lastPressed != null){
			lastPressed.toggle(false);
		}
		pad_clicked.toggle(!pad_clicked.isOn);
		lastPressed = pad_clicked;
	}

}

@:structInit
class PadConfig {
	public var pixel_x:Int;
	public var pixel_y:Int;
	public var pixel_w:Int;
	public var pixel_h:Int;
	public var grid_x:Int;
	public var grid_y:Int;
	public var color_hover:Int;
	public var color_on:Int;
	public var color_off:Int;
}

class Pad {
	public var element(default, null):UIElement;
	public var isOn(default, null):Bool;
	var config:PadConfig;
	var onClicked:(pad:Pad)->Void;

	public function new(config:PadConfig, style:RoundBorderStyle, onClicked:(pad:Pad)->Void) {
		this.config = config;
		this.onClicked = onClicked;
		element = new UIElement(
			config.pixel_x,
			config.pixel_y,
			config.pixel_w,
			config.pixel_h,
			style);

			element.onPointerOver = onOver;
			element.onPointerOut = onOut;
			element.onPointerClick = onClick;
		}

	inline function onOver(uiElement:UIElement, e:PointerEvent) {
		element.style.color = config.color_hover;
		element.updateStyle();
	}

	inline function onOut(uiElement:UIElement, e:PointerEvent) {
		element.style.color = isOn
									? config.color_on
									: config.color_off;
		element.updateStyle();
	}

	inline function onClick(uiElement:UIElement, e:PointerEvent) {
		onClicked(this);
	}

	public inline function toggle(isOn:Bool){
		this.isOn = isOn;
		element.style.color = isOn
									? config.color_on
									: config.color_off;
		element.updateStyle();
	}
}

class Grid<T> {
	var width:Int;
	var height:Int;

	public var cells(default, null):Array<Null<T>>;

	public function new(defaultValue:(x:Int, y:Int)->T, width:Int, height:Int) {
		this.width = width;
		this.height = height;
		cells = [for (i in 0...width * height) defaultValue(x(i), y(i))];
	}

	inline function i(x:Int, y:Int) {
		return x + width * y;
	}

	inline function x(index:Int):Int {
		return Std.int(index % width);
	}

	inline function y(index:Int):Int {
		return Std.int(index / width);
	}

	public function get(x:Int, y:Int):Null<T> {
		return cells[i(x, y)];
	}
}
