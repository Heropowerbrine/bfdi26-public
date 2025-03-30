officeArray = {'office','desk','tboss','officebroken'}

spaceArray = {'stars','ship','fgdesk','wheel','pence'}

planetArray = {'sky','skym','skymm','ground'}

notspace = true

function onCreate() 
	setProperty('textmiss.alpha',1)
    setProperty('camZooming',true)

-- planet
makeLuaSprite('sky','backgrounds/help-me/planet/sky planet',-500,-200)
setScrollFactor('sky',0.1,0.1)
addLuaSprite('sky',false)

makeLuaSprite('skym','backgrounds/help-me/planet/mist planet',-1000,125)
setScrollFactor('skym',0.15,0.15)
addLuaSprite('skym',false)

makeLuaSprite('skymm','backgrounds/help-me/planet/moon planet',100,-75)
setScrollFactor('skymm',0.15,0.15)
addLuaSprite('skymm',false)

makeLuaSprite('ground','backgrounds/help-me/planet/ground planet',600,530)
addLuaSprite('ground',false)

makeLuaSprite('hours','backgrounds/help-me/planet/hours',0,0)
addLuaSprite('hours',false)
setObjectCamera('hours','camOther')
screenCenter('hours','xy')
setProperty('hours.alpha',0)
--

-- office
    makeLuaSprite('officebroken','backgrounds/help-me/office/walls smashed',0,0)
    addLuaSprite('officebroken',false)

    makeLuaSprite('office','backgrounds/help-me/office/walls full',0,0)
    addLuaSprite('office',false)

    makeLuaSprite('desk','backgrounds/help-me/office/desk goes in front',1450,985)
    addLuaSprite('desk',true)
--

-- space
makeLuaSprite('stars', '',-500,0)
makeGraphic('stars',1280,720,'000000')
setProperty('stars.visible',false)
scaleObject('stars',2,2)
setScrollFactor('stars',0.15,0.15)
setSpriteShader('stars','stars')
addLuaSprite('stars',false)

makeLuaSprite('ship','backgrounds/help-me/space/ship full',250,265)
addLuaSprite('ship',false)
setProperty('ship.visible',false)

makeAnimatedLuaSprite('pence','backgrounds/help-me/space/pence ahh dance',1225,1050)
addAnimationByPrefix('pence','dance','pence instance 1',24,true)
addLuaSprite('pence',false)
setProperty('pence.visible',false)

makeAnimatedLuaSprite('wheel','backgrounds/help-me/space/roz wheel front',1725,1075)
addAnimationByPrefix('wheel','hold','wheel front instance 1',24,true)
addLuaSprite('wheel',true)
setProperty('wheel.visible',false)

makeLuaSprite('fgdesk','backgrounds/help-me/space/foreground shit',175,1175)
addLuaSprite('fgdesk',true)
setScrollFactor('fg',1.05,1.05)
setProperty('fgdesk.visible',false)

makeAnimatedLuaSprite('tboss','characters/boss fuhd up',1825,590)
addAnimationByPrefix('tboss','idle','boss fucked up idle instance 1',24,true)
addLuaSprite('tboss',true)
setProperty('tboss.visible',false)
--
makeLuaSprite('b', 'rendersnlogos/bossrender',1300,120)
setProperty('b.alpha',0)
setObjectCamera('b','camHUD')
scaleObject('b',0.5,0.5)
addLuaSprite('b',true)

makeLuaSprite('logo', 'rendersnlogos/helpmetitle',0,0)
setProperty('logo.alpha',0)
setObjectCamera('logo','camHUD')
screenCenter('logo','xy')
addLuaSprite('logo',true)
end

function onCreatePost()
if shaderEnabled then
	initLuaShader("stars");
