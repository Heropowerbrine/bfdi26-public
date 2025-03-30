var scoreLerp;
function onUpdatePost(elapsed:Float){
    scoreLerp = FlxMath.lerp(scoreLerp, PlayState.instance.songScore, 0.108);
    PlayState.instance.scoreTxt.text = 'Score: ' + Std.parseInt(scoreLerp);
}

function onStartCountdown() {
	skipTween = game.skipArrowStartTween;
	game.skipArrowStartTween = true;
	return Function_Continue;
}

function onCountdownStarted() {
	//game.remove(game.uiGroup);
	//game.insert(0, game.uiGroup);
	var m:Int = (ClientPrefs.data.downScroll ? -1 : 1);
	var i:Int = 0;
	for (strum in game.strumLineNotes.members) {
		var player = (i >= game.opponentStrums.length);
		if (!skipTween && PlayState.startOnTime <= 0 && (player || ClientPrefs.data.opponentStrums)) {
			strum.y -= m * 10;
			strum.alpha = 0;
			FlxTween.tween(strum, {y: strum.y + m * 10, alpha: ((ClientPrefs.data.middleScroll && i < game.opponentStrums.length) ? 0.35 : 1)}, 1, {ease: FlxEase.circOut, startDelay: 0.6 + (0.2 * (i % game.opponentStrums.length))});
		}
		
		i ++;
	}
	return Function_Continue;
}
