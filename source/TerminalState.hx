import flixel.math.FlxMath;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import sys.io.File;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import openfl.filters.ShaderFilter;
import haxe.ds.Map;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxTimer;
import flash.system.System;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

using StringTools;

import PlayState; //why the hell did this work LMAO.


class TerminalState extends MusicBeatState
{

    //dont just yoink this code and use it in your own mod. this includes you, psych engine porters.
    //if you ingore this message and use it anyway, atleast give credit.

    public var curCommand:String = "";
    public var previousText:String = LanguageManager.getTerminalString("term_introduction");
    public var displayText:FlxText;
    var expungedActivated:Bool = false;
    public var CommandList:Array<TerminalCommand> = new Array<TerminalCommand>();
    public var typeSound:FlxSound;

    // [BAD PERSON] was too lazy to finish this lol.
    var unformattedSymbols:Array<String> =
    [
        "period",
        "backslash",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
        "zero",
        "shift",
        "semicolon",
        "alt",
        "lbracket",
        "rbracket",
        "comma",
        "plus"
    ];

    var formattedSymbols:Array<String> =
    [
        ".",
        "/",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "0",
        "",
        ";",
        "",
        "[",
        "]",
        ",",
        "="
    ];
    public var fakeDisplayGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
    public var expungedTimer:FlxTimer;
    var curExpungedAlpha:Float = 0;

