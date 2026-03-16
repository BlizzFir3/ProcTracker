local addonName, PT = ...

PT.UI = PT.UI or {}

-- Cache global functions
local CreateFrame = CreateFrame
local GetTime = GetTime
local UIParent = UIParent
local print = print
local string = string

-- Création de l'UI (La Vue)
PT.UI.Frame = CreateFrame("Frame", "ProcTrackerCanvas", UIParent)
PT.UI.Frame:SetSize(200, 100)
PT.UI.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
PT.UI.Frame:Hide()

-- Texture Solaire
PT.UI.solarTex = PT.UI.Frame:CreateTexture(nil, "OVERLAY")
PT.UI.solarTex:SetSize(64, 64)
PT.UI.solarTex:SetPoint("CENTER", PT.UI.Frame, "CENTER", -50, 0)
PT.UI.solarTex:SetTexture([[Interface\SpellActivationOverlay\Icon_Druid_Solar]])
-- Fond de couleur garanti pour le debug si la texture Blizzard échoue
PT.UI.solarTex:SetColorTexture(1, 0.8, 0, 0.8)
PT.UI.solarTex:Hide()

-- Texture Lunaire
PT.UI.lunarTex = PT.UI.Frame:CreateTexture(nil, "OVERLAY")
PT.UI.lunarTex:SetSize(64, 64)
PT.UI.lunarTex:SetPoint("CENTER", PT.UI.Frame, "CENTER", 50, 0)
PT.UI.lunarTex:SetTexture([[Interface\SpellActivationOverlay\Icon_Druid_Lunar]])
-- Fond de couleur garanti pour le debug si la texture Blizzard échoue
PT.UI.lunarTex:SetColorTexture(0, 0.8, 1, 0.8)
PT.UI.lunarTex:Hide()

-- Timer Text
PT.UI.Frame.timerText = PT.UI.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
PT.UI.Frame.timerText:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
PT.UI.Frame.timerText:SetPoint("BOTTOM", PT.UI.Frame, "BOTTOM", 0, 0)

-- Le Moteur de Rendu (Le Contrôleur)
local activeExpirationTime = 0

PT.UI.Frame:SetScript("OnUpdate", function(self, elapsed)
    local timeLeft = activeExpirationTime - GetTime()
    if timeLeft > 0 then
        self.timerText:SetText(string.format("%.1f", timeLeft))
    else
        self:Hide() -- Sécurité : coupe l'UI si le temps est écoulé
    end
end)

-- L'API d'entrée (UpdateEclipseState)
function PT.UI.UpdateEclipseState(solarAura, lunarAura)
    -- Log pour le debug du déclenchement
    print("ProcTracker: UpdateEclipseState appelé avec Solaire:", solarAura ~= nil, "Lunaire:", lunarAura ~= nil)

    if solarAura then
        activeExpirationTime = solarAura.expirationTime or 0
        PT.UI.solarTex:Show()
        PT.UI.lunarTex:Hide()
        PT.UI.Frame:Show()
    elseif lunarAura then
        activeExpirationTime = lunarAura.expirationTime or 0
        PT.UI.solarTex:Hide()
        PT.UI.lunarTex:Show()
        PT.UI.Frame:Show()
    else
        -- Aucune aura active
        PT.UI.solarTex:Hide()
        PT.UI.lunarTex:Hide()
        PT.UI.Frame:Hide()
    end
end
