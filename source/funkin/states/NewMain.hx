package funkin.states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import funkin.states.editors.MasterEditorMenu;
import funkin.states.options.OptionsState;
import funkin.data.Highscore;
import funkin.objects.Character;

import flixel.input.mouse.FlxMouseEvent;

class NewMain extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	var selectedSomethin = false;

	final buttons:Array<String> = ["mainsongs","freeplay","options","credits","website"];
	public static var menuItems:FlxTypedGroup<FlxSprite>;

	var tv:Character;
	final bgs = ['exit','plains','beam','ruins','hpprc'];

	override function create()
	{

		FlxG.mouse.visible = true;
		FlxG.camera.bgColor = FlxColor.BLACK;

		#if DISCORD_ALLOWED DiscordClient.changePresence("BFDI 26 - MAIN MENU", null); #end
		Mods.loadTopMod();
		Difficulty.resetList();

		var rd = FlxG.random.getObject(bgs);
		var bg = new FlxSprite().loadImage('menus/main/bgs/${rd}');
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		if (rd == 'plains') {
			bg.scale.set(0.8,0.8);
		} 
		else if (rd != 'ruins') bg.scale.set(0.7,0.7);
		bg.screenCenter();
		bg.x += 30;
		bg.scrollFactor.set(0.7,0.7);
		bg.alpha = 0.1;
		FlxTween.tween(bg, {alpha: 1,x: bg.x+20}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.3});
		if (rd == 'beam') FlxTween.tween(bg, {alpha: 1,x: bg.x,y: bg.y-30}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.3});
		if (rd == 'hpprc') FlxTween.tween(bg, {alpha: 1,x: bg.x-40}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.3});
		if (rd == 'exit') FlxTween.tween(bg, {alpha: 1,x: bg.x-20}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.3});
		
		tv = new Character(0,0,'tv');
        tv.antialiasing = true;
        add(tv);
        tv.scrollFactor.set(0.8,0.8);

		menuItems = new FlxTypedGroup<FlxSprite>();
		for (i in 0...buttons.length)
		{
			var menuItem = new FlxSprite(650,140 + (i * (60 + 30)));
			menuItem.frames = Paths.getSparrowAtlas('menus/main/buttons/${buttons[i]}');
			menuItem.animation.addByPrefix('i', '${buttons[i]} instance 1',1);
			menuItem.animation.addByPrefix('s', '${buttons[i]} selected instance 1',1);
			menuItem.animation.play('i');
			menuItem.scale.set(0.6,0.6);
			menuItem.updateHitbox();
			menuItem.scrollFactor.set(0.9,0.9);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.ID = i;
			menuItems.add(menuItem);
		}
		add(menuItems);

		tv.x = menuItems.members[0].x-300;
		tv.y = menuItems.members[0].y+275;
		tv.alpha = 0.0001;

		menuItems.forEach(function(spr:FlxSprite){
			spr.alpha = 0;
			spr.x += 30;
			FlxTween.tween(spr, {alpha: 1,x:spr.x+30}, 0.8, {ease: FlxEase.backOut,startDelay: spr.ID*0.1});
		});
		FlxTween.tween(tv,{alpha: 1,y: tv.y+25},0.6,{ease: FlxEase.backOut,startDelay: 0.6});

		changeItem();
		super.create();
	}

	override function update(elapsed:Float)
	{
		mouseMovement(elapsed);

		if (!selectedSomethin) {
			if (controls.UI_UP_P || controls.UI_DOWN_P) changeItem(controls.UI_UP_P ? -1 : 1);

			if (controls.BACK || FlxG.mouse.justPressedRight)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(new funkin.states.Title());
				FlxG.mouse.visible = false;
			}

			if (menuItems != null) {
				for(i in menuItems){ 
					final itemID = menuItems.members.indexOf(i);
					final isOver = FlxG.mouse.overlaps(i);

					if (isOver && curSelected != itemID && FlxG.mouse.justMoved) 
					{
						changeItem(itemID-curSelected);
					}
					
					if (controls.ACCEPT || (FlxG.mouse.justPressed && isOver)) confirm(buttons[curSelected]);
				}
			}
		}

		super.update(elapsed);
	}	

	function changeItem(change:Int = 0)
	{
		if(change != 0) FlxG.sound.play(Paths.sound('scrollMenu'));

		menuItems.members[curSelected].animation.play('i');
		curSelected = FlxMath.wrap(curSelected+change,0,menuItems.length-1);
		menuItems.members[curSelected].animation.play('s');

		tv.playAnim('${buttons[curSelected]}');
	}

	function confirm(button:String = null) {
		if (button != null) {
			switch(button) {
				case "mainsongs": 
					FlxTween.tween(FlxG.sound.music, {pitch: 3}, 0.1, {onComplete:Void->{
						FlxTween.tween(FlxG.sound.music, {pitch: FlxG.random.float(0.4, 0.9)}, 0.3);
					}});
					FlxTween.tween(FlxG.camera,{zoom: 1.1},0.4,{ease: FlxEase.backOut, onComplete:Void->{
						openSubState(new SongSelect());
					}});
				case "freeplay": FlxG.switchState(funkin.states.FreeplayState.new);
				case "options": 
					FlxG.switchState(funkin.states.options.OptionsState.new);
					OptionsState.onPlayState = false;
					if (PlayState.SONG != null)
					{
						PlayState.SONG.arrowSkin = null;
						PlayState.SONG.splashSkin = null;
						PlayState.stageUI = 'normal';
					} 
				case "credits": 							
					FlxG.sound.music.fadeOut(0.3);
					FlxG.switchState(funkin.states.CreditsState.new);
				case "website": 
					FlxG.sound.play(Paths.sound('confirmMenu')); 
					CoolUtil.browserLoad('https://discord.gg/yoylefake'); //more convenient
			}
		}
	}

	function mouseMovement(elapsed:Float) { //luv u vechett
		var mouseX = (FlxG.mouse.getScreenPosition(FlxG.camera).x - (FlxG.width/2)) / 14;
		var mouseY = (FlxG.mouse.getScreenPosition(FlxG.camera).y - (FlxG.height/2)) / 14;
	
		FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (mouseX), 1-Math.exp(-elapsed * 3));
		FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (mouseY),1-Math.exp(-elapsed * 3));
	}
}

