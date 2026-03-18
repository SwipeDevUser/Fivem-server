# Maps Assets

This directory contains custom map modifications, interiors, and environmental assets.

## Structure

```
maps/
├── interiors/       # Interior modifications
├── exteriors/       # Exterior map changes
├── objects/         # Custom objects and props
├── collision/       # Collision data
├── ymap/            # Map files (.ymap)
└── metadata/        # Map metadata and references
```

## File Guidelines

- **Interiors**: Organize by location (police, hospital, etc.)
- **Exteriors**: Group by map section/district
- **Objects**: Props, buildings, static entities
- **Collision**: YBN (collision) files for custom objects
- **YMAP**: FiveM-compatible map definition files

## Example Usage

```lua
-- Load map file
TriggerEvent('streaming:requestMap', 'custom_map_name')

-- Add object to map
local obj = CreateObject(GetHashKey('prop_custom'), x, y, z, true, false, false)
PlaceObjectOnGroundProperly(obj)
```

## Map Coverage

- **Downtown**: Business district modifications
- **Sandy Shores**: Desert area assets
- **Paleto Bay**: Northern region content
- **Custom Locations**: New interior spaces

## Performance Tips

- Keep .ymap files under 1MB
- Use LOD (Level of Detail) models
- Optimize collision meshes
- Remove unnecessary draw distances

