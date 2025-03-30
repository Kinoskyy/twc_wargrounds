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
        dxDrawTextAligned( 'Name: ', offsetx+10*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, false )
        dxDrawTextAligned( 'Kills: ', offsetx+350*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, false )
        dxDrawTextAligned( 'HP: ', offsetx+450*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, false )
        dxDrawTextAligned( 'Damage: ', offsetx+560*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, false )
        local killsx, hpx, dmgx = offsetx+350*scale - dxGetTextWidth( 'Kills: ', 1, font_2 )/2, offsetx+450*scale - dxGetTextWidth( 'HP: ', 1, font_2 )/2, offsetx+560*scale- dxGetTextWidth( 'Damage: ', 1, font_2 )/2
        offsety = offsety + 25*scale; 
        for k, v in pairs( Round.p ) do 
            if( v.Team == team ) then 
                dxDrawTextAligned(removeColorCodes(v.Name), offsetx+10*scale, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, false)
                dxDrawTextAligned( tostring(v.Kills), killsx, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, false )
                dxDrawTextAligned( tostring(math.floor(v.Health+v.Armor)), hpx, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, false )
                dxDrawTextAligned( tostring(v.Damage), dmgx, offsety+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, false )
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
        dxDrawTextAligned( 'Name: ', offsetx2+10*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, false )
        dxDrawTextAligned( 'Kills: ', offsetx2+350*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, false )
        dxDrawTextAligned( 'HP: ', offsetx2+450*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, false )
        dxDrawTextAligned( 'Damage: ', offsetx2+560*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'right', 'top', false, false, false, true, false )
        local killsx2, hpx2, dmgx2 = offsetx2+350*scale - dxGetTextWidth( 'Kills: ', 1, font_2 )/2, offsetx2+450*scale - dxGetTextWidth( 'HP: ', 1, font_2 )/2, offsetx2+560*scale- dxGetTextWidth( 'Damage: ', 1, font_2 )/2
        offsety2 = offsety2 + 25*scale; 
        for k, v in pairs( Round.p ) do 
            if( v.Team == team2 ) then 
                dxDrawTextAligned(removeColorCodes(v.Name), offsetx2+10*scale, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'left', 'top', false, false, false, true, false)
                dxDrawTextAligned( tostring(v.Kills), killsx2, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, false )
                dxDrawTextAligned( tostring(math.floor(v.Health+v.Armor) ), hpx2, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, false )
                dxDrawTextAligned( tostring(v.Damage), dmgx2, offsety2+25*scale, _,_, tocolor(255,255,255), 1, font_2, 'center', 'top', false, false, false, true, false )
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
