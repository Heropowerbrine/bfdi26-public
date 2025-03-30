function onEvent(name,v1)
	if name == 'Trigger' and v1 == 'renderin' then
		doTweenAlpha('logoshit3','y',1,2,'quadOut')
		doTweenX('logoshit5','y',500,1.75,'circOut')
		doTweenAlpha('logoshit','logo',1,2,'quadOut')
	elseif name == 'Trigger' and v1 == 'renderout' then
		doTweenX('logoshit6','y',1500,2,'quadIn')
		doTweenAlpha('logoshit4','y',0,2,'quadOut')
		doTweenAlpha('logoshit2','logo',0,2,'quadOut')
	end
end