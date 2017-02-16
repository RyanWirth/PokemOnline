package com.cloakentertainment.pokemonline.ui 
{
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIIntroMenu extends Sprite implements UIElement
	{	
		private var _background:UIIntroMenuBackground;
		private var _logo:UIIntroMenuLogo;
		
		private var _pressStart:UIIntroMenuPressStart;
		
		public function UIIntroMenu() 
		{
			construct();
		}
		
		public function construct():void
		{
			SoundManager.playMusicTrack(103);
			
			_background = new UIIntroMenuBackground();
			this.addChild(_background);
			
			_logo = new UIIntroMenuLogo();
			_logo.y = 3 * Configuration.SPRITE_SCALE;
			_logo.x = Configuration.VIEWPORT.width / 2 - _logo.width / 2;
			this.addChild(_logo);
			
			_pressStart = new UIIntroMenuPressStart();
			_pressStart.y = 105 * Configuration.SPRITE_SCALE;
			_pressStart.x = Configuration.VIEWPORT.width / 2 - _pressStart.width / 2;
			this.addChild(_pressStart);
			
			KeyboardManager.registerKey(Configuration.ENTER_KEY, pressStart, InputGroups.MAIN_MENU, true);
			if (Configuration.ENTER_KEY != 13) KeyboardManager.registerKey(13, pressStart, InputGroups.MAIN_MENU, true);
		}
		
		private function pressStart():void
		{
			Configuration.FADE_OUT_AND_IN(createMainMenu, true);
		}
		
		private function createMainMenu():void
		{
			destroy();
			
			Configuration.createMenu(MenuType.MAIN);
		}
		
		public function destroy():void
		{
			this.removeChild(_background);
			_background.destroy();
			_background = null;
			
			this.removeChild(_logo);
			_logo.destroy();
			_logo = null;
			
			this.removeChild(_pressStart);
			_pressStart.destroy();
			_pressStart = null;
			
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressStart);
			KeyboardManager.unregisterKey(13, pressStart);
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
		
	}

}