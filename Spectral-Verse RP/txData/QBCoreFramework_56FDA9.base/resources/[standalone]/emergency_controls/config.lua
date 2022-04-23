Config = {}

-- Optional, if you want to show the siren indicators at the bottom right.
Config.EnableHUD = true
Config.EnableUIMenu = true
Config.EnableController = true

-- Put your firetruck models here.
Config.Firetrucks = {
    "FIRETRUK",
}

-- Put your ambulance models here.
Config.Ambulances = {
	"AMBULANCE",
	"LGUARD"
}

Config.AvailableSirens = {
    [1] = "SIRENS_AIRHORN",
    [2] = "RESIDENT_VEHICLES_SIREN_WAIL_01",
    [3] = "RESIDENT_VEHICLES_SIREN_QUICK_01",
    [4] = "RESIDENT_VEHICLES_SIREN_WAIL_02",
    [5] = "RESIDENT_VEHICLES_SIREN_QUICK_02",
    [6] = "RESIDENT_VEHICLES_SIREN_WAIL_03",
    [7] = "RESIDENT_VEHICLES_SIREN_QUICK_03",
    [8] = "VEHICLES_HORNS_SIREN_1",
    [9] = "VEHICLES_HORNS_SIREN_2",
    [10] = "VEHICLES_HORNS_AMBULANCE_WARNING",
    [11] = "VEHICLES_HORNS_FIRETRUCK_WARNING",
    [12] = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01",
    [13] = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01",
    -- EXAMPLE IF USING WM_SERVERSIRENS
    -- [14] = "SIREN_ALPHA" 
}

-- EXAMPLE BASED OFF OF WM-SERVERSIRENS RESOURCE
-- IF YOU ARE USING CUSTOM SIRENS PLEASE INCLUDE THE DLC THEY WILL BE FOUND IN HERE
-- DOCUMENTATION ON CUSTOM SIRENS CAN BE FOUND HERE, THANKS TO THESE GUYS FOR FIGURING THIS STUFF OUT
-- https://github.com/Walsheyy/WMServerSirens
Config.AvailableSirensAudioRef = {
    -- ["SIREN_ALPHA"] = "DLC_WMSIRENS_SOUNDSET",
}

-- Put your police sirens here. These will function as the default
-- sirens if your model isn't in another category.
Config.DefaultPoliceSirens = {
    [1] = "VEHICLES_HORNS_SIREN_1",
    [2] = "VEHICLES_HORNS_SIREN_2",
    [3] = "VEHICLES_HORNS_POLICE_WARNING",
    [4] = "SIRENS_AIRHORN" -- HORN
}

-- Put your firetruck sirens here. Requires model to be in the
-- Config.Firetrucks table above.
Config.DefaultFiretruckSirens = {
    [1] = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01",
    [2] = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01",
    [3] = "VEHICLES_HORNS_FIRETRUCK_WARNING",
    [4] = "SIRENS_AIRHORN" -- HORN
}

-- Put your ambulance sirens here. Requires model to be in the
-- Config.Ambulances table above.
Config.DefaultAmbulanceSirens = {
    [1] = "RESIDENT_VEHICLES_SIREN_WAIL_03",
    [2] = "RESIDENT_VEHICLES_SIREN_QUICK_03",
    [3] = "VEHICLES_HORNS_AMBULANCE_WARNING",
    [4] = "SIRENS_AIRHORN" -- HORN
}

Config.Keyboard = {
    SirenOne = 'LEFT',
    SirenTwo = 'UP',
    SirenThree = 'RIGHT',
    UIMenu = 'DOWN',
    Mode = 'LSHIFT',
    Horn = 'E',
    Lights = 'Q'
}

Config.ControllerButtons = {
    SirenOne = 115,     -- Default D-Pad Left: 115
    SirenTwo = 173,     -- Default D-Pad Down: 173
    SirenThree = 172,   -- Default D-Pad Up: 172
    Mode = 73,          -- Default A/X: 73
    UIMenu = 99,        -- Default X/Square: 99
    Horn = 80,           -- Default ?
    Lights = 28         -- Default L3
}