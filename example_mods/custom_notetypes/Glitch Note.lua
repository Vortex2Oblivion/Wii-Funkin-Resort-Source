function onCreate() 
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Glitch Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'mechanics/glitch')
            setPropertyFromGroup('unspawnNotes', i, 'missHealth', 5000)
			setPropertyFromGroup('unspawnNotes', i, 'shader', nil)
		end
	end
end