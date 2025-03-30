var shader = game.createRuntimeShader("adjustColor");
var shader2 = game.createRuntimeShader("RGB_PIN_SPLIT");

function initShaders() {
}

function onCreatePost() {
    game.camGame.filters = ([new ShaderFilter(shader), (new ShaderFilter(shader2))]);
}

var twn;
var twn2;
var twn3;
function onEvent(ev,v1,v2) {
    if (ev == 'RGB') {

        if (twn != null) twn.cancel();
        if (twn2 != null) twn2.cancel();
        if (twn3 != null) twn3.cancel();

    twn = FlxTween.num(-25, 0, 2, {ease: FlxEase.quadOut}, f -> shader.setFloat("hue", f));
    twn2 = FlxTween.num(25, 0, 3, {ease: FlxEase.quadOut}, f -> shader.setFloat("brightness", f));
    twn3 = FlxTween.num(0.02, 0, 1, {ease: FlxEase.quadOut}, f -> shader2.setFloat("amount", f));
    }
}