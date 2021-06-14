package;

import lime.ui.Window;
import lime.ui.MouseButton;
import lime.app.Application;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.graphics.RenderContext;

import peote.view.PeoteView;
import peote.view.Color;

import peote.text.Font;
import peote.ui.text.FontStyleTiled;

import peote.ui.interactive.LayoutDisplay;
import peote.ui.interactive.LayoutElement;
import peote.ui.interactive.LayoutTextline;

import peote.ui.skin.SimpleSkin;
import peote.ui.skin.SimpleStyle;
import peote.ui.skin.RoundedSkin;
import peote.ui.skin.RoundedStyle;

import peote.layout.LayoutContainer;
import peote.layout.Size;


class ButtonLayout extends Application
{
	var peoteView:PeoteView;
	var uiDisplay:LayoutDisplay;
	
	var simlpeSkin = new SimpleSkin();
	var roundedSkin = new RoundedSkin();
		
	var uiLayoutContainer:LayoutContainer;
	
	var fontTiled:Font<FontStyleTiled>;
	
	public function new() super();
	
	public override function onWindowCreate() {
		switch (window.context.type)
		{
			case WEBGL, OPENGL, OPENGLES: initPeoteView(window); // start sample
			default: throw("Sorry, only works with OpenGL.");
		}
	}
	
	public function initPeoteView(window:Window) {
		try {			
			peoteView = new PeoteView(window.context, window.width, window.height);
			uiDisplay = new LayoutDisplay(0, 0, window.width, window.height, Color.GREY3);
			peoteView.addDisplay(uiDisplay);
			
			// load the FONT:
			fontTiled = new Font<FontStyleTiled>("assets/fonts/tiled/hack_ascii.json");
			fontTiled.load( onTiledFontLoaded );
		}
		catch (e:Dynamic) trace("ERROR:", e);
	}
	
	public function onTiledFontLoaded() {
		try {			
			var red   = new LayoutElement(simlpeSkin, new SimpleStyle(Color.RED));
			var green = new LayoutElement(simlpeSkin, new SimpleStyle(Color.GREEN));
			var blue  = new LayoutElement(roundedSkin, new SimpleStyle(Color.BLUE));
			var yellow= new LayoutElement(roundedSkin, new SimpleStyle(Color.YELLOW));

			var fontStyleTiled = new FontStyleTiled();
			fontStyleTiled.height = 25;
			fontStyleTiled.width = 25;
			fontStyleTiled.color = Color.WHITE;
			var textLine = new LayoutTextline<FontStyleTiled>(0, 0, 112, 25, "hello Button", fontTiled, fontStyleTiled);
			
			uiDisplay.add(red);
			uiDisplay.add(green);
			uiDisplay.add(blue);
			uiDisplay.add(yellow);
			uiDisplay.add(textLine);
			
			uiLayoutContainer = new Box( uiDisplay , { width:Size.limit(100,700), relativeChildPositions:true },
			[                                                          
				new Box( red , { width:Size.limit(100,600) },
				[                                                      
					new Box( green,  { width:Size.limit(50, 300), height:Size.limit(100,400) }),							
					new Box( blue,   { width:Size.span(50, 150), height:Size.limit(100, 300), left:Size.min(50) },
					[
						new Box( textLine, {width:Size.min(100), height:30, top:5, left:5, bottom:Size.min(5) }),
					]),
					new Box( yellow, { width:Size.limit(50, 150), height:Size.limit(200,200), left:Size.span(0,100), right:50 } ),
				])
			]);
			
			uiLayoutContainer.init();
			uiLayoutContainer.update(peoteView.width, peoteView.height);
		}
		catch (e:Dynamic) trace("ERROR:", e);
	}

	
	// ------------------------------------------------------------
	// ----------------- LIME EVENTS ------------------------------
	// ------------------------------------------------------------	
	
	public override function render(context:RenderContext) peoteView.render();
	
	// ----------------- MOUSE EVENTS ------------------------------
	var sizeEmulation = false;
	
	public override function onMouseMove (x:Float, y:Float) {
		uiDisplay.mouseMove(x, y);
		if (sizeEmulation) uiLayoutContainer.update(Std.int(x),Std.int(y));
	}
	
	public override  function onMouseUp (x:Float, y:Float, button:MouseButton) {
		uiDisplay.mouseUp(x, y, button);
		sizeEmulation = !sizeEmulation; 
		if (sizeEmulation) uiLayoutContainer.update(x,y);
		else uiLayoutContainer.update(peoteView.width, peoteView.height);
	}

	// ----------------- KEYBOARD EVENTS ---------------------------
	public override function onKeyDown (keyCode:KeyCode, modifier:KeyModifier) {
		switch (keyCode) {
			#if html5
			case KeyCode.TAB: untyped __js__('event.preventDefault();');
			#end
			case KeyCode.F: window.fullscreen = !window.fullscreen;
			default:
		}
		uiDisplay.keyDown(keyCode, modifier);
	}
	
	// ----------------- WINDOWS EVENTS ----------------------------
	public override function onWindowResize (width:Int, height:Int) {
		peoteView.resize(width, height);
		
		// calculates new Layout and updates all Elements 
		uiLayoutContainer.update(width, height);
	}

}
