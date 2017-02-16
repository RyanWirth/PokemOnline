package com.cloakentertainment.pokemonline.sound
{
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.sound.effects.*;
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	TweenPlugin.activate([VolumePlugin]);
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SoundManager
	{
		public static const REFERENCES:Array = [SEAlert, SEDoorOpen, SEDoorSlideOpen, SEEnterKeyBing, SEInGameMenuOpen, SEJumpLedge, SEMoveIneffectiveDamage, SEMoveNormalDamage, SEMoveSuperEffectiveDamage, SEPCLogOn, SEPCTurnOff, SEPCTurnOn, SEPokemonFaint, SEPokemonLowHealthWarning];
		
		public function SoundManager()
		{
		
		}
		
		private static var _musicSoundChannel:SoundChannel;
		private static var _musicSoundTransform:SoundTransform;
		private static var _musicSoundClip:Sound;
		private static var _tempMusicSoundClip:Sound;
		private static var _tempMusicSoundTransform:SoundTransform;
		private static var _tempMusicSoundChannel:SoundChannel;
		private static var _currentlyPlayingTrack:String = "";
		private static var _currentlyPlayingTrackID:int = 0;
		
		public static function get CURRENTLY_PLAYING_MUSIC_TRACK():int
		{
			return _currentlyPlayingTrackID;
		}
		
		public static function delayPlayMusicTrack(trackID:int, trackLoops:int, returnToPreviousTrack:Boolean, fastFade:Boolean = false, delay:Number = 1):void
		{
			TweenLite.delayedCall(delay, playMusicTrack, [trackID, trackLoops, returnToPreviousTrack, fastFade]);
		}
		
		public static function playMusicTrack(trackID:int, trackLoops:int = 0, returnToPreviousTrack:Boolean = false, fastFade:Boolean = false):void
		{
			if (Configuration.MUSIC == false)
				return;
			
			if (_returnToTrack == 0 && returnToPreviousTrack) _returnToTrack = _currentlyPlayingTrackID;
				
			_currentlyPlayingTrackID = trackID;
			
			var filename:String = MusicTrackLookup.getTrackNameFromID(trackID);
			if (filename == _currentlyPlayingTrack)
				return;
			_currentlyPlayingTrack = filename;
			if (_musicSoundClip || _tempMusicSoundClip)
			{
				// We're currently playing a song
				if (_tempMusicSoundClip)
					copyOverMusicChannels();
				TweenLite.killTweensOf(_musicSoundTransform);
				TweenLite.to(_musicSoundTransform, !fastFade ? 2.5 : 0.25, {volume: 0, onUpdate: updateMusicTransform, onUpdateParams: [_musicSoundTransform, _musicSoundChannel]});
			}
			
			_tempMusicSoundClip = new Sound();
			_tempMusicSoundChannel = new SoundChannel();
			_tempMusicSoundTransform = new SoundTransform(0, 0);
			
			var urlRequest:URLRequest = new URLRequest(Configuration.WEB_ASSETS_URL + "/music/" + filename);
			_tempMusicSoundClip.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);
			_tempMusicSoundClip.load(urlRequest);
			_tempMusicSoundChannel = _tempMusicSoundClip.play(0, trackLoops == 0 ? int.MAX_VALUE : trackLoops, _tempMusicSoundTransform);
			
			// When the new music track has completed playing, play _returnToTrack.
			if (returnToPreviousTrack)	_tempMusicSoundChannel.addEventListener(Event.SOUND_COMPLETE, finishPlaying, false, 0, true);
			
			TweenLite.killDelayedCallsTo(checkMusicTrackPosition);
			if (trackID == 108)
			{
				// This track has to look at a specific point, update tweenlite to check the position
				TweenLite.delayedCall(0.1, checkMusicTrackPosition);
			}
			
			TweenLite.to(_tempMusicSoundTransform, !fastFade ? 5 : 0.5, {volume: Configuration.MASTER_VOLUME * Configuration.MUSIC_VOLUME, onUpdate: updateMusicTransform, onUpdateParams: [_tempMusicSoundTransform, _tempMusicSoundChannel], onComplete: finishTransitioningTrackOut});
		}
		
		private static function checkMusicTrackPosition():void
		{
			if (_tempMusicSoundChannel)
			{
				if (CURRENTLY_PLAYING_MUSIC_TRACK == 108)
				{
					if (_tempMusicSoundChannel.position >= 14313) 
					{
						_tempMusicSoundChannel.stop();
						_tempMusicSoundChannel = _tempMusicSoundClip.play(2000, 0, _tempMusicSoundTransform);
					}
				}
			} else
			{
				if (CURRENTLY_PLAYING_MUSIC_TRACK == 108)
				{
					if (_musicSoundChannel.position >= 14313) 
					{
						_musicSoundChannel.stop();
						_musicSoundChannel = _musicSoundClip.play(2000, 0, _musicSoundTransform);
					}
				}
			}
			
			TweenLite.delayedCall(0.1, checkMusicTrackPosition);
		}
		
		private static var _returnToTrack:int = 0;
		private static function finishPlaying(e:Event):void
		{
			_musicSoundChannel.removeEventListener(Event.SOUND_COMPLETE, finishPlaying);
			if(_tempMusicSoundChannel) _tempMusicSoundChannel.removeEventListener(Event.SOUND_COMPLETE, finishPlaying);
			
			playMusicTrack(_returnToTrack);
			_returnToTrack = 0;
		}
		
		private static function ioError(e:IOErrorEvent):void
		{
			// Silence!
		}
		
		public static function updateMusicVolumeLevels():void
		{
			if (_tempMusicSoundTransform)
			{
				if (TweenLite.getTweensOf(_tempMusicSoundTransform).length == 0) _tempMusicSoundTransform.volume = Configuration.MASTER_VOLUME * Configuration.MUSIC_VOLUME;
				
				_tempMusicSoundChannel.soundTransform = _tempMusicSoundTransform;
			}
			
			if (_musicSoundTransform)
			{
				if (TweenLite.getTweensOf(_musicSoundTransform).length == 0) _musicSoundTransform.volume = Configuration.MASTER_VOLUME * Configuration.MUSIC_VOLUME;
				
				_musicSoundChannel.soundTransform = _musicSoundTransform;
			}
		}
		
		private static function copyOverMusicChannels():void
		{
			_musicSoundChannel = _tempMusicSoundChannel;
			_musicSoundClip = _tempMusicSoundClip;
			_musicSoundTransform = _tempMusicSoundTransform;
		}
		
		private static var _musicTrackOut:Boolean = true;
		
		private static function finishTransitioningTrackOut():void
		{
			copyOverMusicChannels();
			
			updateMusicVolumeLevels();
			
			_tempMusicSoundTransform = null;
			_tempMusicSoundChannel = null;
			_tempMusicSoundClip = null;
		}
		
		private static function updateMusicTransform(transform:SoundTransform, channel:SoundChannel):void
		{
			if (!channel) return;
			channel.soundTransform = transform;
		}
		
		public static function playPokemonCry(pokemonID:int):void
		{
			if (Configuration.SOUND_EFFECTS == false)
				return;
			
			var id:String = (pokemonID < 100 ? "0" : "") + (pokemonID < 10 ? "0" : "") + pokemonID;
			var urlRequest:URLRequest = new URLRequest(Configuration.WEB_ASSETS_URL + "/cry/" + id + "Cry.mp3");
			var _crySoundClip:Sound = new Sound();
			var _crySoundChannel:SoundChannel = new SoundChannel();
			var _crySoundTransform:SoundTransform = new SoundTransform(Configuration.MASTER_VOLUME * Configuration.SOUND_EFFECTS_VOLUME);
			_crySoundClip.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);
			_crySoundChannel.soundTransform = _crySoundTransform;
			_crySoundClip.load(urlRequest);
			_crySoundChannel = _crySoundClip.play();
		}
		
		private static var lowhealthwarningplaying:Boolean = false;
		private static var lowhealthwarningstop:Boolean = false;
		private static var lowhealthwarning:SoundEffect;
		
		public static function playLowHealthWarning():void
		{
			if (lowhealthwarningstop)
			{
				lowhealthwarning = null;
				lowhealthwarningstop = false;
				lowhealthwarningplaying = false;
				return;
			}
			
			if (lowhealthwarningplaying)
				return;
			lowhealthwarningplaying = true;
			
			lowhealthwarning = playSoundEffect(SoundEffect.LOW_HEALTH_WARNING, continueLowHealthWarning);
		}
		
		private static function continueLowHealthWarning():void
		{
			lowhealthwarning = null;
			lowhealthwarningplaying = false;
			playLowHealthWarning();
		}
		
		public static function stopLowHealthWarning():void
		{
			if (lowhealthwarningplaying == false)
				return;
			
			lowhealthwarningstop = true;
		}
		
		public static function playEnterKeySoundEffect():void
		{
			playSoundEffect(SoundEffect.ENTER_KEY_BING);
		}
		
		public static function playSoundEffect(soundEffect:String, callback:Function = null):SoundEffect
		{
			if (Configuration.SOUND_EFFECTS == false)
				return null;
				
			var c:Class = getDefinitionByName("com.cloakentertainment.pokemonline.sound.effects." + soundEffect) as Class;
			var se:SoundEffect = new c() as SoundEffect;
			c = null;
			
			if (callback != null)
				se.CALLBACK = callback;
			
			return se;
		}
	
	}

}