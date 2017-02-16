package com.cloakentertainment.pokemonline.ui 
{
	import com.cloakentertainment.pokemonline.stats.PokemonStatusCondition;
	import com.cloakentertainment.pokemonline.stats.PokemonStatusConditions;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIPokemonStatusCondition extends UISprite
	{
		[Embed(source="assets/UIPokemonStatusCondition.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _conditionSprite:Bitmap;
		private var _condition:PokemonStatusCondition;
		
		public function UIPokemonStatusCondition(condition:PokemonStatusCondition) 
		{
			super(spriteImage);
			
			_condition = condition;
			
			if(_condition != null) construct();
		}
		
		public function changeCondition(newCondition:PokemonStatusCondition):void
		{
			destroy();
			_condition = newCondition;
			if(_condition != null) construct();
		}
		
		override public function construct():void
		{
			var rectangle:Rectangle; // 32x14
			switch(_condition)
			{
				case PokemonStatusConditions.POISON:
					rectangle = new Rectangle(20 * 0, 0, 20, 8);
					break;
				case PokemonStatusConditions.PARALYSIS:
					rectangle = new Rectangle(20 * 1, 0, 20, 8);
					break;
				case PokemonStatusConditions.SLEEP:
					rectangle = new Rectangle(20 * 2, 0, 20, 8);
					break;
				case PokemonStatusConditions.FREEZE:
					rectangle = new Rectangle(20 * 3, 0, 20, 8);
					break;
				case PokemonStatusConditions.BURN:
					rectangle = new Rectangle(20 * 4, 0, 20, 8);
					break;
				case PokemonStatusConditions.FAINT:
					rectangle = new Rectangle(20 * 6, 0, 20, 8);
					break;
				default:
					throw(new Error("Unknown PokemonStatusCondition " + _condition));
					break;
			}
			
			_conditionSprite = getSprite(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			this.addChild(_conditionSprite);
			
			rectangle = null;
		}
		
		override public function destroy():void
		{
			this.removeChild(_conditionSprite);
			_conditionSprite.bitmapData.dispose();
			_conditionSprite = null;
		}
		
	}

}