# Threshold(L) = (L-1)*(60*L+80). The next interval is 200, then grows by 120 XP/level.
execute if score #xp hpww.lv.work matches 150920.. run return run function hpww:main/spells/function/api/level/internal/max_level
scoreboard players operation #span hpww.lv.work = #level hpww.lv.work
scoreboard players operation #span hpww.lv.work *= #60 hpww.lv.work
scoreboard players add #span hpww.lv.work 80
scoreboard players operation #floor hpww.lv.work = #level hpww.lv.work
scoreboard players remove #floor hpww.lv.work 1
scoreboard players operation #floor hpww.lv.work *= #span hpww.lv.work
scoreboard players operation #span hpww.lv.work += #span hpww.lv.work
scoreboard players remove #span hpww.lv.work 80
scoreboard players operation #next hpww.lv.work = #floor hpww.lv.work
scoreboard players operation #next hpww.lv.work += #span hpww.lv.work
execute if score #xp hpww.lv.work < #floor hpww.lv.work run function hpww:main/spells/function/api/level/internal/retreat
execute if score #xp hpww.lv.work >= #next hpww.lv.work run function hpww:main/spells/function/api/level/internal/advance
scoreboard players operation #fill hpww.lv.work = #xp hpww.lv.work
scoreboard players operation #fill hpww.lv.work -= #floor hpww.lv.work
scoreboard players operation #fill hpww.lv.work *= #30 hpww.lv.work
scoreboard players operation #fill hpww.lv.work /= #span hpww.lv.work
