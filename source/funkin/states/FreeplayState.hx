package funkin.states;

import funkin.backend.Song;

import funkin.data.WeekData;
import funkin.data.Highscore;

import funkin.data.Progress;
import Main;

import flixel.math.FlxMath;
import flixel.group.FlxContainer;
import flixel.util.FlxStringUtil;

import funkin.substates.GameplayChangersSubstate;
import flixel.input.mouse.FlxMouseEvent;

import flixel.util.FlxGradient;

import flixel.addons.text.FlxTypeText;
import funkin.objects.freeplay.Dirtybubble;
import funkin.objects.freeplay.Textbox;
import flixel.system.FlxAssets;

import funkin.objects.AttachedSprite;

import flixel.addons.effects.FlxSkewedSprite;

import sys.FileSystem;
import sys.io.File;

import Sys;
import sys.io.Process;
import lime.app.Application;

//this menu is such a fucking mess //rlly need to optimize

//okay todo
// add swap for blue golfball and oneshot
// use atlas for dirtybubble
// add gradietn bg
// optimize and rewrite some code? cuz its really bad rn
class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMeta> = [];
	var curSelected:Int = 0;
	public static var vocals:FlxSound = null;

	var imgs:FlxTypedGroup<FlxSprite>;
	var tokens:FlxTypedGroup<FlxSprite>;
	var names:FlxTypedGroup<FlxText>;
	var score:FlxTypedGroup<FlxText>;

	var scrollY:Float;
	var scrollBar:FlxSprite;
	var canScroll:Bool = true;

	var playedASongBefore:Bool = false;
	var hasPlayedBefore:Bool;
	var resetData:Bool;

	//i dont really like how this is done but wtv
	function generateThumbnails(reset:Bool) {
		WeekData.reloadWeekFiles(false);

		for (i in 0...WeekData.weeksList.length)
		{
			final curWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			WeekData.setDirectoryFromWeek(curWeek);

			for (song in curWeek.songs)
			{
                songs.push({
                    sn: song[0],
                    week: song[1],
                    folder: Mods.currentModDirectory
                });
			}
		}
		Mods.loadTopMod();

		var spacingX:Int = 240;
		var spacingY:Int = 220;

        imgs = new FlxTypedGroup<FlxSprite>();
		tokens = new FlxTypedGroup<FlxSprite>();
		names = new FlxTypedGroup<FlxText>();
		score = new FlxTypedGroup<FlxText>();

        for (k => i in songs) {
			var thing = Highscore.getSongData(songs[k].sn,1);

			#if !debug
			if (!FlxG.save.data.welcome2) {
				if (thing.songScore > 0) {
					playedASongBefore = true;
				}
			}
			#end

			if (reset == true) { //not proper data reset but whatever
				if (thing.songScore > 0) {
					thing.songScore = 0;

					Progress.isWebCrashed = false;
					Progress.isOneshotUnlocked = false;
					Progress.isDataReset = false;
				}
			}

            var thumbnails = new FlxSprite(((k % 4) * spacingX) + 160, (Std.int(k / 4) * spacingY) + 120).loadImage('menus/freeplay/thumbnails/${i.sn}');
			var shit = Std.int(thumbnails.width * 0.17);

			if (thing.songScore <= 0){
				thumbnails.loadFrames('menus/freeplay/thumbnails/unknown');
				thumbnails.addAnimByPrefix('i', 'unknown', 24, true);
				thumbnails.animation.play('i');
			}

			if (i.sn == 'oneshot' && !Progress.isOneshotUnlocked) thumbnails.loadImage('menus/freeplay/thumbnails/secret');
			if (i.sn == 'web-crasher' && !Progress.isWebCrashed) thumbnails.loadImage('menus/freeplay/thumbnails/secret');

			thumbnails.setGraphicSize(shit);
			thumbnails.updateHitbox();
			thumbnails.ID = k;
			thumbnails.antialiasing = ClientPrefs.data.antialiasing;
            imgs.add(thumbnails);

			var token = ClientPrefs.data.lightMode ? 'light' : 'dark';
			final path = 'menus/freeplay/freeplaytokensnew_${token}';

			var tokenSprites = new FlxSprite(((k % 4) * spacingX) + 160, (Std.int(k / 4) * spacingY) + 257).loadFrames(path);
			tokenSprites.addAnimByPrefix('empty', 'no token instance 1', 20, true);
			tokenSprites.addAnimByPrefix('normal', 'win token instance 1', 20, true);
			tokenSprites.addAnimByPrefix('gold', 'gold token instance 1', 20, true);

			if (thing.songScore > 0){
				switch(thing.songFC){
					case SDCB, FC:
						tokenSprites.animation.play('normal');
					case GFC, PFC:
						tokenSprites.animation.play('gold');
				}
			} else tokenSprites.animation.play('empty');

			tokenSprites.setGraphicSize(Std.int(tokenSprites.width * 0.5));
			tokenSprites.updateHitbox();
			tokenSprites.antialiasing = ClientPrefs.data.antialiasing;
            tokens.add(tokenSprites);

			var namesText = new FlxText(((k % 4) * spacingX) + 210, (Std.int(k / 4) * spacingY) + 250, 0, FlxStringUtil.toTitleCase(StringTools.replace(i.sn, "-", " ")), 10);
			if (thing.songScore <= 0) namesText.text = '???';
			namesText.setFormat(Paths.font("Roboto-Regular.ttf"), 22, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE);
			namesText.antialiasing = ClientPrefs.data.antialiasing;
            names.add(namesText);

			var scoreText = new FlxText(((k % 4) * spacingX) + 210, (Std.int(k / 4) * spacingY) + 277, 0, Std.string(thing.songScore), 5);
			scoreText.setFormat(Paths.font("Roboto-Regular.ttf"), 18, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE);
			scoreText.antialiasing = ClientPrefs.data.antialiasing;
            score.add(scoreText);
        }

		add(tokens);
		add(names);
		add(score);
		add(imgs);
	}

	var settings:FlxSprite;
	var load:FlxSprite;
	var screen:FlxSprite;

	var blackbg:FlxSprite;
	override function create()
	{
		FlxG.camera.bgColor = ClientPrefs.data.lightMode ? 0xFFe0e0e0 : 0xFF121212;
		FlxG.sound.playMusic(Paths.music('freeplayMenu'), 1);
		FlxG.mouse.visible = true;
		FlxG.mouse.load(Main.Setup.mouseGraphic,0.1);
		
		Paths.clearStoredMemory();
		DiscordClient.changePresence("BFDI 26 - BROWSING THE WEB", null);

		if (Progress.isDataReset) generateThumbnails(true);
		else generateThumbnails(false);

		hasPlayedBefore = (!FlxG.save.data.welcome2 && FileSystem.isDirectory(Sys.getEnv("AppData") + "/BFDI26/BFDI26") #if !debug && playedASongBefore #end);
		trace(hasPlayedBefore);

        var poop = new FlxSprite().loadImage('menus/freeplay/poopium ${ClientPrefs.data.lightMode ? 'light' : 'dark'}');
		poop.x = FlxG.width - 1270;
		poop.y = imgs.members[0].y - 100;
		add(poop);
		poop.antialiasing = ClientPrefs.data.antialiasing;
		poop.setScale(0.5);

	    settings = new FlxSprite().loadImage('menus/freeplay/settings');
		settings.x = FlxG.width - 100;
		settings.y = imgs.members[0].y - 80;
		add(settings);
		settings.antialiasing = ClientPrefs.data.antialiasing;
		settings.setScale(0.13);
		settings.color = ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE;

		FlxMouseEvent.add(settings,(settings)->{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		},null,null,null,false,true,false);

		var end = new FlxSprite().loadImage('menus/freeplay/end');
		end.screenCenter();
		end.y = imgs.members[16].y + 700;
		add(end);
		end.antialiasing = ClientPrefs.data.antialiasing;

		scrollBar = new FlxSprite(0, 0).generateGraphic(15,250);
		scrollBar.screenCenter();
		scrollBar.x = FlxG.width - 15;
		scrollBar.alpha = 0;
		FlxTween.tween(scrollBar, {alpha: 1},1, {ease: FlxEase.circOut, startDelay: .3});
		add(scrollBar);
		scrollBar.scrollFactor.set();
		scrollBar.color = ClientPrefs.data.lightMode ? 0xFF878787 : 0xFF666666;
		
		Paths.clearUnusedMemory();

		super.create();

		screen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        screen.scale.set(FlxG.width, FlxG.height);
        screen.updateHitbox();
        screen.alpha = 0;
        screen.scrollFactor.set();
        add(screen);

		load = new FlxSprite().loadImage('menus/freeplay/load');
		load.scrollFactor.set();
		load.setScale(0.4);
		load.screenCenter();
		load.alpha = 0;
		add(load);

		blackbg = new FlxSprite(0,0).generateGraphic(FlxG.width, FlxG.height);
		blackbg.screenCenter();
		blackbg.scrollFactor.set();
		blackbg.color = FlxColor.BLACK;
		blackbg.alpha = 0;
		add(blackbg);

		if (hasPlayedBefore) {
			hi();
		}
		if (!hasPlayedBefore && !FlxG.save.data.welcome2) {
			hi2();
		}

		#if debug
		var debugName = new FlxText(0, 0, FlxG.width, 'debug', 36);
		debugName.screenCenter(Y);
		debugName.scrollFactor.set();
		add(debugName);
		FlxMouseEvent.add(debugName,(debugName)->{
			if (FlxG.save.data.welcome2) FlxG.save.data.welcome2 = false; 
			if (Progress.isDataReset) Progress.isDataReset = false;
			FlxG.resetState();
		},null,null,null,false,true,false);
		#end
	}

	function hi() {
		blackbg.alpha = 1;
		canScroll = false;
		var clickedYet:Bool = false;

		FlxG.sound.music.pitch = FlxG.random.float(0.2, 0.8);
		FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3},1.2, {ease: FlxEase.circOut, startDelay: 0.5});

		var data = new FlxSprite().loadImage('menus/freeplay/popups/data');
		data.screenCenter();
		data.scrollFactor.set();
		add(data);

		var bomb = new FlxSkewedSprite(360,90,Paths.image("menus/freeplay/popups/bomby"));
		bomb.scale.set(0.9,0.9);
		add(bomb);

		var reset = new FlxSprite().loadImage('menus/freeplay/popups/reset');
		reset.screenCenter();
		reset.y += 240;
		reset.x += 135;
		reset.scrollFactor.set();
		add(reset);

		var keep = new FlxSprite().loadImage('menus/freeplay/popups/keep');
		keep.screenCenter();
		keep.y += 240;
		keep.x -= 135;
		keep.scrollFactor.set();
		add(keep);

		for (i in [data,bomb,reset,keep]) {
			i.alpha = 0;
			FlxTween.tween(i, {alpha: 1},1.2, {ease: FlxEase.circOut, startDelay: 0.5});
		}

		FlxMouseEvent.add(reset,(r)->{
			if (clickedYet) {
				for (i in [data,bomb,reset,keep]) {
					FlxTween.tween(i, {y: 800, alpha: 0},1.2, {ease: FlxEase.circOut,onComplete:Void->{
						data.destroy();
						bomb.destroy();
						reset.destroy();
						keep.destroy();
					}});
				}

				hi2();
			}
			else {
				clickedYet = true;
				resetData = true;
				reset.alpha = 0;
				FlxG.sound.play(Paths.sound('fuckyou'));
			}
		},null,(r)->reset.scale.set(1.1,1.1),(r)->reset.scale.set(1,1),false,true,false);

		FlxMouseEvent.add(keep,(k)->{
			if (clickedYet) {
				for (i in [data,bomb,reset,keep]) {
					FlxTween.tween(i, {y: 800, alpha: 0},1.2, {ease: FlxEase.circOut,onComplete:Void->{
						data.destroy();
						bomb.destroy();
						reset.destroy();
						keep.destroy();
					}});
				}

				hi2();
			}
			else {
				clickedYet = true;
				keep.alpha = 0;
				FlxG.sound.play(Paths.sound('fuckyou'));
			}
		},null,(k)->keep.scale.set(1.1,1.1),(k)->keep.scale.set(1,1),false,true,false);
	}

	function hi2() {
		if (canScroll) {
			canScroll = false;
			FlxG.sound.music.pitch = FlxG.random.float(0.2, 0.8);
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3},1.2, {ease: FlxEase.circOut, startDelay: 1.5});
			blackbg.alpha = 1;
		}

		var img = new FlxSprite().loadImage('menus/freeplay/popups/welcome');
		img.screenCenter();
		img.y -= 30;
		img.alpha = 0;
		img.scrollFactor.set();
		add(img);

		var clcik = new AttachedSprite('menus/freeplay/popups/x');
		clcik.sprTracker = img;
		clcik.xAdd = 465;
		clcik.copyAlpha = true;
		add(clcik);

		FlxTween.tween(img, {y: img.y + 30, alpha: 1},1.2, {ease: FlxEase.circOut, startDelay: 2.2});

		FlxMouseEvent.add(clcik,(s)->{
			FlxTween.tween(img, {y: 600, angle: -6, alpha: 0},0.8, {ease: FlxEase.quadOut,onComplete:Void->{
				canScroll = true;
				img.destroy();
				clcik.destroy();
			}});

			FlxG.save.data.welcome2 = true;
			if (!resetData) {
				FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.3},1.4, {ease: FlxEase.quadOut});
				FlxTween.tween(FlxG.sound.music, {pitch: 1},1.2, {ease: FlxEase.quadOut});
				FlxTween.tween(blackbg, {alpha: 0},1.2, {ease: FlxEase.circOut, onComplete:Void->{
					blackbg.kill();
				}});
			} else {
				FlxTween.tween(FlxG.sound.music, {pitch: 0},1.2, {ease: FlxEase.quadOut, onComplete:Void-> {
					FlxG.resetState();
					Progress.isDataReset = true;
				}});
			}
			FlxMouseEvent.remove(clcik);
		},null,null,null,false,true,false);
	}

	var selected:Bool = false;
	var thumbCam:FlxCamera;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		
		final thing = Highscore.getSongData(songs[curSelected].sn,1);

		load.angle += (elapsed*40)-3;
		
		if (canScroll) 
		{
			if (FlxG.mouse.wheel != 0) {
				scrollY += -FlxG.mouse.wheel * 40;
				scrollY = Math.max(0, Math.min(scrollY, 1600));
			}
			
			FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, scrollY, 0.07);
			scrollBar.y = FlxMath.lerp(scrollBar.y, scrollY/3.36, 0.10);

			for (thumbnails in imgs.members) 
			{
				if (!selected) {
					if (FlxG.mouse.overlaps(thumbnails) && curSelected != thumbnails.ID) {
						changeSelection(thumbnails.ID - curSelected);
					}
				}
	
				if (FlxG.mouse.overlaps(thumbnails) && !selected && (controls.ACCEPT || FlxG.mouse.justPressed)) 
				{
					if ((songs[curSelected].sn == 'web-crasher' && !Progress.isWebCrashed) || songs[curSelected].sn == 'oneshot' && !Progress.isOneshotUnlocked) {
						FlxG.sound.play(Paths.sound('scr'));
						FlxG.camera.zoom += 0.05;
						FlxTween.cancelTweensOf(FlxG.camera, ['zoom']); 
						FlxTween.tween(FlxG.camera, {zoom: 1}, 0.4, {ease: FlxEase.circOut});
						FlxG.camera.flash(FlxColor.BLACK,0.5,null,true);
					} 
					else {
						if (thing.songScore > 0) 
						{
							var value = FlxG.random.int(1,4);
							selected = true;
							load.visible = true;
							load.alpha = 0;
							FlxTimer.wait(value, ()->{
								var thumb = new SelectedThumb(this);
								thumbCam = quickCreateCam();
								thumb.cameras = [thumbCam];	
								add(thumb);
								load.visible = false;
							});
							FlxTween.tween(load, {alpha: 1},1.2, {ease: FlxEase.linear});
							FlxTween.tween(screen, {alpha: 1},0.9, {ease: FlxEase.linear});
						}
						else 
						{
							loadSong(songs[curSelected].sn);
						}
					}
				}
			}
		}

		if (controls.BACK && canScroll) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(funkin.states.NewMain.new);
			FlxMouseEvent.remove(settings);
		}

		super.update(elapsed);
	}

	function loadSong(songToLoad:String){
		if (songs[curSelected].sn == 'web-crasher' || songs[curSelected].sn == 'himsheys')
			if (FlxG.fullscreen) FlxG.fullscreen = false;

		if (songs[curSelected].sn == 'himsheys') {
			var himsheys = FlxG.random.int(1,5); //the 4:3 script resets tue songs and causes whatever song you were gonna play via the lua stage to be gone
			if (himsheys == 1) songToLoad = 'himsheys-tird';
		}

		var formatedSong = Paths.formatToSongPath(songToLoad);
		var diffFormatting = Highscore.formatSong(formatedSong, 1);
		
		FlxG.camera.fade(FlxColor.BLACK, 1, false);
		FlxTween.tween(FlxG.sound.music, {pitch: 0, volume: 10}, 1, {ease: FlxEase.quadOut});
		FlxTween.tween(FlxG.camera, {zoom: 1.5, angle: 2}, 1, {ease: FlxEase.cubeIn, onComplete:Void->{
			try
			{
				PlayState.SONG = funkin.backend.Song.loadFromJson(diffFormatting, formatedSong);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 1;
			}
			catch (e:Dynamic)
			{
				trace('fuck. $e');
				FlxG.sound.play(Paths.sound('cancelMenu'));
				return;
			}
	
			FlxG.switchState(PlayState.new);
		}});
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeSelection(ok:Int) curSelected = FlxMath.wrap(curSelected + ok, 0, imgs.length-1);

	override function destroy():Void
	{
		FlxMouseEvent.remove(settings);
		super.destroy();
		FlxG.autoPause = ClientPrefs.data.autoPause;
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}	

	function quickCreateCam(defDraw:Bool = false):FlxCamera
	{
		var camera = new FlxCamera();
		camera.bgColor = 0x0;
		FlxG.cameras.add(camera,defDraw);
		return camera;
	}
}
typedef SongMeta = {sn:String,week:Int,folder:String} 

