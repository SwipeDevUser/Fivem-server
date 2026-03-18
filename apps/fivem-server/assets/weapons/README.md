# Weapons Assets

This directory contains weapon models, textures, and effects.

## Structure

```
weapons/
├── models/          # Weapon model files (.yft, .ytd)
├── attachments/     # Weapon attachment models (scopes, silencers, etc.)
├── effects/         # Muzzle flash and effect files
├── sounds/          # Custom weapon sound files
├── metadata/        # Weapon stats and properties
└── ammo/            # Ammunition models and effects
```

## File Guidelines

- **Models**: YFT/YTD files for each weapon type
- **Attachments**: Scopes, suppressors, extended mags, grips
- **Effects**: Muzzle flashes, bullet impacts
- **Sounds**: Fire, reload, pump action sounds
- **Metadata**: Damage, accuracy, rate of fire configs

## Weapon Categories

### Pistols
- Glock variants
- 1911 styles
- Custom designs

### Rifles
- Assault rifles
- Sniper rifles
- Battle rifles

### Shotguns
- Combat shotguns
- Pump actions
- Semi-auto

### SMGs
- Micro-SMGs
- Tommy guns
- Compact variants

### Heavy Weapons
- Machine guns
- Grenade launchers
- Miniguns

## Example Usage

```lua
-- Give custom weapon
GiveWeaponToPed(ped, GetHashKey('weapon_custom_pistol'), 120, false, 1)

-- Add weapon attachment
GiveWeaponComponentToPed(ped, GetHashKey('weapon_custom_rifle'), GetHashKey('component_scope'))

-- Set weapon properties
SetWeaponDamageModifier(GetHashKey('weapon_custom'), 1.5)
```

## Audio Setup

Weapon sounds organized by action:
- `fire` - Main gunshot sound
- `fire_suppressed` - Silenced gunshot
- `reload` - Reload animation sound
- `reload_empty` - Click when magazine empty
- `pickup` - Pickup sound
- `drop` - Drop sound

## Asset Optimization

- Models: 1K-5K triangles per weapon
- Textures: 512x512 or 1024x1024
- Audio: 16-bit, 44.1kHz WAV or MP3
- File size: Keep under 3MB per weapon

## Custom Mod Integration

Supported frameworks:
- Custom weapon hashes in database
- Weapon configuration system
- Job-specific weapon restrictions
- Loadout saving system

