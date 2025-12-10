package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect.FlxGlitchDirection;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import openfl.ui.Keyboard;
import flixel.util.FlxCollision;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	
	public static var weekUnlocked:Array<Bool> = [
		true, true, true, true, true, true, true, true,
		true, true, true, true // Additional weeks unlocked by default
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;
	var curRow:Int = 0;
	var curCol:Int = 0;
	
	// Grid configuration
	static inline var WEEKS_PER_ROW:Int = 4;
	static inline var ROW_SPACING:Int = 180;

	var yellowBG:FlxSprite;

	var txtTracklist:FlxText;
	var txtTrackdeco:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpLocks:FlxTypedGroup<FlxSprite>;
	
	// Week data - easier to manage now!
	var weeks:Array<Week> = [];

	var awaitingExploitation:Bool;
	static var awaitingToPlayMasterWeek:Bool;

	var weekBanners:Array<FlxSprite> = new Array<FlxSprite>();
	var lastSelectedWeek:Int = 0;
	
	var upArrow:FlxSprite;
	var downArrow:FlxSprite;

	override function create()
	{
		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');

		// Initialize weeks - much cleaner now!
		initializeWeeks();

		#if desktop
		DiscordClient.changePresence("In the Story Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				playMenuMusic();
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 0, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("Comic Sans MS Bold", 32);
		scoreText.antialiasing = true;

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 0, 0, "", 32);
		txtWeekTitle.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.antialiasing = true;
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("comic.ttf"), 32);
		rankText.antialiasing = true;
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width * 2, 400, FlxColor.WHITE);
		yellowBG.color = weeks[0].weekColor;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 57, FlxColor.BLACK);
		add(blackBarThingie);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		// Create week items in grid layout
		for (i in 0...weeks.length)
		{
			var row = Math.floor(i / WEEKS_PER_ROW);
			var col = i % WEEKS_PER_ROW;
			
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 80, i);
			weekThing.x += ((weekThing.width + 20) * col);
			weekThing.y += (row * ROW_SPACING);
			weekThing.targetX = col;
			weekThing.antialiasing = true;
			grpWeekText.add(weekThing);
		}

		add(yellowBG);

		txtTrackdeco = new FlxText(0, yellowBG.x + yellowBG.height + 50, FlxG.width, LanguageManager.getTextString('story_track').toUpperCase(), 28);
		txtTrackdeco.alignment = CENTER;
		txtTrackdeco.font = rankText.font;
		txtTrackdeco.color = 0xFFe55777;
		txtTrackdeco.antialiasing = true;
		txtTrackdeco.screenCenter(X);

		txtTracklist = new FlxText(0, yellowBG.x + yellowBG.height + 80, FlxG.width, '', 28);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		txtTracklist.antialiasing = true;
		txtTracklist.screenCenter(X);
		add(txtTrackdeco);
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);

		createWeekBanners();
		createArrowIndicators();

		updateText();
		
		if (awaitingToPlayMasterWeek)
		{
			awaitingToPlayMasterWeek = false;
			var masterWeekIndex = weeks.length - 1;
			var targetRow = Math.floor(masterWeekIndex / WEEKS_PER_ROW);
			var targetCol = masterWeekIndex % WEEKS_PER_ROW;
			changeWeek(targetCol - curCol, targetRow - curRow);
		}
		else
		{
			changeWeek(0, 0);
		}
		super.create();
	}

	function initializeWeeks()
	{
		// ROW 1: Original weeks
		addWeek(['Warmup'], LanguageManager.getTextString('story_tutorial'), 0xFF8A42B7, 'warmup');
		addWeek(['Luna', 'Treats', 'Scratch'], LanguageManager.getTextString('story_lunaWeek'), 0xFF4965FF, 'luna');
		addWeek(['Fatalistic'], LanguageManager.getTextString('story_finalWeek'), 0xFF00B515, 'final');
		addWeek(['Nomophobia', 'Disoriented'], LanguageManager.getTextString('story_disorientedWeek'), 0xFF00FFFF, 'dIsOrIeNtEd');
		
		// ROW 2: More weeks
		addWeek(['Action', 'Action-Two', 'Meow'], LanguageManager.getTextString('story_challengeWeek'), 0xFF800080, 'challenge');
		addWeek(['Galactic', 'Milky-Way', 'Master'], LanguageManager.getTextString('story_spectreWeek'), 0xFFCA00FF, 'spectre');
		addWeek(['Heavenly', 'Septuagint', 'Clamorous', 'Psychosis'], LanguageManager.getTextString('story_hortasWeek'), 0xFF992A33, 'hortas');
		
		// ROW 3: Example new weeks
		addWeek(['Neon', 'Electric', 'Voltage'], 'Electric Dreams', 0xFFFF00FF, 'electric');
		addWeek(['Shadow', 'Eclipse'], 'Dark Side', 0xFF1A1A1A, 'shadow');
		addWeek(['Festival', 'Celebration', 'Party'], 'Festival Week', 0xFFFFD700, 'festival');
		addWeek(['Mystery', 'Enigma'], 'The Unknown', 0xFF4B0082, 'mystery');
		
		// Master week (if unlocked)
		if (FlxG.save.data.masterWeekUnlocked)
		{
			var weekName = !FlxG.save.data.hasPlayedMasterWeek ? 
				LanguageManager.getTextString('story_masterWeekToPlay') : 
				LanguageManager.getTextString('story_masterWeek');
			var banner = FlxG.save.data.hasPlayedMasterWeek ? 'lunavsbambi' : 'what';
			addWeek(['Cheating', 'Unfairness'], weekName, 0xFF116E1C, banner);
		}
	}

	function addWeek(songs:Array<String>, name:String, color:FlxColor, banner:String)
	{
		weeks.push(new Week(songs, name, color, banner));
	}

	function playMenuMusic()
	{
		var musicData = [
			{id: 1, name: 'freakierMenu', bpm: 135},
			{id: 2, name: 'noahEngine', bpm: 102},
			{id: 3, name: 'pinecone', bpm: 293},
			{id: 4, name: 'playstation', bpm: 121},
			{id: 5, name: 'loveSongs', bpm: 120},
			{id: 6, name: 'jacobsLadder', bpm: 146},
			{id: 7, name: 'diddyBlud', bpm: 146},
			{id: 8, name: 'sheWill', bpm: 152},
			{id: 9, name: 'sdp', bpm: 120},
			{id: 10, name: 'iBelievedIt', bpm: 145}
		];
		
		var selectedMusic = musicData.filter(m -> m.id == FlxG.save.data.altMenuMusic)[0];
		
		if (selectedMusic != null)
		{
			FlxG.sound.playMusic(Paths.music(selectedMusic.name), 0);
			Conductor.changeBPM(selectedMusic.bpm);
		}
		else
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			Conductor.changeBPM(150);
		}
	}

	function createWeekBanners()
	{
		for (banner in weekBanners)
		{
			remove(banner);
		}
		weekBanners = [];

		for (i in 0...weeks.length)
		{
			var weekBanner:FlxSprite = new FlxSprite(600, 56).loadGraphic(Paths.image('weekBanners/${weeks[i].bannerName}'));
			weekBanner.antialiasing = false;
			weekBanner.active = true;
			weekBanner.screenCenter(X);
			weekBanner.alpha = i == curWeek ? 1 : 0;
			add(weekBanner);

			weekBanners.push(weekBanner);
		}
	}

	function createArrowIndicators()
	{
		// Create up arrow
		upArrow = new FlxSprite(50, FlxG.height / 2 - 100);
		upArrow.loadGraphic(Paths.image('storyui/up'));
		upArrow.scale.set(0.5, 0.5);
		upArrow.updateHitbox();
		upArrow.antialiasing = true;
		add(upArrow);

		// Create down arrow
		downArrow = new FlxSprite(50, FlxG.height / 2 + 50);
		downArrow.loadGraphic(Paths.image('storyui/down'));
		downArrow.scale.set(0.5, 0.5);
		downArrow.updateHitbox();
		downArrow.antialiasing = true;
		add(downArrow);
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = LanguageManager.getTextString('story_weekScore') + lerpScore;
		txtWeekTitle.text = weeks[curWeek].weekName.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
		
		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.LEFT_P)
				{
					changeWeek(-1, 0);
				}

				if (controls.RIGHT_P)
				{
					changeWeek(1, 0);
				}

				if (controls.UP_P)
				{
					upArrow.loadGraphic(Paths.image('storyui/upPress'));
					changeWeek(0, -1);
				}
				else if (controls.UP_R)
				{
					upArrow.loadGraphic(Paths.image('storyui/up'));
				}

				if (controls.DOWN_P)
				{
					downArrow.loadGraphic(Paths.image('storyui/downPress'));
					changeWeek(0, 1);
				}
				else if (controls.DOWN_R)
				{
					downArrow.loadGraphic(Paths.image('storyui/down'));
				}
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}
		
		if (FlxG.keys.justPressed.SEVEN && !FlxG.save.data.masterWeekUnlocked)
		{
			FlxG.sound.music.fadeOut(1, 0);
			FlxG.camera.shake(0.02, 5.1);
			FlxG.camera.fade(FlxColor.WHITE, 5.05, false, function()
			{
				FlxG.save.data.masterWeekUnlocked = true;
				FlxG.save.data.hasPlayedMasterWeek = false;
				awaitingToPlayMasterWeek = true;
				FlxG.save.flush();

				FlxG.resetState();
			});
			FlxG.sound.play(Paths.sound('doom'));
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (!stopspamming)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}
			
			// Zoom and fade animation for selected week
			var selectedItem = grpWeekText.members[curWeek];
			FlxTween.tween(selectedItem.scale, {x: 1.2, y: 1.2}, 0.6, {ease: FlxEase.expoOut});
			
			// Fade out non-selected weeks
			for (i in 0...grpWeekText.members.length)
			{
				if (i != curWeek)
				{
					var item = grpWeekText.members[i];
					FlxTween.tween(item, {alpha: 0, y: item.y + 50}, 0.4, {ease: FlxEase.expoIn});
				}
			}
			
			// Slide UI elements out
			FlxTween.tween(yellowBG, {alpha: 0}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(scoreText, {x: -200}, 0.5, {ease: FlxEase.expoIn});
			FlxTween.tween(txtWeekTitle, {x: FlxG.width + 200}, 0.5, {ease: FlxEase.expoIn});
			FlxTween.tween(txtTracklist, {alpha: 0, y: txtTracklist.y + 30}, 0.4, {ease: FlxEase.expoIn});
			FlxTween.tween(txtTrackdeco, {alpha: 0, y: txtTrackdeco.y + 30}, 0.4, {ease: FlxEase.expoIn});
			FlxTween.tween(upArrow, {x: -100}, 0.4, {ease: FlxEase.expoIn});
			FlxTween.tween(downArrow, {x: -100}, 0.4, {ease: FlxEase.expoIn});
			
			// Banner zoom effect
			if (curWeek < weekBanners.length)
			{
				FlxTween.tween(weekBanners[curWeek].scale, {x: 1.15, y: 1.15}, 0.6, {ease: FlxEase.expoOut});
			}
			
			// Fade to black after zoom
			new FlxTimer().start(0.6, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.4, false);
			});
			
			PlayState.storyPlaylist = weeks[curWeek].songList;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			PlayState.SONG = Song.loadFromJson(Highscore.formatSong(PlayState.storyPlaylist[0].toLowerCase(), 1));
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				PlayState.characteroverride = "none";
				PlayState.formoverride = "none";
				PlayState.curmult = [1, 1, 1, 1];
				
				// Check if it's the master week (last week if unlocked)
				if (FlxG.save.data.masterWeekUnlocked && curWeek == weeks.length - 1)
				{
					if (!FlxG.save.data.hasPlayedMasterWeek)
					{
						FlxG.save.data.hasPlayedMasterWeek = true;
						FlxG.save.flush();
						
						// Update the week banner after playing
						weeks[weeks.length - 1].bannerName = 'lunavsbambi';
						var newBanner:FlxSprite = new FlxSprite(600, 56).loadGraphic(Paths.image('weekBanners/lunavsbambi'));
						newBanner.antialiasing = false;
						newBanner.active = true;
						newBanner.screenCenter(X);
						newBanner.alpha = 1;
						
						// Replace old banner
						remove(weekBanners[weeks.length - 1]);
						weekBanners[weeks.length - 1] = newBanner;
						add(newBanner);
					}
				}
				
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(changeCol:Int = 0, changeRow:Int = 0):Void
	{
		lastSelectedWeek = curWeek;
		
		curCol += changeCol;
		curRow += changeRow;
		
		var maxRow = Math.ceil(weeks.length / WEEKS_PER_ROW) - 1;
		
		// Wrap around rows
		if (curRow > maxRow)
			curRow = 0;
		if (curRow < 0)
			curRow = maxRow;
		
		// Calculate weeks in current row
		var weeksInRow = WEEKS_PER_ROW;
		if (curRow == maxRow)
		{
			var remainder = weeks.length % WEEKS_PER_ROW;
			if (remainder != 0)
				weeksInRow = remainder;
		}
		
		// Wrap around columns
		if (curCol >= weeksInRow)
			curCol = 0;
		if (curCol < 0)
			curCol = weeksInRow - 1;
		
		// Calculate actual week index
		curWeek = curRow * WEEKS_PER_ROW + curCol;
		
		// Safety check
		if (curWeek >= weeks.length)
			curWeek = weeks.length - 1;
		
		var bullShit:Int = 0;
		
		for (item in grpWeekText.members)
		{
			var itemRow = Math.floor(bullShit / WEEKS_PER_ROW);
			var itemCol = bullShit % WEEKS_PER_ROW;
			
			// Update horizontal position
			item.targetX = itemCol - curCol;
			
			// Update vertical position with smooth animation
			var targetYPos = (yellowBG.y + yellowBG.height + 80) + ((itemRow - curRow) * ROW_SPACING);
			FlxTween.tween(item, {y: targetYPos}, 0.2, {ease: FlxEase.expoOut});
			
			if (bullShit == curWeek && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxTween.color(yellowBG, 0.25, yellowBG.color, weeks[curWeek].weekColor);

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
		updateWeekBanner();
	}

	function updateWeekBanner()
	{
		for (i in 0...weekBanners.length)
		{
			if (![lastSelectedWeek, curWeek].contains(i))
			{
				weekBanners[i].alpha = 0;
			}
		}
		if (lastSelectedWeek < weekBanners.length)
		{
			FlxTween.tween(weekBanners[lastSelectedWeek], {alpha: 0}, 0.1);
		}
		if (curWeek < weekBanners.length)
		{
			FlxTween.tween(weekBanners[curWeek], {alpha: 1}, 0.1);
		}
	}

	function updateText()
	{
		txtTracklist.text = "";

		var stringThing:Array<String> = weeks[curWeek].songList;

		// Check if it's the master week and hasn't been played yet
		if (FlxG.save.data.masterWeekUnlocked && 
			curWeek == weeks.length - 1 && 
			!FlxG.save.data.hasPlayedMasterWeek)
		{
			stringThing = ['???', '???'];
		}

		txtTracklist.text = stringThing.join(' - ');

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, 1);
		#end
	}
}

class Week
{
	public var songList:Array<String>;
	public var weekName:String;
	public var weekColor:FlxColor;
	public var bannerName:String;

	public function new(songList:Array<String>, weekName:String, weekColor:FlxColor, bannerName:String)
	{
		this.songList = songList;
		this.weekName = weekName;
		this.weekColor = weekColor;
		this.bannerName = bannerName;
	}
}