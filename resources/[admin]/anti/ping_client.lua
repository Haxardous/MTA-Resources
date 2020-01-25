function downloadCheck (pingLimit, pingCheckTime)
	if not isTransferBoxActive() and getPlayerPing(localPlayer) > pingLimit then
		setTimer(function(pingLimit)
			if getPlayerPing(localPlayer) > pingLimit then
				triggerServerEvent('clientCheck', root, true)
			else
				triggerServerEvent('clientCheck', root, false)
			end
		end, pingCheckTime, 1, pingLimit)
	else
		triggerServerEvent('clientCheck', root, false)
	end
end
addEvent('downloadCheck', true)
addEventHandler( 'downloadCheck', root, downloadCheck )

function spectate ()
	executeCommandHandler('spectate')
end
addEvent('spectate', true)
addEventHandler( 'spectate', resourceRoot, spectate )

-------------------------------------------------------
----------- Lagger detection 
-------------------------------------------------------


local currentLossWarning = 0;
local isLossWarningShown = false;
local kickLossAfterWarningsCount = 30;
local loss = getNetworkStats()["packetlossLastSecond"]
local countSecondsLeftBeforeKick = kickLossAfterWarningsCount - currentLossWarning;

function packetLossCheck()
	if (loss > 15) then
		currentLossWarning = currentLossWarning + 1;
		countSecondsLeftBeforeKick = kickLossAfterWarningsCount - currentLossWarning;
		if (currentLossWarning == 10) then
			outputChatBox("your packet loss is too high. you'll be kicked after "..countSecondsLeftBeforeKick.." seconds. seconds left will reset after 1 minute.", 255, 0, 0)
			requestDisplayPacketLossWarning()
		elseif (currentLossWarning == 30) then
			triggerServerEvent("onLaggerRequestKick", localPlayer)
		end
	end
end
setTimer(packetLossCheck, 1000, 0)

function showPacketLossWarning()
	local sx,sy = guiGetScreenSize()
	if (isLossWarningShown) then
		local p = ( getTickCount() - tick ) / 500
		screenW, screenH = interpolateBetween(sx, sy - 1000, 0, sx, sy, 0, p, "Linear")
	  
		dxDrawText("Packet Loss detected (%"..string.format("%.2f", loss).."), "..countSecondsLeftBeforeKick.." seconds left before kicking you from the server.", screenW*(855/1920), screenH*(-427/1080), screenW*(1070/1920), screenH*(555/1080), tocolor(0, 0, 0, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Packet Loss detected (%"..string.format("%.2f", loss).."), "..countSecondsLeftBeforeKick.." seconds left before kicking you from the server.", screenW*(853/1920), screenH*(-430/1080), screenW*(1070/1920), screenH*(555/1080), tocolor(255, 0, 0, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
	end
end

function requestDisplayPacketLossWarning()
	if not (isLossWarningShown) then
		isLossWarningShown = true;
		tick = getTickCount()
		addEventHandler("onClientRender", root, showPacketLossWarning)
		setTimer(function() 
			removeEventHandler("onClientRender", root, showPacketLossWarning) 
			isLossWarningShown = false;
		end, 21000, 1)
	end
end

-------------------------------------------------------
