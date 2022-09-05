package peote.ui.style;

import peote.view.Color;
import peote.view.Element;
import peote.view.Program;
import peote.view.Buffer;

import peote.ui.interactive.Interactive;
import peote.ui.style.interfaces.Style;
import peote.ui.style.interfaces.StyleID;
import peote.ui.style.interfaces.StyleProgram;
import peote.ui.style.interfaces.StyleElement;
import peote.ui.util.Unique;

@:structInit
class SimpleStyle implements Style implements StyleID
{
	// style
	public var color:Color = Color.GREY2;
		
	// -----------------------------------------	
	
	static var ID:Int = Unique.styleID;
	public inline function getID():Int return ID;
	public var id(default, null):Int = 0;
	
	public function new(
		?color:Null<Color>
	) {
		if (color != null) this.color = color;
	}
	
	static public function createById(id:Int, ?style:SimpleStyle,
		?color:Null<Color>
	):SimpleStyle {
		var newStyle = (style != null) ? style.copy(color) : new SimpleStyle(color);
		newStyle.id = id;
		return newStyle;
	}
	
	public inline function copy(
		?color:Null<Color>
	):SimpleStyle {
		var newStyle = new SimpleStyle(
			(color != null) ? color : this.color		
		);
		newStyle.id = id;
		return newStyle;
	}
	
	//@:keep inline function createStyleProgram():SimpleStyleProgram return new SimpleStyleProgram();
	@:keep public inline function createStyleProgram():StyleProgram return new SimpleStyleProgram();
}


// -------------------------------------------------------------------
// ---------------- peote-view Element and Program -------------------
// -------------------------------------------------------------------

class SimpleStyleElement implements StyleElement implements Element
{
	// style
	@color var color:Color;
		
	// layout
	@posX var x:Int=0;
	@posY var y:Int=0;	
	@sizeX @varying var w:Int=100;
	@sizeY @varying var h:Int = 100;
	@zIndex var z:Int = 0;
	
	//var OPTIONS = {  };
		
	public inline function new(uiElement:Interactive, style:Dynamic)
	{
		setStyle(style);
		setLayout(uiElement);
	}
	
	inline function setStyle(style:Dynamic)
	{
		color = style.color;
	}
	
	inline function setLayout(uiElement:Interactive)
	{
		z = uiElement.z;
		
		#if (peoteui_no_masking)
		x = uiElement.x;
		y = uiElement.y;
		w = uiElement.width;
		h = uiElement.height;
		#else
		if (uiElement.masked) { // if some of the edges is cut by mask for scroll-area
			x = uiElement.x + uiElement.maskX;
			y = uiElement.y + uiElement.maskY;
			w = uiElement.maskWidth;
			h = uiElement.maskHeight;
		} else {
			x = uiElement.x;
			y = uiElement.y;
			w = uiElement.width;
			h = uiElement.height;
		}
		#end		
	}
}

class SimpleStyleProgram extends Program implements StyleProgram
{
	inline function getBuffer():Buffer<SimpleStyleElement> return cast buffer;
	
	public function new()
	{
		super(new Buffer<SimpleStyleElement>(16, 8));
	}

	inline function createElement(uiElement:Interactive, style:Dynamic):StyleElement
	{
		return new SimpleStyleElement(uiElement, style);
	}
	
	inline function addElement(styleElement:StyleElement)
	{
		getBuffer().addElement(cast styleElement);
	}
	
	inline function update(styleElement:StyleElement)
	{
		getBuffer().updateElement(cast styleElement);
	}
	
	inline function removeElement(styleElement:StyleElement)
	{
		getBuffer().removeElement(cast styleElement);
	}
	
}
