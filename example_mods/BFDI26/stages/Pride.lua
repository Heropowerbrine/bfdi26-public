amount = 0

function onSongStart()
	setProperty("canPause", false)
	setProperty('camGame.alpha',0)
    for _, hudout in ipairs({'uiGroup','bars','textmiss','scoreTxt','hyper','textacc'}) do
setProperty(hudout..'.alpha',0)
setProperty('canPause',false)
	end

    for p= 4,7 do
		noteTweenX('movePlayer'..p, p,1625 + (110 *(p - 4)), 0.25,'cubeInOut')
		end
	
		for p= 0,3 do
			noteTweenX('moveOpponent'..p, p,-450 + (115 *(p - 4)), 0.25,'cubeInOut')
			end

    setProperty('isCameraOnForcedPos', true)
	setProperty('camFollow.y',0)
	setProperty('camFollow.x',800)

	if createfile == true then
		saveFile('BFDI26/weeks/8.json',
[[{
	"storyName": "pridemfonfplideflag",
	"difficulties": "normal",
	"hideFreeplay": false,
	"weekBackground": "stage",
	"weekBefore": "tutorial",
	"freeplayColor": [
		146,
		113,
		253
	],
	"startUnlocked": true,
	"hideStoryMode": true,
	"songs": [
		[
			"web-crasher",
			"prideflag",
			[
				255,
				255,
				255
			]
		]
	],
	"weekCharacters": [
		"dad",
		"bf",
		"gf"
	],
	"hiddenUntilUnlocked": false,
	"weekName": "fello"
}]])
		end
end

function onTweenCompleted(tag)
	if tag == 'healthTween' then
		doTweenColor('healthTween2','healthBar.leftBar','00FF00',1.5)
	elseif tag == 'healthTween2' then
		doTweenColor('healthTween3','healthBar.leftBar','0000FF',1.5)
	elseif tag == 'healthTween3' then
		doTweenColor('healthTween','healthBar.leftBar','FF0000',1.5)
	end
	end

function onCreate() 
	if checkFileExists("BFDI26/weeks/8.json") then
		createfile = false
		else
		createfile = true
		end

	doTweenZoom('camGamehihi','camGame',4,0.001)
	setProperty('camGame.bgColor', getColorFromHex('FFFFFF'))
	setProperty('textmiss.alpha',1)
	setProperty('bars.alpha',1)

	makeLuaSprite('galaxy', 'backgrounds/web-crasher/galaxybg',-750,-200)
	setProperty('galaxy.alpha',0)
	setScrollFactor('galaxy',0.5,0.5)
	addLuaSprite('galaxy',false)

makeLuaSprite('hyper','backgrounds/web-crasher/hypercam',625,0)
setObjectCamera('hyper','other')
scaleObject('hyper',0.25,0.25)
addLuaSprite('hyper',true)

makeLuaSprite("ytpmv", null, 275, 423)
makeGraphic("ytpmv", 400, 232.5, 'FFFFF')
setObjectCamera("ytpmv", 'hud')
addLuaSprite("ytpmv",false)
setProperty("ytpmv.alpha",0)

  makeLuaText('textThis', 'THIS',1000,-125,150)
  setProperty('textThis.alpha',0)
  setTextSize('textThis',200)
  setTextFont('textThis','impact.TTF')
  setObjectCamera('textThis','other')
  addLuaText('textThis',true)

  makeLuaText('textIs', 'IS',1000,175,150)
  setProperty('textIs.alpha',0)
  setTextSize('textIs',200)
  setTextFont('textIs','impact.TTF')
  setObjectCamera('textIs','other')
  addLuaText('textIs',true)

  makeLuaText('textSparta', 'SPARTA',1000,75,360)
  setProperty('textSparta.x',-20)
  setProperty('textSparta.alpha',0)
  setTextSize('textSparta',200)
  setTextFont('textSparta','impact.TTF')
  setObjectCamera('textSparta','other')
  addLuaText('textSparta',true)
end

function onCreatePost()
setProperty('gf.visible',false)
setProperty('boyfriend.visible',false)
setProperty('camGame.x',-200)

