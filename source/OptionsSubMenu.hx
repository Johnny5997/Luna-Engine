package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

class OptionsSubMenu extends MusicBeatState
{
	var category:String;
	var awaitingExploitation:Bool;
	var curSelected:Int = 0;
	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var bgShader:Shaders.GlitchEffect;

	var songBarOptions = ['ShowTime','SongName'];
	var curSongBarOptionSelected:Int;

	public function new(cat:String, exploit:Bool)
	{
		super();
		category = cat;
		awaitingExploitation = exploit;
	}

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In " + category + " Options", null);
		#end

		var menuBG:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/mainmenubg', 'shared'));
		menuBG.scrollFactor.set();
		menuBG.antialiasing = false;
		add(menuBG);

		#if SHADERS_ENABLED
		bgShader = new Shaders.GlitchEffect();
		bgShader.waveAmplitude = 0.1;
		bgShader.waveFrequency = 5;
		bgShader.waveSpeed = 2;
		menuBG.shader = bgShader.shader;
		#end

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		curSongBarOptionSelected = songBarOptions.indexOf(FlxG.save.data.songBarOption);

		var options:Array<String> = getOptionsForCategory(category);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			controlLabel.screenCenter(X);
			controlLabel.itemType = 'Vertical';
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			
			// Start off-screen to the right and invisible
			controlLabel.x += 300;
			controlLabel.alpha = 0;
			
			grpControls.add(controlLabel);
			
