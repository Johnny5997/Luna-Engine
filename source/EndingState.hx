package;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * shut up idiot im not bbpanzu hes a crazy!
 */
class EndingState extends MusicBeatState
{

	var _ending:String;
	var _song:String;
	
	public function new(ending:String,song:String) 
	{
		super();
		_ending = ending;
		_song = song;
	}
	
	override public function create():Void 
	{
		super.create();
		var end:FlxSprite = new FlxSprite(0, 0);
		end.loadGraphic(Paths.image("endings/" + _ending));
		FlxG.sound.playMusic(Paths.music(_song),1,true);
		add(end);
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true);	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.ENTER)
		{
			endIt();
		}
		
	}
	
	
	public function endIt()
	{
		trace("ENDING");
		FlxG.switchState(new StoryMenuState());
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
	}
	
}