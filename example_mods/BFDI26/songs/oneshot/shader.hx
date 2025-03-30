var shader = game.createRuntimeShader("colorInversion");

function initShaders() {
}

function onCreate() {
    game.camGame.filters = [new ShaderFilter(shader)];
    shader.setInt('invert', 0);
}


function onEvent(ev,v1,v2) {
    if (ev == 'Trigger') {
        if (v1 == 'negative') {
    shader.setInt('invert', 1);
        }
    if (v1 == 'oneshotend') {
    shader.setInt('invert', 0);
        }
    }
}