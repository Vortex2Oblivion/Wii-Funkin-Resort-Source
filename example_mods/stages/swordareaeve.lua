--stage
function onCreate()
	makeLuaSprite('sky','newsword/eve/sky', -850, -500)
	addLuaSprite('sky')
	setScrollFactor('sky', 0.0, 0.0)

	makeLuaSprite('islandbridge','newsword/eve/islandbridge', 0, 0)
	addLuaSprite('islandbridge')
	setScrollFactor('islandbridge', 0.3, 0.3)

	makeLuaSprite('buildings','newsword/eve/buildings', 300, 0)
	addLuaSprite('buildings')
	setScrollFactor('buildings', 0.5, 0.5)

	makeLuaSprite('bigscreen','newsword/eve/bigscreen', 275, 250)
	addLuaSprite('bigscreen')
	setScrollFactor('bigscreen', 0.84, 0.84)

	makeAnimatedLuaSprite('invalid_speakers','newsword/eve/invalid_speakers', 350, 550)
	addAnimationByPrefix('invalid_speakers','invalid_speakers','invalid_speakers', 24, false)
	setScrollFactor('invalid_speakers', 0.845, 0.845)
	addLuaSprite('invalid_speakers')

	makeAnimatedLuaSprite('boppers','newsword/eve/boppers', -510, 170 * 1.5)
	addAnimationByPrefix('boppers','boppers','boppers', 24, false)
	setScrollFactor('boppers', 0.85, 0.85)
	scaleObject("boppers", 0.85, 0.85)
	addLuaSprite('boppers')

	makeLuaSprite('platform','newsword/eve/platform', -250, 1000)
	addLuaSprite("platform")

	makeLuaSprite('sunoverlay','newsword/eve/sunoverlay', -500, -500)
	setScrollFactor('sunoverlay', 0, 0)
	screenCenter("sunoverlay")
	setBlendMode("sunoverlay", 'screen')
	setProperty("sunoverlay.alpha", 0.1)
	addLuaSprite("sunoverlay", true)
	setProperty("gfGroup.alpha", 0)

	--phighting stuff 
	addLuaScript("swordfight")
end

--dance
function onBeatHit()
	playAnim('invalid_speakers','invalid_speakers', true)
	playAnim('boppers','boppers', true)
end