/*
    execVM "USER\sandstorm\testEmitter.sqf";
*/

private _particleSource = "#particlesource" createVehicleLocal (player getPos [10,10]);
_particleSource setParticleCircle [0, [0, 0, 0]];
_particleSource setParticleRandom [0.2, [1, 1, 0], [0.5, 0.5, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_particleSource setParticleParams [["\x\grad_sandstorm\addons\particle\p3d\sandparticle.p3d", 10, 0, 100, 0], "", "Billboard", 
1, 4, [0, 0, 0], [0,0,0], 0, 0.35, 0.30, 0.40, [
                        30,
                        30,
                        30,
                        30,
                        30,
                        30,
                        30,
                        30,
                        30,
                        30,
                        30,
                        30
                    ], [
                        [0,0,0,0],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,1],
                        [0.4,0.3,0.3,0.7],
                        [0.4,0.3,0.3,0.2],
                        [0.4,0.3,0.3,0]
                    ], [0.01*25], 0, 0, "", "", _particleSource];
_particleSource setDropInterval 1;

_particleSource attachTo [player, [1,105,1]];

[{
    params ["_particleSource"];

    deleteVehicle _particleSource;
}, [_particleSource], 10] call CBA_fnc_waitAndExecute;