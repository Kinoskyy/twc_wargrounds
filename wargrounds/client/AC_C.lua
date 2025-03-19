function getKeys(control)
    local keys = {}
    local boundKeys = getBoundKeys(control)
    for k, v in pairs(boundKeys) do
        keys[k] = v
    end
    return keys
end

function getPlayerSpeed(player)
    local speedX, speedY, speedZ = getElementVelocity(player)
    local speed = math.sqrt(speedX^2 + speedY^2 + speedZ^2) * 180
    return speed
end

addEventHandler('onClientKey', root, function(key, state)
    local keys = {jump = getKeys('jump'), fire = getKeys('fire'), aim = getKeys('aim_weapon'), sprint = getKeys('sprint')}
    local states = {jump = getControlState('jump'), aim = getControlState('aim_weapon'), fire = getControlState('fire'), sprint = getControlState('sprint')}
    if keys.jump[key] == 'down' then
        if states.fire then
            cancelEvent()
        end
    end
    if keys.sprint[key] == 'down' and (not states.aim) then
        if states.aim and states.jump then
            cancelEvent()
        end
        local speed = getPlayerSpeed(localPlayer)
        if speed > 55.172 and isPedOnGround(localPlayer) then
            triggerServerEvent('suspectSpeed', resourceRoot, speed)
            if speed > 55.172 then
                setElementFrozen(localPlayer, true)
                setTimer(setElementFrozen, 500, 1, localPlayer, false)
            end
            cancelEvent()
        end
    end
end)