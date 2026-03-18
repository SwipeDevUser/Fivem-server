-- Machine Gun America Configuration
-- Premium Full-Auto Shooting Range & Retail Store

Config = Config or {}

Config.MachineGunAmerica = {
    ["machine_gun_america"] = {
        label = "Machine Gun America",
        brand = "machine_gun_america",
        color = {255, 0, 0},  -- Red (American)
        tagline = "Full-Auto Experience",
        description = "Premium Full-Auto Weapons & Tactical Gear - Kissimmee",
        
        -- Store categories
        categories = {
            full_auto = {
                label = "Full-Auto Weapons",
                items = {
                    { name = "m4_full_auto", label = "M4 Full-Auto Carbine", price = 3800 },
                    { name = "m14_full_auto", label = "M14 Full-Auto", price = 4200 },
                    { name = "ak47_auto", label = "AK-47 Full-Auto", price = 3500 },
                    { name = "m16_auto", label = "M16 Full-Auto", price = 3200 },
                    { name = "mp5_auto", label = "MP5 Full-Auto", price = 2800 },
                    { name = "ump45_auto", label = "UMP45 Full-Auto", price = 2500 }
                }
            },
            precision_rifles = {
                label = "Precision Rifles",
                items = {
                    { name = "barrett_50cal", label = "Barrett .50 Cal", price = 5000 },
                    { name = "m24_sniper", label = "M24 Sniper", price = 4200 },
                    { name = "awp_dragon", label = "AWP Dragon Lore", price = 6000 },
                    { name = "intervention", label = "CheyTac Intervention", price = 5500 }
                }
            },
            military_grade = {
                label = "Military Grade",
                items = {
                    { name = "m249_saw", label = "M249 SAW", price = 4000 },
                    { name = "m240_bravo", label = "M240 Bravo", price = 4500 },
                    { name = "minigun", label = "Minigun", price = 8000 },
                    { name = "rpg_launcher", label = "RPG Launcher", price = 10000 }
                }
            },
            tactical_pistols = {
                label = "Tactical Pistols",
                items = {
                    { name = "glock_22_gen5", label = "Glock 22 Gen 5 - .40 S&W", price = 625 },
                    { name = "glock_10", label = "Glock 10 - 10MM Tactical", price = 850 },
                    { name = "desert_eagle", label = "Desert Eagle .50", price = 1500 },
                    { name = "five_seven", label = "Five-Seven", price = 800 },
                    { name = "p250", label = "P250", price = 600 },
                    { name = "cz75", label = "CZ-75", price = 900 }
                }
            },
            shotguns_tactical = {
                label = "Tactical Shotguns",
                items = {
                    { name = "xm1014_auto", label = "XM1014 Auto-Shotgun", price = 2000 },
                    { name = "mag7_tactical", label = "MAG-7 Tactical", price = 1800 },
                    { name = "sawed_off", label = "Sawed-Off Shotgun", price = 1200 },
                    { name = "nova_tactical", label = "Nova Tactical", price = 1400 }
                }
            },
            military_ammunition = {
                label = "Military Ammunition",
                items = {
                    { name = "556_nato", label = "5.56 NATO Box", price = 75 },
                    { name = "762_nato", label = "7.62 NATO Box", price = 85 },
                    { name = "762x39", label = "7.62x39 Ammo Box", price = 70 },
                    { name = "10mm_mil", label = "10MM Military Box", price = 60 },
                    { name = "40sw_mil", label = ".40 S&W Military Box", price = 65 },
                    { name = "50bmg", label = ".50 BMG Box", price = 200 },
                    { name = "338_lapua", label = ".338 Lapua Box", price = 150 },
                    { name = "300_win_mag", label = ".300 Win Mag Box", price = 120 }
                }
            },
            tactical_gear = {
                label = "Tactical Gear",
                items = {
                    { name = "body_armor", label = "Body Armor - Level III", price = 800 },
                    { name = "tactical_vest", label = "Tactical Vest", price = 500 },
                    { name = "helmet_ballistic", label = "Ballistic Helmet", price = 600 },
                    { name = "laser_sight", label = "Laser Sight Module", price = 400 },
                    { name = "suppressor", label = "Tactical Suppressor", price = 350 },
                    { name = "acog_scope", label = "ACOG 4x32 Scope", price = 450 },
                    { name = "red_dot_sight", label = "Red Dot Sight", price = 300 },
                    { name = "night_vision", label = "Night Vision Goggles", price = 1200 }
                }
            },
            ammunition_belts = {
                label = "Ammunition Belts",
                items = {
                    { name = "belt_556", label = "5.56 Ammo Belt", price = 180 },
                    { name = "belt_762", label = "7.62 Ammo Belt", price = 200 },
                    { name = "mag_extended", label = "Extended Magazine", price = 120 },
                    { name = "mag_drum", label = "Drum Magazine", price = 250 }
                }
            }
        },

        -- Flat item list for basic access
        items = {
            { name = "m4_full_auto", label = "M4 Full-Auto Carbine", price = 3800 },
            { name = "m14_full_auto", label = "M14 Full-Auto", price = 4200 },
            { name = "ak47_auto", label = "AK-47 Full-Auto", price = 3500 },
            { name = "m16_auto", label = "M16 Full-Auto", price = 3200 },
            { name = "barrett_50cal", label = "Barrett .50 Cal", price = 5000 },
            { name = "glock_22_gen5", label = "Glock 22 Gen 5", price = 625 },
            { name = "556_nato", label = "5.56 NATO Box", price = 75 }
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
