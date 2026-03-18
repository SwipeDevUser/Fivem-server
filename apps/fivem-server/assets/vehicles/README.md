# Vehicles Assets

This directory contains custom vehicle models, textures, and configurations.

## Structure

```
vehicles/
├── models/          # Vehicle model files (.yft, .ytd)
├── configs/         # Vehicle configuration files
├── liveries/        # Custom paint jobs and liveries
├── addons/          # Vehicle addon parts
└── metadata/        # Vehicle metadata and properties
```

## File Guidelines

- **Model Files**: Keep .yft and .ytd files organized by vehicle type
- **Configuration**: Store vehicle stats in YAML or JSON format
- **Liveries**: One directory per vehicle model
- **Metadata**: Add hash values, handling properties, etc.

## Example Usage

```lua
-- Load vehicle model
local modelHash = GetHashKey('custom_vehicle')
RequestModel(modelHash)
while not HasModelLoaded(modelHash) do
    Wait(0)
end

-- Spawn vehicle
local vehicle = CreateVehicle(modelHash, x, y, z, heading, true, false)
```

## Asset Optimization

- Models: 50-200K triangles recommended
- Textures: 1024x1024 or 2048x2048 maximum
- File size: Keep under 5MB per vehicle

