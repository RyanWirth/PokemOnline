package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.trainer.TrainerBadge;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBadgeSprite extends UISprite
	{
		[Embed(source="assets/UIBadgeSprite.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _badge:Bitmap;
		private var _badgeType:String
		
		public function UIBadgeSprite(type:String) 
		{
			super(spriteImage);
			
			_badgeType = type;
			
			construct();
		}
		
		override public function construct():void
		{
			var xCoord:int = 0;
			var yCoord:int = 0;
			if (_badgeType == TrainerBadge.STONE) xCoord = 0;
			else if (_badgeType == TrainerBadge.KNUCKLE) xCoord = 16;
			else if (_badgeType == TrainerBadge.DYNAMO) xCoord = 32;
			else if (_badgeType == TrainerBadge.HEAT) xCoord = 48;
			else if (_badgeType == TrainerBadge.BALANCE) xCoord = 64;
			else if (_badgeType == TrainerBadge.FEATHER) xCoord = 80;
			else if (_badgeType == TrainerBadge.MIND) xCoord = 96;
			else if (_badgeType == TrainerBadge.RAIN) xCoord = 112;
			else throw(new Error("Unknown Badge type " + _badgeType));
			
			_badge = getSprite(xCoord, yCoord, 16, 16);
			this.addChild(_badge);
		}
		
		override public function destroy():void
		{
			this.removeChild(_badge);
			_badge = null;
		}
		
	}

}