			// Animate slide in with staggered delay
			FlxTween.tween(controlLabel, {x: controlLabel.x - 300, alpha: 1}, 0.6, {
				ease: FlxEase.expoOut,
				startDelay: 0.2 + (0.05 * i)
			});
		}

		versionShit = new FlxText(5, FlxG.height - 18, 0, category + " Options", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	function getMenuBGText():String		// doing it this way to make it look better -johnny
	{
		return switch(FlxG.save.data.mainMenuBG)
		{
			case 0: "Main Menu BG: Luna World";
			case 1: "Main Menu BG: Pinecone";
			case 2: "Main Menu BG: House";
			case 3: "Main Menu BG: Tessattack";
			case 4: "Main Menu BG: Golden Void";
			case 5: "Main Menu BG: Kade Engine";
			default: "Main Menu BG: Luna World";
		}
	}

	function getOptionsForCategory(cat:String):Array<String>
	{
		switch(cat)
		{
			case "Gameplay":
				return [
					LanguageManager.getTextString('option_change_keybinds'),
					(FlxG.save.data.newInput ? LanguageManager.getTextString('option_ghostTapping_on') : LanguageManager.getTextString('option_ghostTapping_off')),
					(FlxG.save.data.downscroll ? LanguageManager.getTextString('option_downscroll') : LanguageManager.getTextString('option_upscroll')),
					(FlxG.save.data.songPosition ? LanguageManager.getTextString('option_songPosition_on') : LanguageManager.getTextString('option_songPosition_off')),
					LanguageManager.getTextString('option_songBarType_${songBarOptions[curSongBarOptionSelected]}'),
					(FlxG.save.data.scorePopups ? 'Score Popups: ON' : 'Score Popups: OFF')
				];
			case "Visuals":
				return [
					(FlxG.save.data.eyesores ? LanguageManager.getTextString('option_eyesores_enabled') : LanguageManager.getTextString('option_eyesores_disabled')),
					(FlxG.save.data.noteCamera ? LanguageManager.getTextString('option_noteCamera_on') : LanguageManager.getTextString('option_noteCamera_off')),
					(FlxG.save.data.disableFps ? LanguageManager.getTextString('option_enable_fps') : LanguageManager.getTextString('option_disable_fps')),
					getMenuBGText()
				];
			case "Audio":
				return [
					(FlxG.save.data.donoteclick ? LanguageManager.getTextString('option_hitsound_on') : LanguageManager.getTextString('option_hitsound_off')),
					(
						FlxG.save.data.altMenuMusic == 0 ? "Menu Music: Freaky" :
						FlxG.save.data.altMenuMusic == 1 ? "Menu Music: Freakier" :
						FlxG.save.data.altMenuMusic == 2 ? "Menu Music: Noah Engine" :
						FlxG.save.data.altMenuMusic == 3 ? "Menu Music: Pinecone" :
						FlxG.save.data.altMenuMusic == 4 ? "Menu Music: Playstation" :
						FlxG.save.data.altMenuMusic == 5 ? "Menu Music: Love Songs" :
						FlxG.save.data.altMenuMusic == 6 ? "Menu Music: Jacobs Ladder" :
						FlxG.save.data.altMenuMusic == 7 ? "Menu Music: Diddy Blud" :
						FlxG.save.data.altMenuMusic == 8 ? "Menu Music: She Will" :
						FlxG.save.data.altMenuMusic == 9 ? "Menu Music: SDP" :
						FlxG.save.data.altMenuMusic == 10 ? "Menu Music: I Believed It" :
						"Menu Music: Freaky"  // Default fallback
					)
				];
			case "Misc":
				return [
					LanguageManager.getTextString('option_change_langauge'),
					(FlxG.save.data.selfAwareness ? LanguageManager.getTextString('option_selfAwareness_on') : LanguageManager.getTextString('option_selfAwareness_off')),
					(!awaitingExploitation ? (FlxG.save.data.modchart ? 'Mod Chart OFF' : 'Mod Chart ON') : "Locked"),
					(!awaitingExploitation ? (FlxG.save.data.botplay ? 'Bot Play ON' : 'Bot Play OFF') : "Locked")
				];
		}
		return [];
	}

	override function update(elapsed:Float)
	{
	    super.update(elapsed);
	
	    // ADVANCE SHADER TIME
	    #if SHADERS_ENABLED
	    if (bgShader != null)
	        bgShader.shader.uTime.value[0] += elapsed;
	    #end
	
	    if (controls.BACK)
	    {
			FlxG.sound.play(Paths.sound('cancelMenu'));
	        FlxG.save.flush();
	        CompatTool.save.flush();
	        FlxG.switchState(new OptionsMenu());
	    }
	    if (controls.UP_P) changeSelection(-1);
	    if (controls.DOWN_P) changeSelection(1);
	
	    if (controls.ACCEPT)
	    {
	        // Play the "settings" sound when selecting an option
	        FlxG.sound.play(Paths.sound('settings'));
	        handleOptionSelection(category, curSelected);
	    }
	}


	function handleOptionSelection(cat:String, index:Int)
	{
		switch(cat)
		{
			case "Gameplay":
				switch (index)
				{
					case 0:
						FlxG.switchState(new ChangeKeybinds());
					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						updateOption(index, FlxG.save.data.newInput ? LanguageManager.getTextString('option_ghostTapping_on') : LanguageManager.getTextString('option_ghostTapping_off'));
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						updateOption(index, FlxG.save.data.downscroll ? LanguageManager.getTextString('option_downscroll') : LanguageManager.getTextString('option_upscroll'));
					case 3:
						FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
						updateOption(index, FlxG.save.data.songPosition ? LanguageManager.getTextString('option_songPosition_on') : LanguageManager.getTextString('option_songPosition_off'));
					case 4:
						curSongBarOptionSelected++;
						if (curSongBarOptionSelected >= songBarOptions.length)
							curSongBarOptionSelected = 0;
						FlxG.save.data.songBarOption = songBarOptions[curSongBarOptionSelected];
						updateOption(index, LanguageManager.getTextString('option_songBarType_${songBarOptions[curSongBarOptionSelected]}'));
					case 5:
						FlxG.save.data.scorePopups = !FlxG.save.data.scorePopups;
						updateOption(index, FlxG.save.data.scorePopups ? 'Score Popups: ON' : 'Score Popups: OFF');
				}

			case "Visuals":
				switch(index)
				{
					case 0:
						FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
						updateOption(index, FlxG.save.data.eyesores ? LanguageManager.getTextString('option_eyesores_enabled') : LanguageManager.getTextString('option_eyesores_disabled'));
					case 1:
						FlxG.save.data.noteCamera = !FlxG.save.data.noteCamera;
						updateOption(index, FlxG.save.data.noteCamera ? LanguageManager.getTextString('option_noteCamera_on') : LanguageManager.getTextString('option_noteCamera_off'));
					case 2:
						FlxG.save.data.disableFps = !FlxG.save.data.disableFps;
						Main.fps.visible = !FlxG.save.data.disableFps;
						updateOption(index, FlxG.save.data.disableFps ? LanguageManager.getTextString('option_enable_fps') : LanguageManager.getTextString('option_disable_fps'));
					case 3:
						FlxG.save.data.mainMenuBG++;
						if (FlxG.save.data.mainMenuBG > 5) FlxG.save.data.mainMenuBG = 0;
						updateOption(index, getMenuBGText());
				}

			case "Audio":
				switch(index)
				{
					case 0:
						FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
						updateOption(index, FlxG.save.data.donoteclick ? LanguageManager.getTextString('option_hitsound_on') : LanguageManager.getTextString('option_hitsound_off'));
					case 1:
						FlxG.save.data.altMenuMusic++;
						if (FlxG.save.data.altMenuMusic > 10) FlxG.save.data.altMenuMusic = 0;
						var musicText:String = FlxG.save.data.altMenuMusic == 0 ? "Menu Music: Freaky" :
							FlxG.save.data.altMenuMusic == 1 ? "Menu Music: Freakier" :
							FlxG.save.data.altMenuMusic == 2 ? "Menu Music: Noah Engine" :
							FlxG.save.data.altMenuMusic == 3 ? "Menu Music: Pinecone" :
							FlxG.save.data.altMenuMusic == 4 ? "Menu Music: Playstation" :
							FlxG.save.data.altMenuMusic == 5 ? "Menu Music: Love Songs" :
							FlxG.save.data.altMenuMusic == 6 ? "Menu Music: Jacobs Ladder" :
							FlxG.save.data.altMenuMusic == 7 ? "Menu Music: Diddy Blud" :
							FlxG.save.data.altMenuMusic == 8 ? "Menu Music: She Will" :
							FlxG.save.data.altMenuMusic == 9 ? "Menu Music: SDP" :
							"Menu Music: I Believed It";
						updateOption(index, musicText);

						// restart music
						FlxG.sound.music.stop();
						switch(FlxG.save.data.altMenuMusic)
						{
							case 0: FlxG.sound.playMusic(Paths.music('freakyMenu')); Conductor.changeBPM(150);
							case 1: FlxG.sound.playMusic(Paths.music('freakierMenu')); Conductor.changeBPM(135);
							case 2: FlxG.sound.playMusic(Paths.music('noahEngine')); Conductor.changeBPM(102);
							case 3: FlxG.sound.playMusic(Paths.music('pinecone')); Conductor.changeBPM(293);
							case 4: FlxG.sound.playMusic(Paths.music('playstation')); Conductor.changeBPM(121);
							case 5: FlxG.sound.playMusic(Paths.music('loveSongs')); Conductor.changeBPM(120);
							case 6: FlxG.sound.playMusic(Paths.music('jacobsLadder')); Conductor.changeBPM(146);
							case 7: FlxG.sound.playMusic(Paths.music('diddyBlud')); Conductor.changeBPM(184);
							case 8: FlxG.sound.playMusic(Paths.music('sheWill')); Conductor.changeBPM(152);
							case 9: FlxG.sound.playMusic(Paths.music('sdp')); Conductor.changeBPM(120);
							case 10: FlxG.sound.playMusic(Paths.music('iBelievedIt')); Conductor.changeBPM(145);
						}
				}

			case "Misc":
				switch(index)
				{
					case 0: FlxG.switchState(new ChangeLanguageState());
					case 1:
						FlxG.save.data.selfAwareness = !FlxG.save.data.selfAwareness;
						updateOption(index, FlxG.save.data.selfAwareness ? LanguageManager.getTextString('option_selfAwareness_on') : LanguageManager.getTextString('option_selfAwareness_off'));
					case 2:
						if (!awaitingExploitation) FlxG.save.data.modchart = !FlxG.save.data.modchart;
						updateOption(index, FlxG.save.data.modchart ? 'Mod Chart OFF' : 'Mod Chart ON');
					case 3:
						if (!awaitingExploitation) FlxG.save.data.botplay = !FlxG.save.data.botplay;
						updateOption(index, FlxG.save.data.botplay ? 'Bot Play ON' : 'Bot Play OFF');
				}
		}
	}

	function updateOption(index:Int, text:String)
	{
		var oldOpt = grpControls.members[index];
		if (oldOpt != null)
		{
			// make a new option
			var newOpt:Alphabet = new Alphabet(0, oldOpt.y, text, true, false);
			newOpt.screenCenter(X);
			newOpt.itemType = 'Vertical';
			newOpt.isMenuItem = true;
			newOpt.targetY = oldOpt.targetY;

			// replace it in the group
			grpControls.members[index] = newOpt;

			// remove old one and add new one to the state so it renders
			remove(oldOpt, true);
			add(newOpt);
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		if (curSelected < 0) curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length) curSelected = 0;

		var bullShit:Int = 0;
		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.6;
			if (item.targetY == 0) item.alpha = 1;
		}
	}
}