# Persistent progress and temporary per-player animation scores.
scoreboard objectives add hpww.xp dummy
scoreboard objectives add hpww.level dummy
scoreboard objectives add hpww.lv.shown dummy
scoreboard objectives add hpww.lv.start dummy
scoreboard objectives add hpww.lv.from dummy
scoreboard objectives add hpww.lv.age dummy
scoreboard objectives add hpww.lv.frame dummy
scoreboard objectives add hpww.lv.gold dummy
scoreboard objectives add hpww.lv.number dummy
scoreboard objectives add hpww.lv.count dummy
scoreboard objectives add hpww.lv.work dummy
scoreboard objectives add hpww.lv.deaths deathCount
scoreboard players set #30 hpww.lv.work 30
scoreboard players set #60 hpww.lv.work 60
scoreboard players set #max hpww.lv.work 150920
scoreboard players set #scale hpww.lv.work 10000
scoreboard players set #negate hpww.lv.work -1
# Three-tick anticipation, then a normalized exponential ease-out; the last sample is exact.
data modify storage hpww:level ease set value [0,0,0,0,1312,2455,3451,4319,5075,5733,6307,6807,7242,7622,7952,8240,8491,8709,8899,9065,9210,9335,9445,9540,9624,9696,9759,9814,9862,9904,9940,9972,10000]
