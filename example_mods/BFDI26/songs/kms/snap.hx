function onSongStart() {
	var oppPos = [for (i in game.opponentStrums) i.x];
	for (i in 0...4) {
		if (!ClientPrefs.data.middleScroll){
			game.opponentStrums.members[i].x = game.playerStrums.members[i].x;
			game.playerStrums.members[i].x = oppPos[i];
		}
	}
    for (i in opponentStrums) {
        i.x = -1000;
    }
}

function onUpdatePost(elapsed) {
    game.camZooming = true;
}

function boom() {
	if (FlxG.camera.zoom < 1.35 && ClientPrefs.data.camZooms) {
		FlxG.camera.zoom += .015;
		game.camHUD.zoom += .03;
	}
}

function onUpdate(e) {
	var mult:Float = 1 - Math.exp(-e * 7);
	game.camGame.zoom += (game.defaultCamZoom - game.camGame.zoom) * mult;
	game.camHUD.zoom += (1 - game.camHUD.zoom) * mult;
}

function onSectionHit() {
	boom();
	return Function_Continue;
}