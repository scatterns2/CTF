// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\GUIMarineBuyMenu.lua
//
// Created by: Andreas Urwalek (andi@unknownworlds.com)
//
// Manages the marine buy/purchase menu.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/GUIAnimatedScript.lua")

class 'GUIMarineClassMenu' (GUIAnimatedScript)



GUIMarineClassMenu.kBuyMenuTexture = "ui/marine_buy_textures.dds"
GUIMarineClassMenu.kBuyHUDTexture = "ui/marine_buy_icons.dds"
GUIMarineClassMenu.kRepeatingBackground = "ui/menu/grid.dds"
GUIMarineClassMenu.kContentBgTexture = "ui/menu/repeating_bg.dds"
GUIMarineClassMenu.kContentBgBackTexture = "ui/menu/repeating_bg_black.dds"
GUIMarineClassMenu.kResourceIconTexture = "ui/pres_icon_big.dds"
GUIMarineClassMenu.kBigIconTexture = "ui/marine_buy_bigicons.dds"
GUIMarineClassMenu.kButtonTexture = "ui/marine_buymenu_button.dds"
GUIMarineClassMenu.kMenuSelectionTexture = "ui/marine_buymenu_selector.dds"
GUIMarineClassMenu.kScanLineTexture = "ui/menu/scanLine_big.dds"
GUIMarineClassMenu.kArrowTexture = "ui/menu/arrow_horiz.dds"

GUIMarineClassMenu.kFont = "fonts/AgencyFB_small.fnt"
GUIMarineClassMenu.kFont2 = "fonts/AgencyFB_small.fnt"

GUIMarineClassMenu.kDescriptionFontName = "fonts/AgencyFB_small.fnt"
GUIMarineClassMenu.kDescriptionFontSize = GUIScale(20)

GUIMarineClassMenu.kScanLineHeight = GUIScale(256)
GUIMarineClassMenu.kScanLineAnimDuration = 5

GUIMarineClassMenu.kArrowWidth = GUIScale(32)
GUIMarineClassMenu.kArrowHeight = GUIScale(32)
GUIMarineClassMenu.kArrowTexCoords = { 1, 1, 0, 0 }

// Big Item Icons
GUIMarineClassMenu.kBigIconSize = GUIScale( Vector(320, 256, 0) )
GUIMarineClassMenu.kBigIconOffset = GUIScale(20)

local kEquippedMouseoverColor = Color(1, 1, 1, 1)
local kEquippedColor = Color(0.5, 0.5, 0.5, 0.5)

local gBigIconIndex = nil
local bigIconWidth = 400
local bigIconHeight = 300
local function GetBigIconPixelCoords(techId, researched)

    if not gBigIconIndex then
    
        gBigIconIndex = {}
        gBigIconIndex[kTechId.Axe] = 0
        gBigIconIndex[kTechId.Pistol] = 1
        gBigIconIndex[kTechId.Rifle] = 2
        gBigIconIndex[kTechId.Shotgun] = 3
        gBigIconIndex[kTechId.GrenadeLauncher] = 4
        gBigIconIndex[kTechId.Flamethrower] = 5
        gBigIconIndex[kTechId.Jetpack] = 6
        gBigIconIndex[kTechId.Exosuit] = 7
        gBigIconIndex[kTechId.Welder] = 8
        gBigIconIndex[kTechId.LayMines] = 9
        gBigIconIndex[kTechId.DualMinigunExosuit] = 10
        gBigIconIndex[kTechId.UpgradeToDualMinigun] = 10
        gBigIconIndex[kTechId.ClawRailgunExosuit] = 11
        gBigIconIndex[kTechId.DualRailgunExosuit] = 11
        gBigIconIndex[kTechId.UpgradeToDualRailgun] = 11
        
        gBigIconIndex[kTechId.ClusterGrenade] = 12
        gBigIconIndex[kTechId.GasGrenade] = 13
        gBigIconIndex[kTechId.PulseGrenade] = 14
        
    
    end
    
    local index = gBigIconIndex[techId]
    if not index then
        index = 0
    end
    
    local x1 = 0
    local x2 = bigIconWidth
    
    if not researched then
    
        x1 = bigIconWidth
        x2 = bigIconWidth * 2
        
    end
    
    local y1 = index * bigIconHeight
    local y2 = (index + 1) * bigIconHeight
    
    return x1, y1, x2, y2

end

