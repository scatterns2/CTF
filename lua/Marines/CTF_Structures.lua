Script.Load("lua/Armory.lua")
Script.Load("lua/CommandStation.lua")

local orig_Armory_GetCanBeUsed = Armory.GetCanBeUsed
function Armory:GetCanBeUsed(player, useSuccessTable)
        useSuccessTable.useSuccess = false
end

local orig_CommandStation_GetCanBeUsed = CommandStation.GetCanBeUsed
function CommandStation:GetCanBeUsed(player, useSuccessTable)

        useSuccessTable.useSuccess = false      
end

local orig_CommandStation_OnConstructionComplete = CommandStation.OnConstructionComplete
function CommandStation:OnConstructionComplete()
    self:TriggerEffects("closed")    
end

local orig_CommandStation_OnUpdateAnimationInput = CommandStation.OnUpdateAnimationInput
function CommandStructure:OnUpdateAnimationInput(modelMixin)

    PROFILE("CommandStructure:OnUpdateAnimationInput")
    modelMixin:SetAnimationInput("occupied", true)
    
end

local orig_CommandStation_GetIsPlayerInside = CommandStation.GetIsPlayerInside
function CommandStation:GetIsPlayerInside(player)
	return true
end

