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

-- Creation de l'UI (La Vue)
PT.UI.Frame = CreateFrame("Frame", "ProcTrackerCanvas", UIParent)
PT.UI.Frame:SetSize(200, 100)
PT.UI.Frame:Hide()

-- Fonction de mise a jour de la position
local function UpdatePosition()
    PT.UI.Frame:SetPoint("CENTER", UIParent, "CENTER", PT_Config_Offset_X, PT_Config_Offset_Y)
end
UpdatePosition()

-- Texture Solaire
PT.UI.solarTex = PT.UI.Frame:CreateTexture(nil, "OVERLAY")
PT.UI.solarTex:SetSize(200, 200)
PT.UI.solarTex:SetPoint("LEFT", PT.UI.Frame, "CENTER", 50, 0)
PT.UI.solarTex:SetBlendMode("ADD")
PT.UI.solarTex:Hide()

-- Texture Lunaire
PT.UI.lunarTex = PT.UI.Frame:CreateTexture(nil, "OVERLAY")
PT.UI.lunarTex:SetSize(200, 200)
PT.UI.lunarTex:SetPoint("RIGHT", PT.UI.Frame, "CENTER", -50, 0)
PT.UI.lunarTex:SetBlendMode("ADD")
PT.UI.lunarTex:Hide()

-- Timer Text
PT.UI.Frame.timerText = PT.UI.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
PT.UI.Frame.timerText:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
PT.UI.Frame.timerText:SetTextColor(1, 1, 0, 1)
-- Initialement attache au solaire par defaut (sera ecrase par le routeur)
PT.UI.Frame.timerText:SetPoint("TOP", PT.UI.solarTex, "BOTTOM", 0, -10) 

-- Le Moteur de Rendu (Le Controleur)
local activeExpirationTime = 0

PT.UI.Frame:SetScript("OnUpdate", function(self, elapsed)
    local timeLeft = activeExpirationTime - GetTime()
    if timeLeft > 0 then
        self.timerText:SetText(string.format("%.1f", timeLeft))
    else
        self.timerText:SetText("")
    end
end)
function PT.UI.UpdateOverlayAsset(spellID, texturePath)
    local targetTex = (spellID == 48517) and PT.UI.solarTex or PT.UI.lunarTex
    
    -- Nettoyage préalable
    targetTex:SetTexture(nil)
    targetTex:SetAtlas(nil)
    
    -- Application dynamique (Atlas vs Texture)
    if type(texturePath) == "string" and not string.find(string.lower(texturePath), "interface") then
        targetTex:SetAtlas(texturePath)
    else
        targetTex:SetTexture(texturePath)
    end
end

-- L'API d'entree (UpdateEclipseState avec Routage Dynamique)
function PT.UI.UpdateEclipseState(solarAura, lunarAura)
    if solarAura and lunarAura then
        -- Les DEUX sont actives
        PT.UI.solarTex:Show()
        PT.UI.lunarTex:Show()
        
        -- Routage configurable du timer inversé
        if PT.Config.TotalEclipseTimerSide == "LEFT" then
            activeExpirationTime = (lunarAura.expirationTime and lunarAura.expirationTime > 0) and lunarAura.expirationTime or (GetTime() + 15)
            PT.UI.Frame.timerText:ClearAllPoints()
            PT.UI.Frame.timerText:SetPoint("TOP", PT.UI.lunarTex, "BOTTOM", 0, -10)
        else
            activeExpirationTime = (solarAura.expirationTime and solarAura.expirationTime > 0) and solarAura.expirationTime or (GetTime() + 15)
            PT.UI.Frame.timerText:ClearAllPoints()
            PT.UI.Frame.timerText:SetPoint("TOP", PT.UI.solarTex, "BOTTOM", 0, -10)
        end
        PT.UI.Frame:Show()
        
    elseif solarAura then
        -- SEULEMENT Solaire
        activeExpirationTime = (solarAura.expirationTime and solarAura.expirationTime > 0) and solarAura.expirationTime or (GetTime() + 15)
        PT.UI.solarTex:Show()
        PT.UI.lunarTex:Hide()
        PT.UI.Frame.timerText:ClearAllPoints()
        PT.UI.Frame.timerText:SetPoint("TOP", PT.UI.solarTex, "BOTTOM", 0, -10)
        PT.UI.Frame:Show()
        
    elseif lunarAura then
        -- SEULEMENT Lunaire
        activeExpirationTime = (lunarAura.expirationTime and lunarAura.expirationTime > 0) and lunarAura.expirationTime or (GetTime() + 15)
        PT.UI.solarTex:Hide()
        PT.UI.lunarTex:Show()
        PT.UI.Frame.timerText:ClearAllPoints()
        PT.UI.Frame.timerText:SetPoint("TOP", PT.UI.lunarTex, "BOTTOM", 0, -10)
        PT.UI.Frame:Show()
        
    else
        -- AUCUNE aura logic
        PT.UI.solarTex:Hide()
        PT.UI.lunarTex:Hide()
        PT.UI.Frame.timerText:SetText("")
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

-- Configuration du coté du Timer
SLASH_PROCTRACKER_ECLIPSE1 = "/pteclipse"
SlashCmdList["PROCTRACKER_ECLIPSE"] = function(msg)
    if msg == "left" or msg == "right" then
        PT.Config.TotalEclipseTimerSide = msg:upper()
        print("ProcTracker: Côté du timer d'Éclipse Totale configuré sur :", PT.Config.TotalEclipseTimerSide)
    else
        print("ProcTracker: Erreur d'utilisation (/pteclipse left ou /pteclipse right)")
    end
end
