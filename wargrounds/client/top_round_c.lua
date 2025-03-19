local Map = { }; 
local Round = { 
    show = false; 
}
local screen = Vector2(guiGetScreenSize( )); 
local scale = screen.x/1920; 
local rectW, rectH = 600*scale, 600*scale; 
local font = dxCreateFont('verdana.ttf', 15*scale)
local font_2 = dxCreateFont('verdana.ttf', math.max(10, 12*scale))
local dxDrawText_ = dxDrawText; 

function dxDrawTextAligned(text, x, y, b, b1, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, border, ... )
    if type(text) ~= "string" or type(x) ~= "number" or type(y) ~= "number" or type(scale) ~= "number" or type(alignX) ~= "string" or type(alignY) ~= "string" or type(clip) ~= "boolean" or type(wordBreak) ~= "boolean" or type(postGUI) ~= "boolean" or type(colorCoded) ~= "boolean" or type(border) ~= "boolean" then
        return
    end
    if not font then
        font = "default"
    end
    if ( type( text ) == 'string' ) then 
        local textWidth = colorCoded and dxGetTextWidth(text:gsub( '#%x%x%x%x%x%x', ''), scale, font) or dxGetTextWidth(text, scale, font) 
        local textHeight = dxGetFontHeight(scale, font )
        if alignX == "center" then
            x = x - textWidth / 2
        elseif alignX == "right" then
            x = x - textWidth
        end
        if alignY == "center" then
            y = y - textHeight / 2
        elseif alignY == "bottom" then
            y = y - textHeight
        end
        if ( border ) then 
            dxDrawText_(text:gsub('#%x%x%x%x%x%x', ''), x + 1.5, y + 1.5, _, _, tocolor( 0, 0, 0 ), scale, font, 'left', 'top', clip, wordBreak, false, colorCoded, false, unpack( {...} ))
        end
        dxDrawText_(text, x, y, _, _, color, scale, font, 'left', 'top', clip, wordBreak, postGUI, colorCoded, true, unpack( {...} ))
    end
end
addEvent( 'showTopRound', true )
function removeColorCodes(text)
    return text:gsub('#%x%x%x%x%x%x', '')
