package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSoundGroup;
import flixel.ui.FlxBar;
import flixel.system.FlxSound;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.FlxObject;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class MusicPlayerState extends MusicBeatState
{
    var songs:Array<PlaySongMetadata> = [];
    private var grpSongs:FlxTypedGroup<Alphabet>;
    private var iconArray:Array<HealthIcon> = [];
    var curSelected:Int = 0;
    var CurVocals:FlxSound;
    var currentlyplaying:Bool = false;
    public var playdist:Float = 0;
    var bg:FlxSprite;

    private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

    private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

    private var barText:FlxText;

    // Category system (mirroring FreeplayState)
    private var Catagories:Array<String> = ['dave', 'joke', 'extras', 'iykyk'];
    var translatedCatagory:Array<String> = [LanguageManager.getTextString('freeplay_dave'), LanguageManager.getTextString('freeplay_joke'), LanguageManager.getTextString('freeplay_extra'), LanguageManager.getTextString('freeplay_iykyk')];
    private var CurrentPack:Int = 0;
    private var InMainMusicPlayerState:Bool = false;
    var titles:Array<Alphabet> = [];
    var icons:Array<FlxSprite> = [];
    var loadingPack:Bool = false;
    var canInteract:Bool = true;
    private var camFollow:FlxObject;
    var awaitingExploitation:Bool;

    // Locked song text
    var lockedSongText:FlxText;
    var lockedSongTimer:FlxTimer;
  
    override function create()
    {
        FlxG.autoPause = false;
        
        awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');

        // Setup background
        bg = new FlxSprite();
        if (awaitingExploitation)
        {
            bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
            bg.scrollFactor.set();
            bg.antialiasing = false;
            bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
        }
        else
        {
            bg.loadGraphic(MainMenuState.randomizeBG());
            bg.color = 0xFFFD719B;
            bg.scrollFactor.set();
        }
        add(bg);

        // Check for terminal category
        if (FlxG.save.data.terminalFound && !awaitingExploitation)
        {
            Catagories = ['dave', 'joke', 'extras', 'iykyk', 'terminal'];
            translatedCatagory = [
                LanguageManager.getTextString('freeplay_dave'),
                LanguageManager.getTextString('freeplay_joke'),
                LanguageManager.getTextString('freeplay_extra'),
                LanguageManager.getTextString('freeplay_iykyk'),
                LanguageManager.getTextString('freeplay_terminal')
            ];
        }

        // Create category icons
        for (i in 0...Catagories.length)
        {
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

        // Setup camera follow
        camFollow = new FlxObject(0, 0, 1, 1);
        camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);
        add(camFollow);
        
        FlxG.camera.follow(camFollow, LOCKON, 0.04);
        FlxG.camera.focusOn(camFollow.getPosition());

        // Handle exploitation state
        if (awaitingExploitation)
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
                canInteract = true;
            }});
        }

        #if desktop
        DiscordClient.changePresence("In the OST Menu", null);
        #end

        super.create();
    }

    public function LoadProperPack()
    {
	    switch (Catagories[CurrentPack].toLowerCase())
	    {
		    case 'uhoh':
			    addWeek(['Darkness'], ['lunatrueform'], [false]);
		    case 'dave':
			    addWeek(['Warmup'], ['luna'], [true]);
			    addWeek(['Luna', 'Treats'], ['luna', 'luna'], [true, true]);
			    addWeek(['Scratch'], ['lunamad'], [true]);
			    addWeek(['Fatalistic'], ['lunafinal'], [true]);
			    addWeek(['Nomophobia'], ['lunanomo'], [true]);
			    addWeek(['Disoriented'], ['lunadis'], [true]);
			    addWeek(['Action', 'Action-Two', 'Meow'], ['luna3d', 'luna3d', 'luna'], [true, true, true]);
			    addWeek(['Galactic', 'Milky-Way'], ['lunaspectre', 'lunaspectre'], [true, true]);
			    addWeek(['Master'], ['lunamadspectre'], [true]);
			    addWeek(['Heavenly'], ['holyluna'], [true]);
			    addWeek(['Septuagint'], ['lunaseptuagint'], [true]);
			    addWeek(['Clamorous'], ['lunaclamorous'], [true]);
			    addWeek(['Psychosis'], ['sisters'], [true]);
			    if (FlxG.save.data.hasPlayedMasterWeek)
			    {
				    addWeek(['Cheating'], ['bambi-3d'], [true]);
				    addWeek(['Unfairness'], ['bambi-unfair'], [true]);
			    }
		    case 'joke':
			    addWeek(['dead-zoee'], ['puda'], [true]);
			    addWeek(['lunatopia'], ['lunar'], [true]);
			    addWeek(['vs-luna-free-trial'], ['lunar'], [true]);
			    addWeek(['the-biggest-bird'], ['luna'], [true]);
			    addWeek(['wow-two'], ['luna'], [true]);
			    addWeek(['shipped-my-pants'], ['elonmusk'], [true]);
			    addWeek(['luna-in-among-us'], ['impostor'], [true]);
			    addWeek(['noah-the-pinecone'], ['noahreal'], [true]);
			    addWeek(['obama'], ['obama'], [true]);
			    addWeek(['kys'], ['lunagod'], [true]);
		    case 'extras':
			    addWeek(['Wheels', 'Apprentice', 'Stereo-Madness', 'Roofs', 'Lunas-Arcade'], ['luna', 'luna', 'luna', 'luna', 'luna'], [true, true, true, true, true]);
			    addWeek(['Cuberoot'], ['luna3d'], [true]);
			    addWeek(['Love-Songs'], ['luna3d'], [true]);
			    addWeek(['Yarn'], ['lunaspectre'], [true]);
			    addWeek(['Roses'], ['luna-pixel'], [true]);
			    addWeek(['Lunacone'], ['lunacone'], [true]);
			    addWeek(['Kalampokiphobia'], ['lunakalam'], [true]);
			    addWeek(['Tessattack'], ['lunatessattack'], [true]);
			    addWeek(['Sunshine'], ['lunadoll'], [true]);
			    addWeek(['Puda'], ['puda'], [true]);
			    addWeek(['Lost'], ['lunahalloween'], [true]);
			    addWeek(['Heart-Of-Gold'], ['lunagold'], [true]);
			    if (FlxG.save.data.recursedUnlocked)
				    addWeek(['Recursed'], ['dark'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.recursedUnlocked)
				    addWeek(['Entity'], ['dark'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.optoplisticUnlocked)
				    addWeek(['Optoplistic'], ['optoplistic'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
		    case 'iykyk':
			    if (FlxG.save.data.unethicalFound)
				    addWeek(['unethical'], ['philtrixpissed'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
		    case 'terminal':
			    if (FlxG.save.data.exbungoFound)
				    addWeek(['Blocked'], ['alls'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.exbungoNonoFound)
				    addWeek(['Opposition'], ['nonoalls'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.exbungoFound)
				    addWeek(['Alls-World'], ['alls'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.burntrashFound)
				    addWeek(['i-would-roast-you-but-my-mom-said-im-not-allowed-to-burn-trash'], ['alls'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.slaveFound)
				    addWeek(['Luna-The-Slave'], ['lunaslave'], [true]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
			    if (FlxG.save.data.exploitationFound)
				    addWeek(['Darkness'], ['lunatrueform'], [false]);
			    else
				    addWeek(['Locked Song'], ['lock'], [false]);
	    }
    }

    public function addWeek(songs:Array<String>, songCharacters:Array<String>, hasVocals:Array<Bool>)
    {
        var num:Int = 0;

        for (song in songs)
        {
            addSong(song, songCharacters[num], hasVocals[num]);

            if (songCharacters.length != 1)
                num++;
        }
    }

    public function addSong(songName:String, songCharacter:String, hasVocals:Bool)
    {
        songs.push(new PlaySongMetadata(songName, false, songCharacter, false, hasVocals));
        
        // Add instrumental version if has vocals
        if (hasVocals)
        {
            songs.push(new PlaySongMetadata(songName, false, songCharacter, false, false));
        }
    }

    public function GoToActualMusicPlayer()
    {
        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);

        for (i in 0...songs.length)
        {
            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName + (songs[i].hasVocals ? "" : "-Inst"), true, false);
            songText.isMenuItem = true;
            songText.targetY = i;
            songText.scrollFactor.set();
            grpSongs.add(songText);

            var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
            icon.sprTracker = songText;
            icon.scrollFactor.set();
            icon.changeState(songs[i].ShowBadIcon ? 'losing' : 'normal');

            iconArray.push(icon);
            add(icon);
        }

        // Create hp bar for playback progress
        healthBarBG = new FlxSprite(0, 50).loadGraphic(Paths.image('ui/healthBar'));
        healthBarBG.screenCenter(X);
        healthBarBG.scrollFactor.set();
        add(healthBarBG);

        healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'playdist', 0, 1);
        healthBar.scrollFactor.set();
        healthBar.createFilledBar(FlxColor.WHITE, FlxColor.BLACK);
        insert(members.indexOf(healthBarBG), healthBar);

        iconP1 = new HealthIcon("bf", true);
        iconP1.y = healthBar.y - (iconP1.height / 2);
        add(iconP1);

        iconP2 = new HealthIcon("bf-old", false);
        iconP2.y = healthBar.y - (iconP2.height / 2);
        add(iconP2);

        barText = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + healthBarBG.height + 5, 0, "", 20);
        barText.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        barText.scrollFactor.set();
        barText.borderSize = 1.5;
        barText.antialiasing = true;
        barText.screenCenter(X);
        add(barText);

        // Initialize locked song text
        lockedSongText = new FlxText(0, FlxG.height - 150, FlxG.width, "", 32);
        lockedSongText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        lockedSongText.borderSize = 2;
        lockedSongText.antialiasing = true;
        lockedSongText.scrollFactor.set();
        lockedSongText.alpha = 0;
        add(lockedSongText);

        HideBar();

        changeSelection();
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

    function getLockedSongMessage(songName:String):String
    {
        var lowerSong = songName.toLowerCase();
        
        if (lowerSong == 'opposition')
            return 'Pressing 7 somewhere may unlock this song.';
        
        if (lowerSong == 'optoplistic')
            return 'TURN BACK NOW.';
        
        return 'Unknown unlock...';
    }

    function showLockedSongText(message:String)
    {
        // Cancel existing timer if any
        if (lockedSongTimer != null)
        {
            lockedSongTimer.cancel();
        }

        // Set text and position
        lockedSongText.text = message;
        lockedSongText.y = FlxG.height - 150;
        lockedSongText.screenCenter(X);

        // Bouncy animation in
        FlxTween.cancelTweensOf(lockedSongText);
        lockedSongText.alpha = 0;
        lockedSongText.y += 50; // Start lower
        FlxTween.tween(lockedSongText, {alpha: 1, y: lockedSongText.y - 50}, 0.5, {ease: FlxEase.backOut});

        // Hide after 3 seconds
        lockedSongTimer = new FlxTimer().start(3, function(timer:FlxTimer)
        {
            FlxTween.tween(lockedSongText, {alpha: 0}, 0.5);
        });
    }

    var lastText:String = "";

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (barText != null && barText.text != lastText)
        {
            barText.screenCenter(X);
            lastText = barText.text;
        }

        // Category Selection Mode
        if (!InMainMusicPlayerState)
        {
            if (controls.LEFT_P && canInteract)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                UpdatePackSelection(-1);
            }
            if (controls.RIGHT_P && canInteract)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                UpdatePackSelection(1);
            }
            if (controls.ACCEPT && !loadingPack && canInteract)
            {
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                canInteract = false;

                new FlxTimer().start(0.2, function(timer:FlxTimer)
                {
                    loadingPack = true;
                    LoadProperPack();
                    
                    for (item in icons) { FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut}); }
                    for (item in titles) { FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut}); }
                    
                    new FlxTimer().start(0.2, function(timer:FlxTimer)
                    {
                        for (item in icons) { item.visible = false; }
                        for (item in titles) { item.visible = false; }

                        GoToActualMusicPlayer();
                        InMainMusicPlayerState = true;
                        loadingPack = false;
                        canInteract = true;
                    });
                });
            }
            if (controls.BACK && canInteract && !awaitingExploitation)
            {
                FlxG.autoPause = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxG.switchState(new MainMenuState());
            }
            return;
        }

        // Music Player Mode
        var upP = controls.UP_P;
        var downP = controls.DOWN_P;
        var leftP = controls.LEFT_P;
        var rightP = controls.RIGHT_P;
        var accepted = controls.ACCEPT;

        playdist = 1 - (FlxG.sound.music.time / FlxG.sound.music.length);

        // Update icon positions based on progress bar
        iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - 26);
        iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - 26);

        // Discord presence
        var currentTimeFormatted = FlxStringUtil.formatTime(FlxG.sound.music.time / 1000);
        var lengthFormatted = FlxStringUtil.formatTime(FlxG.sound.music.length / 1000);
        if (currentlyplaying)
        {
            var trackName = songs[curSelected].songName + (songs[curSelected].hasVocals ? "" : " Instrumental");
            #if desktop
            DiscordClient.changePresence('In The OST Menu', '\nListening To: ' +
                CoolUtil.formatString(trackName, '-') + ' | ' + 
                currentTimeFormatted + ' / ' + lengthFormatted,
                null);
            #end
        }

        // Icon state based on progress
        if (healthBar.percent < 20)
            iconP1.changeState('losing');
        else
            iconP1.changeState('normal');

        if (healthBar.percent > 80)
            iconP2.changeState('losing');
        else
            iconP2.changeState('normal');

        // Navigation
        if (upP && canInteract)
        {
            changeSelection(-1);
        }
        if (downP && canInteract)
        {
            changeSelection(1);
        }

        // Seeking
        if (currentlyplaying)
        {
            if (leftP)
            {
                if (CurVocals != null)
                {
                    CurVocals.time -= 5000;
                }
                FlxG.sound.music.time -= 5000;
            }
            if (rightP)
            {
                if (CurVocals != null)
                {
                    CurVocals.time += 5000;
                }
                FlxG.sound.music.time += 5000;
            }
        }

        barText.text = FlxStringUtil.formatTime(FlxG.sound.music.time / 1000) + " / " + FlxStringUtil.formatTime(FlxG.sound.music.length / 1000);

        // Back button handling
        if (controls.BACK && canInteract)
        {
            if (currentlyplaying)
            {
                #if desktop
                DiscordClient.changePresence('In The OST Menu', null);
                #end
                
                if (CurVocals != null)
                {
                    CurVocals.stop();
                    FlxG.sound.list.remove(CurVocals);
                }
                HideBar();
                FlxG.sound.music.stop();
                currentlyplaying = false;

                // Restore menu music
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
                                Conductor.changeBPM(146);
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
            }
            else
            {
                // Go back to category selection
                canInteract = false;

                FlxG.sound.play(Paths.sound('cancelMenu'));
                
                // Hide locked song message when going back
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
                    FlxTween.tween(i, {y: 5000, alpha: 0}, 0.3, {onComplete: function(twn:FlxTween)
                    {
                        for (item in icons) { item.visible = true; FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut}); }
                        for (item in titles) { item.visible = true; FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut}); }

                        InMainMusicPlayerState = false;

                        for (i in grpSongs) { remove(i); }
                        for (i in iconArray) { remove(i); }

                        songs = [];
                        grpSongs.members = [];
                        iconArray = [];
                        curSelected = 0;
                        canInteract = true;
                    }});
                }
            }
        }

        // Play/select song
        if (accepted && canInteract)
        {
	        if (songs[curSelected].songName == 'Locked Song')
	        {
		        // Play lock sound and shake screen
		        FlxG.sound.play(Paths.sound('lock'));
		        FlxG.camera.shake(0.01, 0.1);
		        
		        // Show unlock message based on the previous song's name
		        var message = getLockedSongMessage(curSelected > 0 ? songs[curSelected - 1].songName : "");
		        showLockedSongText(message);
	        }
	        else if (currentlyplaying == false)
	        {
		        ShowBar(songs[curSelected].songCharacter);
		
		        currentlyplaying = true;
		        if (songs[curSelected].hasVocals)
		        {
			        CurVocals = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));
		        }
		        else
		        {
			        CurVocals = new FlxSound();
		        }

		        FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 1, true);
		        CurVocals.looped = true;
		        CurVocals.play();
		        FlxG.sound.list.add(CurVocals);

		        var bullShit:Int = 0;

		        for (i in 0...iconArray.length)
		        {
			        if(i != curSelected)
			        {
				        FlxTween.tween(iconArray[i], {alpha:0}, 0.15);
			        }
			        else
			        {
				        iconArray[curSelected].alpha = 1;
			        }
		        }

		        for (item in grpSongs.members)
		        {
			        item.targetY = bullShit - curSelected;
			        bullShit++;

			        if(item.targetY != 0)
			        {
				        FlxTween.tween(item, {alpha:0}, 0.15);
			        }

			        if (item.targetY == 0)
			        {
			           item.alpha = 1;
			        }
		        }
	        }
        }
    }

    function HideBar()
    {
        FlxTween.tween(iconP1, {alpha: 0}, 0.15);
        FlxTween.tween(iconP2, {alpha: 0}, 0.15);
        FlxTween.tween(barText, {alpha: 0}, 0.15);
        FlxTween.tween(healthBar, {alpha: 0}, 0.15);
        FlxTween.tween(healthBarBG, {alpha: 0}, 0.15);
        new FlxTimer().start(0.15, function(timer:FlxTimer)
        {
            iconP1.visible = false;
            iconP2.visible = false;
            barText.visible = false;
            healthBar.visible = false;
            healthBarBG.visible = false;
        });
    }

    function ShowBar(char:String)
    {
        iconP1.alpha = 0;
        iconP2.alpha = 0;
        barText.alpha = 0;
        healthBar.alpha = 0;
        healthBarBG.alpha = 0;
        iconP1.visible = true;
        iconP2.changeIcon(char);
        iconP2.visible = true;
        barText.visible = true;
        healthBar.visible = true;
        healthBarBG.visible = true;
        FlxTween.tween(iconP1, {alpha: 1}, 0.15);
        FlxTween.tween(iconP2, {alpha: 1}, 0.15);
        FlxTween.tween(barText, {alpha: 1}, 0.15);
        FlxTween.tween(healthBar, {alpha: 1}, 0.15);
        FlxTween.tween(healthBarBG, {alpha: 1}, 0.15);
    }

    function changeSelection(change:Int = 0)
    {
        if (currentlyplaying)
        {
            return;
        }
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        curSelected += change;

        if (curSelected < 0)
            curSelected = songs.length - 1;
        if (curSelected >= songs.length)
            curSelected = 0;
        
        var bullShit:Int = 0;

        for (i in 0...iconArray.length)
        {
            if(i != curSelected)
            {
                FlxTween.tween(iconArray[i], {alpha: 0.6}, 0.15);
            }
            else
            {
                iconArray[curSelected].alpha = 1;
            }
        }
    
        for (item in grpSongs.members)
        {
            item.targetY = bullShit - curSelected;
            bullShit++;

            if(item.targetY != 0)
            {
                FlxTween.tween(item, {alpha: 0.6}, 0.15);
            }

            if (item.targetY == 0)
            {
                item.alpha = 1;
            }
        }
    }
}

class PlaySongMetadata
{
	public var songName:String = "";
	public var ExternalSong:Bool = false;
    public var ShowBadIcon:Bool = false;
	public var songCharacter:String = "";
    public var hasVocals:Bool = true;

	public function new(song:String, external:Bool, songCharacter:String, bad:Bool, vocal:Bool)
	{
		this.songName = song;
		this.ExternalSong = external;
		this.songCharacter = songCharacter;
        this.ShowBadIcon = bad;
        this.hasVocals = vocal;
	}
}