params ["_crystal"];

_crystal addAction
[
    "Put crystal on pedestal",    // title
    {
        params ["_target", "_caller", "_actionId", "_arguments"]; // script

        ["GRAD_VM_phaseControl", [1,1]] call CBA_fnc_serverEvent;

        // attachto syncs faster than setpos
        _target attachTo [phase1_pedestal, [0,0,0.9]];
    },
    nil,        // arguments
    1.5,        // priority
    true,       // showWindow
    true,       // hideOnUse
    "",         // shortcut
    "[1] call GRAD_VM_main_fnc_getPhaseProgress < 1",     // condition
    3,         // radius
    false,      // unconscious
    "",         // selection
    ""          // memoryPoint
];
