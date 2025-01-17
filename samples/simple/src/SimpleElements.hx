package;

import haxe.CallStack;

import lime.app.Application;
import lime.ui.Window;

import peote.view.PeoteView;
import peote.view.Color;

import peote.ui.PeoteUIDisplay;
import peote.ui.interactive.UIElement;

import peote.ui.style.SimpleStyle;
import peote.ui.style.RoundBorderStyle;

import peote.ui.event.PointerEvent;
import peote.ui.event.WheelEvent;


class SimpleElements extends Application
{
	var peoteView:PeoteView;
	var uiDisplay:PeoteUIDisplay;
	
	override function onWindowCreate():Void
	{
		switch (window.context.type)
		{
			case WEBGL, OPENGL, OPENGLES:
				try startSample(window)
				catch (_) trace(CallStack.toString(CallStack.exceptionStack()), _);
			default: throw("Sorry, only works with OpenGL.");
		}
	}

	public function startSample(window:Window)
	{
		peoteView = new PeoteView(window);
		
		var roundBorderStyle = new RoundBorderStyle();
		var simpleStyle = new SimpleStyle();
		
		uiDisplay = new PeoteUIDisplay(20, 20, window.width-40, window.height-40, Color.GREY1);
		peoteView.addDisplay(uiDisplay);
		
		uiDisplay.onPointerOver  = function(uiDisplay:PeoteUIDisplay, e:PointerEvent) { trace("uiDisplay onPointerOver",e); };
		uiDisplay.onPointerOut   = function(uiDisplay:PeoteUIDisplay, e:PointerEvent) { trace("uiDisplay onPointerOut",e); };
		uiDisplay.onPointerDown  = function(uiDisplay:PeoteUIDisplay, e:PointerEvent) { trace("uiDisplay onPointerDown",e); };
		uiDisplay.onPointerUp    = function(uiDisplay:PeoteUIDisplay, e:PointerEvent) { trace("uiDisplay onPointerUp",e);  };
		uiDisplay.onPointerClick = function(uiDisplay:PeoteUIDisplay, e:PointerEvent) { trace("uiDisplay onPointerClick",e); };
		//uiDisplay.onPointerMove =  function(uiDisplay:UIDisplay, e:PointerEvent) { trace("uiDisplayLeft onPointerMove",e); };
		
		
		// Take care that every Button have its own Style if changing style-params into eventhandler
		// or alternatively create different styles by .copy() for over/out/click and so on
		
		var myStyle = roundBorderStyle.copy();
		myStyle.color = Color.GREY1;
		myStyle.borderColor = Color.GREY5;
		myStyle.borderSize = 4.0;
		myStyle.borderRadius = 40.0;
		
		trace("NEW BUTTON -----");
		var button1:UIElement = new UIElement(20, 0, 200, 100, myStyle);
		//var button1:InteractiveElement = new InteractiveElement(20, 0, 200, 100, new SimpleStyle(Color.GREY1));
		
		button1.overOutEventsBubbleToDisplay = false;
		button1.upDownEventsBubbleToDisplay = true;
		uiDisplay.add(button1);
		
		button1.onPointerOver = onOver.bind(Color.GREY2);
		button1.onPointerOut = onOut.bind(Color.GREY1); // only fires if there was some over before!
		button1.onPointerDown = onDown.bind(Color.YELLOW);
		button1.onPointerUp = onUp.bind(Color.GREY5);   // only fires if there was some down before!
		button1.onPointerClick = onClick;
		
		var myStyle2 = new RoundBorderStyle(Color.GREY1, Color.GREY5);
		myStyle2.borderSize = 2.0;

		trace("NEW BUTTON -----");
		var button2:UIElement = new UIElement(120, 60, 200, 100, myStyle2);
		uiDisplay.add(button2);
		
		// to bubble up/down and click-events up to button1
		button2.upDownEventsBubbleTo = button1; 
		
		button2.onPointerOver = onOver.bind(Color.GREY3);
		button2.onPointerOut = onOut.bind(Color.GREY1); // only fire if there was some over before!
		button2.onPointerMove = onMove;
		button2.onPointerDown = onDown.bind(Color.RED);
		button2.onPointerUp = onUp.bind(Color.GREY5);   // only fire if there was some down before!
		button2.onPointerClick = onClick;
		
		//trace("REMOVE onPointerClick -----"); button1.onPointerClick = null;
		//uiDisplay.remove(button1);
		//uiDisplay.add(button1);
					
		//uiDisplay.update(button1);
		//uiDisplay.updateAll();
		
		
		// -------------- Dragging -------------------
		
		trace("NEW SLIDER -----");
		var myStyle3:RoundBorderStyle = {
			color: Color.GREY2,
			borderColor: Color.GREY5,
			borderSize: 3.0,
			borderRadius: 20.0
		}
		
		//var background = new InteractiveElement(10, 140, 350, 60, new SimpleStyle(Color.GREEN));
		var dragBackground = new UIElement(10, 140, 350, 60, myStyle3);
		dragBackground.onPointerOver = onOver.bind(Color.GREY3);
		dragBackground.onPointerOut = onOut.bind(Color.GREY2);
		uiDisplay.add(dragBackground);
		
		//var dragger = new InteractiveElement(10, 140, 100, 60, 1, myStyle3);
		//var dragger = new InteractiveElement(dragBackground.x, dragBackground.y, 100, 60, 1, myStyle2);
		var dragger = new UIElement(dragBackground.x, dragBackground.y, 100, 60, 1, new RoundBorderStyle(Color.BLUE,Color.GREY5));
		//var dragger = new InteractiveElement(dragBackground.x, dragBackground.y, 100, 60, 1, new SimpleStyle(Color.GREEN));
		
		dragBackground.onMouseWheel = function(b:UIElement, e:WheelEvent) {
			trace("MouseWheel:", e);
			dragger.x = Std.int(Math.max(dragBackground.x, Math.min(dragBackground.x+dragBackground.width-dragger.width, (dragger.x + e.deltaY * 20))));
			dragger.updateLayout();
			// trigger mouse-move here also for html5 (maybe also x and y position forlastMouseMoveX)!
			//uiDisplay.mouseMove(lastMouseMoveX, lastMouseMoveY);
		}
		
		
		// to bubble over-event up to the dragBackground
		dragger.overOutEventsBubbleTo = dragBackground;
		dragger.wheelEventsBubbleTo = dragBackground;
		//dragger.onMouseWheel = InteractiveElement.noWheelOperation;
		// testing bubble move-events
		//dragger.moveEventsBubbleTo = button2;
		
		
		dragger.onPointerOver = onOver.bind(Color.RED);
		dragger.onPointerOut = onOut.bind(Color.BLUE);

		dragger.setDragArea(10, 140, 350, 60); // x, y, width, height
		dragger.onPointerDown = function(b:UIElement, e:PointerEvent) {
			trace(" -----> onPointerDown", e);
			b.startDragging(e);
			b.style.borderColor = Color.YELLOW;
			b.updateStyle();
		}
		dragger.onPointerUp = function(b:UIElement, e:PointerEvent) {
			trace(" -----> onPointerUp", e);
			b.style.borderColor = Color.GREY7;
			b.updateStyle();
			b.stopDragging(e); // this need to be at End because it can be trigger the OUT-event after
		}
		uiDisplay.add(dragger);

		// ------ DragArea ------
		
		trace("NEW DragArea -----");
		var myStyle4 = new RoundBorderStyle();
		myStyle4.color = Color.GREY1;
		myStyle4.borderColor = Color.GREY5;
		myStyle4.borderSize = 3.0;
		myStyle4.borderRadius = 40.0;
		
		var draggAreaBG = new UIElement(10, 200, 350, 350, myStyle4);
		uiDisplay.add(draggAreaBG);

		var draggArea = new UIElement(250, 250, 80, 80, myStyle4);
		draggArea.setDragArea(10, 200, 350, 350); // x, y, width, height
		draggArea.onPointerDown = function(b:UIElement, e:PointerEvent) {
			trace(" -----> onPointerDown", e);
			b.startDragging(e);
			b.style.color = Color.YELLOW;
			b.updateStyle();
		}
		draggArea.onPointerUp = function(b:UIElement, e:PointerEvent) {
			trace(" -----> onPointerUp", e);
			b.stopDragging(e);
			b.style.color = Color.GREY1;
			b.updateStyle();
		}
		uiDisplay.add(draggArea);
		
		
		// TODO: make uiElement to switch between
		//uiDisplay.mouseEnabled = false;
		//uiDisplay.touchEnabled = false;
		peoteView.zoom = 0.8;
		peoteView.xOffset = 30;
		uiDisplay.zoom = 1.7;
		uiDisplay.xOffset = 50;
		
		#if android
		uiDisplay.mouseEnabled = false;
		peoteView.zoom = 3;
		#end
		
		// TODO: set what events to register (mouse, touch, keyboard ...)
		PeoteUIDisplay.registerEvents(window);
			
	}
	
