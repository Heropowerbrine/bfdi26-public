package funkin.states;

import funkin.data.WeekData;
import funkin.data.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

import Main;
import flixel.addons.display.FlxBackdrop;

class Title extends MusicBeatState
{
	var logoBl:FlxSprite;
	var transitioning:Bool = true;
	var cam:FlxCamera;

	override public function create():Void
	{
		Paths.clearStoredMemory();

		super.create();

		persistentUpdate = persistentDraw = true;
		#if !mobile
		if (Main.fpsVar != null && !Main.fpsVar.visible) {
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
		}
		#end

		FlxG.mouse.visible = true;
		FlxG.mouse.load(Main.Setup.mouseGraphic,0.1);

		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(5, 0, 0.8);

			FlxG.sound.music.pitch = FlxG.random.float(0.6, 1.2);
			FlxTween.tween(FlxG.sound.music, {pitch: 1}, 3, {ease: FlxEase.cubeOut});
		}

		cam = quickCreateCam();
		cam.alpha = 0;

		FlxG.camera.flash(FlxColor.BLACK,1);
		FlxG.camera.zoom += 1;
		FlxG.camera.y = FlxG.camera.y + 700;

		FlxTween.tween(FlxG.camera, {y: FlxG.camera.y - 700}, 4, {ease: FlxEase.cubeOut});
		FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.cubeOut});
		FlxTween.tween(cam, {alpha: 1}, 1, {ease: FlxEase.cubeOut, startDelay: 2, onComplete:Void -> {
			transitioning = false;
		}});

		var bg = new FlxBackdrop(Paths.image('recoverycenters'),X,0,0);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.screenCenter();
		bg.y += 20;

		bg.velocity.x = (FlxG.random.bool(50) ? FlxG.random.int(-15,-100) : FlxG.random.int(15,100));
		bg.scrollFactor.set();
		add(bg);

		logoBl = new FlxSprite(-10,-20);
		logoBl.scale.set(0.35,0.35);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logoBumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.cameras = [cam];
		add(logoBl);

		var titleText = new FlxSprite(125,635);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.cameras = [cam];
		add(titleText);

		Conductor.bpm = 102;
		Paths.clearUnusedMemory();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

		if (!transitioning && controls.ACCEPT)
		{
			transitioning = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTween.tween(cam, {alpha: 0}, 2, {ease: FlxEase.cubeOut});
			FlxTween.tween(FlxG.camera, {y: FlxG.camera.y - 600}, 3, {ease: FlxEase.cubeOut});
			new FlxTimer().start(2,Void->{
				FlxG.switchState(funkin.states.NewMain.new);
			});
		}
		
		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null)
			logoBl.animation.play('bump', true);
	}

	function quickCreateCam(defDraw:Bool = false):FlxCamera
	{
		var camera = new FlxCamera();
		camera.bgColor = 0x0;
		FlxG.cameras.add(camera,defDraw);
		return camera;
	}
}
