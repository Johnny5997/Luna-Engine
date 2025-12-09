package;
#if desktop
import cpp.abi.Abi;
#end
import flixel.graphics.FlxGraphic;
import flixel.FlxCamera;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUIGroup;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;
/*
hi cool lil committers looking at this code, 95% of this is my code and I'd appreciate if you didn't steal it without asking for my permission
-vs dave dev T5mpler 
i have to put this here just in case you think of doing so
*/
class CreditsMenuState extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite();
   var overlay:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/CoolOverlay'));
   var selectedFormat:FlxText;
   var defaultFormat:FlxText;
   var curNameSelected:Int = 0;
   var creditsTextGroup:Array<CreditsText> = new Array<CreditsText>();
   var menuItems:Array<CreditsText> = new Array<CreditsText>();
   var state:State;
   var selectedPersonGroup:FlxSpriteGroup = new FlxSpriteGroup();
   var selectPersonCam:FlxCamera = new FlxCamera();
   var mainCam:FlxCamera = new FlxCamera();
   var transitioning:Bool = false;
   var creditsTypeString:String = '';
   var translatedCreditsType:String = '';

   #if SHADERS_ENABLED
   var bgShader:Shaders.GlitchEffect;
   #end

   var StupidCameraFollow:FlxObject = new FlxObject();

   var curSocialMediaSelected:Int = 0;
   var socialButtons:Array<SocialButton> = new Array<SocialButton>();
   var hasSocialMedia:Bool = true;
   
   // Grid navigation variables
   var gridColumns:Int = 3;
   var gridRows:Int = 0;

   public var DoFunnyScroll:Bool = false;
   
   var peopleInCredits:Array<Person> = 
   [
      // Developers //
      new Person("Johnny5997", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/@Johnny5997YT'), 
         new Social('twitter', 'https://x.com/JohnnyPlayz5997'),
         new Social('roblox', 'https://www.roblox.com/users/658952463/profile'),
         new Social('applemusic', 'https://music.apple.com/us/artist/johnny-playz-5997/1689400751'),
         new Social('spotify', 'https://open.spotify.com/artist/5RYPgLozoYGux3QWMsg5BM'),
         new Social('soundcloud', 'https://soundcloud.com/johnny-playz-gd')
      ]),

      new Person("MoldyGH", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCHIvkOUDfbMCv-BEIPGgpmA'), 
         new Social('twitter', 'https://twitter.com/moldy_gh'),
         new Social('soundcloud', 'https://soundcloud.com/moldygh')
      ]),
     
      new Person("MissingTextureMan101", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ'),
         new Social('twitter', 'https://twitter.com/OfficialMTM101'),
         new Social('twitch', 'https://www.twitch.tv/missingtextureman101'),
         new Social('gamebanana', 'https://gamebanana.com/members/1665049')
      ]),
      
      new Person("rapparep lol", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCKfdkmcdFftv4pFWr0Bh45A'),
         new Social('twitter', 'https://twitter.com/rappareplol')
      ]),
      
      // Contributors //
      new Person("Luna", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/@lunathekitten_')
      ]),
      new Person("Noah", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/@gdnoahplayz'),
         new Social('twitter', 'https://x.com/GDNoah_'),
         new Social('roblox', 'https://www.roblox.com/users/2032836347/profile')
      ]),
      new Person("Aadsta", CreditsType.Contributor,
      [
         new Social('twitter', 'https://twitter.com/FullNameDeTrain')
      ]),
      new Person("Top 10 Awesome", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/c/Top10Awesome')
      ]),
      new Person("Ruby", CreditsType.Contributor,
      [  
         new Social ('youtube', 'https://www.youtube.com/@rubymaze56')
      ]),
      new Person("Kaash Paige", CreditsType.Contributor,
      [  
         new Social ('youtube', 'https://www.youtube.com/channel/UCqLcZ9ksQuE3QIf-pNCVSjA'),
         new Social('twitter', 'https://x.com/kaashmychecks?lang=en'),
         new Social('applemusic', 'https://music.apple.com/us/artist/kaash-paige/1443645944'),
         new Social('spotify', 'https://open.spotify.com/artist/0f2YkMXwFNJNSX7MymevKE'),
         new Social('soundcloud', 'https://soundcloud.com/KAASHMYCHECKS')
      ]),
      new Person("Remove.BG", CreditsType.Contributor,
      [  
         new Social ('removebg', 'https://www.remove.bg')
      ]),
      new Person("Lancey", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://youtube.com/c/Lancey170'),
         new Social('twitter', 'https://twitter.com/Lancey170')
      ]),
      new Person("sibottle", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://www.youtube.com/channel/UCqFkjwmaYlnVXwLMw3_AXLA'),
      ]),
      new Person("4k Funny", CreditsType.Contributor,
      [  

      ]),
      new Person("Cynda", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://www.youtube.com/channel/UCTaq4jni33NoaI1TfMXCRcA'),
      ]),
      new Person("Maevings", CreditsType.Contributor,
      [  

      ]),
      new Person("Instagram", CreditsType.Contributor,
      [  
         new Social('instagram', 'https://www.instagram.com'),
      ]),

      // Beta Testers //
      new Person("Noah", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/@gdnoahplayz'),
         new Social('twitter', 'https://x.com/GDNoah_'),
         new Social('roblox', 'https://www.roblox.com/users/2032836347/profile')
      ]),
      new Person("Spencer", CreditsType.BetaTester,
      [

      ]),

      //extra keys addon creator
      new Person("Magman", CreditsType.EKACreator,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UC1IWpXJIB0wYTCnQI0E9HMQ'),
         new Social('twitter', 'https://twitter.com/magar_manh')
      ]),
	  // Special Thanks //
     new Person("You!", CreditsType.SpecialThanks, [])
   ];

	override function create()
	{
      #if desktop
      DiscordClient.changePresence("In the Credits Menu", null);
      #end

      mainCam.bgColor.alpha = 0;
      selectPersonCam.bgColor.alpha = 0;
      FlxG.cameras.reset(mainCam);
      FlxG.cameras.add(selectPersonCam);

      FlxCamera.defaultCameras = [mainCam];
      selectedPersonGroup.cameras = [selectPersonCam];

      state = State.SelectingName;
      defaultFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      defaultFormat.borderSize = 2;
      defaultFormat.borderQuality = 2;
      selectedFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      selectedFormat.borderSize = 2;
      selectedFormat.borderQuality = 2;

      if (!DoFunnyScroll)
      {
		  var menuBG:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/void/mainmenubgcredits', 'shared'));
		  menuBG.scrollFactor.set();
		  menuBG.antialiasing = false;
		  add(menuBG);

		  #if SHADERS_ENABLED
		  bgShader = new Shaders.GlitchEffect();
		  bgShader.waveAmplitude = 0.1;
		  bgShader.waveFrequency = 5;
		  bgShader.waveSpeed = 2;
		  menuBG.shader = bgShader.shader;
		  #end
  
          overlay.color = FlxColor.LIME;
          overlay.scrollFactor.set();
          add(overlay);
      }
      else
      {
         FlxG.sound.playMusic(Paths.music('creditsTheme'));
         //PLACEHOLDER.
         bg.loadGraphic(MainMenuState.randomizeBG());
         bg.color = FlxColor.GRAY;
         bg.scrollFactor.set();
         add(bg);
      }
      
      var developers:Array<Person> = new Array<Person>();
      var translators:Array<Person> = new Array<Person>();
      var contributors:Array<Person> = new Array<Person>();
      var betaTesters:Array<Person> = new Array<Person>();
      var specialThanks:Array<Person> = new Array<Person>();
      var ekaCreator:Array<Person> = new Array<Person>();

      for (person in peopleInCredits) 
      {
         switch (person.creditsType)
         {
            case Dev: developers.push(person);
            case Translator: translators.push(person);
            case Contributor: contributors.push(person);
            case BetaTester: betaTesters.push(person);
            case SpecialThanks: specialThanks.push(person);
            case EKACreator: ekaCreator.push(person);
         }
      }

      for (i in 0...peopleInCredits.length)
      {
         var currentPerson = peopleInCredits[i];
         if (currentPerson == developers[0] || currentPerson == translators[0] || currentPerson == contributors[0] || currentPerson == betaTesters[0] || currentPerson == specialThanks[0] || currentPerson == ekaCreator[0])
         {
            switch (currentPerson.creditsType)
            {
               case Dev:
                  creditsTypeString = 'Developers';
                  translatedCreditsType = LanguageManager.getTextString('credits_dev');
               case Translator:
                  creditsTypeString = 'Translators';
                  translatedCreditsType = LanguageManager.getTextString('credits_translator');
               case Contributor:
                  creditsTypeString = 'Contributors';
				  translatedCreditsType = LanguageManager.getTextString('credits_contributor');
               case BetaTester:
                  creditsTypeString = 'Beta Testers';
                  translatedCreditsType = LanguageManager.getTextString('credits_betaTester');
               case SpecialThanks:
                  creditsTypeString = 'Special Thanks';
                  translatedCreditsType = LanguageManager.getTextString('credits_specialThanks');
               case EKACreator:
                  creditsTypeString = 'Extra Keys Addon Creator';
                  translatedCreditsType = LanguageManager.getTextString('credits_ekaCreator');
            }
            var titleText:FlxText = new FlxText(0, 0, 0, translatedCreditsType);
            titleText.setFormat("Comic Sans MS Bold", 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            titleText.borderSize = 3;
            titleText.borderQuality = 3;
            titleText.screenCenter(X);
            titleText.antialiasing = true;
            titleText.scrollFactor.set(0, 1);
            if (DoFunnyScroll)
            {
               titleText.color = FlxColor.PURPLE;
            }

            var personIcon:PersonIcon = new PersonIcon(titleText);
            personIcon.loadGraphic(Paths.image('credits/titles/' + creditsTypeString));
            personIcon.visible = !DoFunnyScroll;
            add(personIcon);
            
            var creditsTextTitleText = new CreditsText(titleText, false, personIcon);
            creditsTextGroup.push(creditsTextTitleText);
            add(titleText);
         }

         var textItem:FlxText = new FlxText(0, i * 50, 0, currentPerson.name, 32);
         textItem.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
         textItem.screenCenter(X);
         // Shift text left during DoFunnyScroll to center text+icon combo
         if (DoFunnyScroll)
         {
            textItem.x -= 60;
         }
		   textItem.antialiasing = true;
         textItem.scrollFactor.set(0, 1);

         var personIcon:PersonIcon = new PersonIcon(textItem, DoFunnyScroll);
         personIcon.loadGraphic(Paths.image('credits/icons/' + creditsTypeString + '/' + currentPerson.name));
         add(personIcon);

         // Icons now visible during DoFunnyScroll
         personIcon.visible = true;
         personIcon.antialiasing = true;
         if (currentPerson.name == 'Magman') personIcon.antialiasing = false;

         var creditsTextItem:CreditsText = new CreditsText(textItem, true, personIcon);

         add(textItem);
         creditsTextGroup.push(creditsTextItem);
         menuItems.push(creditsTextItem);
      }
      
      var selection = 0;
      
      changeSelection();
      
      for (creditsText in creditsTextGroup)
      {
         creditsText.selectionId = selection - curNameSelected;
         selection++;  
      }
      for (creditsText in creditsTextGroup)
      {
         var scaledY = FlxMath.remapToRange(creditsText.selectionId, 0, 1, 0, 1.5);
         creditsText.text.y = scaledY * 75 + (FlxG.height * 0.5);
      }

      StupidCameraFollow.x = menuItems[0].text.x;
      StupidCameraFollow.y = menuItems[0].text.y - 460;
      if (DoFunnyScroll)
      {
         // Increased scroll speed by reducing duration (was music.length / 1000 - 10.5, now - 3.5)
         FlxTween.tween(StupidCameraFollow, {y : (menuItems[menuItems.length - 1].text.y + 440)}, (FlxG.sound.music.length / 1000) - 3.5, {ease: FlxEase.linear, onComplete: function(tween:FlxTween)
         {
            var logoBl:FlxSprite = new FlxSprite(StupidCameraFollow.x, StupidCameraFollow.y);
            logoBl.frames = Paths.getSparrowAtlas('ui/logoBumpin');
            logoBl.antialiasing = true;
            logoBl.alpha = 0;
            logoBl.x -= logoBl.width / 2;
            logoBl.y -= logoBl.height / 2;
            add(logoBl);
            FlxTween.tween(logoBl, {alpha: 1}, 5.6, {ease: FlxEase.quadIn, onComplete: function(tween:FlxTween)
            {
               new FlxTimer().start((FlxG.sound.music.length / 1000) - (FlxG.sound.music.time / 1000), function(timer:FlxTimer)
               {
			      if (!FlxG.save.data.hasSeenCreditsMenu)
				  {
				     FlxG.save.data.hasSeenCreditsMenu = true;
					 FlxG.save.flush();
				  }
                  FlxG.sound.playMusic(Paths.music('theend'));
                  FlxG.switchState(new StoryMenuState());
               });
            }});
         }});
      }
		super.create();
	}
   
   override function update(elapsed:Float)
   {

      var fadeTimer:Float = 0.08;
      var upPressed = controls.UP_P;
		var downPressed = controls.DOWN_P;
		var leftPressed = controls.LEFT_P;
		var rightPressed = controls.RIGHT_P;
		var back = controls.BACK;
		var accept = controls.ACCEPT;
		#if SHADERS_ENABLED
		if (bgShader != null)
			bgShader.shader.uTime.value[0] += elapsed;
		#end
      if (DoFunnyScroll)
      {
         FlxG.camera.follow(StupidCameraFollow, 0.1);
         super.update(elapsed);
         if (back && FlxG.save.data.hasSeenCreditsMenu)
         {
            //make sure they get the epic song no matter what
            FlxG.sound.playMusic(Paths.music('theend'));
            FlxG.switchState(new StoryMenuState());
         }
         return;
      }
      switch (state)
      {
         case State.SelectingName:
			   if (upPressed)
				{
               changeSelection(-1);
				}
				if (downPressed)
				{
               changeSelection(1);
            }
				if (back)
				{
        			FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxG.switchState(new MainMenuState());
				}
				if (accept && !transitioning)
				{
               transitioning = true;
               for (creditsText in creditsTextGroup)
               {
                  FlxTween.tween(creditsText.text, {alpha: 0}, fadeTimer);
                  FlxTween.tween(creditsText.icon, {alpha: 0}, fadeTimer);
                  if (creditsText == creditsTextGroup[creditsTextGroup.length - 1])
                  {
                     FlxTween.tween(creditsText.text, {alpha: 0}, fadeTimer, 
                     {
                        onComplete: function(tween:FlxTween)
                        {
                           FlxCamera.defaultCameras = [selectPersonCam];
                           selectPerson(peopleInCredits[curNameSelected]);
                        }
                     });
                  }
               }
				}
         case State.OnName:
            if (back && !transitioning)
            {
               transitioning = true; 
        	   FlxG.sound.play(Paths.sound('cancelMenu'));
               for (item in selectedPersonGroup)
               {
                  FlxTween.tween(item, {alpha: 0}, fadeTimer);
                  if (item == selectedPersonGroup.members[selectedPersonGroup.members.length - 1])
                  {
                     FlxTween.tween(item, {alpha: 0}, fadeTimer,
                     { 
                        onComplete: function (tween:FlxTween) 
                        {
                           selectedPersonGroup.forEach(function(spr:FlxSprite)
                           {
                              remove(selectedPersonGroup.remove(spr, true));
                           });
                           for (i in 0...socialButtons.length) 
                           {
                              socialButtons.remove(socialButtons[i]);
                           }
                           FlxCamera.defaultCameras = [mainCam];
                           for (creditsText in creditsTextGroup)
                           {
                              FlxTween.tween(creditsText.text, {alpha: 1}, fadeTimer);
                              FlxTween.tween(creditsText.icon, {alpha: 1}, fadeTimer);
                              if (creditsText == creditsTextGroup[creditsTextGroup.length - 1])
                              {
                                 FlxTween.tween(creditsText.text, {alpha: 1}, fadeTimer, 
                                 {
                                    onComplete: function(tween:FlxTween)
                                    {
                                       selectedPersonGroup = new FlxSpriteGroup();
                                       socialButtons = new Array<SocialButton>();
                                       FlxG.mouse.visible = false;
                                       transitioning = false;
                                       state = State.SelectingName;
                                    }
                                 });
                              }
                           }
                        }
                     });
                  }
               }
            }
            if (hasSocialMedia)
            {
               // 2D Grid Navigation
               if (upPressed)
               {
                  changeSocialMediaSelection2D(0, -1);
               }
               if (downPressed)
               {
                  changeSocialMediaSelection2D(0, 1);
               }
               if (leftPressed)
               {
                  changeSocialMediaSelection2D(-1, 0);
               }
               if (rightPressed)
               {
                  changeSocialMediaSelection2D(1, 0);
               }
               
                if (accept && !transitioning)
                {
                    var socialButton = socialButtons[curSocialMediaSelected];
                    if (socialButton != null)
                    {
                        transitioning = true;
                        var targetLink:String = socialButton.socialMedia.socialLink;

                        for (button in socialButtons)
                        {
                            for (graphic in button.graphics)
                            {
                                if (button != socialButton)
                                {
                                    // Fade out other buttons
                                    FlxTween.tween(graphic, { alpha: 0 }, 0.8, { ease: FlxEase.quadOut });
                                }
                                else
                                {
                                    // Animate the selected button
                                    FlxG.sound.play(Paths.sound('confirmMenu'));
                                    FlxTween.tween(graphic.scale, { x: 1.25, y: 1.25 }, 0.35, {
                                        ease: FlxEase.quadOut,
                                        onComplete: function(_)
                                        {
                                            FlxTween.tween(graphic.scale, { x: 1, y: 1 }, 0.2, { ease: FlxEase.quadIn });
                                        }
                                    });

                                    // Flicker before opening
                                    FlxFlicker.flicker(graphic, 1, 0.06, false, false, function(_)
                                    {
                                        // Ensure the selected button is visible again after flicker
                                        graphic.visible = true;
                                        graphic.alpha = 1;

                                        // Open the webpage
                                        FlxG.openURL(targetLink);

                                        // Reset all buttons to normal after short delay
                                        new FlxTimer().start(0.5, function(_)
                                        {
                                            for (b in socialButtons)
                                            {
                                                for (g in b.graphics)
                                                {
                                                    // Restore visibility and normal appearance
                                                    g.visible = true;
                                                    g.alpha = 1;
                                                    g.scale.set(1, 1);
                                                    FlxTween.tween(g, { alpha: 1 }, 0.3, { ease: FlxEase.quadOut });
                                                }
                                            }
                                            transitioning = false;
                                        });
                                    });
                                }
                            }
                        }
                    }
                }
            }
      }
      
      super.update(elapsed);
   }

   function changeSelection(amount:Int = 0)
   {
      if (amount != 0)
      {
         FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
         curNameSelected += amount;
      }
      if (curNameSelected > peopleInCredits.length - 1)
      {
         curNameSelected = 0;
      }
      if (curNameSelected < 0)
      {
         curNameSelected = peopleInCredits.length - 1;
      }
      FlxG.camera.follow(menuItems[curNameSelected].text, 0.1);
      updateText(curNameSelected);
   }
   
   function changeSocialMediaSelection(amount:Int = 0)
   {
      if (amount != 0)
      {
         FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
         curSocialMediaSelected += amount;
      }
      if (curSocialMediaSelected > socialButtons.length - 1)
      {
         curSocialMediaSelected = 0;
      }
      if (curSocialMediaSelected < 0)
      {
         curSocialMediaSelected = socialButtons.length - 1;
      }
      updateSocialMediaUI();
   }
   
   function changeSocialMediaSelection2D(xDir:Int, yDir:Int)
   {
      if (xDir == 0 && yDir == 0) return;
      
      var currentRow = Std.int(curSocialMediaSelected / gridColumns);
      var currentCol = curSocialMediaSelected % gridColumns;
      
      var newRow = currentRow + yDir;
      var newCol = currentCol + xDir;
      
      // Handle wrapping for columns
      if (newCol < 0)
      {
         // Get the row we're trying to move to
         var targetRow = currentRow;
         var rowStart = targetRow * gridColumns;
         var rowEnd = Std.int(Math.min(rowStart + gridColumns, socialButtons.length));
         var rowCount = rowEnd - rowStart;
         newCol = rowCount - 1; // Wrap to last item in current row
      }
      else if (newCol >= gridColumns)
      {
         newCol = 0; // Wrap to first column
      }
      else
      {
         // Check if this column exists in the target row
         var targetIndex = newRow * gridColumns + newCol;
         if (targetIndex >= socialButtons.length || targetIndex < 0)
         {
            // If we're at the edge of a shorter row, wrap to the start of that row
            if (newCol > 0)
            {
               newCol = 0;
            }
         }
      }
      
      // Handle wrapping for rows
      if (newRow < 0)
      {
         newRow = gridRows - 1; // Wrap to last row
         // Make sure the column exists in the last row
         var lastRowStart = newRow * gridColumns;
         var lastRowEnd = socialButtons.length;
         var lastRowCount = lastRowEnd - lastRowStart;
         if (newCol >= lastRowCount)
         {
            newCol = lastRowCount - 1;
         }
      }
      else if (newRow >= gridRows)
      {
         newRow = 0; // Wrap to first row
      }
      
      var newIndex = newRow * gridColumns + newCol;
      
      // Validate the new index
      if (newIndex >= 0 && newIndex < socialButtons.length)
      {
         // Check if we're trying to move to a position that doesn't exist in this row
         var rowStart = newRow * gridColumns;
         var rowEnd = Std.int(Math.min(rowStart + gridColumns, socialButtons.length));
         
         if (newIndex >= rowStart && newIndex < rowEnd)
         {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
            curSocialMediaSelected = newIndex;
            updateSocialMediaUI();
         }
      }
   }

   function updateText(index:Int)
   {
      if (DoFunnyScroll)
      {
         return;
      }
      var currentText:FlxText = menuItems[index].text;
      if (menuItems[index].menuItem)
      {
		   currentText.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, 
            selectedFormat.borderColor);
         currentText.color = FlxColor.YELLOW;
         currentText.borderSize = selectedFormat.borderSize;
         currentText.borderQuality = selectedFormat.borderQuality;
      }
		for (i in 0...menuItems.length)
		{
         if (menuItems[i] == menuItems[curNameSelected])
         {
            continue;
         }
			var currentText:FlxText = menuItems[i].text;
         currentText.color = FlxColor.WHITE;
			currentText.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle,
				defaultFormat.borderColor);
			currentText.screenCenter(X);
		}
   }
   function updateSocialMediaUI()
   {
      if (hasSocialMedia)
      {
         for (socialButton in socialButtons)
         {
            var isCurrentSelected = socialButton == socialButtons[curSocialMediaSelected];
            if (isCurrentSelected)
            {
               fadeSocialMedia(socialButton, 1);
            }
            else
            {
               fadeSocialMedia(socialButton, 0.3);
            }
         }
      }
   }
   function fadeSocialMedia(socialButton:SocialButton, amount:Float)
   {
      for (i in 0...socialButton.graphics.length) 
      {
         var graphic:FlxSprite = socialButton.graphics[i];
         graphic.alpha = amount;
      }
   }

   function selectPerson(selectedPerson:Person)
   {
      curSocialMediaSelected = 0;
      var fadeTime:Float = 0.4;
      var blackBg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
      blackBg.screenCenter(X);
      blackBg.updateHitbox();
      blackBg.scrollFactor.set();
      blackBg.active = false;

      var personName:FlxText = new FlxText(0, 100, 0, selectedPerson.name, 50);
      personName.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      personName.screenCenter(X);
      personName.updateHitbox();
	   personName.antialiasing = true;
      personName.scrollFactor.set();
      personName.active = false;
      
      var credits:FlxText = new FlxText(0, personName.y + 50, FlxG.width / 1.25, LanguageManager.getTextString('credit_${selectedPerson.name}'), 25);
      credits.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      credits.screenCenter(X);
      credits.updateHitbox();
	  credits.antialiasing = true;
      credits.scrollFactor.set();
      credits.active = false;

      blackBg.alpha = 0;
      personName.alpha = 0;
      credits.alpha = 0;
      
      selectedPersonGroup.add(blackBg);
      selectedPersonGroup.add(personName);
      selectedPersonGroup.add(credits);

      add(blackBg);
      add(personName);
      add(credits);

      FlxTween.tween(blackBg, { alpha: 0.7 }, fadeTime);
      FlxTween.tween(personName, { alpha: 1 }, fadeTime);
      FlxTween.tween(credits, { alpha: 1 }, fadeTime, { onComplete: function(tween:FlxTween)
      {
         if (selectedPerson.socialMedia.length == 0)
         {
            transitioning = false;
            state = State.OnName;
         }
      }});
      
// Grid settings
var columns:Int = 3; // max per row
gridColumns = columns; // Store for navigation
var spacingX:Int = 150;
var spacingY:Int = 120;
var startY:Float = credits.y + 100;

// Calculate grid rows
gridRows = Math.ceil(selectedPerson.socialMedia.length / columns);

for (i in 0...selectedPerson.socialMedia.length)
{
    var social:Social = selectedPerson.socialMedia[i];

    // Row calculation
    var row:Int = Std.int(i / columns);
    var rowStart:Int = row * columns;
    var rowEnd:Int = Std.int(Math.min(rowStart + columns, selectedPerson.socialMedia.length));
    var rowCount:Int = rowEnd - rowStart;

    // Column within THIS row (not global)
    var colInRow:Int = i - rowStart;

    // Row width (so we can center it)
    var rowWidth:Float = (rowCount - 1) * spacingX;

    var socialGraphic:FlxSprite = new FlxSprite().loadGraphic(
        Paths.image('credits/socialMedia/' + social.socialMediaName)
    );

    // Position in a centered grid
    socialGraphic.x = (FlxG.width / 2.31 - rowWidth / 2.31) + colInRow * spacingX;
    socialGraphic.y = startY + row * spacingY;

    socialGraphic.updateHitbox();
    socialGraphic.scrollFactor.set();
    socialGraphic.active = false;
    socialGraphic.alpha = 0;
    add(socialGraphic);

    // Special case: Discord with text
    var discordText:FlxText = null;
    if (social.socialMediaName == 'discord')
    {
        discordText = new FlxText(socialGraphic.x + 100, socialGraphic.y, 0, social.socialLink, 40);
        discordText.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color,
            defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
        discordText.alpha = 0;
        discordText.updateHitbox();
        discordText.scrollFactor.set();
        discordText.antialiasing = true;
        discordText.active = false;
        add(discordText);
        FlxTween.tween(discordText, { alpha: 1 }, fadeTime);
        selectedPersonGroup.add(discordText);
    }

    var socialButton:SocialButton = (discordText != null)
        ? new SocialButton([socialGraphic, discordText], social)
        : new SocialButton([socialGraphic], social);

    socialButtons.push(socialButton);
    selectedPersonGroup.add(socialGraphic);

    var isCurrentSelectedButton = socialButton == socialButtons[curSocialMediaSelected];
    var targetAlpha = isCurrentSelectedButton ? 1 : 0.3;

    if (i == selectedPerson.socialMedia.length - 1)
    {
        FlxTween.tween(socialGraphic, { alpha: targetAlpha }, fadeTime, {
            onComplete: function(tween:FlxTween)
            {
                transitioning = false;
                state = State.OnName;
            }
        });
    }
    else
    {
        FlxTween.tween(socialGraphic, { alpha: targetAlpha }, fadeTime);
    }
}

      hasSocialMedia = socialButtons.length != 0;
   }
}

