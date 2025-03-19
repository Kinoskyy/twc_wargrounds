local players = {}

addEventHandler("onRoundStart", root, function()
	for k, v in ipairs(getElementsByType("player")) do
		if not players[v] then
			players[v] = getElementHealth(v) + getPedArmor(v)
		end
	end
end)

addEventHandler("onPlayerGameStatusChange", root, function()
	if getPlayerGameStatus(source) == "Play" then
		if not players[source] then
			players[source] = getElementHealth(source) + getPedArmor(source)
		end
	elseif getPlayerGameStatus(source) == "Die" or getPlayerGameStatus(source) == "Spectate" then
		if players[source] then
			players[source] = nil
		end
	end
end)

addEventHandler("onMapStopping", root, function()
	for k, v in pairs(players) do
		players[k] = nil
	end
end)

addEventHandler("onPlayerQuit", root, function()
	if players[source] then
		players[source] = nil
	end
end)

addEventHandler("onPlayerDamage", root, function(_, _, _, loss)
	if players[source] then
		players[source] = players[source] - math.floor(loss)
	end
end)

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	local r = getRoundMapInfo()
	if r.modename ~= "lobby" then
		if players[source] then
			if isElement(attacker) then
				if getElementType(attacker) == "player" then
					local oldDmg = getElementData(attacker, "Damage")
					setElementData(attacker, "Damage", oldDmg + players[source])
				end
			end
		end
	end
end)

addEventHandler("onPlayerSpawn", root, function()
	if getPlayerGameStatus(source) == "Play" then
		if players[source] then
			players[source] = getElementHealth(source) + getPedArmor(source)
		end
	end
end)
