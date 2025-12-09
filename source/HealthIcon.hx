package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

import openfl.utils.Assets;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public var noAaChars:Array<String> = [
		'dave-angey',
		'bambi-3d',
		'bf-pixel',
		'gf-pixel',
		'bambi-unfair',
		'expunged',
		'nofriend',
		'dave-festival-3d'
	];
	var char:String;
	var state:String;
	public var isPlayer:Bool;
	
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	public function changeIcon(char:String)
	{
		if (this.char != char)
		{
			var mainPath = 'ui/iconGrid/' + char;
			var spectrePath = 'ui/iconGrid/spectre/' + char;

			var chosenPath:String = null;

			if (char != "none")
			{
				// Check if icon exists in main folder
				if (Assets.exists(Paths.image(mainPath, 'preload'), IMAGE))
					chosenPath = mainPath;
				// Else check spectre folder
				else if (Assets.exists(Paths.image(spectrePath, 'preload'), IMAGE))
					chosenPath = spectrePath;
				// Neither found → avoid crash
				else {
					trace("ERROR: Icon '" + char + "' not found in iconGrid or spectre!");
					chosenPath = "blank"; // fallback image
					loadGraphic(Paths.image(chosenPath, 'shared'));
					return;
				}

				// Load the icon
				loadGraphic(Paths.image(chosenPath, 'preload'), true, 150, 150);

				antialiasing = !noAaChars.contains(char);
				animation.add(char, [0, 1], 0, false, isPlayer);
				animation.play(char);
			}
			else
			{
				loadGraphic(Paths.image('blank', 'shared'));
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		offset.set(Std.int(FlxMath.bound(width - 150, 0)), Std.int(FlxMath.bound(height - 150, 0)));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
	public function changeState(charState:String)
	{
		switch (charState)
		{
			case 'normal':
				animation.curAnim.curFrame = 0;
			case 'losing':
				animation.curAnim.curFrame = 1;
		}
		state = charState;
	}
	public function getState()
	{
		return state;
	}
	public function getChar():String
	{
		return char;
	}
}