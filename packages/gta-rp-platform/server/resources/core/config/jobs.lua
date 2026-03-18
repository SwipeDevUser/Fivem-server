-- Jobs Configuration
-- Defines job structure, paychecks, expenses, and grades

Jobs = {
    police = {
        label = 'Police Officer',
        description = 'Enforce the law and protect citizens',
        type = 'government',
        grades = {
            [0] = {
                name = 'Cadet',
                salary = 500,
                permissions = {'police.basic'},
            },
            [1] = {
                name = 'Officer',
                salary = 750,
                permissions = {'police.basic', 'police.search'},
            },
            [2] = {
                name = 'Sergeant',
                salary = 1000,
                permissions = {'police.basic', 'police.search', 'police.manage'},
            },
            [3] = {
                name = 'Lieutenant',
                salary = 1250,
                permissions = {'police.basic', 'police.search', 'police.manage', 'police.admin'},
            },
            [4] = {
                name = 'Captain',
                salary = 1500,
                permissions = {'police.all'},
            },
        },
    },
    
    ems = {
        label = 'EMS',
        description = 'Provide emergency medical services',
        type = 'government',
        grades = {
            [0] = {
                name = 'Paramedic',
                salary = 400,
                permissions = {'ems.basic'},
            },
            [1] = {
                name = 'Advanced Paramedic',
                salary = 600,
                permissions = {'ems.basic', 'ems.advanced'},
            },
            [2] = {
                name = 'Supervisor',
                salary = 800,
                permissions = {'ems.basic', 'ems.advanced', 'ems.manage'},
            },
        },
    },
    
    firefighter = {
        label = 'Firefighter',
        description = 'Fight fires and perform rescues',
        type = 'government',
        grades = {
            [0] = {
                name = 'Firefighter',
                salary = 450,
                permissions = {'fire.basic'},
            },
            [1] = {
                name = 'Lieutenant',
                salary = 700,
                permissions = {'fire.basic', 'fire.manage'},
            },
        },
    },
    
    taxi = {
        label = 'Taxi Driver',
        description = 'Transport passengers for income',
        type = 'business',
        grades = {
            [0] = {
                name = 'Driver',
                salary = 0,  -- No salary, income from jobs
                permissions = {'taxi.basic'},
            },
            [1] = {
                name = 'Manager',
                salary = 200,
                permissions = {'taxi.basic', 'taxi.manage'},
            },
        },
    },
    
    mechanic = {
        label = 'Mechanic',
        description = 'Repair and modify vehicles',
        type = 'business',
        grades = {
            [0] = {
                name = 'Apprentice',
                salary = 300,
                permissions = {'mechanic.basic'},
            },
            [1] = {
                name = 'Certified Mechanic',
                salary = 600,
                permissions = {'mechanic.basic', 'mechanic.advanced'},
            },
            [2] = {
                name = 'Master Mechanic',
                salary = 900,
                permissions = {'mechanic.all'},
            },
        },
    },
    
    unemployed = {
        label = 'Unemployed',
        description = 'Jobless',
        type = 'none',
        grades = {
            [0] = {
                name = 'Citizen',
                salary = 0,
                permissions = {},
            },
        },
    },
}

-- Global expenses for all players
GlobalExpenses = {
    {
        name = 'Rent',
        amount = 500,
        description = 'Daily apartment rent',
        interval = 'daily',
    },
    {
        name = 'Food',
        amount = 100,
        description = 'Daily food and utilities',
        interval = 'daily',
    },
    {
        name = 'Insurance',
        amount = 200,
        description = 'Vehicle and health insurance',
        interval = 'weekly',
    },
    {
        name = 'Phone Bill',
        amount = 50,
        description = 'Monthly phone service',
        interval = 'monthly',
    },
}

-- Purchase types available in the economy
PurchaseTypes = {
    vehicle = {
        label = 'Vehicle',
        icon = 'car',
    },
    property = {
        label = 'Property',
        icon = 'home',
    },
    business = {
        label = 'Business',
        icon = 'briefcase',
    },
    item = {
        label = 'Item',
        icon = 'shopping-bag',
    },
    service = {
        label = 'Service',
        icon = 'wrench',
    },
}

-- Helper function to get job
function GetJob(jobName)
    return Jobs[string.lower(jobName)]
end

-- Helper function to get grade info
function GetGradeInfo(jobName, grade)
    local job = GetJob(jobName)
    if not job then
        return nil
    end
    return job.grades[grade]
end

-- Helper function to get salary
function GetJobSalary(jobName, grade)
    local gradeInfo = GetGradeInfo(jobName, grade)
    return gradeInfo and gradeInfo.salary or 0
end

-- Helper function to get job label
function GetJobLabel(jobName)
    local job = GetJob(jobName)
    return job and job.label or 'Unknown'
end

return Jobs
