package;

import flixel.system.FlxSound;
import Controls.Device;
import Controls.Control;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import flixel.effects.FlxFlicker;

import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.FlxObject;
import flixel.addons.util.FlxAsyncLoop;
#if sys import sys.FileSystem; #end
#if desktop import Discord.DiscordClient; #end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite = new FlxSprite();

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var Catagories:Array<String> = ['dave', 'joke', 'extras', 'iykyk'];
	var translatedCatagory:Array<String> = [LanguageManager.getTextString('freeplay_dave'), LanguageManager.getTextString('freeplay_joke'), LanguageManager.getTextString('freeplay_extra'), LanguageManager.getTextString('freeplay_iykyk')];

	private var CurrentPack:Int = 0;
	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = 
	[
    	0xFF00137F,    // GF but its actually luna!
		0xFFB4B4B4,    // LUNA
		0xFF8C8C8C,    // SCRATCH
		0xFF000000,    // BLACK
		0xFFFFFFFF,    // WHITE
		0xFFFFD700,    // GOLD
		0xFFFFA500,    // HALLOWEEN
		0xFFC37A50,    // OBAMAAAAAAAAAAAAA
		FlxColor.fromRGB(140, 75, 0), // BROWN LIKE SHIT
		0xFFB4B4B4,    // LUNA BUT PIXELATED
		FlxColor.fromRGB(44, 44, 44),    // RECURSED
		FlxColor.fromRGB(148, 181, 102),    // ALLS
		FlxColor.fromRGB(189, 167, 129),    // NOAH IRL PINECONE EATER
		FlxColor.fromRGB(187, 45, 45),    // SUSSY AMOGUS INPOSTORT
		0xFF119A2B,    // CHEATING
		0xFF000000,    // UNFAIRNESS
		0xFF000000,    // DARKNESSSSSSSSSS
		0xF5BB27,    // DARKNESSSSSSSSSS
		FlxColor.fromRGB(161, 208, 129),    // TESSATTACK
		FlxColor.fromRGB(223, 207, 77),    // HEAVENLY
 		FlxColor.fromRGB(6, 15, 0),    // SEPTUAGINT
		FlxColor.fromRGB(18, 7, 72),    // CLAMOROUS
 		FlxColor.fromRGB(153, 42, 51),    // PSYCHOSIS
 		FlxColor.fromRGB(108, 38, 82),    // SPECTRE SHIT
 		FlxColor.fromRGB(64, 23, 49),    // SPECTRE BUT DARKER
 		FlxColor.fromRGB(83, 48, 28),    // SLAVE
 ];
	public static var skipSelect:Array<String> = 
	[
		'apprentice',
		'recursed',
		'lost',
		'darkness',
		'dead-zoee',
		'luna-in-among-us',
		'sunshine',
		'kys',
		'action-two',
		'entity',
		'vs-luna-christmas',
		'fatalistic',
		'galactic',
		'kalampokiphobia',
		'yarn',
		'milky-way',
		'unethical',
		'master',
		'nomophobia',
		'tessattack',
		'disoriented',
		'alls-world',
		'heavenly',
		'disoriented',
		'cheating',
		'unfairness'
	];

	public static var noPussy:Array<String> = 
	[

		'luna',
		'treats',
		'scratch',
		'fatalistic',
		'nomophobia',
		'disoriented',
		'action',
		'action-two',
		'meow',
		'galactic',
		'milky-way',





		'cheating',
		'unfairness',

		'dead-zoee',
		'lunatopia',
		'vs-luna-free-trial',
		'the-biggest-bird',
		'wow-two',
		'shipped-my-pants',
		'luna-in-among-us',
		'noah-the-pinecone',
		'obama',
		'kys',

		'wheels',
		'apprentice',
		'stereo-madness',
		'roofs',
		'lunas-arcade',
		'cuberoot',
		'love-songs',
		'yarn',
		'roses',
		'lunacone',
		'kalampokiphobia',
		'tessattack',
		'sunshine',
		'puda',
		'lost',
		'heart-of-gold',
		'recursed',
		'entity',

		'unethical',

		'blocked',

		'alls-world',
		'i-would-roast-you-but-my-mom-said-im-not-allowed-to-burn-trash',
		'luna-the-slave',
		'darkness',
		'Enter Terminal'
	];

	public static var noExtraKeys:Array<String> = 
	[

		'luna',
		'treats',
		'scratch',
		'fatalistic',
		'nomophobia',
		'disoriented',
		'action',
		'action-two',
		'meow',
		'galactic',
		'milky-way',
		'master',
		'heavenly',


		'psychosis',
		'cheating',
		'unfairness',

		'dead-zoee',
		'lunatopia',
		'vs-luna-free-trial',
		'the-biggest-bird',
		'wow-two',
		'shipped-my-pants',

		'noah-the-pinecone',

		'kys',

		'wheels',
		'apprentice',
		'stereo-madness',
		'roofs',
		'lunas-arcade',

		'love-songs',
		'yarn',
		'roses',
		'lunacone',
		'kalampokiphobia',
		'tessattack',
		'sunshine',
		'puda',
		'lost',
		'heart-of-gold',
		'recursed',
		'entity',

		'unethical',

		'blocked',
		'alls-world',
		'opposition',
		'luna-the-slave',
		'darkness',
		'Enter Terminal'
	];

	private var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	private var iconArray:Array<HealthIcon> = [];

	var titles:Array<Alphabet> = [];
	var icons:Array<FlxSprite> = [];

	var doneCoolTrans:Bool = false;

	var defColor:FlxColor;
	var canInteract:Bool = true;

	//recursed
	var timeSincePress:Float;
	var lastTimeSincePress:Float;

	var pressSpeed:Float;
	var pressSpeeds:Array<Float> = new Array<Float>();
	var pressUnlockNumber:Int;
	var requiredKey:Array<Int>;
	var stringKey:String;

	var bgShader:Shaders.GlitchEffect;
	var awaitingExploitation:Bool;
	public static var packTransitionDone:Bool = false;
	var characterSelectText:FlxText;
	var showCharText:Bool = true;

	// Warning sprites
	var shapeNoteWarning:FlxSprite;
	var shapeNoteWarning2:FlxSprite;
	var shapeNoteWarning3:FlxSprite;
	var shapeNoteWarningDefault:FlxSprite;
	var currentWarning:FlxSprite;
	var currentWarningType:Int = -1; // -1 = none, 0 = default, 1 = warning1, 2 = warning2, 3 = warning3

	// Locked song message
	var lockedSongText:FlxText;
	var lockedSongTimer:FlxTimer;

	override function create()
	{
		#if desktop DiscordClient.changePresence("In the Freeplay Menu", null); #end
		
		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		showCharText = FlxG.save.data.wasInCharSelect;

		if (awaitingExploitation)
		{
			bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			bg.scrollFactor.set();
			bg.antialiasing = false;
			bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
			add(bg);
			
			#if SHADERS_ENABLED
			bgShader = new Shaders.GlitchEffect();
			bgShader.waveAmplitude = 0.1;
			bgShader.waveFrequency = 5;
			bgShader.waveSpeed = 2;
			
			bg.shader = bgShader.shader;
			#end
			defColor = bg.color;
		}
		else
		{
			bg.loadGraphic(MainMenuState.randomizeBG());
			bg.color = 0xFF4965FF;
			defColor = bg.color;
			bg.scrollFactor.set();
			add(bg);
		}
		if (FlxG.save.data.terminalFound && !awaitingExploitation)
		{
			Catagories = ['dave', 'joke', 'extras', 'iykyk', 'terminal'];
			translatedCatagory = [
			LanguageManager.getTextString('freeplay_dave'),
			LanguageManager.getTextString('freeplay_joke'),
			LanguageManager.getTextString('freeplay_extra'),
			LanguageManager.getTextString('freeplay_iykyk'),
			LanguageManager.getTextString('freeplay_terminal')];
		}

		for (i in 0...Catagories.length)
		{
			Highscore.load();

			var CurrentSongIcon:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('packs/' + (Catagories[i].toLowerCase()), "preload"));
			CurrentSongIcon.centerOffsets(false);
			CurrentSongIcon.x = (1000 * i + 1) + (512 - CurrentSongIcon.width);
			CurrentSongIcon.y = (FlxG.height / 2) - 256;
			CurrentSongIcon.antialiasing = true;

			var NameAlpha:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, translatedCatagory[i], true, false);
			NameAlpha.x = CurrentSongIcon.x;

			add(CurrentSongIcon);
			icons.push(CurrentSongIcon);
			add(NameAlpha);
			titles.push(NameAlpha);
		}


		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		
		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.focusOn(camFollow.getPosition());

		if (awaitingExploitation)
		{
			if (!packTransitionDone)
			{
				var curIcon = icons[CurrentPack];
				var curTitle = titles[CurrentPack];

				canInteract = false;
				var expungedPack:FlxSprite = new FlxSprite(curIcon.x, curIcon.y).loadGraphic(Paths.image('packs/uhoh', "preload"));
				expungedPack.centerOffsets(false);
				expungedPack.antialiasing = false;
				expungedPack.alpha = 0;
				add(expungedPack);

				var expungedTitle:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, 'uh oh', true, false);
				expungedTitle.x = expungedPack.x;
				add(expungedTitle);
			
				FlxTween.tween(curIcon, {alpha: 0}, 1);
				FlxTween.tween(curTitle, {alpha: 0}, 1);
				FlxTween.tween(expungedTitle, {alpha: 1}, 1);
				FlxTween.tween(expungedPack, {alpha: 1}, 1, {onComplete: function(tween:FlxTween)
				{
					icons[CurrentPack].destroy();
					titles[CurrentPack].destroy();
				
					icons[CurrentPack] = expungedPack;
					titles[CurrentPack] = expungedTitle;

					curIcon.alpha = 1;
					curTitle.alpha = 1;

					Catagories = ['uhoh'];
					translatedCatagory = ['uh oh'];
					packTransitionDone = true;
					canInteract = true;
				}});
			}
			else
			{
				var originalIconPos = icons[CurrentPack].getPosition();
				var originalTitlePos = titles[CurrentPack].getPosition();
				
				icons[CurrentPack].destroy();
				titles[CurrentPack].destroy();
								
				icons[CurrentPack].loadGraphic(Paths.image('packs/uhoh', "preload"));
				icons[CurrentPack].setPosition(originalIconPos.x, originalIconPos.y);
				icons[CurrentPack].centerOffsets(false);
				icons[CurrentPack].antialiasing = false;
				
				titles[CurrentPack] = new Alphabet(40, (FlxG.height / 2) - 282, 'uh oh', true, false);
				titles[CurrentPack].setPosition(originalTitlePos.x, originalTitlePos.y);
				
				Catagories = ['uhoh'];
				translatedCatagory = ['uh oh'];
			}
		}

		super.create();
	}

	public function LoadProperPack()
	{
		switch (Catagories[CurrentPack].toLowerCase())
		{
			case 'uhoh':
				addWeek(['Darkness'], 16, ['lunatrueform']);
			case 'dave':
				addWeek(['Warmup'], 1, ['luna']);
				addWeek(['Luna', 'Treats'], 1, ['luna', 'luna']);
				addWeek(['Scratch'], 2, ['lunamad']);
				addWeek(['Fatalistic'], 3, ['lunafinal']);
				addWeek(['Nomophobia'], 4, ['lunanomo']);
				addWeek(['Disoriented'], 3, ['lunadis']);
				addWeek(['Action', 'Action-Two', 'Meow'], 1, ['luna3d', 'luna3d', 'luna']);
				addWeek(['Galactic', 'Milky-Way'], 23, ['lunaspectre', 'lunaspectre']);
				addWeek(['Master'], 24, ['lunamadspectre']);
				addWeek(['Heavenly'], 19, ['holyluna']);
				addWeek(['Septuagint'], 20, ['lunaseptuagint']);
				addWeek(['Clamorous'], 21, ['lunaclamorous']);
				addWeek(['Psychosis'], 22, ['sisters']);
				if (FlxG.save.data.hasPlayedMasterWeek)
				{
					addWeek(['Cheating'], 14, ['bambi-3d']);
					addWeek(['Unfairness'], 15, ['bambi-unfair']);
				}
			case 'joke':
				addWeek(['dead-zoee'], 8, ['puda']);
				addWeek(['lunatopia'], 1, ['lunar']);
				addWeek(['vs-luna-free-trial'], 1, ['lunar']);
				addWeek(['the-biggest-bird'], 1, ['luna']);
				addWeek(['wow-two'], 1, ['luna']);
				addWeek(['shipped-my-pants'], 1, ['elonmusk']);
				addWeek(['luna-in-among-us'], 13, ['impostor']);
				addWeek(['noah-the-pinecone'], 12, ['noahreal']);
				addWeek(['obama'], 7, ['obama']);
				addWeek(['kys'], 3, ['lunagod']);
			case 'extras':
				addWeek(['Wheels', 'Apprentice', 'Stereo-Madness', 'Roofs', 'Lunas-Arcade'], 1, ['luna', 'luna', 'luna', 'luna', 'luna']);
				addWeek(['Cuberoot'], 1, ['luna3d']);
				addWeek(['Love-Songs'], 2, ['luna3d']);
				addWeek(['Yarn'], 23, ['lunaspectre']);
				addWeek(['Roses'], 9, ['luna-pixel']);
				addWeek(['Lunacone'], 1, ['lunacone']);
				addWeek(['Kalampokiphobia'], 3, ['lunakalam']);
				addWeek(['Tessattack'], 18, ['lunatessattack']);
				addWeek(['Sunshine'], 2, ['lunadoll']);
				addWeek(['Puda'], 8, ['puda']);
				addWeek(['Lost'], 6, ['lunahalloween']);
				addWeek(['Heart-Of-Gold'], 5, ['lunagold']);
				if (FlxG.save.data.recursedUnlocked)
					addWeek(['Recursed'], 10, ['dark']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.recursedUnlocked)
					addWeek(['Entity'], 10, ['dark']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.optoplisticUnlocked)
					addWeek(['Optoplistic'], 3, ['optoplistic']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
			case 'iykyk':
				if (FlxG.save.data.unethicalFound)
					addWeek(['unethical'], 3, ['philtrixpissed']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
			case 'terminal':
				if (FlxG.save.data.exbungoFound)
					addWeek(['Blocked'], 11, ['alls']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.exbungoNonoFound)
					addWeek(['Opposition'], 3, ['nonoalls']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.exbungoFound)
					addWeek(['Alls-World'], 11, ['alls']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.burntrashFound)
					addWeek(['i-would-roast-you-but-my-mom-said-im-not-allowed-to-burn-trash'], 11, ['alls']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.slaveFound)
					addWeek(['Luna-The-Slave'], 25, ['lunaslave']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				if (FlxG.save.data.exploitationFound)
					addWeek(['Darkness'], 16, ['lunatrueform']);
				else
					addWeek(['Locked Song'], 3, ['lock']);
				addWeek(['Enter Terminal'], 17, ['terminal']);
		}
	}

	var scoreBG:FlxSprite;

	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.itemType = 'Classic';
			songText.targetY = i;
			songText.scrollFactor.set();
			songText.alpha = 0;
			songText.y += 1000;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			icon.scrollFactor.set();

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 0, 0, "", 32);
		scoreText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, LEFT);
		scoreText.antialiasing = true;
		scoreText.y = -225;
		scoreText.scrollFactor.set();

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.scrollFactor.set();
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 15, 0, "", 24);
		diffText.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT);
		diffText.antialiasing = true;
		diffText.scrollFactor.set();

		if (showCharText)
		{
			characterSelectText = new FlxText(FlxG.width, FlxG.height, 0, LanguageManager.getTextString("freeplay_skipChar"), 18);
			characterSelectText.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			characterSelectText.borderSize = 1.5;
			characterSelectText.antialiasing = true;
			characterSelectText.scrollFactor.set();
			characterSelectText.alpha = 0;
			characterSelectText.x -= characterSelectText.textField.textWidth;
			characterSelectText.y -= characterSelectText.textField.textHeight;
			add(characterSelectText);

			FlxTween.tween(characterSelectText,{alpha: 1}, 0.5, {ease: FlxEase.expoInOut});
		}

		// Initialize warning sprites
		shapeNoteWarning = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image('ui/OST1'));
		shapeNoteWarning.scrollFactor.set();
		shapeNoteWarning.antialiasing = false;
		shapeNoteWarning.alpha = 0;
		add(shapeNoteWarning);

		shapeNoteWarning2 = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image('ui/OST2'));
		shapeNoteWarning2.scrollFactor.set();
		shapeNoteWarning2.antialiasing = false;
		shapeNoteWarning2.alpha = 0;
		add(shapeNoteWarning2);

		shapeNoteWarning3 = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image('ui/OST3'));
		shapeNoteWarning3.scrollFactor.set();
		shapeNoteWarning3.antialiasing = false;
		shapeNoteWarning3.alpha = 0;
		add(shapeNoteWarning3);

		shapeNoteWarningDefault = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image('ui/OSTDefault'));
		shapeNoteWarningDefault.scrollFactor.set();
		shapeNoteWarningDefault.antialiasing = false;
		shapeNoteWarningDefault.alpha = 0;
		add(shapeNoteWarningDefault);

		// Initialize locked song text
		lockedSongText = new FlxText(0, 0, FlxG.width, "", 32);
		lockedSongText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lockedSongText.borderSize = 2;
		lockedSongText.antialiasing = true;
		lockedSongText.scrollFactor.set();
		lockedSongText.screenCenter();
		lockedSongText.alpha = 0;
		add(lockedSongText);
	
		add(diffText);
		add(scoreText);

		FlxTween.tween(scoreBG,{y: 0},0.5,{ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText,{y: -5},0.5,{ease: FlxEase.expoInOut});
		FlxTween.tween(diffText,{y: 30},0.5,{ease: FlxEase.expoInOut});
		
		for (song in 0...grpSongs.length)
		{
			grpSongs.members[song].unlockY = true;

			// item.targetY = bullShit - curSelected;
			FlxTween.tween(grpSongs.members[song], {y: song, alpha: song == curSelected ? 1 : 0.6}, 0.5, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween)
			{
				grpSongs.members[song].unlockY = false;

				canInteract = true;
			}});
		}

		changeSelection();
		updateWarningDisplay(); // Show initial warning
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
			CurrentPack = Catagories.length - 1;
		
		if (CurrentPack == Catagories.length)
			CurrentPack = 0;

		camFollow.x = icons[CurrentPack].x + 256;
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;

		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	function getWarningType(songName:String):Int
	{
		var lowerSong = songName.toLowerCase();
		
		// Album Type 1
		if (lowerSong == 'warmup' || lowerSong ==  'luna' || lowerSong == 'treats' || lowerSong == 'scratch' || lowerSong == 'fatalistic' || lowerSong == 'nomophobia' || lowerSong == 'disoriented' || lowerSong == 'meow')
			return 1;
		
		// Album Type 2
		if (lowerSong == 'action' || lowerSong == 'action-two' || lowerSong == 'galactic' || lowerSong == 'milky-way' || lowerSong == 'cheating' || lowerSong == 'unfairness')
			return 2;
		
		// Album Type 3
		if (lowerSong == 'master' || lowerSong == 'heavenly' || lowerSong == 'septuagint' || lowerSong == 'clamorous' || lowerSong == 'psychosis')
			return 3;
		
		// Album Default
		return 0;
	}

	function updateWarningDisplay()
	{
		if (!InMainFreeplayState || songs.length == 0)
			return;

		var newWarningType = getWarningType(songs[curSelected].songName);

		// Cancel all ongoing tweens on ALL warning sprites
		FlxTween.cancelTweensOf(shapeNoteWarning);
		FlxTween.cancelTweensOf(shapeNoteWarning2);
		FlxTween.cancelTweensOf(shapeNoteWarning3);
		FlxTween.cancelTweensOf(shapeNoteWarningDefault);

		// Instantly hide ALL warnings
		shapeNoteWarning.alpha = 0;
		shapeNoteWarning.y = FlxG.height * 2;
		shapeNoteWarning2.alpha = 0;
		shapeNoteWarning2.y = FlxG.height * 2;
		shapeNoteWarning3.alpha = 0;
		shapeNoteWarning3.y = FlxG.height * 2;
		shapeNoteWarningDefault.alpha = 0;
		shapeNoteWarningDefault.y = FlxG.height * 2;

		// Always show the new warning
		var newWarning:FlxSprite = null;
		switch (newWarningType)
		{
			case 1:
				newWarning = shapeNoteWarning;
			case 2:
				newWarning = shapeNoteWarning2;
			case 3:
				newWarning = shapeNoteWarning3;
			case 0:
				newWarning = shapeNoteWarningDefault;
		}

		if (newWarning != null)
		{
			currentWarning = newWarning;
			currentWarningType = newWarningType;

			// Reset position and alpha before animating in
			newWarning.y = FlxG.height * 2;
			newWarning.alpha = 0;

			FlxTween.tween(newWarning, {alpha: 1}, 0.8);
			FlxTween.tween(newWarning, {y: 450}, 0.8, {ease: FlxEase.backOut});
		}
	}

	function showLockedSongMessage(songName:String)
	{
		var message:String = "Unknown unlock...";
		var lowerSong = songName.toLowerCase();

		// Specific messages for certain songs
		if (lowerSong == "opposition")
		{
			message = "Pressing 7 somewhere may unlock this song.";
		}
		else if (lowerSong == "optoplistic")
		{
			message = "TURN BACK NOW.";
		}

		lockedSongText.text = message;
		lockedSongText.y = FlxG.height - 150;
		lockedSongText.screenCenter(X);
		
		// Cancel any existing timer
		if (lockedSongTimer != null)
		{
			lockedSongTimer.cancel();
		}

		// Bouncy animation in
		FlxTween.cancelTweensOf(lockedSongText);
		lockedSongText.alpha = 0;
		lockedSongText.y += 50; // Start lower
		FlxTween.tween(lockedSongText, {alpha: 1, y: lockedSongText.y - 50}, 0.5, {ease: FlxEase.backOut});

		// Start 3 second timer to fade out
		lockedSongTimer = new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.tween(lockedSongText, {alpha: 0}, 0.5);
		});
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if SHADERS_ENABLED
		if (bgShader != null)
		{
			bgShader.shader.uTime.value[0] += elapsed;
		}
		#end

		if (InMainFreeplayState)
		{
			timeSincePress += elapsed;

			if (timeSincePress > 2 && pressSpeeds.length > 0)
			{
				resetPresses();
			}
				if (pressSpeeds.length >= pressUnlockNumber && !FlxG.save.data.recursedUnlocked)
				{
					var canPass:Bool = true;
					for (i in 0...pressSpeeds.length)
					{
						var pressSpeed = pressSpeeds[i];
						if (pressSpeed >= 0.5)
						{
							canPass = false;
						}
					}
					if (canPass)
					{
						recursedUnlock();
					}
					else
					{
						resetPresses();
					}
				}
			}
			else
			{
				timeSincePress = 0;
			}

		// Selector Menu Functions
		if (!InMainFreeplayState) 
		{
			scoreBG = null;
			scoreText = null;
			diffText = null;
			characterSelectText = null;
			
			if (controls.LEFT_P && canInteract)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P && canInteract)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack && canInteract)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				canInteract = false;

				new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
				{
					loadingPack = true;
					LoadProperPack();
					
					for (item in icons) { FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut}); }
					for (item in titles) { FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut}); }
					
					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{
						for (item in icons) { item.visible = false; }
						for (item in titles) { item.visible = false; }

						GoToActualFreeplay();
						resetPresses();
						InMainFreeplayState = true;
						loadingPack = false;
					});
				});
			}
			if (controls.BACK && canInteract && !awaitingExploitation)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new MainMenuState());
			}

			return;
		}

		// Freeplay Functions
		else
		{
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;
	
			if (upP && canInteract)
			{
				stringKey = 'up';
				changeSelection(-1);
			}
			if (downP && canInteract)
			{
				stringKey = 'down';
				changeSelection(1);
			}
			if (controls.RIGHT_P)
				changeDiff(1);
			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.BACK && canInteract)
			{				
				loadingPack = true;
				canInteract = false;
				
				FlxG.sound.play(Paths.sound('cancelMenu'));

				// Hide all warnings when going back
				if (currentWarning != null)
				{
					FlxTween.tween(currentWarning, {alpha: 0}, 0.3);
					FlxTween.tween(currentWarning, {y: FlxG.height * 2}, 0.3, {ease: FlxEase.backIn});
				}
				currentWarningType = -1;
				currentWarning = null;
				
				// Hide locked song message
				if (lockedSongText != null)
				{
					FlxTween.cancelTweensOf(lockedSongText);
					lockedSongText.alpha = 0;
					if (lockedSongTimer != null)
					{
						lockedSongTimer.cancel();
					}
				}
				
				for (i in grpSongs)
				{
					i.unlockY = true;

					FlxTween.tween(i, {y: 5000, alpha: 0}, 0.3, {onComplete: function(twn:FlxTween)
					{
						i.unlockY = false;

						for (item in icons) { item.visible = true; FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut}); }
						for (item in titles) { item.visible = true; FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut}); }

						if (scoreBG != null)
						{
							FlxTween.tween(scoreBG,{y: scoreBG.y - 100},0.5,{ease: FlxEase.expoInOut, onComplete: 
							function(spr:FlxTween)
							{
								scoreBG = null;
							}});
						}

						if (scoreText != null)
						{
							FlxTween.tween(scoreText,{y: scoreText.y - 100},0.5,{ease: FlxEase.expoInOut, onComplete: 
							function(spr:FlxTween)
							{
								scoreText = null;
							}});
						}

						if (diffText != null)
						{
							FlxTween.tween(diffText,{y: diffText.y - 100}, 0.5,{ease: FlxEase.expoInOut, onComplete: 
							function(spr:FlxTween)
							{
								diffText = null;
							}});
						}
						if (showCharText)
						{
							if (characterSelectText != null)
							{
								FlxTween.tween(characterSelectText,{alpha: 0}, 0.5,{ease: FlxEase.expoInOut, onComplete: 
								function(spr:FlxTween)
								{
									characterSelectText = null;
								}});
							}
						}
	
						InMainFreeplayState = false;
						loadingPack = false;

						for (i in grpSongs) { remove(i); }
						for (i in iconArray) { remove(i); }

						FlxTween.color(bg, 0.25, bg.color, defColor);

						// MAKE SURE TO RESET EVERYTHIN!
						songs = [];
						grpSongs.members = [];
						iconArray = [];
						curSelected = 0;
						canInteract = true;
					}});
				}
			}
			if (accepted && canInteract && 
				(!noExtraKeys.contains(songs[curSelected].songName.toLowerCase()) || curDifficulty != 0) &&
				(!noPussy.contains(songs[curSelected].songName.toLowerCase()) || curDifficulty != 2))
			{
				switch (songs[curSelected].songName)
				{
					case 'Enter Terminal':
						FlxG.switchState(new TerminalState());
					case 'Locked Song':
						// Play lock sound and shake screen
						FlxG.sound.play(Paths.sound('lock'));
						FlxG.camera.shake(0.01, 0.1);
						
						// Show locked song message
						showLockedSongMessage(songs[curSelected].songName);
						
						canInteract = true; // Re-enable interaction immediately
					default:
						canInteract = false; // Prevent multiple inputs
						FlxG.sound.play(Paths.sound('confirmMenu'));

						// Animate all song entries
						for (i in 0...grpSongs.members.length)
						{
							var item = grpSongs.members[i];
							var icon = iconArray[i];
	
							if (i != curSelected)
							{
								// Fade out non-selected items
								FlxTween.tween(item, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										item.kill();
									}
								});
								FlxTween.tween(icon, {alpha: 0}, 1.3, {ease: FlxEase.quadOut});
							}
							else
							{
								// Selected item: flicker only
								FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									// Proceed to load the song after flicker
									FlxG.sound.music.fadeOut(1, 0);
									PlayState.SONG = Song.loadFromJson(Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty));
									PlayState.isStoryMode = false;
									PlayState.storyDifficulty = curDifficulty;
	
									PlayState.characteroverride = "none";
									PlayState.formoverride = "none";
									PlayState.curmult = [1, 1, 1, 1];
		
									PlayState.storyWeek = songs[curSelected].week;
			
									packTransitionDone = false;
			
									// FIX: Check for both skipSelect AND CTRL held for Extra Keys mode
									var shouldSkipCharSelect = (FlxG.keys.pressed.CONTROL || skipSelect.contains(PlayState.SONG.song.toLowerCase()));
									var isExploitationWithoutModchart = (PlayState.SONG.song.toLowerCase() == 'exploitation' && !FlxG.save.data.modchart);
			
									if (shouldSkipCharSelect && !isExploitationWithoutModchart)
									{
										// Apply character overrides for Extra Keys mode (curDifficulty == 0)
										if (curDifficulty == 0) 
										{
											if (PlayState.SONG.song.toLowerCase() == 'roofs') 
											{
												PlayState.characteroverride = "shaggy";
												PlayState.formoverride = "redshaggy";
											} 
											else if (PlayState.SONG.song.toLowerCase() == 'exploitation') 
											{
												PlayState.characteroverride = "shaggy";
												PlayState.formoverride = "godshaggy";
											} 
											else 
											{
												PlayState.characteroverride = "shaggy";
												PlayState.formoverride = "shaggy";
											}
										}
										LoadingState.loadAndSwitchState(new PlayState());
									}
									else
									{
										if (!FlxG.save.data.wasInCharSelect)
										{
											FlxG.save.data.wasInCharSelect = true;
											FlxG.save.flush();
										}
										LoadingState.loadAndSwitchState(new CharacterSelectState());
									}
								});
							}
						}
				}
			}
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (scoreText != null)
			scoreText.text = LanguageManager.getTextString('freeplay_personalBest') + lerpScore;
			positionHighscore();

	}
	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		// wrap around 0–2 range
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		updateDifficultyText();
	}

	function updateDifficultyText()
	{
		var diff:String = 'HARD';
		switch (curDifficulty)
		{
			case 0:
				// Extra Keys
				if (songs[curSelected].week == 16)
					diff = LanguageManager.getTextString('freeplay_fuckedek');
				else
					diff = LanguageManager.getTextString('freeplay_extrakeys');

			case 1:
				// Hard (existing logic stays the same)
				switch (songs[curSelected].week)
				{
					case 3:
						diff = LanguageManager.getTextString('freeplay_finale');
					case 5:
						diff = LanguageManager.getTextString('freeplay_gold');
					case 6:
						diff = LanguageManager.getTextString('freeplay_scary');
					case 7:
						diff = LanguageManager.getTextString('freeplay_obama');
					case 8:
						diff = LanguageManager.getTextString('freeplay_puda');
					case 10:
						diff = "RECURSED";
					case 11:
						diff = LanguageManager.getTextString('freeplay_alls');
					case 12:
						diff = LanguageManager.getTextString('freeplay_noah');
					case 13:
						diff = LanguageManager.getTextString('freeplay_sus');
					case 16:
						diff = LanguageManager.getTextString('freeplay_fucked');
					case 18:
						diff = LanguageManager.getTextString('freeplay_extreme');
					case 23:
						diff = LanguageManager.getTextString('freeplay_spectre');
					case 24:
						diff = LanguageManager.getTextString('freeplay_spectre');
					case 25:
						diff = LanguageManager.getTextString('freeplay_slave');
					default:
						diff = LanguageManager.getTextString('freeplay_hard');
				}

			case 2:
				// Pussy difficulty
				diff = "PUSSY";
		}

		diffText.text = diff;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (change != 0)
		{
			pressSpeed = timeSincePress - lastTimeSincePress;

			lastTimeSincePress = timeSincePress;

			timeSincePress = 0;
			pressSpeeds.push(Math.abs(pressSpeed));
			
			var inputKeys = controls.getInputsFor(Controls.stringControlToControl(stringKey), Device.Keys);
			if (pressSpeeds.length == 1)
			{
				requiredKey = inputKeys;
			}
			if (!CoolUtil.isArrayEqualTo(requiredKey, inputKeys))
			{
				resetPresses();
			}
			var shakeCheck = pressSpeeds.length % 5;
			if (shakeCheck == 0 && pressSpeeds.length > 0 && !FlxG.save.data.recursedUnlocked)
			{
				FlxG.camera.shake(0.003 * (pressSpeeds.length / 5), 0.1);
				FlxG.sound.play(Paths.sound('recursed/thud', 'shared'), 1, false, null, true);
			}
		}
		
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
	
		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].songName != 'Enter Terminal')
		{
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end

			#if PRELOAD_ALL
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			#end
			
			curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		}
		
		if (diffText != null)
			updateDifficultyText();
		
		// Update warning display when selection changes
		updateWarningDisplay();
		
		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
	}
	function getTrueSongTextWidth(song:Alphabet)
	{
		var index = grpSongs.members.indexOf(song);
		var icon = iconArray[index];

		return song.width + icon.width + 10;
	}
	function resetPresses()
	{
		pressSpeeds = new Array<Float>();
		pressUnlockNumber = new FlxRandom().int(20, 40);
	}
	function recursedUnlock()
	{
		canInteract = false;

		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.sound('recursed/rumble', 'shared'), 0.8, false, null);
		var boom = new FlxSound().loadEmbedded(Paths.sound('recursed/boom', 'shared'), false, false);

		FlxG.camera.shake(0.015, 3, function()
		{
			FlxG.camera.flash();
			var objects:Array<FlxSprite> = new Array<FlxSprite>();
			for (icon in iconArray)
			{
				icon.screenCenter();
				icon.sprTracker = null;
				objects.push(icon);

				icon.velocity.set(new FlxRandom().float(-300, 400), new FlxRandom().float(-200, 400));
				icon.angularVelocity = 60;
			}
			for (song in grpSongs)
			{
				song.unlockY = true;
				song.screenCenter();
				for (character in song.characters)
				{
					character.velocity.set(new FlxRandom().float(-100, 250), new FlxRandom().float(-100, 250));
					character.angularVelocity = 80;
					objects.push(character);
				}
			}
			boom.play();
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.sound('recursed/ambience', 'shared'), 1, false, null);

			bg.color = FlxColor.fromRGB(44, 44, 44);
			new FlxTimer().start(4, function(timer:FlxTimer)
			{
				for (object in objects)
				{
					object.angularVelocity = 0;
					object.velocity.set();
					FlxTween.tween(object, {x: (FlxG.width / 2) - (object.width), y: (FlxG.height / 2) - (object.height)}, 1, {ease: FlxEase.backOut});
				}
				FlxG.camera.shake(0.05, 3);
				
				FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.sound('recursed/rumble', 'shared'), 0.8, false, null);
				FlxG.sound.play(Paths.sound('recursed/piecedTogether', 'shared'), 1, false, null, true);

				FlxG.camera.fade(FlxColor.WHITE, 3, false, function() 
				{
					FlxG.camera.shake(0.1, 0.5);
					FlxG.camera.fade(FlxColor.BLACK, 0);

					FlxG.sound.play(Paths.sound('recursed/recurser_laugh', 'shared'), function()
					{
						new FlxTimer().start(1, function(timer:FlxTimer)
						{
							PlayState.SONG = Song.loadFromJson("Recursed");

							PlayState.storyWeek = 10;

							PlayState.formoverride = 'none';

							FlxG.save.data.recursedUnlocked = true;
							FlxG.save.flush();

							LoadingState.loadAndSwitchState(new PlayState());
						});
					});
				});
			});
		});
	}
	static function getSongWeek(song:String)
	{
		
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}