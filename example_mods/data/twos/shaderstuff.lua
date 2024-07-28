function onCreatePost()
    initShader("blur", "crb")
    setCameraShader("game", "blur")
    setShaderProperty("blur", "blur", 0)
    setShaderProperty("blur", "falloff", 3)
end

function onSongStart()
    tweenShaderProperty("blur", "blur", 0.3, 2.18, "expoIn")
end