{
    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'mbg_bugs_fnc_bugbrain'} else {_fnc_scriptName};
    private _fnc_scriptName = 'mbg_bugs_fnc_bugbrain';
    scriptName _fnc_scriptName;

_bug = _this select 0;
_bfcd = 10;
while {alive _bug} do
{

if (_bfcd > 5) then
{
_bugs = (ASLToAGL getPosASL _bug nearEntities [["mbg_bug_unit_base"], 50]);
_list = (ASLToAGL getPosASL _bug nearEntities [["CAManBase", "Car", "Tank"], 50])-[_bug]-_bugs;
if (count _list > 0) then
{
_t = selectRandom _list;
_bug doWatch _t;
_bug doTarget _t;
_bug lookAt _t;
_bug doMove getpos _t;
};
_bfcd = 0;
};

_bug allowFleeing 0;
_bugs = (ASLToAGL getPosASL _bug nearEntities [["mbg_bug_unit_base"], 5]);
_list = (ASLToAGL getPosASL _bug nearEntities [["CAManBase", "Car", "Tank"], 5])-[_bug]-_bugs;
if (count _list > 0) then
{
_t = selectRandom _list;
if (_t distance _bug < 2) then
{
[_bug, "bug_attack"] remoteExecCall ["switchMove"];
_s = selectRandom ["mbg\mbg_bugs\data\sounds\attack1.ogg","mbg\mbg_bugs\data\sounds\attack2.ogg","mbg\mbg_bugs\data\sounds\attack3.ogg","mbg\mbg_bugs\data\sounds\attack4.ogg","mbg\mbg_bugs\data\sounds\attack5.ogg","mbg\mbg_bugs\data\sounds\attack6.ogg"];
playSound3D [_s, _bug, false, getPosASL _bug, 4,2, 20];
_d = damage _t;
_t setDamage (_d + 0.1);
sleep 1.5; 
};
};

_bfcd = _bfcd + 1;
sleep 0.5;
};}