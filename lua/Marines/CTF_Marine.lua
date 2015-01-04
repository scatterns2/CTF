Script.Load("lua/Marine.lua")
Script.Load("lua/Weapons/MarineStructureAbility.lua")
Script.Load("lua/Marines/AvatarMoveMixin.lua")
Script.Load("lua/CloakableMixin.lua")
Script.Load("lua/Marines/CTF_MarineAbilities.lua")

local networkVars = {

    armorBase = "float (0 to 2045 by 1)",
	healthBase = "float (0 to 250 by 1)",
	speedBase = "float (0 to 25 by 0.1)",
	hasNanoShield = "boolean",
	hasMedicHeal = "boolean",
	camouflaged = "boolean",
	hasCloakAbility = "boolean",
    hasCamouflage = "boolean",
}
AddMixinNetworkVars(CloakableMixin, networkVars)
AddMixinNetworkVars(AvatarMoveMixin, networkVars)

local orig_Marine_OnInitialized = Marine.OnInitialized
function Marine:OnInitialized()
	
	self.classType = self.classType or kClassTypes.Engineer
  
	local classType = kClassTypesData[self.classType]
	
	self.weaponPrimary 	 = classType and classType.weaponPrimary
	self.weaponSecondary = classType and classType.weaponSecondary
	self.weaponTertiary  = classType and classType.weaponTertiary
	self.armorBase		 = classType and classType.armorBase 
	self.speedBase	 	 = classType and classType.speedBase
	self.healthBase	 	 = classType and classType.healthBase 

	self.classItem 		 = classType and classType.classItem
	self.classSpecial    = classType and classType.classSpecial
	self.marineModel     = classType and classType.marineModel
	self.marineGraph     = classType and classType.marineGraph
	
	self.hasNanoShield = (self.classType == kClassTypes.Assault)
	self.hasMedicHeal = (self.classType == kClassTypes.Medic)
	self.hasCloakAbility = (self.classType == kClassTypes.Recon)

	
  // work around to prevent the spin effect at the infantry portal spawned from
    // local player should not see the holo marine model
    if Client and Client.GetIsControllingPlayer() then
    
        local ips = GetEntitiesForTeamWithinRange("InfantryPortal", self:GetTeamNumber(), self:GetOrigin(), 1)
        if #ips > 0 then
            Shared.SortEntitiesByDistance(self:GetOrigin(), ips)
            ips[1]:PreventSpinEffect(0.2)
        end
        
    end
    
    // These mixins must be called before SetModel because SetModel eventually
    // calls into OnUpdatePoseParameters() which calls into these mixins.
    // Yay for convoluted class hierarchies!!!
    InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kPlayerMoveOrderCompleteDistance })
    InitMixin(self, OrderSelfMixin, { kPriorityAttackTargets = { "Harvester" } })
    InitMixin(self, StunMixin)
    InitMixin(self, NanoShieldMixin)
    InitMixin(self, SprintMixin)
    InitMixin(self, WeldableMixin)
	InitMixin(self, CloakableMixin)
	InitMixin(self, AvatarMoveMixin)

    
    // SetModel must be called before Player.OnInitialized is called so the attach points in
    // the Marine are valid to attach weapons to. This is far too subtle...
    self:SetModel(self:GetVariantModel(), MarineVariantMixin.kMarineAnimationGraph)
    
    Player.OnInitialized(self)
    
    // Calculate max and starting armor differently
	self:GetArmorAmount(self.armorBase)
	self:SetMaxHealth(self.healthBase)
	self:SetHealth(self.healthBase)
    
    if Server then
    
        // This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
        
        InitMixin(self, InfestationTrackerMixin)
        self.timeRuptured = 0
        self.interruptStartTime = 0
        self.timeLastPoisonDamage = 0
        
        self.lastPoisonAttackerId = Entity.invalidId
        
        //self:AddTimedCallback(UpdateNanoArmor, 1)
       
    elseif Client then
    
        InitMixin(self, HiveVisionMixin)
        InitMixin(self, MarineOutlineMixin)
        
        self:AddHelpWidget("GUIMarineHealthRequestHelp", 2)
        self:AddHelpWidget("GUIMarineFlashlightHelp", 2)
        self:AddHelpWidget("GUIBuyShotgunHelp", 2)
        // No more auto weld orders.
        //self:AddHelpWidget("GUIMarineWeldHelp", 2)
        self:AddHelpWidget("GUIMapHelp", 1)
        self:AddHelpWidget("GUITunnelEntranceHelp", 1)
        
        self.notifications = { }
        self.timeLastSpitHitEffect = 0
        
    end
    
    self.weaponDropTime = 0
    
    local viewAngles = self:GetViewAngles()
    self.lastYaw = viewAngles.yaw
    self.lastPitch = viewAngles.pitch
    
    // -1 = leftmost, +1 = right-most
    self.horizontalSwing = 0
    // -1 = up, +1 = down
    
    self.timeLastSpitHit = 0
    self.lastSpitDirection = Vector(0, 0, 0)
    self.timeOfLastDrop = 0
    self.timeOfLastPickUpWeapon = 0
    self.ruptured = false
    self.interruptAim = false
    self.catpackboost = false
    self.timeCatpackboost = 0
    
    self.flashlightLastFrame = false
	self.timeLastNano = 0
    
end
	
function Marine:GetArmorAmount()
    return self.armorBase
end

function Marine:GetMaxSpeed()
    return self.speedBase
end

function Marine:SetMaxHealth()
	return self.healthBase
end

