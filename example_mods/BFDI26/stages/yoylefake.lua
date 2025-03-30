local start = false
local focus = false
local popped = false
local dbmove = nil

function onStartCountdown()
    if not allowCountdown and not seenCutscene and yoylefakeStart then
        startVideo('yoylefakeStart',true)
		triggerEvent('dumb video','yoylefakes')
        allowCountdown = true
        return Function_Stop
    end
end

function onSongStart()
setProperty('bars.alpha',0)
	setProperty('camZooming',true)
	setProperty('camHUD.alpha',0)
	setProperty('camGame.alpha',0)
	setProperty('iconP1.visible',false)
	setProperty('iconP2.visible',false)
	setProperty('healthBar.visible',false)
	setProperty('camHUD.alpha',0)
	setProperty('camGame.alpha',0)
	setProperty('scoreTxt.visible',false)
	setProperty('botplayTxt.visible',false)

	setProperty('dad.x',getProperty('dad.x')+200)
	setProperty('boyfriend.x',getProperty('boyfriend.x')-200)
end

function onCreate()
	setProperty('camGame.bgColor', getColorFromHex('000000'))
	initLuaShader('void')
	initLuaShader('lava')
	-- background shit
	makeLuaSprite('h', 'backgrounds/yoylefake/happyness',-700,-200)
	scaleObject('h',2,2)
	setScrollFactor('h',0.15,0.15)
	setProperty('h.alpha',0)
	addLuaSprite('h',false)
	setSpriteShader('h','void')

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

	makeAnimatedLuaSprite('michael', 'backgrounds/yoylefake/burningdreamisland',-375,-25)
	setScrollFactor('michael',0.2,0.2)
	scaleObject('michael',1.1,1.1)
	addAnimationByPrefix('michael', 'burn', 'dream island instance 1',24,true)
	setProperty('michael.alpha',0)
	addLuaSprite('michael',false)

	makeAnimatedLuaSprite('fire3', 'backgrounds/yoylefake/fire',-425,90)
    addAnimationByPrefix('fire3', 'flames', 'fire',20,true)
	scaleObject('fire3',1.5,1.5)
	setScrollFactor('fire3',0.5,0.5)
	setProperty('fire3.alpha',0)
	setProperty('fire3.visible',false)
	setBlendMode('fire3','add')
    addLuaSprite('fire3',false)

	makeLuaSprite('center', 'backgrounds/yoylefake/recovery',1000,100)
	setScrollFactor('center',0.6,0.6)
	setProperty('center.alpha',0)
	addLuaSprite('center',false)

	makeLuaSprite('center2', 'backgrounds/yoylefake/recovery',1500,100)
	setScrollFactor('center2',0.59,0.59)
	setProperty('center2.alpha',0)
	addLuaSprite('center2',false)

	makeLuaSprite('red', '',-50,1500)
	makeGraphic('red',3280,270,'D40202')
	scaleObject('red',1,1)
	setProperty('red.alpha',0)
	addLuaSprite('red',false)

	makeLuaSprite('table', 'backgrounds/yoylefake/table',1250,1400)
	setProperty('table.alpha',0)
	scaleObject('table',0.8,0.8)
	addLuaSprite('table',false)

	makeLuaSprite('platform', 'backgrounds/yoylefake/platform',830,1615)
	setProperty('platform.alpha',0)
	addLuaSprite('platform',false)

	makeLuaSprite('platform2', 'backgrounds/yoylefake/platform',1910,1615)
	setProperty('platform2.alpha',0)
	addLuaSprite('platform2',false)

	makeLuaSprite('center3', 'backgrounds/yoylefake/recovery',500,-500)
	setProperty('center3.alpha',0)
	scaleObject('center3',1.5,1.5)
	addLuaSprite('center3',true)

	makeAnimatedLuaSprite('fire', 'backgrounds/yoylefake/fire',-225,690)
    addAnimationByPrefix('fire', 'flames', 'fire',16,true)
	scaleObject('fire',1.5,1.5)
	setScrollFactor('fire',0.75,0.75)
	setProperty('fire.alpha',0)
	setProperty('fire.visible',false)
	setBlendMode('fire','add')
    addLuaSprite('fire',true)

	makeLuaSprite('d', 'rendersnlogos/dirtybubblerender',1000,175)
