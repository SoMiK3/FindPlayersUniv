-- Author - https://vk.com/klamet1

require "lib.sampfuncs"
require "lib.moonloader"

script_name("FindPlayers")
script_author("СоМиК")
script_version("1.3")
script_properties("work-in-pause")

local main_color = 0x5A90CE
local color_text = "{FFFF00}"
local tag = "[FindPlayers]: "

local dlstatus = require('moonloader').download_status

local script_vers = 4
local script_vers_text = "1.3"
local script_path = thisScript().path
local script_url = "https://raw.githubusercontent.com/SoMiK3/FindPlayersUniv/main/FindPlayers.lua"
local update_path = getWorkingDirectory() .. "/fplayersupdate.ini"
local update_url = "https://raw.githubusercontent.com/SoMiK3/FindPlayersUniv/main/fplayersupdate.ini"
local config_path = getWorkingDirectory() .. "/config/FindPlayer.ini"

local MoonFolder = getWorkingDirectory()

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		sampShowDialog(1338, "{FFFF00}Краш скрипта {FFFFFF}FindPlayers", "{FFFF00}Скрипт был {FFFFFF}крашнут {FFFF00}по какой-то причине...\nВозможно, скрипт был {FFFFFF}перезагружен{FFFF00}, это могло посодействовать появлению данного окна\n\nЕсли же скрипт не был перезагружен, пожалуйста, обратитесь сюда: {FFFFFF}https://vk.com/klamet1/\nНе забудьте указать{FFFF00}, каким было ваше последнее действие перед {FFFFFF}крашем{FFFF00} скрипта.\n\n\n{ffff00}И последнее... Никогда не отчаивайтесь и запомните, {FFFFFF}Аллах {FFFF00}вам в помощь.\n{ff0033}ДОЛБИТЕ ВСЕМИ СИЛАМИ ПО КЛАВИШАМ, ПОСТОЯННО ПЕРЕЗАГРУЖАЙТЕ СКРИПТ КОМБИНАЦИЕЙ CTRL + R\nПОСТОЯННО ПЕРЕЗАПУСКАЙТЕ ГТА ЕСЛИ КОМБИНАЦИЯ НЕ СРАБОТАЛА И НАДЕЙТЕСЬ НА УДАЧУ ДО ПОСЛЕДНЕГО, ПОКА СКРИПТ НЕ ЗАРАБОТАЕТ\n{FFFF00}Ну или просто дождитесь {FFFFFF}фикса {FFFF00}от автора :)\nВсем {00FF00}б{FFFF00}обра и позитива, {FFFFFF}чао", "{ff0000}Автор гей", nil, DIALOG_STYLE_MSGBOX)
	end
end

local sampev = require "lib.samp.events"
local keys = require "vkeys"
local inicfg = require "inicfg"
local rkeys = require "rkeys"
local wm = require 'lib.windows.message'
local sw, sh = getScreenResolution()
local initable = {
cfg = {
	posx = 0,
	posy = sh / 2,
	bindKey = "[104]",
	command = "findplayers",
	findlvlOT = 1,
	findlvlDO = 1,
	check = false,
	messages = 1,
	message = "Привет, я использую скрипт \"FindPlayers\" сделанный СоМиК'ом. Это сообщение будет отправлено автоматически!",
	message2 = "Это сообщение было отправлено вторым по счёту.",
	message3 = "А это третьим.",
	ignore = false,
	cooldown = 1000,
	color1 = 0.00,
	color2 = 0.49,
	color3 = 1.00,
	theme = 1,
	rgb_style = false
	}
}
local FindPlayer
if not doesDirectoryExist("moonloader//lib") then
	createDirectory("moonloader//lib")
	inicfg.save(initable, "FindPlayer")
end
FindPlayer = inicfg.load(nil, "FindPlayer")
if FindPlayer == nil then
	inicfg.save(initable, "FindPlayer")
	FindPlayer = inicfg.load(nil, "FindPlayer")
end
a1 = FindPlayer.cfg.color1
b1 = FindPlayer.cfg.color2
c1 = FindPlayer.cfg.color3
local rgb_speed = 0.5
if FindPlayer.cfg.rgb_style then
	rgb_style = true
end
theme = FindPlayer.cfg.theme
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8

local menuSelected = 1
local page = 1

local window = imgui.ImBool(false)
local nickIgnore = imgui.ImBuffer(200)
local FindLVLiO = imgui.ImInt(FindPlayer.cfg.findlvlOT)
local FindLVLiD = imgui.ImInt(FindPlayer.cfg.findlvlDO)
local message = imgui.ImBuffer(200)
message.v = u8(FindPlayer.cfg.message)
local message2 = imgui.ImBuffer(200)
message2.v = u8(FindPlayer.cfg.message2)
local message3 = imgui.ImBuffer(200)
message3.v = u8(FindPlayer.cfg.message3)
local cooldown = imgui.ImFloat(FindPlayer.cfg.cooldown / 1000)
local chkmsg = imgui.ImBool(FindPlayer.cfg.check)
local ignore = imgui.ImBool(FindPlayer.cfg.ignore)
local command = imgui.ImBuffer(35)
local color = imgui.ImFloat3(a1, b1, c1)
imgui.HotKey = require("imgui_addons").HotKey
local activeKeys = {
	v = decodeJson(FindPlayer.cfg.bindKey)
}
local tLastKeys = {}
command.v = tostring(u8(FindPlayer.cfg.command))
cmd = tostring(FindPlayer.cfg.command)

local fa_font = nil
local fa = require 'fAwesome5'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

nicksandnumbers = {
}
servers = {
	["Phoenix"] = "185.169.134.3:7777",
	["Tucson"] = "185.169.134.4:7777",
	["Scottdale"] = "185.169.134.43:7777",
	["Chandler"] = "185.169.134.44:7777",
	["Brainburg"] = "185.169.134.45:7777",
	["Saint Rose"] = "185.169.134.5:7777",
	["Mesa"] = "185.169.134.59:7777",
	["Red Rock"] = "185.169.134.61:7777",
	["Yuma"] = "185.169.134.107:7777",
	["Surprise"] = "185.169.134.109:7777",
	["Prescott"] = "185.169.134.166:7777",
	["Glendale"] = "185.169.134.171:7777",
	["Kingman"] = "185.169.134.172:7777",
	["Winslow"] = "185.169.134.173:7777",
	["Payson"] = "185.169.134.174:7777",
	["Gilbert"] = "80.66.82.191:7777",
	["Show Low"] = "80.66.82.190:7777",
	["Casa Grande"] = "80.66.82.188:7777",
	["Page"] = "80.66.82.168:7777",
	["Sun City"] = "80.66.82.159:7777",
	["Queen Creek"] = "80.66.82.200:7777",
	["Sedona"] = "80.66.82.144:7777",
	["Holiday"] = "80.66.82.132:7777"
}

local loadScr = true

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand(cmd, activation)

	sampAddChatMessage(tag .. color_text .. "Скрипт готов к работе. Автор - " .. "{FFFFFF}" ..  "СоМиК" .. color_text .. "! Меню скрипта: " .. "{FFFFFF}/" .. cmd, main_color)
	
	bindKey = rkeys.registerHotKey(activeKeys.v, 1, true, function() if not loadScr then window.v = not window.v imgui.Process = not imgui.Process else sampAddChatMessage(tag .. color_text .. "Вы сможете открыть окно {FFFFFF}только после входа {FFFF00}на сервер!", main_color) end end)

	activeCmd = cmd
	windowActive = false

	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
	if file == nil then
		io.open(MoonFolder .."\\config\\FindPlayer.json", "a")
	end
	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
	a = file:read("*a")
	file:close()
	local tabl = decodeJson(a)
	if tabl == nil then
		tabl = {
			nicks = {
			},
			hnicks = {
			},
			hinfo = {
			},
			hnumber = {
			},
			hlvl = {
			}
		}
	end
	encodedTable = encodeJson(tabl)
	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
	file:write(encodedTable)
	file:flush()
	file:close()

	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			checkupd = true
			updateIni = inicfg.load(nil, update_path)
			if updateIni ~= nil then
				if tonumber(updateIni.info.vers) > script_vers then
					sampAddChatMessage(tag .. color_text .. "Есть {FFFFFF}обновление{FFFF00}! Новая версия: {FFFFFF}" .. updateIni.info.vers_text .."{FFFF00}. Текущая версия: {FFFFFF}".. script_vers_text .. "{FFFF00}.", main_color)
					sampAddChatMessage(tag .. color_text .. "Чтобы {FFFFFF}установить{FFFF00} обновление, необходимо перейти в раздел {FFFFFF}\"обновления\"{FFFF00} в меню скрипта", main_color)
					mbobnova = true
					checkupd = false
				else
					checkupd = false
					sampAddChatMessage(tag .. color_text .. "Обновлений {FFFFFF}не найдено{FFFF00}.", main_color)
				end
				os.remove(update_path)
				checkupd = false
			else
				os.remove(update_path)
				checkupd = false
				sampAddChatMessage(tag .. color_text .. "Произошла какая-то {FFFFFF}ошибка{FFFF00}! Не удалось проверить наличие обновлений...", main_color)
				sampAddChatMessage(tag .. color_text .. "Вы можете попробовать проверить наличие обновлений заново, перейдя во вкладку \"{FFFFFF}обновления{FFFF00}\" в меню скрипта", main_color)
			end
		end
	end)

	while true do
		wait(0)
		if loadScr then
			repeat
				id = sampGetPlayerIdByCharHandle(PLAYER_PED)
				wait(1500)
			until sampIsPlayerConnected(id)
			local ip, port = sampGetCurrentServerAddress()
			local currentServer = ip .. ":" .. port
			local ik = 1
			for k, v in pairs(servers) do
				if currentServer == v then
					for i = 1, 3 do
						sampAddChatMessage(tag .. color_text .. "Сервер: {FFFFFF}Arizona Role Play: " .. k .. "{FFFF00}. Скрипт {FFFFFF}готов {FFFF00}к работе.", main_color)
					end
					break
				else
					ik = ik + 1
					if ik == 18 then
						for i = 1, 10 do
							sampAddChatMessage(tag .. color_text .. "Скрипт работает только на серверах {FFFFFF}ARIZONA GAMES{FFFF00}!", main_color)
							print("Сервер не найден. Скрипт работает только на серверах ARIZONA GAMES!")
						end
						thisScript():unload()
					end
				end
			end
			loadScr = false
		end
		if obnova then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage(tag .. color_text .. "Обновление {FFFFFF}успешно{FFFF00} установлено. Новая версия: {FFFFFF}" .. updateIni.info.vers_text, main_color)
					sampAddChatMessage(tag .. color_text .. "{FFFFFF}Узнать{FFFF00} историю обновлений можно в разделе {FFFFFF}\"обновления\"{FFFF00} в меню скрипта", main_color)
					sampAddChatMessage(tag .. color_text .. "Конфиг был автоматически {FFFFFF}сброшен {FFFF00}до состояния по умолчанию", main_color)
					os.remove(config_path)
				end
			end)
			break
		end
		if window.v then
			imgui.ShowCursor = true
		else
			imgui.ShowCursor = false
		end
		if windowActive then
			local result, button, list, input = sampHasDialogRespond(1337)
			if result then
				if button == 0 then
					imgui.Process = true
					window.v = true
					windowActive = false
				else
					imgui.Process = true
					window.v = true
					windowActive = false
				end
			end
		end
		if FindPlayer.cfg.bindKey:match("{}") then
			noValue = true
		else
			noValue = false
		end
	end
end

function ShowHotkey(hotk)
	local as = {}
	local te = ""
	for w in hotk:gmatch("[%d+]+") do
	  	table.insert(as, w)
	end
	for i = 1, #as do
		te = te .. keys.id_to_name(tonumber(as[i]))
		if i ~= #as then
			te = te .. " + "
		end
	end
	return te
end

function stringToArray(str)
	local t = {}
	for i = 1, #str do
	  t[i] = str:sub(i, i)
	end
	return t
end

function activation()
	if loadScr then
		sampAddChatMessage(tag .. color_text .. "Сначала необходимо {FFFFFF}войти {FFFF00}на сервер!", main_color)
		if window.v then
			window.v = not window.v
			imgui.Process = false
		else
			window.v = true
			imgui.Process = true
		end
	else
		if window.v then
			window.v = not window.v
			imgui.Process = false
		else
			window.v = true
			imgui.Process = true
		end
	end
end

