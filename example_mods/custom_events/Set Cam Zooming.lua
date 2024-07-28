---
--- @param eventName string
--- @param value1 string
--- @param value2 string
--- @param strumTime float
---
function onEvent(eventName, value1, value2, strumTime)
    if eventName == "Set Cam Zooming" then
        if tostring(value1) == "0" then
            setProperty("camZooming", false)
        else
            setProperty("camZooming", true)
        end
    end
end