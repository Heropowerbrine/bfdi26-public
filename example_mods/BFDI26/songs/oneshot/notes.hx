function onSongStart() {
	var oppPos = [for (i in game.opponentStrums) i.x];
	for (i in 0...4) {
		if (!ClientPrefs.data.middleScroll){
			game.opponentStrums.members[i].x = game.playerStrums.members[i].x;
		}
	}
    for (i in opponentStrums) {
        i.x = -1000;
    }
}