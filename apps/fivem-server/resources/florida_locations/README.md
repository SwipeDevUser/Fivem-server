# Florida Locations & Districts System
## Comprehensive Urban Roleplay Framework for GTA V

**Transforms GTA V into a Florida-inspired roleplaying environment with 5 major regions, multiple districts, and authentic location mapping.**

---

## Overview

The Florida Locations system provides a comprehensive framework for creating a Florida-based roleplay server. It maps real Florida cities and locations to GTA V coordinates, creates interactive zones, provides GPS navigation, and integrates with existing business systems.

### Key Features:
- 🏙️ **5 Major Regions** - Orlando, Jacksonville, Miami, Melbourne (Space Coast), Tampa Bay
- 🛣️ **Multiple Districts** - Downtown areas, historic districts, entertainment zones
- 📍 **50+ Named Locations** - Government buildings, airports, attractions, businesses
- 🗺️ **Interactive GPS System** - Navigate to any location by name
- 📡 **Zone System** - Dynamic zone-based events and location tracking
- 🎯 **Waypoint Markers** - Visual map markers for all locations
- 🏪 **Business Integration** - Orlando Gun Club, Machine Gun America, Buc-ee's locations
- 🌳 **Tourism Guide** - Information about attractions and restaurants

---

## Regions

### 1. Orlando - Central Hub
**Description:** Central Florida hub with theme parks, government, and business district
- Downtown Orlando (Government & Business)
- International Drive (Entertainment & Tourism)
- Waterford Lakes (Shopping & Recreation)
- Coordinates: Downtown -480, -900
- Color: Orange (255, 102, 0)

**Key Locations:**
- Orlando City Hall
- Orange County Courthouse
- Supreme Court Building
- Banking District
- Buc-ee's, WAWA, 7-Eleven locations

### 2. Jacksonville - Northern Florida
**Description:** Northern Florida business and historic district
- Downtown Jacksonville (Business & Government)
- Riverside District (Historic & Upscale)
- San Marco (Cultural District)
- Coordinates: Downtown 420, -950
- Color: Blue (0, 102, 255)

**Key Locations:**
- Jacksonville Sheriff's Office
- Duval County Courthouse
- Port of Jacksonville
- Riverside Historic District
- Banking & Government Centers

### 3. Miami - South Florida
**Description:** Beach and entertainment destination on the coast
- South Beach (Entertainment & Nightlife)
- Wynwood (Arts & Culture)
- Biscayne Bay (Water Recreation)
- Coordinates: Downtown 290, 425
- Color: Pink (255, 0, 102)

**Key Locations:**
- Miami Beach Pier
- Biscayne National Park Area
- Downtown Miami (Business District)
- Art Galleries & Entertainment

### 4. Melbourne - Space Coast
**Description:** Space and technology hub with NASA presence
- Kennedy Space Center
- Port Canaveral
- Cocoa Beach
- Coordinates: Space Center 2430, 2858
- Color: Green (102, 255, 0)

**Key Locations:**
- Kennedy Space Center
- Port Canaveral (International Trade)
- Cocoa Beach Pier
- Technology & Innovation Centers

### 5. Tampa Bay - Western Hub
**Description:** Entertainment and sports destination
- Downtown Tampa
- St. Petersburg
- Ybor City (Historic District)
- Color: Yellow (255, 255, 0)

---

## Districts

### Orlando Districts
- **Downtown Orlando** - Government, courts, business center
- **International Drive** - Hotels, attractions, entertainment
- **Waterford Lakes** - Shopping, dining, recreation

### Jacksonville Districts
- **Downtown Jacksonville** - Business & government
- **Riverside** - Historic river district, upscale dining
- **San Marco** - Cultural and historic area

### Miami Districts
- **South Beach** - Entertainment and nightlife
- **Wynwood** - Arts, culture, galleries
- **Biscayne Bay** - Water recreation and tourism

---

## Game Commands

### Navigation Commands
```
/location              Shows current location name and district
/nearby               Lists 5 nearest locations
/gps [location name]   Set waypoint to named location
/district             Shows current district information
```

### Information Commands
```
/regions              List all available regions
/districts            List all available districts
/attractions [region] Show attractions in a region
/restaurants [region] Show restaurants in a region
/zones                List all special zones
/zone                 Shows current zone information
/tourism              Tourism guide for Florida
```

### Server Commands
```
/floridainfo          Display Florida system information
/studstats            Location statistics
/traveldist           Travel distances between regions
```

---

## Location Examples

### Orlando Downtown
- **Orlando City Hall** - Government Center
- **Orange County Courthouse** - Judicial Building
- **Supreme Court Building** - Florida Supreme Court
- **Downtown Business District** - Office & Financial
- **Buc-ee's Travel Center** - Convenience Store
- **WAWA Express** - Convenience Store
- **7-Eleven Downtown** - 24/7 Convenience

### Jacksonville
- **Jacksonville Sheriff's Office** - Police HQ
- **Duval County Courthouse** - Judicial Building
- **Port of Jacksonville** - International Trade Port
- **Riverside District** - Historic Upscale Area

### Gun Ranges
- **Orlando Gun Club** - Premium Firearms (Est. 2010)
- **Machine Gun America** - Full-Auto Range (Kissimmee)

---

## Features

