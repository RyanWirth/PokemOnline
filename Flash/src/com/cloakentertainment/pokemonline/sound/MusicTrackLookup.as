package com.cloakentertainment.pokemonline.sound 
{
	/**
	 * ...
	 * @author PROWNE
	 */
	public class MusicTrackLookup 
	{
		
		public function MusicTrackLookup() 
		{
			
		}
		
		public static function getTrackNameFromID(trackName:int):String
		{
			var filename:String = "";
			switch(trackName)
			{
				case 101:
					filename = "101-title-demo-departure-from-houen-district-";
					break;
				case 102:
					filename = "102-title-demo-2-double-battle-";
					break;
				case 103:
					filename = "103-title-main-theme-";
					break;
				case 104:
					filename = "104-opening-selection";
					break;
				case 105:
					filename = "105-mishiro-town";
					break;
				case 106:
					filename = "106-odamaki-research-institute";
					break;
				case 107:
					filename = "107-haruka";
					break;
				case 108:
					filename = "108-help-";
					break;
				case 109:
					filename = "109-battle-wild-pokemon";
					break;
				case 110:
					filename = "110-wild-pokemon-defeated-";
					break;
				case 111:
					filename = "111-route-101";
					break;
				case 112:
					filename = "112-kotoki-town";
					break;
				case 113:
					filename = "113-pokemon-center";
					break;
				case 114:
					filename = "114-recovery";
					break;
				case 115:
					filename = "115-look-tanpanko-statue";
					break;
				case 116:
					filename = "116-look-miniskirt";
					break;
				case 117:
					filename = "117-battle-trainer";
					break;
				case 118:
					filename = "118-trainer-defeated-";
					break;
				case 119:
					filename = "119-improvement";
					break;
				case 120:
					filename = "120-touka-city";
					break;
				case 121:
					filename = "121-come-along";
					break;
				case 122:
					filename = "122-route-104";
					break;
				case 123:
					filename = "123-touka-forest";
					break;
				case 124:
					filename = "124-magma-team-appears-";
					break;
				case 125:
					filename = "125-battle-aqua-magma-team";
					break;
				case 126:
					filename = "126-aqua-magma-team-defeated-";
					break;
				case 127:
					filename = "127-kanazumi-city";
					break;
				case 128:
					filename = "128-trainers-school";
					break;
				case 129:
					filename = "129-crossing-the-sea";
					break;
				case 130:
					filename = "130-muro-town";
					break;
				case 131:
					filename = "131-look-a-girl";
					break;
				case 132:
					filename = "132-kaina-city";
					break;
				case 133:
					filename = "133-marine-science-museum";
					break;
				case 134:
					filename = "134-route-110";
					break;
				case 135:
					filename = "135-cycling";
					break;
				case 136:
					filename = "136-game-corner";
					break;
				case 137:
					filename = "137-hit-";
					break;
				case 138:
					filename = "138-regret";
					break;
				case 139:
					filename = "139-bd-time";
					break;
				case 140:
					filename = "140-great-success-";
					break;
				case 141:
					filename = "141-shidake-town";
					break;
				case 142:
					filename = "142-route-113";
					break;
				case 143:
					filename = "143-my-twins";
					break;
				case 144:
					filename = "144-hajitsuge-town";
					break;
				case 145:
					filename = "145-rope-way";
					break;
				case 146:
					filename = "146-chimney-mountain";
					break;
				case 147:
					filename = "147-look-giant";
					break;
				case 148:
					filename = "148-route-111";
					break;
				case 149:
					filename = "149-gym";
					break;
				case 150:
					filename = "150-battle-gym-leader";
					break;
				case 151:
					filename = "151-gym-leader-defeated-";
					break;
				case 152:
					filename = "152-get-badge";
					break;
				case 153:
					filename = "153-get-work-machine";
					break;
				case 154:
					filename = "154-surfing";
					break;
				case 201:
					filename = "201-route-119";
					break;
				case 202:
					filename = "202-hiwamaki-city";
					break;
				case 203:
					filename = "203-route-120";
					break;
				case 204:
					filename = "204-interviewer";
					break;
				case 205:
					filename = "205-safari-zone";
					break;
				case 206:
					filename = "206-look-gentleman";
					break;
				case 207:
					filename = "207-minamo-city";
					break;
				case 208:
					filename = "208-art-museum";
					break;
				case 209:
					filename = "209-failure";
					break;
				case 210:
					filename = "210-yuuki";
					break;
				case 211:
					filename = "211-battle-yuuki-haruka";
					break;
				case 212:
					filename = "212-evolution";
					break;
				case 213:
					filename = "213-congratulations-on-your-evolution";
					break;
				case 214:
					filename = "214-friendly-shop";
					break;
				case 215:
					filename = "215-okuribi-mountain";
					break;
				case 216:
					filename = "216-look-saikikka";
					break;
				case 217:
					filename = "217-look-occult-maniac";
					break;
				case 218:
					filename = "218-okuribi-mountain-outer-wall";
					break;
				case 219:
					filename = "219-hiding-place";
					break;
				case 220:
					filename = "220-get-tool";
					break;
				case 221:
					filename = "221-aqua-team-appears-";
					break;
				case 222:
					filename = "222-battle-aqua-magma-team-s-leader";
					break;
				case 223:
					filename = "223-waking-up-the-ancient-pokemon";
					break;
				case 224:
					filename = "224-drought";
					break;
				case 225:
					filename = "225-heavy-rain";
					break;
				case 226:
					filename = "226-dive";
					break;
				case 227:
					filename = "227-rune-city";
					break;
				case 228:
					filename = "228-small-shrine-mezame";
					break;
				case 229:
					filename = "229-battle-ancient-pokemon";
					break;
				case 230:
					filename = "230-look-bikini-sister";
					break;
				case 231:
					filename = "231-saiyuu-city";
					break;
				case 232:
					filename = "232-get-berry";
					break;
				case 233:
					filename = "233-contest-lobby";
					break;
				case 234:
					filename = "234-contest-";
					break;
				case 235:
					filename = "235-result-announcement";
					break;
				case 236:
					filename = "236-contest-championship";
					break;
				case 237:
					filename = "237-ohure-no-sekishitsu";
					break;
				case 238:
					filename = "238-battle-rejirock-rejiaisu-rejisuchiru";
					break;
				case 239:
					filename = "239-trick-mansion";
					break;
				case 240:
					filename = "240-suterarebune";
					break;
				case 241:
					filename = "241-battle-tower";
					break;
				case 242:
					filename = "242-champion-road";
					break;
				case 243:
					filename = "243-look-elite-trainer";
					break;
				case 244:
					filename = "244-big-four-appears-";
					break;
				case 245:
					filename = "245-battle-big-four";
					break;
				case 246:
					filename = "246-champion-daigo";
					break;
				case 247:
					filename = "247-decisive-battle-daigo";
					break;
				case 248:
					filename = "248-daigo-is-defeated-";
					break;
				case 249:
					filename = "249-glory-room";
					break;
				case 250:
					filename = "250-induction-into-the-hall-of-fame";
					break;
				case 251:
					filename = "251-ending";
					break;
				case 252:
					filename = "252-the-end";
					break;
				case 253:
					filename = "253-trick-master";
					break;
				case 254:
					filename = "254-slateport-city";
					break;
				case 255:
					filename = "255-steven-stone";
					break;
				case 256:
					filename = "256-triumph-effect";
					break;
				case 257:
					filename = "257-pokemart";
					break;
				case 0:
					filename = "battle-vs-mew";
					break;
				default:
					throw(new Error("Unknown Music Track ID " + trackName));
					break;
			}
			
			return filename + ".mp3";
		}
		
	}

}