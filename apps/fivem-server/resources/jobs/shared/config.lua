-- Jobs Configuration - Clock In/Out System
Config = {
    -- Job definitions with hourly pay
    Jobs = {
        -- ============ TRANSPORT JOBS ============
        ['trucker'] = {
            label = 'Truck Driver',
            payPerMinute = 3,  -- $180/hr
            objectives = "Drive to warehouse, pick up cargo, deliver to destination",
            workLocation = vector3(500.0, -1000.0, 29.4)
        },
        ['delivery'] = {
            label = 'Delivery Driver',
            payPerMinute = 2,  -- $120/hr
            objectives = "Pick up packages and deliver to addresses around the city",
            workLocation = vector3(400.0, -1050.0, 29.4)
        },
        ['ubereats'] = {
            label = 'Uber Eats Driver',
            payPerMinute = 2.5,  -- $150/hr
            objectives = "Pick up food orders from restaurants and deliver to customers",
            workLocation = vector3(420.0, -1080.0, 29.4)
        },
        ['doordash'] = {
            label = 'DoorDash Driver',
            payPerMinute = 2.5,  -- $150/hr
            objectives = "Pick up orders and deliver to customer locations",
            workLocation = vector3(440.0, -1100.0, 29.4)
        },
        ['taxi'] = {
            label = 'Taxi Driver',
            payPerMinute = 2,  -- $120/hr
            objectives = "Wait for passengers and drive them to their destinations",
            workLocation = vector3(300.0, -900.0, 29.4)
        },
        
        -- ============ CONSTRUCTION & TRADE ============
        ['construction'] = {
            label = 'Construction Worker',
            payPerMinute = 4,  -- $240/hr
            objectives = "Move materials, operate machinery, clear sites, inspect progress",
            workLocation = vector3(600.0, -950.0, 29.4)
        },
        
        -- ============ AUTOMOTIVE ============
        ['mechanic'] = {
            label = 'Mechanic',
            payPerMinute = 5,  -- $300/hr
            objectives = "Inspect vehicles, retrieve parts, perform repairs, test vehicles",
            workLocation = vector3(450.0, -1100.0, 29.4)
        },
        ['carsalesman'] = {
            label = 'Car Dealership Salesman',
            payPerMinute = 6,  -- $360/hr
            objectives = "Greet customers, show vehicles, discuss financing, complete sales",
            workLocation = vector3(550.0, -850.0, 29.4)
        },
        ['cardealer'] = {
            label = 'Car Dealer Employee',
            payPerMinute = 5,  -- $300/hr
            objectives = "Prep vehicles, detail cars, update inventory, manage paperwork",
            workLocation = vector3(570.0, -880.0, 29.4)
        },
        
        -- ============ LEGAL SERVICES ============
        ['lawyer'] = {
            label = 'Lawyer',
            payPerMinute = 10,  -- $600/hr
            objectives = "Review case files, meet clients, prepare documents, file with court",
            workLocation = vector3(260.0, -365.0, 44.9)
        },
        
        -- ============ FINANCIAL SERVICES ============
        ['banker'] = {
            label = 'Bank Employee',
            payPerMinute = 6,  -- $360/hr
            objectives = "Process deposits, handle inquiries, verify documents, reconcile transactions",
            workLocation = vector3(-110.0, -825.0, 31.4)
        },
        ['creditcard'] = {
            label = 'Credit Card Processor',
            payPerMinute = 8,  -- $480/hr
            objectives = "Review applications, verify info, activate cards, handle disputes",
            workLocation = vector3(-100.0, -840.0, 31.4)
        },
        ['businessadmin'] = {
            label = 'Business Administrator',
            payPerMinute = 7,  -- $420/hr
            objectives = "Manage spreadsheets, organize files, process payroll, schedule meetings",
            workLocation = vector3(180.0, -900.0, 29.4)
        },
        
        -- ============ GUN CLUBS ============
        ['gunrange'] = {
            label = 'Gun Range Employee',
            payPerMinute = 4,  -- $240/hr
            objectives = "Setup targets, manage inventory, assist customers, maintain equipment",
            workLocation = vector3(-660.0, -934.0, 21.8)
        },

        -- ============ ILLEGAL WORK ============
        ['hitman'] = {
            label = 'Hitman/Assassin',
            payPerMinute = 0,  -- No hourly pay, contract-based only
            objectives = "Receive contracts via iPhone, eliminate targets, complete jobs for payment",
            workLocation = vector3(-450.0, -350.0, 44.0),
            requiresUnlock = true  -- Requires 10+ kills to unlock
        }
    },
    
    -- Clock in/out radius (how close you need to be to work location)
    ClockInRadius = 30.0,
    
    -- ============ MULTI-CITY JOB LOCATIONS ============
    -- Miami (Higher pay - more expensive area)
    MiamiJobs = {
        ['trucker'] = {coords = vector3(380.1, -983.2, 29.4), payMult = 1.4},
        ['delivery'] = {coords = vector3(350.5, -1010.1, 29.3), payMult = 1.4},
        ['ubereats'] = {coords = vector3(420.2, -950.5, 29.2), payMult = 1.4},
        ['doordash'] = {coords = vector3(480.1, -920.2, 29.1), payMult = 1.4},
        ['taxi'] = {coords = vector3(150.5, -1040.1, 29.3), payMult = 1.4},
        ['construction'] = {coords = vector3(520.3, -880.5, 25.1), payMult = 1.3},
        ['mechanic'] = {coords = vector3(400.0, -900.0, 29.4), payMult = 1.3},
        ['carsalesman'] = {coords = vector3(450.0, -850.0, 29.4), payMult = 1.35},
        ['cardealer'] = {coords = vector3(470.0, -870.0, 29.4), payMult = 1.3},
        ['lawyer'] = {coords = vector3(260.0, -365.0, 44.9), payMult = 1.4},
        ['banker'] = {coords = vector3(-110.0, -825.0, 31.4), payMult = 1.35},
        ['creditcard'] = {coords = vector3(-100.0, -840.0, 31.4), payMult = 1.35},
        ['businessadmin'] = {coords = vector3(180.0, -900.0, 29.4), payMult = 1.35},
        ['gunrange'] = {coords = vector3(-660.0, -934.0, 21.8), payMult = 1.3}
    },
    
    -- Jacksonville
    JacksonvilleJobs = {
        ['trucker'] = {coords = vector3(380.2, -1400.1, 32.3), payMult = 1.0},
        ['delivery'] = {coords = vector3(425.1, -1450.2, 32.2), payMult = 1.0},
        ['ubereats'] = {coords = vector3(450.5, -1380.1, 32.4), payMult = 1.0},
        ['doordash'] = {coords = vector3(-450.2, -1300.5, 44.0), payMult = 1.0},
        ['taxi'] = {coords = vector3(-400.1, -1250.2, 44.2), payMult = 1.0},
        ['construction'] = {coords = vector3(-300.5, -1200.1, 44.1), payMult = 1.0},
        ['mechanic'] = {coords = vector3(-500.2, -1350.5, 44.3), payMult = 1.0},
        ['carsalesman'] = {coords = vector3(300.0, -1350.0, 32.0), payMult = 1.0},
        ['cardealer'] = {coords = vector3(320.0, -1370.0, 32.0), payMult = 1.0},
        ['lawyer'] = {coords = vector3(250.0, -1200.0, 32.0), payMult = 1.0},
        ['banker'] = {coords = vector3(100.0, -1100.0, 32.0), payMult = 1.0},
        ['creditcard'] = {coords = vector3(120.0, -1120.0, 32.0), payMult = 1.0},
        ['businessadmin'] = {coords = vector3(200.0, -1250.0, 32.0), payMult = 1.0},
        ['gunrange'] = {coords = vector3(50.0, -1050.0, 32.0), payMult = 1.0}
    },
    
    -- The Beaches (Tourism area)
    BeachesJobs = {
        ['trucker'] = {coords = vector3(-1000.0, -1600.0, 5.0), payMult = 1.2},
        ['delivery'] = {coords = vector3(-980.0, -1580.0, 5.0), payMult = 1.2},
        ['ubereats'] = {coords = vector3(-950.0, -1550.0, 5.0), payMult = 1.2},
        ['doordash'] = {coords = vector3(-920.0, -1520.0, 5.0), payMult = 1.2},
        ['taxi'] = {coords = vector3(-1050.0, -1650.0, 5.0), payMult = 1.2},
        ['construction'] = {coords = vector3(-900.0, -1500.0, 5.0), payMult = 1.1},
        ['mechanic'] = {coords = vector3(-850.0, -1450.0, 5.0), payMult = 1.1},
        ['carsalesman'] = {coords = vector3(-800.0, -1400.0, 5.0), payMult = 1.15},
        ['cardealer'] = {coords = vector3(-780.0, -1380.0, 5.0), payMult = 1.1},
        ['lawyer'] = {coords = vector3(-1100.0, -1700.0, 5.0), payMult = 1.2},
        ['banker'] = {coords = vector3(-1150.0, -1750.0, 5.0), payMult = 1.15},
        ['creditcard'] = {coords = vector3(-1130.0, -1730.0, 5.0), payMult = 1.15},
        ['businessadmin'] = {coords = vector3(-1050.0, -1650.0, 5.0), payMult = 1.15},
        ['gunrange'] = {coords = vector3(-750.0, -1350.0, 5.0), payMult = 1.1}
    },
    
    -- Orlando
    OrlandoJobs = {
        ['trucker'] = {coords = vector3(1200.1, -2850.5, 5.5), payMult = 1.05},
        ['delivery'] = {coords = vector3(1150.2, -2900.1, 5.1), payMult = 1.05},
        ['ubereats'] = {coords = vector3(1250.5, -2800.2, 10.1), payMult = 1.05},
        ['doordash'] = {coords = vector3(-450.5, -300.2, 44.0), payMult = 1.05},
        ['taxi'] = {coords = vector3(-400.1, -350.5, 43.8), payMult = 1.05},
        ['construction'] = {coords = vector3(-500.5, -280.2, 43.9), payMult = 1.0},
        ['mechanic'] = {coords = vector3(-520.3, -320.1, 44.1), payMult = 1.0},
        ['carsalesman'] = {coords = vector3(330.1, -1360.5, 32.5), payMult = 1.0},
        ['cardealer'] = {coords = vector3(350.0, -1380.0, 32.5), payMult = 1.0},
        ['lawyer'] = {coords = vector3(425.1, -1450.2, 32.2), payMult = 1.05},
        ['banker'] = {coords = vector3(450.5, -1380.1, 32.4), payMult = 1.0},
        ['creditcard'] = {coords = vector3(-450.2, -1300.5, 44.0), payMult = 1.0},
        ['businessadmin'] = {coords = vector3(-400.1, -1250.2, 44.2), payMult = 1.0},
        ['gunrange'] = {coords = vector3(-300.5, -1200.1, 44.1), payMult = 1.0}
    }
}
    
    -- Gun range inventory (NPC sales available even without employee)
    GunRangeInventory = {
        {model = "WEAPON_PISTOL", name = "9MM Pistol", price = 500},
        {model = "WEAPON_COMBATPISTOL", name = "Combat Pistol", price = 600},
        {model = "WEAPON_MACHINEPISTOL", name = "Machine Pistol", price = 800},
        {model = "WEAPON_MICROSMG", name = "Micro SMG", price = 1500},
        {model = "WEAPON_ASSAULTRIFLE", name = "Assault Rifle", price = 3000},
        {model = "WEAPON_CARBINERIFLE", name = "Carbine Rifle", price = 3500},
        {model = "WEAPON_PUMPSHOTGUN", name = "Pump Shotgun", price = 2000},
        {model = "WEAPON_SNIPER", name = "Sniper Rifle", price = 5000}
    }
}

return Config
