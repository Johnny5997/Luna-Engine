package;

import flixel.math.FlxMath;
import flixel.tweens.misc.ColorTween;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxSave;

class SelectLanguageState extends MusicBeatState
{
   var bg:FlxBackdrop;
   var selectLanguage:FlxText;
   var textItems:Array<FlxText> = new Array<FlxText>();
   var curLanguageSelected:Int;
   var currentLanguageText:FlxText;
   var langaugeList:Array<Language> = new Array<Language>();
   var accepted:Bool;

   public override function create()
   {
      PlayerSettings.init();

      FlxG.sound.playMusic(Paths.music('selectLanguageMenu'), 0.7);
      
      FlxG.sound.music.fadeIn(2, 0, 0.7);

      langaugeList = LanguageManager.getLanguages();
      
      bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
      bg.antialiasing = true;
      bg.color = langaugeList[curLanguageSelected].langaugeColor;
      add(bg);

      selectLanguage = new FlxText(0, (FlxG.height / 2) - 300, FlxG.width, "Hi! Welcome to VS Luna, and thanks for downloading!! Have fun, but not too much fun... don't wanna make Luna mad... And more languages are coming soon.", 45);
      selectLanguage.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      selectLanguage.antialiasing = true;
      selectLanguage.borderSize = 2;
      selectLanguage.screenCenter(X);
      add(selectLanguage);

      for (i in 0...langaugeList.length)
      {
         var currentLangauge = langaugeList[i];

         var langaugeText:FlxText = new FlxText(0, (FlxG.height / 2 - 150) + i * 75, FlxG.width, currentLangauge.langaugeName, 25);
         langaugeText.screenCenter(X);
         langaugeText.setFormat("Comic Sans MS Bold", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
         langaugeText.antialiasing = true;
         langaugeText.borderSize = 2;

         var flag:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('languages/' + currentLangauge.langaugeName));
         flag.x = langaugeText.x + langaugeText.width + flag.width / 2;

         var yValues = CoolUtil.getMinAndMax(flag.height, langaugeText.height);
         flag.y = langaugeText.y + ((yValues[0] - yValues[1]) / 2);
         add(flag);

         langaugeText.y -= 10;
         langaugeText.alpha = 0;

         flag.y -= 10;
         flag.alpha = 0;

         FlxTween.tween(langaugeText, {y: langaugeText.y + 10, alpha: 1}, 0.07, {startDelay: i * 0.1});
         FlxTween.tween(flag, {y: flag.y + 10, alpha: 1}, 0.07, {startDelay: i * 0.1});

         textItems.push(langaugeText);
         add(langaugeText);
      }

      changeSelection();
   }
   public override function update(elapsed:Float)
   {
      var scrollSpeed:Float = 50;
      bg.x -= scrollSpeed * elapsed;
      bg.y -= scrollSpeed * elapsed;

      if (!accepted)
      {
			if (controls.ACCEPT)
			{
				accepted = true;

				FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);

				LanguageManager.save.data.language = langaugeList[curLanguageSelected].pathName;
            LanguageManager.save.flush();
            LanguageManager.currentLocaleList = CoolUtil.coolTextFile(Paths.file('locale/' + LanguageManager.save.data.language + '/textList.txt', TEXT, 'preload'));

            FlxFlicker.flicker(currentLanguageText, 1.1, 0.07, true, true, function(flick:FlxFlicker)
				{
					FlxG.switchState(new TitleState());
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
			      FlxG.sound.music.fadeIn(4, 0, 0.7);
				});
			}
			if (controls.UP_P)
			{
				changeSelection(-1);
			}
			if (controls.DOWN_P)
			{
				changeSelection(1);
			}
      }
   }
   function changeSelection(amount:Int = 0)
   {
      if (amount != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

      curLanguageSelected += amount;
      if (curLanguageSelected > langaugeList.length - 1)
      {
         curLanguageSelected = 0;
      }
      if (curLanguageSelected < 0)
      {
         curLanguageSelected = langaugeList.length - 1;
      }
      currentLanguageText = textItems[curLanguageSelected];
      for (menuItem in textItems)
      {
         updateText(menuItem, menuItem == textItems[curLanguageSelected]);
      }
      FlxTween.color(bg, 0.4, bg.color, langaugeList[curLanguageSelected].langaugeColor);
   }
   function updateText(text:FlxText, selected:Bool)
   {
      if (selected)
      {
         text.setFormat("Comic Sans MS Bold", 25, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      }
      else
      {
         text.setFormat("Comic Sans MS Bold", 25);
      }
   }
}