# Restrict Markers

This simple mod restricts map markers to only share to other players if they are nearby. Players can no longer rely on magically shared markers to communicate positions on-the-fly. Instead, detailed mission planning is encouraged, as players must huddle around to share map markers. In the field, effective use of verbal communication is emphasized. You can't always rely on having a high tech digital networked interactive map, and this mod makes the map behave more like a basic paper map.

## Features

- Player created markers are local to your own map by default.
- Markers automatically share to other players within 7 meters.
- Optional Zeus modules to toggle the mod on/off during mission.
- Compatible with vanilla and ACE markers.

## Setup Instructions

- Server side mod, not required on clients.
- No dependencies on other mods.

## Links

- Demo: https://youtu.be/HXME_IodBD8
- Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2560276469

## Developer Notes

Variable `jibrm_restrictmarkers_shareEnabled` toggles the mod during mission (same as what the Zeus modules do). The variable `jibrm_restrictmarkers_shareDistance` changes the share distance (default 7 meters). NOTE: Must broadcast the variables to all clients!

## Troubleshooting

### Markers don't show up for other players even when they are nearby?

Ensure you select the correct channel (group, side, etc) when creating the marker, as channel restrictions still apply.