// Small Item Icons
local kSmallIconScale = 0.9
GUIMarineClassMenu.kSmallIconSize = GUIScale( Vector(100, 50, 0) )
GUIMarineClassMenu.kMenuIconSize = GUIScale( Vector(190, 80, 0) ) * kSmallIconScale
GUIMarineClassMenu.kSelectorSize = GUIScale( Vector(215, 110, 0) ) * kSmallIconScale
GUIMarineClassMenu.kIconTopOffset = 10
GUIMarineClassMenu.kItemIconYOffset = {}

GUIMarineClassMenu.kEquippedIconTopOffset = 58

local smallIconHeight = 64
local smallIconWidth = 128
local gSmallIconIndex = nil
local function GetSmallIconPixelCoordinates(itemTechId)

    if not gSmallIconIndex then
    
        gSmallIconIndex = {}
        gSmallIconIndex[kTechId.Axe] = 4
        gSmallIconIndex[kTechId.Pistol] = 3
        gSmallIconIndex[kTechId.Rifle] = 1
        gSmallIconIndex[kTechId.Shotgun] = 5
        gSmallIconIndex[kTechId.GrenadeLauncher] = 8
        gSmallIconIndex[kTechId.Flamethrower] = 6
        gSmallIconIndex[kTechId.Jetpack] = 24
        gSmallIconIndex[kTechId.Exosuit] = 26
        gSmallIconIndex[kTechId.Welder] = 10
        gSmallIconIndex[kTechId.LayMines] = 21
        gSmallIconIndex[kTechId.DualMinigunExosuit] = 26
        gSmallIconIndex[kTechId.UpgradeToDualMinigun] = 26
        gSmallIconIndex[kTechId.ClawRailgunExosuit] = 38
        gSmallIconIndex[kTechId.DualRailgunExosuit] = 38
        gSmallIconIndex[kTechId.UpgradeToDualRailgun] = 38
        
        gSmallIconIndex[kTechId.ClusterGrenade] = 42
        gSmallIconIndex[kTechId.GasGrenade] = 43
        gSmallIconIndex[kTechId.PulseGrenade] = 44
    
    end
    
    local index = gSmallIconIndex[itemTechId]
    if not index then
        index = 0
    end
    
    local y1 = index * smallIconHeight
    local y2 = (index + 1) * smallIconHeight
    
    return 0, y1, smallIconWidth, y2

end
                            
GUIMarineClassMenu.kTextColor = Color(kMarineFontColor)

GUIMarineClassMenu.kMenuWidth = GUIScale(190)
GUIMarineClassMenu.kPadding = GUIScale(8)

GUIMarineClassMenu.kEquippedWidth = GUIScale(128)

GUIMarineClassMenu.kBackgroundWidth = GUIScale(600)
GUIMarineClassMenu.kBackgroundHeight = GUIScale(710)
// We want the background graphic to look centered around the circle even though there is the part coming off to the right.
GUIMarineClassMenu.kBackgroundXOffset = GUIScale(0)

GUIMarineClassMenu.kPlayersTextSize = GUIScale(24)
GUIMarineClassMenu.kResearchTextSize = GUIScale(24)

GUIMarineClassMenu.kResourceDisplayHeight = GUIScale(64)

GUIMarineClassMenu.kResourceIconWidth = GUIScale(32)
GUIMarineClassMenu.kResourceIconHeight = GUIScale(32)

GUIMarineClassMenu.kMouseOverInfoTextSize = GUIScale(20)
GUIMarineClassMenu.kMouseOverInfoOffset = Vector(GUIScale(-30), GUIScale(-20), 0)
GUIMarineClassMenu.kMouseOverInfoResIconOffset = Vector(GUIScale(-40), GUIScale(-60), 0)

GUIMarineClassMenu.kDisabledColor = Color(0.5, 0.5, 0.5, 0.5)
GUIMarineClassMenu.kCannotBuyColor = Color(1, 0, 0, 0.5)
GUIMarineClassMenu.kEnabledColor = Color(1, 1, 1, 1)

GUIMarineClassMenu.kCloseButtonColor = Color(1, 1, 0, 1)

GUIMarineClassMenu.kButtonWidth = GUIScale(160)
GUIMarineClassMenu.kButtonHeight = GUIScale(64)

GUIMarineClassMenu.kItemNameOffsetX = GUIScale(28)
GUIMarineClassMenu.kItemNameOffsetY = GUIScale(256)

