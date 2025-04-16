package;

#if android
import android.content.Context;
#end

//crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideo;
#end
import funkin.objects.Video4;

import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIState;
import funkin.data.Controls;
import funkin.data.ClientPrefs;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.system.ui.FlxSoundTray;
import funkin.utils.MathUtil;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import flixel.tweens.FlxEase;
import funkin.states.Title;
import flixel.input.keyboard.FlxKey;
import openfl.display.BitmapData;
import openfl.system.System;
import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import lime.graphics.Image;
import lime.system.System as LimeSystem;
import mobile.states.CopyState;

#if (linux && !debug)
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('#define GAMEMODE_AUTO')
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = Setup; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public static var fpsVar:FPSCounter;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		#if mobile
  		#if android
  		SUtil.requestPermissions();
  		#end
  		Sys.setCwd(SUtil.getStorageDirectory());
  		#end
 		mobile.backend.CrashHandler.init();

		// Credits to MAJigsaw77 (he's the og author for this code)
		//#if android
		//Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		//#elseif ios
		//Sys.setCwd(lime.system.System.applicationStorageDirectory);
		//#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	public static var game:FlxGame;

	private function setupGame():Void
	{
		#if (openfl <= "9.2.0")
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		#else
 		if (zoom == -1.0)
 			zoom = 1.0;
 		#end
		
		game = new FlxGame(gameWidth, gameHeight, #if (mobile && MODS_ALLOWED) CopyState.checkExistingFiles() ? initialState : CopyState #else initialState #end, #if(flixel < "5.0.0")zoom,#end framerate, framerate, skipSplash, startFullscreen);
		@:privateAccess game._customSoundTray = BFDISoundTray;
	
		Setup.loadSave();
		addChild(game);

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		fpsVar.visible = false;

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if android FlxG.android.preventDefaultKeys = [BACK]; #end
 
 		LimeSystem.allowScreenTimeout = ClientPrefs.data.screensaver;
		
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onFatalCrash);
		#end
		#end

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

		FlxG.signals.gameResized.add(onResize);
	}

	public static function onResize(w, h)
	{
		if (FlxG.cameras != null)
		{
			for (cam in FlxG.cameras.list)
			{
				if (cam != null && cam.filters != null) resetSpriteCache(cam.flashSprite);
			}
		}
		if (FlxG.game != null) resetSpriteCache(FlxG.game);
		
		if (fpsVar != null) #if mobile fpsVar.positionFPS(10, 3, Math.min(w / FlxG.width, h / FlxG.height)); #else fpsVar.scaleX = fpsVar.scaleY = Math.max(1, Math.min(w / FlxG.width, h / FlxG.height)); #end
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		    sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	public static function setWindowIcon(path:String):Void
	{
		var icon:Image = Image.fromFile(path);
		Lib.application.window.setIcon(icon);
	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "BFDI26_" + dateNow + ".txt";

		errMsg += '${e.error}\n';

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += 'in ${file} (line ${line})\n';
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\n\n> Crash Handler written by: squirra-rng and EliteMasterEric";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
	}

	// ELITEMASTERERIC I FUCKING LOVE YOU
	function onFatalCrash(msg:String):Void 
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "BFDI26_" + dateNow + ".txt";

		errMsg += '${msg}\n';

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += 'in ${file} (line ${line})\n';
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\n\n> Crash Handler written by: squirra-rng and EliteMasterEric";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}

class Setup extends FlxState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var mouseGraphic:BitmapData = BitmapData.fromFile('assets/shared/images/mouse.png');

	public static function loadSave()
	{
		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		funkin.data.Highscore.load();
	}

    override function create() 
    {
		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(funkin.psychlua.CallbackHandler.call)); #end

        #if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		ClientPrefs.loadPrefs();

		#if VIDEOS_ALLOWED
		funkin.objects.Video4.init();
		#end

		#if HSCRIPT_ALLOWED
		funkin.psychlua.HScript.setIrisLogger();
		#end

		if (FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;
		FlxG.switchState(Splash.new);

		super.create();
    }
}

