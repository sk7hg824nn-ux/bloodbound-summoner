# 2.5D layer stack — locked to the TRUE 2.5D board

Side-view depth. Camera looks through these bands.

| Band | z_index | Role |
|---|---|---|
| FarMountains | -40 | Far mountains / sky |
| FarBackground | -30 | Distant hills, far town |
| Buildings | -15 | Houses, trees, architecture |
| Npcs | -5 | Mid-ground students / townsfolk |
| Party | 0 | Ash + companions |
| ForegroundNpcs | 5 | Figures that pass in front of Ash |
| Foreground | 12 | Leaves, fence posts, pillars, blur |

Depth comes from this order, parallax scroll_scale, and the camera. Not from MeshInstance.

Party lives at z = 0 so companions occlude mid NPCs and sit under foreground.
Old names Background / Distant / Architecture still resolve as aliases.
