var shader = game.createRuntimeShader("adjustColor");

function onCreate() {
    game.camGame.filters = [new ShaderFilter(shader)];
    game.camHUD.filters  = [new ShaderFilter(shader)];
}

function onSectionHit() {
    var num = FlxG.random.int(40,150);
    shader.setFloat("contrast", num);
}