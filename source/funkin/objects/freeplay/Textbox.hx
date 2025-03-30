package funkin.objects.freeplay; 

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Textbox extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0){
        super(x, y);
        
        var darkorlight = ClientPrefs.data.lightMode ? 'light' : 'dark';
        var togo = 'menus/freeplay/DB/box_${darkorlight}';

        frames = Paths.getSparrowAtlas('$togo');
        animation.addByPrefix("appear", "box appear instance 1", 24, false);
        animation.addByPrefix("disappear", "box disappear instance 1", 24, false);
        animation.addByPrefix("idle", "box instance 1", 24, true);
        scale.set(0.63,0.63);
        updateHitbox();
        antialiasing = ClientPrefs.data.antialiasing;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}