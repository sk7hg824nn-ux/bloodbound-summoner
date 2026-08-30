# 2.5D architecture — Bloodbound

Entry: World25.

World25.compose(world, "hall" | "woods")
  LayerStack on that node
  dress painted plates on the walk plane
  overlay res://art/plates/<room>.png when present

World25.bind_cut(cut, camera, stack)
  talk freezes parallax
  camera pushes ROMANCE, returns EXPLORE

World25.still(id)
  art/plates/<id>.png or OriginArt fallback

FieldPresenter on every Actor
  atlas SpriteFrames if present
  else Figure2D

Camera2DDirector
  EXPLORE / COMBAT / ROMANCE / BOSS / TOURNAMENT

Not in this stack: MaxRects, TexturePacker runtime, MeshInstance, AES.
