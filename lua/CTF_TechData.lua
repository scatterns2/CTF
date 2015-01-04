

local function CTFTechAdditions(techData)

								
	table.insert(techData, { 	[kTechDataId] = kTechId.HeavyMachineGun,     
								[kTechDataMaxHealth] = kMarineWeaponHealth,    
								[kTechDataPointValue] = kHeavyMachineGunPointValue,      
								[kTechDataMapName] = HeavyMachineGun.kMapName,
								[kTechDataDisplayName] = "HeavyMachineGun",            
								[kTechDataTooltipInfo] =  "HeavyMachineGun",
								[kTechDataModel] = HeavyMachineGun.kModelName,
								[kTechDataDamageType] = kHeavyMachineGunDamageType,
								[kTechDataCostKey] = kHeavyMachineGunCost,
								[kStructureAttachId] = kTechId.AdvancedArmory,
								[kStructureAttachRange] = kArmoryWeaponAttachRange, 
								[kStructureAttachRequiresPower] = true })
								
    table.insert(techData, { 	[kTechDataId] = kTechId.FlagSpawn,
								[kTechDataGhostModelClass] = "MarineGhostModel", 
								[kTechDataMapName] = FlagSpawn.kMapName })
								
								
	table.insert(techData, {    [kTechDataId] = kTechId.MarineStructureAbility, 
								[kTechDataTooltipInfo] = "MARINE_BUILD_TOOLTIP", 
								[kTechDataPointValue] = kWeaponPointValue,   
								[kTechDataMapName] = MarineStructureAbility.kMapName, 
								[kTechDataDisplayName] = "MARINE_BUILD",        
								[kTechDataModel] = Welder.kModelName, 
								[kTechDataDamageType] = kWelderDamageType,
								[kTechDataCostKey] = kWelderCost, })
								
								
    
end								

local oldBuildTechData = BuildTechData
function BuildTechData()
	local techData = oldBuildTechData()
	CTFTechAdditions(techData)
	return techData
end