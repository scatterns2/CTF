Script.Load("lua/Gorge.lua")

local orig_Gorge_InitWeapons = Gorge.InitWeapons
function Gorge:InitWeapons()

    Alien.InitWeapons(self)

    self:GiveItem(SpitSpray.kMapName)
	self:GiveItem(DropStructureAbility.kMapName)   
    self:GiveItem(BileBomb.kMapName)
    self:GiveItem(BabblerAbility.kMapName)
	self:GiveItem(Web.kMapName)
	
    self:SetActiveWeapon(SpitSpray.kMapName)
    
end