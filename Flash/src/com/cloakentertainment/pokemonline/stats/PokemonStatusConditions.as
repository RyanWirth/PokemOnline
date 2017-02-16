package com.cloakentertainment.pokemonline.stats 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonStatusConditions 
	{
		public static const BURN:PokemonStatusCondition = new PokemonStatusCondition("Burn", PokemonStatusConditions.NONVOLATILE);
		public static const FREEZE:PokemonStatusCondition = new PokemonStatusCondition("Freeze", PokemonStatusConditions.NONVOLATILE);
		public static const PARALYSIS:PokemonStatusCondition = new PokemonStatusCondition("Paralysis", PokemonStatusConditions.NONVOLATILE);
		public static const POISON:PokemonStatusCondition = new PokemonStatusCondition("Poison", PokemonStatusConditions.NONVOLATILE);
		public static const BADLYPOISONED:PokemonStatusCondition = new PokemonStatusCondition("Badly Poisoned", PokemonStatusConditions.NONVOLATILE);
		public static const SLEEP:PokemonStatusCondition = new PokemonStatusCondition("Sleep", PokemonStatusConditions.NONVOLATILE);
		public static const FAINT:PokemonStatusCondition = new PokemonStatusCondition("Faint", PokemonStatusConditions.NONVOLATILE);

		public static const CONFUSION:PokemonStatusCondition = new PokemonStatusCondition("Confusion", PokemonStatusConditions.VOLATILE);
		public static const CURSE:PokemonStatusCondition = new PokemonStatusCondition("Curse", PokemonStatusConditions.VOLATILE);
		public static const EMBARGO:PokemonStatusCondition = new PokemonStatusCondition("Embargo", PokemonStatusConditions.VOLATILE);
		public static const ENCORE:PokemonStatusCondition = new PokemonStatusCondition("Encore", PokemonStatusConditions.VOLATILE);
		public static const FLINCH:PokemonStatusCondition = new PokemonStatusCondition("Flinch", PokemonStatusConditions.VOLATILE);
		public static const HEALBLOCK:PokemonStatusCondition = new PokemonStatusCondition("Heal Block", PokemonStatusConditions.VOLATILE);
		public static const IDENTIFICATION:PokemonStatusCondition = new PokemonStatusCondition("Identification", PokemonStatusConditions.VOLATILE);
		public static const INFATUATION:PokemonStatusCondition = new PokemonStatusCondition("Infatuation", PokemonStatusConditions.VOLATILE);
		public static const NIGHTMARE:PokemonStatusCondition = new PokemonStatusCondition("Nightmare", PokemonStatusConditions.VOLATILE);
		public static const PARTIALLYTRAPPED:PokemonStatusCondition = new PokemonStatusCondition("Partially Trapped", PokemonStatusConditions.VOLATILE);
		public static const PERISHSONG:PokemonStatusCondition = new PokemonStatusCondition("Perish Song", PokemonStatusConditions.VOLATILE);
		public static const SEEDING:PokemonStatusCondition = new PokemonStatusCondition("Seeding", PokemonStatusConditions.VOLATILE);
		public static const TAUNT:PokemonStatusCondition = new PokemonStatusCondition("Taunt", PokemonStatusConditions.VOLATILE);
		public static const TELEKINETICLEVITATION:PokemonStatusCondition = new PokemonStatusCondition("Telekinetic Levitation", PokemonStatusConditions.VOLATILE);
		public static const TORMENT:PokemonStatusCondition = new PokemonStatusCondition("Torment", PokemonStatusConditions.VOLATILE);
		public static const TRAPPED:PokemonStatusCondition = new PokemonStatusCondition("Trapped", PokemonStatusConditions.VOLATILE);

		public static const AQUARING:PokemonStatusCondition = new PokemonStatusCondition("Aqua Ring", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const BRACING:PokemonStatusCondition = new PokemonStatusCondition("Bracing", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const CENTEROFATTENTION:PokemonStatusCondition = new PokemonStatusCondition("Center of Attention", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const DEFENSECURL:PokemonStatusCondition = new PokemonStatusCondition("Defense Curl", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const GLOWING:PokemonStatusCondition = new PokemonStatusCondition("Glowing", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const ROOTING:PokemonStatusCondition = new PokemonStatusCondition("Rooting", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const MAGICCOAT:PokemonStatusCondition = new PokemonStatusCondition("Magic Coat", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const MAGNETICLEVITATION:PokemonStatusCondition = new PokemonStatusCondition("Magnetic Levitation", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const MINIMIZE:PokemonStatusCondition = new PokemonStatusCondition("Minimize", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const PROTECTION:PokemonStatusCondition = new PokemonStatusCondition("Protection", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const RECHARGING:PokemonStatusCondition = new PokemonStatusCondition("Recharging", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const SEMIINVULNERABLE:PokemonStatusCondition = new PokemonStatusCondition("Semi-Invulnerable", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const SUBSTITUTE:PokemonStatusCondition = new PokemonStatusCondition("Substitute", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const TAKINGAIM:PokemonStatusCondition = new PokemonStatusCondition("Taking Aim", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const TAKINGINSUNLIGHT:PokemonStatusCondition = new PokemonStatusCondition("Taking in Sunlight", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const WITHDRAWING:PokemonStatusCondition = new PokemonStatusCondition("Withdrawing", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const WHIPPINGUPAWHIRLWIND:PokemonStatusCondition = new PokemonStatusCondition("Whipping up a Whirlwind", PokemonStatusConditions.VOLATILE_BATTLE);
		public static const CLOAKEDINAHARSHLIGHT:PokemonStatusCondition = new PokemonStatusCondition("Cloaked in a Harsh Light", PokemonStatusConditions.VOLATILE_BATTLE);

		public static const NONVOLATILE:String = "nonvolatile";
		public static const VOLATILE:String = "volatile";
		public static const VOLATILE_BATTLE:String = "volatilebattle";
		
		public function PokemonStatusConditions() 
		{
			
		}
		
		public static function getStatusTextFromCondition(condition:PokemonStatusCondition):String
		{
			switch(condition)
			{
				case BURN:
					return "BURN";
					break;
				case FREEZE:
					return "FREEZE";
					break;
				case PARALYSIS:
					return "PARALYSIS";
					break;
				case POISON:
					return "POISON";
					break;
				case BADLYPOISONED:
					return "BADLYPOISONED";
					break;
				case SLEEP:
					return "SLEEP";
					break;
				case FAINT:
					return "FAINT";
					break;
				default:
					return "";
					break;
			}
		}
		
		public static function getStatusConditionFromString(type:String):PokemonStatusCondition
		{
			switch(type)
			{
				case "BURN":
					return BURN;
					break;
				case "FREEZE":
					return FREEZE;
					break;
				case "PARALYSIS":
					return PARALYSIS;
					break;
				case "POISON":
					return POISON;
					break;
				case "BADLYPOISONED":
					return BADLYPOISONED;
					break;
				case "SLEEP":
					return SLEEP;
					break;
				case "FAINT":
					return FAINT;
					break;
				default:
					return null;
					break;
			}
		}
		
	}

}