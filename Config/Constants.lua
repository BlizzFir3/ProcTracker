local addonName, PT = ...
PT.Config = PT.Config or {}
PT.Config.TotalEclipseTimerSide = "LEFT"
PT.Constants = {
    UI = {
        FRAME_WIDTH = 120,
        FRAME_HEIGHT = 120,
        TEXTURE_WIDTH = 120,
        TEXTURE_HEIGHT = 120,
        FONT = "Fonts\\FRIZQT__.TTF",
        FONT_SIZE = 18,
        TIMER_OFFSET_Y = -40,
        DEFAULT_BLEND = "ADD",
    },
    
    -- Define procs dynamically per class
    -- The keys represent the standard WoW class internal names (e.g., DRUID, MAGE, WARRIOR)
    PROCS = {
        DRUID = {
            -- Solar Eclipse
            [48517] = {
                texture = "Interface\\SpellActivationOverlay\\Eclipse_Sun",
                offsetX = -120,
                offsetY = 0,
            },
            -- Lunar Eclipse
            [48518] = {
                texture = "Interface\\SpellActivationOverlay\\Eclipse_Moon",
                offsetX = 120,
                offsetY = 0,
            },
        },
        -- Future classes can be safely configured here
        -- MAGE = { ... },
        -- WARRIOR = { ... },
    }
}
