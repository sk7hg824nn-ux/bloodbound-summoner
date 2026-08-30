# Ash academy field set

Six illustrated views. Each view has idle / walk / run clips.

```
front/
back/
left/
right/
three_quarter_front/
three_quarter_back/
    idle/0.png idle/1.png
    walk/0.png walk/1.png …
    run/0.png  run/1.png  …
```

FieldPresenter selects a view from movement vs camera.
Do not flip_h left/right. Left and right plates are unique drawings.
Depth comes from DepthRig, not from these files.
