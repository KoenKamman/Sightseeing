Sightseeing = LibStub("AceAddon-3.0"):NewAddon("Sightseeing", "AceConsole-3.0", "AceEvent-3.0")

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

function Sightseeing:OnInitialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Sightseeing", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Sightseeing", "Sightseeing")
    self.optionsFrame.default = function() self:SetDefaultOptions() end;
    self:RegisterChatCommand("sightseeing", "ChatCommand")
    
    Sightseeing.message = "Welcome Home!"
    Sightseeing.showInChat = false
    Sightseeing.showOnScreen = true
    Sightseeing.enabled = true
end

function Sightseeing:OnEnable()
    self:RegisterEvent("ZONE_CHANGED")
end

function Sightseeing:OnDisable()
end

function Sightseeing:ZONE_CHANGED()
    if self.showInChat then
        self:Print(self.message)
    end

    if self.showOnScreen then
        UIErrorsFrame:AddMessage(self.message, 1.0, 1.0, 1.0, 5.0)
    end
end

function Sightseeing:GetMessage(info)
    return self.message
end

function Sightseeing:SetMessage(info, newValue)
    self.message = newValue
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
    return self.showInChat
end

function Sightseeing:ToggleShowInChat(info, value)
    self.showInChat = value
end

function Sightseeing:IsShowOnScreen(info)
    return self.showOnScreen
end

function Sightseeing:ToggleShowOnScreen(info, value)
    self.showOnScreen = value
end

function Sightseeing:SetDefaultOptions()
    Sightseeing.message = "Welcome Home!"
    Sightseeing.showInChat = false
    Sightseeing.showOnScreen = true
    Sightseeing.enabled = true

    LibStub("AceConfigRegistry-3.0"):NotifyChange("Sightseeing");
end;
