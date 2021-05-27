params ["_bug"];

[_bug, 0.2] remoteExec ["setAnimSpeedCoef"];
_bug setVariable ["MBG_hasBrain", false];
_bug setVariable ["MBG_rising", true];
[_bug, "bug_spawn"] remoteExec ["switchMove"];
_bug disableAI "ALL";
_bug enableAI "ANIM";
_bug enableAI "MOVE";
_bug allowDamage false;

[{
    params ["_args", "_handle"];
    _args params ["_bug"];

    _bug setObjectScale 10;

}, 0, [_bug]] call CBA_fnc_addPerFrameHandler;


[{
    params ["_args", "_handle"];
    _args params ["_bug"];

    [[_bug], "USER\tunnel\big_bug_fx.sqf"] remoteExec ["BIS_fnc_execVM"];

    // systemChat "animDone";

    private _rising = _bug getVariable ["MBG_rising", false];

    private _sound = selectRandom
    [
        (getMissionPath "USER\tunnel\growl_1.ogg"),
        (getMissionPath "USER\tunnel\growl_2.ogg"),
        (getMissionPath "USER\tunnel\growl_3.ogg")
    ];

    if (!_rising) then {
        [_bug, 0.2] remoteExec ["setAnimSpeedCoef"];
        [_bug, "bug_spawn"] remoteExec ["switchMove"];
        _bug setVariable ["MBG_rising", true];
        [[_bug], "USER\tunnel\bug_earthshake.sqf"] remoteExec ["BIS_fnc_execVM"];

        playSound3D [_sound, _bug];

        [{
            params ["_sound", "_bug"];
            playSound3D [_sound, _bug];
        }, [_sound, _bug], 6] call CBA_fnc_waitAndExecute;
    };

    if (_rising) then {
        [_bug, -0.2] remoteExec ["setAnimSpeedCoef"];
        _bug setVariable ["MBG_rising", false];
        [[_bug], "USER\tunnel\bug_earthshake.sqf"] remoteExec ["BIS_fnc_execVM"];

        playSound3D [_sound, _bug];

        [{
            params ["_sound", "_bug"];
            playSound3D [_sound, _bug];
        }, [_sound, _bug], 6] call CBA_fnc_waitAndExecute;
    };

}, 13, [_bug]] call CBA_fnc_addPerFrameHandler;

