local addonName, addonTable = ...
local PT = addonTable.PT

-- Cache global functions for performance
local CreateFrame = CreateFrame
local GetTime = GetTime
local UIParent = UIParent
local pairs = pairs

PT.UI.Canvas = PT.UI.Canvas or {}

-- Create the main parent frame
local mainFrame = CreateFrame("Frame", "ProcTrackerCanvas", UIParent)
mainFrame:SetSize(300, 150)
mainFrame:SetPoint("CENTER", 0, 150)
mainFrame:Hide() -- Hidden by default so OnUpdate doesn't run needlessly

-- Expose mainFrame to be used by Indicators locally
PT.UI.Canvas.frame = mainFrame

-- Set up the OnUpdate script to refresh the active timers fluidly
mainFrame:SetScript("OnUpdate", function(self, elapsed)
    local currentTime = GetTime()
    local hasActiveProc = false
    
    -- Iterate over the dynamic list of indicators
    if PT.UI.Indicators and PT.UI.Indicators.activeFrames then
        for spellID, indicator in pairs(PT.UI.Indicators.activeFrames) do
            if indicator.isActive then
                local timeLeft = indicator.expirationTime - currentTime
                if timeLeft > 0 then
                    indicator.text:SetFormattedText("%.1f", timeLeft)
                    hasActiveProc = true
                else
                    -- Expiration time reached, securely hide the indicator
                    PT.UI.Indicators.UpdateState(spellID, false, 0)
                end
            end
        end
    end
    
    -- Stop the OnUpdate loop if no procs are active (CPU optimization)
    if not hasActiveProc then
        self:Hide()
    end
end)

-- API exposed to trigger the canvas loop when a new proc is captured
function PT.UI.Canvas.CheckAndStartLoop()
    if not mainFrame:IsShown() then
        mainFrame:Show()
    end
end
