params ["_unit", "_destinationPosition", "_index", "_duration"];

private _currentPosition = getPos _unit;

drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",1,5,[1,1,0],[0,0,0],0,9,7,0,[.5,.5],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_unit];

private _position = getPos _unit;
private _firefly = "#particlesource" createVehicleLocal _position;
_firefly setParticleCircle [.5,[0,0,0]];
_firefly setParticleRandom [0,[0,0,0],[0,0,0],0,0,[0,0,0,0],1,0];
_firefly setParticleParams [["\A3\data_f\proxies\muzzle_flash\mf_machineGun_Cheetah.p3d",1,0,1],"","SpaceObject",1,1,[0,0,0],[0,0,2],3,1.3,1,0,[0.1,0.1],[[1,1,1,1],[0,0,0,0]],[0],0,0,"","",_firefly, 0,true,0,[[255,255,255,10],[255,0,0,0]],[0,1,0]];
_firefly setDropInterval 0.001;
_firefly attachTo [_unit, [0,0,-1]];


private _beam = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getPosWorld _unit, true];
getPosWorld _unit params ["_xPos", "_yPos"];
_beam setPos [_xPos, _yPos, 2];
[_beam, 90, 0] call BIS_fnc_setPitchBank;

[getpos _unit] call GRAD_VM_teleport_fnc_despawnEffect;

// park unit off map for tunnel fx
_unit setPos [_index * -1000, _index * -1000, 0];


_unit setVariable ["grad_VM_teleportDone", false];
[[-100,1000*index,1000], _duration] call GRAD_VM_teleport_fnc_wormHole;



[{
        params ["_firefly"];
        deleteVehicle _firefly;
}, [_firefly], 1.7] call CBA_fnc_waitAndExecute;

[{
    params ["_currentPosition", "_destinationPosition", "_unit", "_beam"];
    _currentPosition distance2d _unit > 200
},{
    params ["_currentPosition", "_destinationPosition", "_unit", "_beam"];

    deleteVehicle _beam;

    drop [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",1,1,[1,1,0],[0,0,0],0,9,7,0,[2,2,2,.1],[[0,0,0,0],[0,0,0,1],[0,0,0,0]],[1],0,0,"","",_unit];

    _currentPosition params ["_posX", "_posY"];

    private _lightPoint = "#lightpoint" createvehiclelocal [_posX, _posY, 1];
    _lightPoint setLightDayLight true;_lightPoint setLightUseFlare true;
    _lightPoint setLightFlareSize 10; _lightPoint setLightFlareMaxDistance 5000;
    _lightPoint setLightAmbient[0.5,0.5,1]; _lightPoint setLightColor[0.9,0.7,0.9];
    _lightPoint setLightAttenuation [0, 0, 0, 0, 0, 4000];
    _lightPoint setLightBrightness 3;

    [{
            params ["_lightPoint"];
            deleteVehicle _lightPoint;
    }, [_lightPoint], 0.2] call CBA_fnc_waitAndExecute;

    getPos _unit params ["_posXNew", "_posYNew"];

    private _lightPoint = "#lightpoint" createvehiclelocal [_posXNew, _posYNew, 1];
    _lightPoint setLightDayLight true;_lightPoint setLightUseFlare true;
    _lightPoint setLightFlareSize 10; _lightPoint setLightFlareMaxDistance 5000;
    _lightPoint setLightAmbient[0.5,0.5,1]; _lightPoint setLightColor[0.9,0.7,0.9];
    _lightPoint setLightAttenuation [0, 0, 0, 0, 0, 4000];
    _lightPoint setLightBrightness 3;

    [{
            params ["_lightPoint"];
            deleteVehicle _lightPoint;
    }, [_lightPoint], 0.2] call CBA_fnc_waitAndExecute;


    [_unit, "Acts_UnconsciousStandUp_part1"] remoteExecCall ["switchMove", 0];

    private _fireflyEnd = "#particlesource" createvehiclelocal [_currentPosition select 0, _currentPosition select 1, 1];
    _fireflyEnd setParticleCircle [0,[0,0,0]];
    _fireflyEnd setParticleRandom [0,[0,0,0],[0.1,0.1,0.1],1,0,[0,0,0,0.1],1,1];
    _fireflyEnd setParticleParams [["\A3\data_f\proxies\muzzle_flash\mf_machineGun_Cheetah.p3d",1,0,1],"","SpaceObject",1,5,[0,0,0],[0,0,0],13,1.3,1,0,[0.01,0.01],[[1,1,1,1],[0,0,0,0]],[1],1,0.1,"","",_fireflyEnd, 0,true,1,[[200,200,200,10],[200,200,200,0]]];
    _fireflyEnd setDropInterval 0.05;

    [{
        params ["_fireflyEnd"];
        deleteVehicle _fireflyEnd;
    }, [_fireflyEnd], 0.2] call CBA_fnc_waitAndExecute;


    [{
        params ["_destinationPosition", "_unit"];
        _unit getVariable ["grad_VM_teleportDone", false]
    },{
        params ["_destinationPosition", "_unit"];
        titleCut ["", "WHITE OUT", 1.5];
        _unit setPos (_destinationPosition findEmptyPosition [0,15]);

    }, [_destinationPosition, _unit]] call CBA_fnc_waitUntilAndExecute;


}, [_currentPosition, _destinationPosition, _unit, _beam]] call CBA_fnc_waitUntilAndExecute;
