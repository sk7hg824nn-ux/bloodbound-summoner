# TexturePacker — presets for this phone build

Exporter: **Godot SpriteSheet** (TexturePacker 8.2+).
Plugin: desktop Godot AssetLib only. Xogot Play does not slice.

Drop output in `res://art/atlas/`.
Runtime: `AtlasLib.tex(sheet, frame)`.

## Shared (every sheet)
- Data format: Godot SpriteSheet (.tpsheet)
- Texture: PNG-32 (RGBA8888). No indexed PNG. No JPEG atlas.
- Rotation: **off** (flip_h must stay legal)
- Size constraints: power-of-two preferred, **max 2048**. Prefer 1024 if it fits.
- Multipack: on only after 2048 is full. Name `akari_field-0`, `-1`.
- Heuristic: MaxRects / Best Short Side Fit
- Border padding: **2**
- Shape padding: **2**
- Inner padding: 0
- Trim mode: Trim
- Trim margin: 1
- Extrude: **1** (stops linear filter leaking the next cell)
- Alpha: keep. Premultiply off unless a specific VFX sheet needs it.
- Common divisor / grid snap: off (trim is the point)
- Detect animations: on for field sheets (names `walk_0`, `walk_1` → clip `walk`)

Godot import on the PNG after export:
- Compress: Lossless
- Filter: **Linear**
- Mipmaps: off
- Repeat: disabled
- VRAM / Basis: off

## Field atlas (ash_field, akari_field, …)
Goal: one GPU bind for idle/walk/run/cast/hurt.
- Source frames: ~256 px tall. Do not pack 4K portraits here.
- Max: 1024 if ≤ that, else 2048
- Trim: on (feet and tails eat empty pixels)
- Pivot: bottom-center if TexturePacker writes it; we still set Sprite offset in engine
- Animations in the .tpsheet: idle, walk, run, cast, hurt
- FPS target after import: 8–12

## Talk atlas (akari_talk, …)
Goal: HUD portraits, not field.
- One expression per sprite (`neutral`, `smirk`, `soft`, `fierce`)
- Size: longest side ≤ 768
- Separate sheet from field so a talk swap does not keep a walk atlas resident
- No animation block required. HUD loads stills.

## VFX atlas (foxflame, blood-seal, hits)
- Max 1024
- Trim + extrude 1
- Short clips only
- Do not pack environment plates here

## Never pack
- Hall / woods / prologue plates (full-screen paintings)
- World map
- UI chrome (buttons already in theme)

## Quality vs phone
One 2048 RGBA lossless atlas is ~16 MB decoded. Keep field sheets to **one per character**. Do not ship four 2048s for Year 1. Ash + Akari field first. Lithanya / Breana sheets wait on their year.

If a sheet is mostly empty after trim, the source frames are too big. Shrink the paint, do not raise max size.
