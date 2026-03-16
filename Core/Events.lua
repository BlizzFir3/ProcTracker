local addonName, PT = ...

-- Cache global functions
local CreateFrame = CreateFrame
local C_UnitAuras = C_UnitAuras
local UnitClassBase = UnitClassBase or UnitClass
local pairs = pairs
local type = type
local print = print

PT.Core = PT.Core or {}
PT.Core.Events = PT.Core.Events or {}

local eventsFrame = CreateFrame("Frame")
eventsFrame:RegisterEvent("PLAYER_LOGIN")
eventsFrame:RegisterEvent("UNIT_AURA")

local classConfig = nil

local function UpdatePlayerAuras()
    local solarAura = C_UnitAuras.GetPlayerAuraBySpellID(48517)
    local lunarAura = C_UnitAuras.GetPlayerAuraBySpellID(48518)

    -- Observabilité stricte telle que demandée avant
    if solarAura ~= nil and solarAura.expirationTime then
        print("ProcTracker: Eclipse Solaire active !")
    end
    if lunarAura ~= nil and lunarAura.expirationTime then
        print("ProcTracker: Eclipse Lunaire active !")
    end

    -- Appel vers l'UI avec vérification stricte (Null-safety)
    if PT and PT.UI and type(PT.UI.UpdateEclipseState) == "function" then
        PT.UI.UpdateEclipseState(solarAura, lunarAura)
    else
        print("ProcTracker ERREUR : PT.UI.UpdateEclipseState est introuvable !")
    end
end
if SpellActivationOverlayFrame and SpellActivationOverlayFrame.ShowOverlay then
    hooksecurefunc(SpellActivationOverlayFrame, "ShowOverlay", function(self, spellID, texturePath, position, scale, r, g, b)
        if spellID == 48517 or spellID == 48518 then
            if PT and PT.UI and type(PT.UI.UpdateOverlayAsset) == "function" then
                PT.UI.UpdateOverlayAsset(spellID, texturePath)
            end
        end
    end)
end

eventsFrame:SetScript("OnEvent", function(self, event, unitTarget)
    if event == "PLAYER_LOGIN" then
        local _, classFileName = UnitClassBase("player")
        if PT.Constants and PT.Constants.PROCS then
            classConfig = PT.Constants.PROCS[classFileName]
        end

        if classConfig then
            if PT.UI and PT.UI.Display and type(PT.UI.Display.Initialize) == "function" then
                PT.UI.Display.Initialize(classConfig)
            end
            UpdatePlayerAuras()
        end

    elseif event == "UNIT_AURA" then
        if unitTarget == "player" then
            print("ProcTracker: UNIT_AURA déclenché")
            UpdatePlayerAuras()
        end
    end
end)
