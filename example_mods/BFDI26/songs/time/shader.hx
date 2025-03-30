var shader = game.createRuntimeShader("vhs");

function initShaders() {
}

function onCreate() {
    game.camGame.filtersEnabled = false;
    game.camGame.filters = [new ShaderFilter(shader)];
}

function onUpdatePost(elapsed) {
    shader.setFloat("iTime", Conductor.songPosition / 1600); 
}

function onEvent(ev,v1,v2) {
    if (ev == 'Trigger') {
        if (v1 == 'renderin') {
            game.camGame.filtersEnabled = true;
        }
    }
}