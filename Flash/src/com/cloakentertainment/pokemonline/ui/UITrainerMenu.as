package com.cloakentertainment.pokemonline.ui
{
	import adobe.utils.CustomActions;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.ui.MessageCenter;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.trainer.TrainerBadge;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UITrainerMenu extends UISprite implements UIElement
	{
		[Embed(source="assets/UITrainerMenu.png")]
		private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		public static const TEXT_FORMAT_RIGHT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x606060, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		private var front:Sprite;
		private var back:Sprite;
		
		private var _background:Bitmap;
		private var _front_bitmap:Bitmap;
		private var _back_bitmap:Bitmap;
		private var trainericon:UITrainerSprite;
		private var trainerName:TextField;
		private var trainerID:TextField;
		private var trainerMoney:TextField;
		private var trainerMoneyVal:TextField;
		private var trainerPokedex:TextField;
		private var trainerPokedexVal:TextField;
		private var trainerTime:TextField;
		private var trainerTimeVal:TextField;
		
		public function UITrainerMenu()
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			var male:Boolean = TrainerType.isMale(Configuration.ACTIVE_TRAINER.TYPE);
			
			_background = getSprite(male ? 0 : 240, 140, 240, 160);
			this.addChild(_background);
			
			front = new Sprite();
			_front_bitmap = getSprite(0, 0, 228, 140);
			_front_bitmap.x = (240 - 228) / 2 * Configuration.SPRITE_SCALE;
			_front_bitmap.y = (160 - 140) / 2 * Configuration.SPRITE_SCALE;
			front.addChild(_front_bitmap);
			trainericon = new UITrainerSprite(Configuration.ACTIVE_TRAINER.TYPE);
			trainericon.x = 148 * Configuration.SPRITE_SCALE + _front_bitmap.x + trainericon.width / 2;
			trainericon.y = 38 * Configuration.SPRITE_SCALE + _front_bitmap.y + trainericon.height / 2;
			front.addChild(trainericon);
			trainerID = new TextField();
			Configuration.setupTextfield(trainerID, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			trainerID.width = 84 * Configuration.SPRITE_SCALE;
			trainerID.x = 146 * Configuration.SPRITE_SCALE;
			trainerID.y = 20 * Configuration.SPRITE_SCALE;
			trainerID.text = "IDNo." + GUID.getConcatID(Configuration.ACTIVE_TRAINER.UID);
			front.addChild(trainerID);
			trainerName = new TextField();
			Configuration.setupTextfield(trainerName, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			trainerName.width = 96 * Configuration.SPRITE_SCALE;
			trainerName.x = 24 * Configuration.SPRITE_SCALE;
			trainerName.y = 44 * Configuration.SPRITE_SCALE;
			trainerName.text = "NAME: " + Configuration.ACTIVE_TRAINER.NAME;
			front.addChild(trainerName);
			trainerMoney = new TextField();
			Configuration.setupTextfield(trainerMoney, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			trainerMoney.x = 24 * Configuration.SPRITE_SCALE;
			trainerMoney.y = 68 * Configuration.SPRITE_SCALE;
			trainerMoney.width = 88 * Configuration.SPRITE_SCALE;
			trainerMoney.text = "MONEY";
			front.addChild(trainerMoney);
			trainerMoneyVal = new TextField();
			Configuration.setupTextfield(trainerMoneyVal, TEXT_FORMAT_RIGHT, Configuration.TEXT_FILTER);
			trainerMoneyVal.x = 24 * Configuration.SPRITE_SCALE;
			trainerMoneyVal.y = 68 * Configuration.SPRITE_SCALE;
			trainerMoneyVal.width = 112 * Configuration.SPRITE_SCALE;
			trainerMoneyVal.text = "₽" + Configuration.ACTIVE_TRAINER.MONEY;
			front.addChild(trainerMoneyVal);
			trainerPokedex = new TextField();
			Configuration.setupTextfield(trainerPokedex, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			trainerPokedex.x = 24 * Configuration.SPRITE_SCALE;
			trainerPokedex.y = 84 * Configuration.SPRITE_SCALE;
			trainerPokedex.width = 88 * Configuration.SPRITE_SCALE;
			trainerPokedex.text = "POKéDEX";
			front.addChild(trainerPokedex);
			trainerPokedexVal = new TextField();
			Configuration.setupTextfield(trainerPokedexVal, TEXT_FORMAT_RIGHT, Configuration.TEXT_FILTER);
			trainerPokedexVal.x = 24 * Configuration.SPRITE_SCALE;
			trainerPokedexVal.y = 84 * Configuration.SPRITE_SCALE;
			trainerPokedexVal.width = 112 * Configuration.SPRITE_SCALE;
			trainerPokedexVal.text = Configuration.ACTIVE_TRAINER.numberOfSeenPokemon().toString();
			front.addChild(trainerPokedexVal);
			if (Configuration.ACTIVE_TRAINER.getState("POKéDEX") != "true") trainerPokedex.visible = trainerPokedexVal.visible = false;
			trainerTime = new TextField();
			Configuration.setupTextfield(trainerTime, Configuration.TEXT_FORMAT, Configuration.TEXT_FILTER);
			trainerTime.x = 24 * Configuration.SPRITE_SCALE;
			trainerTime.y = 100 * Configuration.SPRITE_SCALE;
			trainerTime.width = 88 * Configuration.SPRITE_SCALE;
			trainerTime.text = "TIME";
			front.addChild(trainerTime);
			trainerTimeVal = new TextField();
			Configuration.setupTextfield(trainerTimeVal, TEXT_FORMAT_RIGHT, Configuration.TEXT_FILTER);
			trainerTimeVal.x = 24 * Configuration.SPRITE_SCALE;
			trainerTimeVal.y = 100 * Configuration.SPRITE_SCALE;
			trainerTimeVal.width = 112 * Configuration.SPRITE_SCALE;
			trainerTimeVal.text = Configuration.ACTIVE_TRAINER.TIME_PLAYED_HHMM;
			front.addChild(trainerTimeVal);
			
			drawBadge(TrainerBadge.STONE);
			drawBadge(TrainerBadge.KNUCKLE);
			drawBadge(TrainerBadge.DYNAMO);
			drawBadge(TrainerBadge.HEAT);
			drawBadge(TrainerBadge.BALANCE);
			drawBadge(TrainerBadge.FEATHER);
			drawBadge(TrainerBadge.MIND);
			drawBadge(TrainerBadge.RAIN);
			
			
			back = new Sprite();
			_back_bitmap = getSprite(228, 0, 228, 140);
			_back_bitmap.x = _front_bitmap.x;
			_back_bitmap.y = _front_bitmap.y;
			back.addChild(_back_bitmap);
			
			this.addChild(front);
			this.addChild(back);
			back.visible = false;
			
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressEnter, InputGroups.TRAINER, true);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.TRAINER, true);
		}
		private var badges:Vector.<UIBadgeSprite> = new Vector.<UIBadgeSprite>();
		private function drawBadge(badgeType:String):void
		{
			if (Configuration.ACTIVE_TRAINER.hasBadge(badgeType))
			{
				var badge:UIBadgeSprite = new UIBadgeSprite(badgeType);
				badge.y = 124 * Configuration.SPRITE_SCALE;
				badge.x = 32 * Configuration.SPRITE_SCALE;
				if (badgeType == TrainerBadge.KNUCKLE) badge.x += 24 * 1 * Configuration.SPRITE_SCALE;
				else if (badgeType == TrainerBadge.DYNAMO) badge.x += 24 * 2 * Configuration.SPRITE_SCALE;
				else if (badgeType == TrainerBadge.HEAT) badge.x += 24 * 3 * Configuration.SPRITE_SCALE;
				else if (badgeType == TrainerBadge.BALANCE) badge.x += 24 * 4 * Configuration.SPRITE_SCALE;
				else if (badgeType == TrainerBadge.FEATHER) badge.x += 24 * 5 * Configuration.SPRITE_SCALE;
				else if (badgeType == TrainerBadge.MIND) badge.x += 24 * 6 * Configuration.SPRITE_SCALE;
				else if (badgeType == TrainerBadge.RAIN) badge.x += 24 * 7 * Configuration.SPRITE_SCALE;
				badges.push(badge);
				front.addChild(badge);
			}
		}
		
		
		private var frontHeight:int = 0;
		private var backHeight:int = 0;
		private var frontY:int = 0;
		private var animating:Boolean = false;
		private function pressEnter():void
		{
			if (animating) return;
			
			if (back.visible == false)
			{
				// animate the flip
				frontY = front.y;
				frontHeight = front.height;
				animating = true;
				TweenLite.to(front, 0.25, {y:(160 - 2)/2 * Configuration.SPRITE_SCALE, height:2 * Configuration.SPRITE_SCALE, onComplete:midwayTweenToBack } );
			} else
			{
				animating = true;
				Configuration.FADE_OUT_AND_IN(finishPressCancel);
			}
		}
		
		private function midwayTweenToBack():void
		{
			front.visible = false;
			front.height = frontHeight;
			back.visible = true;
			backHeight = back.height;
			back.height = 2 * Configuration.SPRITE_SCALE;
			back.y = front.y;
			front.y = frontY;
			TweenLite.to(back, 0.25, {y:frontY, height:backHeight, onComplete:finishTweenToBack } );
		}
		
		private function finishTweenToBack():void
		{
			animating = false;
		}
		
		private function midwayTweenToFront():void
		{
			back.visible = false;
			back.height = backHeight;
			front.visible = true;
			frontHeight = front.height;
			front.height = 2 * Configuration.SPRITE_SCALE;
			front.y = back.y;
			back.y = frontY;
			TweenLite.to(front, 0.25, { y:frontY, height:frontHeight, onComplete:finishTweenToBack } );
		}
		
		private function pressCancel():void
		{
			if (animating) return;
			
			if (back.visible == false)
			{
				animating = true;
				Configuration.FADE_OUT_AND_IN(finishPressCancel);
			} else
			{
				animating = true;
				TweenLite.to(back, 0.25, { y:(160 - 2) / 2 * Configuration.SPRITE_SCALE, height:2 * Configuration.SPRITE_SCALE, onComplete:midwayTweenToFront } );
			}
		}
		
		private function finishPressCancel():void
		{
			destroy();
			Configuration.createMenu(MenuType.IN_GAME_MENU);
		}
		
		override public function destroy():void
		{
			this.removeChild(_background);
			_background = null;
			
			front.removeChild(_front_bitmap);
			front.removeChild(trainericon);
			_front_bitmap = null;
			trainericon.destroy();
			trainericon = null;
			front.removeChild(trainerName);
			front.removeChild(trainerMoney);
			front.removeChild(trainerMoneyVal);
			front.removeChild(trainerPokedex);
			front.removeChild(trainerPokedexVal);
			front.removeChild(trainerID);
			front.removeChild(trainerTime);
			front.removeChild(trainerTimeVal);
			trainerName = trainerMoney = trainerMoneyVal = trainerPokedex = trainerPokedexVal = trainerID = trainerTime = trainerTimeVal = null;
			for (var i:int = 0; i < badges.length; i++)
			{
				front.removeChild(badges[i]);
				badges[i].destroy();
				badges[i] = null;
			}
			badges.splice(0, badges.length);
			
			back.removeChild(_back_bitmap);
			_back_bitmap = null;
			
			this.removeChild(back);
			this.removeChild(front);
			back = null;
			front = null;
			
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}