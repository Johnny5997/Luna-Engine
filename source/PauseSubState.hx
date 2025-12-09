package;

import flixel.group.FlxGroup;
import haxe.Json;
import haxe.Http;
import flixel.math.FlxRandom;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var bg:FlxBackdrop;

	var menuItems:Array<PauseOption> = [
		new PauseOption('Resume'),
		new PauseOption('Restart Song'),
		new PauseOption('Change Character'),
		new PauseOption('Skip Time'),
		new PauseOption('Practice Mode'),
		new PauseOption('Botplay'),
		new PauseOption('Exit to menu')
	];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var expungedSelectWaitTime:Float = 0;
	var timeElapsed:Float = 0;
	var patienceTime:Float = 0;

	public var funnyTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	// Skip Time variables
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = 0;
	var holdTime:Float = 0;

	// Checkbox variables
	var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	var practiceModeCheckbox:CheckboxThingie;
	var botplayCheckbox:CheckboxThingie;

	// Botplay notification
	var botplayNotification:FlxText;
	var notificationTween:FlxTween;

	public function new(x:Float, y:Float)
	{
		super();

		curTime = Math.max(0, Conductor.songPosition);
		
		funnyTexts = new FlxTypedGroup<FlxText>();
		add(funnyTexts);

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
			case "darkness":
				pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast-ohno'), true, true);
				expungedSelectWaitTime = new FlxRandom().float(2, 7);
				patienceTime = new FlxRandom().float(15, 30);
		}
		
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var backBg:FlxSprite = new FlxSprite();
		backBg.makeGraphic(FlxG.width + 1, FlxG.height + 1, FlxColor.BLACK);
		backBg.alpha = 0;
		backBg.scrollFactor.set();
		add(backBg);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.alpha = 0;
		bg.antialiasing = true;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelInfo.antialiasing = true;
		levelInfo.borderSize = 2.5;
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('comic.ttf'), 32, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelDifficulty.antialiasing = true;
		levelDifficulty.borderSize = 2.5;
		levelDifficulty.updateHitbox();
		if ((PlayState.SONG.song.toLowerCase() == 'darkness' && !PlayState.isGreetingsCutscene) || PlayState.storyDifficulty != 1)
		{
			add(levelDifficulty);
		}

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(backBg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5,
		onComplete: function(tween:FlxTween)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'darkness':
					doALittleTrolling(levelDifficulty);
			}
		}});

		// Remove options based on conditions
		if (PlayState.isStoryMode || FreeplayState.skipSelect.contains(PlayState.SONG.song.toLowerCase()) || PlayState.instance.localFunny == PlayState.CharacterFunnyEffect.Recurser)
		{
			menuItems.remove(PauseOption.getOption(menuItems, 'Change Character'));
		}
		
		// Only show Skip Time in practice mode (noMiss check)
		if (!PlayState.instance.noMiss)
		{
			menuItems.remove(PauseOption.getOption(menuItems, 'Skip Time'));
		}

		for (item in menuItems)
		{
			if (PlayState.instance.localFunny == PlayState.CharacterFunnyEffect.Recurser)
			{
				if(item.optionName != 'Resume' && item.optionName != 'Practice Mode')
				{
					menuItems.remove(PauseOption.getOption(menuItems, item.optionName));
				}
				continue;
			}
		}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, LanguageManager.getTextString('pause_${menuItems[i].optionName}'), true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);

			// Add checkboxes for Practice Mode and Botplay
			if (menuItems[i].optionName == 'Practice Mode')
			{
				practiceModeCheckbox = new CheckboxThingie(0, 0, PlayState.instance.noMiss);
				practiceModeCheckbox.sprTracker = songText;
				practiceModeCheckbox.offsetX = 0;
				practiceModeCheckbox.offsetY = 0;
				checkboxGroup.add(practiceModeCheckbox);
			}
			else if (menuItems[i].optionName == 'Botplay')
			{
				botplayCheckbox = new CheckboxThingie(0, 0, FlxG.save.data.botplay);
				botplayCheckbox.sprTracker = songText;
				botplayCheckbox.offsetX = 0;
				botplayCheckbox.offsetY = 0;
				checkboxGroup.add(botplayCheckbox);
			}
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		if(skipTimeText != null)
			skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}

	function showBotplayNotification()
	{
		// Cancel existing tweens to prevent buggy animations
		if (notificationTween != null)
		{
			notificationTween.cancel();
			notificationTween = null;
		}

		if (botplayNotification != null)
		{
			botplayNotification.kill();
			remove(botplayNotification);
			botplayNotification.destroy();
		}

		botplayNotification = new FlxText(0, FlxG.height + 50, FlxG.width, "Restart song to enable", 32);
		botplayNotification.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayNotification.borderSize = 2;
		botplayNotification.scrollFactor.set();
		add(botplayNotification);

		notificationTween = FlxTween.tween(botplayNotification, {y: FlxG.height - 100}, 0.4, {
			ease: FlxEase.quartOut,
			onComplete: function(twn:FlxTween)
			{
				notificationTween = FlxTween.tween(botplayNotification, {y: FlxG.height + 50}, 0.4, {
					ease: FlxEase.quartIn,
					startDelay: 2.0,
					onComplete: function(twn:FlxTween)
					{
						if (botplayNotification != null)
						{
							botplayNotification.kill();
							remove(botplayNotification);
							botplayNotification.destroy();
							botplayNotification = null;
						}
						notificationTween = null;
					}
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;

		timeElapsed += elapsed;
		if (pauseMusic.volume < 0.75)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		var daSelected:String = menuItems[curSelected].optionName;

		// Handle Skip Time controls
		if (daSelected == 'Skip Time')
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				curTime -= 1000;
				holdTime = 0;
			}
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				curTime += 1000;
				holdTime = 0;
			}

			if(controls.LEFT || controls.RIGHT)
			{
				holdTime += elapsed;
				if(holdTime > 0.5)
				{
					curTime += 45000 * elapsed * (controls.LEFT ? -1 : 1);
				}

				if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
				else if(curTime < 0) curTime += FlxG.sound.music.length;
				updateSkipTimeText();
			}
		}

		updateSkipTextStuff();

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (PlayState.SONG.song.toLowerCase() == 'darkness' && this.exists && PauseSubState != null)
		{
			if (expungedSelectWaitTime >= 0)
			{
				expungedSelectWaitTime -= elapsed;
			}
			else
			{
				expungedSelectWaitTime = new FlxRandom().float(0.5, 2);
				changeSelection(new FlxRandom().int((menuItems.length - 1) * -1, menuItems.length - 1));
			}
		}

		if (accepted)
		{
			selectOption();
		}
	}

	function selectOption()
	{
		var daSelected:String = menuItems[curSelected].optionName;

		switch (daSelected)
		{
			case "Resume":
				close();
			case "Restart Song":
				FlxG.sound.music.volume = 0;
				PlayState.instance.vocals.volume = 0;

				PlayState.instance.shakeCam = false;
				PlayState.instance.camZooming = false;

				FlxG.sound.play(Paths.sound('cancelMenu'));

				if (PlayState.SONG.song.toLowerCase() == "darkness")
				{
					if (PlayState.window != null)
					{
						PlayState.window.close();
					}
				}
				FlxG.mouse.visible = false;
				FlxG.resetState();
			case "Change Character":
				if (MathGameState.failedGame)
				{
					MathGameState.failedGame = false;
				}
				funnyTexts.clear();
				PlayState.characteroverride = 'none';
				PlayState.formoverride = 'none';
				PlayState.recursedStaticWeek = false;

				FlxG.sound.play(Paths.sound('cancelMenu'));

				Application.current.window.title = Main.applicationName;

				if (PlayState.SONG.song.toLowerCase() == "darkness")
				{
					Main.toggleFuckedFPS(false);
					if (PlayState.window != null)
					{
						PlayState.window.close();
					}
				}
				PlayState.instance.shakeCam = false;
				PlayState.instance.camZooming = false;
				FlxG.mouse.visible = false;
				FlxG.switchState(new CharacterSelectState());	
			case 'Skip Time':
				if(curTime < Conductor.songPosition)
				{
					// Going backwards - need to regenerate all notes
					FlxG.sound.music.pause();
					PlayState.instance.vocals.pause();
		
					// Regenerate all notes from scratch
					PlayState.instance.regenerateNotes();
		
					// Set the song time
					PlayState.instance.setSongTime(curTime);
		
					// Clear notes that are before the target time
					PlayState.instance.clearNotesBefore(curTime);
		
					FlxG.sound.music.play();
					PlayState.instance.vocals.play();
					close();
				}
				else
				{
					// Going forwards - just clear old notes
					if (curTime != Conductor.songPosition)
					{
						FlxG.sound.music.pause();
						PlayState.instance.vocals.pause();
			
						PlayState.instance.clearNotesBefore(curTime);
						PlayState.instance.setSongTime(curTime);
			
						FlxG.sound.music.play();
						PlayState.instance.vocals.play();
					}
					close();
				}
			case "Practice Mode":
				PlayState.instance.noMiss = !PlayState.instance.noMiss;
				var nm = PlayState.SONG.song.toLowerCase();

				// Update checkbox
				if (practiceModeCheckbox != null)
				{
					practiceModeCheckbox.daValue = PlayState.instance.noMiss;
				}

				FlxG.sound.play(Paths.sound('checkboxClick'));

				if (['darkness', 'cheating', 'unfairness', 'recursed'].contains(nm))
				{
					PlayState.instance.health = 0;
					close();
				}
			case "Botplay":
				var previousBotplay = FlxG.save.data.botplay;
				FlxG.save.data.botplay = !FlxG.save.data.botplay;
				FlxG.save.flush();

				// Update checkbox
				if (botplayCheckbox != null)
				{
					botplayCheckbox.daValue = FlxG.save.data.botplay;
				}

				FlxG.sound.play(Paths.sound('checkboxClick'));

				// Show notification if botplay was just enabled
				if (!previousBotplay && FlxG.save.data.botplay)
				{
					showBotplayNotification();
				}

				var nm = PlayState.SONG.song.toLowerCase();
				if (['darkness', 'cheating', 'unfairness', 'recursed'].contains(nm))
				{
					PlayState.instance.health = 0;
					close();
				}
			case "Exit to menu":
				if (MathGameState.failedGame)
				{
					MathGameState.failedGame = false;
				}
				funnyTexts.clear();
				PlayState.characteroverride = 'none';
				PlayState.formoverride = 'none';
				PlayState.recursedStaticWeek = false;

				FlxG.sound.play(Paths.sound('cancelMenu'));

				Application.current.window.title = Main.applicationName;

				if (PlayState.SONG.song.toLowerCase() == "darkness")
				{
					Main.toggleFuckedFPS(false);
					if (PlayState.window != null)
					{
						PlayState.window.close();
					}
				}
				PlayState.instance.shakeCam = false;
				PlayState.instance.camZooming = false;
				FlxG.mouse.visible = false;
				FlxG.switchState(new MainMenuState());
		}
	}

	override function close()
	{
		funnyTexts.clear();
		FlxG.sound.play(Paths.sound('cancelMenu'));

		super.close();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function doALittleTrolling(levelDifficulty:FlxText)
	{
		var difficultyHeight = levelDifficulty.height;
		var amountOfDifficulties = Math.ceil(FlxG.height / difficultyHeight);

		for (i in 0...amountOfDifficulties)
		{
			if (funnyTexts.exists)
			{
				var difficulty:FlxText = new FlxText(20, (15 + 32) * (i + 2), 0, "", 32);
				difficulty.text += levelDifficulty.text;
				difficulty.scrollFactor.set();
				difficulty.setFormat(Paths.font('comic.ttf'), 32, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				difficulty.antialiasing = true;
				difficulty.borderSize = 2;
				difficulty.updateHitbox();
				funnyTexts.add(difficulty);

				difficulty.alpha = 0;

				difficulty.x = FlxG.width - (difficulty.width + 20);

				FlxTween.tween(difficulty, {alpha: 1, y: difficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.05 * i});
			}
			else
			{
				return;
			}

		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
				
				// Handle Skip Time display
				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}

		// Create or destroy skip time text based on selection
		var daSelected:String = menuItems[curSelected].optionName;
		if (daSelected == 'Skip Time' && skipTimeText == null)
		{
			skipTimeText = new FlxText(0, 0, 0, '', 64);
			skipTimeText.setFormat(Paths.font("comic.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			skipTimeText.scrollFactor.set();
			skipTimeText.borderSize = 2;
			skipTimeTracker = grpMenuShit.members[curSelected];
			add(skipTimeText);

			updateSkipTextStuff();
			updateSkipTimeText();
		}
		else if (daSelected != 'Skip Time' && skipTimeText != null)
		{
			deleteSkipTimeText();
		}
	}
}

class PauseOption
{
	public var optionName:String;

	public function new(optionName:String)
	{
		this.optionName = optionName;
	}
	
	public static function getOption(list:Array<PauseOption>, optionName:String):PauseOption
	{
		for (option in list)
		{
			if (option.optionName == optionName)
			{
				return option;
			}
		}
		return null;
	}
}

class CheckboxThingie extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var daValue(default, set):Bool;
	public var copyAlpha:Bool = true;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	
	public function new(x:Float = 0, y:Float = 0, ?checked = false) 
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('ui/checkboxanim');
		animation.addByPrefix("unchecked", "checkbox0", 24, false);
		animation.addByPrefix("unchecking", "checkbox anim reverse", 24, false);
		animation.addByPrefix("checking", "checkbox anim0", 24, false);
		animation.addByPrefix("checked", "checkbox finish", 24, false);
		antialiasing = true;
		setGraphicSize(Std.int(0.9 * width));
		updateHitbox();
		animationFinished(checked ? 'checking' : 'unchecking');
		animation.finishCallback = animationFinished;
		daValue = checked;
	}
	
	override function update(elapsed:Float) 
	{
		if (sprTracker != null) 
		{
			setPosition(sprTracker.x + sprTracker.width + 20 + offsetX, sprTracker.y - 20 + offsetY);
			if(copyAlpha) 
			{
				alpha = sprTracker.alpha;
			}
		}
		super.update(elapsed);
	}
	
	private function set_daValue(check:Bool):Bool 
	{
		if(check) 
		{
			if(animation.curAnim.name != 'checked' && animation.curAnim.name != 'checking') 
			{
				animation.play('checking', true);
				offset.set(34, 25);
			}
		} 
		else if(animation.curAnim.name != 'unchecked' && animation.curAnim.name != 'unchecking') 
		{
			animation.play("unchecking", true);
			offset.set(25, 28);
		}
		return check;
	}
	
	private function animationFinished(name:String)
	{
		switch(name)
		{
			case 'checking':
				animation.play('checked', true);
				offset.set(3, 12);
			case 'unchecking':
				animation.play('unchecked', true);
				offset.set(0, 2);
		}
	}
}