function onCreate() 
	setProperty('camGame.bgColor', getColorFromHex('FFFFFF'))
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

	makeLuaSprite('cc', 'circledie',0,0)
    setProperty('cc.alpha',0)
	scaleObject('cc',1.422,1.422)
    setObjectCamera('cc','other')
    addLuaSprite('cc',false)

	makeLuaSprite('c', 'rendersnlogos/circlerender',1000,50)
    setProperty('c.alpha',0)
    setObjectCamera('c','camHUD')
    addLuaSprite('c',false)

    makeAnimatedLuaSprite('logo', 'rendersnlogos/wellroundedtext',0,0)
    addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 4',24,true)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)
end


function onCreatePost()
        setScrollFactor('gfGroup',0.25,0.25)
        end

function onEvent(name,v1)
	if name == 'Trigger' and v1 == 'renderin' then
        setProperty('camGame.visible',true)
        setProperty('camHUD.visible',true)
        setProperty('camGame.filtersEnabled',true)
        doTweenAlpha('logoshit3','c',1,2,'quadOut')
        doTweenX('logoshit5','c',650,1.75,'circOut')
        doTweenAlpha('logoshit','logo',1,2,'quadOut')
	elseif name == 'Trigger' and v1 == 'renderout' then
        doTweenX('logoshit6','c',1250,2,'quadIn')
        doTweenAlpha('logoshit4','c',0,2,'quadOut')
        doTweenAlpha('logoshit2','logo',0,2,'quadOut')
        elseif name == 'Trigger' and v1 == 'characterchange' then
                setProperty('isCameraOnForcedPos', true)
        doTweenY('daddie','dad',getProperty('dad.y')+750,1.25,'cubeInOut')
        doTweenY('bfdie','boyfriend',getProperty('boyfriend.y')+750,1.25,'cubeInOut')
        doTweenY('camY', 'camFollow',getProperty('camFollow.y')-500,1,'cubeInOut')
        doTweenZoom('camZoom','camGame',getProperty('defaultCamZoom')+0.35,1.25,'cubeInOut')
	end
	end

        function onTweenCompleted(tag)
        if tag == 'bfdie' then
                setProperty('isCameraOnForcedPos',false)
        doTweenZoom('camZoom2','camGame',getProperty('defaultCamZoom'),1.25,'cubeInOut')
        elseif tag == 'camY' then
                doTweenY('camY2', 'camFollow',getProperty('camFollow.y')+500,1,'cubeInOut') 
        end
end