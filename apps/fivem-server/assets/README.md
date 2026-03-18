# Assets Directory Structure

Centralized asset management for the FiveM server.

## Directories

### `/vehicles`
Custom vehicle models, textures, and configurations.
- Vehicle model files (.yft, .ytd)
- Vehicle configurations
- Livery files
- Vehicle metadata

### `/maps`
Custom map modifications, interiors, and objects.
- Map files
- Interior modifications
- Custom objects
- Building models
- Props and static entities

### `/clothing`
Character clothing, skins, and appearance assets.
- Clothing models (.ytd, .yft)
- Skin textures
- Tattoo files
- Hair models
- Component textures

### `/weapons`
Weapon models, textures, and effects.
- Weapon model files (.yft, .ytd)
- Weapon effects
- Muzzle flash textures
- Sound effects
- Weapon attachment models

### `/ui`
User interface assets and NUI resources.
- UI images and icons
- HUD elements
- Menu backgrounds
- Font files
- HTML/CSS resources
- Script files

## Usage

Assets should be referenced in resources via proper paths:

```lua
-- Example: Loading vehicle model
RequestModel(GetHashKey('custom_vehicle_name'))

-- Example: Loading clothing
TriggerEvent('skinchanger:loadClothes', playerId, clothingData)

-- Example: Loading weapon
GiveWeaponToPed(ped, GetHashKey('weapon_custom'), 9999, false, 1)
```

## Asset Organization Best Practices

1. **Naming Convention** - Use descriptive names: `police_car_01`, `officer_uniform`, `glock_19`
2. **Subdirectories** - Organize by type within each category
3. **Documentation** - Keep README files in each subdirectory
4. **Version Control** - Track asset versions and updates
5. **File Sizes** - Keep individual assets optimized (<5MB recommended)

## File Type Reference

| Category | File Types |
|----------|-----------|
| Vehicles | .yft, .ytd, .yml |
| Maps | .ymap, .ybn, .ydr |
| Clothing | .ytd, .yft, .zs, .meta |
| Weapons | .yft, .ytd, .meta |
| UI | .png, .jpg, .ttf, .html, .js, .css |

## Compression Guidelines

- Images: Use PNG for UI, compress to <100KB each
- Models: Keep YFT/YTD files under 2MB
- Maps: Optimize collision data
- Total asset size: Recommend <500MB per resource

## Access Control

Assets are served through your FiveM resources and can be:
- Public (available to all clients)
- Protected (restricted by role)
- Private (server-only)

Configure access in individual resource manifests as needed.

