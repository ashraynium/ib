# IB Realms — Rojo Prototype

IB Realms is a multiplayer Roblox learning RPG prototype for IB revision. Players choose their own IB subjects, explore themed subject realms, complete quest battles, answer IB-style questions, unlock moves, gain XP/coins, and track weak topics.

## Run with Rojo

1. Open this folder in VS Code.
2. Install/use Rojo.
3. Start the sync server:
   ```bash
   rojo serve
   ```
4. Open Roblox Studio, connect Rojo, and press **Play**.

The project is configured by `default.project.json` and syncs `src/ReplicatedStorage`, `src/ServerScriptService`, and `src/StarterPlayer/StarterPlayerScripts`.

## Prototype includes

- Clean floating **IB Nexus** hub with central plaza, bridges, Dashboard Island, Rank Hall, PvP preview island, Loadout Forge, Category Wing, and Daily Quest Board.
- Subject selection UI that allows any number of subjects.
- Dashboard with rank, XP, coins, accuracy, selected subjects, progress, recommended quests, and weak topics.
- Subject preview UI and campaign-style topic map UI.
- Physical preview zones for System Core, Infinite Tower, Reality Engine, Innovation Forge, Market City, Global Exchange, Biosphere Frontier, and Language World.
- NPCs/terminals using ProximityPrompts.
- Question battle loop with MCQ, text, calculation, scenario, and boss-question-ready architecture.
- Session progress tracking for subjects, answers, mastery tags, weak topics, XP, coins, completed quests, badges, and unlocked moves.
- Loadout preview for starter and boss-unlocked moves.
- Shift-to-sprint and Return Hub UI.

## Not built yet

- Full syllabus coverage.
- Real-time ability combat and animations.
- Ranked PvP / Team Realm Clash / Boss Race gameplay.
- DataStore persistence. `GameConfig.UseDataStores` is currently `false` for Studio-safe session testing.
- Cosmetics, guilds, trading, shops, full bosses, and generated question ingestion tools.

## Add subjects

Edit `src/ReplicatedStorage/IBRealms/Data/SubjectData.lua` and add a subject entry with:

- `Id`, `Base`, `Name`, `Category`, `Realm`, `Level`
- `StarterMove`, `Role`, `Color`, `Description`
- `PreviewCFrame`
- `Topics`

Then add matching questions in `QuestionBank.lua` and a quest in `QuestData.lua`.

## Add questions

Edit `src/ReplicatedStorage/IBRealms/Data/QuestionBank.lua`. Questions support:

- IB command terms
- MCQ, text, calculation, scenario, and boss types
- accepted keywords
- numerical tolerance
- markscheme bullets
- explanation and common misconception feedback
- tags used by mastery and weakness tracking
- XP and damage values

## Add quests

Edit `src/ReplicatedStorage/IBRealms/Data/QuestData.lua`. A quest defines:

- subject base / allowed subject IDs
- realm and NPC
- enemy name/HP
- ordered question IDs
- required correct answers
- XP, coins, progress, moves, and badges

For more detail, see `DESIGN.md`.
