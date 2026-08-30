Ash field atlas is packed into scripts/art/art_ash_data.gd so Xogot Play
does not depend on TexturePacker or a .import file.

Optional loose PNGs may live in res://art/characters/ash/.
ArtAsh.tex(name) checks those paths first, then the packed atlas.

Names: idle_se idle_front idle_back idle_side walk_se_0 walk_se_1 run_se_0 run_se_1 child_idle_se face_close
