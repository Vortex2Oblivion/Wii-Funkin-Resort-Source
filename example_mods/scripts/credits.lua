local credits = {
    --    track        sport    composer
        ["sword up"] = {"sword", "Invalid"},
        ["kendo"] = {"sword", "Genzu, Invalid"},
        ["true-edge"] = {"sword", "NobodyKnows"},
        ["everl4st"] = {"sword", "Invalid"},
        ["daito"] = {"sword", "Genzu"},
        ["fault-line"] = {"sword", "Revlio"},
        ["mobility"] = {"box", "Revlio"},
        ["glove-check"] = {"box", "NobodyKnows"},
        ["final-fist"] = {"box", "NobodyKnows"},
        ["decked"] = {"box", "Invalid"},
        ["ringside"] = {"box", "Revilo & Invalid"},
        ["doodle"] = {"box", "Invalid & NunsStop"},
        ["gameboy"] = {"box", "Revilo & Invalid"},
        ["ones"] = {"ball", "Invalid"},
        ["tommy"] = {"ball", "Genzu"},
        ["overtime"] = {"ball", "CrazyCake and More"}, --https://www.youtube.com/watch?v=YOw4YgyNnog
        ["skilled"] = {"ball", "NobodyKnows"},
        ["beefed-up"] = {"ball", "Invalid"},
        ["twos"] = {"ball", "NobodyKnows"},
        ["gr00ve"] = {"", "Starcanon"},
        ["resort"] = {"", "Invalid, Delta & CowJD"},
        ["genz"] = {"", "Genzu, Invalid"},
        ["d3fect"] = {"glitch", "Invalid"},
        ["gba"] = {"glitch", "Invalid"},
        ["proto"] = {"glitch", "Invalid"},
        ["parasitic"] = {"glitch", "Invalid"},
        ["advantage"] = {"sword", "Invalid"},
        ["light-it-up-resort"] = {"sword", "Delta"},
        ["sporting-resort"] = {"box", "Invalid"},
        ["boxing-match-resort"] = {"box", "Revilo & Delta"},
        ["blacklight"] = {"box", "Invalid"},
        ["ruckus-resort"] = {"sword", "Invalid"},
        ["target-practice-resort"] = {"sword", "Genzu"},
        ["footwork"] = {"box", "CooknCake"},
        ["empty-fade"] = {"sword", "DeltaMoai"},
        ["prizefight"] = {"box", "NobodyKnows"},
    }
    local objects = {'songbar', 'thenameofthesong', 'author'}
    function onCreatePost()
        makeLuaSprite('songbar', 'display/credit-'..credits[string.lower(songName)][1], -500, 360, 2.0);
        makeLuaText("thenameofthesong", string.lower(songName), 0, -500, 470);
        setProperty("thenameofthesong.offset.x", -30)
        makeLuaText("author", 'By: '..credits[string.lower(songName)][2], 0, -500, 600);
        setProperty("author.offset.x", -30)
        addLuaSprite('songbar', true);
        scaleObject('songbar', 1.4, 1.4);
        addLuaText('thenameofthesong');
        addLuaText('author');
        setTextSize('thenameofthesong', 65);
        setTextSize('author', 35);
        setObjectCamera('songbar', 'other');
        setObjectCamera('thenameofthesong', 'other');
        setObjectCamera('author', 'other');
        setTextFont('thenameofthesong', 'kinger.ttf');
        setTextFont('author', 'kinger.ttf');
		while getProperty("thenameofthesong.fieldWidth") > 330 do
			setProperty("thenameofthesong.size", getProperty("thenameofthesong.size") - 1);
		end;	
    end
    
    function onSongStart()
        for i = 1,#objects do
            doTweenX('bye'..i, objects[i], 10, 0.8, 'BackOut');
        end
    end
    
function onStepHit()
    if curStep == 24 then
        for i = 1,#objects do
            doTweenX('bye'..(i)+3, objects[i], -550, 1, 'BackOut');
        end
    end
end