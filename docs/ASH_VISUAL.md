# Ash — visual target (academy)

Reference sheets + TRUE 2.5D board (2026-08-30).
Academy look. Not childhood.

## Sheet facts
- Height 6'3". Age 19. Lean / athletic.
- Role: summoner. Era: academy.
- Alignment on the sheet: Neutral Good. Personality in story still timid at the first rite.

## Palette
- Hair: white with green streak
- Eyes: green
- Coat: black, long, gold/green filigree, ragged hem
- Lining: vivid green
- Body: black layers, belts, gloves, boots

## Production facings (board)
FRONT, BACK, LEFT, RIGHT, 3/4 FRONT, 3/4 BACK.
LEFT and RIGHT are painted separately when the coat is asymmetric.
flip_h is a placeholder only.

## Production animation states (board)
IDLE, WALK, RUN, CAST, ATTACK, DODGE.
FieldPresenter also reserves hit / summon / death so clips can drop in later.
Ash does not fight empty-handed. ATTACK on Ash is UNDEFINED until canon gives him a weapon that is not a summon. CAST is the rite / pact motion.

## Field implementation
Illustrated frames live in `ArtAsh` / packed atlas `art_ash_data.gd`.
`FieldPresenter` draws them with `AnimatedSprite2D`.
`Figure2D` polygon layers stay attached as a hidden fallback only.

Current placeholder frame names:
- idle_se, idle_front, idle_back, idle_side
- walk_se_0, walk_se_1
- run_se_0, run_se_1
- child_idle_se
- face_close (cinematic push-in / CLOSE SHOT)

Depth: `DepthRig.scale_at(y) * BASE` on the Field node. Do not scale Ash per shot.

## Layers (Figure2D fallback)
Shadow, Coat, Lining, Arm, Head, Hair

## Face
The board's smirk / focused faces are later Ash.
Year 1 woods rite still plays timid even if the coat looks like this.

## What this is not
Not a LoRA. Not a MeshInstance. Not the character-sheet image used raw as a sprite.
