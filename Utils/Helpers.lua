local addonName, addonTable = ...
local PT = addonTable.PT

PT.Utils = PT.Utils or {}

-- Cache global printing function
local print = print

-- Simple debug print wrapper localized for ProcTracker
function PT.Utils.Print(...)
    print("|cFF00FF00[ProcTracker]|r", ...)
end
