local Players = { }; 
local Messages = {
    [1] = {"1st #F41127%s #FFFFFF(Damage: %s| Kills: %s)"},
    [2] = {"1st #F41127%s #FFFFFF(Damage: %s| Kills: %s)", "2nd #FF7F00%s #FFFFFF(Damage: %s| Kills: %s)"},
    [3] = {"1st #F41127%s #FFFFFF(Damage: %s| Kills: %s)", "2nd #FF7F00%s #FFFFFF(Damage: %s| Kills: %s)", "3rd #FFd800%s #FFFFFF(Damage: %s| Kills: %s)"},
}
local Map = { }; 
function Map.Finish( winner, reason, scores )
    Players = Players; 
    local Top = 3; 
    local G_Players = getElementsByType( 'player' ); 
    for _, self in pairs( G_Players ) do 
        if( getElementData( self, 'loaded' ) == true ) then 
            local Kills, Damage = (getElementData( self, 'Kills' ) or 0)-getElementData( self, 'oldKills' ), (getElementData( self, 'Damage' ) or 0)-getElementData( self, 'oldDamage' );
            local Health, Armor = getElementHealth( self ), getPedArmor( self ); 
            local Name          = getPlayerName( self ); 
            local Team          = getPlayerTeam( self ); 
            table.insert( Players, { Name=Name, Kills=Kills, Damage=Damage, Health=Health, Armor=Armor, Team= Team} )
        end
    end
    table.sort(Players, function(a, b) return a.Damage > b.Damage end)
    local Mode    = getRoundMapInfo( ); 
    local mName   = firstUpper( Mode.modename ); 
    local r, g, b = 255, 255, 255 
    local wTeam   = winner[5] and getTeamFromName( winner[5] ) or false;  
    if( wTeam and isElement( wTeam ) ) then 
        r, g, b = getTeamColor( wTeam ); 
    end
    local TeamColor   = RGBToHex( r, g, b );
    local TeamHealth  = 0; 
    if( wTeam and isElement( wTeam ) ) then 
        local TeamPlayers = getPlayersInTeam( wTeam ); 
        for _, self in pairs( TeamPlayers ) do 
            -- iprint(getPlayerGameStatus( self ) )
            if( ( not isPedDead( self ) ) and getPlayerGameStatus( self ) == 'Play' ) then 
                TeamHealth = math.floor(TeamHealth + getElementHealth( self ) + getPedArmor( self )); 
            end
        end 
    end
    local formattedText = isElement(wTeam) and ( '#FFFFFF>> %s%s #FFFFFFwin %s %s with %s %s #FFFFFFhealth remaining' ):format( TeamColor, winner[5], mName, Mode.name:match(':(.*)'), TeamColor, TeamHealth ) or ('>> Round %s map "%s" has finished by a draw'):format(mName, Mode.name:match(':(.*)')); 
    outputChatBox_( formattedText, root, 70, 219, 2, true)
    if #Players > 0 then
        outputChatBox_("Top Players", root, 255, 255, 255, true)
        if #Players >= Top then
            for i = 1, #Messages[Top] do
                outputChatBox(Messages[Top][i]:format(string.gsub(Players[i].Name, "#%x%x%x%x%x%x", ""), Players[i].Damage, Players[i].Kills), root, 255, 255, 255, true)
            end
        else
            for i = 1, #Players do
                outputChatBox(Messages[#Players][i]:format(string.gsub(Players[i].Name, "#%x%x%x%x%x%x", ""), Players[i].Damage, Players[i].Kills), root, 255, 255, 255, true)
            end
        end
    end

    triggerClientEvent( root, 'showTopRound', root, true, Players, Map.GetTeams( ), formattedText:gsub('>>',''):gsub('"', ''), winner[5] and winner[5] or 'Draw' ); 
end 

function Map.Load( ... )
    Players = { }; 
    for id, self in pairs( getElementsByType( 'player' ) ) do
        local datas = {'Kills', 'Deaths', 'Damage'};  
        for _, data in pairs( datas ) do 
            setElementData( self, 'old'..data, getElementData( self, data ) or 0 )
        end
    end

    triggerClientEvent( root, 'showTopRound', root, false )
end 

function Map.GetTeams( )
    local tempteams = { };     
    for k, v in pairs( getElementsByType( 'team' ) ) do 
        local data = tonumber(getElementData( v, 'Side' )); 
        if( (data == 1) or ( data == 2 ) ) then 
            table.insert( tempteams, v ); 
        end   
    end
    return tempteams
end 
function Map.GetPlayerTeam( pElement )
    local team = getPlayerTeam( pElement );
    if( not team ) then return end; 
    local t; 
    for id, self in pairs( Map.GetTeams( ) ) do 
        if( self == team and ( tonumber(getElementData( self, 'Side' )) ) ) then 
            t = tonumber(getElementData( self, 'Side' ))
            break 
        end
    end
    return t; 
end 

addEvent( 'fetchTopRound', true )
addEventHandler( 'fetchTopRound', root, function( )
    triggerClientEvent( client, 'showTopRound', client, true, Players, true )
end )
addEventHandler('onRoundFinish', getRootElement(), Map.Finish)
addEventHandler('onMapStarting', getRootElement(), Map.Load)


