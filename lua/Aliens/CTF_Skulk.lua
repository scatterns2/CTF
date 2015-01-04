Script.Load("lua/Skulk.lua")

local orig_Skulk_InitWeapons = Skulk.InitWeapons
function Skulk:InitWeapons()

    Alien.InitWeapons(self)
    
    self:GiveItem(BiteLeap.kMapName)
    self:GiveItem(Parasite.kMapName)
    self.GiveItem(Leap.kMapName)
	self.GiveItem(Xenocide.kMapName)
    self:SetActiveWeapon(BiteLeap.kMapName)    
    
end