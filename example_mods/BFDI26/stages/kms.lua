function onCreate() 
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

    makeLuaSprite('p1','backgrounds/kms/BG',0,400)
    addLuaSprite('p1',false)
    scaleObject('p1',1,1)
    setProperty('p1.alpha',1)

	makeLuaSprite('p', 'rendersnlogos/popcorn render',1500,50)
    setProperty('p.alpha',0)
    scaleObject('p',0.75,0.75)
    setObjectCamera('p','camHUD')
    addLuaSprite('p',false)

    makeAnimatedLuaSprite('logo', 'rendersnlogos/fkms',0,0)
    addAnimationByPrefix('logo', 'title', 'text',24,true)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)

    makeAnimatedLuaSprite('puss', 'backgrounds/kms/thisguyfuckingrocks',-5,840)
    addAnimationByPrefix('puss', 'stupid', 'nutty stroll instance',24,true)
    scaleObject('puss',1.75,1.75)
    addLuaSprite('puss',true)
end

function onCreatePost()
setObjectOrder('dadGroup',getObjectOrder('puss')-1)
end

function onEvent(name,v1)
    if name == 'Trigger' and v1 == 'renderin' then
            doTweenAlpha('logoshit3','p',1,2,'quadOut')
            doTweenX('logoshit5','p',800,1.75,'circOut')
            doTweenAlpha('logoshit','logo',1,2,'quadOut')
    elseif name == 'Trigger' and v1 == 'renderout' then
            doTweenAlpha('logoshit2','logo',0,2,'quadOut')
            doTweenX('logoshit6','p',1500,2,'quadIn')
            doTweenAlpha('logoshit4','p',0,2,'quadOut')
    elseif name == 'Trigger' and v1 == 'nutstart' then
            doTweenX('pussytween','puss',850,3.1,'linear')
    elseif name == 'Trigger' and v1 == 'nutstop' then
            addAnimationByPrefix('puss', 'stop', 'nutty stop instance',24,false)
    end
    end
        function onUpdatePost()
            if getProperty('puss.animation.curAnim.finished') and getProperty("puss.animation.curAnim.name") == 'stop' then
                    addAnimationByPrefix('puss', 'turn', 'nutty turn instance',24,false)
            elseif getProperty('puss.animation.curAnim.finished') and getProperty("puss.animation.curAnim.name") == 'turn' then
                    addAnimationByPrefix('puss', 'stupid', 'nutty macarena instance',24,true)
                    setProperty('puss.x',815)
            end
    end