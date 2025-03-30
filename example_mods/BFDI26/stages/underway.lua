wireArray = {'back','walls','floor','table','furance','smoke','fg','o2','o3','o4','binary','binary2'}

function onCreate() 
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

    --wire
    makeLuaSprite('o4','backgrounds/underway/wire/Subtract',0,0)
    addLuaSprite('o4',true)
    scaleObject('o4',1.75,1.75)
    setScrollFactor('o4',0,0)
    screenCenter('o4','xy')
    setBlendMode('o4','subtract')
    
    makeLuaSprite('o3','backgrounds/underway/wire/Lighten',0,0)
    addLuaSprite('o3',true)
    scaleObject('o3',1.5,1.5)
    setScrollFactor('o3',0,0)
    setBlendMode('o3','lighten')
    screenCenter('o3','xy')

makeLuaSprite('back','backgrounds/underway/wire/Back',550,0)
scaleObject('back',2,2)
setScrollFactor('back',0.97,0.97)
setProperty('back.alpha',0.25)
addLuaSprite('back',false)

makeLuaSprite('walls','backgrounds/underway/wire/Walls',800,550)
scaleObject('walls',1.25,1.25)
addLuaSprite('walls',false)

createInstance('binary', 'flixel.addons.display.FlxBackdrop', {nil, 0x01, 0})
setProperty('binary.x',600)
setProperty('binary.y',400)
loadGraphic('binary', 'backgrounds/underway/wire/binary')
setProperty('binary.velocity.x', -50)
setProperty('binary.color',getColorFromHex('86d0ae'))
addLuaSprite('binary',false)
setProperty('binary.alpha',0.25)

makeLuaSprite('binary2','backgrounds/underway/wire/binary2',2400,850)
addLuaSprite('binary2',false)

makeLuaSprite('floor','backgrounds/underway/wire/floor',-200,1132)
addLuaSprite('floor',false)

makeLuaSprite('table','backgrounds/underway/wire/Table',800,1000)
addLuaSprite('table',false)

makeLuaSprite('furance','backgrounds/underway/wire/Furnace',2000,975)
addLuaSprite('furance',false)

makeLuaSprite('smoke','backgrounds/underway/wire/smoke',750,75)
addLuaSprite('smoke',true)

makeLuaSprite('o2','backgrounds/underway/wire/Multiply',0,50)
addLuaSprite('o2',false)
setScrollFactor('o2',0,0)
scaleObject('o2',1.25,1.25)
screenCenter('o2','xy')
setBlendMode('o2','multiply')

makeLuaSprite('fg','backgrounds/underway/wire/foregroundwireframe',700,1000)
addLuaSprite('fg',true)
setScrollFactor('fg',1.25,1.25)

makeLuaSprite('gp', 'rendersnlogos/gpsrender',1300,-240)
setProperty('gp.alpha',0)
setObjectCamera('gp','camHUD')
scaleObject('gp',0.75,0.75)
addLuaSprite('gp',true)

makeLuaSprite('logo', 'rendersnlogos/underwaytitle',0,0)
setProperty('logo.alpha',0)
setObjectCamera('logo','camHUD')
screenCenter('logo','xy')
addLuaSprite('logo',true)

for i = 1,#wireArray do
setProperty(wireArray[i]..'.visible',false)
end
 --

    -- pov
    makeLuaSprite('bg1','backgrounds/underway/thenightlybackground1',-1300,-340)
    addLuaSprite('bg1',false)
    --

    --side pov
    makeLuaSprite('bg2','backgrounds/underway/thenightlybackground2',0,565)
    addLuaSprite('bg2',false)
    setProperty('bg2.alpha',0.001)
    --

    makeLuaSprite('o1','backgrounds/underway/bluething',0,0)
    addLuaSprite('o1',false)
    scaleObject('o1',1.25,1)
    setObjectCamera('o1','camHUD')
end

function onCreatePost()
    setProperty('gf.alpha',0)
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

    setProperty('boyfriend.alpha',0)
    setProperty('gf.alpha',0)

setScrollFactor('gfGroup',1,1)
setScrollFactor('dadGroup',1.1,1.1)
setObjectOrder('dadGroup',20)
end
function onEvent(name,v1)
if name == 'Trigger' and v1 == 'intro' then
    bfy = getProperty('boyfriend.y')
    gfy = getProperty('gf.y')
debugPrint('hi')
setProperty('boyfriend.alpha',1)
setProperty('gf.alpha',1)

setProperty('boyfriend.y',720)
setProperty('gf.y',670)
doTweenY('bfwowstop','boyfriend',bfy,0.5,'circOut')
doTweenY('gfwowstop','gf',gfy,0.5,'circOut')
elseif name == 'Trigger' and v1 == 'wireframe' then
cameraFlash('camGame','86d0ae',0.5)

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

    setProperty('isCameraOnForcedPos', true)
	doTweenX('camX3', 'camFollow',1600,1,'cubeInOut')
	doTweenY('camY4', 'camFollow',1110,1.35,'cubeInOut')
    doTweenX('binarywow','binary2',0,getRandomInt(5,15))
    setProperty('defaultCamZoom',0.865)


for i = 1,#wireArray do
setProperty(wireArray[i]..'.visible',true)
end
setProperty('bg1.alpha',0)
setProperty('o1.alpha',0.001)
setProperty('dadGroup.y',500)
setProperty('dadGroup.x',-200)

doTweenX('dadahh','dadGroup',1200,1.25,'circOut')

setProperty('boyfriendGroup.y',925)
setProperty('boyfriendGroup.x',1700)

setProperty('gfGroup.y',775)
setProperty('gfGroup.x',1100)


setObjectOrder('dadGroup',15)
setScrollFactor('dadGroup',1,1)
elseif name == 'Trigger' and v1 == 'sidepov' then
alreadySwapped = false
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


    setProperty('isCameraOnForcedPos', false)
    setProperty('defaultCamZoom',0.7)
    setProperty('bg2.alpha',1)
    setProperty('o1.alpha',1)
    for i = 1,#wireArray do
        setProperty(wireArray[i]..'.visible',false)
        end

        setProperty('dadGroup.y',985)
setProperty('dadGroup.x',1800)

setProperty('boyfriendGroup.x',1350)

setProperty('gfGroup.x',1000)
setProperty('gfGroup.y',905)
elseif name == 'Trigger' and v1 == 'manic' then
    for p= 4,7 do
    noteTweenX('movePlayer'..p, p,425 + (110 *(p - 4)), 3.25,'cubeInOut')
    end

    for p= 0,3 do
        noteTweenX('moveOpponent'..p, p,1850 + (115 *(p - 4)), 2.25,'cubeInOut')
        end

    setProperty('isCameraOnForcedPos',true)
	doTweenX('camX23', 'camFollow',1875,1.25,'cubeInOut')
	doTweenY('camY24', 'camFollow',getProperty("dad.y")+350,1.5,'cubeInOut')
	setProperty('defaultCamZoom',0.5)
	doTweenZoom('camGamehihi2','camGame',getProperty('defaultCamZoom'),1.75,'cubeInOut')
end
end

function onUpdatePost()
    setShaderFloat('binary','iTime',os.clock()/4)

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


function onTweenCompleted(name)
if name == 'binarywow' and getProperty('binary2.visible') == true then
    setProperty('binary2.x',getRandomInt(2400,2700))
    setProperty('binary2.y',getRandomInt(825,900))
    doTweenX('binarywow','binary2',0,getRandomInt(5,15))
end
end