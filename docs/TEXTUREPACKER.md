# TexturePacker — how this repo uses atlases

Desktop tool: TexturePacker.
Exporter: **Godot SpriteSheet** (TexturePacker 8.2+).
Plugin: CodeAndWeb TexturePacker Importer 4.8 (MIT). Install from AssetLib on a desktop Godot. Do not expect the slicer to run inside Xogot Play.

## Export settings
- Format: Godot SpriteSheet (.tpsheet + .png)
- Rotation: off
- Trim: on
- Padding: 2
- Max size: 2048
- PNG-32
- Filter on the PNG after import: linear, compress lossless

## Drop here
res://art/atlas/<name>.png
res://art/atlas/<name>.png.import
res://art/atlas/<name>.tpsheet

After desktop import, commit what the plugin writes:
res://art/atlas/<name>.sprites/*.tres
res://art/atlas/<name>.animations.tres   (if the sheet has animation names)

## Names
Field sheets: ash_field, akari_field, lithanya_field, breana_field
Talk stills may share a talk atlas: ash_talk, akari_talk, …
Hall / woods / prologue plates are full-screen paintings, not packed frames.

## Runtime
AtlasLib.tex("akari_field", "walk_0")
returns the AtlasTexture if that .tres exists, else null.
Figure2D stays until those files exist.
