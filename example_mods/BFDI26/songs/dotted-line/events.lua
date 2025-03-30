background1 = true
background2 = false
background3 = false

function onCreatePost()
    for i = 0, 3 do
		j = (i + 4)

		iPos = _G['defaultPlayerStrumX'..i];
		jPos = _G['defaultOpponentStrumX'..i];
		if alreadySwapped then
				iPos = _G['defaultOpponentStrumX'..i];
				jPos = _G['defaultPlayerStrumX'..i];
		end
		noteTweenX('note'..i..'TwnX', i, iPos, 1.25, 'cubeInOut');
		noteTweenX('note'..j..'TwnX', j, jPos, 1.25, 'cubeInOut');
		if middlescroll == true then
			noteTweenX('note'..i..'TwnX',j,iPos, 1.25, 'cubeInOut');
			noteTweenX('note'..j..'TwnX',i,jPos, 1.25, 'cubeInOut');
		end
end

    for _, backgroundsprite2 in ipairs({'sky','water','shelf','plant','chair','add','force'}) do
    setProperty(backgroundsprite2..'.visible',false)
end
    for _, background3 in ipairs({'skyb','ground','grass','grass2','grass3','grass4','land','grad'}) do
        setProperty(background3..'.visible',false)
end
    setProperty('swirl.visible',true)
end

function onEvent(tag,v1)
if tag == 'Trigger' and v1 == 'spookytween' then
    doTweenZoom('camGamesht3','camGame',2.051,2.75,'cubeInOut')
    doTweenAlpha('vshitend2','v',0.75,1,'cubeInOut')
elseif tag == 'Trigger' and v1 == 'pause' then
setProperty('canPause',true)
elseif tag == 'Trigger' and v1 == 'background2' then
    cancelTween('camGamesht3')
    cancelTween('vshitend2')
    setProperty('bfPhantom.visible',false)
    setProperty('bfPhantom2.visible',false)
    setProperty('dadPhantom.visible',false)
    setProperty('dadPhantom2.visible',false)
    setShaderFloat('temporaryShader','amount',0)
    for _, backgroundsprite2 in ipairs({'sky','water','shelf','plant','chair','add','force'}) do
        setProperty(backgroundsprite2..'.visible',true)
        setObjectOrder('dadGroup',getObjectOrder('chair')-1)
        setProperty('swirl.visible',false)
        for i = 1,5 do
        setProperty('star'..i..'.visible',false)
        end
setProperty('cameraSpeed',1)
        background1 = false
        background2 = true

        alreadySwapped = true
    for i = 0, 3 do
		j = (i + 4)

		iPos = _G['defaultPlayerStrumX'..i];
		jPos = _G['defaultOpponentStrumX'..i];
		if alreadySwapped then
				iPos = _G['defaultOpponentStrumX'..i];
				jPos = _G['defaultPlayerStrumX'..i];
		end
		noteTweenX('note'..i..'TwnX', i, iPos, 1.25, 'cubeInOut');
		noteTweenX('note'..j..'TwnX', j, jPos, 1.25, 'cubeInOut');
		if middlescroll == true then
			noteTweenX('note'..i..'TwnX',j,iPos, 1.25, 'cubeInOut');
			noteTweenX('note'..j..'TwnX',i,jPos, 1.25, 'cubeInOut');
		end
end

    end

elseif tag == 'Trigger' and v1 == 'background3' then
    for _, background3 in ipairs({'skyb','ground','grass','grass2','grass3','grass4','land','grad'}) do
    setProperty(background3..'.visible',true)
    background3 = true
    background2 = false

    for p= 4,7 do
        noteTweenX('movePlayer'..p, p,425 + (110 *(p - 4)), 3.25,'cubeInOut')
        end
    
        for p= 0,3 do
            noteTweenX('moveOpponent'..p, p,-850 + (115 *(p - 4)), 2.25,'cubeInOut')
            end
    end
    for _, backgroundsprite2 in ipairs({'sky','water','shelf','plant','chair','add','force'}) do
        setProperty(backgroundsprite2..'.visible',false)
    end
    setObjectOrder('dadGroup',getObjectOrder('boyfriendGroup')+2)
    setObjectOrder('grad',getObjectOrder('boyfriendGroup')+1)
    setProperty('dadGroup.x',getProperty('dadGroup.x')+270)
    setProperty('boyfriendGroup.y',getProperty('boyfriendGroup.y')+420)
    setProperty('camGame.zoom',1.5)
    doTweenZoom('camGamesht','camGame',0.751,1.25,'quintInOut')
    setProperty('defaultCamZoom',0.751)
    doTweenAlpha('vignetteendstuff','v',0.5,1,'quadOut')
    setProperty('isCameraOnForcedPos', true)
    setProperty('camFollow.x',610)
    setProperty('camFollow.y',310)
elseif tag == 'Trigger' and v1 == 'endtween' then
    doTweenZoom('camGamesht2','camGame',2.251,5.5,'cubeInOut')
    doTweenAlpha('vshitend','v',1,2,'cubeInOut')
end
end

function onTweenCompleted(tag)
if tag == 'camGamesht' then
setProperty('cameraSpeed',0)
end
end