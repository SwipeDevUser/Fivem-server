-- Florida Locations Configuration
-- Maps real Florida cities to GTA V coordinates

Config = {}

-- Main Regions (Cities)
Config.Regions = {
    orlando = {
        name = "Orlando",
        label = "Downtown Orlando, FL",
        color = {255, 102, 0},  -- Orange
        description = "Central Florida Hub",
        realWorldCity = "Orlando, Florida"
    },
    jacksonville = {
        name = "Jacksonville",
        label = "Jacksonville, FL",
        color = {0, 102, 255},  -- Blue
        description = "Northern Florida",
        realWorldCity = "Jacksonville, Florida"
    },
    miami = {
        name = "Miami",
        label = "Miami-Dade County, FL",
        color = {255, 0, 102},  -- Pink
        description = "South Florida Coast",
        realWorldCity = "Miami, Florida"
    },
    melbou = {
        name = "Melbourne",
        label = "Melbourne, FL",
        color = {102, 255, 0},  -- Green
        description = "Space Coast",
        realWorldCity = "Melbourne, Florida"
    },
    tampabay = {
        name = "Tampa Bay",
        label = "Tampa/St. Petersburg, FL",
        color = {255, 255, 0},  -- Yellow
        description = "Bay Area Hub",
        realWorldCity = "Tampa, Florida"
    }
}

-- Downtown Orlando Locations (replaces LS Downtown)
Config.OrlandoDowntown = {
    {
        name = "Orlando City Hall",
        realLocation = "Orlando City Hall",
        coords = {-524.4, -914.2, 29.3},
        heading = 0,
        radius = 150,
        icon = 227,
        color = 25,
        description = "Government Center"
    },
    {
        name = "Orlando Supreme Court",
        realLocation = "Orange County Courthouse",
        coords = {-427.8, -893.5, 29.2},
        heading = 0,
        radius = 100,
        icon = 227,
        color = 25,
        description = "Florida Supreme Court Building"
    },
    {
        name = "Orlando International Bank",
        realLocation = "Banking District",
        coords = {-532.1, -902.3, 29.4},
        heading = 0,
        radius = 80,
        icon = 227,
        color = 2,
        description = "Financial Center"
    },
    {
        name = "Buc-ee's Travel Center",
        realLocation = "Buc-ee's Convenience",
        coords = {-502.3, -945.8, 29.2},
        heading = 0,
        radius = 50,
        icon = 227,
        color = 1,
        description = "Convenience Store"
    },
    {
        name = "WAWA Express",
        realLocation = "WAWA Convenience",
        coords = {-475.2, -925.4, 29.1},
        heading = 0,
        radius = 50,
        icon = 227,
        color = 1,
        description = "Convenience Store"
    },
    {
        name = "7-Eleven Downtown",
        realLocation = "7-Eleven Convenience",
        coords = {-505.7, -880.3, 29.3},
        heading = 0,
        radius = 50,
        icon = 227,
        color = 1,
        description = "24/7 Convenience Store"
    },
    {
        name = "Downtown Business District",
        realLocation = "Central Business District",
        coords = {-480.0, -900.0, 29.0},
        heading = 0,
        radius = 300,
        icon = 227,
        color = 25,
        description = "Orlando Business Hub - Office & Retail"
    }
}

-- Jacksonville District Locations (replaces Blaine County North)
Config.JacksonvilleCityDistrict = {
    {
        name = "Jacksonville Police Department",
        realLocation = "Jacksonville Sheriff's Office",
        coords = {429.2, -985.4, 29.4},
        heading = 0,
        radius = 150,
        icon = 227,
        color = 3,
        description = "Law Enforcement Headquarters"
    },
    {
        name = "Duval County Courthouse",
        realLocation = "County Courthouse",
        coords = {402.5, -928.7, 29.3},
        heading = 0,
        radius = 100,
        icon = 227,
        color = 25,
        description = "Florida Courts Building"
    },
    {
        name = "Jacksonville Port Authority",
        realLocation = "Port of Jacksonville",
        coords = {520.3, -945.2, 20.1},
        heading = 0,
        radius = 250,
        icon = 227,
        color = 1,
        description = "Major Port Authority"
    },
    {
        name = "Riverside District",
        realLocation = "Historic Riverside",
        coords = {450.0, -1050.0, 29.0},
        heading = 0,
        radius = 400,
        icon = 227,
        color = 25,
        description = "Jacksonville Upscale River District"
    }
}

