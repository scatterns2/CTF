
for _, v in ipairs( {  'HeavyMachineGun' } ) do
	AppendToEnum( kTechId, v )
end

AppendToEnum( kPlayerStatus, 'HMG' )

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
    
end								

local oldBuildTechData = BuildTechData
function BuildTechData()
	local techData = oldBuildTechData()
	CTFTechAdditions(techData)
	return techData
end