if (shadersEnabled) then
	initLuaShader("compressed");
	initLuaShader("galaxy");
	setSpriteShader('hyper','compressed')
	setSpriteShader("galaxy", "galaxy");
end
end

function onUpdatePost()
setShaderFloat('galaxy','iTime',os.clock()*2)
end

function onEvent(name,v1)
if name == 'Trigger' and v1 == 'cutscene' then
	elseif name == 'Trigger' and v1 == 'hudcomein' then
	    for _, hudout in ipairs({'uiGroup','textmiss','scoreTxt','hyper','textacc','bars'}) do
		doTweenAlpha('comeback'..hudout..'',hudout,1,1,'quadOut')
				end
				alreadySwapped = true
				for i = 0, 3 do
					j = (i + 4)
				
					iPos = _G['defaultPlayerStrumX'..i];
					jPos = _G['defaultOpponentStrumX'..i];
					if alreadySwapped then
							iPos = _G['defaultOpponentStrumX'..i]-60;
							jPos = _G['defaultPlayerStrumX'..i]-225;
					end
					noteTweenX('note'..i..'TwnX', i, iPos, 1.25, 'cubeInOut');
					noteTweenX('note'..j..'TwnX', j, jPos, 1.25, 'cubeInOut');
				end
	
	elseif name == 'Trigger' and v1 == 'speedshit' then
		setProperty('gf.visible',true)
		triggerEvent('Change Character','gf','hourgirl')
		setProperty('isCameraOnForcedPos',false)
		setProperty('cameraSpeed',2)
		doTweenColor('healthTween','healthBar.leftBar','FF0000',1.5)
		setProperty('canPause',true)
		setProperty('camGame.alpha',1)
		setProperty('defaultCamZoom',0.825)
	elseif name == 'Trigger' and v1 == 'badapple' then
setProperty('boyfriend.color',getColorFromHex('000000'))
setProperty('gf.color',getColorFromHex('000000'))
setProperty('dad.color',getColorFromHex('000000'))
	elseif name == 'Trigger' and v1 == 'badappleend' then
		setProperty('cameraSpeed',1000)
		setProperty('camGame.zoom',1.1)
		setProperty('defaultCamZoom',1.1)
		setProperty('boyfriend.color',getColorFromHex('FFFFFF'))
		setProperty('gf.color',getColorFromHex('FFFFFF'))
		setProperty('dad.color',getColorFromHex('FFFFFF'))
	elseif name == 'Trigger' and v1 == 'sparta' then
setProperty('camGame.visible',false)
setObjectCamera('gf','camHUD')
screenCenter('boyfriend','xy')
screenCenter('gf','xy')
setProperty('gf.y',getProperty('gf.y')+215)
setProperty("ytpmv.alpha",1)
setObjectOrder('ytpmv',getObjectOrder('boyfriendGroup')+5)
setObjectOrder('gfGroup',getObjectOrder('ytpmv')+5)
	elseif name == 'Trigger' and v1 == 'nosparta' then
		setProperty('camGame.visible',true)
		setObjectCamera('gf','camGame')
		setObjectCamera('dad','camGame')
		setObjectCamera('boyfriend','camGame')
		setProperty("ytpmv.alpha",0)
		setProperty('gf.y',getProperty('gf.y')+215)
		setProperty('gf.x',getProperty('gf.x')+210)
	elseif name == 'Trigger' and v1 == 'normal' then
		setProperty('cameraSpeed',2)
		setProperty('defaultCamZoom',0.825)
	elseif name == 'Trigger' and v1 == 'galaxy' then
		cameraFlash('camHUD', 'FFFFFF',1);
	doTweenAlpha('galaxystuff1','galaxy',1,1.5,'quadOut')
	setObjectOrder('galaxy',getObjectOrder('gfGroup')-1)
	elseif name == 'Trigger' and v1 == 'partytime' then
		setObjectOrder('dadGroup',getObjectOrder('boyfriendGroup')+2)
		setObjectOrder('gfGroup',getObjectOrder('boyfriendGroup')-1)
		cameraFlash('camHUD', 'FFFFFF',1);
elseif name == 'Trigger' and v1 == 'end' then
	cameraFlash('camOther', 'FFFFFF',1);
	end
	end