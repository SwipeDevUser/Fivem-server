# Clothing Assets

This directory contains character clothing, skins, and appearance modifications.

## Structure

```
clothing/
├── skins/           # Custom skin/character models
├── outfits/         # Complete outfit sets
├── components/      # Individual clothing items
├── tattoos/         # Tattoo files
├── faces/           # Face/head models
└── metadata/        # Clothing metadata and properties
```

## File Guidelines

- **Skins**: YFT/YTD files with texture variants
- **Outfits**: Grouped clothing combinations
- **Components**: Shirts, pants, shoes, hats, etc.
- **Tattoos**: ZS (compressed) files organized by body part
- **Faces**: Custom character creation options

## Example Usage

```lua
-- Load custom clothing
TriggerEvent('skinchanger:loadClothes', playerId, {
    ['tshirt_1'] = 0,
    ['tshirt_2'] = 0,
    ['torso_1'] = 0,
    ['torso_2'] = 0,
})

-- Apply tattoo
TriggerEvent('skinchanger:loadTattoo', playerId, 'torso', tattoo_id)
```

## Clothing Categories

- **Torso**: Shirts, jackets, vests
- **Legs**: Pants, shorts, skirts
- **Feet**: Shoes, boots, sneakers
- **Accessories**: Hats, glasses, chains
- **Hands**: Gloves, rings
- **Special**: Job-specific uniforms (police, EMS, etc.)

## Asset Optimization

- Textures: 512x512 or 1024x1024
- Polygon count: 10K-30K triangles per item
- File size: Keep under 2MB per clothing item

## Job Uniforms

Directory organization for work clothing:

```
clothing/
├── jobs/
│   ├── police/
│   ├── ems/
│   ├── firefighter/
│   └── security/
└── casual/
```

