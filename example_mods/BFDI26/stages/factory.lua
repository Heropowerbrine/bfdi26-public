function onCreate() 
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

	makeAnimatedLuaSprite('factory', 'backgrounds/bossy/factory',-500,0)
    addAnimationByPrefix('factory', 'factory', 'Symbol 3 copy instance 1',24,true)
    addLuaSprite('factory', false)

makeLuaSprite('subtract','backgrounds/bossy/SUBTRACTalpha16bgoverlay',-300,0)
setBlendMode('subtract','subtract')
setProperty('subtract.alpha',0.16)
addLuaSprite('subtract',false)

makeLuaSprite('light','backgrounds/bossy/MULTIPLYY',0,100)
addLuaSprite('light',true)
setBlendMode('light','multiply')
scaleObject('light',2,2)
screenCenter('light','x')

makeAnimatedLuaSprite('fire','backgrounds/bossy/boomboom',-335,275)
addAnimationByPrefix('fire','boom','kablooey0',24,false)
setProperty('fire.visible',false)
addLuaSprite('fire',true)

makeLuaSprite('g', 'rendersnlogos/gbrender',-500,120)
setProperty('g.alpha',1)
setObjectCamera('g','camHUD')
scaleObject('g',0.65,0.65)
addLuaSprite('g',true)

makeLuaSprite('logo', 'rendersnlogos/bossytitle',0,0)
setProperty('logo.alpha',0)
setObjectCamera('logo','camHUD')
screenCenter('logo','xy')
addLuaSprite('logo',true)
end

function onEvent(tag,v1)
if tag == 'Trigger' and v1 == 'boom' then
	debugPrint('well hi explode')
setProperty('fire.visible',true)
playAnim('fire','boom')
end
end