end
function Map.Render( )
    if( Round.show ) then 
        local team = Round.teams[1]; 
        local score = team:getData( getRoundMapInfo( ).modename == 'domination' and 'Points' or 'Score' ) 
        dxDrawTextAligned( tostring(Round.wintext), screen.x/2, screen.y/2-rectH/2-50*scale, _,_, tocolor(255,255,255), 1, font, 'center', 'bottom', false, false, false, true, true )
        local attackname = getTeamName( team )
        local attackcolor = {getTeamColor( team )}
        dxDrawRectangle( screen.x/2 - rectW - 25*scale, screen.y/2-rectH/2+rectH/7, rectW, rectH-rectH/7, tocolor( 0,0,0,100) )
        dxDrawRectangle( screen.x/2 - rectW - 30*scale, screen.y/2-rectH/2, rectW+10*scale, rectH/7, tocolor(attackcolor[1], attackcolor[2], attackcolor[3],150) )
        dxDrawTextAligned( attackname:upper(), screen.x/2 - rectW - 30*scale, screen.y/2-rectH/2, _,_, tocolor(attackcolor[1], attackcolor[2], attackcolor[3] ), 1, 'bankgothic', 'left', 'bottom', false, false, false, true, true )
        dxDrawTextAligned( tostring(score), screen.x/2 - 25*scale, screen.y/2-rectH/2, _,_, tocolor(attackcolor[1], attackcolor[2], attackcolor[3] ), 1, 'bankgothic', 'right', 'bottom', false, false, false, true, true )
        if( Round.winner ~= 'Draw' ) then 
            dxDrawTextAligned( Round.winner == attackname and 'WINNER' or 'LOSER', screen.x/2 - 25 * scale - rectW / 2, screen.y/2-rectH/2+((rectH/7)/2), _,_, tocolor(255,255,255 ), (math.max(1, math.floor(3*scale))), 'bankgothic', 'center', 'center', false, false, false, true, false )
        end 
        local offsetx, offsety = screen.x/2 - rectW - 25*scale, screen.y/2-rectH/2+rectH/7; 
        dxDrawShadowText( 'Name: ', offsetx+10*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, true )
        dxDrawShadowText( 'Kills: ', offsetx+350*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, true )
        dxDrawShadowText( 'HP: ', offsetx+450*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, true )
        dxDrawShadowText( 'Damage: ', offsetx+560*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, true )
        local killsx, hpx, dmgx = offsetx+350*scale - dxGetTextWidth( 'Kills: ', 1, font_2 )/2, offsetx+450*scale - dxGetTextWidth( 'HP: ', 1, font_2 )/2, offsetx+560*scale- dxGetTextWidth( 'Damage: ', 1, font_2 )/2
        offsety = offsety + 25*scale; 
        for k, v in pairs( Round.p ) do 
            if( v.Team == team ) then 
                dxDrawTextAligned(  v.Name, offsetx+10*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, true )
                dxDrawShadowText( tostring(v.Kills), killsx, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, true )
                dxDrawShadowText( tostring(math.floor(v.Health+v.Armor)), hpx, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, true )
                dxDrawShadowText( tostring(v.Damage), dmgx, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, true )
                offsety = offsety + 25*scale; 
            end 
        end
        local team2 = Round.teams[2]; 
        local score = team2:getData( getRoundMapInfo( ).modename == 'domination' and 'Points' or 'Score' ) 
        local defenseName = getTeamName( team2 )
        local defenseColor = { getTeamColor( team2 ) }
        dxDrawRectangle( screen.x/2 + 30*scale, screen.y/2-rectH/2+rectH/7, rectW, rectH-rectH/7, tocolor( 0,0,0,100) )
        dxDrawRectangle( screen.x/2 + 20*scale, screen.y/2-rectH/2, rectW+20*scale, rectH/7, tocolor(defenseColor[1], defenseColor[2], defenseColor[3],150) )
        dxDrawTextAligned( defenseName:upper(), screen.x/2 + 20*scale+rectW, screen.y/2-rectH/2, _,_, tocolor(defenseColor[1], defenseColor[2], defenseColor[3] ), 1, 'bankgothic', 'right', 'bottom', false, false, false, true, true )
        dxDrawTextAligned( tostring(score), screen.x/2 + 25*scale, screen.y/2-rectH/2, _,_, tocolor(defenseColor[1], defenseColor[2], defenseColor[3] ), 1, 'bankgothic', 'left', 'bottom', false, false, false, true, true )
        if( Round.winner ~= 'Draw' ) then 
            dxDrawTextAligned(Round.winner == defenseName and 'WINNER' or 'LOSER', screen.x/2 + 30*scale + rectW / 2, screen.y/2-rectH/2+((rectH/7)/2), _,_, tocolor(255,255,255), (math.max(1, math.floor(3*scale))), 'bankgothic', 'center', 'center', false, false, false, true, false )
        end 
        local offsetx2, offsety2 = screen.x/2 + 30*scale, screen.y/2-rectH/2+rectH/7; 
        dxDrawShadowText( 'Name: ', offsetx2+10*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, true )
        dxDrawShadowText( 'Kills: ', offsetx2+350*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, true )
        dxDrawShadowText( 'HP: ', offsetx2+450*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, true )
        dxDrawShadowText( 'Damage: ', offsetx2+560*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, true )
        local killsx2, hpx2, dmgx2 = offsetx2+350*scale - dxGetTextWidth( 'Kills: ', 1, font_2 )/2, offsetx2+450*scale - dxGetTextWidth( 'HP: ', 1, font_2 )/2, offsetx2+560*scale- dxGetTextWidth( 'Damage: ', 1, font_2 )/2
        offsety2 = offsety2 + 25*scale; 
        for k, v in pairs( Round.p ) do 
            if( v.Team == team2 ) then 
                dxDrawShadowText( v.Name, offsetx2+10*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, true )
                dxDrawShadowText( tostring(v.Kills), killsx2, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, true )
                dxDrawShadowText( tostring(math.floor(v.Health+v.Armor) ), hpx2, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, true )
                dxDrawShadowText( tostring(v.Damage), dmgx2, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, true )
                offsety2 = offsety2 + 25*scale; 
            end 
        end 
        local mostDamage, damageColor = getMostDamage( Round.p ); 
        local mostKills, killsColor = getMostKills( Round.p ); 
        local mostHP, hpColor = getMostHP( Round.p ); 
        local offsetx, offsety = (25*scale)+screen.x/2-((rectW+25*scale)*2)/2, screen.y/2+rectH/2+25*scale
        dxDrawRectangle( offsetx, offsety, ((rectW)*2), rectH/6, tocolor(0,0,0,50))
		dxDrawShadowText( 'Most Damage: '..damageColor..mostDamage:gsub('#%x%x%x%x%x%x', ''), offsetx+(((rectW+25*scale)*2)/2), offsety+(rectH/6)/2, _,_, tocolor(255, 255, 255 ), 1, font_2, 'center', 'center', false, false, false, true, false )
		dxDrawShadowText( 'Most Kills: '..killsColor..mostKills:gsub('#%x%x%x%x%x%x', ''), offsetx+50*scale, offsety+(rectH/6)/2, _,_, tocolor(255, 255, 255 ), 1, font_2, 'left', 'center', false, false, false, true, false )
		dxDrawShadowText( 'Most HP: '..hpColor..mostHP:gsub('#%x%x%x%x%x%x', ''), offsetx+(((rectW)*2))-50*scale, offsety+(rectH/6)/2, _,_, tocolor(255, 255, 255 ), 1, font_2, 'right', 'center', false, false, false, true, false )
    end
