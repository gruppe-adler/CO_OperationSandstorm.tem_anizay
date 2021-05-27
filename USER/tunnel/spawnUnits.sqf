params
[
    ["_tunnels", [], [[]]],
    ["_side", east, [east]],
    ["_count", 16, [16]],
    ["_classnames", [], [[]]]
];


if (count _tunnels <= 0) exitWith { grpnull };
if (count _classnames <= 0) exitWith { grpnull };
if (_count <= 0) exitWith { grpnull };

{
    private _amount = ceil (_count/count _tunnels);
    private _positions = _x buildingPos -1;
    private _spawn = _x modelToWorld (_x selectionPosition "vn_tunnel_exit");

    for "_i" from 1 to _amount do
    {
        if (count _positions > 0) then
        {
            private _classname = selectRandom _classnames;
            private _position = selectRandom _positions;
            _positions deleteAt (_positions findIf {_x isEqualTo _position});

            while {_position distance _spawn <= 8 && {count _positions > 0}} do
            {
                _position = selectRandom _positions;
                _positions deleteAt (_positions findIf {_x isEqualTo _position});
            };

            if (count _positions > 0) then
                {
                    private _group = createGroup _side;
                    private _unit = _group createUnit [_classname, _position, [], 0, "CAN_COLLIDE"];
                    _unit setPosATL _position;
                    [_unit, "default"] remoteExec ["switchMove"];
                    doStop _unit;
                    _group deleteGroupWhenEmpty true;
                    _group enableDynamicSimulation true;
                };
            };
        };
} foreach _tunnels;

