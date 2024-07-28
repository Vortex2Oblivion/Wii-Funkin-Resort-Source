function onCreatePost()
	makeLuaSprite('bar', 'display/Wii-Ball', 680, 415);
	makeLuaText("song", songName, 0, 810, 420);
	makeLuaText("author", 'By Gary Gilberson', 0, 810, 460);
	addLuaSprite('bar', true);
	addLuaText('song');
	addLuaText('author');
	setTextSize('song', 40);
	setTextSize('author', 40);
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