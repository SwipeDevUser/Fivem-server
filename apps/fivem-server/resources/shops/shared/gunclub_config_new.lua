-- Orlando Gun Club Configuration
-- Premium Firearms and Accessories Dealer
-- Sources weapons from shared weapons catalog

Config = Config or {}

-- Import weapons catalog
local WeaponsCatalog = require 'shared.weapons_catalog'

Config.OrlandoGunClub = {
    ["orlando_gun_club"] = {
        label = "Orlando Gun Club",
        brand = "orlando_gun_club",
        color = {178, 34, 34},  -- Dark Red (Firebrick)
        tagline = "Est. 2010 - Orlando's Premier Gun Club",
        description = "Professional firearms dealer with expert staff - Complete Selection",
        
        -- Store categories from unified catalog
        categories = {
            pistols = {
                label = "Premium Handguns",
                items = WeaponsCatalog.Config.WeaponsCatalog.pistols
            },
            revolvers = {
                label = "Revolvers & Magnums",
                items = WeaponsCatalog.Config.WeaponsCatalog.revolvers
            },
            rifles = {
                label = "Rifles & Carbines",
                items = WeaponsCatalog.Config.WeaponsCatalog.rifles
            },
            shotguns = {
                label = "Shotguns",
                items = WeaponsCatalog.Config.WeaponsCatalog.shotguns
            },
            sniper_rifles = {
                label = "Precision Rifles",
                items = WeaponsCatalog.Config.WeaponsCatalog.sniper_rifles
            },
            ammunition = {
                label = "Ammunition",
                items = WeaponsCatalog.Config.WeaponsCatalog.ammunition
            },
            accessories = {
                label = "Accessories & Gear",
                items = WeaponsCatalog.Config.WeaponsCatalog.accessories
            }
        },

        -- Flat item list for basic access (sample of most popular items)
        items = {
            -- Pistols
            { name = "glock_17", label = "Glock 17", price = 450 },
            { name = "glock_19", label = "Glock 19", price = 500 },
            { name = "glock_26", label = "Glock 26", price = 480 },
            { name = "glock_43", label = "Glock 43", price = 460 },
            { name = "sig_p226", label = "SIG Sauer P226", price = 600 },
            { name = "sig_p320", label = "SIG Sauer P320", price = 650 },
            { name = "beretta_92fs", label = "Beretta 92FS", price = 550 },
            { name = "colt_m1911", label = "Colt M1911", price = 700 },
            { name = "springfield_xd", label = "Springfield XD", price = 520 },
            { name = "fn_five_seven", label = "FN Five-seveN", price = 650 },
            { name = "sw_mp9", label = "S&W M&P9", price = 550 },
            { name = "hk_usp", label = "HK USP", price = 700 },
            { name = "desert_eagle_50", label = "Desert Eagle .50", price = 1500 },
            
            -- Revolvers
            { name = "sw_model_29", label = "S&W Model 29", price = 900 },
            { name = "colt_anaconda", label = "Colt Anaconda", price = 850 },
            
            -- Rifles
            { name = "m4a1", label = "M4A1", price = 1350 },
            { name = "m16a4", label = "M16A4", price = 1200 },
            { name = "ar15", label = "AR-15", price = 1200 },
            { name = "hk416", label = "HK416", price = 1600 },
            { name = "ak47", label = "AK-47", price = 1200 },
            { name = "draco", label = "DRACO Mini AK", price = 1100 },
            
            -- Shotguns
            { name = "remington_870", label = "Remington 870", price = 450 },
            { name = "mossberg_590", label = "Mossberg 590", price = 550 },
            { name = "benelli_m4", label = "Benelli M4", price = 1200 },
            
            -- Accessories
            { name = "scope_acog", label = "ACOG 4x32 Scope", price = 450 },
            { name = "holster_iwb", label = "IWB Holster", price = 80 },
            { name = "ammo_9mm", label = "9MM Ammo Box", price = 35 },
            { name = "ammo_556nato", label = "5.56 NATO Ammo Box", price = 55 }
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
    "250+ Weapons in Stock",
    "Complete Firearms Selection",
    "We Know Guns. We Know Service.",
    "Your Trusted Firearms Dealer",
    "Safety First, Always",
    "Where Shooters Come First",
    "Expert Staff, Premium Selection",
    "Professional Grade Equipment",
    "Building Shooters Since 2010"
}

return Config
