var shader = game.createRuntimeShader("adjustColor");

function initShaders() {
}

function onCreatePost() {
    game.camGame.filtersEnabled = false;
    game.camHUD.filtersEnabled = false;

    game.camGame.filters = [new ShaderFilter(shader)];
    game.camHUD.filters = [new ShaderFilter(shader)];
}

    var amount = 0;

function onUpdatePost(elapsed) {
    amount = amount+2.5;
    shader.setFloat("hue", amount); 
}


function onEvent(ev,v1,v2) {
    if (ev == 'Trigger') {
    if (v1 == 'sus') 
        game.camGame.filtersEnabled = true;
    game.camHUD.filtersEnabled = true;
    }
}