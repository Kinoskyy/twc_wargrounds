local allowDisabledScreenshots = false

addEvent("sendCheater", true)
addEventHandler(
	"sendCheater", root, function(p)
		cheater = p
		setTimer(
			function()
				fn.cHandlers.cheater = "Unknown"
			end, 2000, 1
		)
	end
)



addEvent("wargrounds:handleScreenshot", true)
addEventHandler(
	"wargrounds:handleScreenshot", root, function()
		if not allowDisabledScreenshots then
			kickPlayer(client, "Wargrounds:AC", "Enable 'Allow screen upload' on your settings.")
		end
	end
)
addEvent("reportHealth", true)
addEventHandler(
	"reportHealth", root, function(player, player1)
		outputChatBox_("Anti Cheat: \"" .. string.gsub(player, "#%x%x%x%x%x%x", "") .. "\" just changed the health of \"" .. string.gsub(player1, "#%x%x%x%x%x%x", "") .. "\"", root, 70, 219, 2)
		
	end
)

addEvent("reportJetpack", true)
addEventHandler(
	"reportJetpack", root, function(player, player1)
		outputChatBox_("Anti Cheat: \"" .. string.gsub(player, "#%x%x%x%x%x%x", "") .. "\" has just given a jetpack to \"" .. string.gsub(player1, "#%x%x%x%x%x%x", "") .. "\"", root, 70, 219, 2)
		
	end
)



addEvent("reportArmour", true)
addEventHandler(
	"reportArmour", root, function(player, player1)
		outputChatBox_("Anti Cheat: \"" .. string.gsub(player, "#%x%x%x%x%x%x", "") .. "\" just changed the armour of \"" .. string.gsub(player1, "#%x%x%x%x%x%x", "") .. "\"", root, 70, 219, 2)
		
	end
)

addEvent("reportDimension", true)
addEventHandler(
	"reportDimension", root, function(player, player1, dimension)
		outputChatBox_("Anti Cheat: \"" .. string.gsub(player, "#%x%x%x%x%x%x", "") .. "\" moved \"" .. string.gsub(player1, "#%x%x%x%x%x%x", "") .. "\"".." to dimension "..dimension, root, 70, 219, 2)
		
	end
)

addEvent("reportElement", true)
addEventHandler(
	"reportElement", root, function(player, player1, element)
		outputChatBox_("Anti Cheat: \"" .. string.gsub(player, "#%x%x%x%x%x%x", "") .. "\" just gave a \"" .. string.sub(element, 6) .. "\" to \"" .. string.gsub(player1, "#%x%x%x%x%x%x", "") , root, 70, 219, 2)
	end
)

addEvent("reportSpec", true)
addEventHandler(
	"reportSpec", root, function(spectator, player)
		outputChatBox_("Anti Cheat: \"" .. string.gsub(spectator, "#%x%x%x%x%x%x", "") .. "\" is now spectating \"" .. string.gsub(player, "#%x%x%x%x%x%x", "") .. "\"", root, 70, 219, 2)
	end
)

function handleScreenshot(_, status)
	if allowDisabledScreenshots == false and status == "disabled" then
		kickPlayer(source, "Wargrounds:AC", "Enable 'Allow screen upload' on your settings.")
		return
	end
	outputChatBox_(
		"Anti Cheat: \"" .. string.gsub(cheater, "#%x%x%x%x%x%x", "") .. "\" took a screenshot from \"" .. string.gsub(getPlayerName(source), "#%x%x%x%x%x%x", "") .. "\"", root, 70, 219,
			2
	)
end
addEventHandler("onPlayerScreenShot", root, handleScreenshot)

function toggleScreenshotKick(player, _, _)
	if isGuestAccount(getPlayerAccount(player)) then
		return
	end

	if not isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(player)), aclGetGroup("Admin")) then
		return
	end

	local enabled = allowDisabledScreenshots ~= true and {true, "disabled"} or {false, "enabled"}
	allowDisabledScreenshots = enabled[1]
	outputChatBox_("Admin \"" .. string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "") .. "\" has " .. enabled[2] .. " screenshot disabled kick", root, 70, 219, 2)
end
addCommandHandler("screenshots", toggleScreenshotKick)
addCommandHandler("ss", toggleScreenshotKick)

