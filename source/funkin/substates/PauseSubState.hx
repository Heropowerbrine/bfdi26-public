package funkin.substates;

import funkin.data.WeekData;
import funkin.data.Highscore;

import funkin.backend.Song;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxStringUtil;

import funkin.states.FreeplayState;
import funkin.states.options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var pauseMusic:FlxSound;
	var outside:FlxSprite;
	var thumbnail:FlxSprite;
	var bg:FlxSprite;
	var bf:FlxSprite;
	var pauseCam:FlxCamera;
	var canDoShit:Bool = false;
	var usingMouse:Bool = true;
	var cameraTween:FlxTween;
	var curSelected:Int = 1;
	var buttons:FlxSpriteGroup;
	final options:Array<String> = ['restart','resume','options','exit'];
	public static var songName:String = null;

	public static function cacheMenu() {
		Paths.music('breakfast');
		Paths.image('menus/pause/outside window');
		Paths.image('menus/freeplay/thumbnails/${PlayState.SONG.song}');
		Paths.image('menus/pause/bf-room');
	}

	override function create()
	{
		trace(PlayState.FUCKMYLIFE);
		pauseMusic = new FlxSound();
		pauseMusic.loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		camera = pauseCam = new FlxCamera();
    	FlxG.cameras.add(pauseCam, false);
    	pauseCam.bgColor = 0;
		pauseCam.alpha = 0;

		outside = new FlxSprite().loadImage('menus/pause/outside window');
		outside.scale.set(1.4, 1.4);
		outside.scrollFactor.set(0.3, 0.3);
		outside.x -= 700;
		outside.y -= 190;
		add(outside);

		thumbnail = new FlxSprite().loadImage('menus/freeplay/thumbnails/${PlayState.SONG.song}');
		thumbnail.alpha = 0;
		thumbnail.scale.set(0.7, 0.7);
		thumbnail.screenCenter();
		add(thumbnail);

		bg = new FlxSprite().loadImage('menus/pause/bf-room');
		bg.scale.set(1.5, 1.5);
		bg.screenCenter();
		bg.y -= 20;
		add(bg);

		buttons = new FlxSpriteGroup();
		add(buttons);
		for (k => i in options) {
			trace('${i}Hover');
			var o = new FlxSprite().loadFrames('menus/pause/buttons/buttons');
			o.addAnimByPrefix('idle','${i}Grey', 24, true);
			o.addAnimByPrefix('selected','${i}Hover', 24, true);
			o.animation.play('idle', true);
			o.updateHitbox();
			o.ID = k;

			switch(i){
				case 'exit':
					o.setPosition(1170, 250);
				case 'resume':
					o.setPosition(200, -100);
				case 'restart':
					o.setPosition(-300, 250);
				case 'options':
					o.setPosition(700, -100);
			}

			if (PlayState.FUCKMYLIFE) {
				o.x -= 150;	
			}

			buttons.add(o);
		}

		bf = new FlxSprite().loadFrames('menus/pause/bf boiling');
		bf.addAnimByPrefix('idle', 'Symbol 34 instance 1', 24, true);
		bf.animation.play('idle', true);
		bf.scale.set(1.3, 1.3);
		bf.screenCenter();
		bf.y += 710;
		add(bf);

		cameraTween = FlxTween.tween(pauseCam, {zoom: 0.5, alpha: 1}, 1, {ease: FlxEase.cubeOut, onComplete:Void->{
			FlxTween.tween(thumbnail, {alpha: 1}, 0.7, {ease: FlxEase.cubeOut, onComplete:Void->{
				canDoShit = true;
			}});
		}});

		changeSelection(0);

		super.create();
	}

	override function update(elapsed:Float)
	{	
		if (pauseMusic.volume < 1)
			pauseMusic.volume += 0.02 * elapsed;

		if(controls.BACK){
			closeMenu();
			return;
		}
		mouseMovement(elapsed);

		if (controls.UI_LEFT_P || controls.UI_RIGHT_P){
			usingMouse = false;
			changeSelection(controls.UI_LEFT_P ? -1 : 1);
		}

		for(i in buttons){ 
			final itemID = i.ID;
			final isOver = i.overlapsPoint(FlxG.mouse.getScreenPosition(pauseCam), true, pauseCam);
		
			if (isOver && curSelected != itemID && FlxG.mouse.justMoved) {
				changeSelection(itemID-curSelected);
				usingMouse = true;
			}
		
			if (isOver && i.animation.curAnim.name != 'selected') {
				i.animation.play('selected', true);
				i.offset.x = 40;
			}
			
			if (controls.ACCEPT || (FlxG.mouse.justPressed && isOver)){
				confirm(options[curSelected]);
				break;
			}
			
			if (!isOver && usingMouse){
				i.animation.play('idle', true);
				i.offset.x = 0;
			}
		}
		
		super.update(elapsed);
	}

	function mouseMovement(elapsed:Float) {
		if (!canDoShit) return;
		var mouseX = (FlxG.mouse.getScreenPosition(pauseCam).x - (FlxG.width/2)) / 14;
		var mouseY = (FlxG.mouse.getScreenPosition(pauseCam).y - (FlxG.height/2)) / 14;
	
		pauseCam.scroll.x = FlxMath.lerp(pauseCam.scroll.x, (mouseX), 1-Math.exp(-elapsed * 3));
		pauseCam.scroll.y = FlxMath.lerp(pauseCam.scroll.y, (mouseY),1-Math.exp(-elapsed * 3));
	}

	function changeSelection(ok:Int){
		if (curSelected >= 0){
			var target = buttons.members[curSelected];
			target.animation.play('idle', true);
			target.offset.x = 0;
			curSelected = FlxMath.wrap(curSelected + ok, 0, 3);
			target = buttons.members[curSelected];
			target.animation.play('selected', true);
			target.offset.x = 40;
		}
	}

	function confirm(shit:String){
		switch(shit){
			case 'resume':
				closeMenu();
			case 'restart':
				restartSong();
			case 'options':
				PlayState.instance.paused = true;
				PlayState.instance.vocals.volume = 0;

				FlxG.sound.playMusic(Paths.music('breakfast'), pauseMusic.volume);
				FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
				FlxG.sound.music.time = pauseMusic.time;

				OptionsState.onPlayState = true;
				FlxG.switchState(OptionsState.new);
			case 'exit':
				#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
				PlayState.deathCounter = 0;

				if(PlayState.SONG.song == 'yoylefake') {
					FlxG.switchState(funkin.states.NewMain.new);
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
				else {
					FlxG.switchState(FreeplayState.new);
				}
				
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;
				FlxG.camera.followLerp = 0;
		}
	}

	function closeMenu(){
		FlxTween.tween(thumbnail, {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
		canDoShit = false;
		if (cameraTween != null) cameraTween.cancel();
		cameraTween = FlxTween.tween(pauseCam, {zoom: 1.45, 'scroll.x': 0, 'scroll.y': 0}, 1, {ease: FlxEase.cubeInOut, onComplete:Void->{
			close();
		}});
	}

	override function destroy()
	{
		pauseMusic.destroy();
		super.destroy();
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true;
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;
	
		if(noTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		FlxG.resetState();
	}
}
