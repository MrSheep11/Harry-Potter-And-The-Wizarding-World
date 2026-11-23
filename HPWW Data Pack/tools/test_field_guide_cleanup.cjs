// Runs against an isolated 1.21.11 server with two offline test clients.
const fs = require('node:fs');
const path = require('node:path');
const net = require('node:net');
const { spawn } = require('node:child_process');
const readline = require('node:readline');
const { createRequire } = require('node:module');

const work = path.join(process.env.USERPROFILE, 'Documents/Codex/2026-11-07/hpww-release');
const testRequire = createRequire(path.join(work, 'test-deps/package.json'));
const protocol = testRequire('minecraft-protocol');
const { simplify } = testRequire('prismarine-nbt');
const baseline = process.argv.includes('--baseline');
const pageApi = Boolean(process.env.HPWW_FIELD_GUIDE_API_TEST_PACK);
const testOverlay = process.env.HPWW_FIELD_GUIDE_TEST_OVERLAY === '1';
const root = process.env.HPWW_FIELD_GUIDE_TEST_ROOT || path.join(work, baseline ? 'field-guide-baseline' : pageApi ? 'field-guide-api' : 'field-guide-validation', '1.21.11');
const pack = process.env.HPWW_FIELD_GUIDE_API_TEST_PACK || (baseline ? path.join(work, 'baseline-1.21.11') : path.join(work, 'build/1.21.11/HPWW Data Pack'));
fs.mkdirSync(root, { recursive: true });
fs.cpSync(pack, path.join(root, 'world/datapacks/hpww'), { recursive: true });
const fixtures = path.join(root, 'world/datapacks/field_guide_test');
const functions = path.join(fixtures, 'data/release_fg/function');
fs.mkdirSync(functions, { recursive: true });
fs.copyFileSync(path.join(pack, 'pack.mcmeta'), path.join(fixtures, 'pack.mcmeta'));

