{
    private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'mbg_bugs_fnc_bugkilled'} else {_fnc_scriptName};
    private _fnc_scriptName = 'mbg_bugs_fnc_bugkilled';
    scriptName _fnc_scriptName;

_this spawn
{
sleep 0.1;
_unit = _this;
if local _unit then
{
[_unit, getpos _unit] spawn mbg_bugs_fnc_bugspawn;
};






};}