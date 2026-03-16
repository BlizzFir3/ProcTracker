local addonName, addonTable = ...
local PT = addonTable.PT

local CreateFrame = CreateFrame
local GetTime = GetTime
local UIParent = UIParent
local pairs = pairs

PT.UI.Display = PT.UI.Display or {}

PT.UI.Display.frames = {}
PT.UI.Display.activeFrames = {}

local mainFrame = CreateFrame("Frame", "ProcTrackerCanvas", UIParent)
mainFrame:SetSize(300, 150)
mainFrame:SetPoint("CENTER", 0, 150)
mainFrame:Hide()

PT.UI.Display.frame = mainFrame

mainFrame:SetScript("OnUpdate", function(self, elapsed)
    local currentTime = GetTime()
    local hasActiveProc = false
    
    for spellID, indicator in pairs(PT.UI.Display.activeFrames) do
        if indicator.isActive then
            local timeLeft = indicator.expirationTime - currentTime
            if timeLeft > 0 then
                indicator.text:SetFormattedText("%.1f", timeLeft)
                hasActiveProc = true
            else
                PT.UI.Display.UpdateState(spellID, false, 0)
            end
        end
    end
    
    if not hasActiveProc then
        self:Hide()
    end
end)

function PT.UI.Display.CheckAndStartLoop()
    if not mainFrame:IsShown() then
        mainFrame:Show()
    end
end

function PT.UI.Display.Initialize(classProcs)
    for spellID, config in pairs(classProcs) do
        local display = CreateFrame("Frame", "ProcTrackerIndicator_" .. spellID, mainFrame)
        display:SetSize(128, 128)
        
        if spellID == 48517 then -- Eclipse Solaire
            display:SetPoint("CENTER", UIParent, "CENTER", -150, 0)
        elseif spellID == 48518 then -- Eclipse Lunaire
            display:SetPoint("CENTER", UIParent, "CENTER", 150, 0)
        else
            display:SetPoint("CENTER", UIParent, "CENTER", config.offsetX, config.offsetY)
        end
        
        display.texture = display:CreateTexture(nil, "BACKGROUND")
        display.texture:SetSize(128, 128)
        display.texture:SetPoint("CENTER", 0, 0)
        display.texture:SetTexture(config.texture)
        display.texture:SetBlendMode("ADD")
        
        display.text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        display.text:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
        display.text:SetPoint("CENTER", 0, -40)
        display:Hide()
        
        PT.UI.Display.frames[spellID] = {
            frame = display,
            text = display.text,
            isActive = false,
            expirationTime = 0
        }
    end
end

function PT.UI.Display.UpdateState(spellID, isActive, expirationTime)
    local indicator = PT.UI.Display.frames[spellID]
    if not indicator then return end
    
    indicator.isActive = isActive
    indicator.expirationTime = expirationTime or 0
    
    if isActive then
        indicator.frame:Show()
        PT.UI.Display.activeFrames[spellID] = indicator
        PT.UI.Display.CheckAndStartLoop()
    else
        indicator.frame:Hide()
        PT.UI.Display.activeFrames[spellID] = nil
    end
end
