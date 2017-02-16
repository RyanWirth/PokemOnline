package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.trainer.TrainerType;
	import com.cloakentertainment.pokemonline.world.PlayerManager;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIMapMenu extends UISprite
	{
		[Embed(source="assets/UIMapMenu.png")]
        private static const embeddedImage:Class;
		private static const spriteImage:Bitmap = new embeddedImage() as Bitmap;
		
		private var _background:Bitmap;
		private var _cursor:UIMapMenuCursor;
		private var _icon:Bitmap;
		
		private var _readout:UITextBox;
		private var _title:UITextBox;
		
		public function UIMapMenu():void
		{
			super(spriteImage);
			
			construct();
		}
		
		override public function construct():void
		{
			_background = getSprite(0, 0, 240, 160);
			this.addChild(_background);
			
			_icon = getSprite(Configuration.ACTIVE_TRAINER.TYPE == TrainerType.HERO_FEMALE ? 15 : 0, 161, 14, 14);
			this.addChild(_icon);
			_cursorPoint = convertWorldCoordinatesToMapCoordinates(PlayerManager.LAST_OVERWORLD_XTILE, PlayerManager.LAST_OVERWORLD_YTILE);
			_icon.x = _cursorPoint.x * 8 * Configuration.SPRITE_SCALE - _icon.width * 0.5;
			_icon.y = _cursorPoint.y * 8 * Configuration.SPRITE_SCALE - _icon.height * 0.5;
			
			_cursor = new UIMapMenuCursor();
			this.addChild(_cursor);
			_cursor.x = _cursorPoint.x * 8 * Configuration.SPRITE_SCALE;
			_cursor.y = _cursorPoint.y * 8 * Configuration.SPRITE_SCALE;
			
			KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.MAP_MENU, false);
			KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.MAP_MENU, false);
			KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.MAP_MENU, false);
			KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.MAP_MENU, false);
			KeyboardManager.registerKey(Configuration.CANCEL_KEY, pressCancel, InputGroups.MAP_MENU, true);
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.MAP_MENU);
			
			Configuration.MENU_OPEN = true;
			
			_readout = new UITextBox(getRegionNameFromCursorPoint(), 112, 32, 7, 7, 7, 7);
			_readout.x = Configuration.VIEWPORT.width - _readout.width;
			_readout.y = Configuration.VIEWPORT.height - _readout.height;
			this.addChild(_readout);
			
			_title = new UITextBox("    HOENN", 72, 32, 7, 7, 7, 7);
			_title.x = Configuration.VIEWPORT.width - _title.width;
			_title.y = 0;
			this.addChild(_title);
			
			checkKeys();
		}
		
		private function checkKeys():void
		{
			TweenLite.delayedCall(1, checkKeys, null, true);
			if (KeyboardManager.isKeyPressed(Configuration.LEFT_KEY)) pressLeft();
			if (KeyboardManager.isKeyPressed(Configuration.RIGHT_KEY)) pressRight();
			if (KeyboardManager.isKeyPressed(Configuration.UP_KEY)) pressUp();
			if (KeyboardManager.isKeyPressed(Configuration.DOWN_KEY)) pressDown();
		}
		
		private var _cursorPoint:Point;
		private var _animatingX:Boolean = false;
		private var _animatingY:Boolean = false;
		private function pressLeft():void
		{
			if (_animatingX) return;
			if (_cursorPoint.x > 1.5)
			{
				_cursorPoint.x--;
				animateCursorX();
			}
		}
		
		private function animateCursorX():void
		{
			_animatingX = true;
			_readout.TEXT_FIELD.text = getRegionNameFromCursorPoint();
			TweenLite.to(_cursor, 0.1, { x:_cursorPoint.x * 8 * Configuration.SPRITE_SCALE, onComplete:finishAnimatingX, ease:Linear.easeNone } );
		}
		
		private function finishAnimatingX():void
		{
			_animatingX = false;
		}
		
		private function animateCursorY():void
		{
			_animatingY = true;
			_readout.TEXT_FIELD.text = getRegionNameFromCursorPoint();
			TweenLite.to(_cursor, 0.1, { y:_cursorPoint.y * 8 * Configuration.SPRITE_SCALE, onComplete:finishAnimatingY, ease:Linear.easeNone } );
		}
		
		private function finishAnimatingY():void
		{
			_animatingY = false;
		}
		
		private function pressRight():void
		{
			if (_animatingX) return;
			if (_cursorPoint.x < 28.5)
			{
				_cursorPoint.x++;
				animateCursorX();
			}
		}
		
		private function pressUp():void
		{
			if (_animatingY) return;
			if (_cursorPoint.y > 2.5)
			{
				_cursorPoint.y--;
				animateCursorY();
			}
		}
		
		private function pressDown():void
		{
			if (_animatingY) return;
			if (_cursorPoint.y < 17.5)
			{
				_cursorPoint.y++;
				animateCursorY();
			}
		}
		
		private function convertWorldCoordinatesToMapCoordinates(xTile:Number, yTile:Number):Point
		{
			var p:Point = new Point(0, 0);
			p.x = Math.floor((xTile-8) / 24) + 1.5;
			p.y = Math.floor(yTile / 24) + 1.5;
			return p;
		}
		
		private function getRegionNameFromCursorPoint():String
		{
			var x:int = _cursorPoint.x - 0.5;
			var y:int = _cursorPoint.y - 1.5;
			
			if (x == 4 && y == 1) return "FALLARBOR TOWN";
			else if (x == 6 && y == 4) return 'LAVARIDGE TOWN';
			else if (x == 5 && y == 7) return "VERDANTURF TOWN";
			else if (x == 5 && y == 12) return "LITTLEROOT TOWN";
			else if (x == 5 && y == 10) return "OLDALE TOWN";
			else if (x == 3 && y == 15) return "DEWFORD TOWN";
			else if (x == 18 && y == 11) return "PACIFIDLOG TOWN";
			else if (x == 1 && (y == 6 || y == 7)) return "RUSTBORO CITY";
			else if (x == 2 && y == 10) return "PETALBURG CITY";
			else if (y == 7 && (x == 9 || x == 10)) return "MAUVILLE CITY";
			else if (x == 9 && (y == 11 || y == 12)) return "SLATEPORT CITY";
			else if (x == 13 && y == 1) return "FORTREE CITY";
			else if (y == 4 && (y == 19 || y == 20)) return "LILYCOVE CITY";
			else if (x == 22 && y == 8) return "SOOTOPOLIS CITY";
			else if (y == 6 && (x == 25 || x == 26)) return "MOSSDEEP CITY";
			else if (x == 28 && (y == 9 || y == 10)) return "EVER GRANDE CITY";
			else if (x == 5 && y == 11) return "ROUTE 101";
			else if (y == 10 && (x == 3 || x == 4)) return "ROUTE 102";
			else if (y == 9 && (x == 5 || x == 6 || x == 7 || x == 8)) return "ROUTE 103";
			else if (x == 1 && (y == 8 || y == 9 || y == 10)) return "ROUTE 104";
			else if (x == 1 && (y == 11 || y == 12 || y == 13)) return "ROUTE 105";
			else if (y == 14 && (x == 1 || x == 2 || x == 3)) return "ROUTE 106";
			else if (y == 15 && (x == 6 || x == 5 || x == 4)) return "ROUTE 107";
			else if (y == 15 && (x == 7 || x == 8)) return "ROUTE 108";
			else if (x == 9 && (y == 15 || y == 14 || y == 13)) return "ROUTE 109";
			else if (x == 9 && (y == 10 || y == 9 || y == 8)) return "ROUTE 110";
			else if (x == 9 && y <= 6) return "ROUTE 111";
			else if (y == 4 && (x == 7 || x == 8)) return "ROUTE 112";
			else if (y == 1 && (x == 5 || x == 6 || x == 7 || x == 8)) return "ROUTE 113";
			else if (x == 3 && y == 1) return "ROUTE 114";
			else if (x == 2 && (y == 1 || y == 2 || y == 3)) return "ROUTE 114";
			else if (x == 1 && (y == 3 || y == 4 || y == 5)) return "ROUTE 115";
			else if (y == 6 && (x == 2 || x == 3 || x == 4 || x == 5)) return "ROUTE 116";
			else if (y == 7 && (x == 6 || x == 7 || x == 8)) return "ROUTE 117";
			else if (y == 7 && (x == 11 || x == 12)) return "ROUTE 118";
			else if (x == 12 && y <= 6) return "ROUTE 119";
			else if (x == 14 && (y == 2 || y == 3 || y == 4)) return "ROUTE 120";
			else if (y == 4 && (x == 15 || x == 16 || x == 17 || x == 18)) return "ROUTE 121";
			else if (x == 17 && (y == 5 || y == 6)) return "ROUTE 122";
			else if (y == 7 && (x == 13 || x == 14 || x == 15 || x  == 16 || x == 17)) return "ROUTE 123";
			else if (x >= 21 && x <= 24 && y >= 4 && y <= 6) return "ROUTE 124";
			else if (x >= 25 && x <= 26 && y >= 4 && y <= 5) return "ROUTE 125";
			else if (x >= 21 && x <= 23 && y >= 7 && y <= 9) return "ROUTE 126";
			else if (x >= 24 && y <= 9 && x <= 26 && y >= 7) return "ROUTE 127";
			else if (y == 10 && (x == 24 || x == 25 || x == 26 || x == 27)) return "ROUTE 128";
			else if (y == 11 && (x == 26 || x == 25)) return "ROUTE 129";
			else if (y == 11 && (x == 24 || x == 23 || x == 22)) return "ROUTE 130";
			else if (y == 11 && (x == 21 || x == 20 || x == 19)) return "ROUTE 131";
			else if (y == 11 && (x == 17 || x == 16)) return "ROUTE 132";
			else if (y == 11 && (x == 15 || x == 14 || x == 13)) return "ROUTE 133";
			else if (y == 11 && (x == 12 || x == 11 || x == 10)) return "ROUTE 134";
			else return "";
		}
		
		private function pressCancel():void
		{
			SoundManager.playEnterKeySoundEffect();
			TweenLite.killDelayedCallsTo(checkKeys);
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressLeft);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressRight);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressUp);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressDown);
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, pressCancel);
			
			Configuration.FADE_OUT_AND_IN(destroy);
		}
		
		override public function destroy():void
		{
			TweenLite.killTweensOf(_cursor);
			
			this.removeChild(_background);
			this.removeChild(_cursor);
			this.removeChild(_icon);
			this.removeChild(_readout);
			this.removeChild(_title);
			
			_title.destroy();
			_readout.destroy();
			_cursor.destroy();
			_background.bitmapData.dispose();
			_icon.bitmapData.dispose();
			
			Configuration.MENU_OPEN = false;
			
			_readout = _title = null;
			_cursor = null;
			_background = _icon = null;
			
			KeyboardManager.enableInputGroup(InputGroups.OVERWORLD);
			if (Configuration.STAGE.contains(this)) Configuration.STAGE.removeChild(this);
		}
	
	}

}