class SongSelect extends MusicBeatSubstate {
	final song:Array<String> = ["yoylefake","locked","locked"]; //idc fuck all
	public static var songSpr:FlxTypedGroup<FlxSprite>;
	public static var current:Int = 0;
	var sle:Bool = false;
	var blackbg:FlxSprite;

	public function new() {super();}

	override function create()
	{
		blackbg = new FlxSprite(0,0).generateGraphic(FlxG.width, FlxG.height);
		blackbg.screenCenter();
		blackbg.scrollFactor.set();
		blackbg.color = FlxColor.BLACK;
		blackbg.alpha = 0;
		add(blackbg);

		FlxTween.tween(blackbg,{alpha: 0.8},1,{ease: FlxEase.backOut});

		songSpr = new FlxTypedGroup<FlxSprite>();
		for (i in 0...song.length)
		{
			var menuItem = new FlxSprite(0,0).loadImage('menus/main/select/${song[i]}');
			menuItem.scale.set(0.26,0.26);
			menuItem.scrollFactor.set(0.98,0.98);
			menuItem.screenCenter();
			menuItem.x += (360 * (i - (song.length / 2))) + 570;
			menuItem.y = 130;
			menuItem.updateHitbox();
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.ID = i;
			songSpr.add(menuItem);
		}
		add(songSpr);

		songSpr.forEach(function(spr:FlxSprite){
			spr.y -= 700;
			FlxTween.tween(spr, {y:spr.y+700}, 1.5, {ease: FlxEase.backOut,startDelay: spr.ID*0.2, onComplete:Void->{
				sle = true;
			}});
		});

		cursel();
		super.create();
	}

