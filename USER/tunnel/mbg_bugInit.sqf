{
    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'mbg_bugs_fnc_bugspawn'} else {_fnc_scriptName};
    private _fnc_scriptName = 'mbg_bugs_fnc_bugspawn';
    scriptName _fnc_scriptName;

_bug = _this select 0;
_bugpos = _this select 1;
[_bug, "bug_spawn"] remoteExecCall ["switchMove"];

_bug allowFleeing 0;

_c = "Land_ShellCrater_01_F" createVehicle [0,0,0];
_c setDir (random 360);
_c setPos _bugpos;
_bug setPos getpos _c;

playSound3D ["mbg\mbg_bugs\data\sounds\earthcrumble.ogg", _bug, false, getPosASL _bug, 4,1, 40];

[_bug] spawn mbg_bugs_fnc_bugbrain;}