GUIMarineClassMenu.kItemDescriptionOffsetY = GUIScale(300)
GUIMarineClassMenu.kItemDescriptionSize = GUIScale( Vector(450, 180, 0) )
/*
function GUIMarineClassMenu:SetHostStructure(hostStructure)

    self.hostStructure = hostStructure
    self:_InitializeItemButtons()
    
end*/

function GUIMarineClassMenu:OnClose()

    // Check if GUIMarineClassMenu is what is causing itself to close.
    if not self.closingMenu then
        // Play the close sound since we didn't trigger the close.
        MarineBuy_OnClose()
    end

end

function GUIMarineClassMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    self.mouseOverStates = { }
    self.equipped = { }
    
    self.selectedItem = kTechId.None

    self:_InitializeBackground()
	self:_InitializeItemButtons()

    self:_InitializeContent()
    self:_InitializeResourceDisplay()
    self:_InitializeCloseButton()
    self:_InitializeEquipped()    

    MarineBuy_OnOpen()
    
end

/**
 * Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
 */
local function GetIsMouseOver(self, overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver
    
end

local function UpdateEquipped(self, deltaTime)

    self.hoverItem = nil
    for i = 1, #self.equipped do
    
        local equipped = self.equipped[i]
        if GetIsMouseOver(self, equipped.Graphic) then
        
            self.hoverItem = equipped.TechId
            equipped.Graphic:SetColor(kEquippedMouseoverColor)
            
        else
            equipped.Graphic:SetColor(kEquippedColor)
        end
        
    end
    
end

function GUIMarineClassMenu:Update(deltaTime)

    GUIAnimatedScript.Update(self, deltaTime)

    UpdateEquipped(self, deltaTime)
    self:_UpdateItemButtons(deltaTime)
    self:_UpdateContent(deltaTime)
    self:_UpdateCloseButton(deltaTime)
    
end

function GUIMarineClassMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    self:_UninitializeItemButtons()
    self:_UninitializeBackground()
    self:_UninitializeContent()
    self:_UninitializeResourceDisplay()
    self:_UninitializeCloseButton()

end

local function MoveDownAnim(script, item)

    item:SetPosition( Vector(0, -GUIMarineClassMenu.kScanLineHeight, 0) )
    item:SetPosition( Vector(0, Client.GetScreenHeight() + GUIMarineClassMenu.kScanLineHeight, 0), GUIMarineClassMenu.kScanLineAnimDuration, "MARINEBUY_SCANLINE", AnimateLinear, MoveDownAnim)

end

function GUIMarineClassMenu:_InitializeBackground()

    // This invisible background is used for centering only.
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(Color(0.05, 0.05, 0.1, 0.7))
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)
    
    self.repeatingBGTexture = GUIManager:CreateGraphicItem()
    self.repeatingBGTexture:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.repeatingBGTexture:SetTexture(GUIMarineClassMenu.kRepeatingBackground)
    self.repeatingBGTexture:SetTexturePixelCoordinates(0, 0, Client.GetScreenWidth(), Client.GetScreenHeight())
    self.background:AddChild(self.repeatingBGTexture)
    
    self.content = GUIManager:CreateGraphicItem()
    self.content:SetSize(Vector(GUIMarineClassMenu.kBackgroundWidth, GUIMarineClassMenu.kBackgroundHeight, 0))
    self.content:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.content:SetPosition(Vector((-GUIMarineClassMenu.kBackgroundWidth / 2) + GUIMarineClassMenu.kBackgroundXOffset, -GUIMarineClassMenu.kBackgroundHeight / 2, 0))
    self.content:SetTexture(GUIMarineClassMenu.kContentBgTexture)
    self.content:SetTexturePixelCoordinates(0, 0, GUIMarineClassMenu.kBackgroundWidth, GUIMarineClassMenu.kBackgroundHeight)
    self.content:SetColor( Color(1,1,1,0.8) )
    self.background:AddChild(self.content)
    
    self.scanLine = self:CreateAnimatedGraphicItem()
    self.scanLine:SetSize( Vector( Client.GetScreenWidth(), GUIMarineClassMenu.kScanLineHeight, 0) )
    self.scanLine:SetTexture(GUIMarineClassMenu.kScanLineTexture)
    self.scanLine:SetLayer(kGUILayerPlayerHUDForeground4)
    self.scanLine:SetIsScaling(false)
    
    self.scanLine:SetPosition( Vector(0, -GUIMarineClassMenu.kScanLineHeight, 0) )
    self.scanLine:SetPosition( Vector(0, Client.GetScreenHeight() + GUIMarineClassMenu.kScanLineHeight, 0), GUIMarineClassMenu.kScanLineAnimDuration, "MARINEBUY_SCANLINE", AnimateLinear, MoveDownAnim)

