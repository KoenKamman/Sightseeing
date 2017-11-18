local Sightseeing = LibStub("AceAddon-3.0"):NewAddon("Sightseeing", "AceConsole-3.0", "AceEvent-3.0")
local Dragons = LibStub("HereBeDragons-1.0")
local DragonsPins = LibStub("HereBeDragons-Pins-1.0")

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
end

function Sightseeing:OnEnable()
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("WORLD_MAP_UPDATE")
end

function Sightseeing:WORLD_MAP_UPDATE()
    self:Print('map updated')
end

function Sightseeing:ZONE_CHANGED()

    -- create a new pin
	pin = CreateFrame("Button", "--------------------", WorldMapDetailFrame)
	pin:SetWidth(100)
	pin:SetHeight(100)
	pin:SetPoint("CENTER", WorldMapDetailFrame, "CENTER")
    pin.Texture = pin:CreateTexture(nil,"OVERLAY");
    pin.Texture:SetTexture("Interface\\Minimap\\UI-QuestBlob-MinimapRing");
    pin.Texture:SetAllPoints(pin)

    x, y, mapId, level = Dragons:GetPlayerZonePosition()

    DragonsPins:AddWorldMapIconMF("Sightseeing", pin, mapId, level, x, y)
    self:Print(x .. ' ' .. y .. ' ' .. mapId .. ' ' .. level)

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
