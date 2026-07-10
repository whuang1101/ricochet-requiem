# RICOCHET REQUIEM — Game Design Document (v2)

**One-liner:** An arena action roguelite where your shots only hurt after they
bounce — every room is a killing floor of angles, and you are the only thing
in it that can't be shot directly.

**Genre:** Top-down arena action roguelite · **Players:** 1 (drop-in 2P co-op
post-launch) · **Engine:** Godot 4 · **Target:** Steam, $5.99–7.99 ·
**Session:** 20–30 min runs · **Inspirations:** the aiming of pool/carom
billiards, the room-clear cadence of *Hades*, the push-forward aggression of
*ULTRAKILL*, the readability of *Nuclear Throne*, the one-rule purity of
*Downwell*.

> **v2 changes (fun/addiction pass):** added Tuning (dead slugs are no longer
> wasted shots), Resonance healing (aggression = survival), Flourish
> multi-kill rewards, Requiem decay + banking, Encore perfect-room boons,
> instant restart doctrine, Dissonance heat system, and §11 — a complete
> implementation handoff for an autonomous coding agent.

---

## 0. Lessons carried from Stray Signal (why this one instead)

The previous prototype died for one reason: **the player's direct verb was
weak** — you moved and dodged while an autonomous weapon had all the fun.
Design laws for this project, non-negotiable:

1. **The core verb must be fun in an empty gray room.** If firing one bounce
   shot into two dummies doesn't feel great by prototype day 3, kill or fix
   the verb before building anything else.
2. **The player causes every kill.** No auto-fire, no companion, no idle DPS.
   Every death on screen traces back to a decision the player aimed.
3. **Systems may be deep, but the first 10 seconds must be legible:**
   "my bullets only work after they bounce" is one sentence, demonstrated by
   the first shot fired.
4. **Never punish with boredom.** Death → back in action in under 2 seconds.
   No unskippable anything, ever.
5. Prototype gate before content: playtest the core loop, honestly answer
   "did I want one more room?" — only then build the roguelite shell.

## 1. The Hook

Your gun fires **dead rounds** — inert slugs that pass straight through
enemies. The moment a round strikes a wall it goes **live**: it ignites,
accelerates, and kills. Every bounce after the first makes it stronger.

Three consequences fall out of one rule, and they ARE the game:

- **Aiming is thinking.** You never point at the target; you point at the
  geometry that will deliver the target. Every room is a puzzle you solve at
  200 mph while being chased.
- **Walls are ammunition.** Cover, corridors, pillars — the arena is not the
  backdrop of the fight, it's your weapon.
- **Point-blank is the danger zone, for both sides.** Enemies hug open space
  to starve your angles; you herd them toward geometry.

**Fantasy:** you are a trick-shot god in a world where the straight line is a
lie. The power fantasy moment is a triple-bank shot threading three enemies —
and the game is built so that happens by intent, not luck.

## 2. Core mechanics

### 2.1 The shot
- Slug fires straight, visible tracer. **Dead** (gray, harmless-to-kill)
  until first wall contact → **live** (ignited, colored, lethal, +15% speed).
- Each subsequent bounce: +1 damage tier, brighter color, higher-pitched
  ping — bounce 3+ shots scream across the room. Cap at 5 bounces, then the
  slug detonates (small AoE) wherever it is.
- Slugs live ~2.5s. Max ~4 of the player's slugs alive at once.
- **Friendly ricochet:** live slugs CAN hit you at **25% damage** (v1 said
  50% — too punishing; the threat only needs to exist to make shots feel
  consequential). *Purist* toggle: 100% self-damage for a 1.5× score
  multiplier. *Assist* toggle: off entirely, no penalty shaming.

### 2.2 Tuning — dead slugs are setup, not waste  **(v2, core)**
A dead slug passing **through** an enemy *tunes* it for 2.5s: the enemy
hums, glows faintly, and takes **+1 damage tier** from the next live hit.

Why this is the most important v2 change:
- The naive instinct (aim straight at the enemy) is no longer a dead input —
  it's the *first half of the correct play*. Fire through the Mirrorback at
  the wall behind it; the same slug comes back tuned-target-ready. Every
  shot is now a two-part decision: what do I pass through, what do I bounce
  off. Depth went up AND the frustration floor went down.
- It creates the game's skill-signature: lining up enemy + wall in one ray.

