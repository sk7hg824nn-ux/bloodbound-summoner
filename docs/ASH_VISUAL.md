# Ash — visual target (academy)

Reference sheet provided 2026-08-30. Academy look. Not childhood.

## Sheet facts
- Height 6'3". Age 19. Lean / athletic.
- Role: summoner. Era: academy.
- Alignment on the sheet: Neutral Good. Personality in story still timid at the first rite.

## Palette
- Hair: white with green streak
- Eyes: green
- Coat: black, long, ragged hem
- Lining: vivid green, torn like a second edge
- Body: black layers, belts, gloves, boots

## Field implementation (2026-08-30 art pass)
Illustrated frames live in `ArtAsh` / packed atlas `art_ash_data.gd`.
`FieldPresenter` draws them with `AnimatedSprite2D`.
`Figure2D` polygon layers stay attached as a hidden fallback only.

Frames:
- idle_se, idle_front, idle_back, idle_side
- walk_se_0, walk_se_1
- run_se_0, run_se_1
- child_idle_se (separate child proportions + childhood clothes)
- face_close (cinematic push-in)

Directions: front / back / side / 3-4. Left is flip_h of right.
Depth: `DepthRig.scale_at(y) * BASE` on the Field node. Do not scale Ash per shot.

## Layers (already the Figure2D names)
Shadow, Coat, Lining, Arm, Head, Hair

## Face
The sheet's smirk / focused faces are later Ash.
Year 1 woods rite still plays timid even if the coat looks like this.

## What this is not
Not a LoRA. Not a MeshInstance. Not the character-sheet image used as a sprite.