end

function GUIMarineClassMenu:_UninitializeBackground()

    GUI.DestroyItem(self.background)
    self.background = nil
    
    self.content = nil
    
end

function GUIMarineClassMenu:_InitializeEquipped()

    self.equippedBg = GetGUIManager():CreateGraphicItem()
    self.equippedBg:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.equippedBg:SetPosition(Vector( GUIMarineClassMenu.kPadding, -GUIMarineClassMenu.kResourceDisplayHeight, 0))
    self.equippedBg:SetSize(Vector(GUIMarineClassMenu.kEquippedWidth, GUIMarineClassMenu.kBackgroundHeight + GUIMarineClassMenu.kResourceDisplayHeight, 0))
    self.equippedBg:SetColor(Color(0,0,0,0))
    self.content:AddChild(self.equippedBg)
    
    self.equippedTitle = GetGUIManager():CreateTextItem()
    self.equippedTitle:SetFontName(GUIMarineClassMenu.kFont)
    self.equippedTitle:SetFontIsBold(true)
    self.equippedTitle:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.equippedTitle:SetTextAlignmentX(GUIItem.Align_Center)
    self.equippedTitle:SetTextAlignmentY(GUIItem.Align_Center)
    self.equippedTitle:SetColor(kEquippedColor)
    self.equippedTitle:SetPosition(Vector(0, GUIMarineClassMenu.kResourceDisplayHeight / 2, 0))
    self.equippedTitle:SetText(Locale.ResolveString("EQUIPPED"))
    self.equippedBg:AddChild(self.equippedTitle)
    
    self.equipped = { }
    
    local equippedTechIds = MarineBuy_GetEquipped()
    local selectorPosX = -GUIMarineClassMenu.kSelectorSize.x + GUIMarineClassMenu.kPadding
    
    for k, itemTechId in ipairs(equippedTechIds) do
    
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(GUIMarineClassMenu.kSmallIconSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-GUIMarineClassMenu.kSmallIconSize.x/ 2, GUIMarineClassMenu.kEquippedIconTopOffset + (GUIMarineClassMenu.kSmallIconSize.y) * k - GUIMarineClassMenu.kSmallIconSize.y, 0))
        graphicItem:SetTexture(kInventoryIconsTexture)
        graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(itemTechId))
        
        self.equippedBg:AddChild(graphicItem)
        table.insert(self.equipped, { Graphic = graphicItem, TechId = itemTechId } )
    
    end
    
end



    
local itemList = {
   
	   { classTypes = kClassTypes.Assault, label = "Assault", pixelCoords = kTechId.GrenadeLauncher},
	   { classTypes = kClassTypes.Medic, label = "Medic", pixelCoords = kTechId.Shotgun},
	   { classTypes = kClassTypes.Engineer, label = "Engineer", pixelCoords = kTechId.Welder},
	   { classTypes = kClassTypes.Recon, label = "Recon", pixelCoords = kTechId.Rifle}
	}
 
