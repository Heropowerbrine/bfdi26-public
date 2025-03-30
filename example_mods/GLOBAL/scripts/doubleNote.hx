var lastNote = 0;
function goodNoteHit(n) {
    if (n.isSustainNote) return;
    if (boyfriend.curCharacter != 'tophat2')
    if (lastNote == n.strumTime) makeGhost(boyfriend);
    else lastNote = n.strumTime;
}

var lastNoteOp = 0;
function opponentNoteHit(n) {
    if (n.isSustainNote) return;
    if (lastNoteOp == n.strumTime) makeGhost(dad);
    else lastNoteOp = n.strumTime;
}

function makeGhost(char:Character){
    var trail = new Character(char.x, char.y, char.curCharacter, (char == boyfriend) ? true : false);
    trail.color = char.color;
    trail.scale.set(char.scale.x, char.scale.y);
    trail.holdTimer = 0;
    if (char == boyfriend) addBehindBF(trail);
    else addBehindDad(trail);
    trail.playAnim(char.getAnimationName());
    FlxTween.tween(trail, {x: trail.x + (FlxG.random.bool(50) ? 200 : -200), 'scale.x': trail.scale.x + 0.2, 'scale.y': trail.scale.y + 0.2}, 4, {ease: FlxEase.circOut});
    FlxTween.tween(trail, {alpha: 0}, .55).onComplete = function() {
        trail.kill();
        remove(trail, true);
    };
    trail.animation.frameName = char.animation.frameName;
    trail.offset.x = char.offset.x;
    trail.offset.y = char.offset.y;
}