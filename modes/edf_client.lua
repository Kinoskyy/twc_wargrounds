local replaceModels = {nitro=2221,repair=2222,vehiclechange=2223,weapon=2221}
local replaces = {}
function onStart()
	for name,id in pairs(replaceModels) do
		replaces[name] = {}
		replaces[name].txd = engineLoadTXD(":tactics/models/"..name..".txd")
		engineImportTXD(replaces[name].txd,id)
		replaces[name].dff = engineLoadDFF(":tactics/models/"..name..".dff",id)
		engineReplaceModel(replaces[name].dff,id)
	end
	for i,racepickup in pairs(getElementsByType("racepickup")) do
		checkElementType(racepickup)
	end
	for i,capture_point in pairs(getElementsByType("Capture_Point")) do
		checkElementType(capture_point)
	end
end
function onStop()
	for name,id in pairs(replaceModels) do
		destroyElement(replaces[name].txd)
		destroyElement(replaces[name].dff)
	end
end
function checkElementType(element)
	element = element or source
	if (getElementType(element) == "racepickup") then
		local object = getRepresentation(element,"object")
		if (object) then
			local pickuptype = exports.edf:edfGetElementProperty(element,"type")
			setElementModel(object[1],replaceModels[pickuptype] or 1346)
			setElementAlpha(object[2],0)
		end
	end
	if (getElementType(element) == "Capture_Point") then
		local marker = getRepresentation(element,"marker")
		local blip = getRepresentation(element,"blip")
		if (marker and blip) then
			local team = exports.edf:edfGetElementProperty(element,"team")
			if (team == 1) then
				setMarkerColor(marker,128,0,0,128)
				setBlipColor(blip,128,0,0,255)
			elseif (team == 2) then
				setMarkerColor(marker,0,0,128,128)
				setBlipColor(blip,0,0,128,255)
			else
				setMarkerColor(marker,192,192,192,128)
				setBlipColor(blip,192,192,192,255)
			end
		end
	end
end
addEventHandler("onClientElementCreate",root,checkElementType)
addEventHandler("onClientElementPropertyChanged",root,function(propertyName)
	if (getElementType(source) == "racepickup") then
		if (propertyName == "type") then
			local object = getRepresentation(source,"object")
			if (object) then
				local pickupType = exports.edf:edfGetElementProperty(source,"type")
				setElementModel(object[1],replaceModels[pickupType] or 1346)
			end
		end
	end
	if (getElementType(source) == "Capture_Point" and propertyName == "team") then
		local marker = getRepresentation(source,"marker")
		local blip = getRepresentation(source,"blip")
		if (marker and blip) then
			local team = exports.edf:edfGetElementProperty(source,"team")
			if (team == 1) then
				setMarkerColor(marker,128,0,0,128)
				setBlipColor(blip,128,0,0,255)
			elseif (team == 2) then
				setMarkerColor(marker,0,0,128,128)
				setBlipColor(blip,0,0,128,255)
			else
				setMarkerColor(marker,192,192,192,128)
				setBlipColor(blip,192,192,192,255)
			end
		end
	end
end)
addEventHandler("onClientRender",root,function()
	local zone = {}
	for i,point in pairs(getElementsByType("Anti_Rush_Point",root,true)) do
		local object = getRepresentation(source,"object")
		local x,y,z = getElementPosition(object)
		table.insert(zone,{x,y,z})
	end
	if (#zone > 0) then
		if (#zone == 2) then
			zone = {
				{math.min(zone[1][1],zone[2][1]),math.min(zone[1][2],zone[2][2])},
				{math.max(zone[1][1],zone[2][1]),math.min(zone[1][2],zone[2][2])},
				{math.max(zone[1][1],zone[2][1]),math.max(zone[1][2],zone[2][2])},
				{math.min(zone[1][1],zone[2][1]),math.max(zone[1][2],zone[2][2])}
			}
		end
		if (#zone > 1) then
			for j,point1 in ipairs(zone) do
				local point2 = (j < #zone and zone[j+1]) or zone[1]
				local x1,y1 = getScreenFromWorldPosition(point1[1],point1[2],point1[3],360)
				local x2,y2 = getScreenFromWorldPosition(point2[1],point2[2],point2[3],360)
				if (x1 and x2) then dxDrawLine(x1,y1,x2,y2,0x80A00000,5) end
			end
		end
	end
	local angle = getTickCount()*0.1%360
	for i,racepickup in pairs(getElementsByType("racepickup",root,true)) do
		setElementRotation(racepickup,0,0,angle)
	end
end)
function getRepresentation(element,type)
	local elemTable = {}
	for i,elem in ipairs(getElementsByType(type,element)) do
		if elem ~= exports.edf:edfGetHandle(elem) then
			table.insert(elemTable,elem)
		end
	end
	if (#elemTable == 0) then
		return false
	elseif (#elemTable == 1) then
		return elemTable[1]
	else
		return elemTable
	end
end