local orig_Marine_InitWeapons = Marine.InitWeapons
function Marine:InitWeapons()
   
   Player.InitWeapons(self)
	
	self:GiveItem(self.weaponPrimary)
	self:GiveItem(self.weaponAuxillary)
    self:GiveItem(self.weaponSecondary)
    self:GiveItem(self.weaponTertiary)
    self:GiveItem(self.classItem)
	self:GiveItem(self.classSpecial)

    self:SetQuickSwitchTarget(self.weaponSecondary)
    self:SetActiveWeapon(self.weaponPrimary)

end

function Marine:GetIsCamouflaged()
    return true 
end


function Marine:Buy()

    // Don't allow display in the ready room, or as phantom
    if self:GetIsLocalPlayer() then
    
        // The Embryo cannot use the buy menu in any case.
        if self:GetTeamNumber() ~= 0  then
        
            if not self.buyMenu  then
            
                self.buyMenu = GetGUIManager():CreateGUIScript("Marines/GUIMarineClassMenu")
                MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
                
            else
                self:CloseMenu()
            end
            
        else
            self:PlayEvolveErrorSound()
        end
        
    end
    
end

local orig_Marine_OverrideInput = Marine.OverrideInput
function Marine:OverrideInput(input)

	// Always let the MarineStructureAbility override input, since it handles client-side-only build menu
	local buildAbility = self:GetWeapon(MarineStructureAbility.kMapName)

	if buildAbility then
		input = buildAbility:OverrideInput(input)
	end
	
	return Player.OverrideInput(self, input)
        
end

local orig_Marine_UpdateGhostModel = MarineUpdateGhostModel
function Marine:UpdateGhostModel()

    self.currentTechId = nil
    self.ghostStructureCoords = nil
    self.ghostStructureValid = false
    self.showGhostModel = false
    
    local weapon = self:GetActiveWeapon()
	
	if weapon then
		if weapon:isa("MarineStructureAbility") then
		
			self.currentTechId = weapon:GetGhostModelTechId()
			self.ghostStructureCoords = weapon:GetGhostModelCoords()
			self.ghostStructureValid = weapon:GetIsPlacementValid()
			self.showGhostModel = weapon:GetShowGhostModel()

			return weapon:GetShowGhostModel()
			
		elseif weapon:isa("LayMines") then
    
			self.currentTechId = kTechId.Mine
			self.ghostStructureCoords = weapon:GetGhostModelCoords()
			self.ghostStructureValid = weapon:GetIsPlacementValid()
			self.showGhostModel = weapon:GetShowGhostModel()
    
		end	
	end

end

if Client then

    function Marine:GetShowGhostModel()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("MarineStructureAbility") then
            return weapon:GetShowGhostModel()       
		end
		
        return false
        
    end
	
    function Marine:GetGhostModelOverride()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("MarineStructureAbility") and weapon.GetGhostModelName then
            return weapon:GetGhostModelName(self)

						
        end
        
    end
    
    function Marine:GetGhostModelTechId()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("MarineStructureAbility") then
            return weapon:GetGhostModelTechId()		
        end
        
    end
   
    function Marine:GetGhostModelCoords()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("MarineStructureAbility") then
            return weapon:GetGhostModelCoords()		
        end
        
    end
    
    function Marine:GetLastClickedPosition()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("MarineStructureAbility") then
            return weapon.lastClickedPosition
        end
    end

    function Marine:GetIsPlacementValid()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("MarineStructureAbility") then
            return weapon:GetIsPlacementValid()		
        end
    
    end

end

if Server then

    function Marine:ProcessClassBuyAction(message)
	
	    local extraValues = {
		    classType = message.classType
	    }
	    self:Replace(Marine.kMapName,self:GetTeamNumber(), false, nil,extraValues
	    )
	end
end

local origGetHostStructure = GetHostStructure
function GetHostStructureFor(entity, techId)

    local hostStructures = {}
	table.copy(GetEntitiesForTeamWithinRange("CommandStation", entity:GetTeamNumber(), entity:GetOrigin(), kClassMenuUseRange), hostStructures, true)
    table.copy(GetEntitiesForTeamWithinRange("PrototypeLab", entity:GetTeamNumber(), entity:GetOrigin(), PrototypeLab.kResupplyUseRange), hostStructures, true)
    
    if table.count(hostStructures) > 0 then
    
        for index, host in ipairs(hostStructures) do
        
            // check at first if the structure is hostign the techId:
            if GetHostSupportsTechId(entity,host, techId) then
                return host
            end
        
        end
            
    end
    
    return nil

end

local origGetIsCloseToMenuStructure = GetIsCloseToMenuStructure
function GetIsCloseToMenuStructure(player)
    
    local ptlabs = GetEntitiesForTeamWithinRange("PrototypeLab", player:GetTeamNumber(), player:GetOrigin(), PrototypeLab.kResupplyUseRange)
    local commandchairs = GetEntitiesForTeamWithinRange("CommandStation", player:GetTeamNumber(), player:GetOrigin(), kClassMenuUseRange)
    
    return (ptlabs and #ptlabs > 0) or (commandchairs and #commandchairs > 0)

end

local orig_Marine_HandleButtons
function Marine:HandleButtons(input)

    PROFILE("Marine:HandleButtons")
    
    Player.HandleButtons(self, input)
    
	self:ClassAbility(input)
	
       
end

function Marine:ClassAbility(input)
	
	local abilityPressed = bit.band(input.commands,  Move.ToggleFlashlight) ~= 0
	
	if abilityPressed and self.timeLastNano + kMedicHealCoolDown < Shared.GetTime() then
		if self.hasNanoShield then
				self:ActivateNanoShield()
				self.timeLastNano = Shared.GetTime()	
		elseif self.hasMedicHeal then
				self:PerformMedicHeal()
				self.timeLastNano = Shared.GetTime()	
		elseif self.hasCloakAbility then
				self:TriggerCloak()
				self.timeLastNano = Shared.GetTime()	
		end
	end
end






Class_Reload("Marine", networkVars)