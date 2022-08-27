params ["_logic", "_units", "_isActivated"];
if (!_isActivated) exitWith {};
if (!isServer) exitWith {};
jib_restrictmarkers_enabled = true;
publicVariable "jib_restrictmarkers_enabled";
deleteVehicle _logic;
true;
