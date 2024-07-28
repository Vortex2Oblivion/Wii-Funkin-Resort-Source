function onCreatePost()
	makeLuaSprite('bar', 'display/credit-sword', -500, 360, 2.0);
	makeLuaText("song", songName, 0, -500, 470);
	makeLuaText("author", 'By St4rcannon', 0, -500, 600);
	addLuaSprite('bar', true);
	scaleObject('bar', 1.4, 1.4);
	addLuaText('song');
	addLuaText('author');
	setTextSize('song', 65);
	setTextSize('author', 35);
	setObjectCamera('bar', 'other');
	setObjectCamera('song', 'other');
	setObjectCamera('author', 'other');
	setTextFont('song', 'kinger.ttf');
	setTextFont('author', 'kinger.ttf');	
end

function onSongStart()
	doTweenX('bye', 'bar', 10, 0.8, 'BackOut');
	doTweenX('bye2', 'song', 35, 0.8, 'BackOut');
	doTweenX('bye3', 'author', 35, 0.8, 'BackOut');
end

function onStepHit()
    if curStep == 24 then
	  doTweenX('bye4', 'bar', -500, 1.0, 'BackIn');
	  doTweenX('bye5', 'song', -500, 1.0, 'BackIn');
	  doTweenX('bye6', 'author', -500, 1.0, 'BackIn');
	end
end