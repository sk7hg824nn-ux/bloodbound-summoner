# Ash — visual target (academy)

Reference locked 2026-08-30. Academy look. Not childhood.

Master sheet spec: `docs/ASH_MASTER_SHEET.md`.
Production bible: `docs/ART_PRODUCTION_BIBLE.md`.
Do not replace these field plates. New work fills child / portrait gaps from the same DNA.

## Sheet facts
- Height 6'3". Age 19. Lean / athletic.
- White hair, green tips. Green eyes.
- Black long coat, gold filigree, torn emerald lining, black boots.

## Production field set

`res://art/characters/ash/academy/`

Six illustrated views. Each is a unique drawing.

1. front
2. back
3. left
4. right
5. three_quarter_front
6. three_quarter_back

Clips under each view:

- idle — breathing / cloth frames
- walk — locomotion frames
- run — faster locomotion frames

`FieldPresenter` picks `gait + view` (`walk_left`, `idle_back`, `run_three_quarter_front`).
It does **not** use `flip_h` as the left/right solution.

`ArtAsh` load order:

1. academy PNG
2. legacy PNG (`res://art/characters/ash/<name>.png`)
3. runtime packed keyed JPEG (`art_ash_pack_a.gd` / `_b.gd`)

`Figure2D` stays attached and hidden as fallback only.

Depth: `DepthRig.scale_at(y) * FieldPresenter.BASE` (0.62).
Y-sort: Actor `z_index = int(global_position.y)`.
