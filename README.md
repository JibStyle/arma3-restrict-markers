# Restrict Markers

Arma 3 has a lot of great features, but the vanilla map markers in multiplayer are not very realistic. When you mark something on a paper map, it shouldn't magically appear for everyone even if they are hundreds of meters away from you. This is especially bad in historic time periods like WW2, Vietnam, Cold War, etc. It is more realistic to mark things on your own map, but share the information to others verbally over the radio or by physically visiting them. This simple mod solves that problem.

Restrict Markers makes multiplayer map markers more realistic. You can mark things as needed on your own map, but those markers by default stay local to you. The only way to share markers to other players is via proximity (within 7 meters by default). This encourages gameplay where you stand next to someone and look at the map together during mission planning. Situations in the heat of battle are no longer possible where someone says over the radio "Contact! Marking enemies on the map, see my marker!". Instead, you need to use pre-designated reference points and verbal communication.

## Setup Instructions

This mod needs to be installed on the server and the client using Zeus. The rest of the players do not need it. It has no dependencies on other mods. Thus, it is possible to invite fully vanilla guest players. It is compatible with other mods like ACE if desired. The features of this mod are opt-in, so just having the mod installed won't affect anything. You need to place a couple modules to activate the marker restriction. Also, you can dynamically toggle the feature on/off using the modules. For example, you could allow default marker sharing during briefing, but restrict markers while in the field, then allow default marker sharing again during debriefing.

## How to Use

### Zeus

All you have to do is place two modules from the "Restrict Markers" category: "Initialize Marker Handling" and "Disable Sharing". This can be done at any time while the  mission is in progress. The "Enable Sharing" module can be used to restore the default behavior of markers.

### 3den

Setting up this mod in 3den is not recommended because it would create a dependency of the mission on this mod. As a result, all players would need to install the mod. However, if they do, then it will work. The setup is similar, place the modules "Initialize Marker Handling" and "Disable Sharing". Later in game, a Zeus can place modules "Disable Sharing" and "Enable Sharing" to toggle the feature if desired.

### In Game

While the marker restriction feature is enabled, when you create markers on your map, they will only propagate to other players within 7 meters from you. Note that you still need to create the markers on the appropriate channel (side, global, group, etc) for other players to receive them. If you create markers while no one else is around, they will be local to your own paper map. When you delete markers, the same applies -- they will only be deleted for other players that are close enough.

## Developer Notes

The default max sharing distance is 7 meters. To modify, change the variable `jibrm_restrictmarkers_shareDistance` to the desired number of meters, and publish it to all clients with `publicVariable`. I may add another module later to make this more user friendly if there is demand for that.

## Troubleshooting

### Modules don't show up in Zeus

Vanilla Zeus doesn't automatically load modules from mods. To explicitly load the modules, add an init.sqf file to your mission with the following code:

```
activateAddons ["jibrm_restrictmarkers"];
```
