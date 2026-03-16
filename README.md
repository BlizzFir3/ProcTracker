# ProcTracker

**ProcTracker** is a dynamic, fully modular, and highly performant World of Warcraft (Retail) AddOn designed to track class-specific procs, buffs, and auras using custom textures (like Blizzard's default Spell Activation Overlays) and precision countdown timers.

## Features

- **Multi-Class Support**: The core architecture is completely class-agnostic. It detects your current class upon logging in and automatically loads the relevant auras.
- **Dynamic UI Generation**: No hardcoded frames. The UI dynamically loops through configured procs and constructs indicators, textures, and fonts on the fly.
- **Performance Optimized**: 
  - All WoW Global API functions are heavily cached.
  - The `OnUpdate` loop halts entirely when no procs are active, preventing unnecessary CPU drain.
  - Event listening is strictly filtered to only process changes affecting the `"player"` unit.
- **Retail API Compliance**: Exclusively utilizes the modern `C_UnitAuras.GetAuraDataBySpellID` Retail API.

## Installation

1. Download the latest release from the [Releases](#) tab or clone the repository.
2. Extract the `ProcTracker` folder into your World of Warcraft `_retail_\Interface\AddOns` directory:
   ```text
   World of Warcraft\_retail_\Interface\AddOns\ProcTracker
   ```
3. Boot the game and ensure the AddOn is enabled.

## Adding New Procs

The addon makes it effortless to track new abilities or classes without touching any UI or Event logic!

Simply open `Config/Constants.lua` and locate the `PT.Constants.PROCS` table. Add your desired class internal name, the `SpellID` of the proc, your texture path, and positional offsets:

```lua
MAGE = {
    [48108] = { -- Hot Streak Proc Example
        texture = "Interface\\SpellActivationOverlay\\Hot_Streak",
        offsetX = 120,
        offsetY = 0,
    }
}
```

## Architecture

- `Init.lua` - Initializes the global and internal namespace.
- `Config/Constants.lua` - Hosts data tables, SpellIDs, UI dimensions, and texture paths.
- `UI/Canvas.lua` - The master frame that manages the performant `OnUpdate` ticker loop.
- `UI/Indicators.lua` - Dynamically instantiates the textures and FontStrings for tracked procs.
- `Core/EventBus.lua` - Captures `PLAYER_LOGIN` to map the player's class, and intercepts `UNIT_AURA` for background logic checking.
- `Utils/Helpers.lua` - Reusable functions (such as custom colored printing).

## License

This project is licensed under the [MIT License](LICENSE).
