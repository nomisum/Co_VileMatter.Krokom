/*

["dummyheadgear.p3d","a3\weapons_f\dummyheadgear.p3d",false]

Headgear_H_LIB_US_Helmet_CO

TIOW_Tau_HelmetB2_VL

model = "\40k_tau\Headgear\HelmetB2.p3d";

model = "JMSL_roman\helms\LegionerHelmet_1_2.p3d";
picture = "\JMSL_roman\ico\Ico_helm_leggal.paa";
model = "JMSL_roman\helms\LegionerHelmet_1.p3d";
model = "JMSL_roman\helms\LegionerHelmet_2.p3d";
model = "JMSL_roman\helms\LegionerHelmet_3.p3d";
model = "\JMSL_roman\weapon\gladius_1.p3d";
model = "\JMSL_roman\weapon\aquila.p3d";

*/

params [["_mask", controlNull], ["_duration", 60], ["_startDate", 2035], ["_endDate", 9]];

1 fadeSound 0;


// gradVM_wormholePipes
// gradVM_wormholeProps
private _brightnessMultiplicator = (getLighting select 1);


private _firstPipePos = getPos (gradVM_wormholePipes select 0);
_firstPipePos set [2, (_firstPipePos select 2) - 1.5];
private _lastPipePos = getPos (gradVM_wormholePipes select ((count gradVM_wormholePipes) - 2));
_lastPipePos set [2, (_lastPipePos select 2) - 1.5];

private _startpoint = [-100,0,8000];

for "_i" from 0 to 100 do {
    if (_i % 2 == 0) then {
            _startpoint set [1, (_i*2.85)];
            private _color = [0, 0, random (_i/50*0.05) max (_i/50*0.5)];
            private _lightPoint = "#lightpoint" createvehiclelocal (ASLtoAGL _startpoint);
            _lightPoint setLightDayLight true;_lightPoint setLightUseFlare false;
            _lightPoint setLightAmbient _color; _lightPoint setLightColor _color;
            _lightPoint setLightAttenuation [2, 4, 4, 8, 16, 1];
            _lightPoint setLightBrightness ((random 10 max 2.5)*_brightnessMultiplicator);
            _lightPoint setPos (ASLtoAGL _startpoint);
            gradVM_wormholeProps pushbackunique _lightPoint;
        };
};

[_firstPipePos, _lastPipePos, _startDate, _endDate] spawn GRAD_VM_teleport_fnc_teleportCounter;


private _cam = "camera" camCreate _firstPipePos;
_cam camSetPos _firstPipePos;
_cam camSetTarget _lastPipePos;
_cam camSetFov 8.5;
_cam camPreload 3;

