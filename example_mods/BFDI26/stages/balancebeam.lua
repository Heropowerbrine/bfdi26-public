function onCreate()
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)
	setProperty('camGame.alpha',0)
	setProperty('camHUD.alpha',0)
	-- background shit

	makeLuaSprite('beam', 'backgrounds/wrongfinger/balance',-600,50)
	setProperty('beam.alpha',1)
	setScrollFactor('beam',1,1)
	addLuaSprite('beam',false)

	makeLuaSprite('l', 'rendersnlogos/leafyrender',1250,-200)
	setProperty('l.alpha',0)
	scaleObject('l',0.9,0.9)
	setObjectCamera('l','camHUD')
    addLuaSprite('l',true)

	makeAnimatedLuaSprite('logo', 'rendersnlogos/wrongfingertext',0,0)
    addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 5',24,true)
	scaleObject('logo',1.25,1.25)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)
end

function onCreatePost()
setObjectCamera('gf','other')
screenCenter('gf','xy')
setProperty('gf.x',75)
setProperty('gf.y',400)
end

function onSongStart()
    setProperty('isCameraOnForcedPos', true)
	doTweenX('camX3', 'camFollow',getProperty('dad.x')+475,6.5,'cubeInOut')
	doTweenY('camY4', 'camFollow',getProperty('dad.y')+150,7.5,'cubeInOut')
end

function onEvent(name,v1)
	if name == 'Trigger' and v1 == 'renderin' then
		setProperty('camGame.alpha',1)
		cameraFlash('camHUD', 'FFFFFF',0.5);
		setProperty('defaultCamZoom',1)
		setProperty('camZooming',true)
		doTweenAlpha('logoshit','logo',1,2,'quadOut')
		doTweenX('logoshit5','l',850,1.75,'circOut')
		doTweenAlpha('logoshit3','l',1,2,'quadOut')
	elseif name == 'Trigger' and v1 == 'renderout' then
		doTweenAlpha('logoshit2','logo',0,1,'quadOut')
		doTweenX('logoshit6','l',1250,2,'quadIn')
		doTweenAlpha('logoshit4','l',0,2,'quadOut')
	elseif name == 'Trigger' and v1 == 'cutscene-end' then
		doTweenAlpha('camhudactivate','camHUD',1,1.25,'quadOut')
		doTweenY('wrong','gf',getProperty('gf.y')+1125,1,'cubeInOut')
		doTweenAngle('wrong2','gf',45,3,'sineOut')
	end
	end