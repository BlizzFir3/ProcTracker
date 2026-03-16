-- Cache global functions
local _G = _G

local addonName, addonTable = ...

-- Initialize the addon's global namespace following clean standards
_G.ProcTracker = {
    Config = {},
    Core = {},
    UI = {},
    Utils = {}
}

-- Share in the addonTable for internal and modular access
addonTable.PT = _G.ProcTracker
