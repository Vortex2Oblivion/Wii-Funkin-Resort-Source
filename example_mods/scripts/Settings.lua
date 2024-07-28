-- Hudtypes list:
-- Custom(deafault)
-- KadeEngine
-- ForeverEngine
-- Vanilla
local hudtype = 'Custom';

function onCreate()
    if hudtype == 'Custom' then
        addLuaScript('huds/Custom Hud');
    elseif hudtype == 'KadeEngine' then
        addLuaScript('huds/Kade Hud');
    elseif hudtype == 'ForeverEngine' then
        addLuaScript('huds/Forever Engine Hud');
    elseif hudtype == 'Vanilla' then
        addLuaScript('huds/Vanilla Hud');
    end
end