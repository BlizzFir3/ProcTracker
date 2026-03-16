local addonName, PT = ...

PT.UI = PT.UI or {}

-- Cache global functions
local CreateFrame = CreateFrame
local GetTime = GetTime
local UIParent = UIParent
local print = print
local string = string
local tonumber = tonumber

-- Paramètres locaux de configuration
local PT_Config_Offset_X = 0
local PT_Config_Offset_Y = 0

-- Création de l'UI (La Vue)
PT.UI.Frame = CreateFrame("Frame", "ProcTrackerCanvas", UIParent)
PT.UI.Frame:SetSize(128, 128)
PT.UI.Frame:Hide()

-- Fonction de mise à jour de la position
local function UpdatePosition()
    PT.UI.Frame:SetPoint("CENTER", UIParent, "CENTER", PT_Config_Offset_X, PT_Config_Offset_Y)
end
UpdatePosition()

-- Texture Solaire
PT.UI.solarTex = PT.UI.Frame:CreateTexture(nil, "OVERLAY")
PT.UI.solarTex:SetAllPoints(PT.UI.Frame)
PT.UI.solarTex:SetTexture([[Interface\SpellActivationOverlay\Icon_Druid_Solar]])
PT.UI.solarTex:SetBlendMode("ADD")
PT.UI.solarTex:Hide()

-- Texture Lunaire
PT.UI.lunarTex = PT.UI.Frame:CreateTexture(nil, "OVERLAY")
PT.UI.lunarTex:SetAllPoints(PT.UI.Frame)
PT.UI.lunarTex:SetTexture([[Interface\SpellActivationOverlay\Icon_Druid_Lunar]])
PT.UI.lunarTex:SetBlendMode("ADD")
PT.UI.lunarTex:Hide()

-- Timer Text
PT.UI.Frame.timerText = PT.UI.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
PT.UI.Frame.timerText:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
PT.UI.Frame.timerText:SetPoint("TOP", PT.UI.Frame, "BOTTOM", 0, -10)
PT.UI.Frame.timerText:SetTextColor(1, 1, 0, 1)

-- Le Moteur de Rendu (Le Contrôleur)
local activeExpirationTime = 0

PT.UI.Frame:SetScript("OnUpdate", function(self, elapsed)
    local timeLeft = activeExpirationTime - GetTime()
    if timeLeft > 0 then
        self.timerText:SetText(string.format("%.1f", timeLeft))
    else
        self.timerText:SetText("")
        self:Hide()
    end
end)

-- L'API d'entrée (UpdateEclipseState)
function PT.UI.UpdateEclipseState(solarAura, lunarAura)
    if solarAura then
        activeExpirationTime = (solarAura.expirationTime and solarAura.expirationTime > 0) and solarAura.expirationTime or (GetTime() + 15)
        PT.UI.solarTex:Show()
        PT.UI.lunarTex:Hide()
        PT.UI.Frame:Show()
    elseif lunarAura then
        activeExpirationTime = (lunarAura.expirationTime and lunarAura.expirationTime > 0) and lunarAura.expirationTime or (GetTime() + 15)
        PT.UI.solarTex:Hide()
        PT.UI.lunarTex:Show()
        PT.UI.Frame:Show()
    else
        -- Aucune aura
        PT.UI.solarTex:Hide()
        PT.UI.lunarTex:Hide()
        PT.UI.timerText:SetText("")
        PT.UI.Frame:Hide()
    end
end

-- Création des Slash Commands
SLASH_PROCTRACKER_X1 = "/ptx"
SlashCmdList["PROCTRACKER_X"] = function(msg)
    local val = tonumber(msg)
    if val then
        PT_Config_Offset_X = val
        UpdatePosition()
        print("ProcTracker: X Offset défini à", PT_Config_Offset_X)
    else
        print("ProcTracker: Erreur d'utilisation (/ptx nombre)")
    end
end

SLASH_PROCTRACKER_Y1 = "/pty"
SlashCmdList["PROCTRACKER_Y"] = function(msg)
    local val = tonumber(msg)
    if val then
        PT_Config_Offset_Y = val
        UpdatePosition()
        print("ProcTracker: Y Offset défini à", PT_Config_Offset_Y)
    else
        print("ProcTracker: Erreur d'utilisation (/pty nombre)")
    end
end
