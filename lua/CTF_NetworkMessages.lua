
local kMarineBuildStructureMessage = 
{
    origin = "vector",
    direction = "vector",
    structureIndex = "integer (1 to 10)",
    lastClickedPosition = "vector"
}


function BuildMarineDropStructureMessage(origin, direction, structureIndex, lastClickedPosition)

    local t = {}
    
    t.origin = origin
    t.direction = direction
    t.structureIndex = structureIndex
    t.lastClickedPosition = lastClickedPosition or Vector(0,0,0)

    return t
    
end    

function ParseMarineBuildMessage(t)
    return t.origin, t.direction, t.structureIndex, t.lastClickedPosition
end

local kClassBuyMessage =

{
    classType = "enum kClassTypes",
}

Shared.RegisterNetworkMessage("ClassBuy", kClassBuyMessage)

Shared.RegisterNetworkMessage("MarineBuildStructure", kMarineBuildStructureMessage)
