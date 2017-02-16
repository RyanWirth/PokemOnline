package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.cloakentertainment.pokemonline.battle.BattleSpecialTile;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattleLocation extends UISprite
	{
		[Embed(source="assets/UIBattleLocation.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var bitmap:Bitmap;
		private var _location:String
		
		public function UIBattleLocation(battleSpecialTile:String) 
		{
			super(spriteImage);
			
			_location = battleSpecialTile;
			
			construct();
		}
		
		override public function construct():void
		{
			var initX:int = 0;
			var initY:int = 0; // 240x112
			var w:int = 240;
			var h:int = 112;
			switch(_location)
			{
				case BattleSpecialTile.SAND:
				case BattleSpecialTile.CAVE:
				case BattleSpecialTile.ARENA_2:
				case BattleSpecialTile.ARENA_1:
					initX = w * 2;
					break;
				case BattleSpecialTile.ARENA_3:
				case BattleSpecialTile.ARENA_4:
				case BattleSpecialTile.ARENA_5:
					initX = w * 3;
					break;
				case BattleSpecialTile.TALL_GRASS:
				case BattleSpecialTile.LONG_GRASS:
				case BattleSpecialTile.PLAIN:
				case BattleSpecialTile.SEA_WATER:
				case BattleSpecialTile.PUDDLE:
					initX = 0;
					break;
				default:
					initX = w;
					break;
					
			}
			switch(_location)
			{
				case BattleSpecialTile.PLAIN:
				case BattleSpecialTile.POND_WATER:
				case BattleSpecialTile.CAVE:
				case BattleSpecialTile.ARENA_3:
					initY = 0;
					break;
				case BattleSpecialTile.LONG_GRASS:
				case BattleSpecialTile.UNDERWATER:
				case BattleSpecialTile.SAND:
				case BattleSpecialTile.ARENA_4:
					initY = h;
					break;
				case BattleSpecialTile.TALL_GRASS:
				case BattleSpecialTile.BUILDING:
				case BattleSpecialTile.ARENA_1:
				case BattleSpecialTile.ARENA_5:
					initY = h * 2;
					break;
				default:
					initY = h * 3;
					break;
			}
			
			bitmap =  getSprite(initX, initY, 240, 112);
			this.addChild(bitmap);
		}
		
		override public function destroy():void
		{
			this.removeChild(bitmap);
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
		
	}

}