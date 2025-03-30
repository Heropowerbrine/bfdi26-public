scribbleArray = {'sky','bush','floor'}

function onCreate() 
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)
    setProperty('camZooming',true)

    makeLuaSprite('beam', 'backgrounds/wrongfinger/balance',-600,-200)
	setProperty('beam.alpha',1)
	setScrollFactor('beam',0.25,0.25)
	addLuaSprite('beam',false)

    makeLuaSprite('mainbg','backgrounds/hard-bargain/mainbg',-110,400)
    addLuaSprite('mainbg')

    makeLuaSprite('sky','backgrounds/hard-bargain/bg1/yellowsky1',-750,-250)
    setScrollFactor('sky',0,0)
    addLuaSprite('sky',false)

    makeLuaSprite('bush','backgrounds/hard-bargain/bg1/yellowbush1',-100,635)
    setScrollFactor('bush',0.95,0.95)
    addLuaSprite('bush',false)

    makeLuaSprite('floor','backgrounds/hard-bargain/bg1/yellowfloor1',-350,840)
    addLuaSprite('floor',false)

    createInstance('bgw', 'flixel.addons.display.FlxBackdrop', {nil, 0x01, 0})
    loadGraphic('bgw', 'backgrounds/hard-bargain/bg3/yellowfacebg')
    setProperty('bgw.velocity.x', -500)
    setProperty('bgw.alpha',0)
    addLuaSprite('bgw',false)

    makeAnimatedLuaSprite('week2','backgrounds/hard-bargain/bg2/halloween_bg',-50,150)
    addLuaSprite('week2',false)
    setProperty('week2.visible',false)

    makeAnimatedLuaSprite('static','backgrounds/hard-bargain/static',0,0)
    addAnimationByPrefix('static','stat','static instance 1',24,true)
    addLuaSprite('static',false)
    setObjectCamera('static','camHUD')

    makeLuaSprite('y', 'rendersnlogos/yellowfacerender',1500,50)
        setProperty('y.alpha',0)
        setObjectCamera('y','camHUD')
        scaleObject('y',0.5,0.5)
        addLuaSprite('y',true)
        
    makeLuaSprite('logo', 'rendersnlogos/hardbargaintitlew',0,0)
    setProperty('logo.alpha',0)
    setObjectCamera('logo','camHUD')
    screenCenter('logo','xy')
    addLuaSprite('logo',true)

    makeLuaSprite('and','backgrounds/hard-bargain/andrew',0,0)
    addLuaSprite('and',true)
    setProperty('and.alpha',0)
    screenCenter('and','xy')
    setObjectCamera('and','camOther')

    makeLuaSprite('bluechard','backgrounds/hard-bargain/bluechard',0,0)
    addLuaSprite('bluechard',true)
    setProperty('bluechard.alpha',0)
    setObjectCamera('bluechard','camOther')
    for i = 1,#scribbleArray do
        setProperty(scribbleArray[i]..'.visible',false)
        end
end

function onEvent(tag,v1)
if tag == 'Trigger' and v1 == 'week2' then
setProperty('week2.visible',true)
elseif tag == 'Trigger' and v1 == 'scribbleback' then
    setProperty('week2.visible',false)
    for i = 1,#scribbleArray do
    setProperty(scribbleArray[i]..'.visible',true)
end
elseif tag == 'Trigger' and v1 == 'static' then
cameraFlash('camGame','ffffff',0.5)
doTweenAlpha('statics','static',0,0.5,'circOut')
elseif tag == 'Trigger' and v1 == 'statictween' then
    doTweenAlpha('statics2','static',1,1.35,'quadOut')
elseif tag == 'Trigger' and v1 == 'colour' then
    setProperty('mainbg.color',getColorFromHex('4D2B2E'))
    setProperty('beam.color',getColorFromHex('4D2B2E'))
    setProperty('mainbg.alpha',1)
setProperty('beam.alpha',1)
    setProperty('bgw.alpha',0)
elseif tag == 'Trigger' and v1 == 'funny' then
setProperty('mainbg.alpha',0)
setProperty('beam.alpha',0)
setProperty('boyfriendGroup.x',getProperty('boyfriendGroup.x')+200)
setProperty('boyfriendGroup.y',getProperty('boyfriendGroup.y')-50)
setProperty('bgw.alpha',1)
    for i = 1,#scribbleArray do
    setProperty(scribbleArray[i]..'.visible',false)
    end
elseif tag == 'Trigger' and v1 == 'andrew' then
setProperty('canPause',false)
setProperty('camHUD.alpha',0)
setProperty('camGame.alpha',0)
setProperty('and.alpha',0)
doTweenScale('anddie','and',1.75,40)
doTweenX('andlastly','and',-300,50)
doTweenAlpha('andlive','and',1,10)
elseif tag == 'Trigger' and v1 == 'blue' then
    doTweenX('andlastly2','bluechard',500,50)
    doTweenAlpha('andlive2','bluechard',1,5)
end
end

function doTweenScale(tag,obj,x,y,time,ease)
    doTweenX(tag..'x',obj..'.scale',x,time,ease)
    doTweenY(tag..'y',obj..'.scale',y,time,ease)
  end