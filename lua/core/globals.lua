RestoredHearts.SaveManager.Utility.AddDefaultRunData(
	RestoredHearts.SaveManager.DefaultSaveKeys.GLOBAL,
	{ IllusionData = {} }
)

RestoredHearts.RNG = RNG()

RestoredHearts:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	RestoredHearts.RNG:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
end)

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.PRE_DATA_SAVE, function(_, data)
	local newData = {
		game = {
			run = {
				IllusionData = IllusionMod.GetSaveData(),
			},
		},
	}
	return RestoredHearts.SaveManager.Utility.PatchSaveFile(newData, data)
end)

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.PRE_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
		local settings = {
			["HeartStyleRender"] = 1,
			["IllusionHeartSpawnChance"] = 20,
			["SunHeartSpawnChance"] = 20,
			["ImmortalHeartSpawnChance"] = 20,
			["ActOfContritionImmortal"] = false,
			["IllusionCanPlaceBomb"] = IllusionMod.CanPlaceBomb,
			["IllusionPerfectIllusion"] = IllusionMod.PerfectIllusion,
		}
		for k, v in pairs(settings) do
			if data.file.other[k] == nil then
				data.file.other[k] = v
			end
		end
		return data
	end
end)

RestoredHearts:AddCallback(RestoredHearts.SaveManager.SaveCallbacks.POST_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
		IllusionMod.LoadSaveData(data.game.run.IllusionData)
		IllusionMod.CanPlaceBomb = data.file.other.IllusionCanPlaceBomb
		IllusionMod.PerfectIllusion = data.file.other.IllusionPerfectIllusion
	end
end)

RestoredHearts:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, -1, function()
	local room = Game():GetRoom()
	if room:GetType() == RoomType.ROOM_SUPERSECRET and room:IsFirstVisit() then
		local moddedHearts = {
			["ImmortalHeartSpawnChance"] = RestoredHearts.Enums.Pickups.Hearts.HEART_IMMORTAL,
			["SunHeartSpawnChance"] = RestoredHearts.Enums.Pickups.Hearts.HEART_SUN,
			["IllusionHeartSpawnChance"] = RestoredHearts.Enums.Pickups.Hearts.HEART_ILLUSION,
		}
		local moddedHeartsCount = {}
		
		local morphTo
		local max = 0
		for k, subtype in pairs(moddedHearts) do
			local num = #TSIL.PickupSpecific.GetHearts(subtype)
			moddedHeartsCount[k] = num
			if max < num then
				max = num
			end
		end

		if max == 0 then
			return
		end

		local heartsToChange = TSIL.Utils.Tables.Filter(moddedHearts, function(saveKey, subtype)
			return moddedHeartsCount[saveKey] == max and RestoredHearts:GetDefaultFileSave(saveKey) > 0
		end)
		
		morphTo = TSIL.Random.GetRandomElementsFromTable(heartsToChange, 1)[1]
		for _, heart in ipairs(TSIL.PickupSpecific.GetHearts()) do
			heart:ToPickup():Morph(heart.Type, heart.Variant, morphTo, true, true)
		end
	end
end)
