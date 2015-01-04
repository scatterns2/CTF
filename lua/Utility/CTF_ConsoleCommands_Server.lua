local classConfigShorthandMap = {
    m = kClassTypes.Medic,
	e = kClassTypes.Engineer,   
	r = kClassTypes.Recon,	
	a = kClassTypes.Assault,

}
Event.Hook("Console_ccc", function(client,cm)
    if true or Shared.GetCheatsEnabled() then
        local player = client:GetControllingPlayer()
        local extraValues = {
			classType  = classConfigShorthandMap[tostring(cm)] or kClassTypes.Medic,
        }
        player:Replace("marine", player:GetTeamNumber(), false, nil, extraValues)
    end
end)
