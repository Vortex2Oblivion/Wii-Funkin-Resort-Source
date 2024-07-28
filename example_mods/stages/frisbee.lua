function onCreate()
  makeLuaSprite('S','Fsky', -1000, -900)
  addLuaSprite('S',false)
  setScrollFactor('S', 0, 0);
	
  makeLuaSprite('G','ground', -1600, -900)
  addLuaSprite('G',false)
  setScrollFactor('G', 0.8, 0.8);
 
  makeLuaSprite('green','sexcatch', -1600, -900)
  addLuaSprite('green',false)
  setScrollFactor('green', 0.9, 0.9);

  makeLuaSprite('ground','ggg', -1600, -900)
  addLuaSprite('ground',false)

  makeLuaSprite('tint', nil, 0, 0)
  makeGraphic('tint', screenWidth, screenHeight, 'ebc119')
  setBlendMode('tint', 'add')
  setObjectCamera('tint', 'other')
  setProperty('tint.alpha', 0.2)
  addLuaSprite('tint', true)
  close()
end
-- Coded by Ushear because im cool and awesome and cool and best fnf charter
-- Ushear you used deprecated functions boy -Vortex
-- Ushear you set the scrollfactor of everything to 1 you buffoon -Vortex