//this is bad but im lazy
@:access(funkin.states.FreeplayState)
class SelectedThumb extends FlxTypedSpriteGroup<FlxSprite> {
    var parent:FreeplayState;
    var test:FlxSprite;
	var settings:FlxSprite;
	var swap:FlxSprite;
	var can:Bool = true;

	var canCycle:Bool = false;
	var otherSong:String = '';
	var songName:String = '';

	var noteInfo:FlxText;
	var songInfo:FlxText;

	var sn:FlxText;
	var credTxt:FlxText;

	var bubble:Dirtybubble;
	var box:Textbox;
	var text:FlxTypeText;

	var funfact:String = '';
	var ratingSplit:Array<String>;
	var credits:String = '';

	var popup:FlxSprite;
	var isWebCrasher:Bool = false;
	var webSound:FlxSound;

	public function new(parent) {
		this.parent = parent;
		super();

        parent.canScroll = false;

		songName = parent.songs[parent.curSelected].sn;
		canCycle = ((songName == 'oneshot' && Progress.isUnlockedSour) || (songName == 'blue-golfball' && Progress.isUnlockedHatty));
		switch(songName){
			case 'oneshot': otherSong = 'oneshot-pico';
			case 'blue-golfball': otherSong = 'blue-golfball-bf';
		}

		var data = Highscore.getSongData(songName,1);

		var score = Std.string(data.songScore);
		var acc = data.songRating;

		var token = ClientPrefs.data.lightMode ? 'light' : 'dark';
		final path = 'menus/freeplay/bigtoken_${token}';

        var expandedBg = new FlxSprite(0,0).generateGraphic(FlxG.width, FlxG.height);
		expandedBg.screenCenter();
		expandedBg.scrollFactor.set();
		expandedBg.color = ClientPrefs.data.lightMode ? 0xFFe0e0e0 : 0xFF121212;
		add(expandedBg);

        test = new FlxSprite().loadImage('menus/freeplay/thumbnails/' + songName);
		test.scale.set(0.64,0.64);
		test.x = 50;
		test.y = 70;
		add(test);
		test.updateHitbox();

		var frame = new FlxSprite().loadImage('menus/freeplay/frame');
		frame.scale.set(0.64,0.64);
		frame.x = test.x - 7;
		frame.y = test.y - 11;
		add(frame);
		frame.updateHitbox();
		if (data.songFC != PFC) frame.color = ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE;
		else frame.color = 0xFFF4C52C;

		if (canCycle){
			swap = new FlxSprite(65, 430);
			swap.scale.set(0.85,0.85);
			swap.antialiasing = ClientPrefs.data.antialiasing;
			swap.frames = Paths.getSparrowAtlas('menus/freeplay/swap_${token}');
			swap.animation.addByPrefix("idle", "swap stationary instance 1", 24, true);
			swap.animation.addByPrefix("spin", "swap spin instance 1", 24, false);
			add(swap);
			swap.updateHitbox();
			swap.animation.finishCallback = (a)->{
				if (a == 'spawn') 
					swap.animation.play('idle');
			}

			var tabTxt = new FlxText(680, 18, 0, "Press [TAB] to switch character mixes!").setFormat(Paths.font("Shag-Lounge.otf"), 35, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE, CENTER);
			tabTxt.alpha = 0.5;
			add(tabTxt);
		}

		ratingSplit = Std.string(CoolUtil.floorDecimal(acc * 100, 2)).split('.');
		if (ratingSplit.length < 2) // no decimals, add an empty space
		{
			ratingSplit.push('');
		}
		
		while (ratingSplit[1].length < 2) // less than 2 decimals in it, add decimals then
		{
			ratingSplit[1] += '0';
		}

		songInfo = new FlxText(FlxG.width-400, 145, 0, "").setFormat(Paths.font("Shag-Lounge.otf"), 45, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE, CENTER);
		songInfo.text = 'Score: $score\nAccuracy: ${ratingSplit.join('.')}%';
		add(songInfo);

		if (data.sick > 0) {
			noteInfo = new FlxText().setFormat(Paths.font("Shag-Lounge.otf"), 40, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE, LEFT);
			noteInfo.text = '\n\nOMGs: ${data.sick}\nYOYs: ${data.good}\nOKs: ${data.bad}\nPLEHs: ${data.shit}';
			songInfo.text += noteInfo.text;
	    }

		sn = new FlxText(FlxG.width-1130, 570, 0, "").setFormat(Paths.font("Shag-Lounge.otf"), 60, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE, LEFT);
		sn.text = FlxStringUtil.toTitleCase(StringTools.replace(songName, "-", " "));
		add(sn);

		if (Paths.fileExists('images/menus/freeplay/thumbnails/text/'+songName+'/composer.txt',TEXT)) {
			credits = Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+songName+'/composer.txt');

			credTxt = new FlxText().setFormat(Paths.font("Shag-Lounge.otf"), 30, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE, LEFT);
			credTxt.text = '\n$credits';
			credTxt.x = sn.x + 2;
			credTxt.y = sn.y + 30;
			add(credTxt);
		}

