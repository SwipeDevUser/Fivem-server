-- Inventory System Configuration

Config = {
    -- ========================================
    -- INVENTORY SETTINGS
    -- ========================================
    Inventory = {
        maxWeight = 120000,  -- in grams (120kg)
        maxSlots = 50,
        dropOnDeath = true,
        dropOnDisconnect = false,
        useWeight = true,
        enableDrop = true,
        enableSort = true,
        enableSearch = true
    },

    -- ========================================
    -- ITEM CATEGORIES
    -- ========================================
    ItemCategories = {
        'weapons',
        'ammo',
        'food',
        'medical',
        'tools',
        'documents',
        'materials',
        'misc'
    },

    -- ========================================
    -- ITEMS DATABASE
    -- ========================================
    Items = {
        -- WEAPONS
        ['pistol'] = {
            name = 'Pistol',
            label = 'Pistol',
            weight = 1100,
            category = 'weapons',
            usable = false,
            shouldClose = true,
            unique = true,
            description = 'Basic pistol'
        },
        ['rifle'] = {
            name = 'rifle',
            label = 'Assault Rifle',
            weight = 2400,
            category = 'weapons',
            usable = false,
            shouldClose = true,
            unique = true,
            description = 'Military-grade assault rifle'
        },
        ['shotgun'] = {
            name = 'shotgun',
            label = 'Combat Shotgun',
            weight = 2300,
            category = 'weapons',
            usable = false,
            shouldClose = true,
            unique = true,
            description = 'Shotgun for close combat'
        },

        -- AMMO
        ['ammo_pistol'] = {
            name = 'ammo_pistol',
            label = 'Pistol Ammo',
            weight = 25,
            category = 'ammo',
            usable = false,
            shouldClose = true,
            description = 'Ammo for pistols (pack of 30)'
        },
        ['ammo_rifle'] = {
            name = 'ammo_rifle',
            label = 'Rifle Ammo',
            weight = 60,
            category = 'ammo',
            usable = false,
            shouldClose = true,
            description = 'Ammo for rifles (pack of 30)'
        },

        -- FOOD
        ['burger'] = {
            name = 'burger',
            label = 'Hamburger',
            weight = 200,
            category = 'food',
            usable = true,
            shouldClose = true,
            description = 'A tasty hamburger',
            effect = {
                health = 10,
                stamina = 5
            }
        },
        ['pizza'] = {
            name = 'pizza',
            label = 'Pizza',
            weight = 500,
            category = 'food',
            usable = true,
            shouldClose = true,
            description = 'Hot pizza',
            effect = {
                health = 20,
                stamina = 15
            }
        },
        ['water'] = {
            name = 'water',
            label = 'Water Bottle',
            weight = 300,
            category = 'food',
            usable = true,
            shouldClose = true,
            description = 'Bottled water',
            effect = {
                stamina = 10
            }
        },
        ['coffee'] = {
            name = 'coffee',
            label = 'Coffee',
            weight = 150,
            category = 'food',
            usable = true,
            shouldClose = true,
            description = 'Hot coffee',
            effect = {
                stamina = 15,
                energy = 10
            }
        },
        ['donuts'] = {
            name = 'donuts',
            label = 'Box of Donuts',
            weight = 400,
            category = 'food',
            usable = true,
            shouldClose = true,
            description = 'Police special - 6 donuts',
            effect = {
                health = 15,
                stamina = 20
            }
        },

        -- MEDICAL
        ['bandages'] = {
            name = 'bandages',
            label = 'Bandages',
            weight = 75,
            category = 'medical',
            usable = true,
            shouldClose = true,
            description = 'First aid bandages',
            effect = {
                health = 25
            }
        },
        ['painkillers'] = {
            name = 'painkillers',
            label = 'Painkillers',
            weight = 50,
            category = 'medical',
            usable = true,
            shouldClose = true,
            description = 'Reduces pain (stamina)',
            effect = {
                stamina = 30
            }
        },
        ['medkit'] = {
            name = 'medkit',
            label = 'Medical Kit',
            weight = 300,
            category = 'medical',
            usable = true,
            shouldClose = true,
            description = 'Full medical aid kit',
            effect = {
                health = 100
            }
        },

        -- TOOLS
        ['lockpick'] = {
            name = 'lockpick',
            label = 'Lockpick',
            weight = 100,
            category = 'tools',
            usable = true,
            shouldClose = false,
            description = 'Tool for picking locks',
            skill = 'lockpicking'
        },
        ['flashlight'] = {
            name = 'flashlight',
            label = 'Flashlight',
            weight = 250,
            category = 'tools',
            usable = true,
            shouldClose = false,
            description = 'Handheld flashlight'
        },
        ['phone'] = {
            name = 'phone',
            label = 'Mobile Phone',
            weight = 200,
            category = 'tools',
            usable = true,
            shouldClose = false,
            unique = false,
            description = 'Communication device'
        },

        -- DOCUMENTS
        ['id_card'] = {
            name = 'id_card',
            label = 'ID Card',
            weight = 5,
            category = 'documents',
            usable = true,
            shouldClose = true,
            unique = true,
            description = 'Government issued ID'
        },
        ['drivers_license'] = {
            name = 'drivers_license',
            label = "Driver's License",
            weight = 5,
            category = 'documents',
            usable = true,
            shouldClose = true,
            unique = true,
            description = 'Driving permit'
        },
        ['job_application'] = {
            name = 'job_application',
            label = 'Job Application',
            weight = 50,
            category = 'documents',
            usable = true,
            shouldClose = true,
            description = 'Employment application form'
        },

        -- MATERIALS
        ['copper'] = {
            name = 'copper',
            label = 'Copper Bar',
            weight = 500,
            category = 'materials',
            usable = false,
            shouldClose = true,
            description = 'Raw copper material'
        },
        ['iron'] = {
            name = 'iron',
            label = 'Iron Ore',
            weight = 600,
            category = 'materials',
            usable = false,
            shouldClose = true,
            description = 'Raw iron ore'
        },
        ['plastic'] = {
            name = 'plastic',
            label = 'Plastic',
            weight = 300,
            category = 'materials',
            usable = false,
            shouldClose = true,
            description = 'Plastic material'
        },
        ['wood'] = {
            name = 'wood',
            label = 'Wood Plank',
            weight = 400,
            category = 'materials',
            usable = false,
            shouldClose = true,
            description = 'Cut wood plank'
        },

        -- MISCELLANEOUS
        ['cash'] = {
            name = 'cash',
            label = 'Cash',
            weight = 1,
            category = 'misc',
            usable = false,
            shouldClose = true,
            description = 'Paper money'
        },
        ['usb'] = {
            name = 'usb',
            label = 'USB Drive',
            weight = 50,
            category = 'misc',
            usable = true,
            shouldClose = true,
            description = 'Data storage device'
        },
        ['key_card'] = {
            name = 'key_card',
            label = 'Security Key Card',
            weight = 10,
            category = 'misc',
            usable = true,
            shouldClose = true,
            description = 'Access card for buildings'
        }
    },

    -- ========================================
    -- INVENTORY UI SETTINGS
    -- ========================================
    UI = {
        position = 'right',  -- 'left' or 'right'
        scale = 1.0,
        showWeight = true,
        showCategory = true,
        showDescription = true,
        backgroundColor = 'rgba(0, 0, 0, 0.8)',
        primaryColor = '#00D7FF',
        accentColor = '#FF00FF'
    },

    -- ========================================
    -- NOTIFICATIONS
    -- ========================================
    Notifications = {
        inventoryFull = 'Inventory is full',
        itemAdded = 'Item added to inventory',
        itemRemoved = 'Item removed from inventory',
        cannotDrop = 'Cannot drop this item',
        itemUsed = 'Item used',
        invalidItem = 'Invalid item'
    }
}

return Config