function GUIMarineClassMenu:_InitializeItemButtons()
    
    self.menu = GetGUIManager():CreateGraphicItem()
    self.menu:SetPosition(Vector( -GUIMarineClassMenu.kMenuWidth - GUIMarineClassMenu.kPadding, 0, 0))
    self.menu:SetTexture(GUIMarineClassMenu.kContentBgTexture)
    self.menu:SetSize(Vector(GUIMarineClassMenu.kMenuWidth, GUIMarineClassMenu.kBackgroundHeight, 0))
    self.menu:SetTexturePixelCoordinates(0, 0, GUIMarineClassMenu.kMenuWidth, GUIMarineClassMenu.kBackgroundHeight)
    self.content:AddChild(self.menu)
    
    self.menuHeader = GetGUIManager():CreateGraphicItem()
    self.menuHeader:SetSize(Vector(GUIMarineClassMenu.kMenuWidth, GUIMarineClassMenu.kResourceDisplayHeight, 0))
    self.menuHeader:SetPosition(Vector(0, -GUIMarineClassMenu.kResourceDisplayHeight, 0))
    self.menuHeader:SetTexture(GUIMarineClassMenu.kContentBgBackTexture)
    self.menuHeader:SetTexturePixelCoordinates(0, 0, GUIMarineClassMenu.kMenuWidth, GUIMarineClassMenu.kResourceDisplayHeight)
    self.menu:AddChild(self.menuHeader) 
    
    self.menuHeaderTitle = GetGUIManager():CreateTextItem()
    self.menuHeaderTitle:SetFontName(GUIMarineClassMenu.kFont)
    self.menuHeaderTitle:SetFontIsBold(true)
    self.menuHeaderTitle:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.menuHeaderTitle:SetTextAlignmentX(GUIItem.Align_Center)
    self.menuHeaderTitle:SetTextAlignmentY(GUIItem.Align_Center)
    self.menuHeaderTitle:SetColor(GUIMarineClassMenu.kTextColor)
    self.menuHeaderTitle:SetText(Locale.ResolveString("CLASS"))
    self.menuHeader:AddChild(self.menuHeaderTitle)
    
    self.itemButtons = { }
    	
	local classDetailList = itemList
    local selectorPosX = -GUIMarineClassMenu.kSelectorSize.x + GUIMarineClassMenu.kPadding
    local fontScaleVector = Vector(0.8, 0.8, 0)
    	
    for k, buttonDetails in ipairs(classDetailList) do
		local label = buttonDetails.label
		local iconPixelCoords = buttonDetails.pixelCoords
		local classType = buttonDetails.classTypes
        local graphicItem = GUIManager:CreateGraphicItem()
        graphicItem:SetSize(GUIMarineClassMenu.kMenuIconSize)
        graphicItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
        graphicItem:SetPosition(Vector(-GUIMarineClassMenu.kMenuIconSize.x/ 2, GUIMarineClassMenu.kIconTopOffset + (GUIMarineClassMenu.kMenuIconSize.y) * k - GUIMarineClassMenu.kMenuIconSize.y, 0))
        graphicItem:SetTexture(kInventoryIconsTexture)
        graphicItem:SetTexturePixelCoordinates(GetSmallIconPixelCoordinates(iconPixelCoords))
        
        local graphicItemActive = GUIManager:CreateGraphicItem()
        graphicItemActive:SetSize(GUIMarineClassMenu.kSelectorSize)
        
        graphicItemActive:SetPosition(Vector(selectorPosX, -GUIMarineClassMenu.kSelectorSize.y / 2, 0))
        graphicItemActive:SetAnchor(GUIItem.Right, GUIItem.Center)
        graphicItemActive:SetTexture(GUIMarineClassMenu.kMenuSelectionTexture)
        graphicItemActive:SetIsVisible(false)
        
        graphicItem:AddChild(graphicItemActive)
        
		self.className = GUIManager:CreateTextItem()
		self.className:SetFontName(GUIMarineClassMenu.kFont)
		self.className:SetFontIsBold(true)
		self.className:SetAnchor(GUIItem.Left, GUIItem.Top)
		self.className:SetPosition((Vector(0, 0, 0)))
		self.className:SetTextAlignmentX(GUIItem.Align_Min)
		self.className:SetTextAlignmentY(GUIItem.Align_Min)
		self.className:SetColor(GUIMarineClassMenu.kTextColor)
		self.className:SetText(label)
		
		graphicItem:AddChild(self.className)
			
        local costIcon = GUIManager:CreateGraphicItem()
        costIcon:SetSize(Vector(GUIMarineClassMenu.kResourceIconWidth * 0.8, GUIMarineClassMenu.kResourceIconHeight * 0.8, 0))
        costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        costIcon:SetPosition(Vector(-32, -GUIMarineClassMenu.kResourceIconHeight * 0.5, 0))
        costIcon:SetTexture(GUIMarineClassMenu.kResourceIconTexture)
        costIcon:SetColor(GUIMarineClassMenu.kTextColor)
        
        local selectedArrow = GUIManager:CreateGraphicItem()
        selectedArrow:SetSize(Vector(GUIMarineClassMenu.kArrowWidth, GUIMarineClassMenu.kArrowHeight, 0))
        selectedArrow:SetAnchor(GUIItem.Left, GUIItem.Center)
        selectedArrow:SetPosition(Vector(-GUIMarineClassMenu.kArrowWidth - GUIMarineClassMenu.kPadding, -GUIMarineClassMenu.kArrowHeight * 0.5, 0))
        selectedArrow:SetTexture(GUIMarineClassMenu.kArrowTexture)
        selectedArrow:SetColor(GUIMarineClassMenu.kTextColor)
        selectedArrow:SetTextureCoordinates(unpack(GUIMarineClassMenu.kArrowTexCoords))
        selectedArrow:SetIsVisible(false)
        
        graphicItem:AddChild(selectedArrow) 
        /*
        local itemCost = GUIManager:CreateTextItem()
        itemCost:SetFontName(GUIMarineClassMenu.kFont)
        itemCost:SetFontIsBold(true)
        itemCost:SetAnchor(GUIItem.Right, GUIItem.Center)
        itemCost:SetPosition(Vector(0, 0, 0))
        itemCost:SetTextAlignmentX(GUIItem.Align_Min)
        itemCost:SetTextAlignmentY(GUIItem.Align_Center)
        itemCost:SetScale(fontScaleVector)
        itemCost:SetColor(GUIMarineClassMenu.kTextColor)
        itemCost:SetText(ToString(LookupTechData(itemTechId, kTechDataCostKey, 0)))
        
        costIcon:AddChild(itemCost)  */
        
        graphicItem:AddChild(costIcon)  
        
        self.menu:AddChild(graphicItem)
        table.insert(self.itemButtons, { Button = graphicItem, ResourceIcon = costIcon, Highlight = graphicItemActive, Name = className, classType = classType , Arrow = selectedArrow } )

    end

    // to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

