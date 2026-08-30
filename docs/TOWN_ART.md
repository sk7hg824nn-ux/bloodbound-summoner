# Childhood town — illustrated 2.5D plates

Not a flat backdrop. Not ColorRects.

## Layers (LayerStack bands)

| Band | Plate | Role |
|---|---|---|
| FarMountains | town_sky | Sunrise sky + distant peaks |
| FarBackground | town_far | Forest line + far village silhouette |
| Buildings | town_mid | Ash's cottage, fields, path, creek, road |
| Npcs | town_trees + mother | Mid trees / Mother at the door |
| Party | (Ash) | Existing FieldPresenter — not replaced |
| Foreground | town_fore | Fence rails + hanging leaves in front of Ash |

Magenta-keyed plates: far, trees, fore, mother.
Opaque plates: sky, mid.

## Locations on town_mid

- HOME — timber cottage, left
- MOTHER — door / porch
- BOX — floorboard just inside the left wall / porch
- CREEK — stone water, lower right
- ROAD — dirt track climbing the right bank
- FIELDS / WOODS — mid path and tree line

## Load order

File `art/plates/town_*.jpg` first.
If missing (Xogot), runtime `art_town_*.gd` pack().
Never preload packs.

## Do not

Replace Ash artwork.
Flatten into one background.
Use MeshInstance / Node3D / CSG.
Change prologue dialogue or canon.
