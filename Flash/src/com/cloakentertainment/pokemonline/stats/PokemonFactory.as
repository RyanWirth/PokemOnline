package com.cloakentertainment.pokemonline.stats
{
	import GUID;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class PokemonFactory
	{
		public static const pokemon:Array = [[1, "Bulbasaur"], [2, "Ivysaur"], [3, "Venusaur"], [4, "Charmander"], [5, "Charmeleon"], [6, "Charizard"], [7, "Squirtle"], [8, "Wartortle"], [9, "Blastoise"], [10, "Caterpie"], [11, "Metapod"], [12, "Butterfree"], [13, "Weedle"], [14, "Kakuna"], [15, "Beedrill"], [16, "Pidgey"], [17, "Pidgeotto"], [18, "Pidgeot"], [19, "Rattata"], [20, "Raticate"], [21, "Spearow"], [22, "Fearow"], [23, "Ekans"], [24, "Arbok"], [25, "Pikachu"], [26, "Raichu"], [27, "Sandshrew"], [28, "Sandslash"], [29, "Nidoran♀"], [30, "Nidorina"], [31, "Nidoqueen"], [32, "Nidoran♂‚"], [33, "Nidorino"], [34, "Nidoking"], [35, "Clefairy"], [36, "Clefable"], [37, "Vulpix"], [38, "Ninetales"], [39, "Jigglypuff"], [40, "Wigglytuff"], [41, "Zubat"], [42, "Golbat"], [43, "Oddish"], [44, "Gloom"], [45, "Vileplume"], [46, "Paras"], [47, "Parasect"], [48, "Venonat"], [49, "Venomoth"], [50, "Diglett"], [51, "Dugtrio"], [52, "Meowth"], [53, "Persian"], [54, "Psyduck"], [55, "Golduck"], [56, "Mankey"], [57, "Primeape"], [58, "Growlithe"], [59, "Arcanine"], [60, "Poliwag"], [61, "Poliwhirl"], [62, "Poliwrath"], [63, "Abra"], [64, "Kadabra"], [65, "Alakazam"], [66, "Machop"], [67, "Machoke"], [68, "Machamp"], [69, "Bellsprout"], [70, "Weepinbell"], [71, "Victreebel"], [72, "Tentacool"], [73, "Tentacruel"], [74, "Geodude"], [75, "Graveler"], [76, "Golem"], [77, "Ponyta"], [78, "Rapidash"], [79, "Slowpoke"], [80, "Slowbro"], [81, "Magnemite"], [82, "Magneton"], [83, "Farfetch&#39;d"], [84, "Doduo"], [85, "Dodrio"], [86, "Seel"], [87, "Dewgong"], [88, "Grimer"], [89, "Muk"], [90, "Shellder"], [91, "Cloyster"], [92, "Gastly"], [93, "Haunter"], [94, "Gengar"], [95, "Onix"], [96, "Drowzee"], [97, "Hypno"], [98, "Krabby"], [99, "Kingler"], [100, "Voltorb"], [101, "Electrode"], [102, "Exeggcute"], [103, "Exeggutor"], [104, "Cubone"], [105, "Marowak"], [106, "Hitmonlee"], [107, "Hitmonchan"], [108, "Lickitung"], [109, "Koffing"], [110, "Weezing"], [111, "Rhyhorn"], [112, "Rhydon"], [113, "Chansey"], [114, "Tangela"], [115, "Kangaskhan"], [116, "Horsea"], [117, "Seadra"], [118, "Goldeen"], [119, "Seaking"], [120, "Staryu"], [121, "Starmie"], [122, "Mr. Mime"], [123, "Scyther"], [124, "Jynx"], [125, "Electabuzz"], [126, "Magmar"], [127, "Pinsir"], [128, "Tauros"], [129, "Magikarp"], [130, "Gyarados"], [131, "Lapras"], [132, "Ditto"], [133, "Eevee"], [134, "Vaporeon"], [135, "Jolteon"], [136, "Flareon"], [137, "Porygon"], [138, "Omanyte"], [139, "Omastar"], [140, "Kabuto"], [141, "Kabutops"], [142, "Aerodactyl"], [143, "Snorlax"], [144, "Articuno"], [145, "Zapdos"], [146, "Moltres"], [147, "Dratini"], [148, "Dragonair"], [149, "Dragonite"], [150, "Mewtwo"], [151, "Mew"], [152, "Chikorita"], [153, "Bayleef"], [154, "Meganium"], [155, "Cyndaquil"], [156, "Quilava"], [157, "Typhlosion"], [158, "Totodile"], [159, "Croconaw"], [160, "Feraligatr"], [161, "Sentret"], [162, "Furret"], [163, "Hoothoot"], [164, "Noctowl"], [165, "Ledyba"], [166, "Ledian"], [167, "Spinarak"], [168, "Ariados"], [169, "Crobat"], [170, "Chinchou"], [171, "Lanturn"], [172, "Pichu"], [173, "Cleffa"], [174, "Igglybuff"], [175, "Togepi"], [176, "Togetic"], [177, "Natu"], [178, "Xatu"], [179, "Mareep"], [180, "Flaaffy"], [181, "Ampharos"], [182, "Bellossom"], [183, "Marill"], [184, "Azumarill"], [185, "Sudowoodo"], [186, "Politoed"], [187, "Hoppip"], [188, "Skiploom"], [189, "Jumpluff"], [190, "Aipom"], [191, "Sunkern"], [192, "Sunflora"], [193, "Yanma"], [194, "Wooper"], [195, "Quagsire"], [196, "Espeon"], [197, "Umbreon"], [198, "Murkrow"], [199, "Slowking"], [200, "Misdreavus"], [201, "Unown"], [202, "Wobbuffet"], [203, "Girafarig"], [204, "Pineco"], [205, "Forretress"], [206, "Dunsparce"], [207, "Gligar"], [208, "Steelix"], [209, "Snubbull"], [210, "Granbull"], [211, "Qwilfish"], [212, "Scizor"], [213, "Shuckle"], [214, "Heracross"], [215, "Sneasel"], [216, "Teddiursa"], [217, "Ursaring"], [218, "Slugma"], [219, "Magcargo"], [220, "Swinub"], [221, "Piloswine"], [222, "Corsola"], [223, "Remoraid"], [224, "Octillery"], [225, "Delibird"], [226, "Mantine"], [227, "Skarmory"], [228, "Houndour"], [229, "Houndoom"], [230, "Kingdra"], [231, "Phanpy"], [232, "Donphan"], [233, "Porygon2"], [234, "Stantler"], [235, "Smeargle"], [236, "Tyrogue"], [237, "Hitmontop"], [238, "Smoochum"], [239, "Elekid"], [240, "Magby"], [241, "Miltank"], [242, "Blissey"], [243, "Raikou"], [244, "Entei"], [245, "Suicune"], [246, "Larvitar"], [247, "Pupitar"], [248, "Tyranitar"], [249, "Lugia"], [250, "Ho-Oh"], [251, "Celebi"], [252, "Treecko"], [253, "Grovyle"], [254, "Sceptile"], [255, "Torchic"], [256, "Combusken"], [257, "Blaziken"], [258, "Mudkip"], [259, "Marshtomp"], [260, "Swampert"], [261, "Poochyena"], [262, "Mightyena"], [263, "Zigzagoon"], [264, "Linoone"], [265, "Wurmple"], [266, "Silcoon"], [267, "Beautifly"], [268, "Cascoon"], [269, "Dustox"], [270, "Lotad"], [271, "Lombre"], [272, "Ludicolo"], [273, "Seedot"], [274, "Nuzleaf"], [275, "Shiftry"], [276, "Taillow"], [277, "Swellow"], [278, "Wingull"], [279, "Pelipper"], [280, "Ralts"], [281, "Kirlia"], [282, "Gardevoir"], [283, "Surskit"], [284, "Masquerain"], [285, "Shroomish"], [286, "Breloom"], [287, "Slakoth"], [288, "Vigoroth"], [289, "Slaking"], [290, "Nincada"], [291, "Ninjask"], [292, "Shedinja"], [293, "Whismur"], [294, "Loudred"], [295, "Exploud"], [296, "Makuhita"], [297, "Hariyama"], [298, "Azurill"], [299, "Nosepass"], [300, "Skitty"], [301, "Delcatty"], [302, "Sableye"], [303, "Mawile"], [304, "Aron"], [305, "Lairon"], [306, "Aggron"], [307, "Meditite"], [308, "Medicham"], [309, "Electrike"], [310, "Manectric"], [311, "Plusle"], [312, "Minun"], [313, "Volbeat"], [314, "Illumise"], [315, "Roselia"], [316, "Gulpin"], [317, "Swalot"], [318, "Carvanha"], [319, "Sharpedo"], [320, "Wailmer"], [321, "Wailord"], [322, "Numel"], [323, "Camerupt"], [324, "Torkoal"], [325, "Spoink"], [326, "Grumpig"], [327, "Spinda"], [328, "Trapinch"], [329, "Vibrava"], [330, "Flygon"], [331, "Cacnea"], [332, "Cacturne"], [333, "Swablu"], [334, "Altaria"], [335, "Zangoose"], [336, "Seviper"], [337, "Lunatone"], [338, "Solrock"], [339, "Barboach"], [340, "Whiscash"], [341, "Corphish"], [342, "Crawdaunt"], [343, "Baltoy"], [344, "Claydol"], [345, "Lileep"], [346, "Cradily"], [347, "Anorith"], [348, "Armaldo"], [349, "Feebas"], [350, "Milotic"], [351, "Castform"], [352, "Kecleon"], [353, "Shuppet"], [354, "Banette"], [355, "Duskull"], [356, "Dusclops"], [357, "Tropius"], [358, "Chimecho"], [359, "Absol"], [360, "Wynaut"], [361, "Snorunt"], [362, "Glalie"], [363, "Spheal"], [364, "Sealeo"], [365, "Walrein"], [366, "Clamperl"], [367, "Huntail"], [368, "Gorebyss"], [369, "Relicanth"], [370, "Luvdisc"], [371, "Bagon"], [372, "Shelgon"], [373, "Salamence"], [374, "Beldum"], [375, "Metang"], [376, "Metagross"], [377, "Regirock"], [378, "Regice"], [379, "Registeel"], [380, "Latias"], [381, "Latios"], [382, "Kyogre"], [383, "Groudon"], [384, "Rayquaza"], [385, "Jirachi"], [386, "Deoxys"]];
		
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/1.json', mimeType = 'application/octet-stream')]
		private static const Pokemon1:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/2.json', mimeType = 'application/octet-stream')]
		private static const Pokemon2:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/3.json', mimeType = 'application/octet-stream')]
		private static const Pokemon3:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/4.json', mimeType = 'application/octet-stream')]
		private static const Pokemon4:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/5.json', mimeType = 'application/octet-stream')]
		private static const Pokemon5:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/6.json', mimeType = 'application/octet-stream')]
		private static const Pokemon6:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/7.json', mimeType = 'application/octet-stream')]
		private static const Pokemon7:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/8.json', mimeType = 'application/octet-stream')]
		private static const Pokemon8:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/9.json', mimeType = 'application/octet-stream')]
		private static const Pokemon9:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/10.json', mimeType = 'application/octet-stream')]
		private static const Pokemon10:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/11.json', mimeType = 'application/octet-stream')]
		private static const Pokemon11:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/12.json', mimeType = 'application/octet-stream')]
		private static const Pokemon12:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/13.json', mimeType = 'application/octet-stream')]
		private static const Pokemon13:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/14.json', mimeType = 'application/octet-stream')]
		private static const Pokemon14:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/15.json', mimeType = 'application/octet-stream')]
		private static const Pokemon15:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/16.json', mimeType = 'application/octet-stream')]
		private static const Pokemon16:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/17.json', mimeType = 'application/octet-stream')]
		private static const Pokemon17:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/18.json', mimeType = 'application/octet-stream')]
		private static const Pokemon18:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/19.json', mimeType = 'application/octet-stream')]
		private static const Pokemon19:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/20.json', mimeType = 'application/octet-stream')]
		private static const Pokemon20:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/21.json', mimeType = 'application/octet-stream')]
		private static const Pokemon21:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/22.json', mimeType = 'application/octet-stream')]
		private static const Pokemon22:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/23.json', mimeType = 'application/octet-stream')]
		private static const Pokemon23:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/24.json', mimeType = 'application/octet-stream')]
		private static const Pokemon24:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/25.json', mimeType = 'application/octet-stream')]
		private static const Pokemon25:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/26.json', mimeType = 'application/octet-stream')]
		private static const Pokemon26:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/27.json', mimeType = 'application/octet-stream')]
		private static const Pokemon27:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/28.json', mimeType = 'application/octet-stream')]
		private static const Pokemon28:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/29.json', mimeType = 'application/octet-stream')]
		private static const Pokemon29:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/30.json', mimeType = 'application/octet-stream')]
		private static const Pokemon30:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/31.json', mimeType = 'application/octet-stream')]
		private static const Pokemon31:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/32.json', mimeType = 'application/octet-stream')]
		private static const Pokemon32:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/33.json', mimeType = 'application/octet-stream')]
		private static const Pokemon33:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/34.json', mimeType = 'application/octet-stream')]
		private static const Pokemon34:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/35.json', mimeType = 'application/octet-stream')]
		private static const Pokemon35:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/36.json', mimeType = 'application/octet-stream')]
		private static const Pokemon36:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/37.json', mimeType = 'application/octet-stream')]
		private static const Pokemon37:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/38.json', mimeType = 'application/octet-stream')]
		private static const Pokemon38:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/39.json', mimeType = 'application/octet-stream')]
		private static const Pokemon39:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/40.json', mimeType = 'application/octet-stream')]
		private static const Pokemon40:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/41.json', mimeType = 'application/octet-stream')]
		private static const Pokemon41:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/42.json', mimeType = 'application/octet-stream')]
		private static const Pokemon42:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/43.json', mimeType = 'application/octet-stream')]
		private static const Pokemon43:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/44.json', mimeType = 'application/octet-stream')]
		private static const Pokemon44:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/45.json', mimeType = 'application/octet-stream')]
		private static const Pokemon45:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/46.json', mimeType = 'application/octet-stream')]
		private static const Pokemon46:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/47.json', mimeType = 'application/octet-stream')]
		private static const Pokemon47:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/48.json', mimeType = 'application/octet-stream')]
		private static const Pokemon48:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/49.json', mimeType = 'application/octet-stream')]
		private static const Pokemon49:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/50.json', mimeType = 'application/octet-stream')]
		private static const Pokemon50:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/51.json', mimeType = 'application/octet-stream')]
		private static const Pokemon51:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/52.json', mimeType = 'application/octet-stream')]
		private static const Pokemon52:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/53.json', mimeType = 'application/octet-stream')]
		private static const Pokemon53:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/54.json', mimeType = 'application/octet-stream')]
		private static const Pokemon54:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/55.json', mimeType = 'application/octet-stream')]
		private static const Pokemon55:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/56.json', mimeType = 'application/octet-stream')]
		private static const Pokemon56:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/57.json', mimeType = 'application/octet-stream')]
		private static const Pokemon57:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/58.json', mimeType = 'application/octet-stream')]
		private static const Pokemon58:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/59.json', mimeType = 'application/octet-stream')]
		private static const Pokemon59:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/60.json', mimeType = 'application/octet-stream')]
		private static const Pokemon60:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/61.json', mimeType = 'application/octet-stream')]
		private static const Pokemon61:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/62.json', mimeType = 'application/octet-stream')]
		private static const Pokemon62:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/63.json', mimeType = 'application/octet-stream')]
		private static const Pokemon63:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/64.json', mimeType = 'application/octet-stream')]
		private static const Pokemon64:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/65.json', mimeType = 'application/octet-stream')]
		private static const Pokemon65:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/66.json', mimeType = 'application/octet-stream')]
		private static const Pokemon66:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/67.json', mimeType = 'application/octet-stream')]
		private static const Pokemon67:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/68.json', mimeType = 'application/octet-stream')]
		private static const Pokemon68:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/69.json', mimeType = 'application/octet-stream')]
		private static const Pokemon69:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/70.json', mimeType = 'application/octet-stream')]
		private static const Pokemon70:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/71.json', mimeType = 'application/octet-stream')]
		private static const Pokemon71:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/72.json', mimeType = 'application/octet-stream')]
		private static const Pokemon72:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/73.json', mimeType = 'application/octet-stream')]
		private static const Pokemon73:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/74.json', mimeType = 'application/octet-stream')]
		private static const Pokemon74:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/75.json', mimeType = 'application/octet-stream')]
		private static const Pokemon75:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/76.json', mimeType = 'application/octet-stream')]
		private static const Pokemon76:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/77.json', mimeType = 'application/octet-stream')]
		private static const Pokemon77:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/78.json', mimeType = 'application/octet-stream')]
		private static const Pokemon78:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/79.json', mimeType = 'application/octet-stream')]
		private static const Pokemon79:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/80.json', mimeType = 'application/octet-stream')]
		private static const Pokemon80:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/81.json', mimeType = 'application/octet-stream')]
		private static const Pokemon81:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/82.json', mimeType = 'application/octet-stream')]
		private static const Pokemon82:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/83.json', mimeType = 'application/octet-stream')]
		private static const Pokemon83:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/84.json', mimeType = 'application/octet-stream')]
		private static const Pokemon84:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/85.json', mimeType = 'application/octet-stream')]
		private static const Pokemon85:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/86.json', mimeType = 'application/octet-stream')]
		private static const Pokemon86:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/87.json', mimeType = 'application/octet-stream')]
		private static const Pokemon87:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/88.json', mimeType = 'application/octet-stream')]
		private static const Pokemon88:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/89.json', mimeType = 'application/octet-stream')]
		private static const Pokemon89:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/90.json', mimeType = 'application/octet-stream')]
		private static const Pokemon90:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/91.json', mimeType = 'application/octet-stream')]
		private static const Pokemon91:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/92.json', mimeType = 'application/octet-stream')]
		private static const Pokemon92:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/93.json', mimeType = 'application/octet-stream')]
		private static const Pokemon93:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/94.json', mimeType = 'application/octet-stream')]
		private static const Pokemon94:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/95.json', mimeType = 'application/octet-stream')]
		private static const Pokemon95:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/96.json', mimeType = 'application/octet-stream')]
		private static const Pokemon96:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/97.json', mimeType = 'application/octet-stream')]
		private static const Pokemon97:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/98.json', mimeType = 'application/octet-stream')]
		private static const Pokemon98:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/99.json', mimeType = 'application/octet-stream')]
		private static const Pokemon99:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/100.json', mimeType = 'application/octet-stream')]
		private static const Pokemon100:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/101.json', mimeType = 'application/octet-stream')]
		private static const Pokemon101:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/102.json', mimeType = 'application/octet-stream')]
		private static const Pokemon102:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/103.json', mimeType = 'application/octet-stream')]
		private static const Pokemon103:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/104.json', mimeType = 'application/octet-stream')]
		private static const Pokemon104:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/105.json', mimeType = 'application/octet-stream')]
		private static const Pokemon105:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/106.json', mimeType = 'application/octet-stream')]
		private static const Pokemon106:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/107.json', mimeType = 'application/octet-stream')]
		private static const Pokemon107:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/108.json', mimeType = 'application/octet-stream')]
		private static const Pokemon108:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/109.json', mimeType = 'application/octet-stream')]
		private static const Pokemon109:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/110.json', mimeType = 'application/octet-stream')]
		private static const Pokemon110:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/111.json', mimeType = 'application/octet-stream')]
		private static const Pokemon111:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/112.json', mimeType = 'application/octet-stream')]
		private static const Pokemon112:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/113.json', mimeType = 'application/octet-stream')]
		private static const Pokemon113:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/114.json', mimeType = 'application/octet-stream')]
		private static const Pokemon114:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/115.json', mimeType = 'application/octet-stream')]
		private static const Pokemon115:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/116.json', mimeType = 'application/octet-stream')]
		private static const Pokemon116:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/117.json', mimeType = 'application/octet-stream')]
		private static const Pokemon117:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/118.json', mimeType = 'application/octet-stream')]
		private static const Pokemon118:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/119.json', mimeType = 'application/octet-stream')]
		private static const Pokemon119:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/120.json', mimeType = 'application/octet-stream')]
		private static const Pokemon120:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/121.json', mimeType = 'application/octet-stream')]
		private static const Pokemon121:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/122.json', mimeType = 'application/octet-stream')]
		private static const Pokemon122:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/123.json', mimeType = 'application/octet-stream')]
		private static const Pokemon123:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/124.json', mimeType = 'application/octet-stream')]
		private static const Pokemon124:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/125.json', mimeType = 'application/octet-stream')]
		private static const Pokemon125:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/126.json', mimeType = 'application/octet-stream')]
		private static const Pokemon126:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/127.json', mimeType = 'application/octet-stream')]
		private static const Pokemon127:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/128.json', mimeType = 'application/octet-stream')]
		private static const Pokemon128:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/129.json', mimeType = 'application/octet-stream')]
		private static const Pokemon129:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/130.json', mimeType = 'application/octet-stream')]
		private static const Pokemon130:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/131.json', mimeType = 'application/octet-stream')]
		private static const Pokemon131:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/132.json', mimeType = 'application/octet-stream')]
		private static const Pokemon132:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/133.json', mimeType = 'application/octet-stream')]
		private static const Pokemon133:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/134.json', mimeType = 'application/octet-stream')]
		private static const Pokemon134:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/135.json', mimeType = 'application/octet-stream')]
		private static const Pokemon135:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/136.json', mimeType = 'application/octet-stream')]
		private static const Pokemon136:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/137.json', mimeType = 'application/octet-stream')]
		private static const Pokemon137:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/138.json', mimeType = 'application/octet-stream')]
		private static const Pokemon138:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/139.json', mimeType = 'application/octet-stream')]
		private static const Pokemon139:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/140.json', mimeType = 'application/octet-stream')]
		private static const Pokemon140:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/141.json', mimeType = 'application/octet-stream')]
		private static const Pokemon141:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/142.json', mimeType = 'application/octet-stream')]
		private static const Pokemon142:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/143.json', mimeType = 'application/octet-stream')]
		private static const Pokemon143:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/144.json', mimeType = 'application/octet-stream')]
		private static const Pokemon144:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/145.json', mimeType = 'application/octet-stream')]
		private static const Pokemon145:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/146.json', mimeType = 'application/octet-stream')]
		private static const Pokemon146:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/147.json', mimeType = 'application/octet-stream')]
		private static const Pokemon147:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/148.json', mimeType = 'application/octet-stream')]
		private static const Pokemon148:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/149.json', mimeType = 'application/octet-stream')]
		private static const Pokemon149:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/150.json', mimeType = 'application/octet-stream')]
		private static const Pokemon150:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/151.json', mimeType = 'application/octet-stream')]
		private static const Pokemon151:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/152.json', mimeType = 'application/octet-stream')]
		private static const Pokemon152:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/153.json', mimeType = 'application/octet-stream')]
		private static const Pokemon153:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/154.json', mimeType = 'application/octet-stream')]
		private static const Pokemon154:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/155.json', mimeType = 'application/octet-stream')]
		private static const Pokemon155:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/156.json', mimeType = 'application/octet-stream')]
		private static const Pokemon156:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/157.json', mimeType = 'application/octet-stream')]
		private static const Pokemon157:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/158.json', mimeType = 'application/octet-stream')]
		private static const Pokemon158:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/159.json', mimeType = 'application/octet-stream')]
		private static const Pokemon159:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/160.json', mimeType = 'application/octet-stream')]
		private static const Pokemon160:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/161.json', mimeType = 'application/octet-stream')]
		private static const Pokemon161:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/162.json', mimeType = 'application/octet-stream')]
		private static const Pokemon162:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/163.json', mimeType = 'application/octet-stream')]
		private static const Pokemon163:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/164.json', mimeType = 'application/octet-stream')]
		private static const Pokemon164:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/165.json', mimeType = 'application/octet-stream')]
		private static const Pokemon165:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/166.json', mimeType = 'application/octet-stream')]
		private static const Pokemon166:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/167.json', mimeType = 'application/octet-stream')]
		private static const Pokemon167:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/168.json', mimeType = 'application/octet-stream')]
		private static const Pokemon168:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/169.json', mimeType = 'application/octet-stream')]
		private static const Pokemon169:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/170.json', mimeType = 'application/octet-stream')]
		private static const Pokemon170:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/171.json', mimeType = 'application/octet-stream')]
		private static const Pokemon171:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/172.json', mimeType = 'application/octet-stream')]
		private static const Pokemon172:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/173.json', mimeType = 'application/octet-stream')]
		private static const Pokemon173:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/174.json', mimeType = 'application/octet-stream')]
		private static const Pokemon174:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/175.json', mimeType = 'application/octet-stream')]
		private static const Pokemon175:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/176.json', mimeType = 'application/octet-stream')]
		private static const Pokemon176:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/177.json', mimeType = 'application/octet-stream')]
		private static const Pokemon177:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/178.json', mimeType = 'application/octet-stream')]
		private static const Pokemon178:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/179.json', mimeType = 'application/octet-stream')]
		private static const Pokemon179:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/180.json', mimeType = 'application/octet-stream')]
		private static const Pokemon180:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/181.json', mimeType = 'application/octet-stream')]
		private static const Pokemon181:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/182.json', mimeType = 'application/octet-stream')]
		private static const Pokemon182:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/183.json', mimeType = 'application/octet-stream')]
		private static const Pokemon183:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/184.json', mimeType = 'application/octet-stream')]
		private static const Pokemon184:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/185.json', mimeType = 'application/octet-stream')]
		private static const Pokemon185:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/186.json', mimeType = 'application/octet-stream')]
		private static const Pokemon186:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/187.json', mimeType = 'application/octet-stream')]
		private static const Pokemon187:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/188.json', mimeType = 'application/octet-stream')]
		private static const Pokemon188:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/189.json', mimeType = 'application/octet-stream')]
		private static const Pokemon189:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/190.json', mimeType = 'application/octet-stream')]
		private static const Pokemon190:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/191.json', mimeType = 'application/octet-stream')]
		private static const Pokemon191:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/192.json', mimeType = 'application/octet-stream')]
		private static const Pokemon192:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/193.json', mimeType = 'application/octet-stream')]
		private static const Pokemon193:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/194.json', mimeType = 'application/octet-stream')]
		private static const Pokemon194:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/195.json', mimeType = 'application/octet-stream')]
		private static const Pokemon195:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/196.json', mimeType = 'application/octet-stream')]
		private static const Pokemon196:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/197.json', mimeType = 'application/octet-stream')]
		private static const Pokemon197:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/198.json', mimeType = 'application/octet-stream')]
		private static const Pokemon198:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/199.json', mimeType = 'application/octet-stream')]
		private static const Pokemon199:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/200.json', mimeType = 'application/octet-stream')]
		private static const Pokemon200:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/201.json', mimeType = 'application/octet-stream')]
		private static const Pokemon201:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/202.json', mimeType = 'application/octet-stream')]
		private static const Pokemon202:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/203.json', mimeType = 'application/octet-stream')]
		private static const Pokemon203:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/204.json', mimeType = 'application/octet-stream')]
		private static const Pokemon204:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/205.json', mimeType = 'application/octet-stream')]
		private static const Pokemon205:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/206.json', mimeType = 'application/octet-stream')]
		private static const Pokemon206:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/207.json', mimeType = 'application/octet-stream')]
		private static const Pokemon207:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/208.json', mimeType = 'application/octet-stream')]
		private static const Pokemon208:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/209.json', mimeType = 'application/octet-stream')]
		private static const Pokemon209:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/210.json', mimeType = 'application/octet-stream')]
		private static const Pokemon210:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/211.json', mimeType = 'application/octet-stream')]
		private static const Pokemon211:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/212.json', mimeType = 'application/octet-stream')]
		private static const Pokemon212:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/213.json', mimeType = 'application/octet-stream')]
		private static const Pokemon213:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/214.json', mimeType = 'application/octet-stream')]
		private static const Pokemon214:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/215.json', mimeType = 'application/octet-stream')]
		private static const Pokemon215:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/216.json', mimeType = 'application/octet-stream')]
		private static const Pokemon216:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/217.json', mimeType = 'application/octet-stream')]
		private static const Pokemon217:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/218.json', mimeType = 'application/octet-stream')]
		private static const Pokemon218:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/219.json', mimeType = 'application/octet-stream')]
		private static const Pokemon219:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/220.json', mimeType = 'application/octet-stream')]
		private static const Pokemon220:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/221.json', mimeType = 'application/octet-stream')]
		private static const Pokemon221:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/222.json', mimeType = 'application/octet-stream')]
		private static const Pokemon222:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/223.json', mimeType = 'application/octet-stream')]
		private static const Pokemon223:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/224.json', mimeType = 'application/octet-stream')]
		private static const Pokemon224:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/225.json', mimeType = 'application/octet-stream')]
		private static const Pokemon225:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/226.json', mimeType = 'application/octet-stream')]
		private static const Pokemon226:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/227.json', mimeType = 'application/octet-stream')]
		private static const Pokemon227:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/228.json', mimeType = 'application/octet-stream')]
		private static const Pokemon228:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/229.json', mimeType = 'application/octet-stream')]
		private static const Pokemon229:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/230.json', mimeType = 'application/octet-stream')]
		private static const Pokemon230:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/231.json', mimeType = 'application/octet-stream')]
		private static const Pokemon231:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/232.json', mimeType = 'application/octet-stream')]
		private static const Pokemon232:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/233.json', mimeType = 'application/octet-stream')]
		private static const Pokemon233:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/234.json', mimeType = 'application/octet-stream')]
		private static const Pokemon234:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/235.json', mimeType = 'application/octet-stream')]
		private static const Pokemon235:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/236.json', mimeType = 'application/octet-stream')]
		private static const Pokemon236:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/237.json', mimeType = 'application/octet-stream')]
		private static const Pokemon237:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/238.json', mimeType = 'application/octet-stream')]
		private static const Pokemon238:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/239.json', mimeType = 'application/octet-stream')]
		private static const Pokemon239:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/240.json', mimeType = 'application/octet-stream')]
		private static const Pokemon240:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/241.json', mimeType = 'application/octet-stream')]
		private static const Pokemon241:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/242.json', mimeType = 'application/octet-stream')]
		private static const Pokemon242:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/243.json', mimeType = 'application/octet-stream')]
		private static const Pokemon243:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/244.json', mimeType = 'application/octet-stream')]
		private static const Pokemon244:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/245.json', mimeType = 'application/octet-stream')]
		private static const Pokemon245:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/246.json', mimeType = 'application/octet-stream')]
		private static const Pokemon246:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/247.json', mimeType = 'application/octet-stream')]
		private static const Pokemon247:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/248.json', mimeType = 'application/octet-stream')]
		private static const Pokemon248:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/249.json', mimeType = 'application/octet-stream')]
		private static const Pokemon249:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/250.json', mimeType = 'application/octet-stream')]
		private static const Pokemon250:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/251.json', mimeType = 'application/octet-stream')]
		private static const Pokemon251:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/252.json', mimeType = 'application/octet-stream')]
		private static const Pokemon252:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/253.json', mimeType = 'application/octet-stream')]
		private static const Pokemon253:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/254.json', mimeType = 'application/octet-stream')]
		private static const Pokemon254:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/255.json', mimeType = 'application/octet-stream')]
		private static const Pokemon255:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/256.json', mimeType = 'application/octet-stream')]
		private static const Pokemon256:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/257.json', mimeType = 'application/octet-stream')]
		private static const Pokemon257:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/258.json', mimeType = 'application/octet-stream')]
		private static const Pokemon258:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/259.json', mimeType = 'application/octet-stream')]
		private static const Pokemon259:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/260.json', mimeType = 'application/octet-stream')]
		private static const Pokemon260:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/261.json', mimeType = 'application/octet-stream')]
		private static const Pokemon261:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/262.json', mimeType = 'application/octet-stream')]
		private static const Pokemon262:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/263.json', mimeType = 'application/octet-stream')]
		private static const Pokemon263:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/264.json', mimeType = 'application/octet-stream')]
		private static const Pokemon264:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/265.json', mimeType = 'application/octet-stream')]
		private static const Pokemon265:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/266.json', mimeType = 'application/octet-stream')]
		private static const Pokemon266:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/267.json', mimeType = 'application/octet-stream')]
		private static const Pokemon267:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/268.json', mimeType = 'application/octet-stream')]
		private static const Pokemon268:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/269.json', mimeType = 'application/octet-stream')]
		private static const Pokemon269:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/270.json', mimeType = 'application/octet-stream')]
		private static const Pokemon270:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/271.json', mimeType = 'application/octet-stream')]
		private static const Pokemon271:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/272.json', mimeType = 'application/octet-stream')]
		private static const Pokemon272:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/273.json', mimeType = 'application/octet-stream')]
		private static const Pokemon273:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/274.json', mimeType = 'application/octet-stream')]
		private static const Pokemon274:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/275.json', mimeType = 'application/octet-stream')]
		private static const Pokemon275:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/276.json', mimeType = 'application/octet-stream')]
		private static const Pokemon276:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/277.json', mimeType = 'application/octet-stream')]
		private static const Pokemon277:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/278.json', mimeType = 'application/octet-stream')]
		private static const Pokemon278:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/279.json', mimeType = 'application/octet-stream')]
		private static const Pokemon279:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/280.json', mimeType = 'application/octet-stream')]
		private static const Pokemon280:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/281.json', mimeType = 'application/octet-stream')]
		private static const Pokemon281:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/282.json', mimeType = 'application/octet-stream')]
		private static const Pokemon282:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/283.json', mimeType = 'application/octet-stream')]
		private static const Pokemon283:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/284.json', mimeType = 'application/octet-stream')]
		private static const Pokemon284:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/285.json', mimeType = 'application/octet-stream')]
		private static const Pokemon285:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/286.json', mimeType = 'application/octet-stream')]
		private static const Pokemon286:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/287.json', mimeType = 'application/octet-stream')]
		private static const Pokemon287:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/288.json', mimeType = 'application/octet-stream')]
		private static const Pokemon288:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/289.json', mimeType = 'application/octet-stream')]
		private static const Pokemon289:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/290.json', mimeType = 'application/octet-stream')]
		private static const Pokemon290:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/291.json', mimeType = 'application/octet-stream')]
		private static const Pokemon291:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/292.json', mimeType = 'application/octet-stream')]
		private static const Pokemon292:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/293.json', mimeType = 'application/octet-stream')]
		private static const Pokemon293:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/294.json', mimeType = 'application/octet-stream')]
		private static const Pokemon294:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/295.json', mimeType = 'application/octet-stream')]
		private static const Pokemon295:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/296.json', mimeType = 'application/octet-stream')]
		private static const Pokemon296:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/297.json', mimeType = 'application/octet-stream')]
		private static const Pokemon297:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/298.json', mimeType = 'application/octet-stream')]
		private static const Pokemon298:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/299.json', mimeType = 'application/octet-stream')]
		private static const Pokemon299:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/300.json', mimeType = 'application/octet-stream')]
		private static const Pokemon300:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/301.json', mimeType = 'application/octet-stream')]
		private static const Pokemon301:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/302.json', mimeType = 'application/octet-stream')]
		private static const Pokemon302:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/303.json', mimeType = 'application/octet-stream')]
		private static const Pokemon303:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/304.json', mimeType = 'application/octet-stream')]
		private static const Pokemon304:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/305.json', mimeType = 'application/octet-stream')]
		private static const Pokemon305:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/306.json', mimeType = 'application/octet-stream')]
		private static const Pokemon306:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/307.json', mimeType = 'application/octet-stream')]
		private static const Pokemon307:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/308.json', mimeType = 'application/octet-stream')]
		private static const Pokemon308:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/309.json', mimeType = 'application/octet-stream')]
		private static const Pokemon309:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/310.json', mimeType = 'application/octet-stream')]
		private static const Pokemon310:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/311.json', mimeType = 'application/octet-stream')]
		private static const Pokemon311:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/312.json', mimeType = 'application/octet-stream')]
		private static const Pokemon312:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/313.json', mimeType = 'application/octet-stream')]
		private static const Pokemon313:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/314.json', mimeType = 'application/octet-stream')]
		private static const Pokemon314:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/315.json', mimeType = 'application/octet-stream')]
		private static const Pokemon315:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/316.json', mimeType = 'application/octet-stream')]
		private static const Pokemon316:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/317.json', mimeType = 'application/octet-stream')]
		private static const Pokemon317:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/318.json', mimeType = 'application/octet-stream')]
		private static const Pokemon318:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/319.json', mimeType = 'application/octet-stream')]
		private static const Pokemon319:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/320.json', mimeType = 'application/octet-stream')]
		private static const Pokemon320:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/321.json', mimeType = 'application/octet-stream')]
		private static const Pokemon321:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/322.json', mimeType = 'application/octet-stream')]
		private static const Pokemon322:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/323.json', mimeType = 'application/octet-stream')]
		private static const Pokemon323:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/324.json', mimeType = 'application/octet-stream')]
		private static const Pokemon324:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/325.json', mimeType = 'application/octet-stream')]
		private static const Pokemon325:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/326.json', mimeType = 'application/octet-stream')]
		private static const Pokemon326:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/327.json', mimeType = 'application/octet-stream')]
		private static const Pokemon327:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/328.json', mimeType = 'application/octet-stream')]
		private static const Pokemon328:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/329.json', mimeType = 'application/octet-stream')]
		private static const Pokemon329:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/330.json', mimeType = 'application/octet-stream')]
		private static const Pokemon330:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/331.json', mimeType = 'application/octet-stream')]
		private static const Pokemon331:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/332.json', mimeType = 'application/octet-stream')]
		private static const Pokemon332:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/333.json', mimeType = 'application/octet-stream')]
		private static const Pokemon333:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/334.json', mimeType = 'application/octet-stream')]
		private static const Pokemon334:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/335.json', mimeType = 'application/octet-stream')]
		private static const Pokemon335:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/336.json', mimeType = 'application/octet-stream')]
		private static const Pokemon336:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/337.json', mimeType = 'application/octet-stream')]
		private static const Pokemon337:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/338.json', mimeType = 'application/octet-stream')]
		private static const Pokemon338:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/339.json', mimeType = 'application/octet-stream')]
		private static const Pokemon339:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/340.json', mimeType = 'application/octet-stream')]
		private static const Pokemon340:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/341.json', mimeType = 'application/octet-stream')]
		private static const Pokemon341:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/342.json', mimeType = 'application/octet-stream')]
		private static const Pokemon342:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/343.json', mimeType = 'application/octet-stream')]
		private static const Pokemon343:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/344.json', mimeType = 'application/octet-stream')]
		private static const Pokemon344:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/345.json', mimeType = 'application/octet-stream')]
		private static const Pokemon345:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/346.json', mimeType = 'application/octet-stream')]
		private static const Pokemon346:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/347.json', mimeType = 'application/octet-stream')]
		private static const Pokemon347:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/348.json', mimeType = 'application/octet-stream')]
		private static const Pokemon348:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/349.json', mimeType = 'application/octet-stream')]
		private static const Pokemon349:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/350.json', mimeType = 'application/octet-stream')]
		private static const Pokemon350:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/351.json', mimeType = 'application/octet-stream')]
		private static const Pokemon351:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/352.json', mimeType = 'application/octet-stream')]
		private static const Pokemon352:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/353.json', mimeType = 'application/octet-stream')]
		private static const Pokemon353:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/354.json', mimeType = 'application/octet-stream')]
		private static const Pokemon354:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/355.json', mimeType = 'application/octet-stream')]
		private static const Pokemon355:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/356.json', mimeType = 'application/octet-stream')]
		private static const Pokemon356:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/357.json', mimeType = 'application/octet-stream')]
		private static const Pokemon357:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/358.json', mimeType = 'application/octet-stream')]
		private static const Pokemon358:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/359.json', mimeType = 'application/octet-stream')]
		private static const Pokemon359:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/360.json', mimeType = 'application/octet-stream')]
		private static const Pokemon360:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/361.json', mimeType = 'application/octet-stream')]
		private static const Pokemon361:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/362.json', mimeType = 'application/octet-stream')]
		private static const Pokemon362:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/363.json', mimeType = 'application/octet-stream')]
		private static const Pokemon363:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/364.json', mimeType = 'application/octet-stream')]
		private static const Pokemon364:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/365.json', mimeType = 'application/octet-stream')]
		private static const Pokemon365:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/366.json', mimeType = 'application/octet-stream')]
		private static const Pokemon366:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/367.json', mimeType = 'application/octet-stream')]
		private static const Pokemon367:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/368.json', mimeType = 'application/octet-stream')]
		private static const Pokemon368:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/369.json', mimeType = 'application/octet-stream')]
		private static const Pokemon369:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/370.json', mimeType = 'application/octet-stream')]
		private static const Pokemon370:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/371.json', mimeType = 'application/octet-stream')]
		private static const Pokemon371:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/372.json', mimeType = 'application/octet-stream')]
		private static const Pokemon372:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/373.json', mimeType = 'application/octet-stream')]
		private static const Pokemon373:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/374.json', mimeType = 'application/octet-stream')]
		private static const Pokemon374:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/375.json', mimeType = 'application/octet-stream')]
		private static const Pokemon375:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/376.json', mimeType = 'application/octet-stream')]
		private static const Pokemon376:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/377.json', mimeType = 'application/octet-stream')]
		private static const Pokemon377:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/378.json', mimeType = 'application/octet-stream')]
		private static const Pokemon378:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/379.json', mimeType = 'application/octet-stream')]
		private static const Pokemon379:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/380.json', mimeType = 'application/octet-stream')]
		private static const Pokemon380:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/381.json', mimeType = 'application/octet-stream')]
		private static const Pokemon381:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/382.json', mimeType = 'application/octet-stream')]
		private static const Pokemon382:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/383.json', mimeType = 'application/octet-stream')]
		private static const Pokemon383:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/384.json', mimeType = 'application/octet-stream')]
		private static const Pokemon384:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/385.json', mimeType = 'application/octet-stream')]
		private static const Pokemon385:Class;
		[Embed(source = '/com/cloakentertainment/pokemonline/data/pokemon/386.json', mimeType = 'application/octet-stream')]
		private static const Pokemon386:Class;
		
		private static const _bases:Vector.<PokemonBase> = new Vector.<PokemonBase>();
		
		public function PokemonFactory()
		{
			constructBase(Pokemon1);
			constructBase(Pokemon2);
			constructBase(Pokemon3);
			constructBase(Pokemon4);
			constructBase(Pokemon5);
			constructBase(Pokemon6);
			constructBase(Pokemon7);
			constructBase(Pokemon8);
			constructBase(Pokemon9);
			constructBase(Pokemon10);
			constructBase(Pokemon11);
			constructBase(Pokemon12);
			constructBase(Pokemon13);
			constructBase(Pokemon14);
			constructBase(Pokemon15);
			constructBase(Pokemon16);
			constructBase(Pokemon17);
			constructBase(Pokemon18);
			constructBase(Pokemon19);
			constructBase(Pokemon20);
			constructBase(Pokemon21);
			constructBase(Pokemon22);
			constructBase(Pokemon23);
			constructBase(Pokemon24);
			constructBase(Pokemon25);
			constructBase(Pokemon26);
			constructBase(Pokemon27);
			constructBase(Pokemon28);
			constructBase(Pokemon29);
			constructBase(Pokemon30);
			constructBase(Pokemon31);
			constructBase(Pokemon32);
			constructBase(Pokemon33);
			constructBase(Pokemon34);
			constructBase(Pokemon35);
			constructBase(Pokemon36);
			constructBase(Pokemon37);
			constructBase(Pokemon38);
			constructBase(Pokemon39);
			constructBase(Pokemon40);
			constructBase(Pokemon41);
			constructBase(Pokemon42);
			constructBase(Pokemon43);
			constructBase(Pokemon44);
			constructBase(Pokemon45);
			constructBase(Pokemon46);
			constructBase(Pokemon47);
			constructBase(Pokemon48);
			constructBase(Pokemon49);
			constructBase(Pokemon50);
			constructBase(Pokemon51);
			constructBase(Pokemon52);
			constructBase(Pokemon53);
			constructBase(Pokemon54);
			constructBase(Pokemon55);
			constructBase(Pokemon56);
			constructBase(Pokemon57);
			constructBase(Pokemon58);
			constructBase(Pokemon59);
			constructBase(Pokemon60);
			constructBase(Pokemon61);
			constructBase(Pokemon62);
			constructBase(Pokemon63);
			constructBase(Pokemon64);
			constructBase(Pokemon65);
			constructBase(Pokemon66);
			constructBase(Pokemon67);
			constructBase(Pokemon68);
			constructBase(Pokemon69);
			constructBase(Pokemon70);
			constructBase(Pokemon71);
			constructBase(Pokemon72);
			constructBase(Pokemon73);
			constructBase(Pokemon74);
			constructBase(Pokemon75);
			constructBase(Pokemon76);
			constructBase(Pokemon77);
			constructBase(Pokemon78);
			constructBase(Pokemon79);
			constructBase(Pokemon80);
			constructBase(Pokemon81);
			constructBase(Pokemon82);
			constructBase(Pokemon83);
			constructBase(Pokemon84);
			constructBase(Pokemon85);
			constructBase(Pokemon86);
			constructBase(Pokemon87);
			constructBase(Pokemon88);
			constructBase(Pokemon89);
			constructBase(Pokemon90);
			constructBase(Pokemon91);
			constructBase(Pokemon92);
			constructBase(Pokemon93);
			constructBase(Pokemon94);
			constructBase(Pokemon95);
			constructBase(Pokemon96);
			constructBase(Pokemon97);
			constructBase(Pokemon98);
			constructBase(Pokemon99);
			constructBase(Pokemon100);
			constructBase(Pokemon101);
			constructBase(Pokemon102);
			constructBase(Pokemon103);
			constructBase(Pokemon104);
			constructBase(Pokemon105);
			constructBase(Pokemon106);
			constructBase(Pokemon107);
			constructBase(Pokemon108);
			constructBase(Pokemon109);
			constructBase(Pokemon110);
			constructBase(Pokemon111);
			constructBase(Pokemon112);
			constructBase(Pokemon113);
			constructBase(Pokemon114);
			constructBase(Pokemon115);
			constructBase(Pokemon116);
			constructBase(Pokemon117);
			constructBase(Pokemon118);
			constructBase(Pokemon119);
			constructBase(Pokemon120);
			constructBase(Pokemon121);
			constructBase(Pokemon122);
			constructBase(Pokemon123);
			constructBase(Pokemon124);
			constructBase(Pokemon125);
			constructBase(Pokemon126);
			constructBase(Pokemon127);
			constructBase(Pokemon128);
			constructBase(Pokemon129);
			constructBase(Pokemon130);
			constructBase(Pokemon131);
			constructBase(Pokemon132);
			constructBase(Pokemon133);
			constructBase(Pokemon134);
			constructBase(Pokemon135);
			constructBase(Pokemon136);
			constructBase(Pokemon137);
			constructBase(Pokemon138);
			constructBase(Pokemon139);
			constructBase(Pokemon140);
			constructBase(Pokemon141);
			constructBase(Pokemon142);
			constructBase(Pokemon143);
			constructBase(Pokemon144);
			constructBase(Pokemon145);
			constructBase(Pokemon146);
			constructBase(Pokemon147);
			constructBase(Pokemon148);
			constructBase(Pokemon149);
			constructBase(Pokemon150);
			constructBase(Pokemon151);
			constructBase(Pokemon152);
			constructBase(Pokemon153);
			constructBase(Pokemon154);
			constructBase(Pokemon155);
			constructBase(Pokemon156);
			constructBase(Pokemon157);
			constructBase(Pokemon158);
			constructBase(Pokemon159);
			constructBase(Pokemon160);
			constructBase(Pokemon161);
			constructBase(Pokemon162);
			constructBase(Pokemon163);
			constructBase(Pokemon164);
			constructBase(Pokemon165);
			constructBase(Pokemon166);
			constructBase(Pokemon167);
			constructBase(Pokemon168);
			constructBase(Pokemon169);
			constructBase(Pokemon170);
			constructBase(Pokemon171);
			constructBase(Pokemon172);
			constructBase(Pokemon173);
			constructBase(Pokemon174);
			constructBase(Pokemon175);
			constructBase(Pokemon176);
			constructBase(Pokemon177);
			constructBase(Pokemon178);
			constructBase(Pokemon179);
			constructBase(Pokemon180);
			constructBase(Pokemon181);
			constructBase(Pokemon182);
			constructBase(Pokemon183);
			constructBase(Pokemon184);
			constructBase(Pokemon185);
			constructBase(Pokemon186);
			constructBase(Pokemon187);
			constructBase(Pokemon188);
			constructBase(Pokemon189);
			constructBase(Pokemon190);
			constructBase(Pokemon191);
			constructBase(Pokemon192);
			constructBase(Pokemon193);
			constructBase(Pokemon194);
			constructBase(Pokemon195);
			constructBase(Pokemon196);
			constructBase(Pokemon197);
			constructBase(Pokemon198);
			constructBase(Pokemon199);
			constructBase(Pokemon200);
			constructBase(Pokemon201);
			constructBase(Pokemon202);
			constructBase(Pokemon203);
			constructBase(Pokemon204);
			constructBase(Pokemon205);
			constructBase(Pokemon206);
			constructBase(Pokemon207);
			constructBase(Pokemon208);
			constructBase(Pokemon209);
			constructBase(Pokemon210);
			constructBase(Pokemon211);
			constructBase(Pokemon212);
			constructBase(Pokemon213);
			constructBase(Pokemon214);
			constructBase(Pokemon215);
			constructBase(Pokemon216);
			constructBase(Pokemon217);
			constructBase(Pokemon218);
			constructBase(Pokemon219);
			constructBase(Pokemon220);
			constructBase(Pokemon221);
			constructBase(Pokemon222);
			constructBase(Pokemon223);
			constructBase(Pokemon224);
			constructBase(Pokemon225);
			constructBase(Pokemon226);
			constructBase(Pokemon227);
			constructBase(Pokemon228);
			constructBase(Pokemon229);
			constructBase(Pokemon230);
			constructBase(Pokemon231);
			constructBase(Pokemon232);
			constructBase(Pokemon233);
			constructBase(Pokemon234);
			constructBase(Pokemon235);
			constructBase(Pokemon236);
			constructBase(Pokemon237);
			constructBase(Pokemon238);
			constructBase(Pokemon239);
			constructBase(Pokemon240);
			constructBase(Pokemon241);
			constructBase(Pokemon242);
			constructBase(Pokemon243);
			constructBase(Pokemon244);
			constructBase(Pokemon245);
			constructBase(Pokemon246);
			constructBase(Pokemon247);
			constructBase(Pokemon248);
			constructBase(Pokemon249);
			constructBase(Pokemon250);
			constructBase(Pokemon251);
			constructBase(Pokemon252);
			constructBase(Pokemon253);
			constructBase(Pokemon254);
			constructBase(Pokemon255);
			constructBase(Pokemon256);
			constructBase(Pokemon257);
			constructBase(Pokemon258);
			constructBase(Pokemon259);
			constructBase(Pokemon260);
			constructBase(Pokemon261);
			constructBase(Pokemon262);
			constructBase(Pokemon263);
			constructBase(Pokemon264);
			constructBase(Pokemon265);
			constructBase(Pokemon266);
			constructBase(Pokemon267);
			constructBase(Pokemon268);
			constructBase(Pokemon269);
			constructBase(Pokemon270);
			constructBase(Pokemon271);
			constructBase(Pokemon272);
			constructBase(Pokemon273);
			constructBase(Pokemon274);
			constructBase(Pokemon275);
			constructBase(Pokemon276);
			constructBase(Pokemon277);
			constructBase(Pokemon278);
			constructBase(Pokemon279);
			constructBase(Pokemon280);
			constructBase(Pokemon281);
			constructBase(Pokemon282);
			constructBase(Pokemon283);
			constructBase(Pokemon284);
			constructBase(Pokemon285);
			constructBase(Pokemon286);
			constructBase(Pokemon287);
			constructBase(Pokemon288);
			constructBase(Pokemon289);
			constructBase(Pokemon290);
			constructBase(Pokemon291);
			constructBase(Pokemon292);
			constructBase(Pokemon293);
			constructBase(Pokemon294);
			constructBase(Pokemon295);
			constructBase(Pokemon296);
			constructBase(Pokemon297);
			constructBase(Pokemon298);
			constructBase(Pokemon299);
			constructBase(Pokemon300);
			constructBase(Pokemon301);
			constructBase(Pokemon302);
			constructBase(Pokemon303);
			constructBase(Pokemon304);
			constructBase(Pokemon305);
			constructBase(Pokemon306);
			constructBase(Pokemon307);
			constructBase(Pokemon308);
			constructBase(Pokemon309);
			constructBase(Pokemon310);
			constructBase(Pokemon311);
			constructBase(Pokemon312);
			constructBase(Pokemon313);
			constructBase(Pokemon314);
			constructBase(Pokemon315);
			constructBase(Pokemon316);
			constructBase(Pokemon317);
			constructBase(Pokemon318);
			constructBase(Pokemon319);
			constructBase(Pokemon320);
			constructBase(Pokemon321);
			constructBase(Pokemon322);
			constructBase(Pokemon323);
			constructBase(Pokemon324);
			constructBase(Pokemon325);
			constructBase(Pokemon326);
			constructBase(Pokemon327);
			constructBase(Pokemon328);
			constructBase(Pokemon329);
			constructBase(Pokemon330);
			constructBase(Pokemon331);
			constructBase(Pokemon332);
			constructBase(Pokemon333);
			constructBase(Pokemon334);
			constructBase(Pokemon335);
			constructBase(Pokemon336);
			constructBase(Pokemon337);
			constructBase(Pokemon338);
			constructBase(Pokemon339);
			constructBase(Pokemon340);
			constructBase(Pokemon341);
			constructBase(Pokemon342);
			constructBase(Pokemon343);
			constructBase(Pokemon344);
			constructBase(Pokemon345);
			constructBase(Pokemon346);
			constructBase(Pokemon347);
			constructBase(Pokemon348);
			constructBase(Pokemon349);
			constructBase(Pokemon350);
			constructBase(Pokemon351);
			constructBase(Pokemon352);
			constructBase(Pokemon353);
			constructBase(Pokemon354);
			constructBase(Pokemon355);
			constructBase(Pokemon356);
			constructBase(Pokemon357);
			constructBase(Pokemon358);
			constructBase(Pokemon359);
			constructBase(Pokemon360);
			constructBase(Pokemon361);
			constructBase(Pokemon362);
			constructBase(Pokemon363);
			constructBase(Pokemon364);
			constructBase(Pokemon365);
			constructBase(Pokemon366);
			constructBase(Pokemon367);
			constructBase(Pokemon368);
			constructBase(Pokemon369);
			constructBase(Pokemon370);
			constructBase(Pokemon371);
			constructBase(Pokemon372);
			constructBase(Pokemon373);
			constructBase(Pokemon374);
			constructBase(Pokemon375);
			constructBase(Pokemon376);
			constructBase(Pokemon377);
			constructBase(Pokemon378);
			constructBase(Pokemon379);
			constructBase(Pokemon380);
			constructBase(Pokemon381);
			constructBase(Pokemon382);
			constructBase(Pokemon383);
			constructBase(Pokemon384);
			constructBase(Pokemon385);
			constructBase(Pokemon386);
		}
		
		public static function getRandomName():String
		{
			var rand:int = Math.floor(Math.random() * 386) + 1;
			return getPokemonNameFromID(rand);
		}
		
		public static function createPokemonFromString(data:String):Pokemon
		{
			var pokemon:Pokemon = new Pokemon(_bases[0]); // Random base just for now
			pokemon.DECODE_FROM_STRING(data);
			
			return pokemon;
		}
		
		public static function createPokemonFromData(data:String):Pokemon
		{
			var dataArray:Array = data.split(",");
			var pokemon:Pokemon = createPokemon(dataArray[0], int(dataArray[1]), "Trainer's Pokémon");
			if (dataArray[3] != "auto") pokemon.setAbility(dataArray[3]);
			pokemon.setHeldItem(dataArray[4]);
			pokemon.setGender(dataArray[2] == "male" ? PokemonGender.MALE : (dataArray[2] == "female" ? PokemonGender.FEMALE : PokemonGender.NONE));
			if (dataArray[5] != "auto")
			{
				var moves:Array = [dataArray[5], dataArray[6], dataArray[7], dataArray[8]];
				var movePP:Array = [moves[0] != "" ? PokemonMoves.getMovePPByID(PokemonMoves.getMoveIDByName(moves[0])) : 0, moves[1] != "" ? PokemonMoves.getMovePPByID(PokemonMoves.getMoveIDByName(moves[1])) : 0, moves[2] != "" ? PokemonMoves.getMovePPByID(PokemonMoves.getMoveIDByName(moves[2])) : 0, moves[3] != "" ? PokemonMoves.getMovePPByID(PokemonMoves.getMoveIDByName(moves[3])) : 0];
				pokemon.setMoves(moves);
				pokemon.setMovePP(movePP[0], movePP[1], movePP[2], movePP[3]);
				pokemon.setMovePPMax(movePP[0], movePP[1], movePP[2], movePP[3]);
			}
			
			return pokemon;
		}
		
		public static function createPokemon(name:String, level:int, location:String = "Route 101"):Pokemon
		{
			if (name == "") name = getRandomName();
			var _pokemon:Pokemon = new Pokemon(getPokemonBaseFromName(name));
			_pokemon.setName(_pokemon.base.name.toUpperCase());
			_pokemon.setUID(GUID.create());
			_pokemon.setNature(PokemonNature.getRandomNature());
			var i:int;
			var genderRandNumber:int = Math.floor(Math.random() * 100) + 1;
			if (genderRandNumber <= _pokemon.base.genderRatio)
			{
				_pokemon.setGender(PokemonGender.MALE);
			}
			else
				_pokemon.setGender(PokemonGender.FEMALE);
			
			var heldItemRandNumber:int = Math.floor(Math.random() * 100) + 1;
			var heldItem:String = "";
			//trace("Pokemon " + name + _pokemon.base.heldItems);
			for (i = 0; i < _pokemon.base.heldItems.length; i++)
			{
				if (heldItemRandNumber <= _pokemon.base.heldItems[i].chance)
				{
					heldItem = _pokemon.base.heldItems[i].name;
				}
			}
			_pokemon.setHeldItem(heldItem);
			var shinyPokemonRandNumber:int = Math.floor(Math.random() * 65536);
			if (shinyPokemonRandNumber <= 8)
				_pokemon.setShiny(true);
			else
				_pokemon.setShiny(false);
			
			_pokemon.setXP(PokemonLevelRate.calculateXP(_pokemon.base.levellingRate, level));
			var abilityRandNumber:int = Math.floor(Math.random() * (_pokemon.base.abilities.length - 1));
			_pokemon.setAbility(_pokemon.base.abilities[abilityRandNumber]);
			
			_pokemon.setIVs(Math.floor(Math.random() * 32), Math.floor(Math.random() * 32), Math.floor(Math.random() * 32), Math.floor(Math.random() * 32), Math.floor(Math.random() * 32), Math.floor(Math.random() * 32));
			
			_pokemon.setEVs(0, 0, 0, 0, 0, 0);
			
			// get the four highest level moves for this pokemon
			var moves:Array = [];
			var pps:Array = [];
			for (i = _pokemon.base.learnSet.length - 1; i >= 0; i--)
			{
				var move:Object = _pokemon.base.learnSet[i];
				if (move["level"] != null && move.level <= level)
				{
					moves.push(move.move);
					pps.push(PokemonMoves.getMovePPByID(PokemonMoves.getMoveIDByName(move.move)));
				}
				if (moves.length == 4)
					break;
			}
			
			_pokemon.setMoves(moves);
			_pokemon.setMovePP(pps[0] != null ? pps[0] : 0, pps[1] != null ? pps[1] : 0, pps[2] != null ? pps[2] : 0, pps[3] != null ? pps[3] : 0);
			_pokemon.setMovePPMax(pps[0] != null ? pps[0] : 0, pps[1] != null ? pps[1] : 0, pps[2] != null ? pps[2] : 0, pps[3] != null ? pps[3] : 0);
			
			_pokemon.setFriendship(_pokemon.base.baseFriendship);
			
			// set move PP
			
			_pokemon.setMetAt(level, location);
			_pokemon.setLevel(level);
			_pokemon.setCurrentHP(_pokemon.getStat(PokemonStat.HP));
			
			StatManager.incrementStat(StatType.POKEMON_GENERATED);
			return _pokemon;
		}
		
		public static function getPokemonBaseFromName(name:String):PokemonBase
		{
			return getBase(getPokemonIDFromName(name) - 1);
		}
		
		public static function getPokemonNameFromID(id:int):String
		{
			for (var i:uint = 0; i < pokemon.length; i++)
			{
				if (pokemon[i][0] == id)
					return pokemon[i][1];
			}
			
			throw(new Error('Unknown Pokemon ID ' + id));
			return "";
		}
		
		public static function getPokemonIDFromName(name:String):int
		{
			if (name == "Nidoran♂") return 32;
			if (name == "Farfetch'd") return 83;
			
			for (var i:uint = 0; i < pokemon.length; i++)
			{
				if (pokemon[i][1] == name)
					return pokemon[i][0];
			}
			
			throw(new Error('Unknown Pokemon "' + name + '".'));
			return 0;
		}
		
		public static function getBase(id:int):PokemonBase
		{
			return _bases[id];
		}
		
		public static function getBaseByHoennID(id:int):PokemonBase
		{
			for (var i:uint = 0; i < _bases.length; i++)
			{
				if (_bases[i].regionalPokedexNumbers[0] == id) return _bases[i];
			}
			
			throw(new Error("Could not find Pokemon with Hoenn ID " + id));
			return null;
		}
		
		public static function getPokemonIDFromHoennID(id:int):int
		{
			return getBaseByHoennID(id).ID;
		}
		
		private static function constructBase(pokemon:Class):PokemonBase
		{
			var _data:Object = JSON.parse(new pokemon());
			var base:PokemonBase = new PokemonBase();
			base.ID = _data.pokemon.ID;
			base.name = _data.pokemon.Name;
			base.type = _data.pokemon.Type;
			base.catchRate = _data.pokemon.CatchRate;
			base.genderRatio = _data.pokemon.GenderRatio;
			base.abilities = _data.pokemon.Abilities;
			base.eggGroups = _data.pokemon.EggGroups;
			base.hatchTime = _data.pokemon.HatchTime;
			if (_data.pokemon.PokedexType) base.pokedexType = _data.pokemon.PokedexType;
			else
			{
				base.pokedexType = "Unknown Pokémon";
				trace("WARNING: " + base.name + " has an unknown Pokémon type.");
			}
			base.height = _data.pokemon.Height;
			base.weight = _data.pokemon.Weight;
			base.regionalPokedexNumbers = _data.pokemon.RegionalPokedexNumbers;
			base.baseExperienceYield = _data.pokemon.BaseExperienceYield;
			base.levellingRate = String(_data.pokemon.LevelingRate).toLowerCase();
			base.HPEVYield = int(_data.pokemon.EVYield.HP);
			base.ATKEVYield = int(_data.pokemon.EVYield.ATK);
			base.DEFEVYield = int(_data.pokemon.EVYield.DEF);
			base.SPEEDEVYield = int(_data.pokemon.EVYield.SPEED);
			base.SPATKEVYield = int(_data.pokemon.EVYield.SPATK);
			base.SPDEFEVYield = int(_data.pokemon.EVYield.SPDEF);
			base.bodyStyle = _data.pokemon.BodyStyle;
			base.footprintStyle = _data.pokemon.FootprintStyle;
			base.pokedexColor = String(_data.pokemon.PokedexColor).toLowerCase();
			base.baseFriendship = _data.pokemon.BaseFriendship;
			
			var i:uint = 0;
			for (i = 0; i < base.type.length; i++)
			{
				base.type[i] = String(base.type[i]).toLowerCase();
			}
			
			// parse evolutions
			var evolutions:Array = _data.pokemon.Evolutions;
			for (i = 0; i < evolutions.length; i++)
			{
				var evolution:PokemonEvolution = new PokemonEvolution(evolutions[i].type, evolutions[i].at, evolutions[i].into, evolutions[i]["with"]);
				base.evolutions.push(evolution);
			}
			
			base.pokedexEntry = _data.pokemon.PokedexEntry;
			base.heldItems = _data.pokemon.HeldItems;
			base.HPBaseStat = _data.pokemon.BaseStats.HP;
			base.ATKBaseStat = _data.pokemon.BaseStats.ATK;
			base.DEFBaseStat = _data.pokemon.BaseStats.DEF;
			base.SPATKBaseStat = _data.pokemon.BaseStats.SPATK;
			base.SPDEFBaseStat = _data.pokemon.BaseStats.SPDEF;
			base.SPEEDBaseStat = _data.pokemon.BaseStats.SPEED;
			base.learnSet = _data.pokemon.LearnSet;
			
			/*var learntMoves:Array = new Array();
			   for (i = 0; i < base.learnSet.length; i++)
			   {
			   var move:String = base.learnSet[i].move;
			   if (base.learnSet[i].item != null) continue;
			   if (base.learnSet[i].level == '0') continue;
			   var known:Boolean = false;
			   for (var j:int = 0; j < learntMoves.length; j++)
			   {
			   if (learntMoves[j] == move) known = true;
			   }
			   if (!known) learntMoves.push(move);
			   else
			   {
			   trace("WARNING: Duplicate moves on Pokemon " + base.name);
			   break;
			   }
			   }*/
			
			_bases.push(base);
			
			return base;
		}
	
	}

}