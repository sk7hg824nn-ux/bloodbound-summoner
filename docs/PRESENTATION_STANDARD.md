# Presentation standard — locked 2026-08-30

Source: the TRUE 2.5D in-game board.

```
100% 2D ARTWORK  ·  2.5D STAGING  ·  REAL DEPTH
NO 3D MODELS  ·  NO MESHES
HIGH DETAIL 2D CHARACTERS + 2D ENVIRONMENTS = TRUE 2.5D EXPERIENCE
```

This board is the bar. Earlier comparisons (Star Ocean field feel, Another Eden plates, Tales talk) were references. They do not override this board.

## Field language
A painted overworld you walk through.
Ash is a high-detail illustrated figure on a designed path — cottages, fence, trees, mountains behind him.
HUD sits on the painting: left stick, right ability cluster, top-right minimap, quest card.
Characters are not chibi and not pixel HD-2D.

## Cutscene language
The Academy Examination Hall plate: painted hall, bleachers full of students, summoning circle, another student's griffin (not Ash's).
Camera moves through named shots on that same plate. No black void with a subtitle.

## Character language
Production Ash uses six painted facings and seven animation states.
See `docs/ASH_VISUAL.md` and `docs/CAMERA_SHOTS.md`.

## What this is not
- MeshInstance / CSG / low-poly 3D heroes or rooms
- LoRA as a runtime requirement
- Octopath pixel as Ash's body
- ColorRect yards as finished art
- Inventing a fourth summon or extra continents to fill a plate

## Honest gap
The engine now stages to this board (layer Z, camera names, HUD chrome).
The painted village plate, hall plate, and six-view walk cycles are still MISSING from `res://art`.
Until those PNGs exist, Xogot will show the staging, not the board.