class Splash extends MusicBeatState
{
	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;

	var video:Video4;

	override public function create():Void
	{
		_cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;
		FlxG.mouse.visible = false;

		_cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		_cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end

		new FlxTimer().start(1, function(tmr:FlxTimer){
			video = new Video4();
			video.isStateAffected = false;

			video.onFormat(()->{
				video.setGraphicSize(FlxG.width, FlxG.height);
				video.updateHitbox();
				video.antialiasing = ClientPrefs.data.antialiasing;
			});
		
			video.addSkipCallback(()->videoDone(),true);
			video.onEnd(()->videoDone(),true);
			
			if (video.load(Paths.video('intro')))
			{
				video.delayAndStart();
			}
			add(video);
		});
	}

	override function update(elapsed:Float) 
	{
		super.update(elapsed);
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function onResize(Width:Int, Height:Int):Void
	{
		super.onResize(Width, Height);
	}

	function videoDone()
	{
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end

		if (!FlxG.save.data.shitCheck) {
			FlxG.switchState(new BootFlashingState());
		}
        else {
			FlxG.switchState(new Title());
		}
	}
}

class BootFlashingState extends MusicBeatState //whatever man
{
    var allowedToSelect:Bool = false;
	var logo:FlxSkewedSprite;
	var guys:FlxSkewedSprite;

    override function create() {
		FlxG.mouse.visible = false;
        Main.fpsVar.visible = false;
		FlxG.camera.bgColor = FlxColor.BLACK;
		FlxG.camera.antialiasing = ClientPrefs.data.antialiasing;

		var text = new FlxText(0,0,FlxG.width,'WARNING');
		text.setFormat(Paths.font("flashing.ttf"), 100, FlxColor.RED);
        text.x += 10;
		text.y += 70;
        text.alpha = 0;
        add(text);

		var text2 = new FlxText(0,0,FlxG.width,"This mod contains\npossibly flashing lights\nand quick changing colors,\nso be warned!");
		text2.setFormat(Paths.font("flashing.ttf"), 70, FlxColor.WHITE, LEFT);
		text2.y += 265;
		text2.x += 20;
		text2.alpha = 0;
		add(text2);

		var text3 = new FlxText(0,0,FlxG.width,"(This mod is BEST EXPERIENCED with shaders enabled and GPU caching, fyi!)");
		text3.setFormat(Paths.font("flashing.ttf"), 25, FlxColor.WHITE, LEFT);
		text3.y += 600;
		text3.x += 20;
		text3.alpha = 0;
		add(text3);

        var enter = new FlxText(0,0,FlxG.width,"PRESS ENTER TO CONTINUE");
		enter.setFormat(Paths.font("flashing.ttf"), 70, FlxColor.WHITE);
        enter.x += 10;
		enter.y += 640;
        enter.alpha = 0;
        add(enter);

		logo = new FlxSkewedSprite(0,0,Paths.image("flashLogo"));
		logo.y = text.y - 180;
		logo.x = text.x + 960;
		add(logo);

		guys = new FlxSkewedSprite(0,0,Paths.image("flashArt"));
		guys.y = text3.y - 90;
		guys.x = text3.x + 1200;
		guys.angle = 50;
		guys.scale.set(0.75,0.75);
		add(guys);

        var twn1 = FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.quadInOut, startDelay: 1});
        var twn2 = FlxTween.tween(text2, {alpha: 1}, 2, {ease: FlxEase.quadInOut, startDelay: 2});

        twn1.then(twn2);

		new FlxTimer().start(5, Void -> {
			FlxTween.tween(logo, {y: text.y - 50}, 2, {ease: FlxEase.quadInOut});
			FlxTween.tween(guys, {y: text3.y - 230, x: text3.x + 820, angle: 0}, 2, {ease: FlxEase.quadInOut});
		});