function findLvl()
	process = true
	lua_thread.create(function()
		while true do
			wait(0)
			for i = 1, 1000 do
				if process then
					if #nicksandnumbers ~= 0 then
						if sampIsPlayerConnected(i) then
							local predNick = sampGetPlayerNickname(i)
							score = sampGetPlayerScore(i)
							if (math.abs(findLVLiO - score) < findLVLiD - findLVLiO or score == findLVLiD) and score >= findLVLiO then
								idforinfo = i
								nickse = sampGetPlayerNickname(i)
								gocheck = true
								local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
								a = file:read("*a")
								file:close()
								local ignoredNicknamesMassive = decodeJson(a)
								if #ignoredNicknamesMassive["nicks"] ~= 0 then
									local cou = 1
									for _,v in ipairs(ignoredNicknamesMassive["nicks"]) do
										if predNick ~= v then
											cou = cou + 1
											if cou > #ignoredNicknamesMassive["nicks"] then
												wait(100)
												repeat
													wait(5)
													if not process then
														break
													end
												until sended == true
												id = i
												idforinfo = i
												lvl = score
												nickse = sampGetPlayerNickname(i)
												kostil = true
												if process then
													wait(100)
													sended = false
													sampSendChat("/number " .. i)
													wait(500)
												end
												break
											end
										else
											break
										end
									end
								else
									wait(100)
									repeat
										wait(5)
										if not process then
											break
										end
									until sended == true
									id = i
									lvl = score
									nickse = sampGetPlayerNickname(i)
									kostil = true
									if process then
										wait(100)
										sended = false
										sampSendChat("/number " .. i)
										wait(400)
									end
								end
							end
						end
					else
						if sampIsPlayerConnected(i) then
							local predNick = sampGetPlayerNickname(i)
							score = sampGetPlayerScore(i)
							if (math.abs(findLVLiO - score) < findLVLiD - findLVLiO or score == findLVLiD) and score >= findLVLiO then
								idforinfo = i
								nickse = sampGetPlayerNickname(i)
								gocheck = true
								local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
								a = file:read("*a")
								file:close()
								local ignoredNicknamesMassive = decodeJson(a)
								if #ignoredNicknamesMassive["nicks"] ~= 0 then
									local cou = 1
									for _,v in ipairs(ignoredNicknamesMassive["nicks"]) do
										if predNick ~= v then
											cou = cou + 1
											if cou > #ignoredNicknamesMassive["nicks"] then
												wait(100)
												id = i
												idforinfo = i
												lvl = score
												nickse = sampGetPlayerNickname(i)
												kostil = true
												if process then
													sampSendChat("/number " .. i)
													wait(100)
													sended = true
													wait(400)
												end
												break
											end
										else
											break
										end
									end
								else
									wait(100)
									id = i
									lvl = score
									nickse = sampGetPlayerNickname(i)
									kostil = true
									if process then
										sampSendChat("/number " .. i)
										wait(100)
										sended = true
										wait(400)
									end
								end
							end
						end
					end
					if i == 1000 then
						if #nicksandnumbers == 0 then
							table.insert(nicksandnumbers, {0, "игроки не найдены", 0, 0})
						end
					end
				else
					break
				end
			end
			process = false
			break
		end
	end)
end

function sampev.onSendClickTextDraw(id)
	if id == 65535 then
		
	end
end

function sampev.onServerMessage(color, msg)
	if process then
		if msg:match("^У вас нет телефонной книжки$") then
			table.insert(nicksandnumbers, {nickse, "нет телефонной книжки", id, lvl})
			sended = true
			process = false
			sampAddChatMessage(tag .. color_text .. "У вас нет {FFFFFF}телефонной книжки{FFFF00}, необходимой для работы скрипта. Купите её в любом магазине {FFFFFF}24/7", main_color)
			return false
		elseif msg:match("^%[Ошибка%] {......}У этого игрока нет sim карты!$") then
			if not FindPlayer.cfg.ignore then
				table.insert(nicksandnumbers, {nickse, "нет сим-карты", id, lvl})
				sended = true
				return false
			else
				sended = true
				return false
			end
		elseif msg:match("^{......}%S+%[%d+%]:    {......}%d+$") then
			local number = msg:match("^{......}%S+%[%d+%]:    {......}(%d+)$")
			table.insert(nicksandnumbers, {nickse, number, id, lvl})
			sended = true
			return false
		elseif msg:match("^%[Ошибка%] {......}Игрок не в сети!$") then
			table.insert(nicksandnumbers, {nickse, "не в сети", id, lvl})
			sended = true
			return false
		elseif msg:match("^%[Ошибка%] {......}У вас уже открыт телефон.$") then
			sampAddChatMessage(tag .. color_text .. "Перед звонком вы должны {FFFFFF}закрыть{FFFF00} телефон.", main_color)
		elseif msg:match("^%[Информация%] {......}Вы подняли трубку") then
			process = false
			sampAddChatMessage(tag .. color_text .. "Вы ответили на {FFFFFF}звонок{FFFF00}. Поиск игроков был аварийно {FFFFFF}завершен{FFFF00}.", main_color)
		end
	end
	if waitCalling then
		if msg:match("^%[Информация%] {FFFFFF}Собеседник взял трубку$") then
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
			local a = file:read("*a")
			file:close()
			local json = decodeJson(a)
			if #json["hnicks"] == 0 then
				table.insert(json["hnicks"], nick_x)
				table.insert(json["hlvl"], lvl_x)
				table.insert(json["hnumber"], number_x)
				table.insert(json["hinfo"], "{009900}вызов совершён")
			else
				for i = #json["hnicks"] + 1, 1, -1 do
					if i ~= 1 and i ~= 21 then
						json["hnicks"][i] = json["hnicks"][i - 1]
						json["hlvl"][i] = json["hlvl"][i - 1]
						json["hnumber"][i] = json["hnumber"][i - 1]
						json["hinfo"][i] = json["hinfo"][i - 1]
					else
						if i == 1 then
							json["hnicks"][i] = nick_x
							json["hlvl"][i] = lvl_x
							json["hnumber"][i] = number_x
							json["hinfo"][i] = "{009900}вызов совершён"
						end
					end
				end
			end
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
			file:write(encodeJson(json))
			file:flush()
			file:close()
			calling = true
			if calling then
				if chkmsg.v then
					if FindPlayer.cfg.message ~= "" and FindPlayer.cfg.message2 ~= "" and FindPlayer.cfg.message3 ~= "" then
						local cd = FindPlayer.cfg.cooldown
						lua_thread.create(function ()
							while true do
								sendMSG = true
								if FindPlayer.cfg.messages >= 1 then
									wait(500)
									sampSendChat(FindPlayer.cfg.message)
									if FindPlayer.cfg.messages > 1 then
										wait(cd)
										sampSendChat(FindPlayer.cfg.message2)
										if FindPlayer.cfg.messages > 2 then
											wait(cd)
											sampSendChat(FindPlayer.cfg.message3)
										end
									end
								end
								sendMSG = false
								break
							end
						end)
					else
						if noValue then
							sampAddChatMessage(tag .. color_text .. "Авто-сообщение при дозвоне было включено, но не сработало, потому что сообщение {FFFFFF}пустое", main_color)
							sampAddChatMessage(tag .. color_text .. "перейдите в меню скрипта, с помощью команды \"{FFFFFF}/" .. cmd .. "{FFFF00}\"", main_color)
							sampAddChatMessage(tag .. color_text .. "Перейдите во вкладку \"{FFFFFF}параметры скрипта{FFFF00}\" и впишите нужный текст в пуст(ое/ые) пол(е/я).", main_color)

						else
							sampAddChatMessage(tag .. color_text .. "Авто-сообщение при дозвоне было включено, но не сработало, потому что сообщение {FFFFFF}пустое", main_color)
							sampAddChatMessage(tag .. color_text .. "перейдите в меню скрипта с помощью команды  команды \"{FFFFFF}/" .. cmd .. "{FFFF00}\"", main_color)
							sampAddChatMessage(tag .. color_text .. "или с помощью бинда {FFFFFF}" .. ShowHotkey(FindPlayer.cfg.bindKey) .. "{FFFF00}", main_color)
							sampAddChatMessage(tag .. color_text .. "Перейдите во вкладку \"{FFFFFF}параметры скрипта{FFFF00}\" и впишите нужный текст в пуст(ое/ые) пол(е/я).", main_color)
						end
					end
				end
			end
		end
		if msg:match("%[Информация%] {......}Звонок окончен! Время разговора {......}%d+ секунд%.") then
			calling = false
			waitCalling = false
			lua_thread.create(function ()
				while true do
					wait(0)
					sampSendClickTextdraw(65535)
					wait(100)
					sampAddChatMessage(tag .. color_text .. "{FFFF00}Звонок был {FFFFFF}завершен{FFFF00}. Время разговора: {FFFFFF}" .. msg:match("%[Информация%] {......}Звонок окончен! Время разговора {......}(%d+) секунд%.") .. " {FFFF00}секунд", main_color)
					break
				end
			end)
			return false
		end
		if msg:match("^%[Информация%] {FFFFFF}Собеседник отменил звонок$") then
			calling = false
			waitCalling = false
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
			local a = file:read("*a")
			file:close()
			local json = decodeJson(a)
			if #json["hnicks"] == 0 then
				table.insert(json["hnicks"], nick_x)
				table.insert(json["hlvl"], lvl_x)
				table.insert(json["hnumber"], number_x)
				table.insert(json["hinfo"], "{660000}вызов отклонен (абонентом)")
			else
				for i = #json["hnicks"] + 1, 1, -1 do
					if i ~= 1 and i ~= 21 then
						json["hnicks"][i] = json["hnicks"][i - 1]
						json["hlvl"][i] = json["hlvl"][i - 1]
						json["hnumber"][i] = json["hnumber"][i - 1]
						json["hinfo"][i] = json["hinfo"][i - 1]
					else
						if i == 1 then
							json["hnicks"][i] = nick_x
							json["hlvl"][i] = lvl_x
							json["hnumber"][i] = number_x
							json["hinfo"][i] = "{660000}вызов отклонен (абонентом)"
						end
					end
				end
			end
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
			file:write(encodeJson(json))
			file:flush()
			file:close()
			lua_thread.create(function ()
				while true do
					wait(0)
					sampSendClickTextdraw(65535)
					wait(100)
					sampAddChatMessage(tag .. color_text .. "{FFFFFF}Абонент {FFFF00}отклонил ваш звонок.", main_color)
					break
				end
			end)
			return false
		end
		if msg:match("^%[Информация%] {......}Вы отменили звонок$") then
			phoneProcess = false
			waitCalling = false
			calling = false
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
			local a = file:read("*a")
			file:close()
			local json = decodeJson(a)
			if #json["hnicks"] == 0 then
				table.insert(json["hnicks"], nick_x)
				table.insert(json["hlvl"], lvl_x)
				table.insert(json["hnumber"], number_x)
				table.insert(json["hinfo"], "{660000}вызов отклонен (вами)")
			else
				for i = #json["hnicks"] + 1, 1, -1 do
					if i ~= 1 and i ~= 21 then
						json["hnicks"][i] = json["hnicks"][i - 1]
						json["hlvl"][i] = json["hlvl"][i - 1]
						json["hnumber"][i] = json["hnumber"][i - 1]
						json["hinfo"][i] = json["hinfo"][i - 1]
					else
						if i == 1 then
							json["hnicks"][i] = nick_x
							json["hlvl"][i] = lvl_x
							json["hnumber"][i] = number_x
							json["hinfo"][i] = "{660000}вызов отклонен (вами)"
						end
					end
				end
			end
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
			file:write(encodeJson(json))
			file:flush()
			file:close()
		end
	end
	if phoneProcess or waitCalling or calling then
		if msg:match("^%[Ошибка%] {FFFFFF}Подождите, пока исчезнет окно мероприятия %( 2%-3 минуты %)!$") then
			sampAddChatMessage(tag .. color_text .. "На сервере активен {FFFFFF}текстдрав{FFFF00}, который запрещает взаимодействовать с телефоном. {FFFFFF}Подождите{FFFF00}, пока оно исчезнет.", main_color)
			phoneProcess = false
		end
		if msg:match("^У вас нет sim карты!$") then
			phoneProcess = false
			waitCalling = false
			sampAddChatMessage(tag .. color_text .. "У вас не установлена {FFFFFF}сим-карта {FFFF00}в телефон!", main_color)
			return false
		end
		if msg:match("^%[Информация%] {......}Вы отменили звонок$") then
			phoneProcess = false
			waitCalling = false
			calling = false
			sampSendClickTextdraw(65535)
		end
		if msg:match("^%[Подсказка%] {......}Номера телефонов государственных служб:$") then
			return false
		end
		if msg:match("^{......}1%.{......} 111 %- {......}Проверить баланс телефона$") then
			return false
		end
		if msg:match("^{......}2%.{......} 060 %- {......}Служба точного времени$") then
			return false
		end
		if msg:match("^{......}3%.{......} 911 %- {......}Полицейский участок$") then
			return false
		end
		if msg:match("^{......}4%.{......} 912 %- {......}Скорая помощь$") then
			return false
		end
		if msg:match("^{......}5%.{......} 913 %- {......}Такси$") then
			return false
		end
		if msg:match("^{......}6%.{......} 914 %- {......}Механик$") then
			return false
		end
		if msg:match("^{......}7%.{......} 8828 %- {......}Справочная центрального банка$") then
			return false
		end
		if msg:match("^{......}8%.{......} 997 %- {......}Служба по вопросам жилой недвижимости %(узнать владельца дома%)$") then
			return false
		end
	end
end

