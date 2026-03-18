-- Comprehensive Weapons Catalog
-- Organized by type and category for easy access

Config = Config or {}

Config.WeaponsCatalog = {
    -- PISTOLS: Service & Combat
    pistols = {
        -- Glock Series
        { id = "glock_17", name = "Glock 17", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 450 },
        { id = "glock_19", name = "Glock 19", model = "weapon_pistol", caliber = "9MM", type = "compact_pistol", price = 500 },
        { id = "glock_26", name = "Glock 26", model = "weapon_pistol", caliber = "9MM", type = "subcompact_pistol", price = 480 },
        { id = "glock_34", name = "Glock 34", model = "weapon_pistol", caliber = "9MM", type = "competition_pistol", price = 550 },
        { id = "glock_43", name = "Glock 43", model = "weapon_pistol", caliber = "9MM", type = "ultra_compact", price = 460 },
        { id = "glock_45", name = "Glock 45", model = "weapon_pistol", caliber = "9MM", type = "full_size", price = 520 },

        -- SIG Sauer Series
        { id = "sig_p226", name = "SIG Sauer P226", model = "weapon_pistol", caliber = ".357 SIG / 9MM", type = "service_pistol", price = 600 },
        { id = "sig_p229", name = "SIG Sauer P229", model = "weapon_pistol", caliber = ".40 S&W / 9MM", type = "compact_pistol", price = 580 },
        { id = "sig_p320", name = "SIG Sauer P320", model = "weapon_pistol", caliber = "9MM / .40 / .45", type = "modular_pistol", price = 650 },
        { id = "sig_p365", name = "SIG Sauer P365", model = "weapon_pistol", caliber = "9MM", type = "ultracompact", price = 520 },

        -- Beretta Series
        { id = "beretta_92fs", name = "Beretta 92FS", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 550 },
        { id = "beretta_m9", name = "Beretta M9", model = "weapon_pistol", caliber = "9MM", type = "military_pistol", price = 560 },
        { id = "beretta_apx", name = "Beretta APX", model = "weapon_pistol", caliber = "9MM", type = "modern_pistol", price = 570 },

        -- Colt 1911 Series
        { id = "colt_m1911", name = "Colt M1911", model = "weapon_pistol", caliber = ".45 ACP", type = "classic_pistol", price = 700 },
        { id = "colt_python", name = "Colt Python", model = "weapon_pistol", caliber = ".357 Magnum", type = "revolver", price = 750 },

        -- Premium 1911 Variants
        { id = "kimber_custom2", name = "Kimber Custom II", model = "weapon_pistol", caliber = ".45 ACP", type = "premium_1911", price = 800 },
        { id = "rock_island_1911", name = "Rock Island 1911", model = "weapon_pistol", caliber = ".45 ACP", type = "affordable_1911", price = 550 },
        { id = "nighthawk_1911", name = "Nighthawk Custom 1911", model = "weapon_pistol", caliber = ".45 ACP", type = "custom_1911", price = 1200 },
        { id = "wilson_edc_x9", name = "Wilson Combat EDC X9", model = "weapon_pistol", caliber = "9MM", type = "premium_1911", price = 1300 },

        -- Springfield Series
        { id = "springfield_xd", name = "Springfield XD", model = "weapon_pistol", caliber = "9MM / .40 / .45", type = "polymer_pistol", price = 520 },
        { id = "springfield_hellcat", name = "Springfield Hellcat", model = "weapon_pistol", caliber = "9MM", type = "ultracompact", price = 500 },

        -- FN Series
        { id = "fn_five_seven", name = "FN Five-seveN", model = "weapon_pistol", caliber = "5.7x28", type = "tactical_pistol", price = 650 },
        { id = "fn_fnx_45", name = "FN FNX-45", model = "weapon_pistol", caliber = ".45 ACP", type = "tactical_pistol", price = 750 },

        -- CZ Series
        { id = "cz_75", name = "CZ-75", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 520 },
        { id = "cz_p10c", name = "CZ P-10C", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 550 },
        { id = "cz_shadow2", name = "CZ Shadow 2", model = "weapon_pistol", caliber = "9MM", type = "competition_pistol", price = 900 },

        -- Walther Series
        { id = "walther_ppk", name = "Walther PPK", model = "weapon_pistol", caliber = ".380 ACP", type = "classic_compact", price = 450 },
        { id = "walther_ppq", name = "Walther PPQ", model = "weapon_pistol", caliber = "9MM / .40", type = "polymer_pistol", price = 600 },
        { id = "walther_pdp", name = "Walther PDP", model = "weapon_pistol", caliber = "9MM", type = "modern_pistol", price = 620 },

        -- HK Series
        { id = "hk_usp", name = "HK USP", model = "weapon_pistol", caliber = "9MM / .40 / .45", type = "tactical_pistol", price = 700 },
        { id = "hk_vp9", name = "HK VP9", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 680 },
        { id = "hk_p30", name = "HK P30", model = "weapon_pistol", caliber = "9MM / .40", type = "service_pistol", price = 650 },

        -- Ruger Series
        { id = "ruger_sr9", name = "Ruger SR9", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 480 },
        { id = "ruger_lc9", name = "Ruger LC9", model = "weapon_pistol", caliber = "9MM", type = "compact_pistol", price = 450 },
        { id = "ruger_security9", name = "Ruger Security-9", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 500 },

        -- Taurus Series
        { id = "taurus_g2c", name = "Taurus G2C", model = "weapon_pistol", caliber = "9MM", type = "budget_pistol", price = 300 },
        { id = "taurus_g3", name = "Taurus G3", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 350 },
        { id = "taurus_pt92", name = "Taurus PT92", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 400 },

        -- Smith & Wesson Series
        { id = "sw_mp9", name = "S&W M&P9", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 550 },
        { id = "sw_shield", name = "S&W Shield", model = "weapon_pistol", caliber = "9MM / .40", type = "compact_pistol", price = 480 },
        { id = "sw_sd9ve", name = "S&W SD9 VE", model = "weapon_pistol", caliber = "9MM", type = "budget_pistol", price = 350 },

        -- Desert Eagle Series
        { id = "desert_eagle_50", name = "Desert Eagle .50", model = "weapon_pistol", caliber = ".50 AE", type = "semi_auto_pistol", price = 1500 },
        { id = "desert_eagle_xix", name = "Desert Eagle XIX", model = "weapon_pistol", caliber = ".50 AE / .357", type = "premium_magnum", price = 1600 },

        -- Premium European
        { id = "browning_hipower", name = "Browning Hi-Power", model = "weapon_pistol", caliber = "9MM", type = "classic_pistol", price = 650 },
        { id = "iwi_masada", name = "IWI Masada", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 580 },
        { id = "canik_tp9", name = "Canik TP9", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 500 },
        { id = "canik_mete", name = "Canik Mete", model = "weapon_pistol", caliber = "9MM", type = "compact_pistol", price = 480 },
        { id = "steyr_m9", name = "Steyr M9", model = "weapon_pistol", caliber = "9MM", type = "polymer_pistol", price = 600 },
        { id = "steyr_l9", name = "Steyr L9", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 650 },

        -- Premium Competition/Custom
        { id = "sti_staccato_p", name = "STI Staccato P", model = "weapon_pistol", caliber = "9MM", type = "competition_1911", price = 2500 },
        { id = "sti_staccato_c2", name = "STI Staccato C2", model = "weapon_pistol", caliber = "9MM", type = "compact_1911", price = 2200 },
        { id = "grand_power_k100", name = "Grand Power K100", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 650 },
        { id = "arsenal_strike", name = "Arsenal Strike One", model = "weapon_pistol", caliber = "9MM", type = "premium_pistol", price = 850 },
        { id = "hudson_h9", name = "Hudson H9", model = "weapon_pistol", caliber = "9MM", type = "compact_1911", price = 1200 },
        { id = "arex_zero1", name = "Arex Rex Zero 1", model = "weapon_pistol", caliber = "9MM", type = "service_pistol", price = 600 },

        -- Specialty Pistols
        { id = "kahr_pm9", name = "Kahr PM9", model = "weapon_pistol", caliber = "9MM", type = "ultra_compact", price = 750 },
        { id = "kahr_cw9", name = "Kahr CW9", model = "weapon_pistol", caliber = "9MM", type = "compact_pistol", price = 650 },
        { id = "chiappa_rhino", name = "Chiappa Rhino (Pistol)", model = "weapon_pistol", caliber = ".357 Magnum", type = "revolving_pistol", price = 900 },
        { id = "tanfoglio_witness", name = "Tanfoglio Witness", model = "weapon_pistol", caliber = "9MM / .40 / .45", type = "service_pistol", price = 550 },
        { id = "jericho_941", name = "Jericho 941", model = "weapon_pistol", caliber = "9MM / .41", type = "service_pistol", price = 600 },
        { id = "imi_desert_eagle", name = "IMI Desert Eagle Mk VII", model = "weapon_pistol", caliber = ".50 AE", type = "premium_magnum", price = 1700 },
    },

    -- REVOLVERS: Classic & Modern
    revolvers = {
        { id = "colt_anaconda", name = "Colt Anaconda", model = "weapon_revolver", caliber = ".44 Magnum", type = "magnum_revolver", price = 850 },
        { id = "colt_king_cobra", name = "Colt King Cobra", model = "weapon_revolver", caliber = ".357 Magnum", type = "service_revolver", price = 750 },
        { id = "sw_model_29", name = "S&W Model 29", model = "weapon_revolver", caliber = ".44 Magnum", type = "magnum_revolver", price = 900 },
        { id = "sw_model_686", name = "S&W Model 686", model = "weapon_revolver", caliber = ".357 Magnum", type = "service_revolver", price = 700 },
        { id = "sw_model_500", name = "S&W Model 500", model = "weapon_revolver", caliber = ".500 Smith & Wesson", type = "magnum_revolver", price = 1200 },
        { id = "sw_model_642", name = "S&W Model 642", model = "weapon_revolver", caliber = ".38 Special", type = "compact_revolver", price = 500 },
        { id = "sw_model_10", name = "S&W Model 10", model = "weapon_revolver", caliber = ".38 Special", type = "service_revolver", price = 550 },
        { id = "sw_model_19", name = "S&W Model 19", model = "weapon_revolver", caliber = ".357 Magnum", type = "service_revolver", price = 650 },
        { id = "sw_model_27", name = "S&W Model 27", model = "weapon_revolver", caliber = ".357 Magnum", type = "service_revolver", price = 700 },
        { id = "ruger_gp100", name = "Ruger GP100", model = "weapon_revolver", caliber = ".357 Magnum", type = "service_revolver", price = 650 },
        { id = "ruger_redhawk", name = "Ruger Redhawk", model = "weapon_revolver", caliber = ".44 Magnum", type = "magnum_revolver", price = 900 },
        { id = "ruger_super_redhawk", name = "Ruger Super Redhawk", model = "weapon_revolver", caliber = ".44 Magnum / .480", type = "magnum_revolver", price = 1050 },
        { id = "ruger_lcr", name = "Ruger LCR", model = "weapon_revolver", caliber = ".38 Special / .357", type = "compact_revolver", price = 550 },
        { id = "taurus_judge", name = "Taurus Judge", model = "weapon_revolver", caliber = ".410 / .45 Colt", type = "specialty_revolver", price = 700 },
        { id = "taurus_raging_bull", name = "Taurus Raging Bull", model = "weapon_revolver", caliber = ".44 Magnum", type = "magnum_revolver", price = 750 },
        { id = "taurus_85", name = "Taurus Model 85", model = "weapon_revolver", caliber = ".38 Special", type = "compact_revolver", price = 450 },
        { id = "charter_bulldog", name = "Charter Arms Bulldog", model = "weapon_revolver", caliber = ".44 Special", type = "compact_revolver", price = 520 },
        { id = "mateba_autorevolver", name = "Mateba Autorevolver", model = "weapon_revolver", caliber = ".454 Casull / .45 Colt", type = "specialty_revolver", price = 1500 },
        { id = "nagant_m1895", name = "Nagant M1895", model = "weapon_revolver", caliber = "7.62x38R", type = "historical_revolver", price = 450 },
        { id = "webley_mk6", name = "Webley Mk VI", model = "weapon_revolver", caliber = ".455 Webley", type = "historical_revolver", price = 500 },
        { id = "colt_detective", name = "Colt Detective Special", model = "weapon_revolver", caliber = ".38 Special", type = "compact_revolver", price = 500 },
        { id = "colt_diamondback", name = "Colt Diamondback", model = "weapon_revolver", caliber = ".38 Special / .357", type = "service_revolver", price = 700 },
        { id = "freedom_arms_83", name = "Freedom Arms Model 83", model = "weapon_revolver", caliber = ".475 Linebaugh / .454", type = "premium_revolver", price = 1800 },
        { id = "ruger_blackhawk", name = "Ruger Blackhawk", model = "weapon_revolver", caliber = ".357 / .41 / .44", type = "western_revolver", price = 650 },
        { id = "ruger_vaquero", name = "Ruger Vaquero", model = "weapon_revolver", caliber = ".357 / .45 Colt", type = "western_revolver", price = 700 },
        { id = "uberti_cattleman", name = "Uberti Cattleman", model = "weapon_revolver", caliber = ".357 / .45 Colt", type = "western_revolver", price = 550 },
        { id = "rossi_971", name = "Rossi Model 971", model = "weapon_revolver", caliber = ".357 Magnum", type = "service_revolver", price = 500 },
        { id = "dan_wesson_715", name = "Dan Wesson 715", model = "weapon_revolver", caliber = ".357 Magnum", type = "premium_revolver", price = 1400 },
        { id = "chiappa_rhino_rev", name = "Chiappa Rhino", model = "weapon_revolver", caliber = ".357 Magnum", type = "specialty_revolver", price = 950 },
    },

    -- SUBMACHINE GUNS & SMGs
    smgs = {
        -- HK Series
        { id = "hk_mp5", name = "HK MP5", model = "weapon_smg", caliber = "9MM", type = "universal_smg", price = 1800 },
        { id = "hk_mp5k", name = "HK MP5K", model = "weapon_smg", caliber = "9MM", type = "compact_smg", price = 1700 },
        { id = "hk_ump45", name = "HK UMP45", model = "weapon_smg", caliber = ".45 ACP", type = "modern_smg", price = 1900 },
        { id = "hk_mp7", name = "HK MP7", model = "weapon_smg", caliber = "4.6x30", type = "modern_smg", price = 2100 },
        { id = "hk_mp9", name = "HK MP9", model = "weapon_smg", caliber = "9MM", type = "compact_smg", price = 1700 },
        { id = "hk_apc9", name = "HK APC9", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 2000 },

        -- Uzi Family
        { id = "uzi", name = "Uzi", model = "weapon_smg", caliber = "9MM", type = "classic_smg", price = 1500 },
        { id = "mini_uzi", name = "Mini Uzi", model = "weapon_smg", caliber = "9MM", type = "compact_smg", price = 1600 },
        { id = "micro_uzi", name = "Micro Uzi", model = "weapon_smg", caliber = "9MM", type = "ultracompact_smg", price = 1550 },

        -- CZ Series
        { id = "cz_scorpion_evo3", name = "CZ Scorpion EVO 3", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1700 },
        { id = "cz_scorpion_3", name = "CZ Scorpion 3+", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1750 },

        -- KRISS & Vector
        { id = "kriss_vector", name = "KRISS Vector", model = "weapon_smg", caliber = "9MM / .45", type = "modern_smg", price = 2200 },
        { id = "tdi_vector_gen2", name = "TDI Vector Gen II", model = "weapon_smg", caliber = "9MM / .45", type = "modern_smg", price = 2100 },

        -- Classic/Vintage SMGs
        { id = "mac10", name = "MAC-10", model = "weapon_smg", caliber = "9MM / .45", type = "vintage_smg", price = 1200 },
        { id = "mac11", name = "MAC-11", model = "weapon_smg", caliber = "9MM / .380", type = "compact_vintage", price = 1100 },
        { id = "thompson_m1928", name = "Thompson M1928", model = "weapon_smg", caliber = ".45 ACP", type = "historical_smg", price = 2500 },
        { id = "thompson_m1a1", name = "Thompson M1A1", model = "weapon_smg", caliber = ".45 ACP", type = "historical_smg", price = 2400 },
        { id = "sterling_smg", name = "Sterling SMG", model = "weapon_smg", caliber = "9MM", type = "historical_smg", price = 1400 },
        { id = "sten_mk2", name = "Sten Mk II", model = "weapon_smg", caliber = "9MM", type = "historical_smg", price = 1100 },
        { id = "sten_mk5", name = "Sten Mk V", model = "weapon_smg", caliber = "9MM", type = "historical_smg", price = 1200 },

        -- Russian SMGs
        { id = "pp19_bizon", name = "PP-19 Bizon", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1500 },
        { id = "pp2000", name = "PP-2000", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1400 },
        { id = "vityaz_sn", name = "Vityaz-SN", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1600 },
        { id = "aps_stechkin", name = "APS Stechkin", model = "weapon_smg", caliber = "9MM", type = "vintage_smg", price = 900 },

        -- Other Europe
        { id = "beretta_m12", name = "Beretta M12", model = "weapon_smg", caliber = "9MM", type = "vintage_smg", price = 1300 },
        { id = "beretta_pmx", name = "Beretta PMX", model = "weapon_smg", caliber = "9MM / .45", type = "modern_smg", price = 1850 },
        { id = "calico_m960", name = "Calico M960", model = "weapon_smg", caliber = "9MM / .22", type = "specialty_smg", price = 1400 },
        { id = "b_t_apc9", name = "B&T APC9", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1900 },
        { id = "b_t_mp9", name = "B&T MP9", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1800 },
        { id = "sigmpx", name = "SIG MPX", model = "weapon_smg", caliber = "9MM", type = "modular_smg", price = 2000 },
        { id = "sig_mcx_rattler", name = "SIG MCX Rattler (SMG)", model = "weapon_smg", caliber = "300BLK", type = "modern_smg", price = 2200 },
        { id = "scorpion_micro", name = "Scorpion Micro", model = "weapon_smg", caliber = "9MM", type = "compact_smg", price = 1600 },

        -- P90 Variants
        { id = "fn_p90", name = "P90", model = "weapon_smg", caliber = "5.7x28", type = "bullpup_smg", price = 2000 },
        { id = "ar57", name = "AR-57", model = "weapon_smg", caliber = "5.7x28", type = "ar_conversion", price = 1800 },
        { id = "fn_p90_tr", name = "FN P90 TR", model = "weapon_smg", caliber = ".45 ACP", type = "bullpup_variant", price = 2100 },

        -- International SMGs
        { id = "famae_saf", name = "FAMAE SAF", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1600 },
        { id = "lwrc_smg45", name = "LWRC SMG-45", model = "weapon_smg", caliber = ".45 ACP", type = "modern_smg", price = 1900 },
        { id = "suomi_kp31", name = "Suomi KP/-31", model = "weapon_smg", caliber = "9MM", type = "historical_smg", price = 1300 },
        { id = "owen_gun", name = "Owen Gun", model = "weapon_smg", caliber = "9MM", type = "historical_smg", price = 1400 },
        { id = "ump9", name = "UMP9", model = "weapon_smg", caliber = "9MM", type = "modern_smg", price = 1750 },
        { id = "ump40", name = "UMP40", model = "weapon_smg", caliber = ".40 S&W", type = "modern_smg", price = 1800 },
    },

    -- RIFLES & CARBINES
    rifles = {
        -- AK Family
        { id = "ak47", name = "AK-47", model = "weapon_rifle", caliber = "7.62x39", type = "classic_rifle", price = 1200 },
        { id = "akm", name = "AKM", model = "weapon_rifle", caliber = "7.62x39", type = "modern_ak", price = 1250 },
        { id = "ak74", name = "AK-74", model = "weapon_rifle", caliber = "5.45x39", type = "modern_rifle", price = 1300 },
        { id = "ak12", name = "AK-12", model = "weapon_rifle", caliber = "5.45x39 / 7.62x39", type = "modern_rifle", price = 1500 },
        { id = "ak103", name = "AK-103", model = "weapon_rifle", caliber = "7.62x39", type = "tactical_rifle", price = 1400 },
        { id = "ak105", name = "AK-105", model = "weapon_rifle", caliber = "5.45x39", type = "carbine_rifle", price = 1350 },
        { id = "draco", name = "DRACO Mini AK", model = "weapon_rifle", caliber = "7.62x39", type = "pistol_carbine", price = 1100 },
        { id = "norinco_56", name = "Norinco Type 56", model = "weapon_rifle", caliber = "7.62x39", type = "ak_variant", price = 900 },
        { id = "norinco_81", name = "Norinco Type 81", model = "weapon_rifle", caliber = "7.62x39", type = "ak_variant", price = 950 },
        { id = "zastava_m70", name = "Zastava M70", model = "weapon_rifle", caliber = "7.62x39", type = "ak_variant", price = 1050 },
        { id = "zastava_m92", name = "Zastava M92", model = "weapon_rifle", caliber = "7.62x39", type = "pistol_carbine", price = 900 },
        { id = "valmet_rk62", name = "Valmet RK 62", model = "weapon_rifle", caliber = "7.62x39", type = "ak_variant", price = 1100 },
        { id = "galil_arm", name = "Galil ARM", model = "weapon_rifle", caliber = "5.56 / 7.62", type = "ak_variant", price = 1300 },
        { id = "galil_ace", name = "Galil ACE", model = "weapon_rifle", caliber = "5.56 NATO", type = "modern_ak", price = 1400 },

        -- M16/M4
        { id = "m16a1", name = "M16A1", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1100 },
        { id = "m16a2", name = "M16A2", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1150 },
        { id = "m16a4", name = "M16A4", model = "weapon_rifle", caliber = "5.56 NATO", type = "tactical_rifle", price = 1200 },
        { id = "m4a1", name = "M4A1", model = "weapon_rifle", caliber = "5.56 NATO", type = "carbine_rifle", price = 1350 },
        { id = "mk18", name = "MK18", model = "weapon_rifle", caliber = "5.56 NATO", type = "short_carbine", price = 1400 },

        -- AR-15 Variants
        { id = "ar15", name = "AR-15", model = "weapon_rifle", caliber = "5.56 NATO / .223", type = "rifle_platform", price = 1200 },
        { id = "ar9", name = "AR-9", model = "weapon_rifle", caliber = "9MM", type = "pistol_caliber", price = 950 },
        { id = "daniel_defense_m4", name = "Daniel Defense M4", model = "weapon_rifle", caliber = "5.56 NATO", type = "tactical_carbine", price = 1600 },
        { id = "lwrc_ic_a5", name = "LWRC IC-A5", model = "weapon_rifle", caliber = "5.56 NATO", type = "tactical_rifle", price = 1700 },
        { id = "bushmaster_xm15", name = "Bushmaster XM15", model = "weapon_rifle", caliber = "5.56 NATO", type = "rifle_platform", price = 1100 },
        { id = "robinson_xcr", name = "Robinson XCR", model = "weapon_rifle", caliber = "5.56 NATO / 7.62", type = "modular_rifle", price = 1500 },

        -- HK Family
        { id = "hk416", name = "HK416", model = "weapon_rifle", caliber = "5.56 NATO", type = "tactical_rifle", price = 1600 },
        { id = "hk417", name = "HK417", model = "weapon_rifle", caliber = "7.62 NATO", type = "tactical_rifle", price = 1750 },
        { id = "hk_g36", name = "HK G36", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1400 },
        { id = "hk_g3", name = "HK G3", model = "weapon_rifle", caliber = "7.62 NATO", type = "battle_rifle", price = 1300 },
        { id = "hk433", name = "HK433", model = "weapon_rifle", caliber = "5.56 NATO", type = "modern_rifle", price = 1550 },

        -- FN Family
        { id = "fn_scar_l", name = "FN SCAR-L", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1800 },
        { id = "fn_scar_h", name = "FN SCAR-H", model = "weapon_rifle", caliber = "7.62 NATO", type = "designated_mk", price = 1900 },
        { id = "fn_fal", name = "FN FAL", model = "weapon_rifle", caliber = "7.62 NATO", type = "battle_rifle", price = 1400 },
        { id = "fn_fnc", name = "FN FNC", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1200 },
        { id = "sig_sig550", name = "SIG SG 550", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1500 },
        { id = "sig_sig553", name = "SIG SG 553", model = "weapon_rifle", caliber = "5.56 NATO", type = "carbine_rifle", price = 1450 },
        { id = "sig_mcx", name = "SIG MCX", model = "weapon_rifle", caliber = "300BLK / 5.56", type = "modular_rifle", price = 1700 },
        { id = "sig_spear", name = "SIG Spear", model = "weapon_rifle", caliber = "6.8x51", type = "battle_rifle", price = 2000 },

        -- European Others
        { id = "steyr_aug", name = "Steyr AUG", model = "weapon_rifle", caliber = "5.56 NATO", type = "bullpup_rifle", price = 1400 },
        { id = "aug_a3", name = "AUG A3", model = "weapon_rifle", caliber = "5.56 NATO", type = "bullpup_rifle", price = 1500 },
        { id = "tar21", name = "TAR-21", model = "weapon_rifle", caliber = "5.56 NATO", type = "bullpup_rifle", price = 1450 },
        { id = "x95", name = "X95", model = "weapon_rifle", caliber = "5.56 NATO / 7.62", type = "bullpup_rifle", price = 1500 },
        { id = "l85a2", name = "L85A2", model = "weapon_rifle", caliber = "5.56 NATO", type = "bullpup_rifle", price = 1350 },
        { id = "l85a3", name = "L85A3", model = "weapon_rifle", caliber = "5.56 NATO", type = "modern_bullpup", price = 1450 },
        { id = "famas_f1", name = "FAMAS F1", model = "weapon_rifle", caliber = "5.56 NATO", type = "bullpup_rifle", price = 1300 },
        { id = "famas_g2", name = "FAMAS G2", model = "weapon_rifle", caliber = "5.56 NATO", type = "modern_bullpup", price = 1400 },
        { id = "cz_bren2", name = "CZ Bren 2", model = "weapon_rifle", caliber = "5.56 NATO / 7.62", type = "modular_rifle", price = 1600 },

        -- Asian Rifles
        { id = "qbz95", name = "QBZ-95", model = "weapon_rifle", caliber = "5.8x42", type = "bullpup_rifle", price = 1200 },
        { id = "qbz03", name = "QBZ-03", model = "weapon_rifle", caliber = "5.8x42", type = "carbine_rifle", price = 1150 },
        { id = "daewoo_k2", name = "Daewoo K2", model = "weapon_rifle", caliber = "5.56 NATO", type = "military_rifle", price = 1100 },
        { id = "imi_galatz", name = "IMI Galatz", model = "weapon_rifle", caliber = "7.62 NATO", type = "sniper_rifle", price = 1600 },
        { id = "sar21", name = "SAR-21", model = "weapon_rifle", caliber = "5.56 NATO", type = "bullpup_rifle", price = 1300 },
        { id = "tavor7", name = "Tavor 7", model = "weapon_rifle", caliber = "7.62 NATO", type = "bullpup_rifle", price = 1500 },

        -- European Modular Systems
        { id = "beretta_arx160", name = "Beretta ARX160", model = "weapon_rifle", caliber = "5.56 NATO", type = "modular_rifle", price = 1400 },
        { id = "vhs2", name = "VHS-2", model = "weapon_rifle", caliber = "5.56 NATO", type = "modular_rifle", price = 1500 },
        { id = "msbs_grot", name = "MSBS Grot", model = "weapon_rifle", caliber = "5.56 NATO", type = "modular_rifle", price = 1450 },
        
        -- Specialty/Experimental
        { id = "acr", name = "Adaptive Combat Rifle", model = "weapon_rifle", caliber = "5.56 NATO / 7.62", type = "modular_rifle", price = 1800 },
        { id = "xm8", name = "XM8", model = "weapon_rifle", caliber = "5.56 NATO", type = "experimental_rifle", price = 1500 },
        { id = "iwi_carmel", name = "IWI Carmel", model = "weapon_rifle", caliber = "5.56 NATO / 7.62", type = "modular_rifle", price = 1550 },
        { id = "cz_805_bren", name = "CZ 805 Bren", model = "weapon_rifle", caliber = "5.56 NATO / 7.62", type = "modular_rifle", price = 1600 },
    },

    -- SHOTGUNS
    shotguns = {
        -- Classic Pump Action
        { id = "remington_870", name = "Remington 870", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 450 },
        { id = "mossberg_500", name = "Mossberg 500", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 400 },
        { id = "mossberg_590", name = "Mossberg 590", model = "weapon_shotgun", caliber = "12 GA", type = "combat_shotgun", price = 550 },
        { id = "mossberg_590a1", name = "Mossberg 590A1", model = "weapon_shotgun", caliber = "12 GA", type = "combat_shotgun", price = 600 },
        { id = "winchester_1200", name = "Winchester 1200", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 400 },
        { id = "ithaca37", name = "Ithaca 37", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 500 },

        -- Semi-Auto Shotguns
        { id = "benelli_m4", name = "Benelli M4", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 1200 },
        { id = "benelli_m3", name = "Benelli M3", model = "weapon_shotgun", caliber = "12 GA", type = "combination_shotgun", price = 1100 },
        { id = "benelli_nova", name = "Benelli Nova", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 700 },
        { id = "benelli_supernova", name = "Benelli SuperNova", model = "weapon_shotgun", caliber = "12 GA", type = "pump_shotgun", price = 750 },
        { id = "browning_a5", name = "Browning Auto-5", model = "weapon_shotgun", caliber = "12/20 GA", type = "semi_auto_shotgun", price = 850 },
        { id = "browning_bps", name = "Browning BPS", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 600 },

        -- Tactical Shotguns
        { id = "kriss_ks_tac", name = "Kel-Tec KSG", model = "weapon_shotgun", caliber = "12 GA", type = "bullpup_shotgun", price = 900 },
        { id = "kriss_ks7", name = "Kel-Tec KS7", model = "weapon_shotgun", caliber = "12 GA", type = "compact_shotgun", price = 750 },
        { id = "aa12", name = "AA-12", model = "weapon_shotgun", caliber = "12 GA", type = "automatic_shotgun", price = 2500 },
        { id = "dp12", name = "DP-12", model = "weapon_shotgun", caliber = "12 GA", type = "dual_barrel_shotgun", price = 1800 },
        { id = "utas_uts15", name = "UTAS UTS-15", model = "weapon_shotgun", caliber = "12 GA", type = "bullpup_shotgun", price = 1000 },

        -- Combat Shotguns
        { id = "spas12", name = "SPAS-12", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_combat", price = 1100 },
        { id = "spas15", name = "SPAS-15", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_combat", price = 1150 },
        { id = "saiga12", name = "Saiga-12", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 900 },
        { id = "vepr12", name = "Vepr-12", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 950 },

        -- Specialist & Vintage
        { id = "winchester_1897", name = "Winchester 1897", model = "weapon_shotgun", caliber = "12 GA", type = "historical_shotgun", price = 600 },
        { id = "winchester_sxp", name = "Winchester SXP", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 700 },
        { id = "stevens_320", name = "Stevens 320", model = "weapon_shotgun", caliber = "12/20 GA", type = "pump_shotgun", price = 300 },
        { id = "cz_712", name = "CZ 712", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 600 },
        { id = "franchi_spas", name = "Franchi SPAS", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 1050 },
        { id = "hatsan_escort", name = "Hatsan Escort", model = "weapon_shotgun", caliber = "12/20 GA", type = "semi_auto_shotgun", price = 500 },
        { id = "fabarm_stf12", name = "Fabarm STF/12", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 1000 },
        { id = "rock_island_vr80", name = "Rock Island VR80", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 700 },
        { id = "tristar_raptor", name = "Tristar Raptor", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 650 },
        { id = "weatherby_element", name = "Weatherby Element", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 800 },
        { id = "stoeger_m3000", name = "Stoeger M3000", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 500 },
        { id = "stoeger_m3500", name = "Stoeger M3500", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 600 },
        { id = "pardus_pump", name = "Pardus Pump", model = "weapon_shotgun", caliber = "12 GA", type = "pump_shotgun", price = 450 },
        { id = "dickinson_xx3", name = "Dickinson XX3", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 450 },
        { id = "panzer_ar12", name = "Panzer AR12", model = "weapon_shotgun", caliber = "12 GA", type = "ar_platform_shotgun", price = 1200 },
        { id ="lynx_12", name = "Lynx 12", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 900 },
        { id = "sds_shotgun", name = "SDS Imports Shotgun", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 550 },
        { id = "remington_versa_max", name = "Remington Versa Max", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_shotgun", price = 1000 },
        { id = "beretta_1301", name = "Beretta 1301", model = "weapon_shotgun", caliber = "12 GA", type = "semi_auto_tactical", price = 1100 },
    },

    -- SNIPER RIFLES & DMR
    sniper_rifles = {
        -- Modern Bolt-Action
        { id = "barrett_m82", name = "Barrett M82", model = "weapon_sniper", caliber = ".50 BMG", type = "anti_material", price = 4000 },
        { id = "barrett_m107", name = "Barrett M107", model = "weapon_sniper", caliber = ".50 BMG", type = "anti_material", price = 4200 },
        { id = "barrett_mrad", name = "Barrett MRAD", model = "weapon_sniper", caliber = ".338 Lapua / .300", type = "modular_sniper", price = 3800 },
        { id = "remington_700", name = "Remington 700", model = "weapon_sniper", caliber = ".308 / .300WM", type = "bolt_action_sniper", price = 1400 },
        { id = "remington_783", name = "Remington 783", model = "weapon_sniper", caliber = ".308 / .300WM", type = "bolt_action_sniper", price = 1200 },
        { id = "accuracy_int_awpc", name = "Accuracy International AXMC", model = "weapon_sniper", caliber = ".338 Lapua / .300", type = "modular_sniper", price = 4500 },
        { id = "accuracy_int_aw", name = "Accuracy International AW", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 3500 },
        { id = "accuracy_int_axsr", name = "Accuracy International AXSR", model = "weapon_sniper", caliber = ".338 Lapua", type = "sniper_rifle", price = 3800 },
        { id = "sako_trg22", name = "Sako TRG 22", model = "weapon_sniper", caliber = ".308 NATO", type = "bolt_action_sniper", price = 2800 },
        { id = "sako_trg42", name = "Sako TRG 42", model = "weapon_sniper", caliber = ".338 Lapua", type = "bolt_action_sniper", price = 3200 },
        { id = "tikka_t3x", name = "Tikka T3x", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 1600 },
        { id = "steyr_ssg08", name = "Steyr SSG 08", model = "weapon_sniper", caliber = ".308 NATO", type = "bolt_action_sniper", price = 2500 },
        { id = "cheytac_m200", name = "CheyTac M200", model = "weapon_sniper", caliber = ".408 CheyTac", type = "ultra_sniper", price = 4800 },
        { id = "desert_tech_hti", name = "Desert Tech HTI", model = "weapon_sniper", caliber = ".338 Lapua / .375", type = "anti_material", price = 5000 },
        { id = "desert_tech_srs", name = "Desert Tech SRS", model = "weapon_sniper", caliber = ".308 / .338", type = "modular_sniper", price = 3700 },
        { id = "ruger_precision", name = "Ruger Precision Rifle", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 1800 },
        { id = "christensen_mpr", name = "Christensen Arms MPR", model = "weapon_sniper", caliber = ".308 / .338", type = "sniper_rifle", price = 2000 },
        { id = "bergara_b14", name = "Bergara B14", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 1700 },
        { id = "howa_1500", name = "Howa 1500", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 1100 },
        { id = "savage_110", name = "Savage 110", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 1300 },
        { id = "winchester_m70", name = "Winchester Model 70", model = "weapon_sniper", caliber = ".308 / .338", type = "bolt_action_sniper", price = 1500 },

        -- Semi-Auto DMR
        { id = "sr25", name = "SR-25", model = "weapon_rifle", caliber = ".308 NATO", type = "designated_mk", price = 2200 },
        { id = "m110_sass", name = "M110 SASS", model = "weapon_rifle", caliber = ".308 NATO", type = "designated_mk", price = 2400 },
        { id = "hk_psg1", name = "HK PSG1", model = "weapon_sniper", caliber = ".308 NATO", type = "precision_rifle", price = 3500 },
        { id = "hk_msg90", name = "HK MSG90", model = "weapon_sniper", caliber = ".308 NATO", type = "precision_rifle", price = 3200 },
        { id = "fn_ballista", name = "FN Ballista", model = "weapon_sniper", caliber = ".338 Lapua", type = "sniper_rifle", price = 3400 },

        -- Historic/Specialty
        { id = "dragunov_svd", name = "Dragunov SVD", model = "weapon_sniper", caliber = "7.62x54R", type = "battle_rifle", price = 1700 },
        { id = "sv98", name = "SV-98", model = "weapon_sniper", caliber = "7.62x54R", type = "bolt_action_sniper", price = 1500 },
        { id = "vss_vintorez", name = "VSS Vintorez", model = "weapon_sniper", caliber = "9x39", type = "integrally_suppressed", price = 2000 },
        { id = "as_val", name = "AS Val", model = "weapon_sniper", caliber = "9x39", type = "integrally_suppressed", price = 1950 },
    },

    -- LIGHT MACHINE GUNS / SUPPORT WEAPONS
    lmgs = {
        -- NATO Standard
        { id = "m249_saw", name = "M249 SAW", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2500 },
        { id = "fn_minimi", name = "FN Minimi", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2400 },
        { id = "m240b", name = "M240B", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 3000 },
        { id = "m240l", name = "M240L", model = "weapon_lmg", caliber = "7.62 NATO", type = "light_mg", price = 2900 },

        -- Russian/Soviet
        { id = "pkm", name = "PKM", model = "weapon_lmg", caliber = "7.62x54R", type = "general_purpose_mg", price = 2200 },
        { id = "pkp_pecheneg", name = "PKP Pecheneg", model = "weapon_lmg", caliber = "7.62x54R", type = "general_purpose_mg", price = 2400 },
        { id = "rpk", name = "RPK", model = "weapon_lmg", caliber = "7.62x39", type = "squad_lmg", price = 1800 },
        { id = "rpk74", name = "RPK-74", model = "weapon_lmg", caliber = "5.45x39", type = "squad_lmg", price = 1900 },

        -- European
        { id = "mg42", name = "MG42", model = "weapon_lmg", caliber = "7.62x51 NATO / 7.92x57", type = "general_purpose_mg", price = 3200 },
        { id = "mg3", name = "MG3", model = "weapon_lmg", caliber = "7.62x51 NATO", type = "general_purpose_mg", price = 3000 },
        { id = "bren_gun", name = "Bren Gun", model = "weapon_lmg", caliber = ".303 British", type = "squad_lmg", price = 2000 },
        { id = "lewis_gun", name = "Lewis Gun", model = "weapon_lmg", caliber = ".303 British", type = "squad_lmg", price = 1800 },
        { id = "negev_ng5", name = "Negev NG5", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2600 },
        { id = "negev_ng7", name = "Negev NG7", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 2800 },
        { id = "ultimax_100", name = "Ultimax 100", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2300 },

        -- Asian
        { id = "type88_lmg", name = "Type 88 LMG", model = "weapon_lmg", caliber = "5.8x42", type = "squad_lmg", price = 1900 },
        { id = "type95_lmg", name = "Type 95 LMG", model = "weapon_lmg", caliber = "5.8x42", type = "squad_lmg", price = 2000 },
        { id = "type67_mg", name = "Type 67 MG", model = "weapon_lmg", caliber = "7.62x54R", type = "general_purpose_mg", price = 1800 },
        { id = "type81_lmg", name = "Type 81 LMG", model = "weapon_lmg", caliber = "7.62x39", type = "squad_lmg", price = 1700 },
        { id = "qbb95", name = "QBB-95", model = "weapon_lmg", caliber = "5.8x42", type = "squad_lmg", price = 2100 },

        -- American
        { id = "m60", name = "M60", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 2800 },
        { id = "m60e4", name = "M60E4", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 3000 },
        { id = "stoner_63", name = "Stoner 63", model = "weapon_lmg", caliber = "5.56 NATO", type = "modular_lmg", price = 2700 },

        -- Other Nations
        { id = "hk21", name = "HK21", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 3200 },
        { id = "hk_mg4", name = "HK MG4", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2800 },
        { id = "hk_mg5", name = "HK MG5", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 3200 },
        { id = "kord_mg", name = "Kord Machine Gun", model = "weapon_lmg", caliber = "12.7x99", type = "heavy_mg", price = 4500 },
        { id = "rpd", name = "RPD", model = "weapon_lmg", caliber = "7.62x39", type = "squad_lmg", price = 1600 },
        { id = "xm250", name = "XM250", model = "weapon_lmg", caliber = "6.8x51", type = "squad_lmg", price = 3500 },
        { id = "fn_evolys", name = "FN EVOLYS", model = "weapon_lmg", caliber = "5.56 / 7.62", type = "modular_lmg", price = 3000 },
        { id = "lsat_lmg", name = "LSAT LMG", model = "weapon_lmg", caliber = "5.56 NATO", type = "experimental_lmg", price = 2900 },
        { id = "ares_shrike", name = "ARES Shrike", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2700 },
        { id = "iwi_negev_sf", name = "IWI Negev SF", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2650 },
        { id = "cetme_ameli", name = "CETME Ameli", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2400 },
        { id = "mg36", name = "MG36", model = "weapon_lmg", caliber = "5.56 NATO", type = "squad_lmg", price = 2600 },
        { id = "vektor_ss77", name = "Vektor SS-77", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 2800 },
        { id = "denel_ss77", name = "Denel SS-77", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 2750 },
        { id = "daewoo_k3", name = "Daewoo K3", model = "weapon_lmg", caliber = "7.62 NATO", type = "general_purpose_mg", price = 2700 },
        { id = "browning_m1919", name = "Browning M1919", model = "weapon_lmg", caliber = ".30-06 / 7.62 NATO", type = "historical_mg", price = 2200 },
        { id = "dp28", name = "DP-28", model = "weapon_lmg", caliber = "7.62x54R", type = "squad_lmg", price = 1700 },
    },

    -- AMMUNITION BY CALIBER
    ammunition = {
        { id = "ammo_9mm", name = "9MM Ammo Box", caliber = "9x19", price = 35 },
        { id = "ammo_40sw", name = ".40 S&W Ammo Box", caliber = ".40 S&W", price = 40 },
        { id = "ammo_45acp", name = ".45 ACP Ammo Box", caliber = ".45 ACP", price = 45 },
        { id = "ammo_357mag", name = ".357 Magnum Ammo Box", caliber = ".357 Magnum", price = 40 },
        { id = "ammo_38spl", name = ".38 Special Ammo Box", caliber = ".38 Special", price = 35 },
        { id = "ammo_10mm", name = "10MM Ammo Box", caliber = "10x25", price = 45 },
        { id = "ammo_44mag", name = ".44 Magnum Ammo Box", caliber = ".44 Magnum", price = 50 },
        { id = "ammo_22lr", name = ".22 LR Ammo Box", caliber = ".22 LR", price = 20 },
        { id = "ammo_380acp", name = ".380 ACP Ammo Box", caliber = ".380 ACP", price = 30 },
        { id = "ammo_5_7x28", name = "5.7x28 Ammo Box", caliber = "5.7x28", price = 55 },
        { id = "ammo_556nato", name = "5.56 NATO Ammo Box", caliber = "5.56x45", price = 55 },
        { id = "ammo_762nato", name = "7.62 NATO Ammo Box", caliber = "7.62x51", price = 65 },
        { id = "ammo_762x39", name = "7.62x39 Ammo Box", caliber = "7.62x39", price = 50 },
        { id = "ammo_545x39", name = "5.45x39 Ammo Box", caliber = "5.45x39", price = 50 },
        { id = "ammo_300blk", name = ".300 BLK Ammo Box", caliber = ".300 BLK", price = 60 },
        { id = "ammo_338lapua", name = ".338 Lapua Ammo Box", caliber = ".338 Lapua", price = 120 },
        { id = "ammo_308win", name = ".308 Winchester Ammo Box", caliber = ".308 Win", price = 60 },
        { id = "ammo_300wm", name = ".300 Win Mag Ammo Box", caliber = ".300 WM", price = 75 },
        { id = "ammo_50bmg", name = ".50 BMG Ammo Box", caliber = ".50 BMG", price = 200 },
        { id = "ammo_408cheytac", name = ".408 CheyTac Ammo Box", caliber = ".408 CheyTac", price = 250 },
        { id = "ammo_12ga", name = "12 Gauge Shells", caliber = "12 GA", price = 45 },
        { id = "ammo_20ga", name = "20 Gauge Shells", caliber = "20 GA", price = 40 },
        { id = "ammo_410ga", name = ".410 Shells", caliber = ".410", price = 35 },
        { id = "ammo_4_6x30", name = "4.6x30 Ammo Box", caliber = "4.6x30", price = 70 },
        { id = "ammo_9x39", name = "9x39 Ammo Box", caliber = "9x39", price = 65 },
        { id = "ammo_7_62x54r", name = "7.62x54R Ammo Box", caliber = "7.62x54R", price = 55 },
    },

    -- ATTACHMENTS & ACCESSORIES
    accessories = {
        { id = "scope_acog", name = "ACOG 4x32 Scope", type = "optic", price = 450 },
        { id = "scope_eotech", name = "EOTech Holographic Sight", type = "optic", price = 400 },
        { id = "scope_aimpoint", name = "Aimpoint Red Dot", type = "optic", price = 350 },
        { id = "scope_vortex", name = "Vortex Optics Scope", type = "optic", price = 500 },
        { id = "scope_zeiss", name = "Zeiss Tactical Scope", type = "optic", price = 600 },
        { id = "laser_sight", name = "Laser Sight Module", type = "attachment", price = 300 },
        { id = "flashlight_tactical", name = "Tactical Flashlight", type = "attachment", price = 100 },
        { id = "suppressor", name = "Tactical Suppressor", type = "attachment", price = 350 },
        { id = "muzzle_brake", name = "Muzzle Brake", type = "attachment", price = 200 },
        { id = "compensator", name = "Compensator", type = "attachment", price = 250 },
        { id = "magazine_extended", name = "Extended Magazine", type = "magazine", price = 120 },
        { id = "magazine_drum", name = "Drum Magazine", type = "magazine", price = 250 },
        { id = "mag_9mm", name = "9MM Magazine", type = "magazine", price = 40 },
        { id = "mag_45acp", name = ".45 ACP Magazine", type = "magazine", price = 50 },
        { id = "mag_556nato", name = "5.56 NATO Magazine", type = "magazine", price = 60 },
        { id = "holster_iwb", name = "IWB Holster", type = "gear", price = 80 },
        { id = "holster_owb", name = "OWB Holster", type = "gear", price = 60 },
        { id = "tactical_vest", name = "Tactical Vest", type = "gear", price = 500 },
        { id = "body_armor_iii", name = "Body Armor - Level III", type = "armor", price = 800 },
        { id = "helmet_ballistic", name = "Ballistic Helmet", type = "armor", price = 600 },
        { id = "sling_riflesling", name = "Rifle Sling", type = "gear", price = 60 },
        { id = "case_hard", name = "Hard Case", type = "case", price = 150 },
        { id = "cleaning_kit", name = "Cleaning Kit", type = "maintenance", price = 75 },
        { id = "ammo_pouch", name = "Ammo Pouch", type = "gear", price = 45 },
        { id = "night_vision", name = "Night Vision Goggles", type = "optic", price = 1200 },
        { id = "eye_protection", name = "Eye Protection", type = "safety", price = 50 },
        { id = "ear_protection", name = "Ear Protection", type = "safety", price = 60 },
        { id = "shooting_gloves", name = "Shooting Gloves", type = "safety", price = 45 },
        { id = "range_mat", name = "Range Mat", type = "range", price = 35 },
    }
}

return Config
