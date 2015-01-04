// =============================================================================================
//
// lua\FlagSpawn.lua
//
// ==============================================================================================
Script.Load("lua/BaseSpawn.lua")

class 'FlagSpawn' (BaseSpawn)

FlagSpawn.kMapName = "flag_Spawn"


function Flagspawn:OnCreate()
	self.teamNumber = self.teamNumber or 0
end
