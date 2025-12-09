package;
#if sys
import sys.io.File;
import sys.io.Process;
#end
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * scary!!!
 */
class ImageState extends FlxState //why did this extend music beat state?
{
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
        FlxG.sound.play(Paths.sound("oooyoufuckedupboy", "preload"), 1, false);
		var spooky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('joke/cancerAwareness', 'shared'));
        spooky.screenCenter();
        add(spooky);
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
        FlxG.switchState(new SusState());
	}
	
}