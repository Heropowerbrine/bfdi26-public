package funkin.states;

import flixel.addons.transition.FlxTransitionableState;

class CharacterUnlock extends MusicBeatState
{
	var popupName:String;
	var spr:FlxSprite;
	var can:Bool = false;

	public function new(?char:String)
	{
		if (char != null) popupName = 'play${char}';
		super();
	}

	override function create()
	{
		var blackbg = new FlxSprite(0,0).generateGraphic(FlxG.width, FlxG.height);
		blackbg.screenCenter();
		blackbg.scrollFactor.set();
		blackbg.color = FlxColor.BLACK;
		add(blackbg);

		spr = new FlxSprite().loadImage('menus/freeplay/popups/${popupName}');
		spr.scale.set(0.3,0.3);
		spr.alpha = 0;
		spr.screenCenter();
		spr.y += 10;
		spr.antialiasing = ClientPrefs.data.antialiasing;
		add(spr);

		FlxG.sound.play(Paths.sound('drumroll'));
		FlxTween.tween(spr, {alpha: 1, 'scale.x': 0.9, 'scale.y': 0.9}, 1, {ease: FlxEase.backOut,startDelay: 3.6, onComplete:Void->{
			can = true;
		}});

		super.create();
	}

	override function update(elapsed:Float)
	{	
		if (controls.ACCEPT && can) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxG.switchState(funkin.states.FreeplayState.new);
		}
		super.update(elapsed);
	}

	override function destroy()
	{
		super.destroy();
	}
}
