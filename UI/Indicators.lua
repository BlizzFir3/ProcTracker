local addonName, addonTable = ...
local PT = addonTable.PT

local CreateFrame = CreateFrame
local pairs = pairs

PT.UI.Indicators = PT.UI.Indicators or {}

-- Store all initialized frames and their current state
PT.UI.Indicators.frames = {}
PT.UI.Indicators.activeFrames = {}

-- Function to initialize frames dynamically based on the current player's class configuration
function PT.UI.Indicators.Initialize(classProcs)
    -- Ensure the Canvas frame exists
    local parent = PT.UI.Canvas.frame
    if not parent then return end
    
    -- Create frames dynamically based on the configuration
    for spellID, config in pairs(classProcs) do
        local display = CreateFrame("Frame", "ProcTrackerIndicator_" .. spellID, parent)
        display:SetSize(PT.Constants.UI.FRAME_WIDTH, PT.Constants.UI.FRAME_HEIGHT)
        display:SetPoint("CENTER", config.offsetX, config.offsetY)
        
        display.texture = display:CreateTexture(nil, "BACKGROUND")
        display.texture:SetSize(PT.Constants.UI.TEXTURE_WIDTH, PT.Constants.UI.TEXTURE_HEIGHT)
        display.texture:SetPoint("CENTER", 0, 0)
        display.texture:SetTexture(config.texture)
        display.texture:SetBlendMode(PT.Constants.UI.DEFAULT_BLEND)
        
        display.text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        display.text:SetFont(PT.Constants.UI.FONT, PT.Constants.UI.FONT_SIZE, "OUTLINE")
        display.text:SetPoint("CENTER", 0, PT.Constants.UI.TIMER_OFFSET_Y)
        display:Hide()
        
        -- Store the UI element with a default baseline state
        PT.UI.Indicators.frames[spellID] = {
            frame = display,
            text = display.text,
            isActive = false,
            expirationTime = 0
        }
    end
end

-- Update the state of a specific indicator when event logic detects an aura change
function PT.UI.Indicators.UpdateState(spellID, isActive, expirationTime)
    local indicator = PT.UI.Indicators.frames[spellID]
    if not indicator then return end
    
    indicator.isActive = isActive
    indicator.expirationTime = expirationTime or 0
    
    if isActive then
        indicator.frame:Show()
        -- Add to the active pool for the Canvas OnUpdate to process
        PT.UI.Indicators.activeFrames[spellID] = indicator
        -- Wake up the OnUpdate loop if sleeping
        PT.UI.Canvas.CheckAndStartLoop()
    else
        indicator.frame:Hide()
        -- Safely remove from the active pool
        PT.UI.Indicators.activeFrames[spellID] = nil
    end
end
