PlaceFencesAnywhere = {}

-- GitHub for reporting issues: https://github.com/luca1197/FS_PlaceFencesAnywhere

function ConstructionBrushNewFence:verifyAccess(posX, posY, posZ)

	-- Check player permission
	local parentClass = self:superClass()
	if not parentClass:hasPlayerPermission() then
		return ConstructionBrush.ERROR.NO_PERMISSION
	end
	
	-- Check farmland access
	if not g_currentMission.accessHandler:canFarmAccessLand(g_localPlayer.farmId, posX, posZ, true) then
		return ConstructionBrush.ERROR.LAND_UNOWNED
	end

	return nil

end

function ConstructionBrushNewFence:validateCurrentSegment(targetSegmentEndX, targetSegmentEndZ)

	if not self.currentSegment then
		return false
	end

	local curSegmentStartX, _, curSegmentStartZ = self.currentSegment:getStartPos()
	if not curSegmentStartX then
		return false
	end

	-- Check farmland access
	if not g_farmlandManager:getIsOwnedByFarmAlongLine(g_localPlayer.farmId, curSegmentStartX, curSegmentStartZ, targetSegmentEndX, targetSegmentEndZ) then
		self.cursor:setErrorMessage(g_i18n:getText(ConstructionBrush.ERROR_MESSAGES[ConstructionBrush.ERROR.LAND_UNOWNED]))
		return false
	end

	-- Check has enough money
	local curSegmentPrice = self.currentSegment:getPrice()
	if g_currentMission:getMoney(g_localPlayer.farmId) < curSegmentPrice then
		self.cursor:setErrorMessage(g_i18n:getText(ConstructionBrushNewFence.ERROR_MESSAGES[ConstructionBrushNewFence.ERROR.NOT_ENOUGH_MONEY]))
		return false
	end

	self.cursor:setMessage(g_i18n:formatMoney(curSegmentPrice))

	return true

end

function FenceSegment:checkOverlap()

	return nil

end
