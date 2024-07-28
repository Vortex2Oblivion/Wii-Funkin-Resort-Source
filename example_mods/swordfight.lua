--swordfighting stuff
local anims = {"blockLEFT", "blockDOWN", "blockUP", "blockRIGHT"}

function goodNoteHit(id, direction, noteType, isSustainNote)
	playAnim('dad', anims[direction + 1], true)
	setProperty('dad.specialAnim', true)
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
	playAnim('boyfriend', anims[direction + 1], true)
	setProperty('boyfriend.specialAnim', true)
end