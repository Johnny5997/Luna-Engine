package;

import sys.FileSystem;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;

	public var globalOffset:Array<Float> = new Array<Float>();
	public var offsetScale:Float = 1;
	
	public var barColor:FlxColor;
	
	public var canSing:Bool = true;
	public var skins:Map<String, String> = new Map<String, String>();

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		skins.set('normal', curCharacter);
		skins.set('recursed', 'bf-recursed');
		skins.set('gfSkin', 'gf-none');
		
		antialiasing = true;

		switch (curCharacter)
		{
			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				skins.set('gfSkin', 'gf');
				skins.set('3d', 'bf-3d');

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'bfspectre':
				frames = Paths.getSparrowAtlas('characters/bfspectre', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				skins.set('gfSkin', 'gf');
				skins.set('3d', 'bf-3d');

				barColor = FlxColor.fromRGB(202, 0, 255);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;


			case 'fpbf':
				frames = Paths.getSparrowAtlas('characters/fpbf', 'shared');
				
				animation.addByPrefix('idle', 'bf idle', 24, false);
				animation.addByPrefix('singUP', 'bf up', 24, false);
				animation.addByPrefix('singLEFT', 'bf left', 24, false);
				animation.addByPrefix('singRIGHT', 'bf right', 24, false);
				animation.addByPrefix('singDOWN', 'bf down', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'itsumi':
				frames = Paths.getSparrowAtlas('characters/itsumi', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(51, 51, 51);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'itsumigod':
				frames = Paths.getSparrowAtlas('characters/itsumigod', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(51, 51, 51);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'itsumispectre':
				frames = Paths.getSparrowAtlas('characters/itsumispectre', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'itsumispectreflipped':
				frames = Paths.getSparrowAtlas('characters/itsumispectre', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

			case 'itsumi-pixel':
				frames = Paths.getSparrowAtlas('characters/itsumi-pixel', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(51, 51, 51);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'bftessattack':
				frames = Paths.getSparrowAtlas('characters/bftessattack', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(103, 250, 226);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'oddbf':
				frames = Paths.getSparrowAtlas('characters/oddbf', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 19, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 19, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 19, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 19, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 19, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 19, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 19, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 19, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 19, false);
				animation.addByPrefix('hey', 'BF HEY', 19, false);

				animation.addByPrefix('firstDeath', "BF dies", 19, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 19, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 19, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 19, false);
				animation.addByPrefix('scared', 'BF idle shaking', 19);
				animation.addByPrefix('hit', 'BF hit', 19, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'bf3d':
				frames = Paths.getSparrowAtlas('characters/bf3d', 'shared');
				
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singUPmiss', 'MUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MDOWN', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'bfscaredgood':
				frames = Paths.getSparrowAtlas('characters/bfscaredgood', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'bf-cool':
				frames = Paths.getSparrowAtlas('characters/Cool_BF', 'shared');
				
				animation.addByPrefix('idle', 'BFIdle', 24, false);
				for (anim in ['Left', 'Down', 'Up', 'Right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}', 'BF${anim}', 24, false);
					animation.addByPrefix('sing${anim.toUpperCase()}miss', 'Dead', 24, false);
				}
				loadOffsetFile(curCharacter);

				skins.set('gfSkin', 'gf-cool');
				skins.set('3d', 'bf-3d');

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('weeb/bfPixel', 'shared');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);
				
				skins.set('gfSkin', 'gf-pixel');
				skins.set('3d', 'bf-3d');
					
				globalOffset = [196, 160];

				barColor = FlxColor.fromRGB(49, 176, 209);

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

				antialiasing = false;
				nativelyPlayable = true;
				
				playAnim('idle');
				flipX = true;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('weeb/bfPixelsDEAD', 'shared');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				
				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				
				antialiasing = false;
				nativelyPlayable = true;
				flipX = true;
				playAnim('firstDeath');

			case 'generic-death':
				frames = Paths.getSparrowAtlas('ui/lose', 'shared');
				animation.addByPrefix('firstDeath', "lose... instance 1", 24, false);
				animation.addByPrefix('deathLoop', "still", 24, true);
				animation.addByPrefix('deathConfirm', "still", 24, false);
				
				loadOffsetFile(curCharacter);
				flipX = true;
				playAnim('firstDeath');

			case 'gf':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas('characters/GF_assets', 'shared');

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				skins.set('3d', 'gf-3d');

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');

			case 'itsumispeaker':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas('characters/itsumispeaker', 'shared');

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromString('51, 51, 51');

				playAnim('danceRight');

			case 'gf-3d':
				frames = Paths.getSparrowAtlas('characters/3d_gf', 'shared');
				animation.addByPrefix('danceLeft', 'idle gf', 24, true);
				animation.addByPrefix('danceRight', 'idle gf', 24, true);
				animation.addByPrefix('sad', 'gf sad', 24, false);
		
				loadOffsetFile(curCharacter);
				
				globalOffset = [-50, -160];
				
				barColor = FlxColor.fromString('#33de39');

				updateHitbox();
				antialiasing = false;
						
				playAnim('danceRight');
			case 'gf-cool':
				frames = Paths.getSparrowAtlas('characters/Cool_GF', 'shared');
				animation.addByPrefix('danceLeft', 'left', 24, true);
				animation.addByPrefix('danceRight', 'right', 24, true);
				animation.addByPrefix('sad', 'f', 24, false);
		
				loadOffsetFile(curCharacter);
				
				skins.set('3d', 'gf-3d');

				barColor = FlxColor.fromString('#33de39');
				
				updateHitbox();						
				playAnim('danceRight');
			case 'gf-none':
				frames = Paths.getSparrowAtlas('characters/noGF', 'shared');
				
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [0], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [0], "", 24, false);
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'gf-pixel':
				frames = Paths.getSparrowAtlas('weeb/gfPixel', 'shared');
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
				loadOffsetFile(curCharacter);
				
				skins.set('3d', 'gf-3d');

				globalOffset = [300, 280];

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				playAnim('danceRight');

			case 'kasumi':
				frames = Paths.getSparrowAtlas('characters/kasumi', 'shared');
				
				animation.addByPrefix('idle', 'kasumi idle0000', 24, false);
				animation.addByPrefix('singUP', 'kasumi up0000', 24, false);
				animation.addByPrefix('singLEFT', 'kasumi left0000', 24, false);
				animation.addByPrefix('singRIGHT', 'kasumi right0000', 24, false);
				animation.addByPrefix('singDOWN', 'kasumi down0000', 24, false);

				loadOffsetFile('bf-playable');

				barColor = FlxColor.fromRGB(118, 104, 103);

				playAnim('idle');

				flipX = false;

				updateHitbox();
				antialiasing = false;

			case 'bambi-new':
				frames = Paths.getSparrowAtlas('bambi/bambiRemake', 'shared');
				animation.addByPrefix('idle', 'bambi idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}', 'bambi $anim', 24, false);
					animation.addByPrefix('sing${anim.toUpperCase()}miss', 'miss $anim', 24, false);
				}
				for (anim in ['left', 'right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}-alt', 'bambi alt $anim', 24, false);
				}
				animation.addByPrefix('hey', 'bambi look', 24, false);
				animation.addByPrefix('singSmash', 'bambi phone', 24, false);
				animation.addByPrefix('singThrow', 'bambi throw', 24, false);
				
				barColor = FlxColor.fromRGB(37, 191, 55);

				loadOffsetFile(curCharacter + (isPlayer ? '-playable' : ''));
				
				globalOffset = [37, 90];
				skins.set('recursed', 'bambi-recursed');

				playAnim('idle');

			case 'bambi-death':
				frames = Paths.getSparrowAtlas('bambi/Bambi_Death', 'shared');

				animation.addByPrefix('firstDeath', 'bambi die', 24, false);
				animation.addByPrefix('deathLoop', 'die loop', 24, true);
				animation.addByPrefix('deathConfirm', 'die end', 24, false);

				loadOffsetFile(curCharacter);
				
				playAnim('firstDeath');

			case 'bambi-3d':
				// BAMBI SHITE ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('expunged/Cheating', 'shared');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
		
				barColor = FlxColor.fromRGB(13, 151, 21);

				loadOffsetFile(curCharacter + (isPlayer ? '-playable' : ''));

				globalOffset = [0, -350];

				setGraphicSize(Std.int((width * 1.5) / furiosityScale));

				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			case 'bambi-unfair':
				// BAMBI SHITE ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('expunged/unfair_bambi', 'shared');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right'])
				{
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}
				globalOffset = [0, -260];
				barColor = FlxColor.fromRGB(178, 7, 7);

				loadOffsetFile(curCharacter);
				
				antialiasing = false;
				
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));

				playAnim('idle');

			case 'bambi-shredder':
				frames = Paths.getSparrowAtlas('festival/bambi_shredder', 'shared');
				
				animation.addByPrefix('idle', 'shredder idle', 24, false);
				animation.addByPrefix('singLEFT', 'shredder left', 24, false);
				animation.addByPrefix('singDOWN', 'shredder down', 24, false);
				animation.addByPrefix('singMIDDLE', 'shredder forward', 24, false);
				animation.addByPrefix('singUP', 'shredder up', 24, false);
				animation.addByPrefix('singRIGHT', 'shredder right', 24, false);
				animation.addByPrefix('singMIDDLE', 'shredder forward', 24, false);
				animation.addByPrefix('takeOut', 'shredder take out', 24, false);

				barColor = FlxColor.fromRGB(37, 191, 55);
				loadOffsetFile(curCharacter);
				
				globalOffset = [37, 90];

			case 'bf-recursed':
				frames = Paths.getSparrowAtlas('recursed/Recursed_BF', 'shared');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT'])
				{
					animation.addByPrefix('sing$anim', 'BF NOTE ${anim}0', 24, false);
					animation.addByPrefix('sing${anim}miss', 'BF NOTE $anim MISS', 24, false);
				}
				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, true);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24, false);

				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.WHITE;
				nativelyPlayable = true;
				flipX = true;

				playAnim('idle');

			case 'luna':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/luna', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'lunaslave':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunaslave', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(83, 48, 28);

				playAnim('idle');

			case 'lunaspectre':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunaspectre', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(108, 38, 82);

				playAnim('idle');

			case 'lunamadspectre':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunamadspectre', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(108, 38, 82);

				playAnim('idle');


			// hortas stuff
			case 'holyluna':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/holyluna', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(223, 207, 77);

				playAnim('idle');

			case 'lunaseptuagint':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunaseptuagint', 'shared');

				animation.addByPrefix('idle', 'sep idle', 24);
				animation.addByPrefix('singUP', 'sep up', 24);
				animation.addByPrefix('singRIGHT', 'sep right', 24);
				animation.addByPrefix('singDOWN', 'sep down', 24);
				animation.addByPrefix('singLEFT', 'sep left', 24);
				animation.addByPrefix('alt', 'sep alt', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(6, 15, 0);

				setGraphicSize(Std.int((width * 2) / furiosityScale));

				playAnim('idle');

				flipX = true;

			case 'lunaclamorous':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunaclamorous', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(18, 7, 72);

				playAnim('idle');

			case 'sisters':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/sisters', 'shared');

				animation.addByPrefix('idle', 'sisters idle', 48);
				animation.addByPrefix('singUP', 'sisters up', 48);
				animation.addByPrefix('singRIGHT', 'sisters right', 48);
				animation.addByPrefix('singDOWN', 'sisters down', 48);
				animation.addByPrefix('singLEFT', 'sisters left', 48);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(153, 42, 51);

				playAnim('idle');

			case 'lunadoll':
				frames = Paths.getSparrowAtlas('characters/lunadoll');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle', 200, -60);
				addOffset('singLEFT', 0, 60);
				addOffset('singDOWN', 60, 10);
				addOffset('singUP', 150, -150);
				addOffset('singRIGHT', 340);

				antialiasing = false;

				barColor = FlxColor.fromRGB(80, 80, 80);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();

				playAnim('idle');

			case 'elonmusk':
				// ELON THE MUSK ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/elonmusk', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(175, 142, 106);

				playAnim('idle');

			case 'lunatessattack':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunatessattack', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(161, 208, 129);

				playAnim('idle');

			case 'dark':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/dark', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(0, 0, 0);

				playAnim('idle');

			case 'philtrixpissed':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/philtrixpissed', 'shared');

				animation.addByPrefix('idle', 'Expunged Idle', 46);
				animation.addByPrefix('singUP', 'Expunged Up', 35);
				animation.addByPrefix('singRIGHT', 'Expunged Right', 24);
				animation.addByPrefix('singDOWN', 'Expunged Down', 24);
				animation.addByPrefix('singLEFT', 'Expunged Left', 24);

				animation.addByPrefix('firstDeath', "Expunged Down", 24, false);
				animation.addByPrefix('deathLoop', "Expunged Down", 24, true);
				animation.addByPrefix('deathConfirm', "Expunged Up", 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int((width * 3) / furiosityScale));

				barColor = FlxColor.fromRGB(127, 64, 64);

				playAnim('idle');

			case 'spongeback':
				frames = Paths.getSparrowAtlas('characters/spongeback', 'shared');
				
				animation.addByPrefix('idle', 'spongeback Idle', 10, false);
				animation.addByPrefix('singUP', 'spongeback Up', 16, false);
				animation.addByPrefix('singLEFT', 'spongeback Left', 16, false);
				animation.addByPrefix('singRIGHT', 'spongeback Right', 16, false);
				animation.addByPrefix('singDOWN', 'spongeback Down', 16, false);

				animation.addByPrefix('firstDeath', "spongeback Down", 24, false);
				animation.addByPrefix('deathLoop', "spongeback Down", 24, true);
				animation.addByPrefix('deathConfirm', "spongeback Up", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int((width * 0.6) / furiosityScale));

				barColor = FlxColor.fromRGB(255, 255, 0);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'spongefront':
				frames = Paths.getSparrowAtlas('characters/spongefront', 'shared');
				
				animation.addByPrefix('idle', 'spongefront Idle', 10, false);
				animation.addByPrefix('singUP', 'spongefront Up', 16, false);
				animation.addByPrefix('singLEFT', 'spongefront Left', 16, false);
				animation.addByPrefix('singRIGHT', 'spongefront Right', 16, false);
				animation.addByPrefix('singDOWN', 'spongefront Down', 16, false);

				animation.addByPrefix('firstDeath', "spongefront Down", 24, false);
				animation.addByPrefix('deathLoop', "spongefront Down", 24, true);
				animation.addByPrefix('deathConfirm', "spongefront Up", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int((width * 0.6) / furiosityScale));

				barColor = FlxColor.fromRGB(255, 255, 0);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'impostor':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/impostor', 'shared');

				animation.addByPrefix('idle', 'impostor idle', 24);
				animation.addByPrefix('singUP', 'impostor up', 24);
				animation.addByPrefix('singRIGHT', 'impostor right', 24);
				animation.addByPrefix('singDOWN', 'impostor down', 24);
				animation.addByPrefix('singLEFT', 'imposter left', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(187, 45, 45);

				playAnim('idle');

			case 'alls':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/alls', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(148, 181, 102);

				playAnim('idle');

			case 'lunar':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunar', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'lunacone':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunacone', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'noahreal':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/noahreal', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'puda':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/puda', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(140, 75, 0);

				playAnim('idle');

			case 'obama':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/obama', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(195, 122, 80);

				playAnim('idle');

			case 'lunahalloween':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunahalloween', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(0, 0, 8);

				playAnim('idle');

			case 'lunagold':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunagold', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(255, 255, 0);

				playAnim('idle');

			case 'luna3d':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/luna3d', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'lunamad':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunamad', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				skins.set('recursed', 'luna-recursed');

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'luna-recursed':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('recursed/Recursed_Luna', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'luna-pixel':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/luna-pixel', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 80, 80);

				playAnim('idle');

			case 'lunanomo':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunanomo', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(80, 255, 0);

				playAnim('idle');

			case 'lunadis':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunadis', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 74);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(255, 0, 203);

				playAnim('idle');

			case 'lunakalam':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/lunakalam', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 74);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(0, 131, 255);

				playAnim('idle');

			case 'lunafinal':
				frames = Paths.getSparrowAtlas('characters/lunafinal', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);

				loadOffsetFile(curCharacter);

				globalOffset = [0, -300];
				
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();

				skins.set('recursed', 'luna-recursed');

				barColor = FlxColor.fromRGB(1, 1, 1);

				nativelyPlayable = true;	
				flipX = false;
	
				antialiasing = false;

				playAnim('idle');

			case 'lunafinalspectre':
				frames = Paths.getSparrowAtlas('characters/lunafinalspectre', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);

				loadOffsetFile(curCharacter);

				globalOffset = [0, -300];
				
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();

				skins.set('recursed', 'luna-recursed');

				barColor = FlxColor.fromRGB(108, 38, 82);

				nativelyPlayable = true;	
				flipX = false;
	
				antialiasing = false;

				playAnim('idle');

			case 'bambi-joke-mad':
				frames = Paths.getSparrowAtlas('joke/bambi-joke-mad', 'shared');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('die', 'die', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');

				barColor = FlxColor.fromRGB(108, 38, 82);
				nativelyPlayable = true;
				flipX = true;

			case 'lunatrueform':
				frames = Paths.getSparrowAtlas('characters/lunatrueform', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'right', 24, false);
				animation.addByPrefix('singRIGHT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				animation.addByPrefix('firstDeath', "down", 24, false);
				animation.addByPrefix('deathLoop', "down", 24, true);
				animation.addByPrefix('deathConfirm', "up", 24, false);

				loadOffsetFile(curCharacter);

				globalOffset = [0, -300];
				
				setGraphicSize(Std.int((width * 2.3) / furiosityScale));
				updateHitbox();

				barColor = FlxColor.fromRGB(1, 1, 1);

				nativelyPlayable = true;	
				flipX = false;
	
				antialiasing = false;

				playAnim('idle');

			case 'lunavirus':
				frames = Paths.getSparrowAtlas('characters/lunavirus', 'shared');

				animation.addByPrefix('idle', 'idle', 35, false);
				animation.addByPrefix('singUP', 'up', 35, false);
				animation.addByPrefix('singLEFT', 'right', 35, false);
				animation.addByPrefix('singRIGHT', 'left', 35, false);
				animation.addByPrefix('singDOWN', 'down', 35, false);

				animation.addByPrefix('firstDeath', "down", 35, false);
				animation.addByPrefix('deathLoop', "down", 35, true);
				animation.addByPrefix('deathConfirm', "up", 35, false);

				loadOffsetFile(curCharacter);

				globalOffset = [0, -300];
				
				setGraphicSize(Std.int((width * 2.3) / furiosityScale));
				updateHitbox();

				barColor = FlxColor.fromRGB(255, 255, 255);

				nativelyPlayable = true;	
				flipX = false;
	
				antialiasing = false;

				playAnim('idle');

			case 'lunagod':
				frames = Paths.getSparrowAtlas('characters/lunagod', 'shared');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);

				loadOffsetFile(curCharacter);

				globalOffset = [200, -300];
				
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();

				barColor = FlxColor.fromRGB(0, 0, 0);

				nativelyPlayable = true;	
				flipX = false;
	
				antialiasing = false;

				playAnim('idle');


			case 'stereo':
				frames = Paths.getSparrowAtlas('characters/IM_GONNA_TORNADER_YOU_AWAY', 'shared');

				animation.addByPrefix('idle', 'bump', 24, false);

				globalOffset = [500, 500];

				loadOffsetFile(curCharacter);
					
				playAnim('idle');

			// ALLS WORLD STUFF
			case 'jewalls':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/jewalls', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(2, 55, 183);

				playAnim('idle');

			case 'jewbf':
				frames = Paths.getSparrowAtlas('allsWorld/characters/jewbf', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(2, 55, 183);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'zombie':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/zombie', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'granny':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/granny', 'shared');

				animation.addByPrefix('idle', 'granny chomp', 1);
				animation.addByPrefix('chomp', 'granny chomp', 20);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'alarmman':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/alarmman', 'shared');

				animation.addByPrefix('idle', 'alarmman alarm', 1);
				animation.addByPrefix('alarm', 'alarmman alarm', 20);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'nothing':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/nothing', 'shared');

				animation.addByPrefix('idle', 'alarmman alarm', 1);
				animation.addByPrefix('alarm', 'alarmman alarm', 20);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'ye':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/ye', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'nonoalls':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/nonoalls', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(1, 1, 1);

				playAnim('idle');

			case 'nonobf':
				frames = Paths.getSparrowAtlas('allsWorld/characters/nonobf', 'shared');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(1, 1, 1);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

			case 'opiumbird':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/opiumbird', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

			case 'bluecollarspongebob':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('allsWorld/characters/bluecollarspongebob', 'shared');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(189, 167, 129);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;

		}
		dance();

		if(isPlayer)
		{
			flipX = !flipX;
		}
	}

	function loadOffsetFile(character:String)
	{
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.offsetFile(character));
		
		for (offsetText in offsetStuffs)
		{
			var offsetInfo:Array<String> = offsetText.split(' ');

			addOffset(offsetInfo[0], Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (animation == null)
		{
			super.update(elapsed);
			return;
		}
		else if (animation.curAnim == null)
		{
			super.update(elapsed);
			return;
		}
		if (!nativelyPlayable && !isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;
	private var losedanced:Bool = false;

	/**
	 * FOR DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && canDance)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-pixel' | 'gf-3d' | 'gf-cool' | 'shaggy' | 'redshaggy':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}
				default:
					playAnim('idle', true);
			}
		}
	}

	public function danceLose()
	{
		if (losedanced)
			playAnim('deathLoopRight', true);
		else
			playAnim('deathLoopLeft', true);

		losedanced = !losedanced;
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null)
		{
			return; //why wasn't this a thing in the first place
		}
		if((AnimName.toLowerCase() == 'idle' || AnimName.toLowerCase().startsWith('dance')) && !canDance)
		{
			return;
		}
		
		if(AnimName.toLowerCase().startsWith('sing') && !canSing)
		{
			return;
		}
		
		animation.play(AnimName, Force, Reversed, Frame);
	
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0] * offsetScale, daOffset[1] * offsetScale);
		}
		
		else
			offset.set(0, 0);
	
		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}
	
			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
