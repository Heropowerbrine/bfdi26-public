function onCreate()
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

makeLuaSprite('iwi','backgrounds/pls/iwiBACKG',3900,-1300)
addLuaSprite('iwi',false)

makeAnimatedLuaSprite('g', 'backgrounds/pls/purpleghostbg',4700,1725)
addAnimationByPrefix('g', 'bop', 'purple',24,true)
setScrollFactor('g',0.95,0.95)
addLuaSprite('g',false)

makeLuaSprite('ch', 'rendersnlogos/chezrender',1350,50)
setProperty('ch.alpha',0)
setObjectCamera('ch','camHUD')
addLuaSprite('ch',false)

makeAnimatedLuaSprite('logo', 'rendersnlogos/plstext',0,0)
addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 11',24,true)
setProperty('logo.alpha',0)
scaleObject('logo',1.25,1.25)
setObjectCamera('logo','camHUD')
screenCenter('logo','xy')
addLuaSprite('logo',true)
end

function onEvent(name,v1)
if name == 'Trigger' and v1 == 'renderin' then
        doTweenAlpha('logoshit3','ch',1,2,'quadOut')
        doTweenX('logoshit5','ch',650,1.75,'circOut')
        doTweenAlpha('logoshit','logo',1,2,'quadOut')
elseif name == 'Trigger' and v1 == 'renderout' then
        doTweenX('logoshit6','ch',1350,2,'quadIn')
        doTweenAlpha('logoshit4','ch',0,2,'quadOut')
        doTweenAlpha('logoshit2','logo',0,2,'quadOut')
end
end