local gResearchToWeaponIds = nil
local function GetItemTechId(researchTechId)

    if not gResearchToWeaponIds then
    
        gResearchToWeaponIds = { }
        gResearchToWeaponIds[kTechId.ShotgunTech] = kTechId.Shotgun
        gResearchToWeaponIds[kTechId.AdvancedWeaponry] = { kTechId.GrenadeLauncher, kTechId.Flamethrower }
        gResearchToWeaponIds[kTechId.WelderTech] = kTechId.Welder
        gResearchToWeaponIds[kTechId.MinesTech] = kTechId.LayMines
        gResearchToWeaponIds[kTechId.JetpackTech] = kTechId.Jetpack
        gResearchToWeaponIds[kTechId.ExosuitTech] = kTechId.Exosuit
        gResearchToWeaponIds[kTechId.DualMinigunTech] = kTechId.DualMinigunExosuit
        gResearchToWeaponIds[kTechId.ClawRailgunTech] = kTechId.ClawRailgunExosuit
        gResearchToWeaponIds[kTechId.DualRailgunTech] = kTechId.DualRailgunExosuit
        
    end
    
    return gResearchToWeaponIds[researchTechId]
    
end

function GUIMarineClassMenu:_UpdateItemButtons(deltaTime)

    for i, item in ipairs(self.itemButtons) do
    
        if GetIsMouseOver(self, item.Button) then
        
            item.Highlight:SetIsVisible(true)
            self.hoverItem = item.TechId
            
        else
            item.Highlight:SetIsVisible(false)
        end
        
        local useColor = Color(1, 1, 1, 1)
        
        // set grey if not researched
        if not MarineBuy_IsResearched(item.TechId) then
            useColor = Color(0.5, 0.5, 0.5, 0.4)
        // set red if can't afford
        elseif PlayerUI_GetPlayerResources() < MarineBuy_GetCosts(item.TechId) then
           useColor = Color(1, 0, 0, 1)
        // set normal visible
        else

            local newResearchedId = GetItemTechId( PlayerUI_GetRecentPurchaseable() )
            local newlyResearched = false 
            if type(newResearchedId) == "table" then
                newlyResearched = table.contains(newResearchedId, item.TechId)
            else
                newlyResearched = newResearchedId == item.TechId
            end
            
            if newlyResearched then
            
                local anim = math.cos(Shared.GetTime() * 9) * 0.4 + 0.6
                useColor = Color(1, 1, anim, 1)
                
            end
           
        end
        
        item.Button:SetColor(useColor)
        item.Highlight:SetColor(useColor)
        item.ResourceIcon:SetColor(useColor)
        item.Arrow:SetIsVisible(self.selectedItem == item.TechId)
        
    end

end

function GUIMarineClassMenu:_UninitializeItemButtons()

    for i, item in ipairs(self.itemButtons) do
        GUI.DestroyItem(item.Button)
    end
    self.itemButtons = nil

end