        new FlxTimer().start(10, Void -> {
			FlxTween.tween(text3, {alpha: 0.7}, 2, {ease: FlxEase.quadInOut});
            FlxTween.tween(enter, {alpha: 1}, 2, {ease: FlxEase.quadInOut, onComplete: Void ->{allowedToSelect = true;}});
		});
		
        super.create();
    }

    var scrollTmr:Float = 0;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

		scrollTmr+= elapsed;

		final skewFactor = Math.cos(scrollTmr / 2.6 * Math.PI) / 2 + 0.5;
		logo.skew.x = -1 + skewFactor * (1 - -1);
		logo.skew.y = -1 + skewFactor * (1 - -1);

        while (scrollTmr >= 1)
        {
            scrollTmr -= 1;
			guys.skew.x = FlxG.random.float(-1, 1);
			guys.skew.y = FlxG.random.float(-1, 1);
        }

		if (controls.ACCEPT && allowedToSelect) {
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.save.data.shitCheck = true;
			allowedToSelect = false;
			FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
				Main.fpsVar.visible = ClientPrefs.data.showFPS;
				FlxG.switchState(new Title());
			});
		}
    
    }
}

class BFDISoundTray extends FlxSoundTray
{
	var graphicScale:Float = 0.30;
	var lerpYPos:Float = 0;
	var alphaTarget:Float = 0;

	var volumeMaxSound:String;

	final strings = ['cake','cakenormal','cakev','cheese','icecream','icecube','yoylefake'];

	public function new()
	{
		super();
		removeChildren();

		y = 0;
		visible = false;

		_bars = [];

		final bum = FlxG.random.getObject(strings);
		for (i in 1...11)
		{
			var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.getPath('images/soundtrays/${bum}/bar_$i.png', IMAGE)));
			bar.x = 9;
			bar.y = 5;
			bar.scaleX = graphicScale;
			bar.scaleY = graphicScale;
			bar.smoothing = ClientPrefs.data.antialiasing;
			addChild(bar);
			_bars.push(bar);
		}

		y = 0;
		alpha = 1;
		_defaultScale = 1.4;
		screenCenter();

		volumeUpSound = Paths.getPath('sounds/soundtray/Volup.${Paths.SOUND_EXT}', SOUND);
		volumeDownSound = Paths.getPath('sounds/soundtray/Voldown.${Paths.SOUND_EXT}', SOUND);
		volumeMaxSound = Paths.getPath('sounds/soundtray/VolMAX.${Paths.SOUND_EXT}', SOUND);
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	override public function show(up:Bool = false):Void
	{
		_timer = 1;
		visible = true;
		active = true;

		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);
		if (FlxG.sound.muted)
		{
			globalVolume = 0;
		}

		if (!silent)
		{
			var sound = up ? volumeUpSound : volumeDownSound;

			if (globalVolume == 10) sound = volumeMaxSound;

			if (sound != null) FlxG.sound.load(sound).play();
		}

		for (i in 0..._bars.length)
		{
			if (i < globalVolume)
			{
				_bars[i].visible = true;
			}
			else
			{
				_bars[i].visible = false;
			}
		}

		checkAntialiasing();
	}

	override public function update(MS:Float):Void
	{
		if (_timer > 0)
        {
            _timer -= (MS / 1000);
		}
		else
		{
			visible = false;
			active = false;

			#if FLX_SAVE
			if (FlxG.save.isBound)
			{
				FlxG.save.data.mute = FlxG.sound.muted;
				FlxG.save.data.volume = FlxG.sound.volume;
				FlxG.save.flush();
			}
			#end
		}
	}

	function checkAntialiasing()
	{
		if (cast(__children[0], Bitmap).smoothing != ClientPrefs.data.antialiasing)
		{
			for (child in __children)
			{
				cast(child, Bitmap).smoothing = ClientPrefs.data.antialiasing;
			}
		}
	}

	override public function screenCenter():Void
	{
		scaleX = _defaultScale;
		scaleY = _defaultScale;

		x = (0.5 * (Lib.current.stage.stageWidth - _width * _defaultScale) - FlxG.game.x);
	}
}