const entries = {
  setup: `forceload add 0 0 32 16
${pageApi ? 'kill @e[tag=aj.hpww_trial_start_button.entity]' : ''}
gamemode spectator HPWW_Test_A
gamemode spectator HPWW_Test_B
tp HPWW_Test_A 0 100 0 0 0
tp HPWW_Test_B 0.25 100 0 0 0
execute as @a run function hpww:main/spells/function/other/store_uuid
scoreboard players set @a hpww.fg.spell_wheel_page.notice_seen 1
scoreboard players set @a SettingsMenuStatus 1
scoreboard players set @a SettingsMenu.page.main 0
execute as HPWW_Test_A at @s run function release_fg:open_a
execute as HPWW_Test_B at @s run function release_fg:open_b
schedule function release_fg:click_close 15t replace
`,
  open_a: `${pageApi ? 'function hpww:main/field_guide/gui/spell_wheel_page/open_link' : ''}
summon marker ~ ~ ~ {Tags:["hpww.fg_marker_binded","fgtest.anchor_a"]}
summon marker ~20 ~ ~ {Tags:["hpww.fg_marker_binded","fgtest.anchor_a"]}
function hpww:main/spells/function/api/uuid_selector/api/link_entities {entity:"@e[tag=fgtest.anchor_a]"}
${pageApi ? '' : 'function hpww:main/field_guide/gui/spell_wheel_page/open_link'}
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[tag=aj.fg_spell_wheel.entity]",function:"release_fg:tag_a"}
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=interaction,tag=aj.fg_spell_wheel.interaction]",function:"release_fg:tag_a"}
`,
  open_b: `${pageApi ? 'function hpww:main/field_guide/gui/spell_wheel_page/open_link' : ''}
summon marker ~ ~ ~ {Tags:["hpww.fg_marker_binded","fgtest.anchor_b"]}
function hpww:main/spells/function/api/uuid_selector/api/link_entities {entity:"@e[tag=fgtest.anchor_b]"}
${pageApi ? '' : 'function hpww:main/field_guide/gui/spell_wheel_page/open_link'}
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[tag=aj.fg_spell_wheel.entity]",function:"release_fg:tag_b"}
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=interaction,tag=aj.fg_spell_wheel.interaction]",function:"release_fg:tag_b"}
`,
  tag_a: 'tag @s add fgtest.rig_a\n',
  tag_b: 'tag @s add fgtest.rig_b\n',
  click_close: `execute unless entity @e[type=item_display,tag=fgtest.rig_a,tag=aj.fg_spell_wheel.root] run say HPWW_FIELD_GUIDE_FAIL: owner A rig not created
execute unless entity @e[type=interaction,tag=fgtest.rig_a] run say HPWW_FIELD_GUIDE_FAIL: owner A interactions not linked
execute unless entity @e[tag=fgtest.anchor_a] run say HPWW_FIELD_GUIDE_FAIL: duplicate anchor fixture missing
execute unless score HPWW_Test_A SettingsMenuStatus matches 1 run say HPWW_FIELD_GUIDE_FAIL: active page cleared menu status
execute unless score HPWW_Test_B SettingsMenuStatus matches 1 run say HPWW_FIELD_GUIDE_FAIL: owner B active page cleared menu status
${pageApi ? 'execute as @e[type=interaction,tag=fgtest.rig_a,tag=aj.fg_spell_wheel.interaction.exit_interaction,limit=1] at @s run function release_fg:other_owner_click' : ''}
execute as HPWW_Test_A at @s run function hpww:main/spells/function/api/uuid_selector/api/at_linked_entity {entity:"@e[type=item_display,tag=aj.fg_spell_wheel.bone.exit]",function:"hpww:main/field_guide/gui/spell_wheel_page/close"}
execute unless entity @e[tag=fgtest.anchor_b] run say HPWW_FIELD_GUIDE_FAIL: owner B anchor removed by owner A
execute unless entity @e[type=item_display,tag=fgtest.rig_b,tag=aj.fg_spell_wheel.root,tag=!aj.fg_spell_wheel.animation.close.playing] run say HPWW_FIELD_GUIDE_FAIL: owner B rig closed by owner A
schedule function release_fg:after_click 20t replace
`,
  after_click: `execute if entity @e[tag=fgtest.rig_a] run say HPWW_FIELD_GUIDE_FAIL: owner A rig survived close animation
execute if entity @e[tag=fgtest.anchor_a] run say HPWW_FIELD_GUIDE_FAIL: owner A anchor survived click close
execute unless score HPWW_Test_A SettingsMenuStatus matches 0 run say HPWW_FIELD_GUIDE_FAIL: close did not clear menu status
execute unless score HPWW_Test_A SettingsMenu.page.spell_wheel matches 0 run say HPWW_FIELD_GUIDE_FAIL: close did not clear page state
execute unless entity @e[tag=fgtest.rig_b] run say HPWW_FIELD_GUIDE_FAIL: owner B rig disappeared
execute as HPWW_Test_A at @s run function release_fg:open_a
scoreboard players set HPWW_Test_A SettingsMenuStatus 1
schedule function release_fg:repeat_close 15t replace
`,
  repeat_close: `execute as HPWW_Test_A at @s run function hpww:main/spells/function/api/uuid_selector/api/at_linked_entity {entity:"@e[type=item_display,tag=aj.fg_spell_wheel.bone.exit]",function:"hpww:main/field_guide/gui/spell_wheel_page/close"}
tp HPWW_Test_B 28 100 0 0 0
schedule function release_fg:after_distance 20t replace
`,
  after_distance: `execute if entity @e[tag=fgtest.rig_a] run say HPWW_FIELD_GUIDE_FAIL: reopened rig survived animation
execute if entity @e[tag=fgtest.anchor_a] run say HPWW_FIELD_GUIDE_FAIL: anchor leak after reopening
execute if entity @e[tag=fgtest.anchor_b] run say HPWW_FIELD_GUIDE_FAIL: anchor survived walk-away close
execute if entity @e[tag=fgtest.rig_b] run say HPWW_FIELD_GUIDE_FAIL: rig survived walk-away close
execute unless score HPWW_Test_B SettingsMenuStatus matches 0 run say HPWW_FIELD_GUIDE_FAIL: walk-away did not clear menu status
${pageApi ? 'execute as HPWW_Test_A at @s run function release_fg:api_test' : 'say HPWW_FIELD_GUIDE_DONE'}
`,
};
if (pageApi) {
  const aimAt = (interaction) =>
    `execute at @e[type=interaction,tag=aj.fg_spell_wheel.interaction.${interaction}_interaction,limit=1] positioned ~ ~0.3 ~ anchored eyes run rotate HPWW_Test_A facing ~ ~ ~`;
  const hasOverlay = row => `@a[name=HPWW_Test_A,tag=hpww.fg.${row}_controls]`;
  const noOverlays = ['wheel', 'drawer'].map(row =>
    `execute if entity @a[tag=hpww.fg.${row}_controls] run say HPWW_FIELD_GUIDE_FAIL: ${row} controls stayed visible after leaving the target`
  ).join('\n');
  entries.other_owner_click = `data modify entity @s interaction set value {player:[I;0,0,0,0],timestamp:0L}
data modify entity @s interaction.player set from entity HPWW_Test_B UUID
function aj:fg_spell_wheel/interactions/exit_interaction_on_interact
execute unless score HPWW_Test_B SettingsMenu.page.spell_wheel matches 1 run say HPWW_FIELD_GUIDE_FAIL: foreign click switched owner B's page
execute unless score HPWW_Test_A SettingsMenu.page.spell_wheel matches 1 run say HPWW_FIELD_GUIDE_FAIL: foreign click closed owner A's page
data remove entity @s interaction
`;
  entries.api_test = `function hpww:main/field_guide/api/create {page:"trial_test",project:"hpww_trial_start_button"}
function hpww:main/field_guide/api/open {page:"trial_test"}
execute unless entity @e[tag=aj.hpww_trial_start_button.root,tag=hpww.fg.page_root,distance=..3] run say HPWW_FIELD_GUIDE_FAIL: registered page did not open
function hpww:main/field_guide/api/close
schedule function release_fg:start_switch 4t replace
`;
  entries.start_switch = `execute if entity @e[tag=aj.hpww_trial_start_button.entity] run say HPWW_FIELD_GUIDE_FAIL: generic page cleanup left an entity
tp HPWW_Test_A 1.0 100 0.5 0 0
scoreboard players set HPWW_Test_A hppw.field_guide.first_open_dialog 1
execute as HPWW_Test_A at @s run function release_fg:switch_to_wheel
schedule function release_fg:during_main_open 2t replace
`;
  entries.switch_to_wheel = `
function hpww:main/field_guide/api/open {page:"main"}
execute unless score @s SettingsMenu.page.main matches 1 run say HPWW_FIELD_GUIDE_FAIL: main page did not open
execute positioned 1.0 100 2.0 unless entity @e[tag=aj.field_guide_gui.root,distance=..0.000001] run say HPWW_FIELD_GUIDE_FAIL: initial page did not spawn at the expected position
data modify storage release_fg:test main_rotation set from entity @e[tag=aj.field_guide_gui.root,limit=1] Rotation
function hpww:main/field_guide/api/open {page:"missing_page"}
execute unless score @s SettingsMenu.page.main matches 1 run say HPWW_FIELD_GUIDE_FAIL: missing page closed current page
tp @s 2.0 100 0.5 83 12
function hpww:main/field_guide/api/open {page:"spell_wheel"}
execute if entity @e[tag=aj.fg_spell_wheel.root] run say HPWW_FIELD_GUIDE_FAIL: next page spawned immediately
`;
  entries.during_main_open = `execute unless entity @e[tag=aj.field_guide_gui.root,tag=aj.field_guide_gui.animation.open_page_main.playing] run say HPWW_FIELD_GUIDE_FAIL: switch interrupted the main opening animation
execute if entity @e[tag=aj.fg_spell_wheel.root] run say HPWW_FIELD_GUIDE_FAIL: next page appeared during opening
schedule function release_fg:during_main_close 8t replace
`;
  entries.during_main_close = `execute unless entity @e[tag=aj.field_guide_gui.root,tag=aj.field_guide_gui.animation.close_page_main.playing] run say HPWW_FIELD_GUIDE_FAIL: main close animation did not play
execute if entity @e[tag=aj.fg_spell_wheel.root] run say HPWW_FIELD_GUIDE_FAIL: next page appeared before the close ended
execute unless score HPWW_Test_A SettingsMenuStatus matches 1 run say HPWW_FIELD_GUIDE_FAIL: guide closed between pages
schedule function release_fg:wheel_ready 18t replace
`;
  entries.wheel_ready = `execute if entity @e[tag=aj.field_guide_gui.root] run say HPWW_FIELD_GUIDE_FAIL: previous page rig survived the switch
execute unless entity @e[tag=aj.fg_spell_wheel.root] run say HPWW_FIELD_GUIDE_FAIL: next page never opened
execute positioned 1.0 100 2.0 unless entity @e[tag=aj.fg_spell_wheel.root,distance=..0.000001] run say HPWW_FIELD_GUIDE_FAIL: wheel moved away from the anchor
execute unless entity @e[tag=aj.fg_spell_wheel.root,nbt={Rotation:[0f,0f]}] run say HPWW_FIELD_GUIDE_FAIL: wheel turned from the anchor
execute as HPWW_Test_A at @s run function release_fg:test_wheel
${testOverlay ? aimAt('wheel_slot_2') + '\nschedule function release_fg:wheel_hover 3t replace' : 'function release_fg:leave_wheel'}
`;
  entries.wheel_hover = `execute unless entity ${hasOverlay('wheel')} run say HPWW_FIELD_GUIDE_FAIL: aiming at a top-row slot did not show the controls
execute if entity ${hasOverlay('drawer')} run say HPWW_FIELD_GUIDE_FAIL: drawer controls overlapped with the top-row controls
execute if entity @a[name=HPWW_Test_B,tag=hpww.fg.wheel_controls] run say HPWW_FIELD_GUIDE_FAIL: controls were activated for the other player
${aimAt('drawer_slot_2')}
schedule function release_fg:drawer_hover 3t replace
`;
  entries.drawer_hover = `execute unless entity ${hasOverlay('drawer')} run say HPWW_FIELD_GUIDE_FAIL: an empty drawer slot did not show the controls
execute if entity ${hasOverlay('wheel')} run say HPWW_FIELD_GUIDE_FAIL: the top-row controls stayed on while hovering over the drawer
execute if entity @a[name=HPWW_Test_B,tag=hpww.fg.drawer_controls] run say HPWW_FIELD_GUIDE_FAIL: drawer controls were activated for the other player
${aimAt('drawer_slot_8')}
schedule function release_fg:bottom_drawer_hover 3t replace
`;
  entries.bottom_drawer_hover = `execute unless entity ${hasOverlay('drawer')} run say HPWW_FIELD_GUIDE_FAIL: a bottom-row drawer slot did not show the controls
rotate HPWW_Test_A 0 -90
schedule function release_fg:outside_hover 3t replace
`;
  entries.outside_hover = `${noOverlays}
${aimAt('wheel_slot_3')}
schedule function release_fg:wheel_hover_again 3t replace
`;
  entries.wheel_hover_again = `execute unless entity ${hasOverlay('wheel')} run say HPWW_FIELD_GUIDE_FAIL: controls did not come back on another top-row slot
${aimAt('drawer_slot_5')}
schedule function release_fg:leave_wheel 3t replace
`;
  entries.leave_wheel = `${testOverlay ? `execute unless entity ${hasOverlay('drawer')} run say HPWW_FIELD_GUIDE_FAIL: drawer controls were not shown before switching pages` : ''}
execute as @e[type=interaction,tag=aj.fg_spell_wheel.interaction.exit_interaction,limit=1] at @s run function release_fg:owner_click_back
${testOverlay ? noOverlays : ''}
schedule function release_fg:back_to_main 20t replace
`;
  entries.owner_click_back = `data modify entity @s interaction set value {player:[I;0,0,0,0],timestamp:0L}
data modify entity @s interaction.player set from entity HPWW_Test_A UUID
function aj:fg_spell_wheel/interactions/exit_interaction_on_interact
data remove entity @s interaction
`;
  entries.test_wheel = `
function release_fg:page_arrows
advancement revoke @s only hpww:spells/unlocked/lumos_unlocked
function hpww:main/field_guide/api/spell_wheel/register_spell {spell:"lumos",page:10,slot:8}
function hpww:main/field_guide/api/spell_wheel/show_drawer_page {page:10}
execute unless entity @e[tag=aj.fg_spell_wheel.bone.d_slot_8,distance=..3,nbt={item:{components:{"minecraft:item_model":"hpww:field_guide/drawer/lumos","minecraft:custom_model_data":{strings:["slot_8_locked"]}}}}] run say HPWW_FIELD_GUIDE_FAIL: locked slot 8 model not applied
function hpww:main/field_guide/gui/spell_wheel_page/bind/select_drawer_spell {slot:8}
execute if score @s hpww.drawer_selected_slot matches 8 run say HPWW_FIELD_GUIDE_FAIL: locked spell could be selected
function release_fg:test_drawer_messages
advancement grant @s only hpww:spells/unlocked/lumos_unlocked
execute as @e[type=interaction,tag=aj.fg_spell_wheel.interaction.drawer_slot_8_interaction,distance=..4,limit=1] at @s run function release_fg:owner_click_slot_8
execute unless score @s hpww.drawer_selected_slot matches 8 run say HPWW_FIELD_GUIDE_FAIL: unlocked slot 8 could not be selected
execute unless entity @e[tag=aj.fg_spell_wheel.bone.d_slot_8,distance=..3,nbt={item:{components:{"minecraft:item_model":"hpww:field_guide/drawer/lumos","minecraft:custom_model_data":{strings:["slot_8_selected"]}}}}] run say HPWW_FIELD_GUIDE_FAIL: selected slot 8 model not applied
function hpww:main/field_guide/gui/spell_wheel_page/bind/generate_bind_api {slot:4}
function pdb:get_me_cached
execute unless data storage pdb:main out.spell_wheel_data.spells.page_1.slot_4{Spell:"lumos"} run say HPWW_FIELD_GUIDE_FAIL: drawer slot 8 did not bind to wheel slot 4
execute unless entity @e[tag=aj.fg_spell_wheel.bone.w_slot_4,distance=..3,nbt={item:{components:{"minecraft:item_model":"hpww:field_guide/drawer/lumos","minecraft:custom_model_data":{strings:["wheel_4"]}}}}] run say HPWW_FIELD_GUIDE_FAIL: bound wheel slot did not display spell
`;
  const attackDrawer = (slot, player) =>
    `execute as @e[type=interaction,tag=aj.fg_spell_wheel.interaction.drawer_slot_${slot}_interaction,distance=..4,limit=1] at @s run function release_fg:drawer_attack_${player}`;
  entries.test_drawer_messages = `data modify storage hpww:gobal_spell_data lumos.drawer_message set value [{text:"HPWW_DRAWER_TEST_LUMOS "},{selector:"@s"}]
data modify storage hpww:gobal_spell_data levioso.drawer_message set value {text:"HPWW_DRAWER_TEST_LEVIOSO"}
${attackDrawer(8, 'a')}
${attackDrawer(7, 'a')}
function hpww:main/field_guide/api/spell_wheel/show_drawer_page {page:4}
${attackDrawer(1, 'a')}
function hpww:main/field_guide/api/spell_wheel/register_spell {spell:"levioso",page:9,slot:8}
function hpww:main/field_guide/api/spell_wheel/show_drawer_page {page:9}
${attackDrawer(8, 'a')}
tp HPWW_Test_B 3.0 100 0.5 0 0
${attackDrawer(8, 'b')}
execute if score @s hpww.drawer_selected_slot matches 1..8 run say HPWW_FIELD_GUIDE_FAIL: inspecting a spell changed the drawer selection
function hpww:main/field_guide/api/spell_wheel/show_drawer_page {page:10}
`;
  for (const player of ['a', 'b']) {
    const name = 'HPWW_Test_' + player.toUpperCase();
    entries['drawer_attack_' + player] = `data modify entity @s attack set value {player:[I;0,0,0,0],timestamp:0L}
data modify entity @s attack.player set from entity ${name} UUID
execute store result entity @s attack.timestamp long 1 run time query gametime
execute as ${name} at @s run function animated_java:global/interactions/attack/on
execute if data entity @s attack run say HPWW_FIELD_GUIDE_FAIL: drawer attack was not dispatched
data remove entity @s attack
`;
  }
  entries.back_to_main = `execute unless entity @e[tag=aj.field_guide_gui.root] run say HPWW_FIELD_GUIDE_FAIL: main page never reopened
execute positioned 1.0 100 2.0 unless entity @e[tag=aj.field_guide_gui.root,distance=..0.000001] run say HPWW_FIELD_GUIDE_FAIL: main moved away from the anchor
data modify storage release_fg:test actual_rotation set from entity @e[tag=aj.field_guide_gui.root,limit=1] Rotation
execute store success score #changed hpww.fg.work run data modify storage release_fg:test actual_rotation set from storage release_fg:test main_rotation
execute if score #changed hpww.fg.work matches 1 run say HPWW_FIELD_GUIDE_FAIL: returning to main changed the original rotation
execute as HPWW_Test_A at @s run function hpww:main/field_guide/api/open {page:"spell_wheel"}
execute as HPWW_Test_A at @s run function hpww:main/field_guide/api/close
schedule function release_fg:after_api 20t replace
`;
  entries.after_api = `execute if entity @e[tag=hpww.fg.page_root] run say HPWW_FIELD_GUIDE_FAIL: page root survived API close
execute if score HPWW_Test_A hpww.fg.session matches 1.. run say HPWW_FIELD_GUIDE_FAIL: session survived full close
tp HPWW_Test_A 8.0 100 4.0 90 0
execute as HPWW_Test_A at @s run function hpww:main/field_guide/api/open {page:"spell_wheel"}
execute positioned 6.5 100 4.0 unless entity @e[tag=aj.fg_spell_wheel.root,distance=..0.000001,nbt={Rotation:[90f,0f]}] run say HPWW_FIELD_GUIDE_FAIL: reopening reused the old anchor
execute as HPWW_Test_A at @s run function hpww:main/field_guide/api/close
schedule function release_fg:after_reopen 20t replace
`;
  entries.after_reopen = `execute if entity @e[tag=hpww.fg.page_root] run say HPWW_FIELD_GUIDE_FAIL: immediate close during open left a page behind
say HPWW_FIELD_GUIDE_DONE
`;
  entries.owner_click_slot_8 = `data modify entity @s interaction set value {player:[I;0,0,0,0],timestamp:0L}
data modify entity @s interaction.player set from entity HPWW_Test_A UUID
function aj:fg_spell_wheel/interactions/drawer_slot_8_interaction_on_interact
data remove entity @s interaction
`;
  const arrowCases = [
    ['d_left', 'drawer_page', 10],
    ['d_left', 'drawer_page', 9],
    ['d_right', 'drawer_page', 10],
    ['d_right', 'drawer_page', 1],
    ['sp_left', 'wheel_page', 1],
    ['sp_right', 'wheel_page', 2],
    ['sp_left', 'wheel_page', 1],
  ];
  entries.page_arrows = arrowCases.map(([arrow, objective, expected]) =>
    `execute as @e[type=interaction,tag=aj.fg_spell_wheel.interaction.${arrow}_arrow_interaction,distance=..4,limit=1] at @s run function release_fg:click_${arrow}
execute unless score @s hpww.fg.spell_wheel_page.${objective} matches ${expected} run say HPWW_FIELD_GUIDE_FAIL: ${arrow} arrow did not reach page ${expected}
`).join('');
  for (const arrow of new Set(arrowCases.map(([arrow]) => arrow))) {
    entries['click_' + arrow] = `data modify entity @s interaction set value {player:[I;0,0,0,0],timestamp:0L}
data modify entity @s interaction.player set from entity HPWW_Test_A UUID
function aj:fg_spell_wheel/interactions/${arrow}_arrow_interaction_on_interact
data remove entity @s interaction
`;
  }
}
for (const [name, text] of Object.entries(entries)) fs.writeFileSync(path.join(functions, name + '.mcfunction'), text);
fs.writeFileSync(path.join(root, 'eula.txt'), 'eula=true\n');

