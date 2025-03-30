function onStartCountdown()
    if not allowCountdown and not seenCutscene then
startVideo('oneshotpicomixStart',true)
triggerEvent('dumb video','oneshot-pico-mix-start')
        allowCountdown = true
        return Function_Stop
    end
end

function onCreate()
setProperty('bars.alpha',1)
setProperty('textmiss.alpha',1)

-- school
	makeLuaSprite('back', 'backgrounds/oneshot/pico-mix/class/backdropCLASSROOM',-700,200)
	setScrollFactor('back',0.9875,0.9875)
	setProperty('back.alpha',1)
	addLuaSprite('back',false)

	makeLuaSprite('chairs', 'backgrounds/oneshot/pico-mix/class/schooldeskwradio',1074,1250)
	setScrollFactor('chairs',0.99,0.99)
	setProperty('chairs.alpha',1)
	addLuaSprite('chairs',false)
--

-- outside
makeLuaSprite('sky', 'backgrounds/oneshot/pico-mix/outside/gradient sky',-500,-425)
setScrollFactor('sky',0.1,0.1)
setProperty('sky.alpha',0)
addLuaSprite('sky',false)

makeLuaSprite('parlor', 'backgrounds/oneshot/pico-mix/outside/unloaded bg',200,525)
setScrollFactor('parlor',0.99,0.99)
setProperty('parlor.alpha',0)
addLuaSprite('parlor',false)

makeAnimatedLuaSprite('bus','backgrounds/oneshot/pico-mix/outside/bus passby transition',-4500,850)
scaleObject('bus',0.75,0.75)
addAnimationByPrefix('bus','pass','bus darkened instance 1',24,true)
setScrollFactor('bus',1.05,1.05)
addLuaSprite('bus',true)
-- forest
makeLuaSprite('airybg','backgrounds/oneshot/pico-mix/forest/oneshotbg',0,300)
setProperty('airybg.alpha',0)
addLuaSprite('airybg',false)

makeLuaSprite('airybg2','backgrounds/oneshot/pico-mix/forest/oneshottrees1',-500,650)
setScrollFactor('airybg2',0.98,0.98)
setProperty('airybg2.alpha',0)
addLuaSprite('airybg2',false)
--

	initLuaShader('scroll')
	-- background shit
	makeLuaSprite('black', '',-500,750)
	makeGraphic('black',1280,720,'000000')
	scaleObject('black',2,2)
	setProperty('black.visible',false)
	addLuaSprite('black',false)

	makeLuaSprite('white', '',1500,750)
	makeGraphic('white',1280,720,'FFFFFF')
	setProperty('white.visible',false)
	scaleObject('white',2,2)
	addLuaSprite('white',false)

	makeLuaSprite('plane', 'backgrounds/oneshot/onecolor',-650,-500)
	setScrollFactor('plane',0.99,0.99)
	setProperty('plane.alpha',1)
	addLuaSprite('plane',false)

	makeAnimatedLuaSprite('glow', 'backgrounds/oneshot/oneglow',550,600)
    addAnimationByPrefix('glow', 'glows', 'funnyglowythings',24,true)
	setScrollFactor('glow',0.85,0.85)
	setProperty('glow.alpha',1)
    addLuaSprite('glow',false)

	makeLuaSprite('rainbow', 'backgrounds/oneshot/rainbowloop',-500,900)
	setScrollFactor('rainbow',0.99,0.99)
	scaleObject('rainbow',0.25,1)
	setProperty('rainbow.alpha',0.02)
	setProperty('rainbow.angle',47)
	setSpriteShader('rainbow','scroll')
	addLuaSprite('rainbow',false)

	makeLuaSprite('rainbow2', 'backgrounds/oneshot/rainbowloop',584,600)
	setScrollFactor('rainbow2',0.99,0.99)
	scaleObject('rainbow2',0.3,1)
	setProperty('rainbow2.alpha',0.02)
	setProperty('rainbow2.angle',227)
	setSpriteShader('rainbow2','scroll')
	addLuaSprite('rainbow2',false)

	makeLuaSprite('chairs1', 'backgrounds/oneshot/backgroundone',-700,1100)
	setScrollFactor('chairs1',0.99,0.99)
	setProperty('chairs1.alpha',1)
	addLuaSprite('chairs1',false)

	makeLuaSprite('v', 'backgrounds/oneshot/vignette',0,0)
	setProperty('v.alpha',1)
	setObjectCamera('v','camHUD')
    addLuaSprite('v',true)

	makeLuaSprite('r', 'backgrounds/oneshot/overlay',100,0)
	setProperty('r.alpha',1)
	setObjectCamera('r','camHUD')
	setBlendMode('r','lighten')
    addLuaSprite('r',false)


	makeLuaSprite('fade', '',-1280,0);
	makeGraphic('fade',1280,720,'000000')
	addLuaSprite('fade',false);
	setObjectCamera('fade', 'other')