class Person
{
   public var name:String;
   public var creditsType:CreditsType;
	public var socialMedia:Array<Social>;

	public function new(name:String, creditsType:CreditsType, socialMedia:Array<Social>)
	{
      this.name = name;
      this.creditsType = creditsType;
      this.socialMedia = socialMedia;
	}
}
class Social
{
   public var socialMediaName:String;
   public var socialLink:String;

   public function new(socialMedia:String, socialLink:String)
   {
      this.socialMediaName = socialMedia;
      this.socialLink = socialLink;
   }
}
class CreditsText
{
   public var text:FlxText;
   public var menuItem:Bool;
   public var selectionId:Int;
   public var icon:PersonIcon;

   public function new(text:FlxText, menuItem:Bool, icon:PersonIcon)
   {
      this.text = text;
      this.menuItem = menuItem;
      this.icon = icon;
   }
}
class PersonIcon extends FlxSprite
{
   public var tracker:FlxObject;
   public var doFunnyScroll:Bool;

   public function new(tracker:FlxObject, doFunnyScroll:Bool = false)
   {
      this.tracker = tracker;
      this.doFunnyScroll = doFunnyScroll;
      super();
   }
   public override function update(elapsed:Float)
   {
      super.update(elapsed);
      if (tracker != null) 
      {
         var biggerValue = Math.max(tracker.height, height);
         var smallerValue = Math.min(tracker.height, height);

         // Move icon closer to text during DoFunnyScroll (was 20, now 10)
         var spacing = doFunnyScroll ? -130 : 20;
         setPosition(tracker.x + tracker.width + spacing, tracker.y + (smallerValue - biggerValue) / 2);
      }
   }
}
class SocialButton
{
   public var graphics:Array<FlxSprite>;
   public var socialMedia:Social;

   public function new(graphics:Array<FlxSprite>, socialMedia:Social)
   {
      this.graphics = graphics;
      this.socialMedia = socialMedia;
   }
}
enum CreditsType
{
   Dev; Translator; Contributor; BetaTester; SpecialThanks; EKACreator;
}
enum State
{
   SelectingName; OnName;
}