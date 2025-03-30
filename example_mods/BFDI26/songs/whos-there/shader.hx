var shader = game.createRuntimeShader("adjustColor");

function initShaders() {
}

function onCreate() {
    game.camGame.filters = [new ShaderFilter(shader)];
    game.camHUD.filters  = [new ShaderFilter(shader)];
}

function onSongStart() {
    for (i in opponentStrums) {
        i.x = -1000;
    } 
}

function onUpdatePost(elapsed) {
    game.camZooming = false;
}

var twn;
function onBeatHit() {
    if (game.dad.visible && game.dad.animation.curAnim.name != 'idle-alt') {
        if (twn != null) twn.cancel();
        twn = FlxTween.num(100, 0.1, 0.9, {ease: FlxEase.quadOut}, f -> shader.setFloat("contrast", f));
    }
}

function onEvent(ev,v1,v2) {
}

function boom() {
	if (FlxG.camera.zoom < 1.35 && ClientPrefs.data.camZooms) {
		FlxG.camera.zoom += .015;
		game.camHUD.zoom += .03;
	}
}

function onSectionHit() {
	boom();
	return Function_Continue;
}
function onUpdate(e) {
	var mult:Float = 1 - Math.exp(-e * 7);
	game.camGame.zoom += (game.defaultCamZoom - game.camGame.zoom) * mult;
	game.camHUD.zoom += (1 - game.camHUD.zoom) * mult;
}