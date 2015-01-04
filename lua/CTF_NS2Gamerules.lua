Script.Load("lua/NS2Gamerules.lua")

if Server then

function NS2Gamerules:SpawnInitialFlags()
    
    self:GetTeam1().flagList = {}
    self:GetTeam2().flagList = {}
    
    for flagSpawnI, flagSpawn in ientitylist(Shared.GetEntitiesWithClassname(FlagSpawn.kMapName)) do
    
        if flagSpawn.teamNumber == 1 or flagSpawn.teamNumber == 2 then
            
            local flag = CreateEntity(Flag.kMapName, flagSpawn:GetOrigin(), flagSpawn.teamNumber)
            
            if flagSpawn.teamNumber == 1 then
                table.insert(self:GetTeam1().flagList, flag)
            elseif flagSpawn.teamNumber == 2 then
                table.insert(self:GetTeam2().flagList, flag)
            end
        end
    end
    
    if #self:GetTeam1().flagList == 0 then
        -- oh shit!
    end
    if #self:GetTeam2().flagList == 0 then
        -- oh shit!
    end
end

        