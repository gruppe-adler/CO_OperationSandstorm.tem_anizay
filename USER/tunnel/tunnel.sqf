/*
    File: GRAD_tunnel_fnc_init.sqf
    Original Author: Ethan Johnson
    Editing: nomisum for Gruppe Adler
    Date: 2021-05-16
    Public: Yes

    Description:
    No description added yet.

    Parameter(s):
    _position - Position [ARRAY, defaults to [0,0,0]]
    _units - List of units [ARRAY, defaults to []]

    Returns:
    NOTHING

    Example(s):
    [position this, []] call GRAD_tunnel_fnc_init
*/

// fills var TUNNEL_POSITIONS
#include "\vn\modules_f_vietnam\vn_tunnel_positions.inc"

// override mbg fnc
mbg_bugs_fnc_buginit = {
    params ["_bug"];
    if (_bug getVariable ["MBG_hasBrain", true]) then {
        [_bug] spawn mbg_bugs_fnc_bugbrain;
        [_bug, "default"] remoteExec ["switchMove"];
    };
};

mbg_bugs_fnc_bugkilled = {
     params ["_bug"];

     _bug setVectorUp [0,0,-1];
};

/*
["mbg_bug_01", "init", {
    params ["_unit"];

    [{
        params ["_unit"];
        [_unit, "default"] remoteExec ["switchMove"];

        systemChat "bla";

        private _nearestObjects = nearestObjects [_unit, [], 5];

        {
          if ((getModelInfo _x) select 0 == "shellcrater_01_f.p3d") then {
                deleteVehicle _x;
          };
        } forEach _nearestObjects;
    }, [_unit], 3] call CBA_fnc_waitUntilAndExecute;    
}, true, [], true] call CBA_fnc_addClassEventhandler;
*/


params [
    "_entryObject", 
    ["_garrison_size", 10],  
    ["_garrison_side", east],
    ["_garrison_classnames_custom", ["UK3CB_TKM_O_MD","UK3CB_TKM_O_RIF_1","UK3CB_TKM_O_RIF_2","UK3CB_TKM_O_SL","UK3CB_TKM_O_WAR","UK3CB_TKM_O_ENG","UK3CB_TKM_O_DEM","UK3CB_TKM_O_AR","UK3CB_TKM_O_AT","UK3CB_TKM_O_AT_ASST"]],
    ["_actionincode_action", "true"],
    ["_actionsearchcode_action", "true"],
    ["_actionoutcode_action", "true"],
    ["_actionincode", ""],
    ["_actionoutcode", ""]
];

private _position = position _entryObject;

// Get the original + all tunnels in the local area.
private _tunnels = nearestObjects [_position, [
    "Land_vn_tunnel_01_building_01_01", 
    "Land_vn_tunnel_01_building_04_01", 
    "Land_vn_tunnel_01_building_03_01", 
    "Land_vn_tunnel_01_building_02_01",
    "Land_vn_tunnel_01_building_02_02",
    "Land_vn_tunnel_01_building_03_04"
], 30000];

if (count _tunnels <= 0) exitWith { [format["!!! VN_TUNNEL_INIT: No tunnels found within 75m of position '%1'. Module init aborted. !!!", _position]] call bis_fnc_error; };

{
        // Save tunnel module to tunnels for outside access to saved variables-
        _x setVariable ["vn_tunnel_module", _entryObject, true];
} foreach _tunnels;

// Spawn offset
private _spawn_positions = TUNNEL_POSITIONS;

private _index = _tunnels findIf {typeOf _x == "Land_vn_tunnel_01_building_01_01"};
private _tunnel = [objnull, _tunnels#_index] select (_index >= 0);

// align Tunnels perfectly and high in sky
{
    private _tunnel = _x;
    private _position = getPosASL _tunnel;
    _position params ["_aslX", "_aslY", "_aslZ"];
    _tunnel setPosASL [_aslX, _aslY, 7000];
} foreach _tunnels;

// Block all exits
{
    private _tunnel = _x;
    {
        _tunnel animateSource [_x, 0, true];
    } foreach ["blockage_01_01_source","blockage_01_02_source","blockage_01_03_source","blockage_01_04_source"];
} foreach _tunnels;

// Get blocking points
private _blockages_array = [];
{
    private _selections = ["blockage_01_01","blockage_01_02","blockage_01_03","blockage_01_04"];
    private _tunnel = _x;
    {
        private _position = _tunnel selectionPosition _x;
        if !(_position isEqualTo [0,0,0]) then
        {
            _blockages_array pushBack ATLToASL (_tunnel modelToWorld _position);
        };
    } foreach _selections;
} foreach _tunnels;

// Unblock points that are beside each other
{
    private _tunnel = _x;
    {
        private _position = _tunnel selectionPosition (_x select [0, 14]);
        _position = ATLToASL (_tunnel modelToWorld _position);

        // Check if there is another blockage selection nearby
        private _anim = [0, 1] select (_blockages_array findIf {!(_position isEqualTo _x) && {_x distance _position <= 5}} > -1);
        [_tunnel, [_x, _anim, true]] remoteExec ["animateSource", 0, true];
    } foreach ["blockage_01_01_source","blockage_01_02_source","blockage_01_03_source","blockage_01_04_source"];
} foreach _tunnels;

_entryObject setVariable ["vn_tunnel_trapped", (random 1 < 0.05), true];
_entryObject setVariable ["vn_tunnel_tunnel_object", _tunnel, true];
_entryObject setVariable ["vn_tunnel_spawn_positions", _spawn_positions, true];

_entryObject setVariable ["vn_tunnel_trapdoor", _entryObject, true];

// Create exit object - don't trap it, that's just mean
private _position = _tunnel modelToWorld [-1.5,-4,40.75];

_tunnel setVariable ["vn_tunnel_entry_object", _entryObject, true];
_tunnel setVariable ["vn_tunnel_exit_object", _entryObject, true];

/*
private _exit_trapdoor = createVehicle ["Land_vn_o_trapdoor_02", _position, [], 0, "CAN_COLLIDE"];
_exit_trapdoor setVectorDirAndUp [[0,-1,0.0001],[0,-0.0001,-1]];
*/

private _size = 8 + (10 * _garrison_size);

// [_entryObject, _actionincode_action, _actionsearchcode_action, _actionoutcode_action, _actionincode, _actionoutcode] remoteExec ["vn_fnc_tunnel_init_actions", 0, true];
[_entryObject, _actionincode_action, _actionsearchcode_action, _actionoutcode_action, _actionincode, _actionoutcode] execVM "USER\tunnel\init_action.sqf";

[getPosATL _tunnel] remoteExec ["vn_fnc_tunnel_trigger", 0, true];

[_tunnels, _garrison_side, _size, _garrison_classnames_custom] execVM "USER\tunnel\spawnUnits.sqf";
