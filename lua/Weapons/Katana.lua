// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\Katana.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Weapons/Weapon.lua")

class 'Katana' (Weapon)

Katana.kMapName = "katana"

Katana.kModelName = PrecacheAsset("models/marine/katana/katana.model")

local kViewModelName = PrecacheAsset("models/marine/katana/katana_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/katana/katana_view.animation_graph")
local kRange = 1

local kKatanaRange = 3.3
local kKatanaDamage = 220
local kKatanaDamageType = kDamageType.Structural

local networkVars =
{
	sprintAllowed = "boolean",
}

function Katana:OnCreate()

    Weapon.OnCreate(self)
	self.sprintAllowed = true

end

function Katana:OnInitialized()

    Weapon.OnInitialized(self)
    
    self:SetModel(Katana.kModelName)
    
end

function Katana:GetViewModelName(sex, variant)
    return kViewModelName
end

function Katana:GetAnimationGraphName()
    return kAnimationGraph
end

function Katana:GetHUDSlot()
    return 3
end

function Katana:GetRange()
    return kTertiaryWeaponSlot
end

function Katana:GetShowDamageIndicator()
    return true
end

function Katana:GetDeathIconIndex()
    return kDeathMessageIcon.Katana
end

function Katana:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    // Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    
end

function Katana:OnHolster(player)

    Weapon.OnHolster(self, player)
    self.primaryAttacking = false
    
end

function Katana:OnPrimaryAttack(player)

    if not self.attacking then
        
        self.primaryAttacking = true
        
    end

end

function Katana:OnPrimaryAttackEnd(player)
    self.primaryAttacking = false
end

function Katana:OnTag(tagName)

    PROFILE("Katana:OnTag")

    if tagName == "swipe_sound" then
    
        local player = self:GetParent()
        if player then
            player:TriggerEffects("katana_swing")
        end
        
    elseif tagName == "hit" then
    
        local player = self:GetParent()
        if player then
            AttackMeleeCapsule(self, player, kKatanaDamage, self:GetRange())
        end
        
    end
    
end

function Katana:UpdateViewModelPoseParameters(viewModel)

    viewModel:SetPoseParam("swing_pitch", 0)
    viewModel:SetPoseParam("swing_yaw", 0)
    viewModel:SetPoseParam("arm_loop", 0)
    
end

function Katana:OnUpdateAnimationInput(modelMixin)

    PROFILE("Katana:OnUpdateAnimationInput")

    local activity = "none"
    if self.primaryAttacking then
        activity = "primary"
    end
    modelMixin:SetAnimationInput("activity", activity)
    
end

Shared.LinkClassToMap("Katana", Katana.kMapName, networkVars)