-- Miami Beach/South Florida Districts
Config.MiamiBeachArea = {
    {
        name = "Miami Beach",
        realLocation = "Miami Beach",
        coords = {290.2, 425.3, 101.2},
        heading = 0,
        radius = 400,
        icon = 227,
        color = 10,
        description = "South Beach Area"
    },
    {
        name = "Biscayne Bay",
        realLocation = "Biscayne National Park",
        coords = {350.5, 520.1, 25.5},
        heading = 0,
        radius = 500,
        icon = 227,
        color = 10,
        description = "Water Recreation Area"
    },
    {
        name = "Miami Downtown",
        realLocation = "Downtown Miami",
        coords = {320.8, 405.2, 102.1},
        heading = 0,
        radius = 300,
        icon = 227,
        color = 10,
        description = "Miami Business District"
    }
}

-- Space Coast (replaces Fort Zancudo area)
Config.SpaceCoast = {
    {
        name = "Kennedy Space Center",
        realLocation = "Kennedy Space Center",
        coords = {2430.5, 2858.3, 50.2},
        heading = 0,
        radius = 300,
        icon = 227,
        color = 1,
        description = "NASA Launch Facility"
    },
    {
        name = "Port Canaveral",
        realLocation = "Port Canaveral",
        coords = {2520.1, 2745.4, 15.3},
        heading = 0,
        radius = 250,
        icon = 227,
        color = 1,
        description = "International Port"
    },
    {
        name = "Cocoa Beach Pier",
        realLocation = "Cocoa Beach",
        coords = {2385.2, 2510.1, 5.2},
        heading = 0,
        radius = 200,
        icon = 227,
        color = 1,
        description = "Beach Destination"
    }
}

-- Gun Ranges & Ammunition Stores (for our gun shops)
Config.GunRangesDistrict = {
    {
        name = "Orlando Gun Club",
        realLocation = "Orlando Gun Club",
        coords = {-155.4, -275.3, 44.2},
        heading = 0,
        radius = 100,
        icon = 227,
        color = 1,
        description = "Premium Firearms Dealer"
    },
    {
        name = "Machine Gun America - Kissimmee",
        realLocation = "Machine Gun America",
        coords = {125.3, -445.8, 44.1},
        heading = 0,
        radius = 100,
        icon = 227,
        color = 1,
        description = "Full-Auto Training Facility"
    }
}