	// ----------------- InteractiveElement Eventhandler ----------------------
	
	public inline function onOver(color:Color, uiElement:UIElement, e:PointerEvent) {
		trace(" -----> onPointerOver", e);
		uiElement.style.color = color;
		if ((uiElement.style is RoundBorderStyle)) {
			uiElement.style.borderColor = Color.GREY7;
		}
		uiElement.updateStyle();
	}
	
	public inline function onOut(color:Color, uiElement:UIElement, e:PointerEvent) {
		trace(" -----> onPointerOut", e);
		uiElement.style.color = color;
		// alternatively you can check:
		if (uiElement.style.borderColor != null) {
			uiElement.style.borderColor = Color.GREY5;
		}
		uiElement.updateStyle();
	}
	
	public inline function onMove(uiElement:UIElement, e:PointerEvent) {
		trace(" -----> onPointerMove", e, uiElement.localX(e.x), uiElement.localY(e.y));
	}
	
	public inline function onDown(borderColor:Color, uiElement:UIElement, e:PointerEvent) {
		trace(" -----> onPointerDown", e);
		if ((uiElement.style is RoundBorderStyle)) {
			uiElement.style.borderColor = borderColor;
			//uiElement.x += 30;  uiElement.update();
			uiElement.updateStyle();
		}
	}
	
