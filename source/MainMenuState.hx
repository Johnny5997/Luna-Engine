package;

import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import sys.FileSystem;
import flixel.util.FlxSave;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

import flixel.system.FlxSound;
import sys.io.File;
import sys.FileSystem;

using StringTools;

var sevenPressCount:Int = 0;
var popupGroup:FlxSpriteGroup;
var inputField:FlxInputText;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = 
	[
		'story mode', 
		'freeplay', 
		'credits',
		'ost',
		'options',
		'changelog',
		'discord'
	];

	var languagesOptions:Array<String> =
	[
		'main_story',
		'main_freeplay',
		'main_credits',
		'main_ost',
		'main_options',
		'main_changelog',
		'main_discord'
	];

	var languagesDescriptions:Array<String> =
	[
		'desc_story',
		'desc_freeplay',
		'desc_credits',
		'desc_ost',
		'desc_options',
		'desc_changelog',
		'desc_discord'
	];

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	public static var daRealEngineVer:String = 'Luna';
	public static var engineVer:String = '1.0 Beta 8';

	public static var engineVers:Array<String> = 
	[
		'Luna', 
		'Puda', 
		'Mittens',
		'Alls'
	];

	public static var kadeEngineVer:String = "LUNA";
	public static var gameVer:String = "0.2.7.1";
	
	var bg:FlxSprite;
	var magenta:FlxSprite;
	var selectUi:FlxSprite;
	var bigIcons:FlxSprite;
	var camFollow:FlxObject;
	public static var bgPaths:Array<String> = [
		'Johnny5997',
	];

	var logoBl:FlxSprite;

	var lilMenuGuy:FlxSprite;

	var awaitingExploitation:Bool;
	var curOptText:FlxText;
	var curOptDesc:FlxText;

	var voidShader:Shaders.GlitchEffect;
	
	var prompt:Prompt;
	var canInteract:Bool = true;

	var black:FlxSprite;

	override function create()
	{
		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		if (!FlxG.sound.music.playing)
		{
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
		    else // FreakyMenu (default)
		    {
		        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		        Conductor.changeBPM(150);
		    }
		}
		persistentUpdate = persistentDraw = true;


		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		KeybindPrefs.loadControls();
		
		MathGameState.accessThroughTerminal = false;

		// daRealEngineVer = engineVers[FlxG.random.int(0, 2)];

		if (awaitingExploitation)
		{
			optionShit = ['freeplay glitch', 'options'];
			languagesOptions = ['main_freeplay_glitch', 'main_options'];
			languagesDescriptions = ['desc_freeplay_glitch', 'desc_options'];
			bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			bg.scrollFactor.set(0, 0.2);
			bg.antialiasing = false;
			bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
			add(bg);

			#if SHADERS_ENABLED
			voidShader = new Shaders.GlitchEffect();
			voidShader.waveAmplitude = 0.1;
			voidShader.waveFrequency = 5;
			voidShader.waveSpeed = 2;
			bg.shader = voidShader.shader;
			#end

			magenta = new FlxSprite(-600, -200).loadGraphic(bg.graphic);
			magenta.scrollFactor.set();
			magenta.antialiasing = false;
			magenta.visible = false;
			magenta.color = FlxColor.multiply(0xFFfd719b, FlxColor.fromRGB(50, 50, 50));
			add(magenta);

			#if SHADERS_ENABLED
			magenta.shader = voidShader.shader;
			#end
		}
		else
		{
			switch(FlxG.save.data.mainMenuBG)
			{
				case 0: // Luna
					bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/mainmenubg', 'shared'));
					#if SHADERS_ENABLED
					voidShader = new Shaders.GlitchEffect();
					voidShader.waveAmplitude = 0.1;
					voidShader.waveFrequency = 5;
					voidShader.waveSpeed = 2;
					bg.shader = voidShader.shader;
					#end

				case 1: // Pinecone
					bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/mainmenu/pineconemenubg', 'shared'));
					// no shader here

					magenta = new FlxSprite(-500, -300).loadGraphic(bg.graphic);
					magenta.scrollFactor.set();
					magenta.antialiasing = false;
					magenta.visible = false;
					magenta.color = FlxColor.multiply(0xFFfd719b, FlxColor.fromRGB(200, 200, 200));
					add(magenta);

				case 2: // House
					bg = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/void/mainmenu/house', 'shared'));
					// no shader here

					magenta = new FlxSprite(0, 0).loadGraphic(bg.graphic);
					magenta.scrollFactor.set();
					magenta.antialiasing = false;
					magenta.visible = false;
					magenta.color = FlxColor.multiply(0xFFfd719b, FlxColor.fromRGB(200, 200, 200));
					add(magenta);

				case 3: // Tessattack
					bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/tessattack', 'shared'));
					#if SHADERS_ENABLED
					voidShader = new Shaders.GlitchEffect();
					voidShader.waveAmplitude = 0.1;
					voidShader.waveFrequency = 5;
					voidShader.waveSpeed = 2;
					bg.shader = voidShader.shader;
					#end

				case 4: // Golden Void
					bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/golden_void', 'shared'));
					#if SHADERS_ENABLED
					voidShader = new Shaders.GlitchEffect();
					voidShader.waveAmplitude = 0.1;
					voidShader.waveFrequency = 5;
					voidShader.waveSpeed = 2;
					bg.shader = voidShader.shader;
					#end

				case 5: // Kade Engine
					bg = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/void/mainmenu/kade', 'shared'));
					// no shader here

					magenta = new FlxSprite(0, 0).loadGraphic(bg.graphic);
					magenta.scrollFactor.set();
					magenta.antialiasing = false;
					magenta.visible = false;
					magenta.color = FlxColor.multiply(0xFFfd719b, FlxColor.fromRGB(200, 200, 200));
					add(magenta);
			}

			bg.scrollFactor.set(0, 0.2);
			bg.antialiasing = false;
			add(bg);
		}

		selectUi = new FlxSprite(0, 0).loadGraphic(Paths.image('mainMenu/Select_Thing', 'preload'));
		selectUi.scrollFactor.set(0, 0);
		selectUi.antialiasing = true;
		selectUi.updateHitbox();
		add(selectUi);

		bigIcons = new FlxSprite(0, 0);
		bigIcons.frames = Paths.getSparrowAtlas('ui/menu_big_icons');
		for (i in 0...optionShit.length)
		{
			bigIcons.animation.addByPrefix(optionShit[i], optionShit[i] == 'freeplay' ? 'freeplay0' : optionShit[i], 24);
		}
		bigIcons.scrollFactor.set(0, 0);
		bigIcons.antialiasing = true;
		bigIcons.updateHitbox();
		bigIcons.animation.play(optionShit[0]);
		bigIcons.screenCenter(X);
		add(bigIcons);

		curOptText = new FlxText(0, 0, FlxG.width, CoolUtil.formatString(LanguageManager.getTextString(languagesOptions[curSelected]), ' '));
		curOptText.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curOptText.scrollFactor.set(0, 0);
		curOptText.borderSize = 2.5;
		curOptText.antialiasing = true;
		curOptText.screenCenter(X);
		curOptText.y = FlxG.height / 2 + 28;
		add(curOptText);

		curOptDesc = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString(languagesDescriptions[curSelected]));
		curOptDesc.setFormat("Comic Sans MS Bold", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curOptDesc.scrollFactor.set(0, 0);
		curOptDesc.borderSize = 2;
		curOptDesc.antialiasing = true;
		curOptDesc.screenCenter(X);
		curOptDesc.y = FlxG.height - 58;
		add(curOptDesc);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('ui/main_menu_icons');

		//camFollow = new FlxObject(0, 0, 1, 1);
		//add(camFollow);

		//FlxG.camera.follow(camFollow, null, 0.06);

		//camFollow.setPosition(640, 150.5);

		for (i in 0...optionShit.length)
		{
			var currentOptionShit = optionShit[i];
			var menuItem:FlxSprite = new FlxSprite(FlxG.width * 1.6, 0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " basic", 24);
			menuItem.animation.addByPrefix('selected', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " white", 24);
			menuItem.animation.play('idle');
			menuItem.antialiasing = false;
			menuItem.setGraphicSize(128, 128);
			menuItem.ID = i;
			menuItem.updateHitbox();
			//menuItem.screenCenter(Y);
			//menuItem.alpha = 0; //TESTING
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			if (firstStart)
			{
				FlxTween.tween(menuItem, {x: FlxG.width / 2 - 542 + (i * 160)}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						finishedFunnyMove = true;
						//menuItem.screenCenter(Y);
						changeItem();
					}
				});
			}
			else
			{
				//menuItem.screenCenter(Y);
				menuItem.x = FlxG.width / 2 - 542 + (i * 160);
				changeItem();
			}
		}

		firstStart = false;

		var versionShit:FlxText = new FlxText(1, FlxG.height - 50, 0, '${daRealEngineVer} Engine v${engineVer}\nKade Engine v1.2\n', 12);
		versionShit.antialiasing = true;
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var pressR:FlxText = new FlxText(150, 10, 0, LanguageManager.getTextString("main_resetdata"), 12);
		pressR.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		pressR.x += 900;
		pressR.antialiasing = true;
		pressR.alpha = 0;
		pressR.scrollFactor.set();
		add(pressR);

		FlxTween.tween(pressR, {alpha: 1}, 1);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.y = FlxG.height / 2 + 130;
		});

		// NG.core.calls.event.logEvent('swag').send();
		

		super.create();
	}
	
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		#if SHADERS_ENABLED
		if (voidShader != null)
		{
			voidShader.shader.uTime.value[0] += elapsed;
		}
		#end
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (canInteract)
		{
			if (FlxG.keys.justPressed.SEVEN)
			{
				var deathSound:FlxSound = new FlxSound();
				deathSound.loadEmbedded(Paths.soundRandom('missnote', 1, 3));
				deathSound.volume = FlxG.random.float(0.6, 1);
				deathSound.play();
		
				FlxG.camera.shake(0.05, 0.1);

				sevenPressCount++;

				if (sevenPressCount >= 10)
				{
					sevenPressCount = 0;
					showSecretPopup();
				}
			}
			if (FlxG.keys.justPressed.R)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				
				prompt = new Prompt(LanguageManager.getTextString("main_warningdata"), controls);
				prompt.canInteract = true;
				prompt.alpha = 0;
				canInteract = false;
				
				
				black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.screenCenter();
				black.alpha = 0;
				add(black);

				FlxTween.tween(black, {alpha: 0.6}, 0.3);

				FlxTween.tween(prompt, {alpha: 1}, 0.5, {
					onComplete: function(tween:FlxTween)
					{
						prompt.canInteract = true;
					}
				});
				prompt.noFunc = function()
				{
					FlxTween.tween(black, {alpha: 0}, 0.3, {onComplete: function(tween:FlxTween)
					{
						remove(black);
					}});
					prompt.canInteract = false;
					FlxTween.tween(prompt, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							remove(prompt);
							FlxG.mouse.visible = false;
							canInteract = true;
						}
					});
				}
				prompt.yesFunc = function()
				{
					resetData();
				}
				add(prompt);
			}
		}
		
		if (!selectedSomethin && canInteract)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new TitleState());
			}

		if (controls.ACCEPT)
		{
			if (optionShit[curSelected] == 'discord' || optionShit[curSelected] == 'merch')
			{
				switch (optionShit[curSelected])
				{
					case 'discord':
						fancyOpenURL("https://www.discord.gg/vsdave");
				}
			}
			else
			{
				selectedSomethin = true;
				// select sound
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						// Zoom animation
						FlxTween.tween(spr.scale, {x: spr.scale.x * 1.3, y: spr.scale.y * 1.3}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								// After zoom finishes, flicker and switch
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];
									switch (daChoice)
									{
										case 'story mode':
											FlxG.switchState(new StoryMenuState());
										case 'freeplay' | 'freeplay glitch':
											if (FlxG.random.bool(0.05))
											{
												fancyOpenURL("https://www.youtube.com/watch?v=Z7wWa1G9_30%22");
											}
											FlxG.switchState(new FreeplayState());
										case 'options':
											FlxG.switchState(new OptionsMenu());
										case 'changelog':
											FlxG.switchState(new ChangelogState());
										case 'ost':
											FlxG.switchState(new MusicPlayerState());
										case 'credits':
											FlxG.switchState(new CreditsMenuState());
									}
								});
							}
						});
					}
				});
			}
			}
		}

		super.update(elapsed);

	}

	function showSecretPopup()
	{
		if (popupGroup != null && popupGroup.exists)
			return; // Prevent duplicates

		canInteract = false;
		FlxG.mouse.visible = true;

		popupGroup = new FlxSpriteGroup();

		// darken background slightly
		var darkBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
		popupGroup.add(darkBG);

		// popup box
		var box = new FlxSprite(FlxG.width / 2 - 150, FlxG.height / 2 - 100).makeGraphic(300, 200, 0xFF222222);
		box.scrollFactor.set();
		popupGroup.add(box);

		// title text
		var title = new FlxText(box.x, box.y + 15, 300, "Enter Code", 16);
		title.setFormat(null, 16, 0xFFFFFFFF, "center");
		popupGroup.add(title);

		// subtext
		var subtext = new FlxText(box.x, box.y + 40, 300, "you're not supposed to be here", 12);
		subtext.setFormat(null, 12, 0xFFAAAAAA, "center");
		popupGroup.add(subtext);

		// input field
		inputField = new FlxInputText(box.x + 25, box.y + 80, 250, "", 8);
		inputField.hasFocus = true;
		popupGroup.add(inputField);

		// ok button
		var okButton = new FlxButton(box.x + 40, box.y + 130, "OK", function() {
			var upperCode = inputField.text.toUpperCase();
			
			if (upperCode == "FIGHTINGCANCER")
			{
				closePopup();
				FlxG.sound.music.stop();
				canInteract = true;
				FlxG.switchState(new ImageState());
			}
			else if (upperCode == "LUNAVURFORSALE")
			{
				closePopup();
				triggerRecursedUnlock();
			}
		});
		okButton.setGraphicSize(70, 25);
		okButton.updateHitbox();
		popupGroup.add(okButton);

		// cancel button
		var cancelButton = new FlxButton(box.x + 160, box.y + 130, "Cancel", function() {
			canInteract = true;
			closePopup();
		});
		cancelButton.setGraphicSize(70, 25);
		cancelButton.updateHitbox();
		popupGroup.add(cancelButton);

		add(popupGroup);
		FlxTween.tween(popupGroup, { alpha: 1 }, 0.3, { ease: FlxEase.quadOut });
	}

	function closePopup()
	{
		if (popupGroup != null)
		{
			remove(popupGroup);
			popupGroup.destroy();
			popupGroup = null;
			FlxG.mouse.visible = false;
		}
	}

	function triggerRecursedUnlock()
	{
		canInteract = false;

		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.sound('recursed/rumbleLong', 'shared'), 0.8, false, null);
		var boom = new FlxSound().loadEmbedded(Paths.sound('recursed/boom', 'shared'), false, false);

		FlxG.camera.shake(0.015, 6.5, function()
		{
			FlxG.camera.flash();
			
			// Change Windows desktop wallpaper to DARKABYSS
			#if windows
			try
			{
				var gameDir = Sys.getCwd();
				var wallpaperPath = gameDir + 'assets\\shared\\images\\backgrounds\\void\\DARKABYSS.png';
				
				// Ensure the file exists
				if (FileSystem.exists(wallpaperPath))
				{
					trace('Setting wallpaper to: ' + wallpaperPath);
					
					// Method 1: Registry + Update
					Sys.command('reg add "HKEY_CURRENT_USER\\Control Panel\\Desktop" /v Wallpaper /t REG_SZ /d "' + wallpaperPath + '" /f');
					Sys.command('reg add "HKEY_CURRENT_USER\\Control Panel\\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f');
					Sys.command('reg add "HKEY_CURRENT_USER\\Control Panel\\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f');
					Sys.command('RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 ,True');
					
					// Method 2: SystemParametersInfo via command
					Sys.command('powershell.exe -Command "& {Add-Type -TypeDefinition \'using System;using System.Runtime.InteropServices;public class Wallpaper{[DllImport(\\\"user32.dll\\\", CharSet=CharSet.Auto)]public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);}\' ; [Wallpaper]::SystemParametersInfo(20, 0, \\"' + wallpaperPath + '\\", 3)}"');
				}
				else
				{
					trace('Wallpaper file not found at: ' + wallpaperPath);
				}
			}
			catch (e:Dynamic)
			{
				trace('Failed to change wallpaper: ' + e);
			}
			#end
			
			var objects:Array<FlxSprite> = new Array<FlxSprite>();
			
			// Change menu icons to virus versions
			var virusTex = Paths.getSparrowAtlas('ui/main_menu_icons_virus');
			for (item in menuItems)
			{
				item.frames = virusTex;
				var currentOptionShit = optionShit[item.ID];
				item.animation.addByPrefix('idle', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " basic", 24);
				item.animation.addByPrefix('selected', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " white", 24);
				item.animation.play('idle');
			}
			
			// Change big icons to virus version
			if (bigIcons != null)
			{
				bigIcons.frames = Paths.getSparrowAtlas('ui/menu_big_icons_virus');
				for (i in 0...optionShit.length)
				{
					bigIcons.animation.addByPrefix(optionShit[i], optionShit[i] == 'freeplay' ? 'freeplay0' : optionShit[i], 24);
				}
				bigIcons.animation.play(optionShit[curSelected]);
			}
			
			// Add all menu items to the chaos
			for (item in menuItems)
			{
				item.screenCenter();
				objects.push(item);
				item.velocity.set(new FlxRandom().float(-300, 400), new FlxRandom().float(-200, 400));
				item.angularVelocity = 60;
			}

			// Add UI elements
			if (selectUi != null)
			{
				selectUi.screenCenter();
				objects.push(selectUi);
				selectUi.velocity.set(new FlxRandom().float(-300, 400), new FlxRandom().float(-200, 400));
				selectUi.angularVelocity = 60;
			}

			if (bigIcons != null)
			{
				bigIcons.screenCenter();
				objects.push(bigIcons);
				bigIcons.velocity.set(new FlxRandom().float(-300, 400), new FlxRandom().float(-200, 400));
				bigIcons.angularVelocity = 60;
			}

			if (curOptText != null)
			{
				curOptText.screenCenter();
				objects.push(curOptText);
				curOptText.velocity.set(new FlxRandom().float(-100, 250), new FlxRandom().float(-100, 250));
				curOptText.angularVelocity = 80;
			}

			if (curOptDesc != null)
			{
				curOptDesc.screenCenter();
				objects.push(curOptDesc);
				curOptDesc.velocity.set(new FlxRandom().float(-100, 250), new FlxRandom().float(-100, 250));
				curOptDesc.angularVelocity = 80;
			}

			// Add background to the chaos
			if (bg != null)
			{
				bg.screenCenter();
				objects.push(bg);
				bg.velocity.set(new FlxRandom().float(-200, 300), new FlxRandom().float(-150, 300));
				bg.angularVelocity = 40;
			}

			// Add magenta background if it exists
			if (magenta != null)
			{
				magenta.screenCenter();
				objects.push(magenta);
				magenta.velocity.set(new FlxRandom().float(-200, 300), new FlxRandom().float(-150, 300));
				magenta.angularVelocity = 40;
			}

			boom.play();
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.sound('recursed/ambience', 'shared'), 1, false, null);

			// Change background to DARKABYSS
			bg.loadGraphic(Paths.image('backgrounds/void/DARKABYSS', 'shared'));
			bg.color = FlxColor.WHITE;
			
			new FlxTimer().start(4, function(timer:FlxTimer)
			{
				for (object in objects)
				{
					object.angularVelocity = 0;
					object.velocity.set();
					FlxTween.tween(object, {x: (FlxG.width / 2) - (object.width / 2), y: (FlxG.height / 2) - (object.height / 2)}, 1, {ease: FlxEase.backOut});
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
							PlayState.SONG = Song.loadFromJson("luna-virus");
							PlayState.storyWeek = 16;
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

	override function beatHit()
	{
		super.beatHit();
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
			//spr.screenCenter(Y);
			spr.updateHitbox();
		});

		bigIcons.animation.play(optionShit[curSelected]);
		curOptText.text = CoolUtil.formatString(LanguageManager.getTextString(languagesOptions[curSelected]), ' ');
		curOptDesc.text = LanguageManager.getTextString(languagesDescriptions[curSelected]);
	}

	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
	{
		var date = Date.now();
		var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
		if(date.getMonth() == 3 && date.getDate() == 1)
		{
			return Paths.image('backgrounds/ramzgaming');
		}
		else
		{
			return Paths.image('backgrounds/${bgPaths[chance]}');
		}
	}
	function resetData()
	{
		for (save in ['funkin', 'controls', 'language'])
		{
			FlxG.save.bind(save, 'ninjamuffin99');
			FlxG.save.erase();
			FlxG.save.flush();
		}
		FlxG.save.bind('funkin', 'ninjamuffin99');

		Highscore.songScores = new Map();
		Highscore.songChars = new Map();

		SaveDataHandler.initSave();
		LanguageManager.init();

		Highscore.load();
		
		CoolUtil.init();

		CharacterSelectState.unlockCharacter('bf');
		CharacterSelectState.unlockCharacter('bf-pixel');
		CharacterSelectState.unlockCharacter('luna');
		CharacterSelectState.unlockCharacter('lunamad');
		CharacterSelectState.unlockCharacter('lunafinal');
		CharacterSelectState.unlockCharacter('puda');
		CharacterSelectState.unlockCharacter('itsumi');
		CharacterSelectState.unlockCharacter('itsumi-pixel');
		CharacterSelectState.unlockCharacter('alls');
		CharacterSelectState.unlockCharacter('noahreal');

		FlxG.switchState(new StartStateSelector());
	}
}
class Prompt extends FlxSpriteGroup
{
	var promptText:FlxText;
	var yesText:FlxText;
	var noText:FlxText;
	var texts = new Array<FlxText>();

	public var yesFunc:Void->Void;
	public var noFunc:Void->Void;
	public var canInteract:Bool = true;
	public var controls:Controls;
	var curSelected:Int = 0;
	
	public function new(question:String, controls:Controls)
	{
		super();

		this.controls = controls;

		FlxG.mouse.visible = true;
		
		promptText = new FlxText(0, FlxG.height / 2 - 200, FlxG.width, question, 16);
		promptText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		promptText.screenCenter(X);
		promptText.scrollFactor.set(0, 0);
		promptText.borderSize = 2.5;
		promptText.antialiasing = true;
		add(promptText);

		noText = new FlxText(0, FlxG.height / 2 + 100, 0, "No", 16);
		noText.screenCenter(X);
		noText.x += 200;
		noText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noText.scrollFactor.set(0, 0);
		noText.borderSize = 1.5;
		noText.antialiasing = true;
		add(noText);

		yesText = new FlxText(0, FlxG.height / 2 + 100, 0, "Yes", 16);
		yesText.screenCenter(X);
		yesText.x -= 200;
		yesText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		yesText.scrollFactor.set(0, 0);
		yesText.borderSize = 1.5;
		yesText.antialiasing = true;
		add(yesText);
		
		texts = [yesText, noText];

		updateText();
	}
	override function update(elapsed:Float)
	{
		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var enter = controls.ACCEPT;

		if (leftP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected--;
			if (curSelected < 0)
			{
				curSelected = 1;
			}
			updateText();
		}
		if (rightP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected++;
			if (curSelected > 1)
			{
				curSelected = 0;
			}
			updateText();
		}
		if (enter)
		{
			select(texts[curSelected]);
		}
		
		/*
		if (FlxG.mouse.overlaps(noText) && curSelected != texts.indexOf(noText))
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected = texts.indexOf(noText);
			updateText();
		}
		if (FlxG.mouse.overlaps(yesText) && curSelected != texts.indexOf(yesText))
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected = texts.indexOf(yesText);
			updateText();
		}*/
		if (FlxG.mouse.justMoved)
		{
			for (i in 0...texts.length)
			{
				if (i != curSelected)
				{
					if (FlxG.mouse.overlaps(texts[i]) && !FlxG.mouse.overlaps(texts[curSelected]))
					{
						curSelected = i;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						updateText();
					}
				}
			}
		}

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(texts[curSelected]))
			{
				select(texts[curSelected]);
			}
		}
		super.update(elapsed);
	}
	function updateText()
	{
		switch (curSelected)
		{
			case 0:
				yesText.borderColor = FlxColor.YELLOW;
				noText.borderColor = FlxColor.BLACK;
			case 1:
				noText.borderColor = FlxColor.YELLOW;
				yesText.borderColor = FlxColor.BLACK;
		}
	}
	function select(text:FlxText)
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		var select = texts.indexOf(text);

		FlxFlicker.flicker(text, 1.1, 0.1, false, false, function(flicker:FlxFlicker)
		{
			switch (select)
			{
				case 0:
					yesFunc();
				case 1:
					noFunc();
			}
		});
	}
}