function sampev.onShowDialog(id, style, title, b1, b2, text)
	print(text)
	if phoneProcess or waitCalling or calling then
		if text == "{B03131}Ваш абонент вне зоны действия сети!\n{FFFFFF}Вы можете оставить ему сообщение, как только он появится в сети он его сможет прочитать." then
			sampAddChatMessage(tag .. color_text .. "У абонента {FFFFFF}выключен {FFFF00}телефон (режим полёта)!", main_color)
			phoneProcess = false
			waitCalling = false
			calling = false
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
			local a = file:read("*a")
			file:close()
			local json = decodeJson(a)
			if #json["hnicks"] == 0 then
				table.insert(json["hnicks"], nick_x)
				table.insert(json["hlvl"], lvl_x)
				table.insert(json["hnumber"], number_x)
				table.insert(json["hinfo"], "{660000}вызов отклонен (выключен телефон)")
			else
				for i = #json["hnicks"] + 1, 1, -1 do
					if i ~= 1 and i ~= 21 then
						json["hnicks"][i] = json["hnicks"][i - 1]
						json["hlvl"][i] = json["hlvl"][i - 1]
						json["hnumber"][i] = json["hnumber"][i - 1]
						json["hinfo"][i] = json["hinfo"][i - 1]
					else
						if i == 1 then
							json["hnicks"][i] = nick_x
							json["hlvl"][i] = lvl_x
							json["hnumber"][i] = number_x
							json["hinfo"][i] = "{660000}вызов отклонен (выключен телефон)"
						end
					end
				end
			end
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
			file:write(encodeJson(json))
			file:flush()
			file:close()
			return false
		end
	end
end

function sampev.onSendCommand(cmd)
	if process then
		if not cmd:find("/number") then
			sampAddChatMessage(tag .. color_text .. "Команды {FFFFFF}запрещено {FFFF00}использовать, когда поиск людей {FFFFFF}активен{FFFF00}!", main_color)
			return false
		end
	end
	if phoneProcess then
		if not cmd:find("/phone") then
			sampAddChatMessage(tag .. color_text .. "Команды {FFFFFF}запрещено {FFFF00}использовать, когда авто-звонок {FFFFFF}активен{FFFF00}!", main_color)
			return false
		end
	end
	if calling or waitCalling then
		if cmd:find("/phone") then
			phoneProcess = false
		end
	end
end

function sampev.onSendChat(msg)
	if sendMSG then
		local i = 1
		if msg ~= u8:decode(message.v) then
			i = i + 1
		end
		if msg ~= u8:decode(message2.v) then
			i = i + 1
		end
		if msg ~= u8:decode(message3.v) then
			i = i + 1
		end
		if i == 4 then
			sampAddChatMessage(tag .. color_text .. "Подождите {FFFFFF}немного{ffff00}...", main_color)
			return false
		end
	end
end

function sampev.onSendClientJoin(version, mod, nickname, challengeResponse, joinAuthKey, clientVer, challengeResponse2)
	local ip, port = sampGetCurrentServerAddress()
	local currentServer = ip .. ":" .. port
	local ik = 1
	for k, v in pairs(servers) do
		if currentServer == v then
			for i = 1, 3 do
				sampAddChatMessage(tag .. color_text .. "Сервер: {FFFFFF}Arizona Role Play: " .. k .. "{FFFF00}. Скрипт {FFFFFF}готов {FFFF00}к работе.", main_color)
			end
			break
		else
			ik = ik + 1
			if ik == 18 then
				for i = 1, 10 do
					sampAddChatMessage(tag .. color_text .. "Скрипт работает только на серверах {FFFFFF}ARIZONA GAMES{FFFF00}!", main_color)
					print("Сервер не найден. Скрипт работает только на серверах ARIZONA GAMES!")
				end
				thisScript():unload()
			end
		end
	end
end

function onWindowMessage(msg, wparam, lparam)
	if msg == 0x0100 and phoneProcess then
		if wparam ~= VK_ESCAPE then
			consumeWindowMessage(true, true)
			sampAddChatMessage(tag .. color_text .. "Нажимать на клавиши запрещено, когда процесс авто-звонка {FFFFFF}активен{FFFF00}!", main_color)
		end
	end
end

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	local r,g,b,a = rainbow(rgb_speed, 255, 0)
	local argb = join_argb(a, r, g, b)
	local a = a / 255
	local r = r / 255
	local g = g / 255
	local b = b / 255
	if rgb_style then
		color = imgui.ImFloat3(r, g, b)
		local clor = join_argb(0, r * 255, g * 255, b * 255)
		d1 = ('%06X'):format(clor)
		d1 = "{" .. d1 .. "}"
	else
		color = imgui.ImFloat3(a1, b1, c1)
		local clor = join_argb(0, a1 * 255, b1 * 255, c1 * 255)
		d1 = ('%06X'):format(clor)
		d1 = "{" .. d1 .. "}"
	end

	style.WindowPadding = imgui.ImVec2(8.0, 4.0)
	style.WindowRounding = 16.0
	style.ChildWindowRounding = 6.0
	style.FramePadding = imgui.ImVec2(4.0, 3.0)
	style.FrameRounding = 12.0
	style.ItemSpacing = imgui.ImVec2(12.0, 6.5)
	style.ItemInnerSpacing = imgui.ImVec2(4.0, 4.0)
	style.TouchExtraPadding = imgui.ImVec2(0, 0)
	style.IndentSpacing = 0
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 12.0
	style.GrabMinSize = 20.0
	style.GrabRounding = 16.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.15)

	if theme == 1 then
		colors[clr.Text]                   = ImVec4(0.00, 0.00, 0.00, 1.00)
		colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00)
		colors[clr.WindowBg]               = ImVec4(1, 1, 1, 1.00)
		colors[clr.ChildWindowBg]          = ImVec4(0.22, 0.22, 0.22, 0.00)
		colors[clr.PopupBg]                = ImVec4(0, 0, 0, 0.84)
		if rgb_style then
			colors[clr.Border]                 = ImVec4(r, g, b, 1.00)
		else
			colors[clr.Border]                 = ImVec4(a1, b1, c1, 1.00)
		end
		colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.00)
		colors[clr.FrameBg]                = ImVec4(0.00, 0.00, 0.00, 0.30)
		colors[clr.FrameBgHovered]         = ImVec4(0.62, 0.62, 0.62, 0.40)
		colors[clr.FrameBgActive]          = ImVec4(1.00, 1.00, 1.00, 0.46)
		if rgb_style then
			colors[clr.TitleBg]                = ImVec4(r, g, b, 0.83)
			colors[clr.TitleBgActive]          = ImVec4(r, g, b, 0.87)
			colors[clr.TitleBgCollapsed]       = ImVec4(r, g, b, 0.20)
		else
			colors[clr.TitleBg]                = ImVec4(a1, b1, c1, 0.83)
			colors[clr.TitleBgActive]          = ImVec4(a1, b1, c1, 0.87)
			colors[clr.TitleBgCollapsed]       = ImVec4(a1, b1, c1, 0.20)
		end
		colors[clr.MenuBarBg]              = ImVec4(1.00, 1.00, 1.00, 0.80)
		if rgb_style then
			colors[clr.ScrollbarBg]            = ImVec4(r, g, b, 0.50)
			colors[clr.ScrollbarGrab]          = ImVec4(r, g, b, 0.82)
			colors[clr.ScrollbarGrabHovered]   = ImVec4(r, g, b, 0.88)
			colors[clr.ScrollbarGrabActive]    = ImVec4(r, g, b, 1.0)
		else
			colors[clr.ScrollbarBg]            = ImVec4(a1, b1, c1, 0.50)
			colors[clr.ScrollbarGrab]          = ImVec4(a1, b1, c1, 0.82)
			colors[clr.ScrollbarGrabHovered]   = ImVec4(a1, b1, c1, 0.88)
			colors[clr.ScrollbarGrabActive]    = ImVec4(a1, b1, c1, 1.0)
		end
		colors[clr.ComboBg]                = ImVec4(1.00, 1.00, 1.00, 0.99)
		if rgb_style then
			colors[clr.CheckMark]              = ImVec4(r, g, b, 0.97)
			colors[clr.SliderGrab]             = ImVec4(r, g, b, 0.76)
			colors[clr.SliderGrabActive]       = ImVec4(r, g, b, 0.99)
		else
			colors[clr.CheckMark]              = ImVec4(a1, b1, c1, 0.97)
			colors[clr.SliderGrab]             = ImVec4(a1, b1, c1, 0.76)
			colors[clr.SliderGrabActive]       = ImVec4(a1, b1, c1, 0.99)
		end
		if rgb_style then
			colors[clr.Button]                 = ImVec4(r, g, b, 0.9)
			colors[clr.ButtonHovered]          = ImVec4(r, g, b, 0.5)
			colors[clr.ButtonActive]           = ImVec4(r, g, b, 1)
			colors[clr.Header]                 = ImVec4(r, g, b, 0.70)
			colors[clr.HeaderHovered]          = ImVec4(r, g, b, 0.46)
			colors[clr.HeaderActive]           = ImVec4(r, g, b, 0.80)
			colors[clr.Separator]              = ImVec4(r, g, b, 1.00)
			colors[clr.SeparatorHovered]       = ImVec4(r, g, b, 1.00)
			colors[clr.SeparatorActive]        = ImVec4(r, g, b, 1.00)
		else
			colors[clr.Button]                 = ImVec4(a1, b1, c1, 0.9)
			colors[clr.ButtonHovered]          = ImVec4(a1, b1, c1, 0.5)
			colors[clr.ButtonActive]           = ImVec4(a1, b1, c1, 1)
			colors[clr.Header]                 = ImVec4(a1, b1, c1, 0.70)
			colors[clr.HeaderHovered]          = ImVec4(a1, b1, c1, 0.46)
			colors[clr.HeaderActive]           = ImVec4(a1, b1, c1, 0.80)
			colors[clr.Separator]              = ImVec4(a1, b1, c1, 1.00)
			colors[clr.SeparatorHovered]       = ImVec4(a1, b1, c1, 1.00)
			colors[clr.SeparatorActive]        = ImVec4(a1, b1, c1, 1.00)
		end
		colors[clr.ResizeGrip]             = ImVec4(1.00, 1.00, 1.00, 0.30)
		colors[clr.ResizeGripHovered]      = ImVec4(1.00, 1.00, 1.00, 0.60)
		colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
		if rgb_style then
			colors[clr.CloseButton]            = ImVec4(r - 50, g - 50, b - 50, 0.83)
			colors[clr.CloseButtonHovered]     = ImVec4(r - 50, g - 50, b - 50, 0.6)
			colors[clr.CloseButtonActive]      = ImVec4(r - 50, g - 50, b - 50, 0.5)
		else
			colors[clr.CloseButton]            = ImVec4(a1 - 50, b1 - 50, c1 - 50, 0.83)
			colors[clr.CloseButtonHovered]     = ImVec4(a1 - 50, b1 - 50, c1 - 50, 0.6)
			colors[clr.CloseButtonActive]      = ImVec4(a1 - 50, b1 - 50, c1 - 50, 0.5)
		end
		colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00)
		colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
		colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
		colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.00, 0.00, 0.35)
		colors[clr.ModalWindowDarkening]   = ImVec4(0.20, 0.20, 0.20, 0.35)
	elseif theme == 2 then
		colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
		colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
		colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.PopupBg]                = ImVec4(1, 1, 1, 0.84)
		if rgb_style then
			colors[clr.Border]                 = ImVec4(r, g, b, 1.00)
		else
			colors[clr.Border]                 = ImVec4(a1, b1, c1, 1.00)
		end
		colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg]                = ImVec4(0.80, 0.80, 0.80, 0.30)
		colors[clr.FrameBgHovered]         = ImVec4(1.00, 1.00, 1.00, 0.53)
		colors[clr.FrameBgActive]          = ImVec4(1.00, 1.00, 1.00, 0.41)
		if rgb_style then
			colors[clr.TitleBg]                = ImVec4(r, g, b, 1.00)
			colors[clr.TitleBgActive]          = ImVec4(r, g, b, 1.00)
			colors[clr.TitleBgCollapsed]       = ImVec4(r, g, b, 0.35)
		else
			colors[clr.TitleBg]                = ImVec4(a1, b1, c1, 1.00)
			colors[clr.TitleBgActive]          = ImVec4(a1, b1, c1, 1.00)
			colors[clr.TitleBgCollapsed]       = ImVec4(a1, b1, c1, 0.35)
		end
		colors[clr.MenuBarBg]              = ImVec4(1.00, 1.00, 1.00, 0.41)
		if rgb_style then
			colors[clr.ScrollbarBg]            = ImVec4(r, g, b, 0.50)
			colors[clr.ScrollbarGrab]          = ImVec4(r, g, b, 0.82)
			colors[clr.ScrollbarGrabHovered]   = ImVec4(r, g, b, 0.88)
			colors[clr.ScrollbarGrabActive]    = ImVec4(r, g, b, 1.0)
		else
			colors[clr.ScrollbarBg]            = ImVec4(a1, b1, c1, 0.50)
			colors[clr.ScrollbarGrab]          = ImVec4(a1, b1, c1, 0.82)
			colors[clr.ScrollbarGrabHovered]   = ImVec4(a1, b1, c1, 0.88)
			colors[clr.ScrollbarGrabActive]    = ImVec4(a1, b1, c1, 1.0)
		end
		colors[clr.ComboBg]                = ImVec4(0.03, 0.03, 0.03, 0.99)
		if rgb_style then
			colors[clr.CheckMark]              = ImVec4(r, g, b, 1.00)
			colors[clr.SliderGrab]             = ImVec4(r, g, b, 0.76)
			colors[clr.SliderGrabActive]       = ImVec4(r, g, b, 0.99)
		else
			colors[clr.CheckMark]              = ImVec4(a1, b1, c1, 1.00)
			colors[clr.SliderGrab]             = ImVec4(a1, b1, c1, 0.76)
			colors[clr.SliderGrabActive]       = ImVec4(a1, b1, c1, 0.99)
		end
		if rgb_style then
			colors[clr.Button]                 = ImVec4(r, g, b, 0.7)
			colors[clr.ButtonHovered]          = ImVec4(r, g, b, 1.00)
			colors[clr.ButtonActive]           = ImVec4(r, g, b, 0.5)
			colors[clr.Header]                 = ImVec4(r, g, b, 0.8)
			colors[clr.HeaderHovered]          = ImVec4(r, g, b, 0.34)
			colors[clr.HeaderActive]           = ImVec4(r, g, b, 0.74)
			colors[clr.Separator]              = ImVec4(r, g, b, 1.00)
			colors[clr.SeparatorHovered]       = ImVec4(r, g, b, 1.00)
			colors[clr.SeparatorActive]        = ImVec4(r, g, b, 1.00)
		else
			colors[clr.Button]                 = ImVec4(a1, b1, c1, 0.7)
			colors[clr.ButtonHovered]          = ImVec4(a1, b1, c1, 1.00)
			colors[clr.ButtonActive]           = ImVec4(a1, b1, c1, 0.5)
			colors[clr.Header]                 = ImVec4(a1, b1, c1, 0.8)
			colors[clr.HeaderHovered]          = ImVec4(a1, b1, c1, 0.34)
			colors[clr.HeaderActive]           = ImVec4(a1, b1, c1, 0.74)
			colors[clr.Separator]              = ImVec4(a1, b1, c1, 1.00)
			colors[clr.SeparatorHovered]       = ImVec4(a1, b1, c1, 1.00)
			colors[clr.SeparatorActive]        = ImVec4(a1, b1, c1, 1.00)
		end
		colors[clr.ResizeGrip]             = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.ResizeGripHovered]      = ImVec4(1.00, 1.00, 1.00, 0.60)
		colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 1.00)
		if rgb_style then
			colors[clr.CloseButton]            = ImVec4(r - 50, g - 50, b - 50, 0.83)
			colors[clr.CloseButtonHovered]     = ImVec4(r - 50, g - 50, b - 50, 1)
			colors[clr.CloseButtonActive]      = ImVec4(r - 50, g - 50, b - 50, 0.5)
		else
			colors[clr.CloseButton]            = ImVec4(a1 - 50, b1 - 50, c1 - 50, 0.83)
			colors[clr.CloseButtonHovered]     = ImVec4(a1 - 50, b1 - 50, c1 - 50, 1)
			colors[clr.CloseButtonActive]      = ImVec4(a1 - 50, b1 - 50, c1 - 50, 0.5)
		end
		colors[clr.PlotLines]              = ImVec4(0.00, 0.00, 0.00, 1.00)
		colors[clr.PlotLinesHovered]       = ImVec4(0.00, 0.00, 0.00, 1.00)
		colors[clr.PlotHistogram]          = ImVec4(0.00, 0.00, 0.00, 1.00)
		colors[clr.PlotHistogramHovered]   = ImVec4(0.00, 0.00, 0.00, 1.00)
		colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.00, 0.00, 0.35)
		colors[clr.ModalWindowDarkening]   = ImVec4(0.00, 0.00, 0.00, 0.35)
	end
