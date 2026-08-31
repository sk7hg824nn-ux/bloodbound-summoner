# Ash — Master Character Sheet (SPEC)

Status: **DNA locked. Do not redraw the academy field body from scratch.**
Date: 2026-08-30
Era for this sheet: academy (age 19). Child look is a derived sheet, not a second person.

This document is the specification. It is not an image. Generate stills only after this page is accepted.

## Identity

| Fact | Lock |
| --- | --- |
| Height | 6'3" |
| Age (academy) | 19 |
| Build | Lean athletic. Long limbs. Not bulky. |
| Hair | White, green tips. Worn slightly messy, falls toward the right eye. Not a helmet. |
| Eyes | Green. Sharp. Tired more than fierce. |
| Skin | Fair, cool undertone |
| Coat | Black long coat, gold filigree, torn emerald lining |
| Under | Dark shirt, no loud logos |
| Legs | Black trousers, black boots |
| Weapon | Summoning focus / later pact blade. Empty focus in Act I. |
| Marks | No glowing tattoos on the V1 field sprite. Bloodline shows in FX, not as costume chrome |

Childhood (`GameState.era == "child"`): same face structure, shorter, home clothes, no academy coat. Derived from this skull and hair, not a new character.

## Master stills required (generate these first)

1. `art/characters/ash/master/full_front.png` — full body, academy coat, empty hands, T-pose-ish but natural weight
2. `art/characters/ash/master/face.png` — head only, three-quarter, neutral
3. `art/characters/ash/master/turnaround.png` — front / 3-4 / side / back on one sheet
4. `art/characters/ash/master/palette.png` — labeled swatches: hair white, hair tip green, iris green, coat black, filigree gold, lining emerald, boot black

Existing approved field plates under `art/characters/ash/academy/` remain the field source of truth. New master stills must match those plates, not replace them.

## Six-direction field set

Already specified in `docs/ASH_VISUAL.md`. Views:

`front` `back` `left` `right` `three_quarter_front` `three_quarter_back`

Clips per view for V1: `idle` `walk` `run`.
Do not use `flip_h` to fake left or right.

Scale: `DepthRig.scale_at(y) * FieldPresenter.BASE` (0.62). Feet sit on the party plane.

## V1 cinematic faces

Folder: `art/characters/ash/portrait/`

| File | Use |
| --- | --- |
| `neutral.png` | default box |
| `happy.png` | rare, exam joke / small win |
| `confused.png` | pact does not answer |
| `determined.png` | woods call |
| `angry.png` | later |
| `shocked.png` | ambush / mother |
| `sad.png` | grief thread |
| `fear.png` | opening knife |
| `grief.png` | mother |
| `resolve.png` | after first pact |

Portraits are busts. Same hair, same eyes, same coat collar. No new haircut per mood.

## Pose / combat set (after field + portraits)

Idle, walk, run (done). Then: interact, talk, hurt, attack, guard, dodge, victory, defeat.

## Do not

- Change the coat into armor
- Give him a tail, ears, or pact marks on the skin for V1
- Age him into a child on the academy sheet
- Replace `FieldPresenter` or the six academy views already in repo
- Generate Lithanya / Breana from this sheet
