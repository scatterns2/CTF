Script.Load("lua/TeamMixin.lua")
Script.Load("lua/ScriptActor.lua")

class 'Flag' (ScriptActor)

Flag.kMapName = "flagspawn"

Flag.kModelName = PrecacheAsset("models/alien/gorge/gorge.model")
Flag.kAnimationGraph = PrecacheAsset("models/alien/gorge/gorge.animation_graph")

Flag.kAtBase = false
Flag.kCarried = false
Flag.kActive = false

local networkVars =
{
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)

function Flag:OnCreate()

    ScriptActor.OnCreate(self)

    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, TeamMixin)
    
    self:SetUpdates(true)
    self:SetRelevancyDistance(Math.infinity)

end 

function Flag:OnInitialized()

   // self.kAtbase = true
   // self.kActive = true
//
    self:SetModel(self.kModelName, nil /*self.kAnimationGraph*/)

end

Shared.LinkClassToMap("Flag", Flag.kMapName, networkVars)