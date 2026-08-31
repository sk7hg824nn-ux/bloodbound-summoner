# Bloodbound — Artwork Production Bible

Art is built around the first playable slice and the existing Godot 4.6 2.5D architecture.

**Rule:** art is the source of truth. Godot is presentation. Do not generate production images until the named master sheet for that character is locked.

**Rule:** do not replace locked Ash field artwork. New Ash work fills gaps (child look, expressions, cinematic) from the same DNA.

**Rule:** no MeshInstance3D, no CSG characters, no flip_h as a left/right solution.

## Name lock

| Bible / display | Code id | Pact figure | V1 |
| --- | --- | --- | --- |
| Ash | `ash` | player | YES |
| Akari | `kitsune` / `akari` | kitsune | YES |
| Mother | `mother` | npc | YES — opening only |
| Sera / Lithanya | `dragoness` | dragoness | NO — master sheet later |
| Mimi / Breana | `bunny` | bunny | NO — master sheet later |
| Rin | `best_friend` | — | slice NPC only if on screen |
| Cael | `rival` | — | slice NPC only if on screen |

Do not invent a second face for any row.

## Pipeline (locked)

```
Master Reference
  → six-direction field art
  → combat / gait clips
  → cinematic + expressions
  → future animation
```

Field views match `FieldPresenter.DIRS`:

1. `front`
2. `back`
3. `left`
4. `right`
5. `three_quarter_front`
6. `three_quarter_back`

Gaits already wired: `idle` / `walk` / `run`.
Add later under the same view folders: `interact`, `talk`, `hurt`, `attack`, `guard`, `dodge`, `victory`, `defeat`.

On-disk:

```
art/characters/<id>/<era>/<view>/<gait>/0.png …
art/characters/<id>/master/<sheet>.png
art/characters/<id>/portrait/<mood>.png
```

Eras for Ash: `child` | `academy`. Same Player + FieldPresenter. `GameState.era` swaps the look.

## V1 playable slice — produce only this

### Characters
- **Ash** — master sheet, six directions, idle/walk/run, basic cinematic faces
- **Akari** — master sheet, six directions, combat set, cinematic faces tied to `Relationships.mood_label("kitsune")`
- **Mother** — master + opening poses (door, talk, farewell). No combat library
- Origin NPCs — only people who appear in the canonical opening. One field sprite + one talk pose each

### Environments (7-band LayerStack)
Already the standard: Sky, Far, Distant structures, Architecture, Interactive, Ground/party, Foreground.

- Origin / childhood town — plates exist; refine, do not flatten
- Academy hall — plates exist; refine
- Woods / Foxwood Gate — next environment pass after the two master sheets

### Systems (presentation, not new characters)
- Dialogue portraits driven by relationship mood
- Named Camera2DDirector shots
- Placeholder VFX / UI chrome until character DNA is locked

## Later (not V1)
Lithanya / Sera, Breana / Mimi, modular academy crowd, full VFX library, full UI paint, woods prop kit.

## Godot integration (Grok)

After a sheet is approved:

1. Drop PNGs in the folders above
2. Register in `ArtAsh` / `ArtAkari` (file first, packed JPEG fallback for Xogot)
3. FieldPresenter selects `gait + view`
4. Portraits: `Relationships.mood_label(id)` → `art/characters/<id>/portrait/<mood>.png`
5. Do not touch movement, prologue beats, or Ash’s locked academy field plates

## Next

1. Lock `docs/ASH_MASTER_SHEET.md`
2. Lock `docs/AKARI_MASTER_SHEET.md`
3. Only then generate production stills from those sheets
