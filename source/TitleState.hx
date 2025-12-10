package;

import haxe.Http;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end

// only load this reference if its debug because its only needed for debug??? idk it might help with the file size or something 
#if debug
import openfl.net.FileReference;
import haxe.Json;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

    var bg:FlxSprite;
    var bgShader:Shaders.GlitchEffect; // add shader var

	var fun:Int;
	var awaitingExploitation:Bool;
	var eye:FlxSprite;
	var loopEyeTween:FlxTween;

	override public function create():Void
	{		
		fun = FlxG.random.int(0, 999);
		if(fun == 1)
		{
			LoadingState.loadAndSwitchState(new SusState());
		}

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		#if desktop
		DiscordClient.initialize();
		#end

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		SaveDataHandler.initSave();
		LanguageManager.init();

		Highscore.load();
		
		CoolUtil.init();

		Main.fps.visible = !FlxG.save.data.disableFps;

		CompatTool.initSave();
		if(CompatTool.save.data.compatMode == null)
        {
            FlxG.switchState(new CompatWarningState());
        }

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}
		

		awaitingExploitation = FlxG.save.data.exploitationState == 'awaiting';

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});		
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(-1, 0), {asset: diamond, width: 32, height: 32},
				new FlxRect(0, 0, FlxG.width * 2, FlxG.height * 2));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(1, 0),
				{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width * 2, FlxG.height * 2));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

		if (awaitingExploitation)
		{
			// Exploitation versions
			if (FlxG.save.data.altMenuMusic == 1) // FreakierMenu
			{
				FlxG.sound.playMusic(Paths.music('freakierMenu_ex'), 0);
				Conductor.changeBPM(135);
			}
			else if (FlxG.save.data.altMenuMusic == 2) // NoahEngine
			{
				FlxG.sound.playMusic(Paths.music('noahEngine_ex'), 0);
				Conductor.changeBPM(102);
			}
			else if (FlxG.save.data.altMenuMusic == 3) // Pinecone
			{
				FlxG.sound.playMusic(Paths.music('pinecone_ex'), 0);
				Conductor.changeBPM(293);
			}
			else if (FlxG.save.data.altMenuMusic == 4) // Playstation
			{
				FlxG.sound.playMusic(Paths.music('playstation_ex'), 0);
				Conductor.changeBPM(121);
			}
			else if (FlxG.save.data.altMenuMusic == 5) // Love Songs
			{
				FlxG.sound.playMusic(Paths.music('loveSongs_ex'), 0);
				Conductor.changeBPM(120);
			}
			else if (FlxG.save.data.altMenuMusic == 6) // Jacobs Ladder
			{
				FlxG.sound.playMusic(Paths.music('jacobsLadder_ex'), 0);
				Conductor.changeBPM(146);
			}
			else if (FlxG.save.data.altMenuMusic == 7) // Diddy Blud
			{
				FlxG.sound.playMusic(Paths.music('diddyBlud_ex'), 0);
				Conductor.changeBPM(184);
			}
		    else if (FlxG.save.data.altMenuMusic == 8) // She Will
		    {
		        FlxG.sound.playMusic(Paths.music('sheWill_ex'), 0);
		        Conductor.changeBPM(152);
		    }
		    else if (FlxG.save.data.altMenuMusic == 9) // SDP
		    {
		        FlxG.sound.playMusic(Paths.music('sdp_ex'), 0);
		        Conductor.changeBPM(120);
		    }
		    else if (FlxG.save.data.altMenuMusic == 10) // I Believed It
		    {
		        FlxG.sound.playMusic(Paths.music('iBelievedIt_ex'), 0);
		        Conductor.changeBPM(145);
		    }
			else // FreakyMenu (default)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu_ex'), 0);
				Conductor.changeBPM(150);
			}
		}
		else
		{
			// Normal versions
			if (FlxG.save.data.altMenuMusic == 1) // FreakierMenu
			{
				FlxG.sound.playMusic(Paths.music('freakierMenu'), 0);
				Conductor.changeBPM(135);
			}
			else if (FlxG.save.data.altMenuMusic == 2) // NoahEngine
			{
				FlxG.sound.playMusic(Paths.music('noahEngine'), 0);
				Conductor.changeBPM(102);
			}
			else if (FlxG.save.data.altMenuMusic == 3) // Pinecone
			{
				FlxG.sound.playMusic(Paths.music('pinecone'), 0);
				Conductor.changeBPM(293);
			}
			else if (FlxG.save.data.altMenuMusic == 4) // Playstation
			{
				FlxG.sound.playMusic(Paths.music('playstation'), 0);
				Conductor.changeBPM(121);
			}
			else if (FlxG.save.data.altMenuMusic == 5) // Love Songs
			{
				FlxG.sound.playMusic(Paths.music('loveSongs'), 0);
				Conductor.changeBPM(120);
			}
			else if (FlxG.save.data.altMenuMusic == 6) // Jacobs Ladder
			{
				FlxG.sound.playMusic(Paths.music('jacobsLadder'), 0);
				Conductor.changeBPM(146);
			}
			else if (FlxG.save.data.altMenuMusic == 7) // Diddy Blud
			{
				FlxG.sound.playMusic(Paths.music('diddyBlud'), 0);
				Conductor.changeBPM(184);
			}
		    else if (FlxG.save.data.altMenuMusic == 8) // She Will
		    {
		        FlxG.sound.playMusic(Paths.music('sheWill'), 0);
		        Conductor.changeBPM(152);
		    }
		    else if (FlxG.save.data.altMenuMusic == 9) // SDP
		    {
		        FlxG.sound.playMusic(Paths.music('sdp'), 0);
		        Conductor.changeBPM(120);
		    }
		    else if (FlxG.save.data.altMenuMusic == 10) // I Believed It
		    {
		        FlxG.sound.playMusic(Paths.music('iBelievedIt'), 0);
		        Conductor.changeBPM(145);
		    }
			else // FreakyMenu (default)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				Conductor.changeBPM(150);
			}
		}
	}

	FlxG.sound.music.fadeIn(4, 0, 0.7);
	persistentUpdate = true;

		// THE NEW WALLPAPER CODEEEEEEEEEEEEEEEEEEEE -johnny
        if (awaitingExploitation)
        {
            // Wavy wallpaper background
            bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/oooshittt', 'shared'));
            bg.scrollFactor.set();
            bg.antialiasing = false;

            #if SHADERS_ENABLED
            bgShader = new Shaders.GlitchEffect();
            bgShader.waveAmplitude = 0.1;
            bgShader.waveFrequency = 5;
            bgShader.waveSpeed = 2;
            bg.shader = bgShader.shader;
            #end

            add(bg);
        }
        else
        {
            // Wavy wallpaper background
            bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/mainmenubgbutdarkenedlol', 'shared'));
            bg.scrollFactor.set();
            bg.antialiasing = false;

            #if SHADERS_ENABLED
            bgShader = new Shaders.GlitchEffect();
            bgShader.waveAmplitude = 0.1;
            bgShader.waveFrequency = 5;
            bgShader.waveSpeed = 2;
            bg.shader = bgShader.shader;
            #end

            add(bg);
        }

		logoBl = new FlxSprite(-95, -80);
		if (!awaitingExploitation)
		{
			logoBl.frames = Paths.getSparrowAtlas('ui/logoBumpin');
		}
		else
		{
			logoBl.frames = Paths.getSparrowAtlas('ui/logoBumpinExpunged');
			Application.current.window.title = "Friday Night Funkin' | VS. Luna?";
		}
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.setGraphicSize(Std.int(logoBl.width * 1));
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		if (awaitingExploitation)
		{
			logoBl.screenCenter(X);

			eye = new FlxSprite(0, 0).loadGraphic(Paths.image('mainMenu/eye'));
			eye.screenCenter();
			eye.antialiasing = false;
			eye.alpha = 0;
			add(eye);

			loopEyeTween = FlxTween.tween(eye, {alpha: 1}, 1, {
				onComplete: function(tween:FlxTween)
				{
					FlxTween.tween(eye, {alpha: 0}, 1, {
						onComplete: function(tween:FlxTween)
						{
							loopEyeTween.start();
						}
					});
				},
				type: PERSIST
			});
		}
		
		if (!awaitingExploitation)
		{
			gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
			gfDance.frames = Paths.getSparrowAtlas('ui/gfDanceTitle');
			gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			gfDance.antialiasing = true;
			add(gfDance);
		}
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('ui/titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 18, false);
		titleText.screenCenter(X);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "MoldyGH\nMissingTextureMan101\nRapparep\nZmac\nTheBuilder\nT5mpler\nErizur", true);
		credTextShit.antialiasing = true;
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);

		// Init the first line of text on the intro start to prevent the intro text bug
		createCoolText(['Created by:']);
		addMoreText('Johnny5997');
		addMoreText('GD Noah');
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

        // Update shader if active
        #if SHADERS_ENABLED
        if (bgShader != null)
            bgShader.update(elapsed);
        #end

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (FlxG.keys.justPressed.ALT)
		{
			FlxG.switchState(new CompatWarningState());
		}
		
		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 0.5);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(FlxG.save.data.alreadyGoneToWarningScreen && FlxG.save.data.exploitationState != 'playing' ? new MainMenuState() : new OutdatedSubState());
			});
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(credGroup);
			skippedIntro = true;
	
			FlxG.camera.fade(FlxColor.WHITE, 2.5, true);
		}
	}


	override function beatHit()
	{
		if (logoBl != null && gfDance != null)
		{
			super.beatHit();

			danceLeft = !danceLeft;

			logoBl.animation.play('bump');
	
			if (danceLeft) gfDance.animation.play('danceRight');
			else gfDance.animation.play('danceLeft');
	
			switch (curBeat)
			{
				case 3:
					addMoreText('MoldyGH');
					addMoreText('MissingTextureMan101');
				case 4:
					addMoreText('Rapparep LOL, and more');
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Luna chromatics by Ruby']);
				case 7:
					addMoreText('Engine originally from Vs Dave and Bambi');
				case 8:
					deleteCoolText();
				case 9:
					createCoolText([curWacky[0]]);
				case 10:
					addMoreText(curWacky[1]);
				case 11:
					deleteCoolText();
				case 12:
					createCoolText(['With lots of help from']);
				case 13:
					addMoreText('Our amazing contributors!');
				case 14:
					addMoreText('And others');
				case 15:
					deleteCoolText();
				case 17:
					addMoreText('mod of the year');
				case 18:
					addMoreText('2025');
				case 19:
					deleteCoolText();
				case 20:
					addMoreText('Special thanks to');
				case 21:
					addMoreText('Magman');
				case 22:
					addMoreText('For Extra Keys mod');
				case 23:
					deleteCoolText();
				case 25:
					addMoreText('Welcome');
				case 26:
					addMoreText('to...');
				case 27:
					deleteCoolText();
				case 28:
					addMoreText("Friday Night Funkin'");
				case 29:
					addMoreText(awaitingExploitation ? 'Vs. Luna?' : 'VS Luna');
				case 30:
					addMoreText(!awaitingExploitation  ? 'The Cat' : 'The Full Mod');
				case 31:
					var text:String = !awaitingExploitation  ? 'The Full Mod' : 'HAHAHHAHAHAHAHHAHAHAHAHHAHAHAHAHHAHA\nHAHAHHAHAHAHAHHAHAHAHAHHAHAHAHAHHAHA\nHAHAHHAHAHAHAHHAHAHAHAHHAHAHAHAHHAHA';
					if (awaitingExploitation) FlxG.sound.play(Paths.sound('evilLaugh', 'shared'), 0.7);
					addMoreText(text);
				case 32:
					skipIntro();
			}
		}
	}

	// INTRO TEXT MANIPULATION SHIT

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:FlxText = new FlxText(0, 0, FlxG.width, textArray[i], 48);
			money.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER);
			money.antialiasing = true;
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:FlxText = new FlxText(0, 0, FlxG.width, text, 48);
		coolText.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER);
		coolText.screenCenter(X);
		coolText.antialiasing = true;
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}
	
	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}
	
	function deleteOneCoolText()
	{
		credGroup.remove(textGroup.members[0], true);
		textGroup.remove(textGroup.members[0], true);
	}
}
