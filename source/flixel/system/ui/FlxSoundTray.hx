package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
#if flash
import flash.text.AntiAliasType;
import flash.text.GridFitType;
#end

class FlxSoundTray extends Sprite
{
	public var active:Bool;
	var _timer:Float;
	var _bars:Array<Bitmap>;
	var _width:Int = 80;
	var _defaultScale:Float = 2.0;
	var text:TextField = new TextField();

	// Track last known volume for detecting increase/decrease
	var _lastVolume:Float = 1.0;

	// Prevent repeated bounce animations while visible
	var _hasBounced:Bool = false;

	public function new()
	{
		super();

		visible = false;
		scaleX = _defaultScale;
		scaleY = _defaultScale;

		var tmp:Bitmap = new Bitmap(new BitmapData(_width, 30, true, 0x7F000000));
		screenCenter();
		addChild(tmp);

		text.width = tmp.width;
		text.height = tmp.height;
		text.multiline = true;
		text.wordWrap = true;
		text.selectable = false;

		#if flash
		text.embedFonts = true;
		text.antiAliasType = AntiAliasType.NORMAL;
		text.gridFitType = GridFitType.PIXEL;
		#end

		var dtf:TextFormat = new TextFormat("Comic Sans MS Bold", 8, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = dtf;
		addChild(text);
		text.text = "Volume - 100%";
		text.y = 14;

		var bx:Int = 10;
		var by:Int = 14;
		_bars = [];

		for (i in 0...10)
		{
			tmp = new Bitmap(new BitmapData(4, i + 1, false, FlxColor.WHITE));
			tmp.x = bx;
			tmp.y = by;
			tmp.alpha = 0.4;
			addChild(tmp);
			_bars.push(tmp);
			bx += 6;
			by--;
		}

		y = -height;
		visible = false;
	}

	public function update(MS:Float):Void
	{
		if (_timer > 0)
		{
			_timer -= MS / 1000;
		}
		else if (y > -height && active)
		{
			active = false;
			_hasBounced = false;

			// Smooth slide up (no bounce)
			FlxTween.tween(this, { y: -height }, 0.3, { ease: FlxEase.quadInOut, type: FlxTweenType.ONESHOT });
		}
	}

	public function show(Silent:Bool = false):Void
	{
		var currentVolume:Float = FlxG.sound.volume;
		var globalVolume:Int = Math.round(currentVolume * 10);

		if (FlxG.sound.muted)
			globalVolume = 0;

		// Play correct sound
		if (!Silent)
		{
			var soundName:String = null;

			if (globalVolume >= 10)
				soundName = "clickyMax";
			else if (currentVolume > _lastVolume)
				soundName = "clickyUp";
			else if (currentVolume < _lastVolume)
				soundName = "clickyDown";

			if (soundName != null)
			{
				var sound = Paths.sound(soundName, "shared");
				if (sound != null)
					FlxG.sound.load(sound).play();
			}
		}

		_lastVolume = currentVolume;

		_timer = 1;
		visible = true;
		active = true;

		// Only bounce once per show
		if (!_hasBounced)
		{
			y = -height;
			_hasBounced = true;
			FlxTween.tween(this, { y: 0 }, 0.7, { ease: FlxEase.elasticOut, type: FlxTweenType.ONESHOT });
		}
		else
		{
			y = 0;
		}

		// Smoothly animate bars (cancel old tweens first to prevent jitter)
		for (i in 0..._bars.length)
		{
			var targetAlpha:Float = (i < globalVolume) ? 1 : 0.4;
			FlxTween.cancelTweensOf(_bars[i]);
			FlxTween.tween(_bars[i], { alpha: targetAlpha }, 0.2, { ease: FlxEase.quadOut });
		}

		// Text updates
		if (globalVolume == 0)
		{
			text.text = "MUTED";

			// Red flash animation
			text.textColor = 0xFFFF0000; // bright red
			FlxTween.cancelTweensOf(text); // prevent stacking
			FlxTween.tween(text, { textColor: 0xFFFFFFFF }, 0.6, { ease: FlxEase.quadOut });
		}
		else
		{
			text.text = "Volume - " + globalVolume * 10 + "%";
			text.textColor = 0xFFFFFFFF; // reset color to white
		}
	}

	public function destroy():Void
	{
		// Cancel all active tweens
		FlxTween.cancelTweensOf(this);
    
		for (bar in _bars)
		{
			FlxTween.cancelTweensOf(bar);
		}
    
		FlxTween.cancelTweensOf(text);
    
		// Clean up references
		_bars = null;
		text = null;
	}

	public function screenCenter():Void
	{
		scaleX = _defaultScale;
		scaleY = _defaultScale;
		x = (0.5 * (Lib.current.stage.stageWidth - _width * _defaultScale) - FlxG.game.x);
	}
}
#end
