function onEvent(name,v1)
	if name == 'Trigger' and v1 == 'renderin' then -- hi gp
		doTweenAlpha('logoshit3','gp',1,2,'quadOut')
		doTweenX('logoshit5','gp',500,1.75,'circOut')
		doTweenAlpha('logoshit','logo',1,2,'quadOut')
	elseif name == 'Trigger' and v1 == 'renderout' then
		doTweenX('logoshit6','gp',1300,2,'quadIn')
		doTweenAlpha('logoshit4','gp',0,2,'quadOut')
		doTweenAlpha('logoshit2','logo',0,2,'quadOut')
	end
end