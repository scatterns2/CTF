// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\GUIJetpackFuel.lua
//
// Created by: Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
// Manages the marine buy/purchase menu.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'GUIAbilityCooldown' (GUIScript)

GUIAbilityCooldown.kJetpackFuelTexture = "ui/marine_jetpackfuel.dds"


GUIAbilityCooldown.kFont = Fonts.kMicrogrammaDMedExt_Medium

GUIAbilityCooldown.kBackgroundWidth = GUIScale(32)
GUIAbilityCooldown.kBackgroundHeight = GUIScale(144)
GUIAbilityCooldown.kBackgroundOffsetX = 6
GUIAbilityCooldown.kBackgroundOffsetY = GUIScale(-240)

GUIAbilityCooldown.kBarWidth = GUIScale(20)
GUIAbilityCooldown.kBarHeight = GUIScale(123)

GUIAbilityCooldown.kBgCoords = {0, 0, 32, 144}

GUIAbilityCooldown.kBarCoords = {39, 10, 39 + 18, 10 + 123}

GUIAbilityCooldown.kFuelBlueIntensity = .8

GUIAbilityCooldown.kBackgroundColor = Color(0, 0, 0, 0.5)
GUIAbilityCooldown.kFuelBarOpacity = 0.8

function GUIAbilityCooldown:Initialize()    
    
    // jetpack fuel display background
    
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(GUIAbilityCooldown.kBackgroundWidth, GUIAbilityCooldown.kBackgroundHeight, 0) )
    self.background:SetPosition(Vector(GUIAbilityCooldown.kBackgroundWidth / 2 + GUIAbilityCooldown.kBackgroundOffsetX, -GUIAbilityCooldown.kBackgroundHeight / 2 + GUIAbilityCooldown.kBackgroundOffsetY, 0))
    self.background:SetAnchor(GUIItem.Left, GUIItem.Bottom) 
    self.background:SetLayer(kGUILayerPlayerHUD)
    self.background:SetTexture(GUIAbilityCooldown.kJetpackFuelTexture)
    self.background:SetTexturePixelCoordinates(unpack(GUIAbilityCooldown.kBgCoords))
    
    // fuel bar
    
    self.fuelBar = GUIManager:CreateGraphicItem()
    self.fuelBar:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.fuelBar:SetPosition( Vector(-GUIAbilityCooldown.kBarWidth / 2, -10, 0))
    self.fuelBar:SetTexture(GUIAbilityCooldown.kJetpackFuelTexture)
    self.fuelBar:SetTexturePixelCoordinates(unpack(GUIAbilityCooldown.kBarCoords))
 
    self.background:AddChild(self.fuelBar)
    self:Update(0)

end

function GUIAbilityCooldown:SetFuel(fraction)

    self.fuelBar:SetSize( Vector(GUIJetpackFuel.kBarWidth, -GUIJetpackFuel.kBarHeight * fraction, 0) )
    self.fuelBar:SetColor( Color(1 - fraction * GUIJetpackFuel.kFuelBlueIntensity, 
                                 GUIJetpackFuel.kFuelBlueIntensity * fraction * 0.8 , 
                                 GUIJetpackFuel.kFuelBlueIntensity * fraction ,
                                 GUIJetpackFuel.kFuelBarOpacity) )

end


function GUIAbilityCooldown:Update(deltaTime)

    local player = Client.GetLocalPlayer()
    
    if player and player.GetFuel then
        self:SetFuel(player:GetFuel())
    end

end



function GUIAbilityCooldown:Uninitialize()

    GUI.DestroyItem(self.fuelBar)
    GUI.DestroyItem(self.background)

end