end

function imgui.CustomButton(name, color, colorHovered, colorActive, size)
	local clr = imgui.Col
	imgui.PushStyleColor(clr.Button, color)
	imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
	imgui.PushStyleColor(clr.ButtonActive, colorActive)
	if not size then size = imgui.ImVec2(0, 0) end
	local result = imgui.Button(name, size)
	imgui.PopStyleColor(3)
	return result
end

function imgui.TextColoredRGB(text)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end

	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end

	render_text(text)
end

function imgui.TextColoredRGBCenter(text)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local width = imgui.GetWindowWidth()
	local height = imgui.GetWindowHeight()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX( width / 2 - calc.x / 2 - 125 )
	imgui.SetCursorPosY( height / 2 - calc.y / 2 )

	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end

	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end

	render_text(text)
end

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	imgui.Text(text)
end

function imgui.CenterTextDisabled(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	imgui.TextDisabled(text)
end

function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		if theme == 1 then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
		elseif theme == 2 then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
		end
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(550)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
		imgui.PopStyleColor()
	end
end

function join_argb(a, r, g, b)
	local argb = b  -- b
	argb = bit.bor(argb, bit.lshift(g, 8))  -- g
	argb = bit.bor(argb, bit.lshift(r, 16)) -- r
	argb = bit.bor(argb, bit.lshift(a, 24)) -- a
	return argb
end

function rainbow(speed, alpha, offset)
	local clock = os.clock() + offset
	local r = math.floor(math.sin(clock * speed) * 127 + 128)
	local g = math.floor(math.sin(clock * speed + 2) * 127 + 128)
	local b = math.floor(math.sin(clock * speed + 4) * 127 + 128)
	return r,g,b,alpha
end

local clor = join_argb(0, a1 * 255, b1 * 255, c1 * 255)
d1 = ('%06X'):format(clor)
d1 = "{" .. d1 .. "}"

function imgui.VerticalSeparator()
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x, p.y + imgui.GetContentRegionMax().y - 33), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Separator]))
end

function imgui.InputTextWithHint(label, hint, buf, flags, callback, user_data)
    local l_pos = {imgui.GetCursorPos(), 0}
    local handle = imgui.InputText(label, buf, flags, callback, user_data)
    l_pos[2] = imgui.GetCursorPos()
    local t = (type(hint) == 'string' and buf.v:len() < 1) and hint or '\0'
    local t_size, l_size = imgui.CalcTextSize(t).x, imgui.CalcTextSize('A').x
    imgui.SetCursorPos(imgui.ImVec2(l_pos[1].x + 8, l_pos[1].y + 2))
    imgui.TextDisabled((imgui.CalcItemWidth() and t_size > imgui.CalcItemWidth()) and t:sub(1, math.floor(imgui.CalcItemWidth() / l_size)) or t)
    imgui.SetCursorPos(l_pos[2])
    return handle
end

function imgui.BeforeDrawFrame()
	if fa_font == nil then
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize40 == nil then
		fontsize40 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 40.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize20 == nil then
		fontsize20 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize30 == nil then
		fontsize30 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize35 == nil then
		fontsize35 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 35.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize25 == nil then
		fontsize25 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize23 == nil then
		fontsize23 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 23.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 18.0, font_config, fa_glyph_ranges)
	end
	if fontsize18 == nil then
		fontsize18 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\comicbd.ttf', 18.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/lib/resource/fonts/fa-solid-900.ttf', 11.0, font_config, fa_glyph_ranges)
	end
