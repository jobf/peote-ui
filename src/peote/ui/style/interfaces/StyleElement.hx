package peote.ui.style.interfaces;

import peote.ui.interactive.Interactive;

interface StyleElement 
{
	public function setStyle(style:Dynamic):Void;
	public function setLayout(uiElement:Interactive):Void;
	public function setMasked(uiElement:Interactive, x:Int, y:Int, w:Int, h:Int, mx:Int, my:Int, mw:Int, mh:Int, z:Int):Void;
}
