-- Orlando Gun Club Configuration
-- Premium Firearms and Accessories Dealer

Config = Config or {}

Config.OrlandoGunClub = {
    ["orlando_gun_club"] = {
        label = "Orlando Gun Club",
        brand = "orlando_gun_club",
        color = {178, 34, 34},  -- Dark Red (Firebrick)
        tagline = "Est. 2010 - Orlando's Premier Gun Club",
        description = "Professional firearms dealer with expert staff",
        
        -- Store categories
        categories = {
            pistols = {
                label = "Pistols & Handguns",
                items = {
                    { name = "glock_19_gen3", label = "Glock 19 Gen 3 - 9MM", price = 550 },
                    { name = "glock_22_gen5", label = "Glock 22 Gen 5 - .40 S&W", price = 625 },
                    { name = "glock_10", label = "Glock 10 - 10MM", price = 700 },
                    { name = "glock_9", label = "Glock 9 - 9MM Compact", price = 480 },
                    { name = "pistol_45", label = ".45 ACP Pistol", price = 650 },
                    { name = "pistol_357", label = ".357 Magnum Revolver", price = 700 },
                    { name = "pistol_22", label = ".22 Pistol", price = 400 }
                }
            },
            rifles = {
                label = "Rifles & Carbines",
                items = {
                    { name = "m4_carbine", label = "M4 Carbine - 5.56 NATO", price = 1450 },
                    { name = "m14", label = "M14 Standard - 7.62 NATO", price = 1650 },
                    { name = "ar15", label = "AR-15 Rifle - 5.56 NATO", price = 1200 },
                    { name = "ar9", label = "AR-9 Pistol Caliber - 9MM", price = 950 },
                    { name = "draco", label = "DRACO Mini AK - 7.62x39", price = 1100 },
                    { name = "rifle_308", label = ".308 Rifle", price = 1400 },
                    { name = "rifle_22", label = ".22 Rifle", price = 600 }
                }
            },
            shotguns = {
                label = "Shotguns",
                items = {
                    { name = "shotgun_12ga", label = "12 Gauge Shotgun", price = 800 },
                    { name = "shotgun_20ga", label = "20 Gauge Shotgun", price = 700 },
                    { name = "shotgun_410", label = ".410 Shotgun", price = 600 }
                }
            },
            ammunition = {
                label = "Ammunition",
                items = {
                    { name = "ammo_9mm", label = "9MM Ammo Box", price = 35 },
                    { name = "ammo_40sw", label = ".40 S&W Ammo Box", price = 40 },
                    { name = "ammo_10mm", label = "10MM Ammo Box", price = 45 },
                    { name = "ammo_45", label = ".45 ACP Ammo Box", price = 45 },
                    { name = "ammo_357", label = ".357 Magnum Ammo Box", price = 40 },
                    { name = "ammo_556", label = "5.56 NATO Ammo Box", price = 55 },
                    { name = "ammo_762", label = "7.62 NATO Ammo Box", price = 65 },
                    { name = "ammo_762x39", label = "7.62x39 Ammo Box", price = 50 },
                    { name = "ammo_308", label = ".308 Ammo Box", price = 60 },
                    { name = "ammo_12ga", label = "12 Gauge Shells", price = 45 },
                    { name = "ammo_22", label = ".22 Ammo Box", price = 20 }
                }
            },
            accessories = {
                label = "Accessories",
                items = {
                    { name = "scope", label = "Tactical Scope", price = 250 },
                    { name = "holster", label = "IWB Holster", price = 80 },
                    { name = "mag_9mm", label = "9MM Magazine", price = 40 },
                    { name = "mag_45", label = ".45 Magazine", price = 50 },
                    { name = "sling", label = "Rifle Sling", price = 60 },
                    { name = "case", label = "Hard Case", price = 150 },
                    { name = "cleaning_kit", label = "Cleaning Kit", price = 75 },
                    { name = "ammo_pouch", label = "Ammo Pouch", price = 45 }
                }
            },
            safety = {
                label = "Safety Gear",
                items = {
                    { name = "ear_protection", label = "Ear Protection", price = 60 },
                    { name = "eye_protection", label = "Eye Protection", price = 50 },
                    { name = "shooting_gloves", label = "Shooting Gloves", price = 45 },
                    { name = "range_mat", label = "Range Mat", price = 35 }
                }
            }
        },

        -- Flat item list for basic access
        items = {
            { name = "glock_19_gen3", label = "Glock 19 Gen 3", price = 550 },
            { name = "m4_carbine", label = "M4 Carbine", price = 1450 },
            { name = "draco", label = "DRACO Mini AK", price = 1100 },
            { name = "shotgun_12ga", label = "12 Gauge Shotgun", price = 800 },
            { name = "ammo_9mm", label = "9MM Ammo Box", price = 35 },
            { name = "ammo_556", label = "5.56 NATO Ammo Box", price = 55 },
            { name = "scope", label = "Tactical Scope", price = 250 },
            { name = "holster", label = "IWB Holster", price = 80 }
        }
    }
}

Config.OrlandoGunClubBrand = {
    label = "Orlando Gun Club",
    textColor = {178, 34, 34},              -- Dark Red (Firebrick)
    backgroundColor = {245, 245, 245},     -- White Smoke background
    accentColor = {255, 215, 0},            -- Gold accents
    borderColor = {139, 69, 19},            -- Saddle Brown borders
    logoStyle = "professional"
}

Config.OrlandoGunClubTaglines = {
    "Est. 2010 - Orlando's Premier Gun Club",
    "We Know Guns. We Know Service.",
    "Your Trusted Firearms Dealer",
    "Safety First, Always",
    "Where Shooters Come First",
    "Expert Staff, Premium Selection",
    "Professional Grade Equipment",
    "Building Shooters Since 2010"
}

return Config
