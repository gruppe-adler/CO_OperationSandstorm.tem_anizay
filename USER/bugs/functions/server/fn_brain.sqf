/*

    original fnc by MBG mondkalb
    adapted to CBA PFH by nomisum 2021

*/

params ["_bug"];

private _loopCount = 10;

[{  
    params ["_args", "_handle"];
    _args params ["_bug"];

    if (!alive _bug) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    if (!(_bug getVariable ["GRAD_bugs_actionRunning", false])) then {

        // fix amount of steps looping
        private _loopCount = _bug getVariable ["GRAD_bugs_loopcount", 0];
        if (_loopCount < 10) then {
            _loopCount = _loopCount + 1;
        } else {
            0
        };
        _bug setVariable ["GRAD_bugs_loopcount", _loopCount];

        if (_loopCount > 5) then
        {
            private _bugs = [];
            if (_bug getVariable ["GRAD_bugs_attacksOpfor", false]) then {
                _bugs = (ASLToAGL getPosASL _bug nearEntities [["mbg_bug_unit_base"], 50]);
            } else {
                _bugs = (ASLToAGL getPosASL _bug nearEntities [["mbg_bug_unit_base", "O_Soldier_F"], 50]);
            };
            _list = (ASLToAGL getPosASL _bug nearEntities [["CAManBase", "Car", "Tank"], 50])-[_bug]-_bugs;

            if (count _list > 0) then
            {
                _target = selectRandom _list;
                _bug doWatch _target;
                _bug doTarget _target;
                _bug lookAt _target;
                _bug doMove getpos _target;
            };
                _loopCount = 0;
        };

        _bug allowFleeing 0;

        private _bugs = [];
        if (_bug getVariable ["canAttackOpfor", false]) then {
            _bugs = (ASLToAGL getPosASL _bug nearEntities [["mbg_bug_unit_base"], 5]);
        } else {
            _bugs = (ASLToAGL getPosASL _bug nearEntities [["mbg_bug_unit_base", "O_Soldier_F"], 5]);
        };
        _list = (ASLToAGL getPosASL _bug nearEntities [["CAManBase", "Car", "Tank"], 5])-[_bug]-_bugs;

        if (count _list > 0) then {
            _target = selectRandom _list;

            if (_target distance _bug < 2) then {
                    [_bug, "bug_attack"] remoteExecCall ["switchMove"];
                    private _sound = selectRandom ["mbg\mbg_bugs\data\sounds\attack1.ogg","mbg\mbg_bugs\data\sounds\attack2.ogg","mbg\mbg_bugs\data\sounds\attack3.ogg","mbg\mbg_bugs\data\sounds\attack4.ogg","mbg\mbg_bugs\data\sounds\attack5.ogg","mbg\mbg_bugs\data\sounds\attack6.ogg"];
                    playSound3D [_sound, _bug, false, getPosASL _bug, 4,2, 20];

                    if (_target isKindOf "Man") then {
                        private _injuredBodyPart = ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"] selectRandomWeighted [0.3, 0.1, 0.2, 0.2, 0.3, 0.3];
                        private _currentUnitDamage = _target getHitpointDamage _injuredBodyPart;
                        private _damageAmount = (_currentUnitDamage + random 1) max (_currentUnitDamage + 0.3);
                        [_target, _damageAmount, _injuredBodyPart, "bullet", objNull] call ace_medical_fnc_addDamageToUnit;
                    } else {
                        private _damage = damage _target;
                        _target setDamage (_damage + 0.1);
                    };

                    _bug setVariable ["GRAD_bugs_actionRunning", true];

                    [{
                        params ["_bug"];

                        _bug setVariable ["GRAD_bugs_actionRunning", false];
                    }, [_bug], 1.5] call CBA_fnc_waitAndExecute;
                };
        };

    };

}, .5, [_bug]] call CBA_fnc_addPerFrameHandler;
