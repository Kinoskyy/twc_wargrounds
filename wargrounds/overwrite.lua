setWeather_ =  setWeather
setWeather = function() end

setTime_ = setTime
setTime = function() end

setSkyGradient_ = setSkyGradient
setSkyGradient = function() end

setMinuteDuration_ = setMinuteDuration
setMinuteDuration = function() end

outputChatBox_ = outputChatBox
outputChatBox =
function(msg, to, r, g, b, bool)
	if string.find(msg, "):") then
		if not string.find(msg, "(ADMIN)") then
			return
		end
	end
	if msg and type(msg) == "string" then
		if string.len(msg) > 0 then
			outputChatBox_(msg, to, r, g, b, bool)
		end
	end
end

setFogDistance_ = setFogDistance
setFogDistance = function() end

setFarClipDistance_ = setFarClipDistance
setFarClipDistance = function() end

setSunSize_ = setSunSize
setSunSize = function() end

setSunColor_ = setSunColor
setSunColor = function() end

if( guiGetScreenSize ) then 
	dxDrawText_ = dxDrawText; 
	local screen = Vector2( guiGetScreenSize( )); 
	local scale = screen.x/1920; 
	function dxDrawText( text, x, y, w, h, ... )
		if( ( 
			(text:find( 'wins the round!')) or 
			(text:find( 'Round has been finished by a draw!' ) ) or 
			(text:find('Waiting other players...' ) ) or 
			(text:find('Team destroyed all the enemies') ) or 
			(text:find('Time is up') ) or 
			(text:find('No one has survived' ) ) or 
			(text:find('winner with')) 
		) ) then 
			return true
		end
		return dxDrawText_( text, x, y, w, h, ... )
	end 
end 
