camhudrand = 1

function onCreate() 
	setProperty('camGame.bgColor', getColorFromHex('FFFFFF'))

	makeLuaSprite('b', 'rendersnlogos/bluegolfballrender',1350,0)
    setProperty('b.alpha',0)
	scaleObject('b',1.35,1.35)
    setObjectCamera('b','camHUD')
    addLuaSprite('b',false)

    makeAnimatedLuaSprite('logo', 'rendersnlogos/bluegolfballtitle',0,0)
    addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 13',24,true)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)

	if songName == 'blue-golfball-bf' then
		setProperty('defaultCamZoom',0.8)
		setProperty('textmiss.alpha',1)
	
		makeLuaSprite('hue', '', 0, 0);
	setProperty('hue.alpha',0)
	  addLuaSprite('hue',false);
	
	  makeLuaSprite('smoke', '',-500,0)
	  makeGraphic('smoke',1280,720,'000000')
	  setSpriteShader('smoke','bgbbfm')
	setProperty('smoke.visible',false)
	setBlendMode('smoke','multiply')
	  scaleObject('smoke',2,2)
	  addLuaSprite('smoke',true)
	
	  makeLuaSprite('b', 'rendersnlogos/bluegolfballbfmixrender',-750,50)
	  setProperty('b.alpha',0)
	  scaleObject('b',0.75,0.75)
	  setObjectCamera('b','camHUD')
	  addLuaSprite('b',false)
	
	  makeLuaSprite('logo', 'rendersnlogos/bluegolfballbfmixtitle',0,0)
	  screenCenter('logo','xy')
	  setProperty('logo.alpha',0)
	  setObjectCamera('logo','camHUD')
	  addLuaSprite('logo',true)
		end
end

function onCreatePost()
if songName == 'blue-golfball-bf' and (shadersEnabled) then
	initLuaShader("adjustColor");
	initLuaShader("bgbbfm");
end
end

function onEvent(name,v1)
if songName == 'blue-golfball-bf' and name == 'Trigger' then
if v1 == 'CAMRANDOM' then
setProperty('camHUD.x',getRandomInt(-250,150))
setProperty('camHUD.y',getRandomInt(-250,150))
triggerEvent('Add Camera Zoom','','')
end
end
end

function onUpdatePost()
if songName == 'blue-golfball-bf' then
	setShaderFloat('smoke','iTime',os.clock())
	if getProperty('hue.alpha') == 1 then
		setProperty('smoke.visible',true)
	end
	end
	end
	