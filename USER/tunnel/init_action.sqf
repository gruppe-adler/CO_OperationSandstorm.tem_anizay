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

private _enter_condition = "_this distance _target <= 4 && {%1}";

missionNamespace setVariable ["vn_tunnel_init_actionincode", compileFinal _actionincode];
missionNamespace setVariable ["vn_tunnel_init_actionoutcode", compileFinal _actionoutcode];

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
    missionNamespace setVariable ["vn_tunnel_entry_data", [getPosATL (_this#1), direction (_this#1)]];

    private _spawn_tunnel = (_this#0) getVariable ["vn_tunnel_tunnel_object", objNull];
    private _spawn_positions = (_this#0) getVariable ["vn_tunnel_spawn_positions", []];
    // [[-2.09985,-2.83984,37.2],[-3.09985,-2.83984,37.2],[-4.09985,-2.83984,37.2],[-2.09985,-3.83984,37.2],[-3.09985,-3.83984,37.2],[-4.09985,-3.83984,37.2],[-2.09985,-4.83984,37.2],[-3.09985,-4.83984,37.2],[-4.09985,-4.83984,37.2],[-2.09985,-5.83984,37.2],[-3.09985,-5.83984,37.2],[-4.09985,-5.83984,37.2],[-2.09985,-6.83984,37.2],[-3.09985,-6.83984,37.2],[-4.09985,-6.83984,37.2]]
    private _position = (_spawn_positions select 0);
    _position params ["_posX", "_posY", "_posZ"];
    /*
    private _spawn_tunnel = cursorObject getVariable ["vn_tunnel_tunnel_object", objNull];
    player setPosATL _spawn_tunnel modelToWorld [-2.09985,-2.83984,37.2];
    */
    (_this#1) setPosATL (_spawn_tunnel modelToWorld [-2.09985,-2.83984,36.75]);
    (_this#1) setDir getDir _spawn_tunnel;
    
    [{
        animationState player == "halofreefall_non"
    }, {
        [player, ""] remoteExec ["switchMove"];
    }, []] call CBA_fnc_waitUntilAndExecute;

    call (missionNamespace getVariable ["vn_tunnel_init_actionincode", {true}]);

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
