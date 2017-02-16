package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokedexSearchMenuOKButton extends Sprite implements UIElement
	{
		private var _deselectedState:Bitmap;
		private var _selectedState:Bitmap;
		
		public function UIPokedexSearchMenuOKButton(deselectedState:Bitmap, selectedState1:Bitmap)
		{
			_deselectedState = deselectedState;
			_selectedState = selectedState1;
			
			construct();
		}
		
		public function construct():void
		{
			this.addChild(_deselectedState);
			this.addChild(_selectedState);
			_selectedState.visible = false;
		}
		
		public function select():void
		{
			_selectedState.visible = true;
			_deselectedState.visible = false;
		}
		
		public function deselect():void
		{
			_selectedState.visible = false;
			_deselectedState.visible = true;
		}
		
		public function darken(turnOnTint:Boolean = true):void
		{
			if (turnOnTint)
			{
				setTint(this, 0x000000, 0.3);
			}
			else
				setTint(this, 0x000000, 0);
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
		
		public function destroy():void
		{
			this.removeChild(_deselectedState);
			this.removeChild(_selectedState);
			
			_deselectedState = null;
			_selectedState = null;
		}
	
	}

}