setProperty('d.alpha',0)
setObjectCamera('d','camHUD')
scaleObject('d',1.7,1.7)
addLuaSprite('d',false)

	makeAnimatedLuaSprite('fire2', 'rendersnlogos/ezzylogo',0,0)
    addAnimationByPrefix('fire2', 'flames2', 'ezzy',24,true)
	screenCenter('fire2','xy')
	setObjectCamera('fire2','camHUD')
	setProperty('fire2.alpha',0)
    addLuaSprite('fire2',false)

makeLuaText('text', 'BFDI 26: YOYLEFAKE',1000,625,650)
screenCenter('text','xy')
setProperty('text.alpha',0)
setTextSize('text',75)
setTextFont('text','Shag-Lounge.OTF')
setObjectCamera('text','other')
addLuaText('text',true)

	makeLuaSprite('blackk', '', 0, 0)
	setScrollFactor('blackk', 0, 0)
	makeGraphic('blackk',1280,720,'FF0000')
	setBlendMode('blackk','multiply')
	setProperty('blackk.alpha',0)
	setObjectCamera('blackk','other')
	scaleObject('blackk',2,2)
	addLuaSprite('blackk',true)
	screenCenter('blackk', 'xy')

	makeLuaSprite('border','',0,0)
    makeGraphic('border',215,1080,'000000')
    addLuaSprite('border',false)
    setObjectCamera('border','other')

    makeLuaSprite('border2','',1050,0)
    makeGraphic('border2',270,1080,'000000')
    addLuaSprite('border2',false)
    setObjectCamera('border2','other')

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	  setProperty('flash.alpha',0)
	setBlendMode('flash', 'add')
	setObjectCamera('flash', 'other')
screenCenter('flash','xy')
	addLuaSprite('flash', true);
end


	function onSectionHit(elapsed)
		if not mustHitSection and focus == true then
			setProperty('defaultCamZoom',0.575)
		elseif mustHitSection and focus == true then
			setProperty('defaultCamZoom',0.7)
		end
	end

		function onUpdatePost()
		if runHaxeCode([[FlxG.mouse.overlaps(dad) && FlxG.mouse.justPressed]]) and setProperty('dad.visible',true) and curStep >128 and curStep <2912 then
			popped = true
			cameraFlash('camOther','000000',1)
			setProperty('dad.visible',false)
			playSound('pop',0.5)
		endSong()
	end
			songPos = getSongPosition()
			if start == true then
			doTweenAlpha('imthealpha','fire',0.55+0.15*math.sin((songPos/3000) * (bpm/30) *1),0.01)
			doTweenAlpha('imthealpha2','fire3',0.65+0.25*math.sin((songPos/4000) * (bpm/60) *1),0.01)
			end

			setShaderFloat('h','iTime',os.clock())

		if start == false then
			setProperty('camHUD.zoom',0.7)
			elseif start == true then
				noteTweenX("NoteMove",0,795, 0.001)
				noteTweenX("NoteMovebb",1,1015, 0.001)
				noteTweenX("NoteMovebbb",2,1240, 0.001)
				noteTweenX("NoteMovebbbb",3,1450, 0.001)
		end
	if dbmove == 0 then
	setProperty('dad.x',2000)
	setProperty('dad.y',1000)
	elseif dbmove == 1 then
		setProperty('dad.x',1700)
		setProperty('dad.y',1175)
	elseif dbmove == 2 then
		setProperty('dad.x',2300)
	elseif dbmove == 3 then
	dbmove = 0
	end
