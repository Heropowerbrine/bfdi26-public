local cutscene = true
local start = 0
local clicked = false

function onStartCountdown()    
    if cutscene == true and start == 0 then
            return Function_Stop;
    end
end

function onCreate() 
	makeLuaSprite('backgroundgame','backgrounds/himshey/candybarbackground',-775,50)
	scaleObject('backgroundgame',0.75,0.75)
	addLuaSprite('backgroundgame')

	makeLuaSprite('background','backgrounds/himshey/candybarbackdrop',-25,-25)
	setProperty('background.visible',true)
	setObjectCamera('background','other')
	addLuaSprite('background')

	makeLuaSprite('title','backgrounds/himshey/titleeeeeee',85,100)
	setProperty('title.visible',true)
	setObjectCamera('title','other')
	addLuaSprite('title')

	makeLuaSprite('button','backgrounds/himshey/play_button',150,500)
	setProperty('button.visible',true)
	setObjectCamera('button','other')
	addLuaSprite('button')

	makeLuaSprite('f', 'rendersnlogos/fireyrender',1000,50)
	scaleObject('f',0.35,0.35)
    setProperty('f.alpha',0)
    setObjectCamera('f','camHUD')
    addLuaSprite('f',false)

    makeAnimatedLuaSprite('logo', 'rendersnlogos/himsheystext',0,0)
    addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 6',24,true)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)

	makeAnimatedLuaSprite('match', 'backgrounds/himshey/matchbg',925,475)
    setScrollFactor('match',0.95,0.95)
    addAnimationByPrefix('match', 'bop', 'match',24,false)
	setProperty('match.antialiasing',false)
    addLuaSprite('match',false)

	makeAnimatedLuaSprite('sb', 'backgrounds/himshey/snowballwalking',-480,855)
    setScrollFactor('sb',1.15,1.15)
	scaleObject('sb',0.85,0.85)
    addAnimationByPrefix('sb', 'walk', 'snowballs',24,true)
	setProperty('sb.antialiasing',false)
    addLuaSprite('sb',true)
end

function onCreatePost()
	setProperty('camGame.x',-200)
	setProperty('logo.x',getProperty('logo.x')-150)
end

function onUpdatePost()

	if getMouseX('other') >180 and getMouseX('other') <775 and getMouseY('other') >512 and getMouseY('other') <705 then
	doTweenX('buttonsize','button.scale',1.05,0.25,'circOut')
	doTweenY('buttonsize3','button.scale',1.05,0.25,'backOut')
	cancelTween('buttonsize2')
	cancelTween('buttonsize4')
else
		cancelTween('buttonsize')
		cancelTween('buttonsize3')
		doTweenX('buttonsize2','button.scale',1,0.25,'circOut')
		doTweenY('buttonsize4','button.scale',1,0.25,'backOut')
end
if mouseClicked('left') and getMouseX('other') >180 and getMouseX('other') <775 and getMouseY('other') >512 and getMouseY('other') <705 and clicked == false then
		setProperty('skipCountdown',true)
		setProperty('buttongrahpic.y',1500)

		doTweenX('titlesize','title.scale',0,1.25,'circOut')
		doTweenY('titlesize2','title.scale',0,1.25,'backOut')

		doTweenAlpha('buttondie','button',0,1,'quadOut')
		
		cutscene = false
		clicked = true
		runTimer('die',1.25)
	startCountdown()
	return Function_Continue;
    end
end

function onBeatHit()
if curBeat % 2 == 0 then
objectPlayAnimation('match','bop')
end
end

function onTimerCompleted(tag)
if tag == 'die' then
doTweenAlpha('bgshit','background',0,0.5,'quadOut')
end
end

function onEvent(name,v1)
	if name == 'Trigger' and v1 == 'renderin' then
		setProperty('defaultCamZoom',0.8)
		doTweenX('logoshit5','f',450,1.75,'circOut')
		doTweenAlpha('logoshit3','f',1,2,'quadOut')
		doTweenAlpha('logoshit','logo',1,3,'quadOut')
	elseif name == 'Trigger' and v1 == 'renderout' then
		doTweenX('logoshit6','f',1000,2,'quadIn')
		doTweenAlpha('logoshit4','f',0,2,'quadOut')
		doTweenAlpha('logoshit2','logo',0,1,'quadOut')
	elseif name == 'Trigger' and v1 == 'sbwalk' then
	doTweenX('sbwalking','sb',1500,25)
	end
	end