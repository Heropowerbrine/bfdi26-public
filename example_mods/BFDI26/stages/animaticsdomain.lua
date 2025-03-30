local miniani = false

function onCreate()
	doTweenZoom('camGamehihi','camGame',1,0.001)
	setProperty('camHUD.alpha',0)
	-- background shit
	makeLuaSprite('bg', 'backgrounds/funnyfellow/animaticbg',-3000,-4700)
	setProperty('bg.alpha',1)
	setScrollFactor('bg',0.95,0.95)
	scaleObject('bg',1.25,1.25)
	addLuaSprite('bg',false)

	makeAnimatedLuaSprite('demoncore', 'backgrounds/funnyfellow/demon core swing bop',1200,325)
    addAnimationByPrefix('demoncore', 'bop', 'demon core swingy instance 1',24,true)
	scaleObject('demoncore',1.5,1.5)
	setScrollFactor('demoncore',0.95,0.95)
    addLuaSprite('demoncore',false)

	makeAnimatedLuaSprite('hive', 'backgrounds/funnyfellow/hives golden freddy',1400,225)
    addAnimationByPrefix('hive', 'freddy', 'hives instance 1',24,true)
	scaleObject('hive',1.5,1.5)
	setScrollFactor('hive',0.95,0.95)
    addLuaSprite('hive',false)

	makeAnimatedLuaSprite('shift', 'backgrounds/funnyfellow/shifty oh hell nah',650,750)
	scaleObject('shift',1.5,1.5)
	setScrollFactor('shift',0.95,0.95)
    addLuaSprite('shift',false)

	makeLuaSprite('f', 'rendersnlogos/animaticrender',1585,-100)
	setProperty('f.alpha',1)
	scaleObject('f',0.65,0.65)
	setObjectCamera('f','camHUD')
    addLuaSprite('f',true)

	makeAnimatedLuaSprite('logo', 'rendersnlogos/funnyfellow',0,0)
    addAnimationByPrefix('logo', 'title', 'Symbol 3',16,true)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)
end

function onCreatePost()
    setProperty('iconP2.visible',false)
	setProperty('dad.visible',false)
	for i = 0,3 do
		setPropertyFromGroup('strumLineNotes',i,'alpha',0)
	end
end