### 2.3 Resonance healing — aggression is survival  **(v2, core)**
There are **no health drops**. Kills with bounce-2+ slugs shatter into
**resonance notes** (health pickups, 8s lifetime) — and they spawn *at the
kill*, in the thick of the fight. Turtling starves you; diving after your
own trick-shots feeds you. This is the push-forward engine (*ULTRAKILL*'s
blood-heal lesson) and it single-handedly prevents the corner-camping
degenerate strategy that plagues arena games.

### 2.4 Aiming assist that preserves skill
- Holding aim shows the first bounce's reflection line only (a short stub,
  not the full path). Upgrades can lengthen the preview; a "pro" option
  hides it. You always see enough to learn, never enough to stop thinking.

### 2.5 Movement
- Fast strafe run + a short **shoulder-slam dash** that staggers enemies and
  nudges movable pillars (repositioning cover is a combat verb). Dash has
  i-frames; 0.8s cooldown.
- No reload; fire rate limited (~2.5/s). The constraint is angles, not ammo.

### 2.6 The Requiem meter (signature system)
Every bounce a slug takes before killing adds a note to the **Requiem** —
kill on bounce 1 = 1 note, a bounce-4 kill = 4 notes; tuned kills +1 note.
The meter is a rising musical phrase (audible: each bounce pings a scale
tone).

- **Decay (v2):** notes drain slowly (1 note / 3s) while no scoring occurs.
  The Requiem is a tempo, not a bank account — it pushes you into the next
  shot. Decay pauses between rooms.
- **Cadenza:** at a full phrase (12 notes), press Q: time dilates to 20%
  for 3 seconds while you aim and fire freely.
- **Banking (v2):** or *don't* press Q — hold past 12 toward 24 for a
  **Grand Cadenza** (5s + every live slug on screen detonates on exit).
  Risk: decay, and taking a hit above 12 drops you back to 12. A permanent
  little greed decision humming under all combat.

