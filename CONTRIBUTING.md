# Contributing to ProcTracker

First off, thank you for considering contributing to **ProcTracker**! We welcome contributions from everyone—whether it's adding new features, fixing bugs, or simply adding configurations for new class procs.

## How to Contribute

### 1. Adding a New Proc or Class Configuration

The most common and helpful contribution is adding standard proc configurations for classes that do not yet have them. 

You **do not** need to edit the core logic to do this. Simply:
1. Fork the repository.
2. Open `Config/Constants.lua`.
3. Add the internal class name (e.g., `WARRIOR`, `PALADIN`, `HUNTER`) into the `PT.Constants.PROCS` table if it doesn't exist.
4. Add the appropriate `SpellID` as a key.
5. Provide the visual rules:
   - `texture`: A path to a WoW texture (preferably existing Spell Activation Overlays).
   - `offsetX` & `offsetY`: Integer values to position the tracker around the center of the screen.
6. Create a Pull Request!

### 2. Reporting Bugs

If you encounter an issue or a Lua error in-game, please open an Issue with:
- The exact version of the addon you are using.
- A copy of the full Lua error report.
- Steps to reproduce the issue.

### 3. Code Contributions

If you want to alter the core UI functionality or the Event Bus logic:
- Ensure you follow the existing modular architecture (Separation of UI canvas, UI generation, Configuration, and Event Listening).
- Cache all Global WoW API functions (e.g., `local C_UnitAuras = _G.C_UnitAuras`).
- Keep all code comments in English.
- Avoid placing any unnecessary load on the `OnUpdate` script located in `Canvas.lua`.

### Pull Request Process

1. Fork the repository and create your feature branch: `git checkout -b feature/my-new-tracker`
2. Commit your changes logically: `git commit -m 'Add tracking for Mage Brain Freeze'`
3. Push to the branch: `git push origin feature/my-new-tracker`
4. Submit a Pull Request.

By contributing to this repository, you agree that your contributions will be licensed under its MIT License.
