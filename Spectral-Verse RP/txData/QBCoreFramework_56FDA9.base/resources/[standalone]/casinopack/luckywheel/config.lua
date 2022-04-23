Config	= {}
Config.Locale = 'en'
Config.ESX = 'esx:getSharedObject'

Config.DailySpin = false				-- If true it will let players to spin once per day
Config.ResetSpin = {h = 0, m = 1}	-- What time will reset the daily spins | Works only if Config.DailySpin is true
Config.SpinMoney = 2000				-- How much will each spin cost | Works only if Config.DailySpin is false (player must have the money in inventory)
Config.SpawnWheel = true			-- If your map does NOT have the wheel, set it to true. if your map has already a wheel set it to false
Config.WheelPos = {x = 978.00, y = 50.35, z = 73.93, h = 327.99}	-- Where the wheel prop will spawn OR where wheel prop is
Config.VehiclePos = {x = 963.42, y = 47.85, z = 74.55, h = 0}
Config.VehicleRot = true			-- If true then the vehicle will rotate slowly
Config.VehicleWinPos = {x = 933.29, y = -3.33, z = 78.34, h = 149.51}	-- Where the vehicle will spawn if a player win it

Config.Cars = {
	[1]  = 'dominator3',
--	[2]  = 'dominator',
--	[3]  = 'dominator2',
--	[4]  = 'dominator3',
--	[5]  = 'baller',
--	[6]  = 'baller2',
--	[7]  = 'sultanrs',
}


-- First it will pick a random 
-- type: weapon, money, item, car (for money it will give only in bank)
-- name: the DB name, 
-- count: 

-- probability: the script will generate a number from 1 to 1000
-- if the random number is between a and b player will win
-- random number must be bigger than a and smaller or equal to b
-- if rnd > a and rnd <= b 

-- available sounds: 'car', 'cash', 'chips', 'clothes', 'mystery', 'win'
Config.Prices = {
	[1]  = {type = 'car', 		name = 'car', 			count = 1, 		sound = 'car', 		probability = {a =   1, b =   2}},	--  0.1 %   0.1 -- VEHICLE
	[2]  = {type = 'money', 	name = 'money', 		count = 15000, 	sound = 'cash', 	probability = {a =   2, b =   18}},	--  0.4 %   0.5 -- 15.000 RP
	[3]  = {type = 'item', 		name = 'calzone', 		count = 1, 		sound = 'clothes', 	probability = {a =   18, b =  35}},	--  0.5 %   1.0 -- CLOTHING
	[4]  = {type = 'item', 		name = 'zetony', 		count = 25000, 	sound = 'chips', 	probability = {a =  35, b =  39}},	--  1.0 %   2.0 -- 25.000 chips
	[5]  = {type = 'money', 	name = 'money', 		count = 40000, 	sound = 'cash', 	probability = {a =  39, b =  43}},	--  2.0 %   4.0 -- 40.000 $
	[6]  = {type = 'money', 	name = 'money', 		count = 10000, 	sound = 'cash', 	probability = {a =  43, b =  60}},	--  2.0 %   6.0 -- 10.000 RP
	[7]  = {type = 'item', 		name = 'barbecue', 		count = 1, 		sound = 'clothes', 	probability = {a =  60, b =  70}},	--  4.0 %   8.0 -- CLOTHING
	[8]  = {type = 'item', 		name = 'ied',  			count = 1, 		sound = 'mystery', 	probability = {a =  70, b = 138}},	--  4.0 %  12.0 -- MYSTERY
	[9]  = {type = 'item', 		name = 'zetony', 		count = 20000, 	sound = 'chips', 	probability = {a = 138, b = 145}},	--  5.0 %  17.0 -- 20.000 chips
	[10] = {type = 'money', 	name = 'money', 		count = 7500, 	sound = 'cash', 	probability = {a = 145, b = 250}},	--  5.0 %  22.0 -- 7.500 RP
	[11] = {type = 'item',		name = 'cupcake', 		count = 1, 		sound = 'clothes', 	probability = {a = 250, b = 280}},	--  6.0 %  28.0 -- CLOTHING
	[12] = {type = 'item', 		name = 'zetony', 		count = 15000, 	sound = 'chips', 	probability = {a = 280, b = 320}},	--  6.0 %  34.0 -- 15.000 chips
	[13] = {type = 'money', 	name = 'money', 		count = 30000, 	sound = 'cash', 	probability = {a = 320, b = 360}},	--  7.0 %  41.0 -- 30.000 $
	[14] = {type = 'money', 	name = 'money', 		count = 5000, 	sound = 'cash', 	probability = {a = 360, b = 540}},	--  7.0 %  48.0 -- 5.000 RP
	[15] = {type = 'item', 		name = 'WEAPON_SWITCHBLADE', count = 1, 	sound = 'mystery', 	probability = {a = 540, b = 670}},	--  8.0 %  56.0 -- DISCOUNT
	[16] = {type = 'item',		name = 'zetony', 		count = 10000, 	sound = 'chips', 	probability = {a = 670, b = 680}},	--  8.0 %  64.0 -- 10.000 chips
	[17] = {type = 'money',		name = 'money', 		count = 20000, 	sound = 'cash', 	probability = {a = 680, b = 730}},	--  8.0 %  72.0 -- 20.000 $
	[18] = {type = 'money', 	name = 'money', 		count = 2500, 	sound = 'cash', 	probability = {a = 800, b = 925}},	--  9.0 %  81.0 -- 2.500 RP
	[19] = {type = 'item', 		name = 'hamburger', 	count = 1, 		sound = 'clothes', 	probability = {a = 925, b = 1000}},	--  9.0 %  90.0 -- CLOTHING
	[20] = {type = 'money', 	name = 'money', 		count = 50000, 	sound = 'cash', 	probability = {a = 0, b = 0}},	-- 1.0 % -- 50.000 $
}