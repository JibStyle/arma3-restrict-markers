params ["_logic", "_units", "_isActivated"];
if (!_isActivated) exitWith {};
if (!isServer) exitWith {};
jibrm_restrictmarkers_shareEnabled = true;
publicVariable "jibrm_restrictmarkers_shareEnabled";
deleteVehicle _logic;
true;