class FPSCounter extends Sprite
{
	public static var extraStats:Bool = #if debug true #else false #end;
	
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	
	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;
	
	@:noCompletion private var times:Array<Float>;
	
	var textDisplay:TextField;
	var underlay:Bitmap;

	var memPeak:Float = 0;
	
	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();
		this.x = x;
		this.y = y;

		underlay = new Bitmap();
		underlay.bitmapData = new BitmapData(1, 1, true, 0x6F000000);
		underlay.alpha = 0.5;
		addChild(underlay);
		
		textDisplay = new TextField();
		textDisplay.defaultTextFormat = new TextFormat("flashing.ttf", 11, color);
		textDisplay.text = "FPS: ";
		textDisplay.selectable = false;
		textDisplay.mouseEnabled = false;
		textDisplay.autoSize = LEFT;
		textDisplay.multiline = true;
		addChild(textDisplay);
		
		currentFPS = 0;
		
		times = [];
	}
	
	var deltaTimeout:Float = 0.0;
	
	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{

		if (FlxG.keys.justPressed.F3)
		{
			extraStats = !extraStats;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000)
			times.shift();
			
		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 100)
		{
			deltaTimeout += deltaTime;
			return;
		}
			
		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		updateText();
		
		deltaTimeout = 0.0;

		if (underlay.alpha == 0) return;
		
		underlay.width = textDisplay.width + 5;
		underlay.height = textDisplay.height;
	}
	
	public function updateText():Void
	{
		memPeak = Math.max(memPeak,memoryMegas);
		textDisplay.text = 'FPS: ' + currentFPS + '\nMemory: ' + flixel.util.FlxStringUtil.formatBytes(memoryMegas).toLowerCase() + ' / ' + flixel.util.FlxStringUtil.formatBytes(memPeak).toLowerCase();

		#if debug
		if (extraStats)
		{
			textDisplay.text += getBeatStateInfo();
			textDisplay.text += getPlayStateInfo();
		}
		#end
		
		textDisplay.textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5) textDisplay.textColor = 0xFFFF0000;
	}
	
	inline function get_memoryMegas():UInt return cast #if (openfl < "9.4.0") System.totalMemory #else System.totalMemoryNumber #end;
	
	#if debug
	@:access(funkin.backend.MusicBeatState)
	function getBeatStateInfo()
	{
		var curStep = '';
		var curBeat = '';
		var curSec = '';
		
		if (Std.isOfType(FlxG.state, MusicBeatState))
		{
			curStep = '\nStep: ${cast (FlxG.state, MusicBeatState).curStep}\n';
			curBeat = 'Beat: ${cast (FlxG.state, MusicBeatState).curBeat}\n';
			curSec = 'Section: ${cast (FlxG.state, MusicBeatState).curSection}\n';
		}
		
		return '$curStep$curBeat$curSec';
	}
	
	function getPlayStateInfo()
	{
		var ext:String = '';

		if (Std.isOfType(FlxG.state, PlayState) && PlayState.instance != null)
		{

			var curTime:String = flixel.util.FlxStringUtil.formatTime(Math.floor(Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset) / 1000), false);
			var totalTime = FlxG.sound.music != null ? '/${flixel.util.FlxStringUtil.formatTime(FlxG.sound.music.length / 1000)}' : '';
			ext = '\nSong Time: $curTime$totalTime';


			if (isBotplay()) ext += '\nBotplay';
		}
		
		return ext;
	}
	#end

	inline function isBotplay() return PlayState.instance != null && PlayState.instance.cpuControlled;
}
