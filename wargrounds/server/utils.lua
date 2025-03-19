function firstUpper(str) return string.gsub(str, "^%l", string.upper) end

function getTeamHP(teamID)
	hp = 0
	local players = getPlayersInTeam(getTeamFromID(teamID))
	for k, v in ipairs(players) do if not isPedDead(v) and getPlayerGameStatus(v) == "Play" then hp = hp + getPlayerTotalHP(v) end end
	return hp
end

function getPlayerTotalHP(player) if isElement(player) then return math.ceil(getElementHealth(player) + getPedArmor(player)) end end

function getTacticsTimer()
	local timers = getTimers()
	for k, v in ipairs(timers) do
		ms = getTimerDetails(v)
		if ms > 60000 then return ms end
	end
end

function getTeamFromID(id)
	for k, v in ipairs(getElementsByType("team")) do if tostring(getElementData(v, "Side")) == id then return v end end
	return false
end

function RGBToHex(red, green, blue, alpha)
	-- Make sure RGB values passed to this function are correct
	if ((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then return nil end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end
