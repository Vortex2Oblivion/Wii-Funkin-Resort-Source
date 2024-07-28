local hudShit = {'timeBar', 'timeBarBG', 'timeTxt', 'scoreTxt', 'judgementCounter'};
local hudElements = {'score', 'misses', 'accuracy', 'rating'};

function onCreatePost()
    for i = 1, #hudShit do setProperty(hudShit[i]..'.visible', false); end

	for i = 1, #hudElements do
		makeLuaText('hudStuff'..i, '', 0, 0, 0);
		setProperty('hudStuff'..i..'.antialiasing', true)
		setTextFont('hudStuff'..i, 'wii.ttf');
		setTextSize('hudStuff'..i, 21);
		if i == 1 then
			setPosition('hudStuff'..i, 10, 40);
			setTextString('hudStuff'..i, 'Score: 0');
		elseif i == 2 then
			setPosition('hudStuff'..i, 10, 60);
			setTextString('hudStuff'..i, 'Misses: 0');
		elseif i == 3 then
			setPosition('hudStuff'..i, 10, 80);
			setTextString('hudStuff'..i, 'Accuracy: 0%');
		elseif i == 4 then
			setPosition('hudStuff'..i, 10, 100);
			setTextString('hudStuff'..i, 'Rating: N/A');
		end
		addLuaText('hudStuff'..i);
	end

    makeLuaText('counter', judgeCountTxt, 0, 10, 360);
    setTextFont('counter', 'wii.ttf');
    setTextSize('counter', 21);
    setTextAlignment('counter', 'left');
    addLuaText('counter');

	makeLuaText('song', songName..' - '..difficultyName:upper(), 0, 10, 690);
	setTextFont('song','wii.ttf');
	setTextSize('song', 21);
	addLuaText('song');

	
	if not downscroll then
	    setProperty('song.y', 680);
	    setProperty('ver.y', 10);
	    setProperty('rating.y', 700);
	    setProperty('acc.y', 680);
	    setProperty('miss.y', 660);
	    setProperty('score.y', 640);
    end
end

function onUpdateScore()
	judgeCountTxt = 'Sicks: '..getProperty('sicks')..'\nGoods: '..getProperty('goods')..'\nBads: '..getProperty('bads')..'\nShits: '..getProperty('shits');
	for i = 1, #hudElements do
		if i == 1 then
			setTextString('hudStuff'..i, 'Score: '..score);
		elseif i == 2 then
			setTextString('hudStuff'..i, 'Misses: '..misses);
		elseif i == 3 then
			setTextString('hudStuff'..i, 'Accuracy: '..floorDecimal(rating * 100, 2)..'%');
		elseif i == 4 then
			setTextString('hudStuff'..i, 'Rating: '..ratingName..(((hits > 0) or (misses > 0)) and ' ('..ratingFC..')' or ''));
		end
	end
	setTextString('counter', judgeCountTxt);
end

function setPosition(obj, x, y)
    setProperty(obj..'.x', x);
    setProperty(obj..'.y', y);
end

function floorDecimal(value, decimals) -- Port of Highscore.floorDecimal() lmao
    if decimals < 1 then
        return math.floor(value);
    end

    local tempMult = 1;
    for i = 1, decimals do
        tempMult = tempMult * 10;
    end
    local newValue = math.floor(value * tempMult);
    return newValue / tempMult;
end