function GUIMarineClassMenu:_InitializeContent()

    self.itemName = GUIManager:CreateTextItem()
    self.itemName:SetFontName(GUIMarineClassMenu.kFont)
    self.itemName:SetFontIsBold(true)
    self.itemName:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.itemName:SetPosition(Vector(GUIMarineClassMenu.kItemNameOffsetX , GUIMarineClassMenu.kItemNameOffsetY , 0))
    self.itemName:SetTextAlignmentX(GUIItem.Align_Min)
    self.itemName:SetTextAlignmentY(GUIItem.Align_Min)
    self.itemName:SetColor(GUIMarineClassMenu.kTextColor)
    self.itemName:SetText("no selection")
    
    self.content:AddChild(self.itemName)
    
    self.portrait = GetGUIManager():CreateGraphicItem()
    self.portrait:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.portrait:SetPosition(Vector(-GUIMarineClassMenu.kBigIconSize.x/2, GUIMarineClassMenu.kBigIconOffset, 0))
    self.portrait:SetSize(GUIMarineClassMenu.kBigIconSize)
    self.portrait:SetTexture(GUIMarineClassMenu.kBigIconTexture)
    self.portrait:SetTexturePixelCoordinates(GetBigIconPixelCoords(kTechId.Axe))
    self.portrait:SetIsVisible(false)
    self.content:AddChild(self.portrait)
    
    self.itemDescription = GetGUIManager():CreateTextItem()
    self.itemDescription:SetFontName(GUIMarineClassMenu.kDescriptionFontName)
    self.itemDescription:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.itemDescription:SetPosition(Vector(-GUIMarineClassMenu.kItemDescriptionSize.x / 2, GUIMarineClassMenu.kItemDescriptionOffsetY, 0))
    self.itemDescription:SetTextAlignmentX(GUIItem.Align_Min)
    self.itemDescription:SetTextAlignmentY(GUIItem.Align_Min)
    self.itemDescription:SetColor(GUIMarineClassMenu.kTextColor)
    self.itemDescription:SetTextClipped(true, GUIMarineClassMenu.kItemDescriptionSize.x - 2* GUIMarineClassMenu.kPadding, GUIMarineClassMenu.kItemDescriptionSize.y - GUIMarineClassMenu.kPadding)
    
    self.content:AddChild(self.itemDescription)
    
end

function GUIMarineClassMenu:_UpdateContent(deltaTime)

    local techId = self.hoverItem
    if not self.hoverItem then
        techId = self.selectedItem
    end
    
    if techId then
    
        local researched, researchProgress, researching = self:_GetResearchInfo(techId)
        
        local itemCost = MarineBuy_GetCosts(techId)
        local canAfford = PlayerUI_GetPlayerResources() >= itemCost

        local color = Color(1, 1, 1, 1)
        if not canAfford and researched then
            color = Color(1, 0, 0, 1)
        elseif not researched then
            // Make it clear that we can't buy this
            color = Color(0.5, 0.5, 0.5, .6)
        end
    
        self.itemName:SetColor(color)
        self.portrait:SetColor(color)        
        self.itemDescription:SetColor(color)

        self.itemName:SetText(MarineBuy_GetDisplayName(techId))
        self.portrait:SetTexturePixelCoordinates(GetBigIconPixelCoords(techId, researched))
        self.itemDescription:SetText(MarineBuy_GetWeaponDescription(techId))
        self.itemDescription:SetTextClipped(true, GUIMarineClassMenu.kItemDescriptionSize.x - 2* GUIMarineClassMenu.kPadding, GUIMarineClassMenu.kItemDescriptionSize.y - GUIMarineClassMenu.kPadding)

    end
    
    local contentVisible = techId ~= nil and techId ~= kTechId.None
    
    self.portrait:SetIsVisible(contentVisible)
    self.itemName:SetIsVisible(contentVisible)
    self.itemDescription:SetIsVisible(contentVisible)
    
end

function GUIMarineClassMenu:_UninitializeContent()

    GUI.DestroyItem(self.itemName)

end

function GUIMarineClassMenu:_InitializeResourceDisplay()
    
    self.resourceDisplayBackground = GUIManager:CreateGraphicItem()
    self.resourceDisplayBackground:SetSize(Vector(GUIMarineClassMenu.kBackgroundWidth, GUIMarineClassMenu.kResourceDisplayHeight, 0))
    self.resourceDisplayBackground:SetPosition(Vector(0, -GUIMarineClassMenu.kResourceDisplayHeight, 0))
    self.resourceDisplayBackground:SetTexture(GUIMarineClassMenu.kContentBgBackTexture)
    self.resourceDisplayBackground:SetTexturePixelCoordinates(0, 0, GUIMarineClassMenu.kBackgroundWidth, GUIMarineClassMenu.kResourceDisplayHeight)
    self.content:AddChild(self.resourceDisplayBackground)
    