end

    setScrollFactor('gfGroup',1,1)
	for i = 0, 3 do
		j = (i + 4)

		iPos = _G['defaultPlayerStrumX'..i];
		jPos = _G['defaultOpponentStrumX'..i];
		if alreadySwapped then
				iPos = _G['defaultOpponentStrumX'..i];
				jPos = _G['defaultPlayerStrumX'..i];
		end
		noteTweenX('note'..i..'TwnX', i, iPos, 1.35, 'elasticInOut');
		noteTweenX('note'..j..'TwnX', j, jPos, 1.35, 'elasticInOut');
		if middlescroll == true then
			noteTweenX('note'..i..'TwnX',j,iPos, 1.35, 'elasticInOut');
			noteTweenX('note'..j..'TwnX',i,jPos, 1.35, 'elasticInOut');
		end
end
end

function onSectionHit()
    if mustHitSection and notspace then
triggerEvent('Play Animation','idle-alt','gf')
triggerEvent('Alt Idle Animation','gf','-alt')
elseif not mustHitSection and notspace then
triggerEvent('Play Animation','idle','gf')
triggerEvent('Alt Idle Animation','gf','')
    end
    end


function onUpdatePost()
	setShaderFloat('stars','iTime',os.clock())

    P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)

    setProperty('iconP1.x',P1Mult - 110)
    setProperty('iconP1.origin.x',240)
    setProperty('iconP1.flipX',true)
    setProperty('iconP2.x',P2Mult + 110)
    setProperty('iconP2.origin.x',-100)
    setProperty('iconP2.flipX',true)
    setProperty('healthBar.flipX',true)
	end

function onEvent(name,v1)
    if name == 'Trigger' and v1 == 'transitionspace' then
doTweenZoom('camGameshit','camGame',getProperty('defaultCamZoom')-0.1,0.75,'quadInOut')
elseif name == 'Trigger' and v1 == 'bosswindow' then
    notspace = false
    setProperty('tboss.x',847.5)
    setProperty('tboss.y',300)
addAnimationByPrefix('tboss','smash','boss window smash instance 10',24,false)
setProperty('tboss.visible',true)
setProperty('dad.alpha',0)
elseif name == 'Trigger' and v1 == 'space' then
    triggerEvent('Screen Shake','27,0.001','27,0.00025')
    cameraFlash('camGame','000000',2)
	setProperty('bars.alpha',1)
    setProperty('camFollow.x',1300)
    setProperty('camFollow.y',985)
    setProperty('isCameraOnForcedPos', true)



    for i = 1,#spaceArray do
        setProperty(spaceArray[i]..'.visible',true)
        end

    for i = 1,#officeArray do
        setProperty(officeArray[i]..'.visible',false)
        end
elseif name == 'Trigger' and v1 == 'planet' then
    setProperty('defaultCamZoom',1.1)
    setProperty('boyfriendGroup.x',getProperty('boyfriend.x')+740)
    setProperty('boyfriendGroup.y',getProperty('boyfriend.y')-70)
    setProperty('gfGroup.x',getProperty('gf.x')-565)
    setProperty('gfGroup.y',getProperty('gf.y')+225)
    setProperty('isCameraOnForcedPos', false)
    cameraFlash('camGame','000000',2)
	setProperty('bars.alpha',0)

        for i = 1,#spaceArray do
            setProperty(spaceArray[i]..'.visible',false)
            end
        elseif name == 'Trigger' and v1 == 'hours' then
        doTweenAlpha('hourscomein','hours',1,1.25,'quadOut')
        doTweenAlpha('byehud','camHUD',0,1.25,'quadOut')
        elseif name == 'Trigger' and v1 == 'blah' then
            setProperty('defaultCamZoom',1.2)
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x',1500)
doTweenAlpha('hoursdie','hours',0,5.25,'quadOut')
setObjectOrder('gfGroup',100)
    end
end

function onTweenCompleted(tag)
if tag == 'camGameshit' then
    doTweenZoom('camGameshit2','camGame',2.5,1.25,'cubeIn')
end
end