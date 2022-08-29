package peote.ui.layouted;

import peote.layout.LayoutContainer;
import peote.ui.interactive.InteractiveElement;
import peote.ui.style.interfaces.Style;

//@:generic class LayoutElement<O,P> extends UIElement implements peote.layout.LayoutElement
class LayoutedElement extends InteractiveElement implements peote.layout.ILayoutElement
{
	//var options:O;
	//var params:P;
	
	public function new(xPosition:Int=0, yPosition:Int=0, width:Int=100, height:Int=100, zIndex:Int=0, style:Style=null) 
	{
		super(xPosition, yPosition, width, height, zIndex, style);
	}
	
	// ----------- Interface: LayoutElement --------------------

	public inline function showByLayout():Void show();
	public inline function hideByLayout():Void hide();

	public inline function updateByLayout(layoutContainer:LayoutContainer) {
		// TODO: layoutContainer.updateMask() from here to make it only on-need
		
		if (isVisible)
		{ 
			if (layoutContainer.isHidden) // if it is full outside of the Mask (so invisible)
			{
				#if peotelayout_debug
				//trace("removed", layoutContainer.layout.name);
				#end
				hide();
			}
			else {
				_update(layoutContainer);
			}
		}
		else if (!layoutContainer.isHidden) // not full outside of the Mask anymore
		{
			#if peotelayout_debug
			//trace("showed", layoutContainer.layout.name);
			#end
			_update(layoutContainer);
			show();
		}		
	}
	
	public inline function _update(layoutContainer:LayoutContainer) {
		x = Math.round(layoutContainer.x);
		y = Math.round(layoutContainer.y);
		z = Math.round(layoutContainer.depth);
		width = Math.round(layoutContainer.width);
		height = Math.round(layoutContainer.height);
		
		#if (!peoteui_no_masking)
		if (layoutContainer.isMasked) { // if some of the edges is cut by mask for scroll-area
/*			trace("origin:",x,y,width,height);
			trace("isMasked",
				Math.round(layoutContainer.maskX),
				Math.round(layoutContainer.maskY),
				Math.round(layoutContainer.maskWidth),
				Math.round(layoutContainer.maskHeight)
			);
*/			
			maskX = Math.round(layoutContainer.maskX);
			maskY = Math.round(layoutContainer.maskY);
			maskWidth  = Math.round(layoutContainer.maskWidth);
			maskHeight = Math.round(layoutContainer.maskHeight);
		}
		masked = layoutContainer.isMasked;
		#end
		
		updateLayout();
	}
		
}