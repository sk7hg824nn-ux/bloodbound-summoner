# 2.5D architecture — Bloodbound

Entry: World25.

World25.compose(world, "hall" | "woods" | "village")
  LayerStack — 7 bands from the TRUE 2.5D board
  dress painted plates on the walk plane
  overlay res://art/plates/<room>.png when present

World25.bind_cut(cut, camera, stack)
  talk freezes parallax
  camera uses named shots (wide / medium / close / push_in / over_shoulder / dynamic)
  returns EXPLORE

World25.still(id)
  art/plates/<id>.png or OriginArt fallback

FieldPresenter on every Actor
  atlas SpriteFrames if present
  else Figure2D

Camera2DDirector
  EXPLORE / COMBAT / ROMANCE / BOSS / TOURNAMENT
  + named cinematic shots

Not in this stack: MaxRects at runtime, TexturePacker plugin inside Xogot, MeshInstance, AES.
