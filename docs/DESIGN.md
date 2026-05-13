# IB Realms Design and Architecture

## Vision

IB Realms is a multiplayer educational RPG for IB revision. The core promise is that academic progress should feel like a real Roblox adventure: players build a profile, choose their actual subjects, enter themed realms, complete learning quests, defeat topic enemies, unlock subject abilities, track mastery, and eventually use those abilities in PvE and PvP.

The current full-foundation build proves three things:

1. The hub and UI can feel coherent and premium, not like a random quiz lobby.
2. The learning loop can teach, check, apply, and give useful feedback.
3. The data architecture can scale to thousands of original questions, quests, and future subjects.

## World structure

The central hub is the **IB Nexus**, a floating cosmic academy with a readable layout:

- Central plaza with spawn pad, Nexus Core, Nexus Mentor, quick subject preview pads, and Dashboard access.
- Dashboard Island with Dashboard and IB Profile terminals.
- Rank Hall with Rank Keeper and board preview.
- PvP Island with coming-soon gates for Arena Duel, Team Realm Clash, and Boss Race.
- Loadout Forge with Loadout Engineer and move preview stands.
- Category Wing with STEM Realms, Individuals and Societies, and Language World portals.
- Daily Quest Island with a board and Quest Clerk.
- Physical preview zones for every subject realm identity.

Geometry uses flat anchored parts, wide bridges, clear labels, moderate neon trim, and safe teleport positions.

## Educational architecture

`CurriculumData` defines the full topic-level campaign scope, memory anchors, enemy ladders, and revision intent for every included topic. Questions are not hard-coded into quests or UI. They live in `QuestionPacks`, are registered through `QuestionBank`, and are selected by `QuestionService` using filters.

Every question can store:

- source note reference
- subject base and subject IDs
- topic and subtopic
- learning objective
- difficulty
- command term
- question type
- prompt and options
- accepted answers and accepted keywords
- markscheme points
- explanation
- common mistake feedback
- tags
- XP and damage values
- mastery impact

This supports recognition, understanding, application, analysis, and boss-level synthesis while making future import tooling straightforward.

## Quest architecture

Quests are data-driven and contain briefing text, NPC giver, objective, enemy, HP/focus settings, question filters, rewards, unlocks, and completion dialogue. In addition to curated intro and demo quests, `QuestData` generates route and boss quests for every topic in every included subject. Normal quests pull from question pools; boss quests filter for higher difficulty and can later use fixed curated question IDs.

The Computer Science demo chain is deeper than the other subject intros:

1. Boot Sector: hardware basics.
2. CPU Core: bottleneck application.
3. Broken Processor boss: explanation and evaluation.
4. Binary Vault preview: data representation preview.

Other subjects each have one intro quest so the whole product shape is visible.

## Progress architecture

`ProgressService` owns session profile state. The current profile includes onboarding, selected subjects, main subject, XP, coins, level, rank, accuracy, subject progress, quests, mastery, mistakes, moves, badges, tokens, active quest, current subject, and stats.

`GameConfig.UseDataStores` is false so Studio testing does not trigger DataStore errors. The service is shaped so persistence can be added later without changing client UI contracts.

## Battle architecture

The first battle system is question-based:

- Start quest.
- Show enemy and question.
- Correct answers damage the enemy.
- Wrong answers reduce focus and log a weak topic.
- Feedback explains the concept and common mistake.
- Completion grants XP, coins, moves, badges, tokens, and quest unlocks.

Future real-time PvE should keep educational feedback central while adding ability buttons, cooldowns, dodging, hitboxes, projectiles, energy, and team utility.

## Client/server split

- Server owns world generation, profile state, quest state, answer checking, rewards, and teleport authority.
- Client owns HUD, onboarding, dashboard, subject preview, topic map, loadout/rank screens, battle UI, prompt handling, notifications, and sprint input.
- Remotes provide narrow API calls: get profile, update subjects, start quest, answer question, teleport request, and notifications.

## PvP direction

`PvPModeData` now scaffolds the intended PvP modes and their stat rules. Matchmaking, arenas, and real-time combat execution are still later production work. Learning should unlock abilities, and PvP should use those abilities in real combat rather than quiz duels.

Future modes:

- Arena Duel: first 1v1 mode; ranked should equalise stats.
- Team Realm Clash: objective control-point mode.
- Boss Race: mirrored dungeon race with fewer mistakes rewarded.

## Iteration priorities

Next milestones:

1. Replace block NPCs with styled models.
2. Expand Computer Science content and add more original questions.
3. Add question import tooling from CSV/JSON.
4. Add real ability buttons in PvE.
5. Add animated portals and better realm entrances.
6. Implement DataStores after publishing.
7. Add Rank Hall leaderboards.
8. Prototype Arena Duel.
9. Add cosmetics and badges.

## Full-version expansion added after full-build feedback

The project now includes a full campaign scaffold rather than only starter quests: `CurriculumData` gives every topic a learning scope, memory anchor, and enemies; `QuestData` generates route and boss quests for every subject/topic combination; `FullCurriculumQuestions` adds higher-difficulty original questions across subjects; `MoveData` now includes a broader cross-category ability library; `DailyQuestData` defines repeatable mission templates, and `PvPModeData`/`CosmeticData` define future progression surfaces without hard-coding them into UI.