end


function GUIMarineClassMenu:_UninitializeResourceDisplay()

   
    GUI.DestroyItem(self.resourceDisplayBackground)
    self.resourceDisplayBackground = nil
    
end

function GUIMarineClassMenu:_InitializeCloseButton()

    self.closeButton = GUIManager:CreateGraphicItem()
    self.closeButton:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.closeButton:SetSize(Vector(GUIMarineClassMenu.kButtonWidth, GUIMarineClassMenu.kButtonHeight, 0))
    self.closeButton:SetPosition(Vector(-GUIMarineClassMenu.kButtonWidth, GUIMarineClassMenu.kPadding, 0))
    self.closeButton:SetTexture(GUIMarineClassMenu.kButtonTexture)
    self.closeButton:SetLayer(kGUILayerPlayerHUDForeground4)
    self.content:AddChild(self.closeButton)
    
    self.closeButtonText = GUIManager:CreateTextItem() 
    self.closeButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.closeButtonText:SetFontName(GUIMarineClassMenu.kFont)
    self.closeButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.closeButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.closeButtonText:SetText(Locale.ResolveString("EXIT"))
    self.closeButtonText:SetFontIsBold(true)
    self.closeButtonText:SetColor(GUIMarineClassMenu.kCloseButtonColor)
    self.closeButton:AddChild(self.closeButtonText)
    
end

function GUIMarineClassMenu:_UpdateCloseButton(deltaTime)

    if GetIsMouseOver(self, self.closeButton) then
        self.closeButton:SetColor(Color(1, 1, 1, 1))
    else
        self.closeButton:SetColor(Color(0.5, 0.5, 0.5, 1))
    end
    
end

function GUIMarineClassMenu:_UninitializeCloseButton()
    
    GUI.DestroyItem(self.closeButton)
    self.closeButton = nil

end

function GUIMarineClassMenu:_GetResearchInfo(techId)

    local researched = MarineBuy_IsResearched(techId)
    local researchProgress = 0
    local researching = false
    
    if not researched then    
        researchProgress = MarineBuy_GetResearchProgress(techId)        
    end
    
    if not (researchProgress == 0) then
        researching = true
    end
    
    return researched, researchProgress, researching
end

local function HandleItemClicked(self, mouseX, mouseY)

    for i = 1, #self.itemButtons do
    
        local item = self.itemButtons[i]
        if GetIsMouseOver(self, item.Button) then
        
            local researched, researchProgress, researching = self:_GetResearchInfo(item.classType)
            local itemCost = MarineBuy_GetCosts(item.classType)
            local canAfford = PlayerUI_GetPlayerResources() >= itemCost
            local hasItem = PlayerUI_GetHasItem(item.classType)
            
            if researched and canAfford and not hasItem then
				Print("blah %s", tostring(item.classType))

				Client.SendNetworkMessage("ClassBuy", { classType = item.classType } )

                MarineBuy_OnClose()
                
                return true, true
                
            end
            
        end
        
    end
    
    return false, false
    
end

function GUIMarineClassMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false
    
    if key == InputKey.MouseButton0 and self.mousePressed ~= down then
    
        self.mousePressed = down
        
        local mouseX, mouseY = Client.GetCursorPosScreen()
        if down then
        
            inputHandled, closeMenu = HandleItemClicked(self, mouseX, mouseY)
            
            if not inputHandled then
            
                // Check if the close button was pressed.
                if GetIsMouseOver(self, self.closeButton) then
                
                    closeMenu = true
                    MarineBuy_OnClose()
                    
                end
                
            end
            
        end
        
    end
    
    // No matter what, this menu consumes MouseButton0/1.
    if key == InputKey.MouseButton0 or key == InputKey.MouseButton1 then
        inputHandled = true
    end
    
    if InputKey.Escape == key and not down then
    
        closeMenu = true
        inputHandled = true
        MarineBuy_OnClose()
        
    end
    
    if closeMenu then
    
        self.closingMenu = true
        MarineBuy_Close()
        
    end
    
    return inputHandled
    
end