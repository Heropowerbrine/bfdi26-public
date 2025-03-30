camstop = nil

function onCreate() 
	setProperty('camGame.bgColor', getColorFromHex('93F8F0'))
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

makeLuaSprite('island','backgrounds/invitational/invitationalbg',0,0)
setProperty('island.alpha',1)
addLuaSprite('island',false)

makeLuaSprite('blue', '',3000,2380)
makeGraphic('blue',3280,30,'37c9fa')
setProperty('blue.alpha',0)
addLuaSprite('blue',false)

makeLuaSprite('m', 'rendersnlogos/mephonerender',1250,50)
setProperty('m.alpha',0)
scaleObject('m',0.35,0.35)
setObjectCamera('m','camHUD')
addLuaSprite('m',false)

makeAnimatedLuaSprite('logo', 'rendersnlogos/invitationaltext',0,0)
addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 7',24,true)
setProperty('logo.alpha',0)
scaleObject('logo',1.25,1.25)
setObjectCamera('logo','camHUD')
screenCenter('logo','xy')
addLuaSprite('logo',true)

makeLuaSprite('transition', '',-1280,0);
makeGraphic('transition',1280,720,'000000')
addLuaSprite('transition',false);
setObjectCamera('transition', 'camHUD')
end

function onEvent(name,v1)
	if name == 'Trigger' and v1 == 'renderin' then
		doTweenX('logoshit5','m',700,1.75,'circOut')
		doTweenAlpha('logoshit3','m',1,2,'quadOut')
		doTweenAlpha('logoshit','logo',1,3,'quadOut')
	elseif name == 'Trigger' and v1 == 'renderout' then
		doTweenX('logoshit6','m',1300,2,'quadIn')
		doTweenAlpha('logoshit4','m',0,2,'quadOut')
		doTweenAlpha('logoshit2','logo',0,1,'quadOut')
	elseif name == 'Trigger' and v1 == 'blueraid' then
	setProperty('island.alpha',0)
	setProperty('healthBar.alpha',0)
	setProperty('iconP1.alpha',0)
	setProperty('iconP2.alpha',0)
	setProperty('blue.alpha',1)
elseif name == 'Trigger' and v1 == 'unblueraid' then
	setProperty('island.alpha',1)
	setProperty('healthBar.alpha',1)
	setProperty('iconP1.alpha',1)
	setProperty('iconP2.alpha',1)
	setProperty('blue.alpha',0)
elseif name == 'Trigger' and v1 == 'move' then
	camstop = true
	setProperty('isCameraOnForcedPos',true)
	doTweenZoom('camgamezoom','camGame',1.25,1,'circOut')
	doTweenX('camX3', 'camFollow',getProperty('boyfriend.x')+300,0.2,'circOut')
doTweenY('camY4', 'camFollow',getProperty('boyfriend.y')+175,0.25,'circOut')
for i = 0,3 do
	noteTweenAlpha('strumdieokay'..i..'',i,0,1,'quadOut')
end
elseif name == 'Trigger' and v1 == 'unmove' then
	camstop = false
	setProperty('isCameraOnForcedPos',false)
	setProperty('camZooming',true)
	doTweenZoom('camgamezoom2','camGame',0.7,1,'circOut')
	for i = 0,3 do
		noteTweenAlpha('strumdieokay2'..i..'',i,1,1,'quadOut')
	end
	elseif name == 'Transition' then
		setProperty('transition.x',-1280)
		doTweenX('part1', 'transition',0,v1, 'linear')
	end
	end

		function onTweenCompleted(tag)
			if tag == 'part1' then
				doTweenX('transitiondie','transition',1280,0.175)
			end
			end

			function onUpdatePost()
			if camstop == true then
			setProperty('camZooming',false)
			end
		end