	override function update(elapsed:Float) {
		mouseMovement(elapsed);

		if (controls.UI_LEFT_P || controls.UI_RIGHT_P) cursel(controls.UI_LEFT_P ? -1 : 1);

		if (sle) {
			if (songSpr != null) {
				for(i in songSpr){ 
					final itemID = songSpr.members.indexOf(i);
					final isOver = FlxG.mouse.overlaps(i);
	
					if (isOver && current != itemID && FlxG.mouse.justMoved) 
					{
						cursel(itemID-current);
					}
						
					if (controls.ACCEPT || (FlxG.mouse.justPressed && isOver)) accept(song[current]);
				}
			}

			if (controls.BACK || FlxG.mouse.justPressedRight)
			{
				songSpr.forEach(function(spr:FlxSprite){
					FlxTween.tween(spr, {y:spr.y+700}, 1.5, {ease: FlxEase.backOut,startDelay: spr.ID*0.2});
				});

				FlxTween.tween(FlxG.sound.music, {pitch: 3}, 0.4, {startDelay: 0.5,onComplete:Void->{
					FlxTween.tween(FlxG.sound.music, {pitch: FlxG.random.float(0.6, 1.3)}, 0.3, {onComplete:Void->{
						FlxTween.tween(FlxG.sound.music, {pitch: 1}, 0.2);
						FlxTween.tween(blackbg,{alpha: 0},0.2,{ease: FlxEase.backOut, onComplete:Void->{
							FlxTween.tween(FlxG.camera,{zoom: 1},0.2,{ease: FlxEase.backOut});
							close();
						}});
					}});
				}});
			}
		}
		super.update(elapsed);
	}

	function cursel(change:Int = 0) current = FlxMath.wrap(current+change,0,songSpr.length-1);
	
	function accept(button:String = null) {
		if (button != null) {
			switch(button) {
				case "yoylefake": 
					sle = false;

					FlxTween.tween(blackbg, {alpha: 1}, 0.3, {ease: FlxEase.backOut, startDelay: 1,onComplete:Void->{
						yyoelafake();
					}});

					songSpr.forEach(function(spr:FlxSprite){
						FlxTween.tween(spr, {alpha: 0}, 1, {ease: FlxEase.backOut,startDelay: spr.ID*0.3});
					});

					//dear god
					FlxTween.tween(FlxG.sound.music, {pitch: 3}, 0.5, {onComplete:Void->{
						FlxTween.tween(FlxG.sound.music, {pitch: FlxG.random.float(0.6, 1.3)}, 0.3, {onComplete:Void->{
							FlxTween.tween(FlxG.sound.music, {pitch: 1}, 0.4, {onComplete:Void->{
								FlxTween.tween(FlxG.sound.music, {pitch: 3}, 0.2, {onComplete:Void->{
									FlxTween.tween(FlxG.sound.music, {pitch: FlxG.random.float(0.6, 1.3)}, 0.2, {onComplete:Void->{
										FlxTween.tween(FlxG.sound.music, {pitch: 0}, 0.2);
									}});
								}});
							}});
						}});
					}});
				default:
					FlxG.sound.play(Paths.sound('cancelMenu'));
					songSpr.members[current].color = FlxColor.BLACK;
					FlxTween.color(songSpr.members[current], 0.3, FlxColor.BLACK, FlxColor.WHITE);
			}
		}
	}

	function yyoelafake(songToLoad:String = 'yoylefake') {
		var formatedSong = Paths.formatToSongPath(songToLoad);
		var diffFormatting = Highscore.formatSong(formatedSong, 1);
		try
		{
			PlayState.SONG = funkin.backend.Song.loadFromJson(diffFormatting, formatedSong);
			PlayState.yoylefakeStart = true;
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;
			FlxG.switchState(PlayState.new);
		}
		catch (e:Dynamic)
		{
			trace('fuck. $e');
			FlxG.sound.play(Paths.sound('cancelMenu'));
			return;
		}
	
		FlxG.switchState(PlayState.new);
	}

	function mouseMovement(elapsed:Float) { //luv u vechett
		var mouseX = (FlxG.mouse.getScreenPosition(FlxG.camera).x - (FlxG.width/2)) / 14;
		var mouseY = (FlxG.mouse.getScreenPosition(FlxG.camera).y - (FlxG.height/2)) / 14;
	
		FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (mouseX), 1-Math.exp(-elapsed * 3));
		FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (mouseY),1-Math.exp(-elapsed * 3));
	}
}