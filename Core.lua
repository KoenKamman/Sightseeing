local Sightseeing = LibStub("AceAddon-3.0"):NewAddon("Sightseeing", "AceConsole-3.0", "AceEvent-3.0")
local HBD = LibStub("HereBeDragons-1.0")
local HBDPins = LibStub("HereBeDragons-Pins-1.0")

local ViewPoints = {}

local options = {
    name = "Sightseeing",
    handler = Sightseeing,
    type = "group",
    args = {
        msg = {
            type = "input",
            width = "full",
            name = "Message",
            desc = "The message to be displayed when you change zones.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            width = "full",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            width = "full",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen"
        }
    }
}

local defaults = {
    profile = {
        message = "Welcome Home!",
        showInChat = false,
        showOnScreen = true,
    },
}

function Sightseeing:SetDefaultOptions()
    Sightseeing.db.profile.message = defaults.profile.message
    Sightseeing.db.profile.showInChat = defaults.profile.showInChat
    Sightseeing.db.profile.showOnScreen = defaults.profile.showOnScreen

    LibStub("AceConfigRegistry-3.0"):NotifyChange("Sightseeing");
end;

function Sightseeing:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SightseeingDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Sightseeing", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Sightseeing", "Sightseeing")
    self.optionsFrame.default = function() self:SetDefaultOptions() end;
    self:RegisterChatCommand("sightseeing", "ChatCommand")


    -- Add markers at azuremyst isle & ammen vale for debugging
    local ViewPoint1 = {}
    local ViewPoint2 = {}

    ViewPoint1.x = 0.5
    ViewPoint1.y = 0.5
    ViewPoint1.mapId = 894
    ViewPoint1.level = 0

    ViewPoint2.x = 0.8
    ViewPoint2.y = 0.8
    ViewPoint2.mapId = 464
    ViewPoint2.level = 0

    table.insert(ViewPoints, ViewPoint1)
    table.insert(ViewPoints, ViewPoint2)

end

function Sightseeing:OnEnable()
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("WORLD_MAP_UPDATE")
end

function Sightseeing:CreateMapIcon()

    icon = CreateFrame("Button", "MapIcon", WorldMapDetailFrame)
    icon:SetWidth(100)
    icon:SetHeight(100)
    icon:SetPoint("CENTER", WorldMapDetailFrame, "CENTER")

    icon.Texture = Icon:CreateTexture(nil,"OVERLAY");
    icon.Texture:SetTexture("Interface\\Minimap\\UI-QuestBlob-MinimapRing");
    icon.Texture:SetAllPoints(icon)
    
    return icon
end

function Sightseeing:WORLD_MAP_UPDATE()

    local x, y, currentMapId, level = HBD:GetPlayerZonePosition()

    if not WorldMapDetailFrame:IsVisible() then 
        return 
    end

    local areaID = GetCurrentMapAreaID()

    HBDPins:RemoveAllWorldMapIcons("Sightseeing")
    self:Print('Removing all icons.')

    for index, vp in ipairs(ViewPoints) do
        if vp.mapId == areaID then
            local icon = self:CreateMapIcon()
            HBDPins:AddWorldMapIconMF("Sightseeing", icon, vp.mapId, vp.level, vp.x, vp.y)
            self:Print('ViewPoint created!')
        end
    end

end

function Sightseeing:ZONE_CHANGED()

    if self.db.profile.showInChat then
        self:Print(self.db.profile.message)
    end

    if self.db.profile.showOnScreen then
        UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
    end

end

function Sightseeing:GetMessage(info)
    return self.db.profile.message
end

function Sightseeing:SetMessage(info, newValue)
    self.db.profile.message = newValue
end

function Sightseeing:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("Sightseeing", "Sightseeing", input)
    end
end

function Sightseeing:IsShowInChat(info)
    return self.db.profile.showInChat
end

function Sightseeing:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function Sightseeing:IsShowOnScreen(info)
    return self.db.profile.showOnScreen
end

function Sightseeing:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end
