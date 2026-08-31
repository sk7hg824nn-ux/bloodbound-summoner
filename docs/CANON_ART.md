# Canon lock — art and implementation

If a drawing or a script fights this page, the page wins. Throw the drawing away.

## Story that art may not spoil

- Childhood is playable. Mother is a person. The knife is specific to the bloodline.
- First awakening is grief, not a pact tutorial.
- At the academy the school does not know. Ash still cannot name the art. **Akari cannot sense the hidden power.**
- "Blood Heir" and "descendant of the First King" are later discoveries. Do not put them on coats, banners, UI chrome, or tooltips.

## Ash

Locked. Do not replace the academy field plates.

- 19. 6'3". Lean.
- White hair, green tips. Green eyes.
- Black long coat, gold filigree, torn emerald lining, black boots.
- Act I: empty focus. No glowing arm tattoo. No blood sword as everyday field gear.
- Child look is the same face, shorter, home clothes. Not a second protagonist.

The black-hair / red-eye / Bloodbound Blade sheet is **not** canon.

## Akari

- One tail until the story grows them. Never hide a nine-tail “true form” on V1.
- Burnt copper hair. Amber-gold eyes. Warm orange tail.
- Dark travel wrap + red sash. Not Ash’s coat. Not a shrine-maiden costume as the field default.
- Bound by a plea she did not want. Unimpressed. Combatant, not a pet.
- Faces follow `Relationships.mood_label("kitsune")`. Do not randomize.

The black-hair / red-eye / kitsune-katana / “multiple tails usually hidden” sheet is **not** canon.

Known drift to fix: left/right idle stills slipped into a kimono. Reshoot those two views to the charcoal wrap. Front and three-quarter are the source of truth.

## Names

| Show | Code | When |
| --- | --- | --- |
| Ash | `ash` | now |
| Akari | `kitsune` / `akari` | now |
| Mother | `mother` | opening only |
| Sera / Lithanya | `dragoness` | after her master sheet |
| Mimi / Breana | `bunny` | after her master sheet |

Do not paint a second face for any row.

## Presentation

2D illustrated plates + FieldPresenter. No MeshInstance3D characters. No `flip_h` as left/right. LayerStack bands stay the camera language.

## What “implement everything” means under this lock

Ship V1 slice art that obeys the rows above. Do not fill the rest of the bible by inventing looks.