end

function onCreatePost()
	for i = 0,3 do
		setPropertyFromGroup('strumLineNotes',i,'alpha',0)
	end

		if (shadersEnabled) then
			initLuaShader("adjustColor");
end
end

function onEvent(name,v1)
if name == 'Trigger' then
if v1 == 'zoomout' then
setProperty('cameraSpeed',1000)
setProperty('camGame.zoom',0.85)
setProperty('defaultCamZoom',0.85)
setProperty('cameraSpeed',1)
for _, backgroundp in ipairs({'plane','glow','rainbow','rainbow2','chairs1','r'}) do
	setProperty(backgroundp..'.visible',false)
end
elseif v1 == 'oneshotstart' then
	setProperty('white.visible',true)
	setProperty('black.visible',true)

	setProperty('chairs.alpha',0)
	setProperty('back.alpha',0)

	setProperty('iconP1.visible',false)
	setProperty('iconP2.visible',false)
	setProperty('healthBar.visible',false)

	setProperty('camHUD.alpha',1)
	setProperty('camGame.alpha',1)
	setProperty('boyfriendGroup.x',getProperty('boyfriend.x')-250)
elseif v1 == 'outside' then
	for _, backgroundc in ipairs({'chairs','back','v'}) do
		setProperty(backgroundc..'.visible',false)
	end
	setProperty('parlor.alpha',1)
	setProperty('sky.alpha',1)

	setProperty('boyfriendGroup.x',getProperty('boyfriend.x')-200)
	setProperty('dadGroup.x',getProperty('dad.x')-100)

	setProperty('defaultCamZoom',0.675)
	setProperty('white.visible',false)
	setProperty('black.visible',false)

	setProperty('iconP1.visible',true)
	setProperty('iconP2.visible',true)
	setProperty('healthBar.visible',true)

	if shadersEnabled then
	setSpriteShader('dad','adjustColor')
	setSpriteShader('boyfriend','adjustColor')
	setShaderFloat("dad", "brightness",-30)
	setShaderFloat("boyfriend", "brightness",-30)
	end
elseif v1 == 'bus' then
doTweenX('bus1','bus',-500,0.2)
end
end
end

function onUpdatePost()
	songPos = getSongPosition()
	doTweenAlpha('glows','glow',getProperty('glow.alpha')-0.25*math.sin((songPos/1500) * (bpm/60) *0.75),0.01)
	doTweenAlpha('rainbowglow','r',0.75-1*math.sin((songPos/500) * (bpm/60) *1)/5,1)
setShaderFloat('rainbow','iTime',os.clock())
setShaderFloat('rainbow2','iTime',os.clock())
end

function onTweenCompleted(tag)
if tag == 'bus1' then
	doTweenX('bus2','bus',4000,0.2)
	setProperty('parlor.alpha',0)
	setProperty('sky.alpha',0)
	setProperty('v.visible',true)
	setProperty('airybg.alpha',1)
	setProperty('airybg2.alpha',1)
	setProperty('defaultCamZoom',0.75)
	if shadersEnabled then
removeSpriteShader('dad')
removeSpriteShader('boyfriend')
	end
end
end