	public inline function onUp(borderColor:Color, uiElement:UIElement, e:PointerEvent) {
		trace(" -----> onPointerUp", e);
		if ((uiElement.style is RoundBorderStyle)) {
			uiElement.style.borderColor = borderColor;
			uiElement.updateStyle();
		}
	}
	
	public inline function onClick(uiElement:UIElement, e:PointerEvent) {
		trace(" -----> onPointerClick", e);
		//uiElement.y += 30; uiElement.updateLayout();
	}
	
	
	// ------------------------------------------------------------
	// ----------------- LIME EVENTS ------------------------------
	// ------------------------------------------------------------	

	// override function onPreloadComplete() {}
	// override function update(deltaTime:Int) {}
	// public override function onRenderContextLost ():Void trace(" --- WARNING: LOST RENDERCONTEXT --- ");		
	// public override function onRenderContextRestored (context:RenderContext):Void trace(" --- onRenderContextRestored --- ");		

	// override function onWindowResize (width:Int, height:Int) { trace("onWindowResize"); }
	// override function onWindowActivate():Void { trace("onWindowActivate"); }
	// override function onWindowDeactivate():Void { trace("onWindowDeactivate"); }
	// override function onWindowClose():Void { trace("onWindowClose"); }
	// override function onWindowDropFile(file:String):Void { trace("onWindowDropFile"); }
	// override function onWindowEnter():Void { trace("onWindowEnter"); }
	// override function onWindowExpose():Void { trace("onWindowExpose"); }
	// override function onWindowFocusIn():Void { trace("onWindowFocusIn"); }
	// override function onWindowFocusOut():Void { trace("onWindowFocusOut"); }
	// override function onWindowFullscreen():Void { trace("onWindowFullscreen"); }
	// override function onWindowMove(x:Float, y:Float):Void { trace("onWindowMove"); }
	// override function onWindowMinimize():Void { trace("onWindowMinimize"); }
	// override function onWindowRestore():Void { trace("onWindowRestore"); }
}
