var shader = game.createRuntimeShader("RGB_PIN_SPLIT");

function initShaders() {
}

function onCreate() {
        shader.setFloat('amount', 0.0075);
game.camGame.filters = [new ShaderFilter(shader)];
game.camHUD.filters = [new ShaderFilter(shader)];
}

function onEvent(ev,v1,v2) {
    if (ev == 'Trigger') {
        if (v1 == 'background2') {
        shader.setFloat('amount', 0);
        }
    }
}