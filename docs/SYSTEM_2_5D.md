# 2.5D stack — what lives in the game

Filtered from the investigation dump.

## In engine (Xogot)
- LayerStack / Parallax2D: BACKGROUND → DISTANT → ARCHITECTURE → NPCs → PARTY → FOREGROUND
- Hall / woods / prologue as painted plates (HallArt / OriginArt until PNG)
- Camera2DDirector modes + freeze stack during talk
- CutsceneDirector beats (say / plate / cam / mark)
- Figure2D layered silhouette (placeholder body)
- FieldPresenter: if an atlas frame exists, show AnimatedSprite2D; else Figure2D
- AtlasLib.tex(sheet, frame) — load only
- Dialogue HUD (portraits when files exist)
- Player brick untouched

## Desktop only — do not ship in Play
- TexturePacker, MaxRects, BSSF, BLSF, Skyline, waste maps, rotation
- TexturePacker Importer plugin
- SpriteFrames slicing window
- AES / HMAC / ConfigFile encryption

## Best system per job
| Job | System |
|---|---|
| World depth | Parallax2D LayerStack |
| Room / field look | Full-screen (or wide) painting on the walk plane |
| Walk body | AnimatedSprite2D + SpriteFrames from atlas, flip_h |
| Placeholder body | Figure2D layers |
| Talk | HUD TextureRect portraits, not field clips |
| Cutscene | CutsceneDirector + plates |
| Pack density | TexturePacker MaxRects BSSF, no rotation, desktop |

No MeshInstance heroes. No runtime packer. No pixel nearest on painted sheets.