end 
function getMostDamage( round )
    local player, damage, team = nil, -999999999; 
    for k, v in pairs ( round ) do 
        if( isValidTeam(v.Team) and v.Damage > damage ) then 
            damage = v.Damage; 
            player = v.Name; 
            team = v.Team; 
        end
    end 
    return player, getHexTeamColor(team)
end 
function getMostKills( round )
    local player, kills, team = nil, -999999999; 
    for k, v in pairs ( round ) do 
        if( isValidTeam(v.Team) and  v.Kills > kills ) then 
            kills = v.Kills; 
            player = v.Name; 
            team = v.Team; 
        end
    end 
    return player, getHexTeamColor(team)
end 
function getMostHP( round )
    local player, hp, team = nil, -999999999; 
    for k, v in pairs ( round ) do 
        if( isValidTeam( v.Team ) and (v.Health+v.Armor) > hp ) then 
            hp = v.Health+v.Armor; 
            player = v.Name; 
            team = v.Team; 
        end
    end 
    return player, getHexTeamColor(team)
end 
function isValidTeam( team )
    local data = tonumber(getElementData( team, 'Side' )); 
    if( (data == 1) or ( data == 2 ) ) then 
        return true; 
    else 
        return false; 
    end   
end
function getHexTeamColor( team )
    if( not isElement(team) ) then 
        return RGBToHex( 255, 255, 255 )
    end
    local team = {getTeamColor(team)}; 
    return RGBToHex( team[1], team[2], team[3] ); 
end 
function RGBToHex(red, green, blue, alpha)

	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end
function dxDrawShadowText( text, x, y, t, r, color, scale, font, alignx, aligny, ... )
dxDrawText( text:gsub('#%x%x%x%x%x%x', ''), x+1, y+1, _,_, tocolor(0,0,0), scale, font, alignx, aligny, unpack({...})); 
return dxDrawText( text, x, y, _,_, color, scale, font, alignx, aligny, unpack({...})); 
end 
addEventHandler( 'onClientRender', root, Map.Render )
addEventHandler( 
    'showTopRound', root,
    function( show, p, teams, wintext, winner, previous )
        Round.show = show;
        Round.winner = winner; 
        Round.wintext = wintext; 
        if( not previous ) then 
            if( teams ) then 
                Round.teams = {};  
                for k, v in pairs( teams ) do 
                    Round.teams[tonumber(getElementData(v, 'Side'))] = v; 
                end
                Round.p = p;   
            end 
        end 
    end 
)

local screen = {guiGetScreenSize()}
local font = 'bankgothic' 
local joinlogs = {}
local quitlogs = {}

function getScreenPos(x, y, w, h)
    local sw, sh = guiGetScreenSize()
    return (x/100) * sw, (y/100) * sh, (w/100) * sw, (h/100) * sh
end

function loadMod(states)
    if (states == true) then
        if not isEventHandlerAdded('onClientRender', root, joinQuit) then
            addEventHandler("onClientRender", getRootElement(), joinQuit)
        end
    else
        removeEventHandler("onClientRender", getRootElement(), joinQuit)
    end
end
local screen = {guiGetScreenSize()}
local font = 'bankgothic' 
local joinlogs = {}
local quitlogs = {}

function getScreenPos(x, y, w, h)
    local sw, sh = guiGetScreenSize()
    return (x/100) * sw, (y/100) * sh, (w/100) * sw, (h/100) * sh
end

