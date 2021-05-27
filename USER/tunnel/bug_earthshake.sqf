/*
    Author: Zozo
    
    Description:
    Earthquake simulation - now just camera shake and sound
    
    Parameter(s):
    _this select 0: INT - intensity {1,2,3,4}   
    
    Returns:
    NONE
    
*/
private ["_magnitude", "_power", "_duration", "_frequency", "_offset", "_compensation", "_eqsound", "_fatiguedefault", "_fatigue"];
params ["_bug"];

private _distance = _bug distance2d player;
if (_distance > 400) exitWith {}; // no effect far away
if (objectParent player isKindOf "Air") exitWith {}; // no effect in air vehicles

_magnitude = if (_distance <= 400) then { 1 } else { 
    if (_distance < 300) then { 2 } else { 
        if (_distance < 200) then { 3 } else { 
            if (_distance < 100) then { 4 }
        };
    };
};

_power = 0.3;
_duration = 13;
_frequency = 100;  
_offset = 0;
_eqsound = "Earthquake_01";
_compensation = 0;
_fatigue = 0.2; 
if( isNil "BIS_fnc_earthquake_inprogress" ) then {BIS_fnc_earthquake_inprogress = false; };

waitUntil{ !BIS_fnc_earthquake_inprogress };

switch( _magnitude ) do
{
    case 1: 
    {
        _power = 0.5;
        _duration = 13;
        _compensation = 4;
        _frequency = 200;
        _eqsound = "Earthquake_01";
        _fatigue = 0.4; 
    };
    case 2: 
    {
        _power = 0.8;
        _duration = 13;
        _compensation = 8.5;
        _frequency = 50; 
        _eqsound = "Earthquake_02";
        _fatigue = 0.6;
    };
    case 3: 
    {
        _power = 1.5;
        _duration = 13;
        _compensation = 7;
        _frequency = 40;    
        _eqsound = "Earthquake_03";
        _fatigue = 0.8; 
    };
    case 4: 
    {
        _power = 2.1;
        _duration = 13;
        _compensation = 6;
        _frequency = 30;
        _eqsound = "Earthquake_04";
        _fatigue = 1;       
    };
    default { [ "EarthQuake: number not defined, using default shake" ] call BIS_fnc_Log; }
};  
enableCamShake true;
BIS_fnc_earthquake_inprogress = true;
playsound _eqsound;
Sleep _offset;
addCamShake [_power, _duration, _frequency];

Sleep ( _duration - _compensation );

Sleep 3;
BIS_fnc_earthquake_inprogress = false;



