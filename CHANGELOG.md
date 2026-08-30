# CHANGELOG.md

## 2026-08-30
- TRUE 2.5D board locked as the presentation standard.
- LayerStack now uses the board Z bands: -40 / -30 / -15 / -5 / 0 / 5 / 12.
- Camera2DDirector named shots: wide, medium, close, push_in, over_shoulder, dynamic.
- Cutscene beat `cam_named`.
- Field HUD chrome: minimap + Current Quest card.
- Village plate hook (`World25.compose(..., "village")`).
- Three save slots (`user://bloodbound_slot_0..2.json`). Index remembers last slot.
- Old single `bloodbound_save.json` migrates into slot 1 if slot 1 is empty.
- Boot lists empty / occupied. Empty → create. Occupied → continue.
- HallArt plate. Parallax freeze. Prologue cinematic. Post-Erathma map locked.
