# Flavor Folk — Hand-Drawn Character System

40 food characters, each with 5 expressive variations (200 drawings total), painted entirely in code. No image assets: every character is a `CustomPainter` built on a hand-drawn ink engine. Nothing here is wired into the app — the folder is self-contained and waits for character selection before any integration.

## Why code-drawn

- Infinitely scalable (vector), tint-able, and animatable per-part later.
- One visual language enforced by a shared engine instead of 200 exported files.
- Variations are parameterized poses/faces/props, so new moods or characters are cheap.

## Structure

```
lib/characters/
  characters.dart          registry: characterFamilies + allFoodCharacters (exports everything)
  core/
    sketch.dart            drawing engine: CharacterMood, Inks palette, MoodPose, Sketch
    food_character.dart    FoodCharacter model, FoodCharacterPainter, FoodCharacterView
  families/                8 files x 5 characters, one const spec + one _paintX fn each
  gallery/
    character_gallery.dart standalone browsing app (grid -> detail with mood switcher)
    gallery_main.dart      entrypoint
test/characters/
  characters_render_test.dart  paints all 200, writes PNGs to build/character_previews/
```

## The drawing engine (`Sketch`)

Everything paints into a virtual 100x100 box (the painter scales/centers it), so all coordinates in family files are plain numbers. The hand-drawn feel comes from:

- `wobble()` — resamples any path along its metrics and jitters points perpendicular to the tangent (seeded per character+mood, so frames are stable).
- `fillArea()` — fills are wobbled *and* slightly offset from the outline (ink misregistration).
- `shade()` — hatched crescent shadow (body minus shifted body), `grain()` — paper speckle.
- Face kit (`moodFace` + eye/mouth primitives), limb kit (`moodArms`, `legs` with a running pose for hype), effects kit (sparkles, hearts, zzz, steam, speed lines, confetti, pop ticks).
- `posed()` — per-mood squash/stretch/lean around a ground anchor.

## The five moods

| Mood | Use it for | What changes |
|---|---|---|
| `signature` | default/brand moments | canonical pose + the character's personal prop |
| `joy` | success, celebration | arc eyes, open laugh, arms up, confetti/pop ticks |
| `yum` | food love, favorites | heart eyes, tongue out, hands to chest |
| `sleepy` | empty states, late night | lidded eyes, squashed pose, zzz + per-character gag |
| `hype` | deals, drops, launches | star eyes, action lean, speed lines + per-character stunt |

Several characters deliberately break the standard mapping (that is their personality): Shari stays serene in every mood and levitates instead of speeding; Maca's mouth is the cream line between its shells; Flan always wobbles (ghost outlines); Croix becomes the moon when sleepy; Carro sleeps planted in soil; Pop launches from a toaster.

## Usage

```dart
FoodCharacterView(character: miso, mood: CharacterMood.hype, size: 120)
```

Browse on device/simulator (not wired into the app):

```bash
flutter run -t lib/characters/gallery/gallery_main.dart
```

Regenerate the 200 preview PNGs (also the paint smoke test):

```bash
flutter test test/characters/characters_render_test.dart
# output: build/character_previews/<id>_<mood>.png
```

## Roster

| Family | Members (id) |
|---|---|
| Orchard Folk | Berry, Zest, Avo, Peach, Pina |
| Garden Gang | Brock, Carro, Ember, Shroomi, Cobb |
| Bakery Bunch | Bagi, Croix, Doni, Twist, Loaf |
| Street Squad | Patty, Fritz, Peppo, Tico, Frank |
| Noodle House | Shari, Miso, Bao, Nori, Pearl |
| Sugar Studio | Poppy, Swirl, Coco, Maca, Flan |
| Sunrise Club | Sunny, Stax, Pop, Crisp, Brew |
| Pantry Pals | Fizz, Brie, Amber, Melone, Malt |

Names, titles, stories, and per-mood lore live on each `FoodCharacter` spec next to its painter.

## Animation (ambient life)

Time is opt-in: `Sketch.time` is null for static rendering (previews, tests — byte-identical output) and a seconds value when live. `FoodCharacterPainter(time: ...)` threads it through; `AnimatedFoodCharacterView` drives it with a quantized `Ticker`.

What the engine animates for every character, with zero painter changes:

- **The boil** — the wobble seed re-rolls ~7x/second, so every ink line, grain fleck, and confetti scrap re-jitters like flipbook cels. This is the core of the hand-drawn look.
- **Breath** — `posed()` adds a volume-preserving squash cycle plus a slow lean sway, anchored at the ground so feet stay planted. `groundShadow` narrows in sync.
- **Blink** — `eyeDot` / `eyeStar` / `eyeHeart` briefly become closed lids every few seconds; bespoke faces built from those primitives blink for free. Closed-eye styles never blink.
- **Effect drift** — steam wisps wave, zzz letters bob.

Per-character temperament comes from `MotionProfile(tempo, bounce)` on the spec (default 1/1). Current overrides: Shari (0.55/0.3 — nearly still, that is the joke), Flan (bounce 1.7), Bao (bounce 1.35), Fizz (1.5/1.15), Brew (tempo 1.45), Crisp (tempo 1.2). Phase offsets derive from each character's seed, so the cast never moves in unison.

Frame rates are an aesthetic choice, not just a budget: everything runs "on twos/threes" like cel animation — the gallery grid at 8 fps, the detail view at 12 fps. Smooth 60 fps would fight the boil. It also keeps 40 concurrent live characters cheap; each view sits in its own `RepaintBoundary` and pauses with `TickerMode` on covered routes.

The gallery has a **Live** toggle in the header. The render test writes 6-frame strips (`_live_strip_<id>.png`) for spot-checking motion and asserts that live frames actually differ.

## Performances, reactions, and morphs

**Signature performances.** `Sketch.perf` is a nullable phase (0..1). When set, `posed()` composes a choreography from `MotionProfile.style` — one of `hop / spin / dash / shake / float / wobble / bow / pop` — with anticipation, squash and stretch, and style-matched flair (landing dust, spin arcs, dash speed lines) drawn in world space so it does not rotate with the body. Magnitude scales with `bounce`, speed with `tempo`, and the ground shadow narrows with `PerfPose.lift`. Every character has an assigned style; eight also have bespoke phase hooks in their painters: Patty's bun tips, Frank's cap tosses, Fizz's spray erupts, Cobb pops popcorn in sequence, Ember's flame blazes, Brie's monocle pops and returns, Pearl's tapioca swirls, Pop coils on springs with launch ticks.

**Reactions** (only when `AnimatedFoodCharacterView(interactive: true)`, as in the gallery detail screen): tap plays the performance, horizontal drag leans the character against the pull (`Sketch.lean`) and releases into a decaying spring, long-press flashes the yum face.

**Mood morphs.** Changing `mood` on a live view no longer hard-cuts: the widget squashes down on the old mood, swaps art at the bottom of the squash, and pops back with overshoot (`easeOutBack`), all quantized to the same ticker so it stays on-twos. Keep the widget's key stable across mood changes or the morph state resets.

The render test also writes 12 performance frames per character to `build/character_performances/` — these feed the "Flavor Folk — Live" APNG showcase page and assert every performance actually moves.

## Adding a character

1. Pick a family file, add a `const <id> = FoodCharacter(...)` spec + `_paintX` function.
2. Body silhouette first (fill -> shade -> grain -> ink), then legs before the body, arms after, face last, mood extras in a switch.
3. Ground sits at y=86-88; keep headroom above y~14 for effects.
4. Add the id to the family `members` list; the registry, gallery, and render test pick it up automatically.
