-- Machine Gun America Configuration
-- Premium Full-Auto Shooting Range & Retail Store
-- Sources weapons from shared weapons catalog

Config = Config or {}

-- Import weapons catalog
local WeaponsCatalog = require 'shared.weapons_catalog'

Config.MachineGunAmerica = {
    ["machine_gun_america"] = {
        label = "Machine Gun America",
        brand = "machine_gun_america",
        color = {255, 0, 0},  -- Red (American)
        tagline = "Full-Auto Experience",
        description = "Premium Full-Auto & Tactical Weapons - Kissimmee - 250+ Models",
        
        -- Store categories from unified catalog (emphasis on military/full-auto capable)
        categories = {
            full_auto_pistols = {
                label = "Full-Auto Pistols & Select-Fire",
                items = {
                    { id = "glock_17", name = "Glock 17", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 450 },
                    { id = "glock_22_gen5", name = "Glock 22 Gen 5 - .40 S&W", price = 625 },
                    { id = "glock_10", name = "Glock 10 - 10MM", price = 850 },
                    { id = "sig_p226", name = "SIG Sauer P226", price = 600 },
                    { id = "hk_usp", name = "HK USP", price = 700 },
                    { id = "desert_eagle_50", name = "Desert Eagle .50", price = 1500 },
                    { id = "desert_eagle_xix", name = "Desert Eagle XIX", price = 1600 }
                }
            },
            full_auto_rifles = {
                label = "Full-Auto & Military Rifles",
                items = {
                    { id = "m4a1", name = "M4A1 (Tactical)", price = 1350 },
                    { id = "m16a2", name = "M16A2", price = 1150 },
                    { id = "m16a4", name = "M16A4", price = 1200 },
                    { id = "hk416", name = "HK416", price = 1600 },
                    { id = "hk417", name = "HK417", price = 1750 },
                    { id = "fn_scar_l", name = "FN SCAR-L", price = 1800 },
                    { id = "fn_scar_h", name = "FN SCAR-H", price = 1900 },
                    { id = "ak47", name = "AK-47 (Full-Auto Capable)", price = 1200 },
                    { id = "akm", name = "AKM", price = 1250 },
                    { id = "ak12", name = "AK-12", price = 1500 },
                    { id = "tar21", name = "TAR-21", price = 1450 },
                    { id = "tavor7", name = "Tavor 7", price = 1500 },
                    { id = "l85a2", name = "L85A2", price = 1350 },
                    { id = "l85a3", name = "L85A3", price = 1450 },
                    { id = "famas_g2", name = "FAMAS G2", price = 1400 }
                }
            },
            short_barrels = {
                label = "Short Barrel Rifles & SBRs",
                items = {
                    { id = "mk18", name = "MK18 CQBR", price = 1400 },
                    { id = "hk_mp5", name = "HK MP5", price = 1800 },
                    { id = "hk_mp5k", name = "HK MP5K", price = 1700 },
                    { id = "hk_ump45", name = "HK UMP45", price = 1900 },
                    { id = "draco", name = "DRACO Mini AK", price = 1100 },
                    { id = "cz_scorpion_evo3", name = "CZ Scorpion EVO 3", price = 1700 },
                    { id = "kriss_vector", name = "KRISS Vector", price = 2200 }
                }
            },
            machine_guns = {
                label = "Light & General Purpose Machine Guns",
                items = WeaponsCatalog.Config.WeaponsCatalog.lmgs
            },
            sniper_rifles = {
                label = "Precision & Sniper Rifles",
                items = WeaponsCatalog.Config.WeaponsCatalog.sniper_rifles
            },
            shotguns_tactical = {
                label = "Tactical Shotguns",
                items = {
                    { id = "remington_870", name = "Remington 870", price = 450 },
                    { id = "mossberg_590", name = "Mossberg 590", price = 550 },
                    { id = "mossberg_590a1", name = "Mossberg 590A1", price = 600 },
                    { id = "benelli_m4", name = "Benelli M4", price = 1200 },
                    { id = "benelli_m3", name = "Benelli M3", price = 1100 },
                    { id = "spas12", name = "SPAS-12", price = 1100 },
                    { id = "spas15", name = "SPAS-15", price = 1150 },
                    { id = "saiga12", name = "Saiga-12", price = 900 },
                    { id = "vepr12", name = "Vepr-12", price = 950 },
                    { id = "kriss_ks_tac", name = "Kel-Tec KSG", price = 900 },
                    { id = "utas_uts15", name = "UTAS UTS-15", price = 1000 },
                    { id = "aa12", name = "AA-12 Auto Shotgun", price = 2500 }
                }
            },
            smgs = {
                label = "Submachine Guns",
                items = WeaponsCatalog.Config.WeaponsCatalog.smgs
            },
            military_ammo = {
                label = "Military Ammunition",
                items = WeaponsCatalog.Config.WeaponsCatalog.ammunition
            },
            tactical_gear = {
                label = "Tactical Gear & Accessories",
                items = WeaponsCatalog.Config.WeaponsCatalog.accessories
            }
        },

        -- Flat item list for basic access
        items = {
            -- Full-Auto Rifles
            { id = "m4a1", name = "M4A1", price = 1350 },
            { id = "m16a2", name = "M16A2", price = 1150 },
            { id = "hk416", name = "HK416", price = 1600 },
            { id = "hk417", name = "HK417", price = 1750 },
            { id = "fn_scar_l", name = "FN SCAR-L", price = 1800 },
            { id = "fn_scar_h", name = "FN SCAR-H", price = 1900 },
            { id = "ak47", name = "AK-47", price = 1200 },
            { id = "ak12", name = "AK-12", price = 1500 },
            
            -- Tactical Pistols
            { id = "glock_22_gen5", name = "Glock 22 Gen 5", price = 625 },
            { id = "glock_10", name = "Glock 10", price = 850 },
            { id = "desert_eagle_50", name = "Desert Eagle .50", price = 1500 },
            { id = "hk_usp", name = "HK USP", price = 700 },
            
            -- SMGs/Machine Guns
            { id = "hk_mp5", name = "HK MP5", price = 1800 },
            { id = "hk_mp5k", name = "HK MP5K", price = 1700 },
            { id = "hk_ump45", name = "HK UMP45", price = 1900 },
            { id = "m249_saw", name = "M249 SAW", price = 2500 },
            { id = "m240b", name = "M240B", price = 3000 },
            
            -- Sniper Rifles
            { id = "barrett_m82", name = "Barrett M82", price = 4000 },
            { id = "accuracy_int_aw", name = "Accuracy International AW", price = 3500 },
            
            -- Tactical Shotgun
            { id = "benelli_m4", name = "Benelli M4", price = 1200 },
            { id = "aa12", name = "AA-12", price = 2500 },
            
            -- Ammunition
            { id = "ammo_556nato", name = "5.56 NATO Box", price = 55 },
            { id = "ammo_762nato", name = "7.62 NATO Box", price = 65 },
            { id = "ammo_50bmg", name = ".50 BMG Box", price = 200 }
        }
    }
}

Config.MachineGunAmericaBrand = {
    label = "Machine Gun America",
    textColor = {255, 0, 0},                -- Red
    backgroundColor = {240, 240, 240},     -- White background
    accentColor = {0, 0, 139},              -- Dark Blue accent
    borderColor = {255, 0, 0},              -- Red borders
    logoStyle = "military"
}

Config.MachineGunAmericaTaglines = {
    "Kissimmee's Full-Auto Destination",
    "250+ Military Grade Weapons",
    "Complete Tactical Arsenal",
    "Unleash The Power",
    "American Firepower",
    "Premium Tactical Experience",
    "Full-Auto Paradise",
    "Military Grade Equipment",
    "Experience The Difference",
    "Where Legends Are Made",
    "Tactical Excellence",
    "Full-Auto Specialists Since 2005"
}

return Config
