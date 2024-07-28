function onUpdate(elapsed)
    if not cameraTracksDirection then
        return
    end
    songPos = getSongPosition()
    local currentBeat = (songPos/5000)*(curBpm/60)
    local currentBeat2 = (songPos/200)*(curBpm/200)
    setProperty('camFollowPos.x',getProperty('camFollowPos.x') + (math.sin(currentBeat2) * 0.2))
    setProperty('camFollowPos.y',getProperty('camFollowPos.y') + (math.cos(currentBeat2) * 0.2))
end