async function main() {
  const probe = net.createServer();
  await new Promise(resolve => probe.listen(0, '127.0.0.1', resolve));
  const port = probe.address().port;
  await new Promise(resolve => probe.close(resolve));
  fs.writeFileSync(path.join(root, 'server.properties'), [
    'server-ip=127.0.0.1', `server-port=${port}`, 'online-mode=false', 'white-list=false',
    'max-players=2', 'view-distance=2', 'simulation-distance=2', 'spawn-protection=0',
    'level-type=minecraft:flat', 'max-tick-time=0', 'pause-when-empty-seconds=0',
    'generator-settings={"layers":[{"block":"minecraft:bedrock","height":1}],"biome":"minecraft:plains","structures":{}}',
  ].join('\n') + '\n');
  const server = spawn('java', ['-Xms256M', '-Xmx2G', '-jar', path.join(work, 'vanilla/1.21.11-server.jar'), 'nogui'],
    { cwd: root, stdio: ['pipe', 'pipe', 'pipe'] });
  const clients = [];
  const failures = [];
  const drawerMessages = [];
  const log = fs.createWriteStream(path.join(root, 'test.log'));
  let connected = 0;
  let completed = false;
  let started = false;
  let stopping = false;
  const command = line => server.stdin.write(line + '\n');
  const stop = () => {
    if (stopping) return;
    stopping = true;
    for (const client of clients) client.end('Test completed');
    command('stop');
  };
  function connect() {
    for (const username of ['HPWW_Test_A', 'HPWW_Test_B']) {
      const client = protocol.createClient({host: '127.0.0.1', port, username, auth: 'offline', version: '1.21.11'});
      clients.push(client);
      client.on('position', packet => client.write('teleport_confirm', {teleportId: packet.teleportId}));
      client.on('system_chat', packet => {
        if (packet.isActionBar) return;
        const text = JSON.stringify(simplify(packet.content));
        if (text.includes('HPWW_DRAWER_TEST_')) drawerMessages.push({username, text});
      });
      client.once('login', () => {
        console.log(`${username} connected`);
        if (++connected === 2) setTimeout(() => command('function release_fg:setup'), 1000);
      });
      client.on('error', error => {
        failures.push(username + ': ' + error.message);
        console.error(error.message);
        stop();
      });
      client.on('end', reason => {
        if (!stopping) {
          failures.push(username + ' disconnected: ' + reason);
          stop();
        }
      });
    }
  }
  function lineReceived(line) {
    log.write(line + '\n');
    if (/HPWW_FIELD_GUIDE|\/ERROR\]|Failed to load|Couldn't parse|Done \(/.test(line)) console.log(line);
    if (/\/ERROR\]|Failed to load|Couldn't parse|HPWW_FIELD_GUIDE_FAIL/.test(line) && !line.includes('Perflib 009')) failures.push(line);
    if (line.includes('Done (') && !started) { started = true; connect(); }
    if (line.includes('HPWW_FIELD_GUIDE_DONE')) { completed = true; stop(); }
  }
  readline.createInterface({input: server.stdout}).on('line', lineReceived);
  readline.createInterface({input: server.stderr}).on('line', lineReceived);
  const timeout = setTimeout(() => { failures.push('Field guide regression timed out'); stop(); }, 120000);
  const code = await new Promise(resolve => server.once('exit', resolve));
  clearTimeout(timeout);
  log.end();
  if (pageApi && completed) {
    const lumos = drawerMessages.filter(({text}) => text.includes('HPWW_DRAWER_TEST_LUMOS'));
    const levioso = drawerMessages.filter(({text}) => text.includes('HPWW_DRAWER_TEST_LEVIOSO'));
    if (lumos.length !== 2 || lumos.some(({text}) => !text.includes('HPWW_Test_A')) || levioso.length !== 1) {
      failures.push('Expected two Lumos messages with the clicker name and one Levioso message.');
    }
    if (drawerMessages.some(({username}) => username !== 'HPWW_Test_A')) {
      failures.push('Drawer message was sent to a player who did not own the drawer.');
    }
  }
  const result = {baseline, connected, completed, serverExitCode: code, drawerMessages, failures};
  fs.writeFileSync(path.join(root, 'result.json'), JSON.stringify(result, null, 2) + '\n');
  console.log(JSON.stringify(result, null, 2));
  process.exitCode = completed && connected === 2 && !failures.length ? 0 : 1;
}
main().catch(error => { console.error(error); process.exitCode = 1; });
