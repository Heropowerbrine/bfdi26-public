var shader = game.createRuntimeShader("colorInversion");
var shader2 = game.createRuntimeShader("adjustColor");



function initShaders() {
}

function onCreate() {
    game.camGame.filters = ([new ShaderFilter(shader), (new ShaderFilter(shader2))]);
    shader2.setFloat('contrast', 11);
    shader2.setFloat('brightness', -16);
    shader2.setFloat('saturation', -25);
    shader2.setFloat('hue', -27);
}

function onEvent(ev,v1,v2) {
    if (ev == 'Trigger') {
        if (v1 == 'zoomout') {
    shader2.setFloat('contrast', 8);
    shader2.setFloat('brightness', -5);
    shader2.setFloat('saturation', 26);
    shader2.setFloat('hue', 8);
        }
        if (v1 == 'negative') {
    shader.setInt("invert", 1);
        }
        if (v1 == 'outside') {
    shader.setInt("invert", 0);
    shader2.setFloat('contrast', 5);
    shader2.setFloat('brightness', -5);
    shader2.setFloat('saturation', 6);
    shader2.setFloat('hue', -2);
        }
        if (v1 == 'axeshade') {
            shader2.setFloat('contrast', 25);
    shader2.setFloat('brightness', -15);
    shader2.setFloat('saturation', 16);
    shader2.setFloat('hue', 15);
        }
    }
}