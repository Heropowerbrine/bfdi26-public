amount = 0
huestuff = 0
huestuff2 = 0

function onCreate()
--shader controls
	makeLuaSprite('blur', '',0, 0);
	setProperty('blur.visible',false)
	  addLuaSprite('blur',false);

makeLuaSprite('hue', '', 0, 0);
setProperty('hue.visible',false)
  addLuaSprite('hue',false);

  makeLuaSprite('hue2', '', 0, 0);
setProperty('hue2.visible',false)
  addLuaSprite('hue2',false);
  --

	  makeLuaSprite('black', '', 0, 0)
	  makeGraphic('black',1280,720,'000000')
	  setProperty('black.alpha',0)
	  addLuaSprite('black',true)
setObjectCamera('black','camHUD')
	  screenCenter('black', 'xy')

	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)
	-- background shit
	makeLuaSprite('bg3', 'backgrounds/yoylefake/fakeoutsky',500,770)
	scaleObject('bg3',0.9,0.9)
	setProperty('bg3.alpha',1)
	setScrollFactor('bg3',0.95,0.95)
	addLuaSprite('bg3',false)

	makeLuaSprite('bg4', 'backgrounds/yoylefake/fakeout',200,1370)
	scaleObject('bg4',1,1)
	setProperty('bg4.alpha',1)
	setScrollFactor('bg4',0.995,0.995)
	addLuaSprite('bg4',false)

	makeLuaSprite('v', 'backgrounds/oneshot/vignette',0,0)
	setProperty('v.alpha',1)
	setObjectCamera('v','camHUD')
    addLuaSprite('v',true)

	makeLuaSprite('ill', 'backgrounds/disrespect/ill',0,0)
	setProperty('ill.alpha',0)
	setObjectCamera('ill','other')
    addLuaSprite('ill',true)

	makeLuaSprite('crush', 'backgrounds/disrespect/crush',0,0)
	setProperty('crush.alpha',0)
	setObjectCamera('crush','other')
    addLuaSprite('crush',true)

	makeLuaSprite('you', 'backgrounds/disrespect/you',0,0)
	setProperty('you.alpha',0)
	setObjectCamera('you','other')
    addLuaSprite('you',true)

	setProperty('bg3.color',getColorFromHex('4D2B2E'))
	setProperty('bg4.color',getColorFromHex('4D2B2E'))
end

function onCreatePost()
	for i = 0,3 do
		setPropertyFromGroup('strumLineNotes',i,'alpha',0)
	end

		if (shadersEnabled) then
			initLuaShader("blur");
			initLuaShader("adjustColor");
			
			makeLuaSprite("temporaryShader");
			makeGraphic("temporaryShader", screenWidth, screenHeight);

			makeLuaSprite("temporaryShader2");
			makeGraphic("temporaryShader2", screenWidth, screenHeight);

			setSpriteShader("temporaryShader2", "adjustColor");
			
			setSpriteShader("temporaryShader", "blur");
			setShaderFloat('temporaryShader','directions',26.0)
			setShaderFloat('temporaryShader','quality',10.0)
			setShaderFloat('temporaryShader','merge',1.0)
			setShaderFloat("temporaryShader", "size",0);
			
			addHaxeLibrary("ShaderFilter", "openfl.filters");
			runHaxeCode([[
				trace(ShaderFilter);
game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader),(new ShaderFilter(game.getLuaObject("temporaryShader2").shader))]);
game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader),(new ShaderFilter(game.getLuaObject("temporaryShader2").shader))]);
			]]);
	end
end

function onEvent(name,v1)
if name == 'Trigger' and v1 == 'blur' then
	doTweenX('blureffect','blur',15,3.25,'cubeOut')
	doTweenAlpha('blackblur','black',0.5,1.25,'quadOut')
	triggerEvent("Add Camera Zoom", 0.015 % 2, 0.0015)
	triggerEvent("CamZoom",0.15,0)
	setProperty('defaultCamZoom',1)
elseif name == 'Trigger' and v1 == 'unblur' then
	doTweenX('blureffect2','blur',0,1.15,'cubeInOut')
	doTweenAlpha('blackblur2','black',0,0.75,'quadInOut')
	doTweenZoom('camgameahaha','camGame',0.9,1.35,'cubeOut')
	setProperty('defaultCamZoom',0.9)
elseif name == 'Trigger' and v1 == 'satur' then
	doTweenX('satureffect','hue',-100,2.25,'cubeOut')
	doTweenAlpha('blackblur','black',0.25,1.25,'quadOut')
	doTweenZoom('camgameahaha2','camGame',1.35,3.5,'sineOut')
	setProperty('defaultCamZoom',1.35)
elseif name == 'Trigger' and v1 == 'unsatur' then
	doTweenX('satureffect2','hue',0,1.25,'cubeOut')
	doTweenAlpha('blackblur2','black',0,0.75,'quadInOut')
	setProperty('defaultCamZoom',0.9)
elseif name == 'Add Camera Zoom' then
setProperty('hue2.x',25)
doTweenX('amountdie','hue2',0,1.25,'quadOut')
elseif name == 'Trigger' and v1 == 'renderin' then
end
end

function onUpdatePost()
	amount = getProperty('blur.x')
	huestuff = getProperty('hue.x')
	huestuff2 = getProperty('hue2.x')
setShaderFloat("temporaryShader", "size",amount);
setShaderFloat("temporaryShader2", "saturation",huestuff);
setShaderFloat("temporaryShader2", "contrast",huestuff2);
end