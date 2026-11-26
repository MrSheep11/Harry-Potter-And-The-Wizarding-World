# Level API (Java 26.3)

Run as the player receiving XP:

```mcfunction
function hpww:main/spells/function/api/level/add_xp {amount:250}
function hpww:main/spells/function/api/level/add_xp {amount:-100}
```

The original `add {score:250}` entry point is an alias and also accepts deductions.
The function returns the new total on success. Gains stop at 150,920 XP and
deductions stop at zero; only the applied difference is shown. An adjustment
at the corresponding limit does not restart the animation. It rejects
non-players and zero amounts. It never
changes vanilla enchanting XP.

- `hpww.xp`: current total HPWW XP. `hpww.level`: current level, committed immediately.
- Level L begins at `(L - 1) * (60 * L + 80)` total XP. Level 1 starts at 0,
  level 2 at 200, level 3 at 520, and level 50 at 150,920. At 50 the badge
  stays full until XP is deducted.
- On first use the API imports a positive score from the original
  `hpww.xp_nextlevel` award stub, if present. Legacy balances outside the new
  range are clamped when the player is next online. Player scoreboards survive reloads.
- The upper-left badge shows the current progress even when the spell wheel
  is closed. Gains and losses animate from the displayed XP along an ease-out curve.
  The middle frame is gold during the animation, then returns to normal. A smaller
  counter below the badge shows the net change, including overlapping adjustments.
  The final signed amount stays visible for
  two seconds; another same-direction change in that window extends the existing
  tally and restarts the hold after the animation. Once hidden, the next change
  starts a new tally.
- Source art lives under `HPWW Resource Pack/assets/hpww_field_guide/textures/level`.
  The generated post-effect texture lives under `textures/effect/level/hud_atlas.png`
  in that namespace; Minecraft does not load it from the source art directory.
  After changing source art, run `python tools/build_level_hud.py` from the
  datapack folder (Pillow required), then reload client resources with F3+T.
  The builder preserves the original artwork and derives levels 21-50 from its digits.
- The post effects use an atlas and small screen regions, not actionbar or title
  channels. Only HPWW's own changed layers are removed or added; no global
  `posteffect clear` is used.