end 
-- 363
-- 334
-- 404
-- 375
function imgui.OnDrawFrame()
	imgui.Process = window.v
	apply_custom_style()
	if window.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowSize(imgui.ImVec2(1350, 405), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2 - 725, sh / 2 - 222.5), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"FindPlayers", window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
		imgui.PushFont(fontsize25)
		imgui.Spacing()
		imgui.BeginChild("Select", imgui.ImVec2(367, 376))
			if menuSelected == 1 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_SEARCH .. u8" поиск людей", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_SEARCH .. u8" поиск людей", imgui.ImVec2(355, 35)) then
					menuSelected = 1
				end
			end
			if menuSelected == 2 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_MOBILE .. u8" история звонков", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_MOBILE .. u8" история звонков", imgui.ImVec2(355, 35)) then
					menuSelected = 2
				end
			end
			if menuSelected == 4 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_COG .. u8" параметры скрипта", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_COG .. u8" параметры скрипта", imgui.ImVec2(355, 35)) then
					menuSelected = 4
				end
			end
			if menuSelected == 5 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_KEYBOARD .. u8" настройки активации скрипта", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_KEYBOARD .. u8" настройки активации скрипта", imgui.ImVec2(355, 35)) then
					menuSelected = 5
				end
			end
			if menuSelected == 6 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_BAN .. u8" система игнорирования игроков", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_BAN .. u8" система игнорирования игроков", imgui.ImVec2(355, 35)) then
					menuSelected = 6
				end
			end
			if menuSelected == 7 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_PALETTE .. u8" кастомизация интерфейса", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_PALETTE .. u8" кастомизация интерфейса", imgui.ImVec2(355, 35)) then
					menuSelected = 7
				end
			end
			if menuSelected == 8 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_FOLDER_PLUS .. u8" обновления", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_FOLDER_PLUS .. u8" обновления", imgui.ImVec2(355, 35)) then
					menuSelected = 8
				end
			end
			if menuSelected == 9 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8" информация о скрипте", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8" информация о скрипте", imgui.ImVec2(355, 35)) then
					menuSelected = 9
				end
			end
			if theme == 1 then
				local style = imgui.GetStyle()
				local colors = style.Colors
				local clr = imgui.Col
				local ImVec4 = imgui.ImVec4
				colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
				if imgui.CustomButton(fa.ICON_FA_BRUSH .. u8" перейти на тёмную тему", imgui.ImVec4(0.00, 0.00, 0.00, 0.95),  imgui.ImVec4(0.00, 0.00, 0.00, 1.00), imgui.ImVec4(0.00, 0.00, 0.00, 0.8), imgui.ImVec2(355, 35))  then
					theme = 2
					FindPlayer.cfg.theme = theme
					inicfg.save(FindPlayer, "FindPlayer")
				end
				colors[clr.Text] = ImVec4(0.00, 0.00, 0.00, 1.00)
			elseif theme == 2 then
				local style = imgui.GetStyle()
				local colors = style.Colors
				local clr = imgui.Col
				local ImVec4 = imgui.ImVec4
				colors[clr.Text] = ImVec4(0.00, 0.00, 0.00, 1.00)
				if imgui.CustomButton(fa.ICON_FA_BRUSH .. u8" перейти на светлую тему", imgui.ImVec4(1.00, 1.00, 1.00, 0.8),  imgui.ImVec4(1.00, 1.00, 1.00, 1.00), imgui.ImVec4(1.00, 1.00, 1.00, 0.40), imgui.ImVec2(355, 35))  then
					theme = 1
					FindPlayer.cfg.theme = theme
					inicfg.save(FindPlayer, "FindPlayer")
				end
				colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
			end
			imgui.Spacing()
		imgui.EndChild()
		imgui.PopFont()
		imgui.SameLine()
		imgui.VerticalSeparator()
		imgui.Spacing()
		if menuSelected == 1 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("LVLsAndNUMBERs", imgui.ImVec2(933, 365), true)
			imgui.PushFont(fontsize25)
				if not process then
					imgui.Spacing()
					if imgui.Button(fa.ICON_FA_TOGGLE_ON .. u8" начать поиск ", imgui.ImVec2(453, 35)) then
						if #nicksandnumbers ~= 0 then
							for i = 1, #nicksandnumbers do
								table.remove(nicksandnumbers, 1)
							end
							findLVLiO = FindPlayer.cfg.findlvlOT
							findLVLiD = FindPlayer.cfg.findlvlDO
							findLvl()
						else
							findLVLiO = FindPlayer.cfg.findlvlOT
							findLVLiD = FindPlayer.cfg.findlvlDO
							findLvl()
						end
					end
					imgui.SameLine()
					local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
					imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.PopFont()
					imgui.PushFont(fontsize25)
						imgui.Button(fa.ICON_FA_POWER_OFF .. u8" остановить поиск ", imgui.ImVec2(453, 35))
					imgui.PopFont()
					imgui.PushFont(fontsize20)
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					if imgui.IsItemHovered() then
						if theme == 1 then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
						elseif theme == 2 then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
						end
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(260)
						imgui.TextUnformatted(u8"Поиск игроков неактивен")
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
						imgui.PopStyleColor()
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
			imgui.PopFont()
			imgui.PushFont(fontsize20)
					if #nicksandnumbers ~= 0 then
						if nicksandnumbers[1][2] == "игроки не найдены" then
							imgui.TextColoredRGB("{660000}Игроки с уровнем от " .. d1 .. findLVLiO .. " {660000}до " .. d1 .. findLVLiD .. " {660000}не были найдены на сервере.")
						elseif nicksandnumbers[1][2] == "нет телефонной книжки" then
							imgui.TextColoredRGB("{660000}У вас нет " .. d1 .. "телефонной книжки{660000}, необходимой для работы скрипта, купите её в любом магазине " .. d1 .. "24/7{660000}.")
						else
							local clipper = imgui.ImGuiListClipper(#nicksandnumbers)
							while clipper:Step() do
								for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
									local style = imgui.GetStyle()
									style.FrameRounding = 8
									if theme == 1 then
										if nicksandnumbers[i][2] == "нет сим-карты" or nicksandnumbers[i][2] == "не в сети" then
											imgui.TextColoredRGB("{000000}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, номер телефона - {660000}" .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										else
											imgui.TextColoredRGB("{000000}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, номер телефона - " .. d1 .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" позвонить##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "Запрещено использовать, когда {FFFFFF}активен {FFFF00}поиск людей!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "Процесс {FFFFFF}авто-звонка {FFFF00}уже выполняется, подождите немного!", main_color)
														else
															nick_x = nicksandnumbers[i][1]
															number_x = nicksandnumbers[i][2]
															lvl_x = nicksandnumbers[i][4]
															waitCalling = true
															sampSendChat("/call " .. nicksandnumbers[i][2])
														end
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_COPY .. u8"##" .. i, imgui.ImVec2(30, 23)) then
													setClipboardText(nicksandnumbers[i][2])
													sampAddChatMessage(tag .. color_text .. "Вы успешно скопировали номер {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} в буфер обмена", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									elseif theme == 2 then
										if nicksandnumbers[i][2] == "нет сим-карты" or nicksandnumbers[i][2] == "не в сети" then
											imgui.TextColoredRGB("{FFFFFF}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, номер телефона - {660000}" .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										else
											imgui.TextColoredRGB("{FFFFFF}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, номер телефона - " .. d1 .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" позвонить##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "Запрещено использовать, когда {FFFFFF}активен {FFFF00}поиск людей!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "Процесс {FFFFFF}звонка {FFFF00}уже выполняется, подождите немного!", main_color)
														else
															nick_x = nicksandnumbers[i][1]
															number_x = nicksandnumbers[i][2]
															lvl_x = nicksandnumbers[i][4]
															waitCalling = true
															sampSendChat("/call " .. nicksandnumbers[i][2])
														end
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_COPY .. u8"##" .. i, imgui.ImVec2(30, 23)) then
													setClipboardText(nicksandnumbers[i][2])
													sampAddChatMessage(tag .. color_text .. "Вы успешно скопировали номер {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} в буфер обмена", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									end
									style.FrameRounding = 12.0
								end
							end
							if not process then
								imgui.TextColoredRGB("{009900}Поиск был завершён. Найдены " .. d1 .. #nicksandnumbers .. " {009900}игрок(а/ов) с уровнем от " .. d1 .. findLVLiO .. "{009900} до " .. d1 .. findLVLiD .. ".")
								imgui.Spacing()
								imgui.Separator()
								imgui.Spacing()
							end
						end
					end
				else
					imgui.Spacing()
					local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
					imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.PopFont()
					imgui.PushFont(fontsize25)
						imgui.Button(fa.ICON_FA_TOGGLE_ON .. u8" начать поиск ", imgui.ImVec2(453, 35))
					imgui.PopFont()
					imgui.PushFont(fontsize20)
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					if imgui.IsItemHovered() then
						if theme == 1 then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
						elseif theme == 2 then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
						end
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(260)
						imgui.TextUnformatted(u8"Поиск игроков уже активен")
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
						imgui.PopStyleColor()
					end
					imgui.SameLine()
					imgui.PopFont()
					imgui.PushFont(fontsize25)
					if imgui.Button(fa.ICON_FA_POWER_OFF .. u8" остановить поиск ", imgui.ImVec2(453, 35)) then
						process = false
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.PopFont()
					imgui.PushFont(fontsize20)
					if #nicksandnumbers ~= 0 then
						if nicksandnumbers[1][2] == "игроки не найдены" then
							imgui.TextColoredRGB("{660000}Игроки с уровнем" .. d1 .. findLVLiO .. " {660000}не были найдены на сервере.")
						else
							local clipper = imgui.ImGuiListClipper(#nicksandnumbers)
							while clipper:Step() do
								for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
									local style = imgui.GetStyle()
									style.FrameRounding = 8
									if theme == 1 then
										if nicksandnumbers[i][2] == "нет сим-карты" or nicksandnumbers[i][2] == "не в сети" then
											imgui.TextColoredRGB("{000000}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, номер телефона - {660000}" .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										else
											imgui.TextColoredRGB("{000000}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, номер телефона - " .. d1 .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" позвонить##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "Запрещено использовать, когда {FFFFFF}активен {FFFF00}поиск людей!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "Процесс {FFFFFF}авто-звонка {FFFF00}уже выполняется, подождите немного!", main_color)
														else
															nick_x = nicksandnumbers[i][1]
															number_x = nicksandnumbers[i][2]
															lvl_x = nicksandnumbers[i][4]
															waitCalling = true
															sampSendChat("/call " .. nicksandnumbers[i][2])
														end
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_COPY .. u8"##" .. i, imgui.ImVec2(30, 23)) then
													setClipboardText(nicksandnumbers[i][2])
													sampAddChatMessage(tag .. color_text .. "Вы успешно скопировали номер {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} в буфер обмена", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									elseif theme == 2 then
										if nicksandnumbers[i][2] == "нет сим-карты" or nicksandnumbers[i][2] == "не в сети" then
											imgui.TextColoredRGB("{FFFFFF}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, номер телефона - {660000}" .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										else
											imgui.TextColoredRGB("{FFFFFF}Никнейм: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], уровень: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, номер телефона - " .. d1 .. nicksandnumbers[i][2])
											imgui.SameLine()
											imgui.PopFont()
											imgui.PushFont(fontsize18)
												local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
												a = file:read("*a")
												file:close()
												local insideTabl = decodeJson(a)
												if #insideTabl["nicks"] ~= 0 then
													local item = 1
													for _, nick in ipairs(insideTabl["nicks"]) do
														if nick == nicksandnumbers[i][1] then
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" не игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																local itemForDelete = 1
																for _, value in ipairs(insideTabl["nicks"]) do
																	if value == nicksandnumbers[i][1] then
																		table.remove(insideTabl["nicks"], itemForDelete)
																	else
																		itemForDelete = itemForDelete + 1
																	end
																end
																encodedTable = encodeJson(insideTabl)
																local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																file:write(encodedTable)
																file:flush()
																file:close()
															end
														else
															item = item + 1
															if item > #insideTabl["nicks"] then
																local pizda = 1
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
																	table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
																	encodedTable = encodeJson(insideTabl)
																	local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
																	file:write(encodedTable)
																	file:flush()
																	file:close()
																end
															end
														end
													end
												else
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" игнорировать##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" позвонить##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "Запрещено использовать, когда {FFFFFF}активен {FFFF00}поиск людей!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "Процесс {FFFFFF}авто-звонка {FFFF00}уже выполняется, подождите немного!", main_color)
														else
															nick_x = nicksandnumbers[i][1]
															number_x = nicksandnumbers[i][2]
															lvl_x = nicksandnumbers[i][4]
															waitCalling = true
															sampSendChat("/call " .. nicksandnumbers[i][2])
														end
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_COPY .. u8"##" .. i, imgui.ImVec2(30, 23)) then
													setClipboardText(nicksandnumbers[i][2])
													sampAddChatMessage(tag .. color_text .. "Вы успешно скопировали номер {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} в буфер обмена", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									end
									style.FrameRounding = 12.0
								end
							end
							if not process then
								imgui.TextColoredRGB("{009900}Поиск был завершён. Найдены " .. d1 .. #nicksandnumbers .. " {009900}человек(а) с уровнем " .. d1 .. findLVLiO .. "{009900}.")
								imgui.Spacing()
								imgui.Separator()
								imgui.Spacing()
							end
						end
					end
				end
				if process then
					local colorxx = nil
					if theme == 1 then colorxx = "{000000}" else colorxx = "{FFFFFF}" end
					imgui.TextColoredRGB(gocheck and "{e28b00}Процесс поиска запущен... Получаем информацию о " .. d1 .. nickse .. colorxx .. "[" .. idforinfo .. "]" or "{e28b00}Процесс поиска запущен...")
					if gocheck then
						imgui.TextColoredRGB("{e28b00}Если скрипт зациклится на одном игроке, просто начните поиск заново")
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
				end
			imgui.PopFont()
			imgui.EndChild()
		end
		if menuSelected == 2 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("HistoryOfCalling", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
				imgui.PushFont(fontsize20)
				imgui.Spacing()
				local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
				a = file:read("*a")
				file:close()
				local insideTabl = decodeJson(a)
				if #insideTabl["hnicks"] ~= 0 then
					for i = 1, #insideTabl["hnicks"] do
						if theme == 1 then
							imgui.TextColoredRGB("{000000}Никнейм: " .. d1 .. insideTabl["hnicks"][i] .. "{000000}, уровень: " .. d1 .. insideTabl["hlvl"][i] .. "{000000}, номер телефона: " .. d1 .. insideTabl["hnumber"][i] .. "{000000}, статус - " .. d1 .. insideTabl["hinfo"][i])
						elseif theme == 2 then
							imgui.TextColoredRGB("{FFFFFF}Никнейм: " .. d1 .. insideTabl["hnicks"][i] .. "{FFFFFF}, уровень: " .. d1 .. insideTabl["hlvl"][i] .. "{FFFFFF}, номер телефона: " .. d1 .. insideTabl["hnumber"][i] .. "{FFFFFF}, статус - " .. d1 .. insideTabl["hinfo"][i])
						end
					end
				else
					imgui.PopFont()
					imgui.PushFont(fontsize25)
					local width = imgui.GetWindowWidth()
					local calc = imgui.CalcTextSize(u8"Здесь будет храниться информация о 20 ваших последних звонках")
					local height = imgui.GetWindowHeight()
					imgui.SetCursorPosX( width / 2 - calc.x / 2 )
					imgui.SetCursorPosY( height / 2 - calc.y / 2 )
					imgui.Text(u8"Здесь будет храниться информация о 20 ваших последних звонках")
				end
				imgui.PopFont()
			imgui.EndChild()
		end
		if menuSelected == 4 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("Params", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
				imgui.PushFont(fontsize20)
					imgui.Text(u8"Введите ниже, какой уровень игрока скрипт должен будет искать.")
					imgui.PushItemWidth(150)
					local style = imgui.GetStyle()
					style.FrameRounding = 8
						imgui.Text(u8"От")
						imgui.SameLine()
						if imgui.InputInt("##4", FindLVLiO, 0, 0) then
							if FindLVLiO.v > 1000 then
								FindLVLiO.v = 1000
							elseif FindLVLiO.v < 1 then
								FindLVLiO.v = 1
							end
							FindLVLiD.v = FindLVLiO.v
							FindPlayer.cfg.findlvlOT = FindLVLiO.v
							FindPlayer.cfg.findlvlDO = FindLVLiD.v
							inicfg.save(FindPlayer, "FindPlayer")
						end
						imgui.SameLine()
						imgui.SetCursorPosY(imgui.GetCursorPosY() - 3.5)
						imgui.Text(u8"до (включительно)")
						imgui.SameLine()
						if imgui.InputInt("##5", FindLVLiD, 0, 0) then
							if FindLVLiD.v > 1000 then
								FindLVLiD.v = 1000
							elseif FindLVLiD.v < FindLVLiO.v then
								FindLVLiD.v = FindLVLiO.v
							end
							FindPlayer.cfg.findlvlDO = FindLVLiD.v
							inicfg.save(FindPlayer, "FindPlayer")
						end
						imgui.Spacing()
						imgui.Separator()
						imgui.Spacing()
						imgui.PopFont()
						imgui.PushFont(fontsize20)
							if imgui.Checkbox(u8"- отправка определённого текста в чат при дозвоне", chkmsg) then
								if chkmsg.v then
									FindPlayer.cfg.check = true
								else
									FindPlayer.cfg.check = false
								end
								inicfg.save(FindPlayer, "FindPlayer")
							end
						imgui.PopFont()
						imgui.PushFont(fontsize25)
						imgui.PopItemWidth()
						imgui.PushItemWidth(915)
						if chkmsg.v then
							if FindPlayer.cfg.messages >= 1 then
								if imgui.InputTextWithHint(u8"##1", u8"Введите сюда какой-то текст", message) then
									if message.v:match("^%s+.+$") then
										local mes = message.v:match("^%s+(.+)$")
										message.v = mes
									end
									if message.v:match("^%s+$") then
										message.v = ""
										FindPlayer.cfg.message = ""
									else
										if #message.v == 0 then
											FindPlayer.cfg.message = ""
										else
											FindPlayer.cfg.message = u8:decode(message.v)
										end
									end
									inicfg.save(FindPlayer, "FindPlayer")
								end
								if #message.v == 0 then
									imgui.PopFont()
									imgui.PushFont(fontsize20)
									if imgui.IsItemHovered() then
										if theme == 1 then
											imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
										elseif theme == 2 then
											imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
										end
										imgui.BeginTooltip()
										imgui.PushTextWrapPos(320)
										imgui.TextUnformatted(u8"Введите сюда сообщение, которое будет ввводиться автоматически при дозвоне")
										imgui.PopTextWrapPos()
										imgui.EndTooltip()
										imgui.PopStyleColor()
									end
									imgui.PopFont()
									imgui.PushFont(fontsize25)
								end
							end
							if FindPlayer.cfg.messages > 1 then
								if imgui.InputTextWithHint(u8"##2", u8"Введите сюда какой-то текст", message2) then
									if message2.v:match("^%s+.+$") then
										local mes2 = message2.v:match("^%s+(.+)$")
										message2.v = mes2
									end
									if message2.v:match("^%s+$") then
										message2.v = ""
										FindPlayer.cfg.message2 = ""
									else
										if #message2.v == 0 then
											FindPlayer.cfg.message2 = ""
										else
											FindPlayer.cfg.message2 = u8:decode(message2.v)
										end
									end
									inicfg.save(FindPlayer, "FindPlayer")
								end
								if #message2.v == 0 then
									imgui.PopFont()
									imgui.PushFont(fontsize20)
									if imgui.IsItemHovered() then
										if theme == 1 then
											imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
										elseif theme == 2 then
											imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
										end
										imgui.BeginTooltip()
										imgui.PushTextWrapPos(320)
										imgui.TextUnformatted(u8"Введите сюда сообщение, которое будет ввводиться автоматически при дозвоне")
										imgui.PopTextWrapPos()
										imgui.EndTooltip()
										imgui.PopStyleColor()
									end
									imgui.PopFont()
									imgui.PushFont(fontsize25)
								end
							end
							if FindPlayer.cfg.messages > 2 then
								if imgui.InputTextWithHint(u8"##3", u8"Введите сюда какой-то текст", message3) then
									if message3.v:match("^%s+.+$") then
										local mes3 = message3.v:match("^%s+(.+)$")
										message3.v = mes3
									end
									if message3.v:match("^%s+$") then
										message3.v = ""
										FindPlayer.cfg.message3 = ""
									else
										if #message3.v == 0 then
											FindPlayer.cfg.message3 = ""
										else
											FindPlayer.cfg.message3 = u8:decode(message3.v)
										end
									end
									inicfg.save(FindPlayer, "FindPlayer")
								end
								if #message3.v == 0 then
									imgui.PopFont()
									imgui.PushFont(fontsize20)
									if imgui.IsItemHovered() then
										if theme == 1 then
											imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
										elseif theme == 2 then
											imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
										end
										imgui.BeginTooltip()
										imgui.PushTextWrapPos(320)
										imgui.TextUnformatted(u8"Введите сюда сообщение, которое будет ввводиться автоматически при дозвоне")
										imgui.PopTextWrapPos()
										imgui.EndTooltip()
										imgui.PopStyleColor()
									end
									imgui.PopFont()
									imgui.PushFont(fontsize25)
								end
							end
							style.FrameRounding = 12.0
							if FindPlayer.cfg.messages > 2 then
								local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
								imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
								imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
								imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
								imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
									imgui.Button(fa.ICON_FA_PLUS_CIRCLE .. u8" отправлять ещё одно сообщение", imgui.ImVec2(453, 35))
								imgui.PopStyleColor()
								imgui.PopStyleColor()
								imgui.PopStyleColor()
								imgui.PopStyleColor()
								if imgui.IsItemHovered() then
									imgui.PopFont()
									imgui.PushFont(fontsize20)
									if theme == 1 then
										imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
									elseif theme == 2 then
										imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
									end
									imgui.BeginTooltip()
									imgui.PushTextWrapPos(325)
									imgui.TextUnformatted(u8"Нельзя отправлять больше трёх сообщений")
									imgui.PopTextWrapPos()
									imgui.EndTooltip()
									imgui.PopStyleColor()
								end
								imgui.PopFont()
								imgui.PushFont(fontsize25)
							else 
								if imgui.Button(fa.ICON_FA_PLUS_CIRCLE .. u8" отправлять ещё одно сообщение", imgui.ImVec2(453, 35)) then
									FindPlayer.cfg.messages = FindPlayer.cfg.messages + 1
									inicfg.save(FindPlayer, "FindPlayer")
								end
							end
							imgui.SameLine()
							if FindPlayer.cfg.messages < 2 then
								local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
								imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
								imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
								imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
								imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
									imgui.Button(fa.ICON_FA_MINUS_CIRCLE .. u8" удалить одно доп. сообщение", imgui.ImVec2(453, 35))
								imgui.PopStyleColor()
								imgui.PopStyleColor()
								imgui.PopStyleColor()
								imgui.PopStyleColor()
								if imgui.IsItemHovered() then
									imgui.PopFont()
									imgui.PushFont(fontsize20)
									if theme == 1 then
										imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
									elseif theme == 2 then
										imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
									end
									imgui.BeginTooltip()
									imgui.PushTextWrapPos(345)
									imgui.TextUnformatted(u8"Нельзя отправлять меньше одного сообщения")
									imgui.PopTextWrapPos()
									imgui.EndTooltip()
									imgui.PopStyleColor()
								end
								imgui.PopFont()
								imgui.PushFont(fontsize25)
							else
								if imgui.Button(fa.ICON_FA_MINUS_CIRCLE .. u8" удалить одно доп. сообщение", imgui.ImVec2(453, 35)) then
									FindPlayer.cfg.messages = FindPlayer.cfg.messages - 1
									inicfg.save(FindPlayer, "FindPlayer")
								end
							end
						end
					if FindPlayer.cfg.messages > 1 then
						style.GrabRounding = 8
						style.FrameRounding = 8.0
						if imgui.SliderFloat(u8"##cooldown", cooldown, 0.5, 5, "%.1f") then
							FindPlayer.cfg.cooldown = cooldown.v * 1000
							inicfg.save(FindPlayer, "FindPlayer")
						end
						imgui.PopFont()
						imgui.PushFont(fontsize20)
						if imgui.IsItemHovered() then
							if theme == 1 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
							elseif theme == 2 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
							end
							imgui.BeginTooltip()
							imgui.PushTextWrapPos(400)
							imgui.TextUnformatted(u8"Данный слайдер отвечает за куллдаун между вводами сообщений во время звонка\n\nКуллдаун отображается в секундах\nПо умолчанию: 1 секунда (рекомендуемое значение)")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
							imgui.PopStyleColor()
						end
						imgui.PopFont()
						imgui.PushFont(fontsize25)
					end
					style.FrameRounding = 12.0
					imgui.PopItemWidth()
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					if imgui.Button(fa.ICON_FA_UNDO .. u8" перезагрузить скрипт", imgui.ImVec2(453, 35)) then
						thisScript():reload()
						setPlayerControl(PlayerPed, true)
					end
					imgui.SameLine()
					if imgui.Button(fa.ICON_FA_POWER_OFF .. u8" выгрузить скрипт", imgui.ImVec2(453, 35)) then
						thisScript():unload()
						setPlayerControl(PlayerPed, true)
					end
					if FindPlayer.cfg.messages ~= 3 then
						imgui.Spacing()
						imgui.Separator()
						imgui.Spacing()
					end
				imgui.PopFont()
			imgui.EndChild()
		end
		if menuSelected == 5 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("Bind", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
				imgui.Spacing()
				imgui.PushFont(fontsize20)
					if imgui.HotKey("##1", activeKeys, tLastKeys, 580) then
						rkeys.unRegisterHotKey(bindKey)
						bindKey = rkeys.registerHotKey(activeKeys.v, 1, true, function() if not loadScr then window.v = not window.v imgui.Process = not imgui.Process end end)
						FindPlayer.cfg.bindKey = encodeJson(activeKeys.v)
						inicfg.save(FindPlayer, "FindPlayer")
					end
					imgui.SameLine()
					imgui.Text(u8"- клавиша, отвечающая за активацию окна")
					local style = imgui.GetStyle()
					style.ItemSpacing = imgui.ImVec2(0, 6.5)
					imgui.PushFont(fontsize23)
						imgui.Text("/")
					imgui.PopFont()
					imgui.SameLine()
					imgui.PushItemWidth(572)
						if imgui.InputTextWithHint(u8"##cmd", u8"Введите команду без '/'. Например: findp", command) then
							if #command.v == 0 then
								command.v = activeCmd
							else
								command.v = command.v:gsub(' ', '')
								sampUnregisterChatCommand(cmd)
								FindPlayer.cfg.command = u8:decode(command.v)
								inicfg.save(FindPlayer, "FindPlayer")
								cmd = FindPlayer.cfg.command
								activeCmd = cmd
								sampRegisterChatCommand(cmd, activation)
							end
						end
						if #command.v == 0 then
							if imgui.IsItemHovered() then
								if theme == 1 then
									imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
								elseif theme == 2 then
									imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
								end
								imgui.BeginTooltip()
								imgui.PushTextWrapPos(400)
								imgui.TextUnformatted(u8"Необходимо ввести команду, которая будет использоваться в дальнейшем для активации окна")
								imgui.PopTextWrapPos()
								imgui.EndTooltip()
								imgui.PopStyleColor()
							end
						end
					imgui.PopItemWidth()
					style.ItemSpacing = imgui.ImVec2(12.0, 6.5)
					imgui.SameLine(600)
					imgui.Text(u8"- команда, отвечающая за активацию окна")
				imgui.PopFont()
				imgui.PushFont(fontsize25)
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
					if imgui.Button(fa.ICON_FA_EJECT .. u8" сбросить команду отвечающую за активацию окна до состояния по умолчанию", imgui.ImVec2(918, 35)) then
						if cmd ~= "findplayers" then
							local lastCmd = cmd
							sampUnregisterChatCommand(cmd)
							FindPlayer.cfg.command = "findplayers"
							inicfg.save(FindPlayer, "FindPlayer")
							cmd = FindPlayer.cfg.command
							command.v = cmd
							sampRegisterChatCommand(cmd, activation)
							sampAddChatMessage(tag .. color_text .. "Команда \"{FFFFFF}/" .. lastCmd .. "{FFFF00}\", отвечающая за активацию окна была изменена на \"{FFFFFF}/" .. cmd .. "{FFFF00}\"", main_color)
						else
							sampAddChatMessage(tag .. color_text .. "Команда, отвечающая за активацию окна {FFFFFF}не была изменена{FFFF00}, так как она и так является командой по умолчанию.", main_color)
						end
					end
				imgui.PopFont()
				imgui.Spacing()
				imgui.Separator()
			imgui.EndChild()
		end
		if menuSelected == 6 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("IgnoreNicks", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
			imgui.Spacing()
				imgui.PushFont(fontsize20)
					imgui.PushItemWidth(400)
					if imgui.InputTextWithHint(u8"никнейм", u8"Например: Sam_Mason", nickIgnore) then
						nickIgnore.v = nickIgnore.v:gsub(' ', '')
					end
					imgui.PopItemWidth()
					imgui.SameLine(480)
					imgui.TextQuestion(u8"Данная функция отвечает за игнорирование никнеймов...\nСкрипт будет игнорировать никнеймы игроков при поиске,\nдаже если их уровень и уровень который нужно найти будут идентичны")
					imgui.SameLine()
					imgui.TextDisabled(u8"- наведи курсор на вопросик")
				imgui.PopFont()
				imgui.PushFont(fontsize25)
					if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" добавить никнейм в игнорирование", imgui.ImVec2(453, 35)) then
						if #nickIgnore.v == 0 then
							sampAddChatMessage(tag .. color_text .. "Поле для ввода {FFFFFF}пустое", main_color)
						else
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							a = file:read("*a")
							file:close()
							local insideTabl = decodeJson(a)
							if #insideTabl["nicks"] ~= 0 then
								local i = 1
								for _,v in ipairs(insideTabl["nicks"]) do
									if u8:decode(nickIgnore.v) == v then
										sampAddChatMessage(tag .. color_text .. "Такой никнейм уже присутствует в {FFFFFF}игнорировании", main_color)
										break
									else
										i = i + 1
										if i > #insideTabl["nicks"] then
											sampAddChatMessage(tag .. color_text .. "Никнейм {FFFFFF}успешно{FFFF00} добавлен в {FFFFFF}игнорирование", main_color)
											table.insert(insideTabl["nicks"], u8:decode(nickIgnore.v))
											encodedTable = encodeJson(insideTabl)
											local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
											file:write(encodedTable)
											file:flush()
											file:close()
											break
										end
									end
								end
							else
								sampAddChatMessage(tag .. color_text .. "Никнейм {FFFFFF}успешно{FFFF00} добавлен в{FFFFFF} игнорирование", main_color)
								table.insert(insideTabl["nicks"], u8:decode(nickIgnore.v))
								encodedTable = encodeJson(insideTabl)
								local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
								file:write(encodedTable)
								file:flush()
								file:close()
							end
						end
					end
					imgui.SameLine()
					if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" удалить никнейм из игнорирования", imgui.ImVec2(453, 35)) then
						if #nickIgnore.v == 0 then
							sampAddChatMessage(tag .. color_text .. "Поле для ввода {FFFFFF}пустое", main_color)
						else
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							a = file:read("*a")
							file:close()
							local i = 1
							local insideTabl = decodeJson(a)
							for _, v in ipairs(insideTabl["nicks"]) do
								if u8:decode(nickIgnore.v) == v then
									table.remove(insideTabl["nicks"], i)
									linkDeleted = true
									sampAddChatMessage(tag .. color_text .. "Никнейм {FFFFFF}успешно {FFFF00}удалён:", main_color)
									sampAddChatMessage(tag .. "{FFFFFF}" .. v, main_color)
									break
								else
									i = i + 1
								end
							end
							if not linkDeleted then
								sampAddChatMessage(tag .. color_text .. "Данный никнейм {FFFFFF}не найден{FFFF00} в {FFFFFF}игнорировании", main_color)
							else
								linkDeleted = false
							end
							encodedTable = encodeJson(insideTabl)
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
							file:write(encodedTable)
							file:flush()
							file:close()
						end
					end
					local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
					insideTabl = file:read("*a")
					file:close()
					local massivewithnicks = decodeJson(insideTabl)
					if #massivewithnicks["nicks"] == 0 then
						local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
						imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
						imgui.PopFont()
						imgui.PushFont(fontsize25)
							imgui.Button(fa.ICON_FA_EYE .. u8" посмотреть все никнеймы в игнорировании", imgui.ImVec2(918, 35))
						imgui.PopFont()
						imgui.PushFont(fontsize20)
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						if imgui.IsItemHovered() then
							if theme == 1 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
							elseif theme == 2 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
							end
							imgui.BeginTooltip()
							imgui.PushTextWrapPos(325)
							imgui.TextUnformatted(u8"В игнорировании нет ни одного никнейма")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
							imgui.PopStyleColor()
						end
					else
						if imgui.Button(fa.ICON_FA_EYE .. u8" посмотреть все никнеймы в игнорировании", imgui.ImVec2(918, 35)) then
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							local a = file:read("*a")
							file:close()
							sampAddChatMessage(tag .. color_text .. "Ниже в ряд будут {FFFFFF}показаны{FFFF00} все никнеймы, которые находятся в {FFFFFF}игнорировании", main_color)
							local allnicks = decodeJson(a)
							for _, v in ipairs(allnicks["nicks"]) do
								sampAddChatMessage(tag .. "{FFFFFF}" .. v, main_color)
							end
							sampAddChatMessage(tag .. color_text .. "Сейчас в {FFFFFF}игнорировании {FFFF00}находится {FFFFFF}" .. #allnicks["nicks"] .. " {FFFF00}никнеймов", main_color)
						end
					end
					if #massivewithnicks["nicks"] == 0 then
						local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
						imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
						imgui.PopFont()
						imgui.PushFont(fontsize25)
							imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" удалить все никнеймы из игнорирования", imgui.ImVec2(918, 35))
						imgui.PopFont()
						imgui.PushFont(fontsize20)
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						if imgui.IsItemHovered() then
							if theme == 1 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
							elseif theme == 2 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
							end
							imgui.BeginTooltip()
							imgui.PushTextWrapPos(325)
							imgui.TextUnformatted(u8"В игнорировании нет ни одного никнейма")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
							imgui.PopStyleColor()
						end
					else
						if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" удалить все никнеймы из игнорирования", imgui.ImVec2(918, 35)) then
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							a = file:read("*a")
							file:close()
							local insideTabl = decodeJson(a)
							if #insideTabl["nicks"] ~= 0 then
								local count = #insideTabl["nicks"]
								for i = 1, count do
									table.remove(insideTabl["nicks"], 1)
								end
								sampAddChatMessage(tag .. color_text .. "Все никнеймы из {FFFFFF}игнорирования {FFFF00}были{FFFFFF} успешно {FFFF00}удалены", main_color)
								encodedTable = encodeJson(insideTabl)
								local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
								file:write(encodedTable)
								file:flush()
								file:close()
							else
								sampAddChatMessage(tag .. color_text .. "В {FFFFFF}игнорировании {FFFF00}нет ни одного никнейма", main_color)
							end
						end
						imgui.PopFont()
						imgui.PushFont(fontsize20)
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					local style = imgui.GetStyle()
					style.FrameRounding = 8
					if imgui.Checkbox(u8"- Игнорировать игроков без сим-карт (наведи курсор на текст, для более точной информации)", ignore) then
						if ignore.v then
							FindPlayer.cfg.ignore = true
						else
							FindPlayer.cfg.ignore = false
						end
						inicfg.save(FindPlayer, "FindPlayer")
					end
					if imgui.IsItemHovered() then
						if theme == 1 then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
						elseif theme == 2 then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
						end
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(325)
						imgui.TextUnformatted(u8"Время поиска от этой настройки не изменится. Скрипт также будет находить игроков без сим-карт, но такие игроки не будут показываться в окне")
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
						imgui.PopStyleColor()
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					style.FrameRounding = 12.0
				imgui.PopFont()
			imgui.EndChild()
		end
		if menuSelected == 7 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("Customization", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
			imgui.Spacing()
				imgui.PushFont(fontsize20)
					imgui.PushItemWidth(400)
					local style = imgui.GetStyle()
					local colors = style.Colors
					local clr = imgui.Col
					local ImVec4 = imgui.ImVec4
					if theme == 1 then
						imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.08, 0.08, 0.08, 1))
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.2, 0.2, 0.2, 1))
					elseif theme == 2 then
						imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(1, 1, 1, 1))
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.8, 0.8, 0.8, 1))
					end
					if imgui.ColorEdit3("##1337", color, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoTooltip + imgui.ColorEditFlags.PickerHueWheel) then
						local clr = join_argb(0, color.v[1] * 255, color.v[2] * 255, color.v[3] * 255)
						a1 = string.format('%.2f', color.v[1])
						b1 = string.format('%.2f', color.v[2])
						c1 = string.format('%.2f', color.v[3])
						d1 = ('%06X'):format(clr)
						d1 = "{" .. d1 .. "}"
						changeColor = true
						rgb_style = false
						local style = imgui.GetStyle()
						local colors = style.Colors
						local clr = imgui.Col
						local ImVec4 = imgui.ImVec4
						colors[clr.CheckMark] = ImVec4(a1, b1, c1, 0.97)
					end
					imgui.PopItemWidth()
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.PopStyleColor()
					imgui.SameLine()
					imgui.Text(u8"-  Изменить цвет стиля")
				imgui.PopFont()
				imgui.PushFont(fontsize25)
					if imgui.Button(fa.ICON_FA_SAVE .. u8" сохранить новый стиль в конфиг", imgui.ImVec2(918, 35)) then
						if changeColor then
							if rgb_style then
								sampAddChatMessage(tag .. color_text .. "Новый {ff4c5b}R{99ff99}G{00ffff}B{FFFFFF} СТИЛЬ {FFFF00}успешно {FFFFFF}сохранен {FFFF00}в конфиг", main_color)
								FindPlayer.cfg.rgb_style = true
								inicfg.save(FindPlayer, "FindPlayer")
							else
								sampAddChatMessage(tag .. color_text .. "Новый " .. d1 .. "СТИЛЬ {FFFF00}успешно {FFFFFF}сохранен {FFFF00}в конфиг", main_color)
								FindPlayer.cfg.color1 = a1
								FindPlayer.cfg.color2 = b1
								FindPlayer.cfg.color3 = c1
								inicfg.save(FindPlayer, "FindPlayer")
							end
						else
							sampAddChatMessage(tag .. color_text .. "Сначала необходимо {FFFFFF}изменить {FFFF00}цвет", main_color)
						end
					end
					if imgui.Button(fa.ICON_FA_EJECT .. u8" сбросить до стиля по умолчанию", imgui.ImVec2(918, 35)) then
						sampAddChatMessage(tag .. color_text .. "Стиль сброшен до состояния по умолчанию и{FFFF00} успешно {FFFFFF}сохранен {FFFF00}в конфиг", main_color)
						FindPlayer.cfg.color1 = 0.00
						FindPlayer.cfg.color2 = 0.49
						FindPlayer.cfg.color3 = 1.00
						rgb_style = false
						FindPlayer.cfg.rgb_style = false
						a1 = 0.00
						b1 = 0.49
						c1 = 1.00
						local clr = join_argb(0, a1 * 255, b1 * 255, c1 * 255)
						d1 = ('%06X'):format(clr)
						d1 = "{" .. d1 .. "}"
						color = imgui.ImFloat3(a1, b1, c1)
						inicfg.save(FindPlayer, "FindPlayer")
					end
					if not rgb_style then
						local r,g,b,a = rainbow(rgb_speed, 255, 0)
						local argb = join_argb(a, r, g, b)
						local a = a / 255
						local r = r / 255
						local g = g / 255
						local b = b / 255
						if imgui.CustomButton(fa.ICON_FA_PAINT_ROLLER .. u8" RGB стиль", imgui.ImVec4(r, g, b, 0.95),  imgui.ImVec4(r, g, b, 1.00), imgui.ImVec4(r, g, b, 0.8), imgui.ImVec2(918, 35)) then
							sampAddChatMessage(tag .. color_text .. "{ff4c5b}R{99ff99}G{00ffff}B{FFFFFF} стиль {FFFF00}успешно {FFFFFF}применен{FFFF00}, но НЕ сохранен в конфиг", main_color)
							rgb_style = true
							changeColor = true
						end
					else
						local r,g,b,a = rainbow(rgb_speed, 255, 0)
						local argb = join_argb(a, r, g, b)
						local a = a / 255
						local r = r / 255
						local g = g / 255
						local b = b / 255
						imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
						imgui.PopFont()
						imgui.PushFont(fontsize25)
							imgui.CustomButton(fa.ICON_FA_PAINT_ROLLER .. u8" RGB стиль", imgui.ImVec4(r, g, b, 0.3),  imgui.ImVec4(r, g, b, 0.3), imgui.ImVec4(r, g, b, 0.3), imgui.ImVec2(918, 35))
						imgui.PopFont()
						imgui.PushFont(fontsize20)
						imgui.PopStyleColor()
						if imgui.IsItemHovered() then
							if theme == 1 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
								imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0, 0, 0, 0.84))
							elseif theme == 2 then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
								imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(1, 1, 1, 0.84))
							end
							imgui.BeginTooltip()
							imgui.PushTextWrapPos(325)
							imgui.TextUnformatted(u8"RGB стиль уже активирован")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
							imgui.PopStyleColor()
							imgui.PopStyleColor()
						end
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
				imgui.PopFont()
			imgui.EndChild()
		end
		if menuSelected == 8 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("UpdateMN", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
				imgui.PushFont(fontsize25)
				imgui.Spacing()
					if imgui.Button(fa.ICON_FA_CLOUD_UPLOAD_ALT .. u8" проверить наличие обновлений", imgui.ImVec2(918, 35)) then
						if not checkupd then
							sampAddChatMessage(tag .. color_text .. "{FFFFFF}Проверяем {FFFF00}наличие обновлений...", main_color)
							downloadUrlToFile(update_url, update_path, function(id, status)
								if status == dlstatus.STATUS_ENDDOWNLOADDATA then
									checkupd = true
									updateIni = inicfg.load(nil, update_path)
									if updateIni ~= nil then
										if tonumber(updateIni.info.vers) > script_vers then
											sampAddChatMessage(tag .. color_text .. "Найдено {FFFFFF}обновление{FFFF00}! Новая версия: {FFFFFF}" .. updateIni.info.vers_text .."{FFFF00}. Текущая версия: {FFFFFF}".. script_vers_text .. "{FFFF00}.", main_color)
											sampAddChatMessage(tag .. color_text .. "Чтобы {FFFFFF}установить{FFFF00} обновление, необходимо перейти в раздел {FFFFFF}\"обновления\"{FFFF00} в меню скрипта", main_color)
											mbobnova = true
											checkupd = false
										else
											checkupd = false
											sampAddChatMessage(tag .. color_text .. "Обновлений {FFFFFF}не найдено{FFFF00}.", main_color)
										end
										os.remove(update_path)
										checkupd = false
									else
										os.remove(update_path)
										checkupd = false
										sampAddChatMessage(tag .. color_text .. "Произошла какая-то {FFFFFF}ошибка{FFFF00}! Не удалось проверить наличие обновлений... Попробуйте ещё раз.", main_color)
									end
								end
							end)
						else
							sampAddChatMessage(tag .. color_text .. "Повторите проверку на наличие обновлений чуть {FFFFFF}позже{FFFF00}! Сейчас уже проходит данная проверка.", main_color)
						end
					end
					if mbobnova then
						if imgui.Button(fa.ICON_FA_DOWNLOAD .. u8" обновить", imgui.ImVec2(918, 35)) then
							if mbobnova then
								sampAddChatMessage(tag .. color_text .. "Начинается {FFFFFF}установка {FFFF00}найденного обновления", main_color)
								window.v = not window.v
								imgui.Process = window.v
								obnova = true
							end
						end
						if imgui.Button(fa.ICON_FA_BOOK .. u8" список изменений", imgui.ImVec2(918, 35)) then
							downloadUrlToFile(update_url, update_path, function(id, status)
								if status == dlstatus.STATUS_ENDDOWNLOADDATA then
									updateIni = inicfg.load(nil, update_path)
									if updateIni ~= nil then
										sampShowDialog(1337, "{FFFF00}Список изменений", u8:decode(updateIni.info.changelog):gsub("\\([n])", {n="\n"}), "{ff0000}Закрыть", nil, DIALOG_STYLE_MSGBOX)
										window.v = false
										windowActive = true
									else
										sampAddChatMessage(tag .. color_text .. "Произошла {FFFFFF}ошибка{FFFF00}, попробуйте ещё раз", main_color)
									end
								end
							end)
						end
					else
						local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
						imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
							imgui.Button(fa.ICON_FA_DOWNLOAD .. u8" обновить", imgui.ImVec2(918, 35))
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
					end
					if imgui.Button(fa.ICON_FA_HISTORY .. u8" история обновлений", imgui.ImVec2(918, 35)) then
						sampShowDialog(1337, "{FFFF00}История обновлений скрипта {FFFFFF}FindPlayers", "{FFFF00}Версия {FFFFFF}1.0 {808080}(дата выхода: {a5a5a5}28.10.21{808080}){FFFF00}:\n{FFFFFF}- Релиз\n{FFFF00}Версия {FFFFFF}1.1 {808080}(дата выхода: {a5a5a5}28.10.21{808080}){FFFF00}:\n{FFFFFF}- Исправлены некоторые ошибки\n{FFFF00}Версия {FFFFFF}1.2 {808080}(дата выхода: {a5a5a5}31.10.21{808080}){FFFF00}:\n{FFFFFF}- Исправлено много ошибок\n{FFFFFF}- Предусмотрен и заранее исправлен возможный баг\n{FFFFFF}- Добавлена поддержка двухзначных и трёхзначных номеров\n{FFFF00}Версия {FFFFFF}1.3 {808080}(дата выхода: {a5a5a5}18.11.22{808080}){FFFF00}:\n{FFFFFF}- Исправлена работа биндов\n- Система авто-звонков адаптирована под новый интерфейс телефона\n- Добавлена история звонков\n- Теперь можно искать игроков в уровневом диапазоне\n- Добавлена кнопка копирования номера в раздел поиска игроков\n- Немного изменен дизайн\n- Улучшена оптимизация", "{ff0000}Закрыть", nil, DIALOG_STYLE_MSGBOX)
						window.v = false
						windowActive = true
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
				imgui.PopFont()
			imgui.EndChild()
		end
		if menuSelected == 9 then
			imgui.SameLine()
			imgui.Spacing()
			imgui.SameLine()
			imgui.BeginChild("InfoOfScript", imgui.ImVec2(933, 365), true, imgui.WindowFlags.NoScrollbar)
				imgui.PushFont(fontsize20)
					if theme == 1 then
						if page == 1 then
							imgui.TextColoredRGB("" .. d1 .. "Скрипт {000000}FindPlayers " .. d1 .. "был создан для удобного поиска людей с определённым уровнем по всему серверу. Как только скрипт\n" .. d1 .. "находит человека с нужным уровнем, он автоматически получает его {000000}айди" .. d1 .. ", {000000}ник-нейм" .. d1 .. ", а также {000000}номер телефона" .. d1 .. ", а затем\n" .. d1 .. "выводит всю эту информацию в окне. В этом же окне через специальные кнопки можно {000000}звонить игроку " .. d1 .. "(если у него есть \n" .. d1 .. "сим-карта) и {000000}редактировать систему игнорирования никнеймов " .. d1 .. "(по другому - чёрный список для никнеймов)\n" .. d1 .. "Для того, чтобы скрипт начал искать людей по серверу с нужным уровнем, достаточно перейти в раздел {000000}\"поиск людей\"\n" .. d1 .. "и нажать на специальную кнопку. По умолчанию скрипт будет искать лишь людей с {000000}1-ым" .. d1 .. " уровнем, но изменить это\n" .. d1 .. "можно в разделе {000000}\"параметры скрипта\"" .. d1 .. ". Также в этом разделе можно: {000000}настроить отправку сообщения при дозвоне до игрока" .. d1 .. ",\n{000000}перезагрузить скрипт" .. d1 .. " и {000000}выгрузить скрипт полностью" .. d1 .. ". Для того, чтобы изменить {000000}бинд" .. d1 .. ", либо {000000}команду активации окна " .. d1 .. "скрипта,\n" .. d1 .. "достаточно перейти в раздел {000000}\"настройки активации скрипта\"" .. d1 .. ", и уже там настроить всё по своему. В разделе {000000}\"система\nигнорирования никнеймов\"" .. d1 .. " можно: {000000}посмотреть все никнеймы находящиеся в игнорировании" .. d1 .. ", {000000}удалить все никнеймы из\nигнорирования" .. d1 .. ", {000000}добавить никнейм в игнорирование" .. d1 .. " и {000000}удалить никнейм из игнорирования" .. d1 .. ". Данная функция отвечает за\n" .. d1 .. "игорирование определённых игроков при поиске, даже если их уровень соответствует нужному.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_FORWARD .. u8" следующая страница", imgui.ImVec2(205, 25)) then
								page = 2
							end
							local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a) )
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a))
								imgui.Button(" ", imgui.ImVec2(918, 38))
							imgui.PopStyleColor()
							imgui.PopStyleColor()
							imgui.PopStyleColor()
						elseif page == 2 then
							imgui.TextColoredRGB("" .. d1 .. "Если же вам надоела стандартная цветовая схема в скрипте, вы можете перейти в раздел {000000}\"кастомизация интерфейса\"" .. d1 .. ", и уже\n" .. d1 .. "там полностью изменить всю цветовую схему, а также активировать {000000}RGB стиль" .. d1 .. " с переливанием всех цветов. Ну и кончено\n" .. d1 .. "же нельзя забывать о таком разделе, как {000000}\"обновления\"" .. d1 .. ". В этом разделе можно: {000000}проверить наличие обновления" .. d1 .. ", {000000}обновить\nскрипт " .. d1 .. "(если обновление доступно), а также посмотреть {000000}историю всех обновлений этого скрипта" .. d1 .. ".\n" .. d1 .. "Автор скрипта: {000000}https://vk.com/klamet1/" .. d1 .. ". Если вы нашли какой либо {000000}баг" .. d1 .. ", просто хотите выразить {000000}благодарность" .. d1 .. " или заказать\n" .. d1 .. "какой либо {000000}скрипт" .. d1 .. ", вы можете это сделать во {000000}ВКонтакте\n" .. d1 .. "Также автор принимает и {000000}материальную благодарность" .. d1 .. ". Вы можете оформить перевод средств на мой {000000}QIWI кошелек " .. d1 .. "по\nникнейму" .. d1 .. ", мой никнейм в {000000}QIWI" .. d1 .. " кошельке: {000000}KLAMET" .. d1 .. ".\n{000000}Спасибо " .. d1 .. "за использование моего скрипта. {000000}Надеюсь" .. d1 .. ", что он будет приносить лишь пользу.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_BACKWARD .. u8" предыдущая страница", imgui.ImVec2(205, 25)) then
								page = 1
							end
							imgui.PopFont()
							imgui.PushFont(fontsize25)
							imgui.Spacing()
							imgui.Separator()
							imgui.Spacing()
							imgui.Spacing()
							if imgui.Button(fa.ICON_FA_GLOBE .. u8" связаться с автором", imgui.ImVec2(453, 35)) then
								os.execute("start www.vk.com/klamet1")
							end
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_USERS .. u8" тема с этим скриптом на форуме BlastHack", imgui.ImVec2(453, 35)) then
								os.execute("start www.blast.hk")
							end
							imgui.PopFont()
							imgui.PushFont(fontsize20)
							local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a) )
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a))
								imgui.Button(" ", imgui.ImVec2(918, 51))
							imgui.PopStyleColor()
							imgui.PopStyleColor()
							imgui.PopStyleColor()
						end
					elseif theme == 2 then
						if page == 1 then
							imgui.TextColoredRGB("" .. d1 .. "Скрипт {FFFFFF}FindPlayers " .. d1 .. "был создан для удобного поиска людей с определённым уровнем по всему серверу. Как только скрипт\n" .. d1 .. "находит человека с нужным уровнем, он автоматически получает его {FFFFFF}айди" .. d1 .. ", {FFFFFF}ник-нейм" .. d1 .. ", а также {FFFFFF}номер телефона" .. d1 .. ", а затем\n" .. d1 .. "выводит всю эту информацию в окне. В этом же окне через специальные кнопки можно {FFFFFF}звонить игроку " .. d1 .. "(если у него есть \n" .. d1 .. "сим-карта) и {FFFFFF}редактировать систему игнорирования никнеймов " .. d1 .. "(по другому - чёрный список для никнеймов)\n" .. d1 .. "Для того, чтобы скрипт начал искать людей по серверу с нужным уровнем, достаточно перейти в раздел {FFFFFF}\"поиск людей\"\n" .. d1 .. "и нажать на специальную кнопку. По умолчанию скрипт будет искать лишь людей с {FFFFFF}1-ым" .. d1 .. " уровнем, но изменить это\n" .. d1 .. "можно в разделе {FFFFFF}\"параметры скрипта\"" .. d1 .. ". Также в этом разделе можно: {FFFFFF}настроить отправку сообщения при дозвоне до игрока" .. d1 .. ",\n{FFFFFF}перезагрузить скрипт" .. d1 .. " и {FFFFFF}выгрузить скрипт полностью" .. d1 .. ". Для того, чтобы изменить {FFFFFF}бинд" .. d1 .. ", либо {FFFFFF}команду активации окна " .. d1 .. "скрипта,\n" .. d1 .. "достаточно перейти в раздел {FFFFFF}\"настройки активации скрипта\"" .. d1 .. ", и уже там настроить всё по своему. В разделе {FFFFFF}\"система\nигнорирования никнеймов\"" .. d1 .. " можно: {FFFFFF}посмотреть все никнеймы находящиеся в игнорировании" .. d1 .. ", {FFFFFF}удалить все никнеймы из\nигнорирования" .. d1 .. ", {FFFFFF}добавить никнейм в игнорирование" .. d1 .. " и {FFFFFF}удалить никнейм из игнорирования" .. d1 .. ". Данная функция отвечает за\n" .. d1 .. "игнорирование определённых игроков при поиске, даже если их уровень соответствует нужному.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_FORWARD .. u8" следующая страница", imgui.ImVec2(205, 25)) then
								page = 2
							end
							local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a) )
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a))
								imgui.Button(" ", imgui.ImVec2(918, 38))
							imgui.PopStyleColor()
							imgui.PopStyleColor()
							imgui.PopStyleColor()
						elseif page == 2 then
							imgui.TextColoredRGB("" .. d1 .. "Если же вам надоела стандартная цветовая схема в скрипте, вы можете перейти в раздел {FFFFFF}\"кастомизация интерфейса\"" .. d1 .. ", и уже\n" .. d1 .. "там полностью изменить всю цветовую схему, а также активировать {FFFFFF}RGB стиль" .. d1 .. " с переливанием всех цветов. Ну и кончено\n" .. d1 .. "же нельзя забывать о таком разделе, как {FFFFFF}\"обновления\"" .. d1 .. ". В этом разделе можно: {FFFFFF}проверить наличие обновления" .. d1 .. ", {FFFFFF}обновить\nскрипт " .. d1 .. "(если обновление доступно), а также посмотреть {FFFFFF}историю всех обновлений этого скрипта" .. d1 .. ".\n" .. d1 .. "Автор скрипта: {FFFFFF}https://vk.com/klamet1/" .. d1 .. ". Если вы нашли какой либо {FFFFFF}баг" .. d1 .. ", просто хотите выразить {FFFFFF}благодарность" .. d1 .. " или заказать\n" .. d1 .. "какой либо {FFFFFF}скрипт" .. d1 .. ", вы можете это сделать во {FFFFFF}ВКонтакте\n" .. d1 .. "Также автор принимает и {FFFFFF}материальную благодарность" .. d1 .. ". Вы можете оформить перевод средств на мой {FFFFFF}QIWI кошелек " .. d1 .. "по\nникнейму" .. d1 .. ", мой никнейм в {FFFFFF}QIWI" .. d1 .. " кошельке: {FFFFFF}KLAMET" .. d1 .. ".\n{FFFFFF}Спасибо " .. d1 .. "за использование моего скрипта. {FFFFFF}Надеюсь" .. d1 .. ", что он будет приносить лишь пользу.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_BACKWARD .. u8" предыдущая страница", imgui.ImVec2(205, 25)) then
								page = 1
							end
							imgui.PopFont()
							imgui.PushFont(fontsize25)
							imgui.Spacing()
							imgui.Separator()
							imgui.Spacing()
							imgui.Spacing()
							if imgui.Button(fa.ICON_FA_GLOBE .. u8" связаться с автором", imgui.ImVec2(453, 35)) then
								os.execute("start www.vk.com/klamet1")
							end
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_USERS .. u8" тема с этим скриптом на форуме BlastHack", imgui.ImVec2(453, 35)) then
								os.execute("start www.blast.hk/threads/106115/")
							end
							imgui.PopFont()
							imgui.PushFont(fontsize20)
							local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a) )
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a))
								imgui.Button(" ", imgui.ImVec2(918, 51))
							imgui.PopStyleColor()
							imgui.PopStyleColor()
							imgui.PopStyleColor()
						end
					end
				imgui.PopFont()
			imgui.EndChild()
		end
		imgui.End()
	end
end