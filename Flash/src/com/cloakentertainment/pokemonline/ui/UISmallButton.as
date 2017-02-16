package com.cloakentertainment.pokemonline.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UISmallButton extends Sprite implements UIElement
	{
		private var uiTextBox:UITextBox;
		
		private var _text:String;
		
		public function UISmallButton(text:String):void
		{
			_text = text;
			
			construct();
		}
		
		public function select():void
		{
			uiTextBox.transform.colorTransform = new ColorTransform();
		}
		
		public function deselect():void
		{
			setTint(uiTextBox, 0x000000, 0.25);
		}
		
		public function construct():void
		{
			uiTextBox = new UITextBox(_text, 222, 30, 8, 8, 6.5, 8);
			this.addChild(uiTextBox);
		}
		
		public function destroy():void
		{
			this.removeChild(uiTextBox);
			uiTextBox.destroy();
			uiTextBox = null;
		}
		
		private function setTint(displayObject:DisplayObject, tintColor:uint, tintMultiplier:Number):void
		{
			var colTransform:ColorTransform = new ColorTransform();
			colTransform.redMultiplier = colTransform.greenMultiplier = colTransform.blueMultiplier = 1 - tintMultiplier;
			colTransform.redOffset = Math.round(((tintColor & 0xFF0000) >> 16) * tintMultiplier);
			colTransform.greenOffset = Math.round(((tintColor & 0x00FF00) >> 8) * tintMultiplier);
			colTransform.blueOffset = Math.round(((tintColor & 0x0000FF)) * tintMultiplier);
			displayObject.transform.colorTransform = colTransform;
		}
	
	}

}