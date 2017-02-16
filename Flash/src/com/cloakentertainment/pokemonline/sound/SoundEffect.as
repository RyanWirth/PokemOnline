package com.cloakentertainment.pokemonline.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import com.cloakentertainment.pokemonline.sound.effects.*;
	import flash.media.SoundTransform;
	import com.cloakentertainment.pokemonline.Configuration;
	/**
	 * ...
	 * @author PROWNE
	 */
	public class SoundEffect
	{
		
		public static const ENTER_KEY_BING:String = "SEEnterKeyBing";
		public static const POKEMON_FAINT:String = "SEPokemonFaint";
		public static const MOVE_INEFFECTIVE_DAMAGE:String = "SEMoveIneffectiveDamage";
		public static const MOVE_SUPEREFFECTIVE_DAMAGE:String = "SEMoveSuperEffectiveDamage";
		public static const MOVE_NORMAL_DAMAGE:String = "SEMoveNormalDamage";
		public static const LOW_HEALTH_WARNING:String = "SEPokemonLowHealthWarning";
		public static const DOOR_OPEN:String = "SEDoorOpen";
		public static const DOOR_SLIDE_OPEN:String = "SEDoorSlideOpen";
		public static const JUMP_LEDGE:String = "SEJumpLedge";
		public static const ALERT:String = "SEAlert";
		public static const IN_GAME_MENU_OPEN:String = "SEInGameMenuOpen";
		public static const PC_TURN_ON:String = "SEPCTurnOn";
		public static const PC_LOG_ON:String = "SEPCLogOn";
		public static const PC_TURN_OFF:String = "SEPCTurnOff";
		public static const POKEMART_BUY:String = "SEPokemartBuy";
		
		private var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		private var sound:Sound;
		private var _callback:Function;
		
		public function SoundEffect(soundClass:Class, callback:Function = null) 
		{
			_callback = callback;
			
			sound = new soundClass() as Sound;
			soundTransform = new SoundTransform(Configuration.MASTER_VOLUME * Configuration.SOUND_EFFECTS_VOLUME);
			soundChannel = sound.play();
			soundChannel.soundTransform = soundTransform;
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);
		}
		
		private function soundComplete(e:Event):void
		{
			sound = null;
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete, false);
			soundChannel = null;
			soundTransform = null;
			
			if (_callback != null) _callback();
			_callback = null;
		}
		
		public function set CALLBACK(callback:Function):void
		{
			_callback = callback;
		}
		
	}

}