function TeamDeathMatch_onClientMapStopping(mapinfo)
	if (mapinfo.modename ~= "arena") then return end
	showRoundHudComponent("timeleft",false)
	showRoundHudComponent("teamlist",false)
	removeEventHandler("onClientPlayerRoundSpawn",localPlayer,TeamDeathMatch_onClientPlayerRoundSpawn)
	removeCommandHandler("gun",toggleWeaponManager)
end
function TeamDeathMatch_onClientMapStarting(mapinfo)
	if (mapinfo.modename ~= "arena") then return end
	setPlayerHudComponentVisible("ammo",true)
	setPlayerHudComponentVisible("area_name",false)
	setPlayerHudComponentVisible("armour",true)
	setPlayerHudComponentVisible("breath",true)
	setPlayerHudComponentVisible("clock",false)
	setPlayerHudComponentVisible("health",true)
	setPlayerHudComponentVisible("money",false)
	setPlayerHudComponentVisible("radar",true)
	setPlayerHudComponentVisible("vehicle_name",false)
	setPlayerHudComponentVisible("weapon",true)
	showRoundHudComponent("timeleft",true)
	showRoundHudComponent("teamlist",true)
	addEventHandler("onClientPlayerRoundSpawn",localPlayer,TeamDeathMatch_onClientPlayerRoundSpawn)
	addCommandHandler("gun",toggleWeaponManager,false)
end
function TeamDeathMatch_onClientPlayerRoundSpawn()
	if (getRoundState() == "stopped") then setCameraPrepair() end
end
addEventHandler("onClientMapStarting",root,TeamDeathMatch_onClientMapStarting)
addEventHandler("onClientMapStopping",root,TeamDeathMatch_onClientMapStopping)