### 🗺️ GPS Navigation System
Navigate to any marked location by name:
```
/gps "Orlando City Hall"
/gps "Kennedy Space Center"
/gps "Machine Gun America"
```

### 📍 Automatic Location Detection
- Displays district name when entering new area
- Shows location name in chat
- Real-time distance tracking

### 🎯 Zone-Based Events
- Special zones trigger on entry/exit
- Gun ranges have dedicated zones
- Customizable zone mechanics

### 🏪 Business Integration
- Orlando Gun Club - Downtown premium firearms
- Machine Gun America - Kissimmee full-auto range
- Multiple convenience stores (Buc-ee's, WAWA, 7-Eleven)
- Supreme Court - Downtown judicial system

### 👥 Tourism Features
- Attraction listings by region
- Restaurant finder by region
- Real-world Florida attractions included
- Travel distance information

---

## Integration Points

### With Existing Systems
- **Police**: Jacksonville police station location
- **Supreme Court**: Downtown Orlando courthouse
- **Banking**: Banking district in downtown
- **Businesses**: Gun clubs, convenience stores, restaurants
- **Inventory**: Transportation hubs for roleplay

### Expansion Possibilities
- Add real estate/housing locations
- Nightclub zones with music events
- Beach day events at Miami locations
- Space Center tours
- Port activities and shipping

---

## Technical Details

### Configuration Files
- **shared/config.lua** - All location definitions and regions
- **shared/locations.lua** - Location utility functions
- **client/main.lua** - Location tracking and commands
- **client/blips.lua** - Map markers and waypoints
- **client/zones.lua** - Zone system and events
- **server/main.lua** - Server statistics and management

### Exported Functions
```lua
-- Check location by coordinates
Locations.GetLocationByCoords(coords, radius)

-- Get current district
Locations.GetDistrict(coords)

-- Check if in region
Locations.IsInRegion(coords, region_name)

-- Get nearest locations
Locations.GetNearestLocation(coords, count)

-- Get location information
Locations.GetLocationInfo(locationName)

-- Get coordinates by location name
Locations.GetCoordsFromLocationName(locationName)
```

---

## Gameplay Examples

### Example 1: Starting Location
- Player spawns in downtown Orlando
- Automatic notification: "Welcome to Downtown Orlando - Central Business & Government District"
- GPS available for all nearby locations
- Can navigate to Supreme Court, Gun Club, Banking, etc.

### Example 2: Travel Between Cities
```
/gps "Jacksonville Sheriff's Office"
// Navigate ~250 miles north to Jacksonville
// District changes to "Downtown Jacksonville"
```

### Example 3: Gun Shop Visit
- Enter Orlando Gun Club zone
- Zone system recognizes player
- Shop interface available
- Full integration with inventory system

### Example 4: Tourism
```
/attractions orlando
// Displays: Magic Kingdom, Epcot, Universal Studios, etc.

/restaurants miami
// Displays: Casa Tua, Latin Café 2000, The Surf Club, etc.
```

---

## Customization

### Adding New Locations
Edit `shared/config.lua` and add to appropriate location table:
```lua
Config.OrlandoDowntown = {
    {
        name = "New Location",
        realLocation = "Real World Address",
        coords = {x, y, z},
        heading = 0,
        radius = 100,
        icon = 227,
        color = 25,
        description = "Location description"
    },
    -- ... more locations
}
```

### Adding New Districts
Edit `Config.Districts` in shared/config.lua:
```lua
my_district = {
    name = "My District",
    region = "region_name",
    center = {x, y},
    radius = 300,
    description = "District description"
}
```

### Adding New Regions
Edit `Config.Regions` in shared/config.lua:
```lua
my_region = {
    name = "Region Name",
    label = "Display Name, FL",
    color = {r, g, b},
    description = "Region description",
    realWorldCity = "Real City Name"
}
```

---

## Future Enhancements

Potential additions:
- Real estate locations and property markets
- Beach events at Miami locations
- Space tours at Kennedy Space Center
- Port activities for shipping RP
- Historical walking tours
- Themed seasonal events
- NPC tour guides
- Taxi/transport system integration
- Delivery system by region

---

## Compatibility

Works with:
- ✅ GTA V FiveM Server
- ✅ Orlando Gun Club system
- ✅ Machine Gun America system
- ✅ Supreme Court system
- ✅ Existing business systems
- ✅ Standard FiveM frameworks
- ✅ Any map mod (base GTA V recommended)

---

## Commands Summary

| Command | Usage | Result |
|---------|-------|--------|
| `/location` | Check current spot | Shows location & district |
| `/nearby` | Find nearby places | Lists 5 closest locations |
| `/gps [name]` | Navigate somewhere | Sets waypoint |
| `/districts` | See all districts | Lists all districts |
| `/regions` | See all regions | Lists all regions |
| `/attractions [region]` | Tourist info | Shows attractions |
| `/restaurants [region]` | Food info | Shows restaurants |
| `/tourism` | Full guide | Complete Florida overview |

---

## Support & Issues

For questions or issues:
- Verify all script files are loading
- Check console for error messages
- Ensure coordinates are valid
- Use `/floridainfo` to verify system is online
- Check blips are appearing on map

---

**Florida Locations System - Complete Urban Roleplay Framework**

*Making GTA V feel like Florida since 2026* 🌴🏖️

Version 1.0.0 - Full Documentation
