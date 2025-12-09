package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
#if desktop
import Discord.DiscordClient;
#end

class ChangelogState extends MusicBeatState
{
    var bg:FlxSprite;
    var changelogText:FlxText;
    var titleText:FlxText;
    var versionText:FlxText;

	var bgShader:Shaders.GlitchEffect;

    var scrollOffset:Float = 0;
    var maxScroll:Float = 0;

    // Version selection
    var versionButtons:FlxTypedGroup<FlxSprite>;
    var versionNames:Array<String> = [
        "1.0 Beta 7",
        "1.0 Beta 6",
        "1.0 Beta 5.1",
        "1.0 Beta 5",
        "1.0 Beta 4",
        "1.0 Beta 3",
        "1.0 Beta 2",
        "1.0 Beta 1"
    ];
    var versionImageNames:Array<String> = [
        "1beta7",
        "1beta6",
        "1beta5-1",
        "1beta5",
        "1beta4",
        "1beta3",
        "1beta2",
        "1beta1"
    ];
    
    var curSelected:Int = 0;
    var selectedVersion:Bool = false;
    var canInteract:Bool = true;

    override function create()
    {
        #if desktop
        DiscordClient.changePresence("Reading the Changelog", null);
        #end

        // Same background as Options Menu
        bg = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/mainmenubgchangelog', 'shared'));
        bg.scrollFactor.set();
        bg.antialiasing = false;
        add(bg);

        #if SHADERS_ENABLED
        bgShader = new Shaders.GlitchEffect();
        bgShader.waveAmplitude = 0.1;
        bgShader.waveFrequency = 5;
        bgShader.waveSpeed = 2;
        bg.shader = bgShader.shader;
        #end

        // Title text
        titleText = new FlxText(0, 30, FlxG.width, "Changelog - Select Version", 32);
        titleText.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        titleText.borderSize = 2;
        titleText.antialiasing = true;
        add(titleText);

        // Version buttons
        versionButtons = new FlxTypedGroup<FlxSprite>();
        add(versionButtons);

        for (i in 0...versionNames.length)
        {
            var btn:FlxSprite = new FlxSprite(0, 0);
            btn.loadGraphic(Paths.image('changelog/' + versionImageNames[i], 'shared'));
            btn.ID = i;
            btn.antialiasing = true;
            btn.setGraphicSize(Std.int(btn.width * 0.8));
            btn.updateHitbox();
            
            // Position in grid (4 columns)
            var col = i % 4;
            var row = Math.floor(i / 4);
            btn.x = FlxG.width / 2 - 575 + (col * 290);
            btn.y = 100 + (row * 280);
            
            versionButtons.add(btn);
        }

        // Changelog contents (hidden initially)
        changelogText = new FlxText(50, 80, FlxG.width - 100, "", 18);
        changelogText.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        changelogText.alignment = LEFT;
        changelogText.borderSize = 2;
        changelogText.antialiasing = true;
        changelogText.alpha = 0;
        changelogText.visible = false;
        add(changelogText);

        // Version text
        versionText = new FlxText(5, FlxG.height - 24, 0, "Current Version: Beta 7", 16);
        versionText.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        versionText.borderSize = 2;
        versionText.antialiasing = true;
        add(versionText);

        changeItem(0);

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

		#if SHADERS_ENABLED
		if (bgShader != null)
			bgShader.shader.uTime.value[0] += elapsed;
		#end

        if (!selectedVersion && canInteract)
        {
            // Navigation
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
            if (controls.UP_P)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeItem(-4);
            }
            if (controls.DOWN_P)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeItem(4);
            }

            // Selection
            if (controls.ACCEPT)
            {
                selectVersion();
            }

