scoreboard players add #level hpww.lv.work 1
scoreboard players operation #floor hpww.lv.work = #next hpww.lv.work
scoreboard players add #span hpww.lv.work 120
scoreboard players operation #next hpww.lv.work += #span hpww.lv.work
execute if score #xp hpww.lv.work >= #next hpww.lv.work run function hpww:main/spells/function/api/level/internal/advance
