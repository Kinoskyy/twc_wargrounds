addEventHandler("onRoundFinish", root, function()
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) and getElementType(player) == "player" then
            setPedAnimation(player, "DANCING", "dnce_m_a", -1, true, false, false, false)
        end
    end
    setTimer(function()
        setGameSpeed(1)
    end, 100, 65)
end)