            // Back button
            if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound("cancelMenu"));
                FlxG.switchState(new MainMenuState());
            }
        }
        else if (selectedVersion && canInteract)
        {
            // Scroll changelog
            if (FlxG.keys.pressed.UP || controls.UP) scrollOffset += 400 * elapsed;
            if (FlxG.keys.pressed.DOWN || controls.DOWN) scrollOffset -= 400 * elapsed;

            changelogText.y = 80 + scrollOffset;

            // Prevent going too far up
            if (changelogText.y > 80) changelogText.y = 80;
            
            // Allow scrolling down through all content
            var minY = FlxG.height - changelogText.height - 30;
            if (changelogText.y < minY)
                changelogText.y = minY;

            // Back button to return to version selection
            if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound("cancelMenu"));
                hideChangelog();
            }
        }
    }

    function changeItem(change:Int = 0)
    {
        curSelected += change;

        if (curSelected >= versionButtons.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = versionButtons.length - 1;

        versionButtons.forEach(function(btn:FlxSprite)
        {
            if (btn.ID == curSelected)
            {
                // Load selected version image
                btn.loadGraphic(Paths.image('changelog/' + versionImageNames[btn.ID] + 'sel', 'shared'));
                btn.setGraphicSize(Std.int(btn.width * 0.8));
                btn.updateHitbox();
            }
            else
            {
                // Load normal version image
                btn.loadGraphic(Paths.image('changelog/' + versionImageNames[btn.ID], 'shared'));
                btn.setGraphicSize(Std.int(btn.width * 0.8));
                btn.updateHitbox();
            }
        });
    }

    function selectVersion()
    {
        canInteract = false;
        FlxG.sound.play(Paths.sound('confirmMenu'));

        var selectedBtn = versionButtons.members[curSelected];

        // Flicker selected button
        FlxFlicker.flicker(selectedBtn, 1, 0.06, false, false, function(flick:FlxFlicker)
        {
            // Hide all buttons
            versionButtons.forEach(function(btn:FlxSprite)
            {
                FlxTween.tween(btn, {alpha: 0}, 0.3, {
                    onComplete: function(twn:FlxTween)
                    {
                        btn.visible = false;
                    }
                });
            });

            // Show changelog
            showChangelog(curSelected);
        });

        // Fade out other buttons immediately
        versionButtons.forEach(function(btn:FlxSprite)
        {
            if (btn.ID != curSelected)
            {
                FlxTween.tween(btn, {alpha: 0}, 0.5);
            }
        });
    }

    function showChangelog(versionIndex:Int)
    {
        selectedVersion = true;
        scrollOffset = 0;

        // Update title
        titleText.text = "Changelog - " + versionNames[versionIndex];

        // Set changelog content based on version
        var changelogString = getChangelogForVersion(versionIndex);
        changelogText.text = changelogString;
        changelogText.visible = true;

        // Fade in changelog
        FlxTween.tween(changelogText, {alpha: 1}, 0.5, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween)
            {
                canInteract = true;
            }
        });
    }

    function hideChangelog()
    {
        canInteract = false;
        selectedVersion = false;

        // Update title
        titleText.text = "Changelog - Select Version";

        // Fade out changelog
        FlxTween.tween(changelogText, {alpha: 0}, 0.3, {
            onComplete: function(twn:FlxTween)
            {
                changelogText.visible = false;

                // Show buttons again
                versionButtons.forEach(function(btn:FlxSprite)
                {
                    btn.visible = true;
                    btn.alpha = 0;
                    FlxTween.tween(btn, {alpha: 1}, 0.3, {
                        onComplete: function(twn:FlxTween)
                        {
                            canInteract = true;
                        }
                    });
                });
            }
        });
    }

    function getChangelogForVersion(index:Int):String
    {
        switch(index)
        {
            case 0: // Beta 7
                return "Version 1.0 Beta 7 (Current Version)
[x] Interactive Chart Editor
[x] Interactive Volume Slider
[x] Lil' Buddies Integration
[x] IYKYK Freeplay Section
[x] Added UNETHICAL
[x] Added Opposition
[x] Added Kalampokiphobia
[x] Added Yarn
[x] Revamped OST Player
[x] Freeplay Songs Flashing
[x] Fixed Changelog Page
[x] Icon Color Fixes
[x] Fixed OST Popups
[x] Septuagint Extra Keys
[x] Main Menu Code Enter Box
[x] Breast Cancer Awareness Page
[x] Dave and Bambi code and files removed
[x] Updated Credits Menu
[x] Pussy Mode for Master and Warmup
[x] Fixed Volume on certain songs
[x] Fixed Offsets for certain characters
[x] Fixed Week Icons
[x] Main Menu and Social Media Buttons Animations
[x] Spectre Week 3 2 1 GO!
[x] Press R to Reset Text fixed
[x] Revamped Combo Popup
[x] No Combo Popup Option
[x] Skip Time in Pause Menu
[x] Fixed all songs having Pussy and Extra Keys
[x] Shaking Characters
[x] 666 unlocks UNETHICAL in the Baldi Game
[x] Luna Engine Enhancements
[x] Hortas Week Window Title Updated
[x] Revamped Cover Art
[x] Red Shaded Backgrounds
[x] Locked Songs
[x] Updated Credits Page
[x] Updated Changelog Page
[x] She Will Menu Music";

            case 1: // Beta 6
                return "Version 1.0 Beta 6 (COMPLETE!!!)
[x] Love Songs Menu Music
[x] Jacob's Ladder Menu Music
[x] Custom Menu BG
[x] No Miss Mode changed to Practice Mode
[x] Botplay shortcut in Pause
[x] Fixed Final Week Text
[x] Extra Keys for Cuberoot and The Biggest Bird
[x] Fixed Notes Offloading in various songs
[x] Added Flashes to Entity
[x] Mechanics in Entity
[x] Fixed Recursed BF
[x] Locked Entity with Recursed
[x] Title Screen Background
[x] Glitch Title Screen Background
[x] Shape Notes in Sunshine
[x] Playable Luna skins
[x] Fixed Playable Characters
[x] Pixel Characters
[x] Hortas Week
[x] Spectre Week
[x] New Modcharts
[x] Settings Menu Bug Fixes
[x] VS Luna Free Trial Subtitles
[x] Septuagint Alt Animations
[x] Expanded Lore
[x] Fixed Meow being silent
[x] Admin Grant lunatheslave.dat
[x] Added Luna The Slave
[x] Updated Credits and Menu
[x] Bottom Right Song Album Covers
[x] Added Alls World
[x] Changelog Page
[x] Noah 3 2 1 GO!
[x] Multicolor Flashes
[x] Exit Menu Sounds
[x] Intro Text changed to Friday Night Funkin' VS Luna The Cat The Full Mod
[x] Extended Game Intro
[x] New Joke Ready Set Go
[x] Note Spamming section in Chart Editor
[x] Luna Engine Enhancements";

            case 2: // Beta 5.1
                return "Version 1.0 Beta 5.1 (COMPLETE!!! 5 Changes)
[x] Fixed and remade Puda
[x] Settings Categories
[x] More pages with Wavy Background
[x] Engine Refinements
[x] I WOULD ROAST YOU, BUT MY MOM SAID I'M NOT ALOUD TO BURN TRASH";

            case 3: // Beta 5
                return "Version 1.0 Beta 5 (COMPLETE!!! 12 Changes)
[x] Added VS Luna Free Trial
[x] Added Sunshine
[x] Added Tessattack
[x] Added Entity
[x] Added Action Two
[x] Custom Menu Music
[x] Noah Engine Menu Music
[x] Playstation Menu Music
[x] Named App Titlebar Beta 5
[x] Added I Shipped My Pants
[x] Console renamed to Terminal
[x] Added Itsumi to Character Selector
[x] Finished Luna's Challenge Week
[x] Luna's Challenge Story Dialogue
[x] Chart Editor modifications
[x] 3d Boyfriend and Luna Dialogue Poses";

            case 4: // Beta 4
                return "Version 1.0 Beta 4 (COMPLETE!!! 22 Changes)
[x] Added BotPlay
[x] Nerfed Recursed
[x] Added Float Effect to Dark Luna
[x] Fixed Dialogues
[x] Finished Week DiStOrTeD
[x] Added Noah The Pinecone
[x] Added Wow Two
[x] Added Luna In Among Us
[x] Moved Blocked to Terminal
[x] alls.dat
[x] Finished Bambi VS Luna Week
[x] Added Kade Engine Watermark
[x] Code Changes
[x] Toggle Mod Charts Setting
[x] Beta Testers and Extra Keys Category in Credits
[x] New Pause Music
[x] Bitch Lasagna in OST
[x] Finished Character Select Menu
[x] Made Notes hit smoother
[x] Credits at the end of Fatalistic
[x] Fixed Love Songs background
[x] Admin Grant Alls.dat";

            case 5: // Beta 3
                return "Version 1.0 Beta 3 (COMPLETE!!! 4 Changes) June 8, 2025
[x] Added Blocked
[x] Added Love Songs
[x] Added Roses
[x] Luna 3 2 1 GO!";

            case 6: // Beta 2
                return "Version 1.0 Beta 2 (COMPLETE!!! 4 Changes) June 4, 2025
[x] Stereo Madness Recharted
[x] Added Darkness
[x] Added Luna's Arcade
[x] Cuberoot Modchart";

            case 7: // Beta 1
                return "Version 1.0 Beta 1 (COMPLETE!!! 8 Changes) May 8, or May 31, 2025
[x] Ported to Kade (Dave) Engine 1.2
[x] Added Lost
[x] Bambi VS Luna Week
[x] New Dialogue Cutscenes
[x] Completely Revamped UI
[x] New Menu Music
[x] Finished Dead Zoee
[x] New Settings";

            default:
                return "No changelog available.";
        }
    }
}