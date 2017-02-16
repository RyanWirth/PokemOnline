package com.cloakentertainment.pokemonline.world.entity
{
	import com.cloakentertainment.pokemonline.sound.SoundEffect;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.world.entity.AnimationType;
	import com.cloakentertainment.pokemonline.world.entity.EntityManager;
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import com.cloakentertainment.pokemonline.world.map.MapManager;
	import com.cloakentertainment.pokemonline.world.sprite.SAlertEffect;
	import com.cloakentertainment.pokemonline.world.sprite.SDropShadow;
	import com.cloakentertainment.pokemonline.world.sprite.SGrassEffect;
	import com.cloakentertainment.pokemonline.world.sprite.SHalfGrassEffect;
	import com.cloakentertainment.pokemonline.world.WorldManager;
	import starling.events.Event;
	import com.cloakentertainment.pokemonline.world.map.LayerType;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import com.cloakentertainment.pokemonline.Configuration;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class Entity extends Sprite implements IEntity
	{		
		public static const TEXT_FILTER:DropShadowFilter = new DropShadowFilter(Configuration.SPRITE_SCALE / 4, 45, 0x343434, 1, Configuration.SPRITE_SCALE, Configuration.SPRITE_SCALE, 255.0, 1, false, false, false);

		protected var _xTile:int;
		protected var _yTile:int;
		protected var _trainerType:String;
		
		public var isOtherPlayer:Boolean = false;
		public var className:String = "";
		
		private var _name:String;
		private var _animation:MovieClip;
		private var _direction:String;
		private var _animationType:String;
		private var _moving:Boolean = false;
		private var _wasJustMoving:Boolean = false;
		private var _moveSpeed:Number = 3.75;
		private var _mobile:Boolean = true;
		private var _nameTF:TextField;
		private var _busy:Boolean;
		
		private var _atlas:TextureAtlas;
		
		private var _nextMove:String = "";
		
		private var _dropShadow:SDropShadow;
		private var _grassEffect:SHalfGrassEffect;
		private var _alertEffect:SAlertEffect;
		
		public var destroyed:Boolean = false;
		
		public function Entity(atlas:TextureAtlas, trainerType:String, name:String = "", initialAnimation:String = AnimationType.WALK_DOWN)
		{
			_atlas = atlas;
			_trainerType = trainerType;
			_name = name;
			
			
			animate(initialAnimation);
			stop();
		}
		
		public function get TRAINER_TYPE():String
		{
			return _trainerType;
		}
		
		public function get NAME():String
		{
			return _name;
		}
		
		public function set currentFrame(frame:int):void
		{
			if (_animation)
			{
				_animation.currentFrame = frame;
			}
		}
		
		public function get currentFrame():int
		{
			if (_animation) return _animation.currentFrame;
			else return 1;
		}
		
		public function setName(name:String, showNametag:Boolean = true):void
		{
			_name = name;
			
			if (!showNametag)
			{
				if (_nameTF)
				{
					this.removeChild(_nameTF);
					_nameTF.dispose();
					_nameTF = null;
				}
				return;
			}
			
			if (_name != "" && _nameTF == null)
			{
				_nameTF = new TextField(ChunkManager.TILE_SIZE * 2, 8 * Configuration.SPRITE_SCALE, _name, Configuration.TEXT_FORMAT_WHITE.font, 8 * Configuration.SPRITE_SCALE, 0xFFFFFF, false);
				_nameTF.nativeFilters = [TEXT_FILTER];
				this.addChild(_nameTF);
				_nameTF.x = -_nameTF.width * 0.5;
				_nameTF.y = -_nameTF.height * 2;
			} else if (_nameTF != null) _nameTF.text = _name;
		}
		
		public function destroy():void
		{
			_atlas = null;
			if (_nameTF)
			{
				this.removeChild(_nameTF);
				_nameTF.dispose();
				_nameTF = null;
			}
			destroyAnimation();
			destroyDropShadow();
			destroyGrass();
			destroyAlertEffect();
			destroyed = true;
			
			dispose();
		}
		
		public function get DIRECTION():String
		{
			return _direction;
		}
		
		public function setMobility(mobile:Boolean):void
		{
			_mobile = mobile;
		}
		
		public function get MOBILE():Boolean
		{
			return _mobile;
		}
		
		public function updateLocation(xTile:int, yTile:int):void
		{
			_xTile = xTile;
			_yTile = yTile;
		}
		
		private var _nextXTileOverride:int = -1;
		private var _nextYTileOverride:int = -1;
		public function setNextMove(direction:String, xTileOverride:int, yTileOverride:int):void
		{
			_nextMove = direction;
			_nextXTileOverride = xTileOverride;
			_nextYTileOverride = yTileOverride;
			
			if (!_moving) checkForNextMove();
		}
		
		public function checkForNextMove():void
		{
			// Check for a jumpDir (as in, forcing the player to move in a certain direction
			var jumpDir:String = MapManager.getTilePropertyAt(X_TILE, Y_TILE, "jumpDir");
			if (jumpDir == "") MapManager.getTilePropertyAt(X_TILE, Y_TILE, "jumpDir", LayerType.MIDDLE);
			
			if (jumpDir != "") EntityManager.moveEntity(this, jumpDir, _nextXTileOverride, _nextYTileOverride);
			else if (_nextMove != "") EntityManager.moveEntity(this, _nextMove, _nextXTileOverride, _nextYTileOverride);
			else TweenLite.delayedCall(5, stop, null, true);
			
			_nextXTileOverride = _nextYTileOverride = -1;
		}
		
		public function turn(direction:String):void
		{
			var animTypeData:Array = _animationType.split("_");
			animate(animTypeData[0] + "_" + direction);
			stop();
		}
		
		public function setBusy(busy:Boolean):void
		{
			_busy = busy;
		}
		
		public function isBusy():Boolean
		{
			return _busy;
		}
		
		public function overrideMoving(moving:Boolean):void
		{
			_moving = moving;
		}
		
		public function animate(animationType:String):void
		{
			if (_animation) destroyAnimation();
			if (destroyed) return;
			_animationType = animationType;
			_direction = getDirectionFromAnimationType(_animationType);
			
			var right:Boolean = false;
			var fps:int = 8;
			var xOffset:int = 0;
			
			if (animationType == "water_left") xOffset = -5 * Configuration.SPRITE_SCALE;
			else if (animationType == "water_right") xOffset = 5 * Configuration.SPRITE_SCALE;
			
			// Check if this is a "right" animatinoType and if it is, use the left version and flip the sprite
			if (animationType.indexOf("right") != -1)
			{
				right = true;
				animationType = animationType.replace("right", "left");
			}
			if (animationType.indexOf("run") != -1)
			{
				fps = 12;
				if (_atlas.getTextures(animationType).length == 0) 
				{
					animationType = String("walk_" + _direction).replace("right", "left");
					fps = 14;
				}
			}
			
			_animation = new MovieClip(_atlas.getTextures(animationType), fps);
			_animation.loop = true;
			_animation.smoothing = TextureSmoothing.NONE;
			
			if (right)
			{
				_animation.scaleX *= -1;
				_animation.x = _animation.width * 0.5;
			}
			else
			{
				_animation.x = _animation.width * -0.5;
			}
			_animation.x += xOffset;
			_animation.y = (_animation.height - ChunkManager.TILE_SIZE) * -1 - ChunkManager.TILE_SIZE * 0.08;
			
			WorldManager.JUGGLER.add(_animation);
			_animation.play();
			this.addChildAt(_animation, 0);
		}
		
		private var _isTrainer:Boolean = false;
		private var _viewDistance:int = 1;
		public function setIsTrainer(viewDistance:int):void
		{
			if (viewDistance == -1)
			{
				_isTrainer = false;
				return;
			}
			
			_isTrainer = true;
			_viewDistance = viewDistance;
		}
		
		public function isTrainer():Boolean
		{
			return _isTrainer;
		}
		
		public function get viewDistance():int
		{
			return _viewDistance;
		}
		
		/** Animates the Entity to move up half a tile, then back down. */
		private var _jumping:Boolean = false;
		public function jump():void
		{
			destroyDropShadow();
			_jumping = true;
			stopRunning();
			
			SoundManager.playSoundEffect(SoundEffect.JUMP_LEDGE);
			
			_dropShadow = new SDropShadow(destroyDropShadow);
			_dropShadow.x = _dropShadow.width * -0.5;
			_dropShadow.y = ChunkManager.TILE_SIZE - _dropShadow.height;
			WorldManager.JUGGLER.add(_dropShadow);
			this.addChildAt(_dropShadow, 0);
			
			var duration:Number = 60 / MOVE_SPEED;
			TweenLite.to(_animation, duration, {ease: Linear.easeOut, y: _animation.y - ChunkManager.TILE_SIZE * 0.75, onComplete: finishJump, useFrames: true});
		}
		
		private function finishJump():void
		{
			var duration:Number = 60 / MOVE_SPEED;
			TweenLite.to(_animation, duration, {onComplete: changeDropShadowToDust, ease: Linear.easeIn, y: _animation.y + ChunkManager.TILE_SIZE * 0.75, useFrames: true});
		}
		
		private function changeDropShadowToDust():void
		{
			_jumping = false;
			if (_dropShadow)
			{
				//TweenLite.delayedCall(60, _dropShadow.play, null, true);
				_dropShadow.currentFrame = 2;
				this.setChildIndex(_dropShadow, this.numChildren - 1);
				_dropShadow.play();
			}
		}
		
		public function isJumping():Boolean
		{
			return _jumping;
		}
		
		private function destroyDropShadow():void
		{
			if (_dropShadow)
			{
				WorldManager.JUGGLER.remove(_dropShadow);
				this.removeChild(_dropShadow);
				_dropShadow.dispose();
				_dropShadow = null;
			}
		}
		
		public function enterGrass():void
		{
			destroyGrass();
			
			TweenLite.delayedCall(20, createGrass, null, true);
		}
		
		private function createGrass():void
		{
			_grassEffect = new SHalfGrassEffect();
			_grassEffect.x = _grassEffect.width * -0.5;
			_grassEffect.y = ChunkManager.TILE_SIZE - _grassEffect.height;
			this.addChild(_grassEffect);
		}
		
		public function alertEffect(callback:Function = null, params:Array = null):void
		{
			if (_alertEffect) return;
			
			_alertEffect = new SAlertEffect();
			_alertEffect.x = _alertEffect.width * -0.5;
			_alertEffect.y = -_alertEffect.height - 2 * Configuration.SPRITE_SCALE;
			_alertEffect.alpha = 0;
			this.addChild(_alertEffect);
			params.push(callback);
			TweenLite.to(_alertEffect, 0.25, { alpha:1, y: -_alertEffect.height - 4 * Configuration.SPRITE_SCALE, onComplete:finishAlertEffect, onCompleteParams:[params] } );
		}
		
		private function finishAlertEffect(callbackParams:Array = null):void
		{
			TweenLite.delayedCall(1, destroyAlertEffect, [callbackParams]);
		}
		
		private function destroyAlertEffect(callbackParams:Array = null):void
		{
			if (_alertEffect)
			{
				this.removeChild(_alertEffect);
				_alertEffect.dispose();
				_alertEffect = null;
			}
			
			if (callbackParams != null)
			{
				var callback:Function = callbackParams.pop();
				TweenLite.delayedCall(0.1, callback, callbackParams);
				callback = null;
			}
			callbackParams = null;
		}
		
		private var _running:Boolean = false;
		public function startRunning(keepWalkAnimation:Boolean = false):void
		{
			if (_running) return;
			_running = true;
			animate((keepWalkAnimation == false ? "run" : "walk") + "_" + DIRECTION);
			_moveSpeed = 7;
		}
		
		public function get isRunning():Boolean
		{
			return _running;
		}
		
		public function stopRunning():void
		{
			if (!_running) return;
			_running = false;
			animate("walk_" + DIRECTION);
			_moveSpeed = 3.75;
		}
		
		public function setMoveSpeed(moveSpeed:Number):void
		{
			_moveSpeed = moveSpeed;
		}
		
		public function destroyGrass():void
		{
			TweenLite.killDelayedCallsTo(createGrass);
			
			if (!_grassEffect) return;
			
			this.removeChild(_grassEffect);
			_grassEffect.dispose();
			_grassEffect = null;
		}
		
		private function destroyAnimation():void
		{
			if (!_animation) return;
			
			WorldManager.JUGGLER.remove(_animation);
			this.removeChild(_animation);
			_animation.dispose();
			_animation = null;
		}
		
		private function getDirectionFromAnimationType(animationType:String):String
		{
			var animData:Array = animationType.split("_");
			return String(animData[1]);
		}
		
		public function stop():void
		{
			if (_animation) _animation.stop();
		}
		
		public function play():void
		{
			TweenLite.killDelayedCallsTo(stop);
			if (_animation) _animation.play();
		}
		
		public function playOnce():void
		{
			if (_animation)
			{
				_animation.addEventListener(Event.COMPLETE, finishPlaying);
				_animation.loop = false;
				_animation.play();
			}
		}
		
		private function finishPlaying():void
		{
			if (_animation)
			{
				_animation.removeEventListener(Event.COMPLETE, finishPlaying);
				_animation.loop = true;
				_animation.stop();
			}
		}
		
		public function get Y_TILE():int
		{
			return _yTile;
		}
		
		public function get X_TILE():int
		{
			return _xTile;
		}
		
		public function get MOVE_SPEED():Number
		{
			return _moveSpeed;
		}
		
		public function startMoving():void
		{
			_nextMove = "";
			_moving = true;
		}
		
		public function finishMoving(startJM:Boolean = true):void
		{
			_moving = false;
			
			if (startJM) startJustMoving();
			
			checkForNextMove();
		}
		
		public function startJustMoving():void
		{
			_wasJustMoving = true;
			TweenLite.delayedCall(0.1, finishJustMoving);
		}
		
		public function finishJustMoving():void
		{
			_wasJustMoving = false;
		}
		
		public function get MOVING():Boolean
		{
			return _moving;
		}
		
		public function get JUST_MOVING():Boolean
		{
			return _wasJustMoving;
		}
		
		public function get NEXT_MOVE():String
		{
			return _nextMove;
		}
	
	}

}