[{
    params ["_mask", "_cam", "_duration"];
    camPreloaded _cam
},{
    params ["_mask", "_cam", "_duration", "_firstPipePos", "_lastPipePos", "_brightnessMultiplicator"];
    _cam camCommand "inertia on";
    _cam cameraEffect ["internal", "BACK"];
    _cam camCommit 0;
    _cam camSetFov 0.7;
    _cam camSetPos _lastPipePos;
    _cam camCommit _duration;

    _mask ctrlSetFade 1;
    _mask ctrlCommit 2;

    private _firefly = "#particlesource" createvehiclelocal (_firstPipePos);
    _firefly setParticleRandom [0,[0,0,0],[1,1,0.1],1,0,[0,0,0,0.1],1,1];
    _firefly setParticleParams [["\a3\data_f\proxies\muzzle_flash\muzzle_flash_rifle_gm6.p3d",1,0,1],"","SpaceObject",1,3,[0,6,0],[0,0,0],13,1.3,1,0,[0.01,0.01],[[1,1,1,1],[0,0,0,0]],[1],1,0.2,"","",_cam, 0,true,1,[[200,200,200,10],[200,200,200,0]]];
    _firefly setDropInterval 0.001;

    private _refract = "#particlesource" createvehiclelocal (_firstPipePos);
    _refract setParticleRandom [0,[0,0,0],[1,1,0],1,0,[0,0,0,0.1],1,1];
    _refract setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1],"","Billboard",1,2,[0,5,0],[0,0,0],13,1.3,1,0,[0,5,0],[[1,1,1,1],[0,0,0,0]],[1],1,0.1,"","",_cam];
    _refract setDropInterval 0.2;

    private _lightPoint = "#lightpoint" createvehiclelocal (_firstPipePos);
    _lightPoint setLightDayLight true;_lightPoint setLightUseFlare true;
    _lightPoint setLightFlareSize 10*_brightnessMultiplicator; _lightPoint setLightFlareMaxDistance 5000;
    _lightPoint setLightAmbient[1,0.2,1]; _lightPoint setLightColor[1,0.2,0.9];
    _lightPoint setLightAttenuation [0, 1, 1, 2, 4, 100];
    _lightPoint setLightBrightness 5*_brightnessMultiplicator;

    private _lightPointStart = "#lightpoint" createvehiclelocal (_firstPipePos);
    _lightPointStart setLightDayLight true;_lightPointStart setLightUseFlare true;
    _lightPointStart setLightFlareSize 20*_brightnessMultiplicator; _lightPointStart setLightFlareMaxDistance 5000;
    _lightPointStart setLightAmbient[0.1,0.2,1]; _lightPointStart setLightColor[0.1,0.2,0.9];
    _lightPointStart setLightAttenuation [0, 1, 1, 2, 4, 100];
    _lightPointStart setLightBrightness 7*_brightnessMultiplicator;
    gradVM_wormholeProps pushbackunique _lightPointStart;

    private _lightPointEnd = "#lightpoint" createvehiclelocal (_lastPipePos);
    _lightPointEnd setLightDayLight true;_lightPointEnd setLightUseFlare false;
    _lightPointEnd setLightFlareSize 20*_brightnessMultiplicator; _lightPointEnd setLightFlareMaxDistance 5000;
    _lightPointEnd setLightAmbient[0.5,0.2,1]; _lightPointEnd setLightColor[0.5,0.2,0.9];
    _lightPointEnd setLightAttenuation [0, 1, 1, 2, 4, 100];
    _lightPointEnd setLightBrightness 10*_brightnessMultiplicator;
    gradVM_wormholeProps pushbackunique _lightPointEnd;

    [{
        params ["_args", "_handle"];
        _args params ["_cam", "_lightPoint", "_lastPipePos"];

        if (isNull _cam) exitWith { [_handle] call CBA_fnc_removePerFrameHandler; };

        {
            gradVM_cameraBank = gradVM_cameraBank + gradVM_cameraBankChange;
            [_x,[0,gradVM_cameraBank,0]] call GRAD_VM_teleport_fnc_setPitchBankYaw;
        } forEach gradVM_wormholePipes;

        private _lightPos = (_cam getPos [20,0]);
        _lightPos set [2, (getPos _cam) select 2];
        _lightPoint setPos _lightPos;

        systemChat str (getpos _lightPoint);

        gradVM_cameraPosition = getPos _cam;

    }, 0, [_cam, _lightPoint, _lastPipePos]] call CBA_fnc_addPerFramehandler;

    [_cam, _firefly, _refract, _lightPoint, _duration, _mask] spawn {
        params ["_cam", "_firefly", "_refract", "_lightPoint", "_duration", "_mask"];

        sleep (_duration-2);
        sleep 1.5;
        player setVariable ["grad_VM_teleportDone", true];
        deleteVehicle _firefly;
        deleteVehicle _refract;
        deleteVehicle _lightPoint;
        camDestroy _cam;
        _mask ctrlSetFade 0;
        _mask ctrlCommit 2;
        3 fadeSound 1;
        sleep 2;
        _mask ctrlSetFade 1;
        _mask ctrlCommit 2;
    };



}, [_mask, _cam, _duration, _firstPipePos, _lastPipePos, _brightnessMultiplicator]] call CBA_fnc_waitUntilAndExecute;
