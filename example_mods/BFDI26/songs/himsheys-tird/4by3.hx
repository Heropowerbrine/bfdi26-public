import lime.app.Application;
import openfl.Lib;

var width:Int = 960;
var height:Int = 720;
final resizable:Bool = Lib.application.window.resizable;

function onCreatePost(){
    Lib.application.window.resizable = false;

    Application.current.window.x += 160;
    FlxG.resizeWindow(width, height);
    FlxG.resizeGame(width, height);

    FlxG.width = width;
    FlxG.height = height;

    FlxG.scaleMode.scale.x = 1;
    FlxG.scaleMode.scale.y = 1;

    FlxG.game.x = 0;
    FlxG.game.y = 0;

    if (PlayState.deathCounter == 0) {
		PlayState.deathCounter = 1;
		FlxG.resetState();
	}

    //im eyeballing ts like crazy
    game.healthBar.x -= 140;
    game.getLuaObject("textmiss").x -= 150;
    game.getLuaObject("textacc").x -= 140;
    game.scoreTxt.x -= 160;
    
}

function onSongStart() {
	var oppPos = [for (i in game.opponentStrums) i.x];
	for (i in 0...4) {
		if (!ClientPrefs.data.middleScroll){
			game.opponentStrums.members[i].x = oppPos[i] - 65;
			game.playerStrums.members[i].x = oppPos[i] + 425;
		}
	}
}

function onDestroy(){
    Application.current.window.x -= 160;
    FlxG.resizeWindow(FlxG.initialWidth, FlxG.initialHeight);
    FlxG.resizeGame(FlxG.initialWidth, FlxG.initialHeight);

    Lib.application.window.resizable = true;
}