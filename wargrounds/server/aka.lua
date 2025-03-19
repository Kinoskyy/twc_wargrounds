function startAKADB(res)
	akaDB = dbConnect("sqlite", "wargrounds/aka.db")
	if not akaDB then cancelEvent(true, "AKA database not found, stopping wargrounds...") end
	dbExec(akaDB, "CREATE TABLE IF NOT EXISTS aka (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `serial` TEXT,  `names` TEXT)")
end
addEventHandler("onResourceStart", resourceRoot, startAKADB)

function akaCommand(p, _, id)
	if (hasObjectPermissionTo(p, "function.kickPlayer", false)) then
		for k, v in ipairs(getElementsByType("player")) do
			if getElementID(v, "ID") == id then
				local aka = getPlayerAKAS(v)
				if aka == "No AKA." then
					outputChatBox_("Error: No AKA.", p, 70, 219, 2)
				else
					for k, v in ipairs(aka) do outputChatBox_("AKA: " .. v, p, 70, 219, 2) end
				end
			end
		end
	end
end
addCommandHandler("aka", akaCommand)

addEventHandler("onPlayerJoin", root, function() checkAKA(source) end)

function getPlayerAKAS(p)
	local ser = getPlayerSerial(p)
	local q = dbQuery(akaDB, "SELECT * FROM aka WHERE serial = '" .. tostring(ser) .. "'")
	local d = dbPoll(q, -1)

	if #d == 0 then
		local nameWithoutColor = string.gsub(getPlayerName(p), "#%x%x%x%x%x%x", "")
		local t = {nameWithoutColor}
		dbExec(akaDB, "INSERT INTO aka ('serial', 'names') VALUES (?,?)", ser, toJSON(t))
		return "No AKA."
	else
		names = fromJSON(d[1].names)
		return names
	end
end

function checkAKA(player)
	local ser = getPlayerSerial(player)

	local q = dbQuery(akaDB, "SELECT * FROM aka WHERE serial = '" .. tostring(ser) .. "'")
	local d = dbPoll(q, -1)
	if #d == 0 then
		local nameWithoutTag = string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")
		local t = {nameWithoutTag}
		dbExec(akaDB, "INSERT INTO aka ('serial', 'names') VALUES (?,?)", ser, toJSON(t))
	else
		local names = fromJSON(d[1].names)
		local foundMatch = false

		for k, v in ipairs(names) do if string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "") == v then foundMatch = true end end

		if not foundMatch then
			names[#names + 1] = string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")
			dbExec(akaDB, "UPDATE `aka` SET names=? WHERE serial=?", toJSON(names), ser)
		end
	end
end

addEventHandler("onPlayerChangeNick", root, function() setTimer(checkAKA, 600, 1, source) end)
