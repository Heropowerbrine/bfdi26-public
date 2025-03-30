local cutscene = true
local start = 0
local clicked = false

function onStartCountdown()    
    if cutscene == true and start == 0 then
            return Function_Stop;
    end
end

function onCreate() 
	makeLuaSprite('backgroundgame','backgrounds/himsheys-TIRD/snowballs bank',-100,100)
	addLuaSprite('backgroundgame')

	makeLuaSprite('background','backgrounds/himshey/candybarbackdrop',-25,-25)
	setProperty('background.visible',true)
	setObjectCamera('background','other')
	addLuaSprite('background')

	makeLuaSprite('title','backgrounds/himsheys-TIRD/title tird',25,100)
	setProperty('title.visible',true)
	scaleObject('title',0.75,0.75)
	setObjectCamera('title','other')
	addLuaSprite('title')

	makeLuaSprite('button','backgrounds/himshey/play_button',150,500)
	setProperty('button.visible',true)
	setObjectCamera('button','other')
	addLuaSprite('button')

	makeLuaSprite('f', 'rendersnlogos/tirdrender',1000,150)
	scaleObject('f',0.3,0.3)
    setProperty('f.alpha',0)
    setObjectCamera('f','camHUD')
    addLuaSprite('f',false)

    makeAnimatedLuaSprite('logo', 'rendersnlogos/himsheystext',0,0)
    addAnimationByPrefix('logo', 'title', 'Symbol 3 copy 6',24,true)
	screenCenter('logo','xy')
	setProperty('logo.alpha',0)
	setObjectCamera('logo','camHUD')
    addLuaSprite('logo',true)

	makeAnimatedLuaSprite('match', 'backgrounds/himsheys-TIRD/match walk up bop',75,575)
    setScrollFactor('match',1.15,1.15)
	setProperty('match.visible',false)
    addAnimationByPrefix('match', 'bop', 'match idle instance 1',24,false)
    addLuaSprite('match',true)

	makeAnimatedLuaSprite('matchw', 'backgrounds/himsheys-TIRD/match walk up',-436,501)
    setScrollFactor('matchw',1.15,1.15)
	setProperty('matchw.antialiasing',false)
    addLuaSprite('matchw',true)

	makeAnimatedLuaSprite('sb', 'backgrounds/himsheys-TIRD/snowball bop',850,355)
    setScrollFactor('sb',0.925,0.925)
    addAnimationByPrefix('sb', 'bopp', 'snoball instance 1',24,false)
	setProperty('sb.antialiasing',false)
    addLuaSprite('sb',false)
end

function onCreatePost()
	setProperty('camGame.x',-200)
	setProperty('logo.x',getProperty('logo.x')-150)
end

	

function onUpdatePost()
	if getProperty('matchw.animation.curAnim.finished') and getProperty("matchw.animation.curAnim.name") == 'walk' then
        setProperty('matchw.visible',false)
		setProperty('match.visible',true)
	end

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

	function onTimerCompleted(tag)
		if tag == 'die' then
		doTweenAlpha('bgshit','background',0,0.5,'quadOut')
		end
		end

function onBeatHit()
if curBeat % 2 == 0 then
objectPlayAnimation('match','bop')
objectPlayAnimation('sb','bopp')
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
	elseif name == 'Trigger' and v1 == 'matchwalk' then
		addAnimationByPrefix('matchw', 'walk', 'match walk up instance 1',24,false)
	end
	end