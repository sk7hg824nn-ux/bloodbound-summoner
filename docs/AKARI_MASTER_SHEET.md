# Akari — Master Character Sheet (SPEC)

Status: **DNA to lock before any production stills.**
Date: 2026-08-30
Code ids: `kitsune`, `akari`. Display name: Akari.
Figure stand-in colors already in `akari.gd` — new paint must match this palette, not the polygons.

She is a combatant and a person. One tail until the story says otherwise. Not a pet. Academy stamps her as Ash’s first summon. She cannot sense the hidden bloodline.

## Identity

| Fact | Lock |
| --- | --- |
| Species | Kitsune. Human-form with fox ears + **one** tail |
| Age look | Young adult. Peer to 19-year-old Ash, not a child |
| Height | Shorter than Ash. About 5'5"–5'7" next to his 6'3" |
| Build | Compact, quick. Not armored |
| Hair | Dark auburn / burnt copper. `Color(0.72, 0.28, 0.12)` |
| Fur / tail | Warm fox orange. `Color(0.93, 0.55, 0.28)` with darker points |
| Skin | Warm light |
| Eyes | Amber-gold. Narrow when annoyed |
| Outfit (academy field) | Dark travel layers, not a school uniform copy of Ash. Fitted coat or wrap, mid-thigh, movement-friendly. No nine-tail ceremonial robe on V1 |
| Ears | Always visible. Same hair color |
| Tail | One. Visible on back / 3-4 / side. Do not hide it on the front view — it still reads at the hip |
| Weapon | Claw / foxfire, not a knight’s sword |

## Master stills required (generate these first)

1. `art/characters/akari/master/full_front.png`
2. `art/characters/akari/master/face.png`
3. `art/characters/akari/master/turnaround.png` — ears + single tail readable on every angle
4. `art/characters/akari/master/palette.png` — hair, fur, skin, iris, outfit, tail tip

No second outfit on this sheet. Foxwood and academy field share this look for V1.

## Six-direction field set

Same `FieldPresenter.DIRS` as Ash:

`front` `back` `left` `right` `three_quarter_front` `three_quarter_back`

```
art/characters/akari/academy/<view>/<gait>/0.png
```

V1 gaits: `idle` `walk` `run`.
Combat clips after the master stills: `ready` `attack` `heavy` `guard` `dodge` `hurt` `knockdown` `recovery` `victory` `defeat`.

Do not flip_h. Tail direction must be drawn per view.

## Expressions ↔ relationship state

Portraits live in `art/characters/akari/portrait/`.
`Relationships.mood_label("kitsune")` picks the file. Do not randomize faces.

| Mood from code | Portrait file | Acting |
| --- | --- | --- |
| `neutral` | `neutral.png` | Unimpressed. Default |
| `distrustful` | `suspicious.png` | Pact is temporary |
| `hostile` | `angry.png` | Tension ≥ 60 |
| `tense` | `jealous.png` | Other companions |
| `close` | `embarrassed.png` | Warming, looks away |
| `trusted` | `concerned.png` | Less performing |
| `devoted` | `affectionate.png` | Would answer again |

Also generate even if unused on day one: `annoyed.png` `happy.png` `shocked.png` `protective.png` `determined.png`.

`kitsune_line_for_mood()` already maps these moods to lines. New art follows that map. Do not invent a parallel mood system.

## Combat notes

- Ready stance is weight on the back foot, tail low
- “Lie” decoy in code is a faded copy of this same body — same silhouette, lower alpha
- Victory is small and rude, not a festival pose
- Defeat is knockdown + one-tail slump, not comedy death

## Do not

- Draw nine tails
- Make her a chibi mascot
- Copy Ash’s coat
- Give her a different face per environment
- Replace Ash plates while working on Akari
- Start Sera / Mimi sheets before this one is locked
