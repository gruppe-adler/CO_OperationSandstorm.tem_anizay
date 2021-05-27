    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'VN_fnc_tunnel_init_actions'} else {_fnc_scriptName};
    private _fnc_scriptName = 'VN_fnc_tunnel_init_actions';
    scriptName _fnc_scriptName;




















params
[
["_tunnel_trapdoor", objNull, [objNull]],
["_actionincode_action", "true", [""]],
["_actionsearchcode_action", "true", [""]],
["_actionoutcode_action", "true", [""]],
["_actionincode", "true", [""]],
["_actionoutcode", "true", [""]]
];

if !hasInterface exitWith {};
if (isNull _tunnel_trapdoor) exitwith {};
if !canSuspend exitwith { _this spawn vn_fnc_tunnel_init_actions };
waitUntil {time > 0};

private _open_condition = "_this distance _target <= 4 && {_target animationSourcePhase 'door1_sound_source' == 0}";
private _close_condition = "_this distance _target <= 4 && {_target animationSourcePhase 'door1_sound_source' == 1}";
private _search_condition = "_this distance _target <= 4 && {_target animationSourcePhase 'door1_sound_source' == 1 && {%1}}";
private _enter_condition = "_this distance _target <= 4 && {_target animationSourcePhase 'door1_sound_source' == 1 && {%1}}";

missionNamespace setVariable ["vn_tunnel_init_actionincode", compileFinal _actionincode];
missionNamespace setVariable ["vn_tunnel_init_actionoutcode", compileFinal _actionoutcode];


[
_tunnel_trapdoor,
localize "STR_VN_TUNNEL_OPEN_ACTION",
"\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unloadDevice_ca.paa",
"\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unloadDevice_ca.paa",
_open_condition,
_open_condition,
{

},
{

},
{

_this#0 animateSource ["door1_sound_source", 1];
},
{

},
[],
0.5,
20,
false,
false,
true
] call BIS_fnc_holdActionAdd;


[
_tunnel_trapdoor,
localize "STR_VN_TUNNEL_CLOSE_ACTION",
"\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa",
"\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa",
_close_condition,
_close_condition,
{

},
{

},
{

_this#0 animateSource ["door1_sound_source", 0];
},
{

},
[],
0.5,
20,
false,
false,
true
] call BIS_fnc_holdActionAdd;


[
_tunnel_trapdoor,
localize "STR_VN_TUNNEL_SEARCH_ACTION",
"\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa",
"\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa",
format[_search_condition, _actionsearchcode_action],
format[_search_condition, _actionsearchcode_action],
{

},
{

},
{

if ((_this#0) getVariable ["vn_tunnel_trapped",false]) then
{
private _trap_check = (random 1 < 0.75);
if !_trap_check then
{
[_this#1] call vn_fnc_tunnel_spawn_trap;
systemchat localize "STR_VN_TUNNEL_SEARCH_ACTION_01";
}
else
{
systemchat localize "STR_VN_TUNNEL_SEARCH_ACTION_02";
};
(_this#0) setVariable ["vn_tunnel_trapped", false, true];
}
else
{
systemchat localize "STR_VN_TUNNEL_SEARCH_ACTION_03";
};
},
{

},
[],
4,
21,
false,
false,
true
] call BIS_fnc_holdActionAdd;


[
    _tunnel_trapdoor,
    localize "STR_VN_TUNNEL_ENTER_ACTION",
    "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa",
    format[_enter_condition, _actionincode_action],
    format[_enter_condition, _actionincode_action],
    {

    },
    {

    },
    {

    diag_log "log before enter";

    if ((_this#0) getVariable ["vn_tunnel_trapped",false]) then
    {
        [_this#1] call vn_fnc_tunnel_spawn_trap;
        (_this#0) setVariable ["vn_tunnel_trapped", false, true];
        diag_log "trap before enter";
    }
    else
    {
        diag_log "enter before enter";
        missionNamespace setVariable ["vn_tunnel_entry_data", [getPosATL (_this#1), direction (_this#1)]];

        private _spawn_tunnel = (_this#0) getVariable ["vn_tunnel_tunnel_object", objNull];
        private _spawn_positions = (_this#0) getVariable ["vn_tunnel_spawn_positions", []];
        (_this#1) setPosATL (_spawn_tunnel modelToWorld (selectRandom _spawn_positions));
        (_this#1) setDir getDir _spawn_tunnel;
        (_this#1) attachTo [_spawn_tunnel];
        detach (_this#1);
        (_this#1) switchMove "";

        diag_log format ["line 188 %1 %2", _spawn_tunnel, _spawn_positions];

        call (missionNamespace getVariable ["vn_tunnel_init_actionincode", {true}]);
    };
    },
    {

    },
    [],
    1,
    22,
    false,
    false,
    true
] call BIS_fnc_holdActionAdd;


missionNamespace setVariable
[
    "vn_tunnel_exit_condition",
    compile _actionoutcode_action
];

true
