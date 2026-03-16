local addonName, addonTable = ...
local PT = addonTable.PT

-- Cache global functions
local CreateFrame = CreateFrame
local C_UnitAuras = C_UnitAuras
local UnitClassBase = UnitClassBase or UnitClass
local pairs = pairs

PT.Core.EventBus = PT.Core.EventBus or {}

local eventsFrame = CreateFrame("Frame")
-- Register early events to catch initial state
eventsFrame:RegisterEvent("PLAYER_LOGIN")
eventsFrame:RegisterEvent("UNIT_AURA")

-- Store the active procs configuration for the current localized class
local classConfig = nil

-- Business Logic: Check all configured auras dynamically for the current class
local function UpdatePlayerAuras()
    if not classConfig then return end
    
    -- Iterate through the configured procs and query the new Retail API securely
    for spellID, _ in pairs(classConfig) do
        local auraData = C_UnitAuras.GetAuraDataBySpellID("player", spellID)
        if auraData then
            PT.UI.Indicators.UpdateState(spellID, true, auraData.expirationTime)
        else
            PT.UI.Indicators.UpdateState(spellID, false, 0)
        end
    end
end

-- WoW Global Event Handler
eventsFrame:SetScript("OnEvent", function(self, event, unitTarget)
    if event == "PLAYER_LOGIN" then
        -- Initialize for the specific class once the player is fully loaded into the world
        local _, classFileName = UnitClassBase("player")
        classConfig = PT.Constants.PROCS[classFileName]
        
        if classConfig then
            -- Create the UI elements for this specific class dynamically
            PT.UI.Indicators.Initialize(classConfig)
            -- Run an initial check in case we log in with buffs already active natively
            UpdatePlayerAuras()
        end
        
    elseif event == "UNIT_AURA" then
        -- Only process if the aura change is affecting the player to preserve performance
        if unitTarget == "player" then
            UpdatePlayerAuras()
        end
    end
end)