local posTextJoin = {
    {getScreenPos(1, 21.9, 75.0, 24.5)},
    {getScreenPos(1, 25.4, 75.0, 28.0)},
    {getScreenPos(1, 27.9, 75.0, 32.1)},
    {getScreenPos(1, 31.4, 75.0, 36.2)},
    {getScreenPos(1, 34.9, 75.0, 38.8)},
    {getScreenPos(1, 28.4, 75.0, 42.8)},
    {getScreenPos(1, 42.9, 75.0, 48.0)},
    {getScreenPos(1, 45.4, 75.0, 50.6)},
}

local posTextQuit = {
    {getScreenPos(1, 24.9, 75.0, 27.5)},
    {getScreenPos(1, 28.4, 75.0, 31.0)},
    {getScreenPos(1, 30.9, 75.0, 35.1)},
    {getScreenPos(1, 34.4, 75.0, 39.2)},
    {getScreenPos(1, 37.9, 75.0, 51.8)},
    {getScreenPos(1, 31.4, 75.0, 45.8)},
    {getScreenPos(1, 45.9, 75.0, 51.0)},
    {getScreenPos(1, 48.4, 75.0, 53.6)},
}

function loadMod(states)
    if (states == true) then
        if not isEventHandlerAdded('onClientRender', root, joinQuit) then
            addEventHandler("onClientRender", getRootElement(), joinQuit)
        end
    else
        removeEventHandler("onClientRender", getRootElement(), joinQuit)
    end
end

function joinQuit()
    for i, v in ipairs(joinlogs) do
        if i <= 8 then
            local alphaJoin = interpolateBetween(255, 0, 0, 0, 0, 0, ((getTickCount() - v[2]) / 6000), 'Linear')
            local nameWidth = dxGetTextWidth(v[1], 0.7, font)
            dxDrawText(v[1], posTextJoin[i][1], posTextJoin[i][2], posTextJoin[i][3], posTextJoin[i][4], tocolor(255, 0, 0, alphaJoin), 0.7, font, "left", "center", false, true, false, false, false)
            dxDrawText(" : ESTA ONLINE.", posTextJoin[i][1] + nameWidth, posTextJoin[i][2], posTextJoin[i][3], posTextJoin[i][4], tocolor(0, 255, 0, alphaJoin), 0.6, font, "left", "center", false, true, false, false, false)

            if alphaJoin == 0 then 
                table.remove(joinlogs, i)
            end
        end
    end
    
    for i, v in ipairs(quitlogs) do
        if i <= 8 then
            local alphaQuit = interpolateBetween(255, 0, 0, 0, 0, 0, ((getTickCount() - v[2]) / 6000), 'Linear')
            local playerName, reason = v[1]:match("^(.-) %((.-)%)$")
            if not playerName then
                playerName = v[1]
                reason = v[4] or "desconocida"
            end
            local nameWidth = dxGetTextWidth(playerName, 0.7, font)
            local statusWidth = dxGetTextWidth(": ESTA OFFLINE.", 0.6, font)
            dxDrawText(playerName, posTextQuit[i][1], posTextQuit[i][2], posTextQuit[i][3], posTextQuit[i][4], tocolor(0, 0, 255, alphaQuit), 0.7, font, "left", "center", false, true, false, false, false)
            dxDrawText(" : ESTA OFFLINE. [" .. reason .. "]", posTextQuit[i][1] + nameWidth, posTextQuit[i][2], posTextQuit[i][3], posTextQuit[i][4], tocolor(255, 0, 0, alphaQuit), 0.6, font, "left", "center", false, true, false, false, false)
            
            if alphaQuit == 0 then 
                table.remove(quitlogs, i)
            end
        end
    end
end
addEventHandler('onClientRender', root, joinQuit)
addEvent('addJoinMessage', true)
addEventHandler('addJoinMessage', root,
    function(msg, img, reason)
        if img == 'Join' then
            table.insert(joinlogs, {msg, getTickCount(), img, reason})
        elseif img == 'Quit' then
            table.insert(quitlogs, {msg, getTickCount(), img, reason})
        end
    end
)

addEventHandler('onClientPlayerQuit', root,
    function(reason)
        local playerName = string.gsub(getPlayerName(source), "#%x%x%x%x%x%x", "")
        local message = string.format("%s", playerName, reason)
        triggerEvent('addJoinMessage', root, message, 'Quit', reason)
    end
)
addEventHandler('onClientPlayerJoin', root,
    function()
        local playerName = string.gsub(getPlayerName(source), "#%x%x%x%x%x%x", "")
        local message = string.format("%s", playerName)
        triggerEvent('addJoinMessage', root, message, 'Join')
    end
) 