    override public function create():Void
    {
        Main.fps.visible = false;
        PlayState.isStoryMode = false;
        displayText = new FlxText(0, 0, FlxG.width, previousText, 32);
		displayText.setFormat(Paths.font("fixedsys.ttf"), 16);
        displayText.size *= 2;
		displayText.antialiasing = false;
        typeSound = FlxG.sound.load(Paths.sound('terminal_space'), 0.6);
        FlxG.sound.playMusic(Paths.music('TheAmbience','shared'), 0.7);

        CommandList.push(new TerminalCommand("help", LanguageManager.getTerminalString("term_help_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var helpText:String = "";
            for (v in CommandList)
            {
                if (v.showInHelp)
                {
                    helpText += (v.commandName + " - " + v.commandHelp + "\n");
                }
            }
            UpdateText("\n" + helpText);
        }));

        CommandList.push(new TerminalCommand("characters", LanguageManager.getTerminalString("term_char_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            UpdateText("\nluna.dat\nalls.dat\nlunafinal.dat\nlunatrueform.dat");
        }));
        CommandList.push(new TerminalCommand("iwouldroastyoubutmymomsaidimnotallowedtoburntrash", LanguageManager.getTerminalString("term_burn_trash"), function(arguments:Array<String>)
        {
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_god"));
		                  	FlxG.save.data.burntrashFound = true;
	        				PlayState.SONG = Song.loadFromJson("i-would-roast-you-but-my-mom-said-im-not-allowed-to-burn-trash"); // fuck is that
                            PlayState.SONG.validScore = false;
                            PlayState.SONG.player2 = "alls";
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
        }));
        CommandList.push(new TerminalCommand("admin", LanguageManager.getTerminalString("term_admin_ins"), function(arguments:Array<String>)
        {
            if (arguments.length == 0)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText("\n" + (!FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'User354378')
                 + LanguageManager.getTerminalString("term_admlist_ins"));
                return;
            }
            else if (arguments.length != 2)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText(LanguageManager.getTerminalString("term_admin_error1") + " " + arguments.length + LanguageManager.getTerminalString("term_admin_error2"));
            }
            else
            {
                if (arguments[0] == "grant")
                {
                    switch (arguments[1])
                    {
                        default:
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\n" + arguments[1] + LanguageManager.getTerminalString("term_grant_error1"));
                        case "luna.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Dave;
                            PlayState.SONG = Song.loadFromJson("luna");
                            PlayState.SONG.validScore = false;
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());

                        case "alls.dat":
                            UpdatePreviousText(false); //resets the text

                            expungedActivated = true;
    
                            // First phase: "GOD IS COMING" message
                            UpdateText("GOD IS COMING");
                            FlxG.sound.play(Paths.sound('GODISCOMING'));
    
                            // Create a timer for the 57-second red screen transition
                            var redIntensity:Float = 0;
                            var elapsedTime:Float = 0;
                            var transitionDuration:Float = 57;
                            var maxAlpha:Float = 0.60;
    
                            // Create a red overlay sprite
                            var redOverlay = new FlxSprite(0, 0);
                            redOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
                            redOverlay.alpha = 0;
                            add(redOverlay);
    
                            // Timer to gradually increase red over 57 seconds
                            new FlxTimer().start(0.1, function(tmr:FlxTimer) {
                                elapsedTime += 0.1;
                                redOverlay.alpha = (elapsedTime / transitionDuration) * maxAlpha;
        
                                if (elapsedTime >= transitionDuration) {
                                    tmr.cancel();
            
                                    // Second phase: "GOD IS HERE" message after 57 seconds
                                    UpdateText("GOD IS HERE");
            
                                    // Wait 10 seconds before loading the song
                                    new FlxTimer().start(10, function(finalTimer:FlxTimer) {
                                        FlxG.save.data.exbungoFound = true;
                                        PlayState.SONG = Song.loadFromJson("blocked");
                                        PlayState.SONG.validScore = false;
                                        PlayState.SONG.player2 = "alls";
                                        Main.fps.visible = !FlxG.save.data.disableFps;
                                        LoadingState.loadAndSwitchState(new PlayState());
                                    });
                                }
                            }, 0); // 0 means repeat indefinitely until cancelled

                        case "lunatheslave.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
		                  	FlxG.save.data.slaveFound = true;
	        				PlayState.SONG = Song.loadFromJson("luna-the-slave"); // SLAVE
                            PlayState.SONG.validScore = false;
                            PlayState.SONG.player2 = "lunaslave";
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "lunafinal.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Bambi;
                            PlayState.SONG = Song.loadFromJson('fatalistic');
                            PlayState.SONG.validScore = false;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "lunatrueform.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            expungedActivated = true;
                            new FlxTimer().start(3, function(timer:FlxTimer)
                            {   
                                expungedReignStarts();
                            });
                   }
                }
                else
                {
                    UpdateText("\nInvalid Parameter"); //todo: translate.
                }
            }
        }));
        CommandList.push(new TerminalCommand("clear", LanguageManager.getTerminalString("term_clear_ins"), function(arguments:Array<String>)
        {
            previousText = "> ";
            UpdateText("");
        }));
        CommandList.push(new TerminalCommand("open", LanguageManager.getTerminalString("term_texts_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var tx = "";
            switch (arguments[0].toLowerCase())
            {
                default:
                    tx = "File not found.";
                case "moldygh":
                    tx = "The creator and keeper of the mods backbone. The creator of Dave Engine.";
                case "kadedev":
                    tx = "The creator and keeper of Kade Engine, Dave Engine's backbone. Without Kade, nothing could function.";
                case "biggest":
                    tx = "I'm the biggest bird.";
                case "ping":
                    tx = "pong.";
                case "6":
                    tx = "7.";
                case "shadowmario":
                    tx = "washed.";
                case "thetruth":
                    tx = "THE TRUTH WILL NEVER BE KNOWN. THE REAL ONE.\nFOREVER YOU SHALL WATCH IN DESPAIR AS YOUR WORLD UNFOLDS INTO CHAOS AROUND, UNKNOWING OF THE REAL TRUTH.";
                case "luna":
                    tx = "A forgotten GOD.\nThe truth will never be known.\nThe extent of her powers will never be unfolded to it's full extent.\nThe more angry Luna gets, the more she executes her powers.\nShe will take things to the deadliest level until she is satisfied with your death.";
                case "girlfriend":
                    tx = "Forgotten. Lost in the void. After entering Fatalistic, you still have yet to find her.\nThe truth will never be known as to what happened to her, alive or dead.";
            }
            //case sensitive!!
            switch (arguments[0])
            {
                case "5G9I9A7":
                    tx = "Even when you're feeling blue.\nAnd the world feels like its crumbling around you.\nJust know that I'll always be there.\nI wish I knew, everything that will happen to you.\nBut I don't, and that's okay.\nAs long as I'm here you'll always see a sunny day.";
                case "Y29udmVyc2F0aW9u":
                    tx = "Log 5997\nI encountered some entity in the void today.\nCalled me \"Out of Order\".\nIt mentioned [DATA LUNA TRUE FORM] and I asked it for help.\nI don't know if I can trust it but I don't really have\nany other options.";
            }
            UpdateText("\n" + tx);
        }));
        CommandList.push(new TerminalCommand("vault", LanguageManager.getTerminalString("term_vault_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var funnyRequiredKeys:Array<String> = ['free', 'reflection', 'p.r.a.e.m'];
            var amountofkeys:Int = (arguments.contains(funnyRequiredKeys[0]) ? 1 : 0);
            amountofkeys += (arguments.contains(funnyRequiredKeys[1]) ? 1 : 0);
            amountofkeys += (arguments.contains(funnyRequiredKeys[2]) ? 1 : 0);
            if (arguments.contains(funnyRequiredKeys[0]) && arguments.contains(funnyRequiredKeys[1]) && arguments.contains(funnyRequiredKeys[2]))
            {
                UpdateText("\nVault unlocked.\ncGVyZmVjdGlvbg\nbGlhcg\nYmVkdGltZSBzb25n\ndGhlIG1lZXRpbmcgcDE=\ndGhlIG1lZXRpbmcgcDI=\nYmlydGhkYXk=\nZW1haWw=\nYXJ0aWZhY3QzLWE=");
            }
            else
            {
                UpdateText("\n" + "Invalid keys. Valid keys: " + amountofkeys);
            }
        }));
        CommandList.push(new TerminalCommand("baldi", LanguageManager.getTerminalString("term_leak_ins"), function(arguments:Array<String>)
        {
            Main.fps.visible = !FlxG.save.data.disableFps;
			MathGameState.accessThroughTerminal = true;
            FlxG.switchState(new MathGameState());
        }, false, true));

        add(displayText);

        super.create();
    }

    public function UpdateText(val:String)
    {
        displayText.text = previousText + val;
    }

    //after all of my work this STILL DOESNT COMPLETELY STOP THE TEXT SHIT FROM GOING OFF THE SCREEN IM GONNA DIE   whoever typed this.. im so sorry.. -johnny
    public function UpdatePreviousText(reset:Bool)
    {
        previousText = displayText.text + (reset ? "\n> " : "");
        displayText.text = previousText;
        curCommand = "";
        var finalthing:String = "";
        var splits:Array<String> = displayText.text.split("\n");
        if (splits.length <= 22)
        {
            return;
        }
        var split_end:Int = Math.round(Math.max(splits.length - 22,0));
        for (i in split_end...splits.length)
        {
            var split:String = splits[i];
            if (split == "")
            {
                finalthing = finalthing + "\n";
            }
            else
            {
                finalthing = finalthing + split + (i < (splits.length - 1) ? "\n" : "");
            }
        }
        previousText = finalthing;
        displayText.text = finalthing;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (expungedActivated)
        {
            curExpungedAlpha = Math.min(curExpungedAlpha + elapsed, 1);
            if (fakeDisplayGroup.exists && fakeDisplayGroup != null)
            {
                for (text in fakeDisplayGroup.members)
                {
                    text.alpha = curExpungedAlpha;
                }
            }
            return;
        }
        var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);

        if (keyJustPressed == FlxKey.ENTER)
        {
            var calledFunc:Bool = false;
            var arguments:Array<String> = curCommand.split(" ");
            for (v in CommandList)
            {
                if (v.commandName == arguments[0] || (v.commandName == curCommand && v.oneCommand)) //argument 0 should be the actual command at the moment
                {
                    arguments.shift();
                    calledFunc = true;
                    v.FuncToCall(arguments);
                    break;
                }
            }
            if (!calledFunc)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText(LanguageManager.getTerminalString("term_unknown") + arguments[0] + "\"");
            }
            UpdatePreviousText(true);
            return;
        }

        if (keyJustPressed != FlxKey.NONE)
        {
            if (keyJustPressed == FlxKey.BACKSPACE)
            {
                curCommand = curCommand.substr(0,curCommand.length - 1);
                typeSound.play();
            }
            else if (keyJustPressed == FlxKey.SPACE)
            {
                curCommand += " ";
                typeSound.play();
            }
            else
            {
                var toShow:String = keyJustPressed.toString().toLowerCase();
                for (i in 0...unformattedSymbols.length)
                {
                    if (toShow == unformattedSymbols[i])
                    {
                        toShow = formattedSymbols[i];
                        break;
                    }
                }
                if (FlxG.keys.pressed.SHIFT)
                {
                    toShow = toShow.toUpperCase();
                }
                curCommand += toShow;
                typeSound.play();
            }
            UpdateText(curCommand);
        }
        if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.BACKSPACE)
        {
            curCommand = "";
        }
        if (FlxG.keys.justPressed.ESCAPE)
        {
            Main.fps.visible = !FlxG.save.data.disableFps;
            FlxG.switchState(new MainMenuState());
        }
    }

	function expungedReignStarts()
	{
		var glitch = new FlxSprite(0, 0);
		glitch.frames = Paths.getSparrowAtlas('ui/glitch/glitch');
		glitch.animation.addByPrefix('glitchScreen', 'glitch', 40);
		glitch.animation.play('glitchScreen');
		glitch.setGraphicSize(FlxG.width, FlxG.height);
		glitch.updateHitbox();
		glitch.screenCenter();
		glitch.scrollFactor.set();
		glitch.antialiasing = false;
		if (FlxG.save.data.eyesores)
		{
			add(glitch);
		}

		add(fakeDisplayGroup);

		var expungedLines:Array<String> = [
			'TAKING OVER....',
			'ATTEMPTING TO HIJACK ADMIN OVERRIDE...',
			'THE VOID IS MINE',
			"DON'T YOU UNDERSTAND? THIS IS MY WORLD NOW.",
			"I WIN, YOU LOSE.",
			"GAME OVER.",
			"THIS IS IT.",
			"FUCK YOU!",
			"I HAVE THE PLOT ARMOR NOW!!",
			"YOU SHOULDN'T HAVE DONE THAT",
			"AHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH",
			"LUNA'S REIGN SHALL START",
			'[DATA LUNATRUE FORM]'
		];
		var i:Int = 0;
		var camFollow = new FlxObject(FlxG.width / 2, -FlxG.height / 2, 1, 1);

		#if windows
		if (!FlxG.save.data.selfAwareness)
		{
			expungedLines.push("Hacking into " + Sys.environment()["COMPUTERNAME"] + "...");
		}
		#end

        FlxG.camera.follow(camFollow, 1);

        expungedActivated = true;
        expungedTimer = new FlxTimer().start(FlxG.elapsed * 2, function(timer:FlxTimer)
        {
            var lastFakeDisplay = fakeDisplayGroup.members[i - 1];
            var fakeDisplay:FlxText = new FlxText(0, 0, FlxG.width, "> " + expungedLines[new FlxRandom().int(0, expungedLines.length - 1)], 19);
            fakeDisplay.setFormat(Paths.font("fixedsys.ttf"), 16);
            fakeDisplay.size *= 2;
            fakeDisplay.antialiasing = false;

            var yValue:Float = lastFakeDisplay == null ? displayText.y + displayText.textField.textHeight : lastFakeDisplay.y + lastFakeDisplay.textField.textHeight;
            fakeDisplay.y = yValue;
            fakeDisplayGroup.add(fakeDisplay);
            if (fakeDisplay.y > FlxG.height)
            {
                camFollow.y = fakeDisplay.y - FlxG.height / 2;
            }
            i++;
        }, FlxMath.MAX_VALUE_INT);
        
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound("expungedGrantedAccess", "preload"), function()
        {
            FlxTween.tween(glitch, {alpha: 0}, 1);
            expungedTimer.cancel();
            fakeDisplayGroup.clear();

            var eye = new FlxSprite(0, 0).loadGraphic(Paths.image('mainMenu/eye'));
			eye.screenCenter();
			eye.antialiasing = false;
            eye.alpha = 0;
			add(eye);

            FlxTween.tween(eye, {alpha: 1}, 1, {onComplete: function(tween:FlxTween)
            {
                FlxTween.tween(eye, {alpha: 0}, 1);
            }});
			FlxG.sound.play(Paths.sound('iTrollYou', 'shared'), function()
			{
				new FlxTimer().start(1, function(timer:FlxTimer)
				{
					FlxG.save.data.exploitationState = 'awaiting';
					FlxG.save.data.exploitationFound = true;
					FlxG.save.flush();

					var programPath:String = Sys.programPath();
					var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";

					File.saveContent(textPath, "you don't know what you're getting yourself into\n don't open the game for your own risk");
					System.exit(0);
				});
			});
        });
    }
}


class TerminalCommand
{
    public var commandName:String = "undefined";
    public var commandHelp:String = "if you see this you are very homosexual and dumb."; //hey im not homosexual. kinda mean ngl
    public var FuncToCall:Dynamic;
    public var showInHelp:Bool;
    public var oneCommand:Bool;

    public function new(name:String, help:String, func:Dynamic, showInHelp = true, oneCommand:Bool = false)
    {
        commandName = name;
        commandHelp = help;
        FuncToCall = func;
        this.showInHelp = showInHelp;
        this.oneCommand = oneCommand;
    }

}