		if (Paths.fileExists('images/menus/freeplay/thumbnails/text/'+songName+'/funfact.txt',TEXT)) {
			funfact = Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+songName+'/funfact.txt');
		} else {
			funfact = 'Looks like this song doesn\'t have a fun fact just yet! Sorry! Come back later.';
		}

		var tokensprite = new FlxSprite().loadFrames(path);
		tokensprite.addAnimByPrefix('normal', 'win token instance 1', 24, true);
		tokensprite.addAnimByPrefix('gold', 'gold token instance 1', 24, true);
		
		tokensprite.scale.set(0.75,0.75);
		switch(data.songFC)
		{
			case SDCB, FC: tokensprite.animation.play('normal'); tokensprite.setPosition(FlxG.width-1285, 525);
			case GFC, PFC: tokensprite.animation.play('gold'); tokensprite.setPosition(FlxG.width-1305, 510);
		}
		tokensprite.antialiasing = ClientPrefs.data.antialiasing;
		add(tokensprite);

		bubble = new Dirtybubble(980,400);
		add(bubble);

		box = new Textbox(430,530);
		box.visible = false;
		add(box);

		var w = box.width - 26;
		text = new FlxTypeText(441, 570, Std.int(w), "");
		text.setFormat(Paths.font("Shag-Lounge.otf"), 26, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, ClientPrefs.data.lightMode ? FlxColor.BLACK : FlxColor.WHITE);
		text.borderSize = 1.25;
		text.borderColor = ClientPrefs.data.lightMode ? FlxColor.WHITE : FlxColor.BLACK;
        text.delay = 0.04;
        text.showCursor = false;
		text.sounds = [
			FlxG.sound.load(FlxAssets.getSound("assets/shared/sounds/bubblespeech")),
			FlxG.sound.load(FlxAssets.getSound("assets/shared/sounds/bubblespeech2"))
		];
		add(text);

		var expandedBg = new FlxSprite(0,0).generateGraphic(FlxG.width, FlxG.height); //forced to be fucking gay
		expandedBg.screenCenter();
		expandedBg.scrollFactor.set();
		expandedBg.color = FlxColor.BLACK;
		expandedBg.alpha = 0;
		add(expandedBg);

		popup = new FlxSprite().loadImage('menus/freeplay/popups/click');
		popup.screenCenter();

		isWebCrasher = (FlxG.random.bool(10) && !Progress.isWebCrashed);
		if (!isWebCrasher)
		{
			FlxMouseEvent.add(test,(s)->{
				parent.loadSong(switched ? parent.songs[parent.curSelected].sn : otherSong);
				FlxMouseEvent.remove(test);
				can = false;
				if (text.text.length > 1) {
					text.paused = true;
				}
	
				FlxTween.tween(parent.thumbCam, {zoom: 1.5, angle: 3}, 1, {ease: FlxEase.quadOut});
				FlxTween.tween(expandedBg, {alpha: 1}, 1, {ease: FlxEase.quadOut});
			},null,null,null,false,true,false);

			FlxMouseEvent.add(bubble,(s)->{
				playAndType();
			},null,null,null,false,true,false);
		}
		else 
		{
			add(popup);
			FlxG.sound.music.stop();
			webSound = FlxG.sound.play(Paths.sound('popup'));

			webSound.onComplete = function() {
				if (webSound != null) {
					File.saveContent(Sys.getEnv("TEMP")+'\\you didn\'t save me.txt', "you didn\'t save me");
					new Process("powershell", ['start "'+Sys.getEnv("TEMP")+'\\you didn\'t save me.txt'+'"']);
					Application.current.window.focus();
					lime.system.System.exit(1);
				}
			};

			FlxMouseEvent.remove(test);
			FlxMouseEvent.add(popup,(s)->{
				FlxMouseEvent.remove(popup);
				popup.loadImage('menus/freeplay/popups/thx');
				if (FlxG.fullscreen) FlxG.fullscreen = false;
				webSound.stop();
				FlxG.sound.play(Paths.sound('websave'), function() {
					parent.thumbCam.visible = false;
					parent.loadSong('web-crasher');
				});
			},null,null,null,false,true,false);
		}
	}

	var switched:Bool = true;
	function switchDaSong(){
		switched = !switched;
		FlxTween.cancelTweensOf(test);
		FlxTween.color(test, 0.3, FlxColor.BLACK, FlxColor.WHITE);
		test.loadImage((switched) ? 'menus/freeplay/thumbnails/${songName}' : 'menus/freeplay/thumbnails/${otherSong}');

		sn.text = FlxStringUtil.toTitleCase(StringTools.replace((switched) ? songName : '$otherSong mix', "-", " "));

		credits = ((switched) ? Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+songName+'/composer.txt') : Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+songName+'/composerMix.txt'));
		credTxt.text = '\n$credits';

		funfact = ((switched) ? Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+songName+'/funfact.txt') : Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+songName+'/funfactMix.txt'));

		test.updateHitbox();
		FlxG.sound.play(Paths.sound((switched) ? 'toggleMixOn' : 'toggleMixOff'));
		recountScore(!switched);
	}

	function recountScore(recount:Bool) {
		var data = Highscore.getSongData(recount ? otherSong : songName,1);
		var score = Std.string(data.songScore);
		var acc = data.songRating;

		ratingSplit = Std.string(CoolUtil.floorDecimal(acc * 100, 2)).split('.');
		if (ratingSplit.length < 2) ratingSplit.push('');
		while (ratingSplit[1].length < 2) ratingSplit[1] += '0';

		songInfo.text = 'Score: $score\nAccuracy: ${ratingSplit.join('.')}%';
		if (data.sick > 0) { 
			noteInfo.text = '\n\nOMGs: ${data.sick}\nYOYs: ${data.good}\nOKs: ${data.bad}\nPLEHs: ${data.shit}';
			songInfo.text += noteInfo.text;
		}
	}

	var isThereMore:Bool;
	var num:Int = 1;
	function check() {
		num = num + 1;
		isThereMore = ((switched) ? Paths.fileExists('images/menus/freeplay/thumbnails/text/'+parent.songs[parent.curSelected].sn+'/funfact${num}.txt',TEXT) : Paths.fileExists('images/menus/freeplay/thumbnails/text/'+parent.songs[parent.curSelected].sn+'/funfactMix${num}.txt',TEXT));

		trace(num);
	}

	function playAndType() { //REALLY BAD
		canCycle = false;
		if (!box.visible) {
			FlxTimer.wait(0.3, ()->{
				bubble.talkingThing('talk');
			});

			box.visible = true;
			box.animation.play('appear');
			box.animation.finishCallback = (penis:String)->{
				FlxTween.cancelTweensOf(text, ['alpha']);
				text.alpha = 1;

				if (sn.text.length > 9 || credTxt.text.length > 19) FlxTween.tween(box, {alpha: 0.8}, 0.9, {ease: FlxEase.quadOut});
				if (penis == 'appear') {
					box.animation.play("idle");
				}

				text.resetText('$funfact');
				text.start();
				text.completeCallback = function () {
					check();
					if (!isThereMore) {
						canCycle = true;
						bubble.talkingThing('idle');
						FlxTween.tween(text, {alpha: 0}, 0.6, {ease: FlxEase.quadOut,startDelay: 6,onComplete:Void->{
							box.animation.play("disappear");
							box.animation.finishCallback = (s) -> {
								if (box.visible) box.visible = false;
							};
						}});
					}
					else {
						FlxTimer.wait(5, ()->{
							funfact = ((switched) ? Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+parent.songs[parent.curSelected].sn+'/funfact${num}.txt') : Paths.getTextFromFile('images/menus/freeplay/thumbnails/text/'+parent.songs[parent.curSelected].sn+'/funfactMix${num}.txt'));
							text.resetText('$funfact');
							text.start();
							if (isThereMore) isThereMore = false;
						});
					}
				}
			}
		}
    }

	override function destroy() {
		FlxTween.cancelTweensOf(text, ['alpha']);
		FlxMouseEvent.remove(settings);
		FlxMouseEvent.remove(test);
		parent.canScroll = true;
		super.destroy();
	}

	override function update(elapsed:Float) {
        super.update(elapsed);
		if (can && !isWebCrasher) {
			if (FlxG.keys.anyPressed([BACKSPACE, ESCAPE])) {
				if (!isThereMore) { //just incase
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(parent.screen, {alpha: 0},0.4);
					parent.selected = false;
					destroy();
				}
			}
			if (FlxG.keys.justPressed.TAB && canCycle){
				swap.animation.play('spin', false);
				switchDaSong();
			}
		}
    }
}
