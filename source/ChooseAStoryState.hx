package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

class ChooseAStoryState extends MusicBeatState
{
    var curSelected:Int = 0;
    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['chapter one', 'chapter two'];

    var curOptText:FlxText;

    override function create()
    {
        // Background
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        // Title
        var title:FlxText = new FlxText(0, 50, FlxG.width, "CHAPTER SELECT");
        title.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        title.scrollFactor.set();
        add(title);

        // Big buttons
        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);

        for (i in 0...optionShit.length)
        {
            var menuItem:FlxText = new FlxText(0, 0, 0, optionShit[i].toUpperCase());
            menuItem.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            menuItem.antialiasing = true;
            menuItem.ID = i;
            menuItem.scrollFactor.set();
            menuItem.screenCenter(X);
            menuItem.y = FlxG.height / 2 + (i * 100);
            menuItems.add(menuItem);
        }

        curOptText = new FlxText(0, FlxG.height - 50, FlxG.width, "");
        curOptText.setFormat("Comic Sans MS Bold", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        curOptText.scrollFactor.set();
        add(curOptText);

        changeItem();
        super.create();
    }

    override function update(elapsed:Float)
    {
        if (controls.UP_P)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            changeItem(-1);
        }
        if (controls.DOWN_P)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            changeItem(1);
        }

        if (controls.BACK)
        {
            FlxG.switchState(new MainMenuState());
        }

        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            var daChoice:String = optionShit[curSelected];
            switch (daChoice)
            {
                case 'chapter one':
                    FlxG.switchState(new StoryMenuState());
                case 'chapter two':
                    FlxG.switchState(new StoryMenuAltState());
            }
        }

        super.update(elapsed);
    }

    function changeItem(huh:Int = 0)
    {
        curSelected += huh;
        if (curSelected >= optionShit.length) curSelected = 0;
        if (curSelected < 0) curSelected = optionShit.length - 1;

        menuItems.forEach(function(spr:FlxSprite)
        {
            if (spr.ID == curSelected)
                cast(spr, FlxText).borderColor = FlxColor.YELLOW;
            else
                cast(spr, FlxText).borderColor = FlxColor.BLACK;
        });

        curOptText.text = 'Press ENTER to start ' + optionShit[curSelected];
    }
}
