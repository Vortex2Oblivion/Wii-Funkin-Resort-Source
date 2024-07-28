function onCreatePost()
	makeLuaSprite('bar', 'display/Wii-Glove', 80, 415, 2.0);
	makeLuaText("song", songName, 0, 110, 430);
	makeLuaText("author", 'By Gary Gilberson', 0, 110, 460);
	addLuaSprite('bar', true);
	scaleObject('bar', 1.3, 1.3);
	addLuaText('song');
	addLuaText('author');
	setTextSize('song', 20);
	setTextSize('author', 20);
	setObjectCamera('bar', 'other');
	setObjectCamera('song', 'other');
	setObjectCamera('author', 'other');
	setTextFont('song', 'contb.ttf');
	setTextFont('author', 'contb.ttf');	
end

function onSongStart()
	doTweenX('bye', 'bar', 1480, 1.5, 'smootherStepIn');
	doTweenX('bye2', 'song', 1610, 1.5, 'smootherStepIn');
	doTweenX('bye3', 'author', 1610, 1.5, 'smootherStepIn');
end