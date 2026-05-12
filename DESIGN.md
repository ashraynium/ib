# IB Realms Design Notes

## Concept

IB Realms is an IB revision RPG for Roblox. The core loop is:

1. Choose IB subjects.
2. Open Dashboard.
3. Pick a recommended quest or realm.
4. Enter a subject preview zone.
5. Talk to an NPC.
6. Answer IB-style learning challenges.
7. Damage enemies and defeat bosses through correct understanding.
8. Earn XP, coins, subject progress, badges, and moves.
9. Return to the IB Nexus and continue.

The game should feel like a polished adventure/RPG where learning unlocks power, not like a plain quiz interface.

## Subjects

Current subjects exclude English and include:

- STEM: Computer Science HL/SL, Maths AA HL, Maths AI SL, Physics HL/SL, Design Technology HL/SL
- Individuals & Societies: Business Management HL/SL, Economics HL/SL, ESS SL
- Languages: Japanese B, French B, Spanish B

Players may choose any number of subjects. Exactly six is not required.

## Hub layout

The hub is the **IB Nexus**, a calm futuristic floating academy.

- Central Nexus Plaza at origin
- Dashboard Island at X = -180
- Rank Hall at X = 180
- PvP Island at Z = -180
- Loadout Forge at Z = 180
- Category Wing at Z = 320
- Daily Quest Board near dashboard/loadout

The build uses flat anchored parts, wide bridges, labelled terminals, and restrained neon accents to avoid random block clutter.

## Realms

- Computer Science: **System Core** — cyber hacking, CPU core, server towers, corrupted routines
- Maths: **Infinite Tower** — geometric tower, graph grids, function gates
- Physics: **Reality Engine** — motion tracks, gravity wells, simulation repairs
- Design Technology: **Innovation Forge** — prototype benches, workshops, materials
- Business: **Market City** — offices, suppliers, strategy cases
- Economics: **Global Exchange** — markets, policy, demand/supply logic
- ESS: **Biosphere Frontier** — systems, conservation, feedback loops
- Languages: **Language World** — vocabulary gates, grammar shrines, dialogue duels

## Learning system

Questions are structured for IB-style revision rather than trivia. Each question can store:

- subject, topic, subtopic, difficulty, target level, command term
- question type: MCQ, Text, Calculation, Scenario, Boss
- prompt, options, answer, accepted keywords, tolerance
- markscheme, explanation, common mistake
- tags, XP, and damage

Feedback always shows correctness, explanation, common mistake, XP gained, and expected keywords for text-style checks.

## Mastery and weaknesses

Every question has tags. Each answer updates per-tag attempts, correct count, mistakes, and a simple mastery score. Low mastery or repeated mistakes become weak topics. The Dashboard displays weak topics, and the future Weakness Dungeon can generate targeted revision from these tags.

## Quest format

Quests connect subject content to RPG battles. A quest stores:

- name, realm, NPC, subject base, allowed subjects
- enemy name and HP
- ordered question pool
- required correct answers
- rewards: XP, coins, subject progress, moves, badges

Computer Science has the deepest first path: Boot Sector, CPU/Memory Repair, Broken Processor Boss, and Binary Vault preview in the topic map.

## Moves and abilities

Moves are unlocked through learning. The final loadout design is four normal moves plus one ultimate. Current prototype shows locked/unlocked move status in the Loadout Forge.

Starter moves:

- CS: Debug Pulse
- Maths: Vector Dash
- Physics: Momentum Push
- Business: Risk Hedge
- Economics: Demand Shift
- ESS: Carbon Sink
- DT: Prototype Shield
- Languages: Vocab Slash

## PvP future

PvP is preview-only in this build. Future modes:

- Arena Duel: 1v1 ranked/casual ability battles
- Team Realm Clash: objective team mode with subject roles
- Boss Race: mirrored dungeons where accuracy, speed, and teamwork matter

Ranked PvP should equalise stats; casual can allow full progression power.

## Persistence

`GameConfig.UseDataStores = false` for Studio-safe session data. The service structure stores selected subjects, progress, mastery, mistakes, quest completion, XP, coins, badges, and moves in a way that can later be wired to DataStores.
