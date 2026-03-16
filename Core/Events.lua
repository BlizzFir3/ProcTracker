local addonName, addonTable = ...
local PT = addonTable.PT

-- Cache global functions
local CreateFrame = CreateFrame
local C_UnitAuras = C_UnitAuras
local UnitClassBase = UnitClassBase or UnitClass
local pairs = pairs
local print = print

PT.Core.Events = PT.Core.Events or {}

local eventsFrame = CreateFrame("Frame")
eventsFrame:RegisterEvent("PLAYER_LOGIN")
eventsFrame:RegisterEvent("UNIT_AURA")

local classConfig = nil

local function UpdatePlayerAuras()
    if not classConfig then return end
    
    for spellID, config in pairs(classConfig) do
        local auraData = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
        
        -- Sécurité des données (Null-safety)
        if auraData ~= nil and auraData.expirationTime then
            -- Observabilité (Logging)
            if spellID == 48517 then
                print("ProcTracker: Eclipse Solaire active !")
            elseif spellID == 48518 then
                print("ProcTracker: Eclipse Lunaire active !")
            end
            
            PT.UI.Display.UpdateState(spellID, true, auraData.expirationTime)
        else
            -- L'aura a disparu, on ordonne à l'UI de se cacher
            PT.UI.Display.UpdateState(spellID, false, 0)
        end
    end
end

eventsFrame:SetScript("OnEvent", function(self, event, unitTarget)
    if event == "PLAYER_LOGIN" then
        local _, classFileName = UnitClassBase("player")
        classConfig = PT.Constants.PROCS[classFileName]
        
        if classConfig then
            PT.UI.Display.Initialize(classConfig)
            UpdatePlayerAuras()
        end
        
    elseif event == "UNIT_AURA" then
        if unitTarget == "player" then
            print("ProcTracker: UNIT_AURA déclenché")
            UpdatePlayerAuras()
        end
    end
end)
