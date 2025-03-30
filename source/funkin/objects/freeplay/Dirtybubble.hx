package funkin.objects.freeplay;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxBasic;
import flixel.FlxObject;

//use the atlas and recode later 
class Dirtybubble extends FlxSprite
{
    public var talking:Bool = false;
    public var blinking:Bool = false; //temp
    public var notblinking:Bool = false;
    var bubble:Dirtybubble;

    public function new(x:Float,y:Float){
        super(x, y);
        
        frames = Paths.getSparrowAtlas('menus/freeplay/DB/db factoid');

        animation.addByPrefix("idle", "db idle instance 1", 24, true);
        animation.addByPrefix("idleBlink", "db idle blinker instance 1", 24, false);
        animation.addByPrefix("idleAlt", "db idle lalala instance 1", 24, true);

        animation.addByPrefix("talk", "db talk idle instance 1", 24, true);
        animation.addByPrefix("toTalk", "db transition to talk instance 1", 20, false);
        animation.addByPrefix("toIdle", "db transition to idle instance 1", 20, false);
        animation.play('idle');
        antialiasing = ClientPrefs.data.antialiasing;
        scale.set(0.7,0.7);
    }

    var blink:Float = FlxG.random.int(3,7); 
    var lala:Float = FlxG.random.int(30,200); 
    override function update(elapsed:Float)
    {
        if (!talking) {
            if (!notblinking) {
                blink -= elapsed;
                if (blink <= 0)
				{
                    blinking = true;
                    animation.play('idleBlink');
                    animation.finishCallback = (penis:String)->{
                        if (penis == 'idleBlink') {
                            blinking = false;
                            animation.play('idle');
                            blink = FlxG.random.int(3,7);
                        }
                    }
				}
            }

            if (!blinking) {
                lala -= elapsed;
                if (lala <= 0)
				{
                    notblinking = true;
                    animation.play('idleAlt');
                    FlxTimer.wait(30, ()->{
                        notblinking = false;
                        animation.play('idle');
                        lala = FlxG.random.int(30,50);
					});
				}
            }
        }
        super.update(elapsed);
    }

    public function talkingThing(state:String) {
        talking = true;
        switch (state) {
            case 'talk':
                animation.play('toTalk');
                offset.set(10, 0);
                animation.finishCallback = (penis:String)->{
                    if (penis == 'toTalk') {
                        animation.play('talk');
                        offset.set(24, 4);
                    }
                }
            case 'idle':
                animation.play('toIdle');
                offset.set(10, 0);
                animation.finishCallback = (penis:String)->{
                    if (penis == 'toIdle') {
                        talking = false;
                        animation.play('idle');
                        offset.set(0, 0);
                    }
                }
        }
    }
}