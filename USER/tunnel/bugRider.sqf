params ["_bug"];

private _group = group _bug;
private _unit = _group createUnit ["UK3CB_TKM_O_RIF_1", [0,0,0], [], 0, "NONE"];
_unit attachTo [_bug, [0.05,0.05,0.1], "core1", true];

_bug setVariable ["bugRider", _unit];

[_unit, "Acts_HeliCargoTalking_out"] remoteExec ["switchMove"];

_unit addEventHandler ["AnimDone", {
    params ["_unit"];

    if (!alive _unit) exitWith {
        _unit removeEventHandler ["AnimDone", _thisEventhandler];
    };
    [_unit, "Acts_HeliCargoTalking_out"] remoteExec ["switchMove"];
}];