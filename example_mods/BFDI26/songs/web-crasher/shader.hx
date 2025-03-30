var shader = game.createRuntimeShader("compressed");
var shader2 = game.createRuntimeShader("colorInversion");
var shader3 = game.createRuntimeShader("adjustColor");
function initShaders() {
}

    var amount = 0;

function onUpdatePost(elapsed) {
    amount = amount+2.5;
    shader3.setFloat("hue", amount); 
}


function onEvent(ev,v1,v2) {
    if (ev == 'Trigger') {
    if (v1 == 'speedshit') 
    game.camGame.filters = ([new ShaderFilter(shader), (new ShaderFilter(shader2))]);
    game.camHUD.filters = [new ShaderFilter(shader)];
    game.camOther.filters = [new ShaderFilter(shader)];

    shader2.setInt("invert", 0);
    }
    
    {
        if (v1 == 'badappleswap') {
    shader2.setInt("invert", 1);
        }
        if (v1 == 'badappleend') {
    shader2.setInt("invert", 0);
        }
        if (v1 == 'partytime') {
    game.camGame.filters = ([new ShaderFilter(shader), (new ShaderFilter(shader3))]);
        }
    }
}