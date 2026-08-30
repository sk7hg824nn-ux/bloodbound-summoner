# Cinematic camera — locked to the TRUE 2.5D board

Gameplay camera follows Ash (EXPLORE).
A story beat switches to a named shot on the same room. Dialogue. Pull back. Gameplay resumes.

| Id | Board label | Intent |
|---|---|---|
| wide | WIDE SHOT | Whole hall / village. Crowd readable. |
| medium | MEDIUM SHOT | Ash + the circle / path. |
| close | CLOSE SHOT | Face. Expression carries the line. |
| push_in | PUSH IN | Slow zoom into the seal or Ash. |
| over_shoulder | OVER THE SHOULDER | Behind Ash, looking at the rite. |
| dynamic | DYNAMIC ANGLE | Combat / dodge / strike beat. |

Cutscene beat:

```
{ "type": "cam_named", "shot": "over_shoulder", "around": Vector2(480, 360), "sec": 0.8 }
```

Modes still exist for systems: EXPLORE, COMBAT, ROMANCE, BOSS, TOURNAMENT.
Named shots override follow until the film ends.