-- Districts/Neighborhoods
Config.Districts = {
    -- ORLANDO NEIGHBORHOODS
    downtown_orlando = {
        name = "Downtown Orlando",
        region = "orlando",
        center = {-480.0, -900.0},
        radius = 250,
        description = "Central Business & Government District"
    },
    international_drive = {
        name = "International Drive",
        region = "orlando",
        center = {-350.0, -450.0},
        radius = 300,
        description = "Theme Park & Tourist Area"
    },
    waterford_lakes = {
        name = "Waterford Lakes",
        region = "orlando",
        center = {-150.0, -600.0},
        radius = 200,
        description = "Shopping & Dining District"
    },
    silverstar = {
        name = "Silverstar",
        region = "orlando",
        center = {-600.0, -750.0},
        radius = 200,
        description = "Residential Neighborhood"
    },
    paramore = {
        name = "Paramore",
        region = "orlando",
        center = {-700.0, -800.0},
        radius = 180,
        description = "Urban Neighborhood"
    },
    winter_garden = {
        name = "Winter Garden",
        region = "orlando",
        center = {-850.0, -600.0},
        radius = 220,
        description = "Historic Garden District"
    },
    ivy_lane = {
        name = "Ivy Lane",
        region = "orlando",
        center = {-550.0, -1050.0},
        radius = 150,
        description = "Upscale Residential Area"
    },
    north_lane = {
        name = "North Lane",
        region = "orlando",
        center = {-400.0, -1100.0},
        radius = 170,
        description = "North Orlando Residential"
    },
    colonial_town = {
        name = "Colonial Town",
        region = "orlando",
        center = {-320.0, -750.0},
        radius = 180,
        description = "Historic Town Center"
    },
    thornton_park = {
        name = "Thornton Park",
        region = "orlando",
        center = {-280.0, -650.0},
        radius = 160,
        description = "Upscale Shopping District"
    },
    downtown_east = {
        name = "Downtown East",
        region = "orlando",
        center = {-350.0, -850.0},
        radius = 140,
        description = "Downtown Expansion District"
    },
    lake_eustis = {
        name = "Lake Eustis",
        region = "orlando",
        center = {-950.0, -900.0},
        radius = 250,
        description = "Lakeside Community"
    },
    cherokee_park = {
        name = "Cherokee Park",
        region = "orlando",
        center = {-500.0, -500.0},
        radius = 180,
        description = "Park District"
    },
    bumby_avenue = {
        name = "Bumby Avenue",
        region = "orlando",
        center = {-200.0, -800.0},
        radius = 140,
        description = "Commercial District"
    },
    pine_hills = {
        name = "Pine Hills",
        region = "orlando",
        center = {-850.0, -950.0},
        radius = 200,
        description = "Residential Hills"
    },
    mill_creek = {
        name = "Mill Creek",
        region = "orlando",
        center = {150.0, -700.0},
        radius = 190,
        description = "Creek Side Community"
    },
    fashion_square = {
        name = "Fashion Square",
        region = "orlando",
        center = {80.0, -550.0},
        radius = 160,
        description = "Shopping & Fashion District"
    },

    -- KISSIMMEE NEIGHBORHOODS
    reunion = {
        name = "Reunion",
        region = "orlando",
        center = {100.0, -250.0},
        radius = 280,
        description = "Master Planned Community"
    },
    poinciana_blvd = {
        name = "Poinciana Boulevard",
        region = "orlando",
        center = {40.0, -100.0},
        radius = 200,
        description = "Main Commercial Corridor"
    },
    shingle_creek = {
        name = "Shingle Creek",
        region = "orlando",
        center = {-50.0, 50.0},
        radius = 220,
        description = "Historic Creek Area"
    },
    old_town = {
        name = "Old Town",
        region = "orlando",
        center = {200.0, -50.0},
        radius = 150,
        description = "Historic Downtown Kissimmee"
    },
    downtown_kissimmee = {
        name = "Downtown Kissimmee",
        region = "orlando",
        center = {180.0, 20.0},
        radius = 180,
        description = "City Center"
    },
    lakefront = {
        name = "Lakefront District",
        region = "orlando",
        center = {290.0, 100.0},
        radius = 190,
        description = "Waterfront Community"
    },
    tohopekaliga = {
        name = "Tohopekaliga",
        region = "orlando",
        center = {350.0, 150.0},
        radius = 210,
        description = "Lake District"
    },
    poinciana_hills = {
        name = "Poinciana Hills",
        region = "orlando",
        center = {-100.0, -200.0},
        radius = 175,
        description = "Residential Hills"
    },
    lakewood_ranch = {
        name = "Lakewood Ranch",
        region = "orlando",
        center = {320.0, -180.0},
        radius = 230,
        description = "Gated Community"
    },
    celebration = {
        name = "Celebration",
        region = "orlando",
        center = {450.0, -350.0},
        radius = 250,
        description = "Disney Planned Community"
    },
    forest_lakes = {
        name = "Forest Lakes",
        region = "orlando",
        center = {500.0, 250.0},
        radius = 200,
        description = "Suburban Forest Community"
    },
    gateway_center = {
        name = "Gateway Center",
        region = "orlando",
        center = {250.0, -380.0},
        radius = 160,
        description = "Commercial Gateway"
    },
    
    -- JACKSONVILLE NEIGHBORHOODS
    downtown_jacksonville = {
        name = "Downtown Jacksonville",
        region = "jacksonville",
        center = {420.0, -950.0},
        radius = 300,
        description = "Jacksonville City Center"
    },
    riverside_jacksonville = {
        name = "Riverside",
        region = "jacksonville",
        center = {500.0, -1050.0},
        radius = 250,
        description = "Historic River District"
    },
    san_marco = {
        name = "San Marco",
        region = "jacksonville",
        center = {580.0, -900.0},
        radius = 220,
        description = "Upscale Shopping District"
    },
    avondale = {
        name = "Avondale",
        region = "jacksonville",
        center = {380.0, -1100.0},
        radius = 200,
        description = "Historic Residential Area"
    },
    five_points = {
        name = "Five Points",
        region = "jacksonville",
        center = {450.0, -1150.0},
        radius = 180,
        description = "Eclectic Urban District"
    },
    ortega = {
        name = "Ortega",
        region = "jacksonville",
        center = {520.0, -1200.0},
        radius = 210,
        description = "Riverside Community"
    },
    mandarin = {
        name = "Mandarin",
        region = "jacksonville",
        center = {620.0, -1050.0},
        radius = 240,
        description = "South Jacksonville Area"
    },
    arlington = {
        name = "Arlington",
        region = "jacksonville",
        center = {350.0, -850.0},
        radius = 230,
        description = "Arlington District"
    },

    -- MIAMI NEIGHBORHOODS
    south_beach_miami = {
        name = "South Beach",
        region = "miami",
        center = {290.0, 425.0},
        radius = 300,
        description = "Miami Beach Entertainment Area"
    },
    wynwood_miami = {
        name = "Wynwood",
        region = "miami",
        center = {350.0, 350.0},
        radius = 200,
        description = "Arts & Culture District"
    },
    brickell = {
        name = "Brickell",
        region = "miami",
        center = {320.0, 480.0},
        radius = 190,
        description = "Downtown Miami Financial District"
    },
    little_havana = {
        name = "Little Havana",
        region = "miami",
        center = {280.0, 550.0},
        radius = 220,
        description = "Historic Cuban District"
    },
    design_district = {
        name = "Design District",
        region = "miami",
        center = {380.0, 300.0},
        radius = 180,
        description = "Art & Design Hub"
    },
    coconut_grove = {
        name = "Coconut Grove",
        region = "miami",
        center = {450.0, 550.0},
        radius = 210,
        description = "Waterfront Village"
    },
    coral_gables = {
        name = "Coral Gables",
        region = "miami",
        center = {400.0, 600.0},
        radius = 240,
        description = "Upscale Residential Area"
    },
    midtown_miami = {
        name = "Midtown Miami",
        region = "miami",
        center = {330.0, 280.0},
        radius = 170,
        description = "Urban Culture District"
    },
    allapattah = {
        name = "Allapattah",
        region = "miami",
        center = {250.0, 620.0},
        radius = 200,
        description = "Historic Residential District"
    },
    siesta_key = {
        name = "Siesta Key",
        region = "miami",
        center = {200.0, 700.0},
        radius = 180,
        description = "Beach Paradise"
    },
    key_biscayne = {
        name = "Key Biscayne",
        region = "miami",
        center = {520.0, 650.0},
        radius = 200,
        description = "Tropical Island Community"
    },

    -- JACKSONVILLE BEACHES
    jacksonville_beach = {
        name = "Jacksonville Beach",
        region = "jacksonville",
        center = {750.0, -850.0},
        radius = 220,
        description = "Atlantic Beach Area"
    },
    amelia_island = {
        name = "Amelia Island",
        region = "jacksonville",
        center = {820.0, -1000.0},
        radius = 210,
        description = "Northern Beach Paradise"
    },

    -- SPACE COAST BEACHES
    daytona_beach = {
        name = "Daytona Beach",
        region = "melbou",
        center = {2250.0, 2300.0},
        radius = 240,
        description = "Famous Racing Beach"
    },
    cocoa_beach = {
        name = "Cocoa Beach",
        region = "melbou",
        center = {2350.0, 2400.0},
        radius = 200,
        description = "Surfer's Paradise"
    },
    melbourne_beach = {
        name = "Melbourne Beach",
        region = "melbou",
        center = {2500.0, 2550.0},
        radius = 190,
        description = "Calm Beach Community"
    },
    new_smyrna_beach = {
        name = "New Smyrna Beach",
        region = "melbou",
        center = {2180.0, 2650.0},
        radius = 210,
        description = "Charming Beach Town"
    },

    -- TAMPA BAY BEACHES
    clearwater_beach = {
        name = "Clearwater Beach",
        region = "tampabay",
        center = {-1200.0, 400.0},
        radius = 220,
        description = "Gulf Coast Paradise"
    },
    st_pete_beach = {
        name = "St. Pete Beach",
        region = "tampabay",
        center = {-1100.0, 550.0},
        radius = 210,
        description = "Pristine White Sand"
    },
    caladesi_island = {
        name = "Caladesi Island",
        region = "tampabay",
        center = {-1050.0, 300.0},
        radius = 200,
        description = "Undeveloped Island Paradise"
    },

    -- ORLANDO BEACHES & LAKES
    wekiwa_springs = {
        name = "Wekiwa Springs",
        region = "orlando",
        center = {-1050.0, -450.0},
        radius = 180,
        description = "Natural Spring Resort"
    }
}

