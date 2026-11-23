scoreboard objectives add hpww.fg.work dummy
scoreboard objectives add hpww.fg.session dummy
scoreboard objectives add hpww.fg.rig dummy
scoreboard objectives add hpww.fg.busy dummy
data modify storage hpww:field_guide categories set value {p1:"damage",p2:"control",p3:"force",p4:"utility",p5:"curses",p6:"other_1",p7:"other_2",p8:"other_3",p9:"other_4",p10:"other_5"}
function hpww:main/field_guide/api/create {page:"main",project:"field_guide_gui"}
function hpww:main/field_guide/api/create {page:"spell_wheel",project:"fg_spell_wheel"}
# The main rig is authored facing the opposite way from the Spell Wheel rig.
data modify storage hpww:field_guide pages.main.yaw set value 180
function hpww:main/field_guide/api/set_animations {page:"main",opening:"open_page_main",closing:"close_page_main"}
function hpww:main/field_guide/api/set_animations {page:"spell_wheel",opening:"open",closing:"close"}
