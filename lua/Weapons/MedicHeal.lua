
Marine.kHealRadius = 14
Marine.kHealAmount = 10
Marine.kMaxTargets = 3
Marine.kThinkInterval = .25
Marine.kHealInterval = 2
Marine.kHealEffectInterval = 1
Marine.kHealPercentage = 0.06
Marine.kMinHeal = 10
Marine.kMaxHeal = 60


local function GetHealTargets(self)

    local targets = {}
    
    // priority on players
    for _, player in ipairs(GetEntitiesForTeamWithinRange("Player", self:GetTeamNumber(), self:GetOrigin(), Marine.kHealRadius)) do
    
        if player:GetIsAlive() then
            table.insert(targets, player)
        end
        
    end

    for _, healable in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", self:GetTeamNumber(), self:GetOrigin(), Marine.kHealRadius)) do
        
        if healable:GetIsAlive() then
            table.insertunique(targets, healable)
        end
        
    end

    return targets

end

function Marine:PerformHealing()

    PROFILE("Marine:PerformHealing")

    local targets = GetHealTargets(self)
    local entsHealed = 0
    
    for _, target in ipairs(targets) do
    
        local healAmount = self:TryHeal(target)
        entsHealed = entsHealed + ((healAmount > 0 and 1) or 0)
        
        if entsHealed >= Marine.kMaxTargets then
            break
        end
    
    end

    if entsHealed > 0 then   
        self.timeOfLastHeal = Shared.GetTime()        
    end
    
end

function Marine:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * Marine.kHealPercentage
    local heal = Clamp(unclampedHeal, Marine.kMinHeal, Marine.kMaxHeal)
    
    if self.healWaveActive then
        heal = heal * Marine.kHealWaveMultiplier
    end
    
    if target:GetHealthScalar() ~= 1 and (not target.timeLastCragHeal or target.timeLastCragHeal + Marine.kHealInterval <= Shared.GetTime()) then
    
        local amountHealed = target:AddHealth(heal)
        target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
end

function Marine:UpdateHealing()

    local time = Shared.GetTime()
    
    if not self:GetIsOnFire() and ( self.timeOfLastHeal == nil or (time > self.timeOfLastHeal + Marine.kHealInterval) ) then    
        self:PerformHealing()        
    end
    
end

function Marine:GetIsHealingActive()
    return self:GetIsAlive() and self:GetIsBuilt() and (self.timeOfLastHeal ~= nil) and (Shared.GetTime() < (self.timeOfLastHeal + Marine.kHealInterval))
end