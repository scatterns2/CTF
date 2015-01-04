
local kHealRadius = 14
local kHealAmount = 40
local kMaxTargets = 3
local kThinkInterval = .25
local kHealInterval = 3
local kHealEffectInterval = 1
local kHealPercentage = 0.06
local kMinHeal = 40
local kMaxHeal = 40


local function GetHealTargets(self)

    local targets = {}
    
    // priority on players
    for _, player in ipairs(GetEntitiesForTeamWithinRange("Player", self:GetTeamNumber(), self:GetOrigin(), kHealRadius)) do
    
        if player:GetIsAlive() then
            table.insert(targets, player)
        end
        
    end

    for _, healable in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", self:GetTeamNumber(), self:GetOrigin(), kHealRadius)) do
        
        if healable:GetIsAlive() then
            table.insertunique(targets, healable)
        end
        
    end

    return targets

end

function Marine:PerformMedicHeal()

    PROFILE("Marine:PerformHealing")

    local targets = GetHealTargets(self)
    local entsHealed = 0
    
    for _, target in ipairs(targets) do
    
        local healAmount = self:TryHeal(target)
        entsHealed = entsHealed + ((healAmount > 0 and 1) or 0)
        
        if entsHealed >= kMaxTargets then
            break
        end
    
    end

    if entsHealed > 0 then   
        self.timeOfLastHeal = Shared.GetTime()        
    end
    
end

function Marine:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * kHealPercentage
    local heal = Clamp(unclampedHeal, kMinHeal, kMaxHeal)
    
   
    if target:GetHealthScalar() ~= 1 and (not target.timeLastCragHeal or target.timeLastCragHeal + kHealInterval <= Shared.GetTime()) then
    
        local amountHealed = target:AddHealth(heal)
        target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
end

function Marine:UpdateHealing()

    local time = Shared.GetTime()
    
    if ( self.timeOfLastHeal == nil or (time > self.timeOfLastHeal + kHealInterval) ) then    
        self:PerformHealing()        
    end
    
end

function Marine:GetIsHealingActive()
    return self:GetIsAlive() and (self.timeOfLastHeal ~= nil) and (Shared.GetTime() < (self.timeOfLastHeal + kHealInterval))
end