end

function onEvent(name,v1,v2)
	if name == 'Trigger' and v1 == 'yoylefake' then
	start = true
	focus = true
	doTweenY('recoveryy','center',getRandomInt(1500,2000),getRandomInt(2,5),'quadIn')
	doTweenAngle('recoveryy2','center',getRandomInt(360,1080),getRandomInt(5,10),'cubeInOut')
	doTweenY('recoveryy4','center2',getRandomInt(1500,2000),getRandomInt(2,5),'quadIn')
	doTweenAngle('recoveryy5','center2',getRandomInt(360,1080),getRandomInt(5,10),'cubeInOut')
	doTweenY('recoveryy6','center3',getRandomInt(1500,2000),getRandomInt(2,5),'quadIn')
	doTweenAngle('recoveryy7','center3',getRandomInt(360,1080),getRandomInt(5,10),'cubeInOut')
	setProperty('dirtybubble.visible',true)
	elseif name == 'Trigger' and v1 == 'oldback' then
		start = false
		focus = false

		setProperty('center.alpha',0)
		setProperty('center2.alpha',0)
		setProperty('center3.alpha',0)
	elseif name == 'Trigger' and v1 == 'flashandstop' then
		start = true
	elseif name == 'Trigger' and v1 == 'backsturned' then
		setProperty('center.alpha',1)
		setProperty('center2.alpha',1)
		setProperty('center3.alpha',1)
		setSpriteShader('h','lava')
	elseif name == 'Change Character' and v2 == 'bubbehind' then
		dbmove = 0
	runTimer('changestuff',5)
	elseif name == 'Change Character' and v2 == 'bubperspec' then
		dbmove = nil
		setProperty('dad.x',700)
	setProperty('dad.y',1300)
	end
end

function onTimerCompleted(name)
	if name == 'endhaha' then
	exitSong()
	elseif name == 'changestuff' then
	runTimer('changestuff',3)
	doTweenAlpha('dbdiefornow','dad',0,0.5,'quadOut')
	end
end

function onTweenCompleted(tag)
if tag == 'dbdiefornow' then
	setProperty('dad.scale.x',1.15)
	setProperty('dad.scale.y',1.15)
	doTweenX('dadgoback','dad.scale',1,0.5,'circOut')
	doTweenY('dadgoback2','dad.scale',1,0.5,'circOut')
	doTweenAlpha('dbcomeback','dad',1,0.25,'elasticOut')
	dbmove = dbmove + 1

elseif tag == 'recoveryy' then
		cancelTween('recoveryy2')
		setProperty('center.angle',0)

		setProperty('center.y',100)
		setProperty('center.x',getRandomInt(-100,2400))
	doTweenY('recoveryy','center',getRandomInt(1500,2000),getRandomInt(2,5),'quadIn')
	doTweenAngle('recoveryy2','center',getRandomInt(360,1080),getRandomInt(5,10),'cubeInOut')
	elseif tag == 'recoveryy4' then
		cancelTween('recoveryy5')
		setProperty('center2.angle',0)

		setProperty('center2.y',100)
		setProperty('center2.x',getRandomInt(-100,2400))
	doTweenY('recoveryy4','center2',getRandomInt(1500,2000),getRandomInt(2,5),'quadIn')
	doTweenAngle('recoveryy5','center2',getRandomInt(360,1080),getRandomInt(5,10),'cubeInOut')
elseif tag == 'recoveryy6' then
	cancelTween('recoveryy7')
	setProperty('center3.angle',0)

	setProperty('center3.y',-500)
	setProperty('center3.x',getRandomInt(500,2500))
doTweenY('recoveryy6','center3',getRandomInt(1900,2300),getRandomInt(2,5),'quadIn')
doTweenAngle('recoveryy7','center3',getRandomInt(360,1080),getRandomInt(5,10),'cubeInOut')
	end
	end