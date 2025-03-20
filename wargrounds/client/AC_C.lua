addEvent("requestScreenMode", true)
addEventHandler("requestScreenMode", localPlayer, function(requestingPlayer)
    local screenMode = dxGetStatus().SettingWindowed and "Windowed" or "Fullscreen"
    local fullscreenMode = dxGetStatus().SettingFullScreenStyle == 0 and 'Fullscreen' or 'Windowed'
    triggerServerEvent("sendScreenMode", resourceRoot, fullscreenMode)
end)
function getKeys( control )
    local keys = { }; 
    local boundKeys = getBoundKeys( control ) 
    for k, v in pairs( boundKeys ) do 
        keys[k] = v 
    end
    return keys
end 
function getPlayerSpeed( player )
    local speedX, speedY, speedZ = getElementVelocity( player )
    local speed = math.sqrt( speedX^2 + speedY^2 + speedZ^2 ) * 180; -- km/h
    return speed
end 
addEventHandler( 'onClientKey', root, function ( key, state )
    local keys = {jump = getKeys( 'jump'),fire = getKeys( 'fire'), aim = getKeys( 'aim_weapon'), sprint = getKeys( 'sprint')  }
    local states = { jump = getControlState('jump'), aim = getControlState('aim_weapon'), fire = getControlState('fire'), sprint = getControlState('sprint') }
    if( keys.sprint[key] == 'down' and (not states.aim) ) then 
        local speed = getPlayerSpeed( localPlayer )
        if( speed > 55 and isPedOnGround( localPlayer)) then 
            triggerServerEvent( 'suspectSpeed', resourceRoot, speed ); 
            if( speed > 55.78) then 
                setElementFrozen( localPlayer, true )
                setTimer( setElementFrozen, 500, 1, localPlayer, false )
            end
            cancelEvent( )
        end
    end
end)