### 2.7 Flourish — the multi-kill celebration  **(v2)**
One slug killing 2+ enemies is a **Flourish**: 0.12s hit-stop, ink-splash
freeze-frame, +Motifs (meta currency) per extra kill, and the bounce-pitch
chord resolves. Flourishes are tracked on the run summary ("Best Flourish:
×4"). Cheap to build, and it aims the player's ambition at the exact thing
that makes the game fun to watch and share.

### 2.8 Encore — perfect-room boon  **(v2)**
Clear a room untouched → the exit door offers an **Encore**: pick 1 of 2
micro-boons (e.g. +5 max HP, +0.2s slug lifetime, 1 free reroll). Small
enough to lose without tilt, real enough to chase. Turns "no-hit" from
self-imposed challenge into a visible carrot every single room.

## 3. Enemies (all designs are angle problems, not stat blocks)

| Enemy | Threat | The angle problem it poses |
|---|---|---|
| **Chorister** (basic) | Slow chase, melee | Fodder that clumps — teaches multi-kill banks |
| **Sidler** | Strafes to keep walls out of your firing solutions | Forces repositioning or dash-slamming pillars |
| **Mirrorback** | Front shield REFLECTS your live slugs | Hit from behind — or tune it through the shield (dead slugs pass!) then bank one home |
| **Wailer** | Ranged; its shots are also bounce-shots | Shared pinball table; stand where its slug dies |
| **Mason** | Builds new wall segments | It's making cover for its team — and ammunition for you |
| **Bellringer** (elite) | Slam that shakes slugs dead mid-flight | A tempo problem: shoot between its slams |
| **Cantor** (miniboss) | Sings enemies into formation | The formation IS the Flourish opportunity |

Bosses (one per act, 3 acts): arena-transformation fights — Act 1's
**Organist** periodically rearranges walls into organ-pipe verticals,
resetting your learned angles mid-fight.

## 4. Arenas

- **Room-based** (Stray Signal's open void was a mistake — angles need
  walls). 8–12 rooms per act, 45–90s each, doors lock, clear to proceed,
  choose next room from 2 doors (icons show reward type).
- Rooms are **hand-authored templates with procedural dressing** (pillar
  positions jitter, hazards vary). Authored geometry makes bank shots
  learnable; full procgen makes them noise. 40 templates/act goal, 15 at
  demo.
- **Act themes change wall physics:**
  - Act 1 *The Nave*: stone — standard bounces.
  - Act 2 *The Foundry*: metal — slugs go live at +1 tier immediately, but
    molten channels kill slugs.
  - Act 3 *The Choir Loft*: glass — some walls shatter after one bounce
    (single-use ammunition; rooms degrade as you fight).
- Interactive geometry: bells that deflect at random angles when rung,
  rotating pillars, portcullises the player can drop.

## 5. Roguelite structure

### 5.1 In-run build: Trick Cards
Every room reward offers 1-of-3 **Trick Cards** modifying the shot rule:
- *Split Chime:* on bounce 2, slug splits in two at ±20°.
- *Dead Weight:* dead slugs knock enemies back (herding — and pushes them
  into your live slugs' paths).
- *Long Echo:* +2 bounce cap, +1s slug lifetime.
- *Sanctified Floor:* dash leaves a 2s wall of light (your dash becomes
  ammunition).
- *Last Note:* Cadenza exit detonates every live slug on screen.
- *Sympathetic String* (v2): tuned enemies chain — killing one live-hits
  every other tuned enemy for tier-1.
- ~35 cards at launch; rarity tiers; boss rooms offer rare-or-better; they
  must combo (Split Chime + Long Echo = screen-filling finale).

### 5.2 First decision at second zero  **(v2)**
A run *starts* with a Trick Card choice (1 of 3) before room 1. Build
identity exists from the first shot, restarts feel different immediately,
and "one more run" costs nothing to evaluate.

### 5.3 Meta-progression
- **The Scorebook:** permanent currency (**Motifs** — earned per room,
  bonus from Flourishes/Encores) unlocks new Trick Cards into the pool,
  alternate guns, starting boons. Power creep mild; the meta unlock is
  *variety*.
- **Alternate guns** change the verb's flavor, never the rule: *Fanfare*
  (3-slug fan, short range), *Tuba* (huge slow slug, +1 tier/bounce, max 2
  alive), *Metronome* (fires on the beat; on-beat shots start tuned).
- **Dissonance** (v2 heat system): after first win, stack named modifiers
  for multiplied Motifs (enemies fire on death, decay doubled, glass
  everywhere…). Each Dissonance tier is a leaderboard bracket.
- **Daily seed** (fixed run, one attempt) and **weekly mutator** (rule
  twist, e.g. "all walls are metal") with leaderboards. Score = total
  Requiem notes — style IS score.

### 5.4 Run shape & flow doctrine
3 acts × ~10 rooms + boss ≈ 25 minutes. Death → stats card (2 lines +
Best Flourish) → **[R] instantly seeds a new run** — under 2 seconds from
death to aiming again, enforced as a perf budget. Motifs always kept. One
mid-act "confessional" room per act: heal OR bank Motifs OR reroll a card —
never all three.

## 6. Co-op (post-launch update, designed-for now)
- 2P drop-in. Partner slugs interact: two live slugs colliding **fuse**
  into a heavy round (bounce counts sum). Reviving = standing in the down
  partner's aura while it charges — holding a corner: an angle problem.
- Friendly ricochet between partners at 25%. Chaos is the clip generator.
- Architecture prep in solo build: all shooting flows through a `Shooter`
  component; nothing may assume a single player node (see §12).

## 7. Presentation

- **Look:** ink-and-stained-glass. Dark parchment floors, walls as thick
  leaded lines, slugs as calligraphy strokes with light trails; a bounce-3+
  kill crystallizes the trail into stained glass for a beat. Two colors per
  act + white. Achievable solo, screenshots distinctively.
- **Audio is a mechanic:** bounces play scale tones (per-act mode/key); the
  Requiem meter is the soundtrack assembling itself; Cadenza is the phrase
  resolving; a Flourish resolves a chord. Base loop sparse — the player's
  play is the melody. Real composer for ship; synth for prototype.
- **Game-feel non-negotiables checklist** (v2 — build these WITH the verb,
  not after; each is ≤30 min of work):
  - screen shake on live-slug kill (trauma-based, from Stray Signal)
  - 0.12s hit-stop on Flourish; 0.05s on any bounce-3+ kill
  - slug trails (Line2D history) — dead gray, live per-tier color ramp
  - bounce ping pitch ladder (one scale, degrees = bounce count)
  - kill = ink burst + brief white flash on the corpse
  - muzzle nudge: tiny player knockback opposite to fire direction
  - controller rumble on bounce 3+ (if pad present)
- Deaths burst into ink; no gore; streams clean.

## 8. Scope & milestones

| Phase | Deliverable | Gate |
|---|---|---|
| **P0 · 2 weeks** | Gray-box: move/dash/shoot, bounce+tuning+resonance rules, Requiem with synth tones, 3 enemies, 5 authored rooms, instant restart, feel checklist | "One more room?" — external testers say yes or the verb gets reworked |
| **P1 · 6 weeks** | Act 1 complete: 15 rooms, 6 enemies, Organist boss, 15 Trick Cards, Encore/Flourish, ink art pass v1 | Next Fest demo candidate |
| **P2 · 8 weeks** | Acts 2–3, Scorebook, alt guns, Dissonance, daily seed | EA / launch decision |
| **P3** | Co-op update, room template expansion | post-launch |

Guardrails: no procgen rooms (templates only), 3 acts not 5, co-op is
post-launch or never, no system that adds a second rule to the shot.

## 9. Risks & honest questions

1. **Aiming may frustrate average players.** Mitigations now built into the
   rules: Tuning makes straight shots useful, bounce preview, generous slug
   width, fodder that dies to sloppy banks. Skill ceiling lives in Requiem
   scoring, not baseline survival.
2. **Rule purity vs. content breadth** — every card/gun must modify the ONE
   rule. Litmus test for any addition: "does this change what bouncing
   means?" If no, cut it.
3. **Room authoring is the real cost.** Build the room-testing mode (spawn
   wave X in room Y from CLI) in P0, not later — it doubles as the test
   harness.
4. **No proven audience for the exact mechanic** — that's the pitch
   strength and the risk. The P0 gate answers it for ~zero cost.

## 10. Steam positioning

- Capsule: calligraphy slug mid-triple-bank, stained-glass shatter.
- Tags: Action Roguelike, Bullet Hell, Top-Down Shooter, Difficult, Stylized.
- Trailer beat: one unbroken 15s shot — tune two enemies through a straight
  line, bank the same slug twice, Grand Cadenza detonation, Flourish ×4
  freeze-frame, music assembling from the bounces. Cut. Title. **"Never
  shoot straight."**
- Demo: Act 1, 8 rooms, daily seed enabled (leaderboards drive wishlists).

---

## 11. IMPLEMENTATION HANDOFF (for an autonomous coding agent)

Everything below is prescriptive. Where this section conflicts with taste,
follow this section; where a gameplay number feels wrong in playtesting,
change it in `balance.gd` and note it in the commit message.

### 11.1 Project conventions
- Godot 4.x, GL Compatibility renderer, 1280×720 base, `canvas_items`
  stretch + `keep` aspect (fullscreen F11/Cmd+F — port from Stray Signal
  `main.gd::toggle_fullscreen`).
- GDScript, typed where inference fails. Snake_case files, one class per
  file. Signals over polling. No autoload except `Balance`, `SFX`, `Game`.
- **All tunables live in `scripts/balance.gd`** (constants only — speeds,
  timers, damage tiers, decay rates, spawn tables). No magic numbers in
  gameplay scripts. This is the single most important convention: tuning
  the game must never require hunting through files.
- Reuse from `~/repos/stray-signal` (copy, don't depend): `sfx.gd`
  (procedural synth — extend with a `scale_tone(degree)` helper),
  `camera_shake.gd`, `fx.gd` (burst/ghost/freeze), `save_data.gd`
  (incl. the `readonly` test flag), fullscreen toggle.

### 11.2 Scene/node architecture
```
Main (run orchestrator: room flow, doors, rewards, run state)
├─ RoomHost (Node2D — current room instance swapped in/out)
│   └─ rooms/room_*.tscn (TileMap walls + Marker2D spawn points + doors)
├─ Player (CharacterBody2D, groups: ["player"])
│   ├─ Shooter (Node — ALL firing logic; co-op = N Shooters later)
│   ├─ Camera2D (camera_shake.gd)
├─ Requiem (Node — meter state; signals: note_added, cadenza_ready,
│            cadenza_started/ended, decayed)
├─ Deck (Node — trick card state; applies card effects as flags/multipliers
│         on Shooter/Slug via a single `modifiers` Dictionary)
├─ HUD (CanvasLayer)
└─ SFX / Game / Balance (autoloads)
```
- `Slug` (`slug.gd`, CharacterBody2D or Area2D + manual move): state enum
  DEAD/LIVE, `tier` int, `bounces` int. Movement via `move_and_collide`;
  on wall collision: `velocity = velocity.bounce(normal)`, tier++, emit
  `bounced(tier, position)`. Dead slugs use a separate collision mask that
  overlaps enemies WITHOUT colliding (Area2D overlap → apply Tuning).
- Enemies extend a base `enemy.gd` (kind-parameterized like Stray Signal's,
  which worked well) — but Mirrorback's reflect and Mason's wall-building
  get their own scripts; don't force everything through one match statement
  past 5 kinds.
- Rooms: each template is a scene with a `RoomDef` root script exporting
  `spawn_waves: Array` and `reward_type`. Main instantiates, connects
  `cleared`, unlocks doors.

### 11.3 Build order (each step ends with the listed test passing)

1. **Slug physics + gray room.** Player move/dash/aim/fire; slug
   dead→live→tiers→detonate; bounce preview stub. *Test:* headless sim
   fires 100 slugs at random angles in a box room; assert every slug either
   detonated at tier 5 or expired; assert 0 tunneling through walls (ray
   margin). Manual: does it feel good? (the P0 gate).
2. **Three enemies + damage.** Chorister, Sidler, Wailer; Tuning
   pass-through; Resonance notes; friendly ricochet at 25%. *Test:* sim
   spawns each kind, fires scripted bank shots, asserts kills happen only
   from LIVE slugs, tuned kills take tier+1, resonance notes spawn on
   bounce-2+ kills only.
3. **Requiem + Cadenza + feel checklist.** Meter, decay, banking, Q slow-mo,
   every §7 feel item. *Test:* sim asserts note math (bounce-3 kill = 3
   notes, decay 1/3s, hit above 12 → 12); manual feel pass.
4. **Rooms + doors + flow.** 5 templates, wave spawning, clear→doors→next
   room, instant restart (measure: reload-to-input < 2s). *Test:* sim
   clears 3 rooms end-to-end via scripted play.
5. **Trick Cards (8) + run-start pick + Flourish + Encore.** Card effects
   via `Deck.modifiers`; run summary screen. *Test:* per-card sim asserting
   its observable effect (Split Chime → 2 slugs exist post-bounce-2, etc.).
6. **Act 1 content fill.** 15 rooms, 6 enemies, Organist, 15 cards, boss
   reward. *Test:* full-act sim (state-driven phases, NOT frame counts —
   headless runs uncapped).
7. **Meta.** Scorebook/Motifs (SaveData), alt gun #1, daily seed
   (`seed(hash(date))`), Dissonance tier 1–3.

### 11.4 Testing doctrine (carried from Stray Signal, hardened)
- `tests/sim_play.gd` pattern: `extends SceneTree`, inject input via
  `Input.action_press`, advance on **observed state** (never frame counts —
  headless runs uncapped). `SaveData.readonly = true` in every sim.
- Every step in 11.3 adds its sim to `tests/`; a `tests/run_all.sh` runs
  import + every sim and greps for `FAIL|SCRIPT ERROR`. Run it before every
  commit — a broken parse in one lambda once cost an hour (see git history).
- A `--room X --wave Y` CLI arg on Main for manual room testing (this is
  the room-authoring tool; build it in step 4).

### 11.5 Initial balance table (starting values for `balance.gd`)
| Constant | Value | Note |
|---|---|---|
| PLAYER_SPEED / DASH | 300 / 750, 0.15s, i-frames 0.25s | dash cd 0.8s |
| FIRE_RATE / MAX_SLUGS | 2.5/s / 4 | |
| SLUG_SPEED | 520 dead, ×1.15 per bounce | lifetime 2.5s |
| DAMAGE_TIERS | [0, 1, 2, 4, 6, 9] (index = bounces) | tier 5 = detonate, AoE 90px |
| TUNING | +1 tier, 2.5s duration | |
| SELF_DAMAGE | 25% of tier | purist 100%, ×1.5 score |
| RESONANCE_HEAL | +2 HP note, bounce-2+ kills, 8s | player max HP 10 |
| REQUIEM | 12 notes, decay 1/3s, bank cap 24 | Cadenza 3s @ 20% time; Grand 5s |
| FLOURISH | hit-stop 0.12s, +2 Motifs per extra kill | |
| ENEMY HP | Chorister 3, Sidler 4, Wailer 3, Mirrorback 6, Mason 5 | |
| ROOM | 3–5 waves, 45–90s target clear | |

### 11.6 Definition of done, P0
Steps 1–4 complete, `run_all.sh` green, restart <2s measured, and a
recorded 60s clip of one room clear that includes: a tuned kill, a bounce-3
kill, a Flourish, and a Cadenza. If the clip isn't fun to watch, stop and
flag the verb for redesign — do not proceed to step 5 on momentum.
