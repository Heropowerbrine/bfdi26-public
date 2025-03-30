

function onCreate() {
	FlxG.camera.snapToTarget();
}

function onSongStart() {
    for (i in opponentStrums) {
        i.x = -1000;
    } 
}
