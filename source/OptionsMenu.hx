package;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var bgShader:Shaders.GlitchEffect;
	var awaitingExploitation:Bool;
	
	// category list (added Changelog)
	var categories:Array<String> = ["Gameplay", "Visuals", "Audio", "Misc", "Credits"];
	
	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Options Menu", null);
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
		
		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		
		// Add category buttons with slide-in animation
		for (i in 0...categories.length)
		{
			var cat:Alphabet = new Alphabet(0, (70 * i) + 30, categories[i], true, false);
			cat.screenCenter(X);
			cat.isMenuItem = true;
			cat.itemType = 'Vertical';
			cat.targetY = i;
			
			// Start off-screen to the right and invisible
			cat.x += 300;
			cat.alpha = 0;
			
			grpControls.add(cat);
			
			// Animate slide in with staggered delay
			FlxTween.tween(cat, {x: cat.x - 300, alpha: 1}, 0.6, {
				ease: FlxEase.expoOut,
				startDelay: 0.2 + (0.05 * i)
			});
		}
		
		versionShit = new FlxText(5, FlxG.height - 18, 0, "Options", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if SHADERS_ENABLED
		if (bgShader != null)
			bgShader.shader.uTime.value[0] += elapsed;
		#end
		
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		
		if (controls.UP_P) changeSelection(-1);
		if (controls.DOWN_P) changeSelection(1);
		
		if (controls.ACCEPT)
		{
			// Play the "settings" sound when selecting an option
			FlxG.sound.play(Paths.sound('settings'));
			
			switch (curSelected)
			{
				case 0:
					FlxG.switchState(new OptionsSubMenu("Gameplay", awaitingExploitation));
				case 1:
					FlxG.switchState(new OptionsSubMenu("Visuals", awaitingExploitation));
				case 2:
					FlxG.switchState(new OptionsSubMenu("Audio", awaitingExploitation));
				case 3:
					FlxG.switchState(new OptionsSubMenu("Misc", awaitingExploitation));
				case 4:
					var menu:CreditsMenuState = new CreditsMenuState();
					menu.DoFunnyScroll = true;
					FlxG.switchState(menu);
			}
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
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