-- Transportation Hubs
Config.TransportationHubs = {
    {
        name = "Orlando International Airport",
        realLocation = "MCO - Orlando International",
        coords = {-250.5, 125.3, 69.2},
        heading = 0,
        description = "Major Airport Hub"
    },
    {
        name = "Jacksonville Airport",
        realLocation = "JAX - Jacksonville International",
        coords = {520.2, 150.3, 50.2},
        heading = 0,
        description = "Jacksonville Airport"
    },
    {
        name = "Miami International Airport",
        realLocation = "MIA - Miami International",
        coords = {305.2, 575.2, 80.2},
        heading = 0,
        description = "Major International Airport"
    },
    {
        name = "Amtrak - Orlando Station",
        realLocation = "Orlando Train Station",
        coords = {-300.2, -850.5, 29.2},
        heading = 0,
        description = "Passenger Rail Hub"
    }
}

-- Popular Attractions
Config.Attractions = {
    {
        name = "Magic Kingdom",
        region = "orlando",
        description = "Theme Park"
    },
    {
        name = "Epcot Center",
        region = "orlando",
        description = "Theme Park & Cultural Center"
    },
    {
        name = "Universal Studios",
        region = "orlando",
        description = "Movie Theme Park"
    },
    {
        name = "Kennedy Space Center",
        region = "melbou",
        description = "NASA Facility"
    },
    {
        name = "Daytona International Speedway",
        region = "melbou",
        description = "Racing Venue"
    },
    {
        name = "St. Augustine Historic District",
        region = "jacksonville",
        description = "Historic Colonial Area"
    }
}

-- Restaurant guide by region
Config.Restaurants = {
    orlando = {
        "The Coop",
        "Howl at the Moon",
        "Giordano's",
        "Taverna",
        "Player 1 Video Game Bar"
    },
    jacksonville = {
        "River and Post",
        "Orsay",
        "Orsay French Brasserie",
        "BB's Restaurant",
        "Taverna"
    },
    miami = {
        "Casa Tua",
        "Latin Café 2000",
        "Macchialato",
        "The Surf Club",
        "News Cafe"
    }
}

return Config
