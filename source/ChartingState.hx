package;

import openfl.system.System;
import sys.io.File;
import sys.FileSystem;
import flixel.FlxCamera;
import flixel.addons.ui.FlxUIText;
import haxe.zip.Writer;
import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

using StringTools;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	public var playClaps:Bool = false;

	public var snap:Int = 1;

	var UI_box:FlxUITabMenu;

	var curSection:Int = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = 'Dad Battle';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;
	var writingNotesText:FlxText;
	var highlight:FlxSprite;

	var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;

	var _song:SwagSong;

	var typingShit:FlxInputText;
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Float = 0;
	var gridBlackLine:FlxSprite;
	var vocals:FlxSound;

	var player2:Character = new Character(0,0, "dad");
	var player1:Boyfriend = new Boyfriend(0,0, "bf");

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;

	var check_stackActive:FlxUICheckBox;
	var stepperStackNum:FlxUINumericStepper;
	var stepperStackOffset:FlxUINumericStepper;
	var stepperStackSideOffset:FlxUINumericStepper;
	var stepperShrinkAmount:FlxUINumericStepper;

	private var lastNote:Note;
	var claps:Array<Note> = [];

	public var snapText:FlxText;
	
	var guitarPart:Bool = false;

	var noteTypes = ['normal', 'treats', 'phone-alt', 'shape'];
	var curNoteType:Int;

	var shagVoice:Bool;
	
	// Lil' Buddies
	var lilStage:FlxSprite;
	var lilBf:FlxSprite;
	var lilOpp:FlxSprite;
	
	// Note count text
	var noteCountTxt:FlxText;
	
	// Sound effects
	var hitsound:FlxSound;
	
	// Section copy variables
	var sectionToCopy:Int = 0;
	var notesCopied:Array<Dynamic>;

	override function create()
	{
		curSection = lastSection;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(MainMenuState.randomizeBG());
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = FlxColor.GRAY;
		add(bg);

		if (PlayState.SONG != null)
			_song = PlayState.SONG;
		else
		{
			_song = {
				song: 'Test',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				stage: 'stage',
				speed: 1,
				mania: 0,
				gf: "gf",
				validScore: false
			};
		}

		shagVoice = PlayState.shaggyVoice;
		
		// Initialize lil' buddies
		lilStage = new FlxSprite(1020, 432).loadGraphic(Paths.image('chartEditor/lilStage'));
		lilStage.scrollFactor.set();
		add(lilStage);

		lilBf = new FlxSprite(1020, 432).loadGraphic(Paths.image('chartEditor/lilBf'), true, 300, 256);
		lilBf.animation.add("idle", [0, 1], 30, true);
		lilBf.animation.add("0", [3, 4, 5], 30, false);
		lilBf.animation.add("1", [6, 7, 8], 30, false);
		lilBf.animation.add("2", [9, 10, 11], 30, false);
		lilBf.animation.add("3", [12, 13, 14], 30, false);
		lilBf.animation.play("idle");
		lilBf.animation.finishCallback = function(name:String){
			lilBf.animation.play(name, true, false, lilBf.animation.getByName(name).numFrames - 2);
		}
		lilBf.scrollFactor.set();
		add(lilBf);

		lilOpp = new FlxSprite(1020, 432).loadGraphic(Paths.image('chartEditor/lilOpp'), true, 300, 256);
		lilOpp.animation.add("idle", [0, 1], 30, true);
		lilOpp.animation.add("0", [3, 4, 5], 30, false);
		lilOpp.animation.add("1", [6, 7, 8], 30, false);
		lilOpp.animation.add("2", [9, 10, 11], 30, false);
		lilOpp.animation.add("3", [12, 13, 14], 30, false);
		lilOpp.animation.play("idle");
		lilOpp.animation.finishCallback = function(name:String){
			lilOpp.animation.play(name, true, false, lilOpp.animation.getByName(name).numFrames - 2);
		}
		lilOpp.scrollFactor.set();
		add(lilOpp);
		
		// Hide by default - will be toggled in settings
		lilBf.visible = false;
		lilOpp.visible = false;
		lilStage.visible = false;

		// Initialize hitsound
		hitsound = FlxG.sound.load(Paths.sound('hitsounds/osu!mania'));
		hitsound.volume = 1;

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
		add(gridBG);

		snapText = new FlxText(60,10,0,"", 14);
		snapText.scrollFactor.set();

		gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		FlxG.mouse.visible = true;
		FlxG.save.bind('funkin', 'ninjamuffin99');

		tempBpm = _song.bpm;

		addSection();

		updateGrid();

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		leftIcon = new HealthIcon(_song.player1);
		rightIcon = new HealthIcon(_song.player2);
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);

		leftIcon.setPosition(0, -100);
		rightIcon.setPosition(gridBG.width / 2, -100);

		bpmTxt = new FlxText(1080, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);
		
		// Add note count text
		noteCountTxt = new FlxText(0, FlxG.height - 30, 0, "", 16);
		noteCountTxt.scrollFactor.set();
		noteCountTxt.alignment = "right";
		noteCountTxt.x = FlxG.width - noteCountTxt.width - 250; // moved 20px more left
		add(noteCountTxt);

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 4);
		add(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		var tabs = [
			{name: "Song", label: 'Song Data'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note Data'},
			{name: "Note Spamming", label: 'Spamming'},
			{name: "Assets", label: 'Assets'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2 + 80;
		UI_box.y = 20;
		add(UI_box);

		addSongUI();
		addSectionUI();
		addNoteUI();
		addNoteStackingUI();

		add(curRenderedNotes);
		add(curRenderedSustains);
		add(snapText);

		super.create();
	}

	function addSongUI():Void
	{
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var check_voices = new FlxUICheckBox(10, 25, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		check_voices.callback = function()
		{
			_song.needsVoices = check_voices.checked;
			trace('CHECKED!');
		};

		var check_mute_inst = new FlxUICheckBox(10, 200, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_inst.checked)
				vol = 0;

			FlxG.sound.music.volume = vol;
		};

		var saveButton:FlxButton = new FlxButton(110, 8, "Save", function()
		{
			saveLevel();
		});

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function()
		{
			loadSong(_song.song);
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function()
		{
			loadJson(_song.song.toLowerCase());
		});

		var restart = new FlxButton(10, 140, "Reset Chart", function()
		{
			for (ii in 0..._song.notes.length)
			{
				for (i in 0..._song.notes[ii].sectionNotes.length)
				{
					_song.notes[ii].sectionNotes = [];
				}
			}
			resetSection(true);
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);
		
		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 65, 0.1, 1, 1.0, 5000.0, 1);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var stepperBPMLabel = new FlxText(74,65,'BPM');
		
		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 80, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperSpeedLabel = new FlxText(74,80,'Scroll Speed');
		
		var stepperMania:FlxUINumericStepper = new FlxUINumericStepper(160, 95, 1, 0, 0, 5, 1);
		stepperMania.value = _song.mania;
		stepperMania.name = 'song_mania';

		var stepperManiaLabel = new FlxText(224,95,'Mania');

		var stepperVocalVol:FlxUINumericStepper = new FlxUINumericStepper(10, 95, 0.1, 1, 0.1, 10, 1);
		stepperVocalVol.value = vocals.volume;
		stepperVocalVol.name = 'song_vocalvol';

		var stepperVocalVolLabel = new FlxText(74, 95, 'Vocal Volume');
		
		var stepperSongVol:FlxUINumericStepper = new FlxUINumericStepper(10, 110, 0.1, 1, 0.1, 10, 1);
		stepperSongVol.value = FlxG.sound.music.volume;
		stepperSongVol.name = 'song_instvol';

		var hitsounds = new FlxUICheckBox(10, stepperSongVol.y + 60, null, null, "Play hitsounds", 100);
		hitsounds.checked = false;
		hitsounds.callback = function()
		{
			playClaps = hitsounds.checked;
		};
		
		var lilBuddiesCheck = new FlxUICheckBox(10, hitsounds.y + 60, null, null, "Lil' Buddies", 100);
		lilBuddiesCheck.checked = false;
		lilBuddiesCheck.callback = function()
		{
			lilBf.visible = lilBuddiesCheck.checked;
			lilOpp.visible = lilBuddiesCheck.checked;
			lilStage.visible = lilBuddiesCheck.checked;
		};

		var stepperSongVolLabel = new FlxText(74, 110, 'Instrumental Volume');

		var shiftNoteDialLabel = new FlxText(10, 245, 'Shift Note FWD by (Section)');
		var stepperShiftNoteDial:FlxUINumericStepper = new FlxUINumericStepper(10, 260, 1, 0, -1000, 1000, 0);
		stepperShiftNoteDial.name = 'song_shiftnote';
		var shiftNoteDialLabel2 = new FlxText(10, 275, 'Shift Note FWD by (Step)');
		var stepperShiftNoteDialstep:FlxUINumericStepper = new FlxUINumericStepper(10, 290, 1, 0, -1000, 1000, 0);
		stepperShiftNoteDialstep.name = 'song_shiftnotems';
		var shiftNoteDialLabel3 = new FlxText(10, 305, 'Shift Note FWD by (ms)');
		var stepperShiftNoteDialms:FlxUINumericStepper = new FlxUINumericStepper(10, 320, 1, 0, -1000, 1000, 2);
		stepperShiftNoteDialms.name = 'song_shiftnotems';

		var shiftNoteButton:FlxButton = new FlxButton(10, 335, "Shift", function()
		{
			shiftNotes(Std.int(stepperShiftNoteDial.value),Std.int(stepperShiftNoteDialstep.value),Std.int(stepperShiftNoteDialms.value));
		});

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var stages:Array<String> = CoolUtil.coolTextFile(Paths.txt('stageList'));

		var player1DropDown = new FlxUIDropDownMenu(10, 5, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player1 = characters[Std.parseInt(character)];
		});
		player1DropDown.selectedLabel = _song.player1;

		var player1Label = new FlxText(10,25,64,'Player 1');

		var player2DropDown = new FlxUIDropDownMenu(140, 5, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
		});
		player2DropDown.selectedLabel = _song.player2;

		var player2Label = new FlxText(140,25,64,'Player 2');

		var stageDropDown = new FlxUIDropDownMenu(140, 50, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stage:String)
			{
				_song.stage = stages[Std.parseInt(stage)];
			});
		stageDropDown.selectedLabel = _song.stage;
		
		var stageLabel = new FlxText(140,70,64,'Stage');

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);
		tab_group_song.add(restart);
		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperBPMLabel);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(stepperSpeedLabel);
		tab_group_song.add(stepperMania);
		tab_group_song.add(stepperManiaLabel);
		tab_group_song.add(stepperVocalVol);
		tab_group_song.add(stepperVocalVolLabel);
		tab_group_song.add(stepperSongVol);
		tab_group_song.add(stepperSongVolLabel);
		tab_group_song.add(shiftNoteDialLabel);
		tab_group_song.add(stepperShiftNoteDial);
		tab_group_song.add(shiftNoteDialLabel2);
		tab_group_song.add(stepperShiftNoteDialstep);
		tab_group_song.add(shiftNoteDialLabel3);
		tab_group_song.add(stepperShiftNoteDialms);
		tab_group_song.add(shiftNoteButton);
		tab_group_song.add(hitsounds);
		tab_group_song.add(lilBuddiesCheck);

		var tab_group_assets = new FlxUI(null, UI_box);
		tab_group_assets.name = "Assets";
		tab_group_assets.add(stageDropDown);
		tab_group_assets.add(stageLabel);
		tab_group_assets.add(player1DropDown);
		tab_group_assets.add(player2DropDown);
		tab_group_assets.add(player1Label);
		tab_group_assets.add(player2Label);

		UI_box.addGroup(tab_group_song);
		UI_box.addGroup(tab_group_assets);
		UI_box.scrollFactor.set();

		FlxG.camera.follow(strumLine);
	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";

		var stepperLengthLabel = new FlxText(74,10,'Section Length (in steps)');

		stepperSectionBPM = new FlxUINumericStepper(10, 80, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 132, 1, 1, -999, 999, 0);
		var stepperCopyLabel = new FlxText(174,132,'sections back');

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last", function()
		{
			copySection(Std.int(stepperCopy.value));
		});

		// Three separate clear buttons
		var clearP1Button:FlxButton = new FlxButton(10, 150, "Clear P1", clearSectionP1);
	
		var clearP2Button:FlxButton = new FlxButton(10, 170, "Clear P2", clearSectionP2);
	
		var clearAllButton:FlxButton = new FlxButton(10, 190, "Clear All", clearSection);

		var swapSection:FlxButton = new FlxButton(10, 210, "Swap Section", function()
		{
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note:Array<Dynamic> = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + Main.keyAmmo[_song.mania]) % (Main.keyAmmo[_song.mania] * 2);
				_song.notes[curSection].sectionNotes[i] = note;
			}
			updateGrid();
		});
	
		// Add duet button
		var duetButton:FlxButton = new FlxButton(10, swapSection.y + 30, "Duet Notes", function()
		{
			var duetNotes:Array<Array<Dynamic>> = [];
			for (note in _song.notes[curSection].sectionNotes)
			{
				var boob = note[1];
				if (boob > 3){
					boob -= 4;
				}else{
					boob += 4;
				}

				var copiedNote:Array<Dynamic> = [note[0], boob, note[2], note[3]];
				duetNotes.push(copiedNote);
			}

			for (i in duetNotes){
				_song.notes[curSection].sectionNotes.push(i);
			}

			updateGrid();
			FlxG.sound.play(Paths.sound('click'));
		});
	
		// Add mirror button
		var mirrorButton:FlxButton = new FlxButton(duetButton.x + 100, duetButton.y, "Mirror Notes", function()
		{
			for (note in _song.notes[curSection].sectionNotes)
			{
				var boob = note[1] % 4;
				boob = 3 - boob;
				if (note[1] > 3) boob += 4;

				note[1] = boob;
			}

			updateGrid();
			FlxG.sound.play(Paths.sound('click'));
		});
	
		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Camera Points to P1?", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;

		check_altAnim = new FlxUICheckBox(10, 400, null, null, "Alternate Animation", 100);
		check_altAnim.name = 'check_altAnim';

		check_changeBPM = new FlxUICheckBox(10, 60, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperLengthLabel);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(stepperCopyLabel);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearP1Button);
		tab_group_section.add(clearP2Button);
		tab_group_section.add(clearAllButton);
		tab_group_section.add(swapSection);
		tab_group_section.add(duetButton);
		tab_group_section.add(mirrorButton);

		UI_box.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;
	var tab_group_note:FlxUI;
	
	function addNoteUI():Void
	{
		tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		writingNotesText = new FlxUIText(20,100, 0, "");
		writingNotesText.setFormat("Arial",20,FlxColor.WHITE,FlxTextAlign.LEFT,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * _song.notes[curSection].lengthInSteps * 4);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var stepperSusLengthLabel = new FlxText(74,10,'Note Sustain Length');

		var applyLength:FlxButton = new FlxButton(10, 100, 'Apply Data');

		// Add note type dropdown
		var displayNameList:Array<String> = [];
		for (i in 0...noteTypes.length) {
			displayNameList.push((i + 1) + '. ' + noteTypes[i]);
		}

		var noteTypeDropDown = new FlxUIDropDownMenu(10, 50, FlxUIDropDownMenu.makeStrIdLabelArray(displayNameList, true), function(noteType:String)
		{
			curNoteType = Std.parseInt(noteType);
		});
		noteTypeDropDown.selectedLabel = '1. ' + noteTypes[0];
		
		var noteTypeLabel = new FlxText(10,35,0,'Note Type');

		tab_group_note.add(stepperSusLength);
		tab_group_note.add(stepperSusLengthLabel);
		tab_group_note.add(applyLength);
		tab_group_note.add(noteTypeLabel);
		tab_group_note.add(noteTypeDropDown);

		UI_box.addGroup(tab_group_note);
	}

	function addNoteStackingUI():Void
	{
		var tab_group_stacking = new FlxUI(null, UI_box);
		tab_group_stacking.name = 'Note Spamming';

		check_stackActive = new FlxUICheckBox(10, 10, null, null, "Enable EZ Spam Mode", 100);
		check_stackActive.name = 'check_stackActive';

		stepperStackNum = new FlxUINumericStepper(10, 30, 1, 1, 0, 999999, 4);
		stepperStackNum.name = 'stack_count';

		var doubleSpamNum:FlxButton = new FlxButton(stepperStackNum.x, stepperStackNum.y + 20, 'x2 Amount', function()
		{
			stepperStackNum.value *= 2;
		});
		doubleSpamNum.setGraphicSize(Std.int(doubleSpamNum.width), Std.int(doubleSpamNum.height));
		doubleSpamNum.color = FlxColor.GREEN;

		var halfSpamNum:FlxButton = new FlxButton(doubleSpamNum.x + doubleSpamNum.width + 20, doubleSpamNum.y, 'x0.5 Amount', function()
		{
			stepperStackNum.value /= 2;
		});
		halfSpamNum.setGraphicSize(Std.int(halfSpamNum.width), Std.int(halfSpamNum.height));
		halfSpamNum.color = FlxColor.RED;

		stepperStackOffset = new FlxUINumericStepper(10, 80, 1, 1, 0, 999999, 4);
		stepperStackOffset.name = 'stack_offset';

		var doubleSpamMult:FlxButton = new FlxButton(stepperStackOffset.x, stepperStackOffset.y + 20, 'x2 SM', function()
		{
			stepperStackOffset.value *= 2;
		});
		doubleSpamMult.color = FlxColor.GREEN;

		var halfSpamMult:FlxButton = new FlxButton(doubleSpamMult.x + doubleSpamMult.width + 20, doubleSpamMult.y, 'x0.5 SM', function()
		{
			stepperStackOffset.value /= 2;
		});
		halfSpamMult.setGraphicSize(Std.int(halfSpamMult.width), Std.int(halfSpamMult.height));
		halfSpamMult.color = FlxColor.RED;

		stepperStackSideOffset = new FlxUINumericStepper(10, 140, 1, 0, -9999, 9999);
		stepperStackSideOffset.name = 'stack_sideways';

		stepperShrinkAmount = new FlxUINumericStepper(10, stepperStackSideOffset.y + 30, 1, 1, 0, 8192, 4);
		stepperShrinkAmount.name = 'shrinker_amount';

		var doubleShrinker:FlxButton = new FlxButton(stepperShrinkAmount.x, stepperShrinkAmount.y + 20, 'x2 SH', function()
		{
			stepperShrinkAmount.value *= 2;
		});
		doubleShrinker.color = FlxColor.GREEN;

		var halfShrinker:FlxButton = new FlxButton(doubleShrinker.x + doubleShrinker.width + 20, doubleShrinker.y, 'x0.5 SH', function()
		{
			stepperShrinkAmount.value /= 2;
		});
		halfShrinker.setGraphicSize(Std.int(halfShrinker.width), Std.int(halfShrinker.height));
		halfShrinker.color = FlxColor.RED;

		var shrinkNotesButton:FlxButton = new FlxButton(10, doubleShrinker.y + 30, "Stretch Notes", function()
		{
			var minimumTime:Float = sectionStartTime();
			var sectionEndTime:Float = sectionStartTime() + (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps);
			
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note:Array<Dynamic> = _song.notes[curSection].sectionNotes[i];
				if (note[2] > 0) note[2] *= stepperShrinkAmount.value;
				var originalStartTime:Float = note[0];
				originalStartTime = originalStartTime - sectionStartTime();

				var stretchedStartTime:Float = originalStartTime * stepperShrinkAmount.value;

				var newStartTime:Float = sectionStartTime() + stretchedStartTime;

				note[0] = Math.max(newStartTime, minimumTime);
				if (note[0] < minimumTime) note[0] = minimumTime;
				_song.notes[curSection].sectionNotes[i] = note;
			}
			updateGrid();
		});

		var stepperShiftSteps:FlxUINumericStepper = new FlxUINumericStepper(10, shrinkNotesButton.y + 30, 1, 1, -8192, 8192, 4);
		stepperShiftSteps.name = 'shifter_amount';

		var shiftNotesButton:FlxButton = new FlxButton(10, stepperShiftSteps.y + 20, "Shift Notes", function()
		{
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				_song.notes[curSection].sectionNotes[i][0] += (stepperShiftSteps.value) * (15000/Conductor.bpm);
			}
			updateGrid();
		});
		shiftNotesButton.setGraphicSize(Std.int(shiftNotesButton.width), Std.int(shiftNotesButton.height));

		var stepperDuplicateAmount:FlxUINumericStepper = new FlxUINumericStepper(10, shiftNotesButton.y + 30, 1, 1, 0, 32, 4);
		stepperDuplicateAmount.name = 'duplicater_amount';

		var dupeNotesButton:FlxButton = new FlxButton(10, stepperDuplicateAmount.y + 20, "Duplicate Notes", function()
		{
			var copiedNotes:Array<Dynamic> = [];
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note:Array<Dynamic> = _song.notes[curSection].sectionNotes[i];
				copiedNotes.push(note);
			}
			for (_i in 1...Std.int(stepperDuplicateAmount.value)+1)
			{
				for (i in 0...copiedNotes.length)
				{
					final copiedNote:Array<Dynamic> = [copiedNotes[i][0], copiedNotes[i][1], copiedNotes[i][2], copiedNotes[i][3]];
					copiedNote[0] += (stepperShiftSteps.value * _i) * (15000/Conductor.bpm);
					_song.notes[curSection].sectionNotes.push(copiedNote);
				}
			}
			if (_song.notes[curSection].sectionNotes.length <= 30000)
				updateGrid();
			else
				changeSection(curSection + 1);
		});
		dupeNotesButton.setGraphicSize(Std.int(dupeNotesButton.width), Std.int(dupeNotesButton.height));

		tab_group_stacking.add(check_stackActive);
		tab_group_stacking.add(stepperStackNum);
		tab_group_stacking.add(stepperStackOffset);
		tab_group_stacking.add(stepperStackSideOffset);
		tab_group_stacking.add(stepperShrinkAmount);
		tab_group_stacking.add(stepperShiftSteps);
		tab_group_stacking.add(stepperDuplicateAmount);
		tab_group_stacking.add(doubleSpamNum);
		tab_group_stacking.add(halfSpamNum);
		tab_group_stacking.add(doubleSpamMult);
		tab_group_stacking.add(halfSpamMult);
		tab_group_stacking.add(doubleShrinker);
		tab_group_stacking.add(halfShrinker);
		tab_group_stacking.add(shrinkNotesButton);
		tab_group_stacking.add(shiftNotesButton);
		tab_group_stacking.add(dupeNotesButton);

		tab_group_stacking.add(new FlxText(100, 30, 0, "Spam Count"));
		tab_group_stacking.add(new FlxText(100, 80, 0, "Spam Multiplier"));
		tab_group_stacking.add(new FlxText(100, 140, 0, "Spam Scroll Amount"));
		tab_group_stacking.add(new FlxText(100, stepperShrinkAmount.y, 0, "Stretch Amount"));
		tab_group_stacking.add(new FlxText(100, stepperShiftSteps.y, 0, "Steps to Shift By"));
		tab_group_stacking.add(new FlxText(100, stepperDuplicateAmount.y, 0, "Amount of Duplicates"));

		UI_box.addGroup(tab_group_stacking);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		FlxG.sound.playMusic(Paths.inst(daSong), 0.6);

		vocals = new FlxSound().loadEmbedded(Paths.voices(daSong, shagVoice ? "Shaggy" : ""));
		FlxG.sound.list.add(vocals);

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.onComplete = function()
		{
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
		{
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Camera Points to P1?':
					_song.notes[curSection].mustHitSection = check.checked;
				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alternate Animation":
					_song.notes[curSection].altAnim = check.checked;
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			if (wname == 'section_length')
			{
				if (nums.value <= 4)
					nums.value = 4;
				_song.notes[curSection].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				if (nums.value <= 0)
					nums.value = 0;
				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				if (nums.value <= 0)
					nums.value = 1;
				tempBpm = Std.int(nums.value);
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(Std.int(nums.value));
			}
			else if (wname == 'song_mania')
			{
				_song.mania = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'note_susLength')
			{
				if (curSelectedNote == null)
					return;

				if (nums.value <= 0)
					nums.value = 0;
				curSelectedNote[2] = nums.value;
				updateGrid();
			}
			else if (wname == 'section_bpm')
			{
				if (nums.value <= 0.1)
					nums.value = 0.1;
				_song.notes[curSection].bpm = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_vocalvol')
			{
				if (nums.value <= 0.1)
					nums.value = 0.1;
				vocals.volume = nums.value;
			}
			else if (wname == 'song_instvol')
			{
				if (nums.value <= 0.1)
					nums.value = 0.1;
				FlxG.sound.music.volume = nums.value;
			}
		}
	}

	var updatedSection:Bool = false;

	function stepStartTime(step):Float
	{
		return _song.bpm / (step / 4) / 60;
	}

	function sectionStartTime():Float
	{
		var daBPM:Float = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection)
		{
			if (_song.notes[i].changeBPM)
			{
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	var writingNotes:Bool = false;
	var doSnapShit:Bool = true;

	function resetBuddies() {
		lilBf.animation.play("idle");
		lilOpp.animation.play("idle");
	}

	function updateNoteCount() {
		var totalNotes:Int = 0;
		for (section in _song.notes) {
			if (section != null && section.sectionNotes != null) {
				totalNotes += section.sectionNotes.length;
			}
		}
		
		noteCountTxt.text = 'Notes: $totalNotes | Rendered: ${curRenderedNotes.length}';
	}

	override function update(elapsed:Float)
	{
		updateHeads();

		snapText.text = "Snap: 1/" + snap + " (" + (doSnapShit ? "Control to disable" : "Snap Disabled, Control to renable") + ")";

		curStep = recalculateSteps();

		if (gridBG.width != GRID_SIZE * Main.keyAmmo[_song.mania] * 2)
		{
			remove(gridBG);
			gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * Main.keyAmmo[_song.mania] * 2, GRID_SIZE * 16);
			add(gridBG);
			gridBlackLine.x = gridBG.x + gridBG.width / 2;
			leftIcon.setPosition(0, -100);
			rightIcon.setPosition(gridBG.width / 2, -100);
		}

		if (FlxG.keys.justPressed.CONTROL)
			doSnapShit = !doSnapShit;

		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingShit.text;

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));
		
		// Update lil buddies
		if (lilBf.visible || lilOpp.visible) {
			curRenderedNotes.forEach(function(note:Note) {
				if (note.strumTime <= Conductor.songPosition && note.strumTime > Conductor.songPosition - 100) {
					var data:Int = note.noteData % 4;
					if (note.mustPress) {
						lilBf.animation.play("" + data, true);
					} else {
						lilOpp.animation.play("" + data, true);
					}
				}
			});
		}
		
		if (playClaps)
		{
			curRenderedNotes.forEach(function(note:Note)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.overlap(strumLine, note, function(_, _)
					{
						if(!claps.contains(note))
						{
							claps.push(note);
							FlxG.sound.play(Paths.sound('note_click', 'shared'));
						}
					});
				}
			});
		}

		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1))
		{
			trace(curStep);
			trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSection + 1] == null)
			{
				addSection();
			}

			changeSection(curSection + 1, false);
		}

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(curRenderedNotes))
			{
				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note))
					{
						if (FlxG.keys.pressed.CONTROL)
						{
							selectNote(note);
							FlxG.sound.play(Paths.sound('selectNote'), 0.7);
						}
						else
						{
							deleteNote(note);
							FlxG.sound.play(Paths.sound('removeNote'), 0.7);
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > gridBG.x
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
				{
					FlxG.log.add('added note');
					addNote();
					FlxG.sound.play(Paths.sound('addedNote'), 0.7);
				}
			}
		}

		if (FlxG.mouse.x > gridBG.x
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			if (FlxG.keys.pressed.SHIFT)
				dummyArrow.y = FlxG.mouse.y;
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			lastSection = curSection;

			FlxG.sound.play(Paths.sound('cancelMenu'));

			PlayState.SONG = _song;
			FlxG.sound.music.stop();
			vocals.stop();
			
			LoadingState.loadAndSwitchState(new PlayState());
		}

		if (FlxG.keys.justPressed.E)
		{
			changeNoteSustain(Conductor.stepCrochet);
		}
		if (FlxG.keys.justPressed.Q)
		{
			changeNoteSustain(-Conductor.stepCrochet);
		}

		if (FlxG.keys.justPressed.TAB)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				UI_box.selected_tab -= 1;
				if (UI_box.selected_tab < 0)
					UI_box.selected_tab = 2;
			}
			else
			{
				UI_box.selected_tab += 1;
				if (UI_box.selected_tab >= 3)
					UI_box.selected_tab = 0;
			}
		}

		if (!typingShit.hasFocus)
		{
			if (FlxG.keys.pressed.CONTROL)
			{
				if (FlxG.keys.justPressed.Z && lastNote != null)
				{
					trace(curRenderedNotes.members.contains(lastNote) ? "delete note" : "add note");
					if (curRenderedNotes.members.contains(lastNote))
						deleteNote(lastNote);
					else 
						addNote(lastNote);
				}
			}

			var shiftThing:Int = 1;
			if (FlxG.keys.pressed.SHIFT)
				shiftThing = 4;
			if (!FlxG.keys.pressed.CONTROL)
			{
				if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
					changeSection(curSection + shiftThing);
				if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
					changeSection(curSection - shiftThing);
			}	
			if (FlxG.keys.justPressed.SPACE)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.pause();
					vocals.pause();
					claps.splice(0, claps.length);
					resetBuddies();
				}
				else
				{
					vocals.play();
					FlxG.sound.music.play();
				}
			}

			if (FlxG.keys.justPressed.R)
			{
				if (FlxG.keys.pressed.SHIFT)
					resetSection(true);
				else
					resetSection();
			}

			if (FlxG.sound.music.time < 0 || curStep < 0)
				FlxG.sound.music.time = 0;

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				claps.splice(0, claps.length);

				var stepMs = curStep * Conductor.stepCrochet;

				if (doSnapShit)
					FlxG.sound.music.time = stepMs - (FlxG.mouse.wheel * Conductor.stepCrochet / snap);
				else
					FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);

				vocals.time = FlxG.sound.music.time;
			}

			if (!FlxG.keys.pressed.SHIFT)
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();
					claps.splice(0, claps.length);

					var daTime:Float = 700 * FlxG.elapsed;

					if (FlxG.keys.pressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
			else
			{
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = Conductor.stepCrochet * 2;

					if (FlxG.keys.justPressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
		}

		_song.bpm = tempBpm;

		bpmTxt.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ " / "
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\nSection: "
			+ curSection 
			+ "\nCurBeat: " 
			+ curBeat
			+ "\nCurStep: " 
			+ curStep
			+ "\n\nCurrent Note Type: \n"
			+ noteTypes[curNoteType];

		updateNoteCount();

		super.update(elapsed);
	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	override function beatHit() 
	{
		super.beatHit();
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSection = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateCurStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		trace('changing section' + sec);

		if (_song.notes[sec] != null)
		{
			curSection = sec;

			updateGrid();

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateCurStep();
			}

			updateGrid();
			updateSectionUI();
		}
		else
			trace('bro wtf I AM NULL');
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2], note[3]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		updateGrid();
	}

	function pasteSection()
	{
		if(notesCopied == null || notesCopied.length < 1)
		{
			return;
		}

		var addToTime:Float = Conductor.stepCrochet * (_song.notes[curSection].lengthInSteps * (curSection - sectionToCopy));

		for (note in notesCopied)
		{
			var copiedNote:Array<Dynamic> = [];
			var newStrumTime:Float = note[0] + addToTime;
			copiedNote = [newStrumTime, note[1], note[2], note[3]];
			_song.notes[curSection].sectionNotes.push(copiedNote);
		}
		
		updateGrid();
	}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSection];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;
	}

	function updateHeads():Void
	{
		if (check_mustHitSection.checked)
		{
			leftIcon.changeIcon(_song.player1);
			rightIcon.changeIcon(_song.player2);
		}
		else
		{
			leftIcon.changeIcon(_song.player2);
			rightIcon.changeIcon(_song.player1);
		}
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null)
			stepperSusLength.value = curSelectedNote[2];
	}

	function updateGrid():Void
	{
		guitarPart = (_song.song.toLowerCase() == 'shredder' && (curSection >= 64 && curSection < 80));
		
		var gridWidth = guitarPart ? 5 + Main.keyAmmo[_song.mania] : Main.keyAmmo[_song.mania] * 2;
		remove(gridBG);
		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * gridWidth, GRID_SIZE * _song.notes[curSection].lengthInSteps);
		add(gridBG);

		if (gridBG != null)
		{
			remove(gridBlackLine);
			gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2 + (guitarPart ? GRID_SIZE / 2 : 0)).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
			add(gridBlackLine);
		}
		
		while (curRenderedNotes.members.length > 0)
		{
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0)
		{
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}

		var sectionInfo:Array<Dynamic> = _song.notes[curSection].sectionNotes;

		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSection].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
		{
			var daBPM:Float = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		for (i in sectionInfo)
		{
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];
			var noteType = i[3];

			var note:Note = new Note(daStrumTime, daNoteInfo % (guitarPart ? 5 : Main.keyAmmo[_song.mania]), null, false, true, noteType, true, guitarPart);
			note.sustainLength = daSus;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor((daNoteInfo % Main.dataJump[_song.mania]) * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));
			
			note.mustPress = _song.notes[curSection].mustHitSection;
			if(i[1] > Main.keyAmmo[_song.mania] - 1) note.mustPress = !note.mustPress;

			if (curSelectedNote != null)
				if (curSelectedNote[0] == note.strumTime)
					lastNote = note;

			curRenderedNotes.add(note);

			if (daSus > 0)
			{
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2),
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * _song.notes[curSection].lengthInSteps, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}
	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false
		};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{
		var swagNum:Int = 0;

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i.strumTime == note.strumTime && i.noteData % (guitarPart ? 5 : Main.keyAmmo[_song.mania]) == note.noteData)
			{
				curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];
			}

			swagNum += 1;
		}

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void
	{
		var noteDataToCheck:Int = note.noteData;
		if(noteDataToCheck > -1 && note.mustPress != _song.notes[curSection].mustHitSection) noteDataToCheck += Main.keyAmmo[_song.mania];

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i[0] == note.strumTime && i[1] == noteDataToCheck)
			{
				if(i == curSelectedNote) curSelectedNote = null;
				_song.notes[curSection].sectionNotes.remove(i);
				break;
			}
		}

		updateGrid();
	}

	function clearSection():Void
	{
		_song.notes[curSection].sectionNotes = [];

		updateGrid();
	}

	function clearSectionP1():Void
	{
		var notesToRemove:Array<Array<Dynamic>> = [];
	
		for (note in _song.notes[curSection].sectionNotes)
		{
			var noteData = note[1];
			var isP1Note = _song.notes[curSection].mustHitSection ? (noteData < Main.keyAmmo[_song.mania]) : (noteData >= Main.keyAmmo[_song.mania]);
		
			if (isP1Note)
			{
				notesToRemove.push(note);
			}
		}
	
		for (note in notesToRemove)
		{
			_song.notes[curSection].sectionNotes.remove(note);
		}

		updateGrid();
	}

	function clearSectionP2():Void
	{
		var notesToRemove:Array<Array<Dynamic>> = [];
	
		for (note in _song.notes[curSection].sectionNotes)
		{
			var noteData = note[1];
			var isP2Note = _song.notes[curSection].mustHitSection ? (noteData >= Main.keyAmmo[_song.mania]) : (noteData < Main.keyAmmo[_song.mania]);
		
			if (isP2Note)
			{
				notesToRemove.push(note);
			}
		}
	
		for (note in notesToRemove)
		{
			_song.notes[curSection].sectionNotes.remove(note);
		}

		updateGrid();
	}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
		{
			_song.notes[daSection].sectionNotes = [];
		}

		updateGrid();
	}

	private function newSection(lengthInSteps:Int = 16, mustHitSection:Bool = false, altAnim:Bool = true):SwagSection
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: mustHitSection,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: altAnim
		};

		return sec;
	}

	function shiftNotes(measure:Int = 0, step:Int = 0, ms:Int = 0):Void
	{
		var newSong = [];

		var millisecadd = (((measure * 4) + step / 4) * (60000 / _song.bpm)) + ms;
		var totaladdsection = Std.int((millisecadd / (60000 / _song.bpm) / 4));
		trace(millisecadd, totaladdsection);
		if (millisecadd > 0)
		{
			for (i in 0...totaladdsection)
			{
				newSong.unshift(newSection());
			}
		}
		for (daSection1 in 0..._song.notes.length)
		{
			newSong.push(newSection(16, _song.notes[daSection1].mustHitSection, _song.notes[daSection1].altAnim));
		}

		for (daSection in 0...(_song.notes.length))
		{
			var aimtosetsection = daSection + Std.int((totaladdsection));
			if (aimtosetsection < 0)
				aimtosetsection = 0;
			newSong[aimtosetsection].mustHitSection = _song.notes[daSection].mustHitSection;
			newSong[aimtosetsection].altAnim = _song.notes[daSection].altAnim;
			
			for (daNote in 0...(_song.notes[daSection].sectionNotes.length))
			{
				var newtiming = _song.notes[daSection].sectionNotes[daNote][0] + millisecadd;
				if (newtiming < 0)
				{
					newtiming = 0;
				}
				var futureSection = Math.floor(newtiming / 4 / (60000 / _song.bpm));
				_song.notes[daSection].sectionNotes[daNote][0] = newtiming;
				newSong[futureSection].sectionNotes.push(_song.notes[daSection].sectionNotes[daNote]);
			}
		}
		
		_song.notes = newSong;
		updateGrid();
		updateSectionUI();
		updateNoteUI();
	}

	private function addNote(?n:Note):Void
	{
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteSus = 0;
		var noteStyle = noteTypes[curNoteType];

		if (n != null)
			_song.notes[curSection].sectionNotes.push([n.strumTime, n.noteData, n.sustainLength, n.noteStyle]);
		else
			_song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus, noteStyle]);

		var thingy = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		curSelectedNote = thingy;

		if (check_stackActive != null && check_stackActive.checked)
		{
			var addCount:Float = stepperStackNum.value * stepperStackOffset.value - 1;
			for(i in 0...Std.int(addCount)) {
				var spamNoteStrum = noteStrum + (15000/Conductor.bpm)/stepperStackOffset.value * (i + 1);
				var spamNoteData = noteData + Math.floor(stepperStackSideOffset.value * (i + 1));
				_song.notes[curSection].sectionNotes.push([spamNoteStrum, spamNoteData, noteSus, noteStyle]);
			}
		}

		updateGrid();
		updateNoteUI();

		autosaveSong();	
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}	

	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes)
		{
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	public static function hahaFunnyRecursed()
	{
		var songList = FileSystem.readDirectory('assets/songs');
		for (song in FileSystem.readDirectory('assets/songs'))
		{
			var removeSong = false;

			var songCheckThing:Array<Dynamic> = [
				['cheating', FlxG.save.data.hasPlayedMasterWeek],
				['unfairness', FlxG.save.data.hasPlayedMasterWeek],
				['darkness', FlxG.save.data.exploitationFound],
				['recursed', FlxG.save.data.recursedUnlocked],
				['entity', FlxG.save.data.recursedUnlocked],
			];
			for (songCheck in songCheckThing)
			{
				if (song == songCheck[0] && !songCheck[1])
				{
					removeSong = true;
				}
			}
			if (removeSong) songList.remove(song);
		}
		var randomSong = songList[FlxG.random.int(0, songList.length - 1)];
		PlayState.SONG = Song.loadFromJson(randomSong);

		PlayState.characteroverride = "none";
		PlayState.formoverride = "none";
		PlayState.recursedStaticWeek = true;

		FlxG.switchState(new PlayState());
	}

	function loadJson(song:String):Void
	{
		PlayState.SONG = Song.loadFromJson(song.toLowerCase());
		FlxG.resetState();
	}

	function loadAutosave():Void
	{
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		LoadingState.loadAndSwitchState(new ChartingState());
	}

	function autosaveSong():Void
	{
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});
		FlxG.save.flush();
	}

	private function saveLevel()
	{
		var json = {
			"song": _song
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + ".json");
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}