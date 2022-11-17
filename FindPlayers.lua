-- Author - https://vk.com/klamet1

require "lib.sampfuncs"
require "lib.moonloader"

script_name("FindPlayers")
script_author("�����")
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
		sampShowDialog(1338, "{FFFF00}���� ������� {FFFFFF}FindPlayers", "{FFFF00}������ ��� {FFFFFF}������� {FFFF00}�� �����-�� �������...\n��������, ������ ��� {FFFFFF}������������{FFFF00}, ��� ����� ��������������� ��������� ������� ����\n\n���� �� ������ �� ��� ������������, ����������, ���������� ����: {FFFFFF}https://vk.com/klamet1/\n�� �������� �������{FFFF00}, ����� ���� ���� ��������� �������� ����� {FFFFFF}������{FFFF00} �������.\n\n\n{ffff00}� ���������... ������� �� ������������ � ���������, {FFFFFF}����� {FFFF00}��� � ������.\n{ff0033}������� ����� ������ �� ��������, ��������� �������������� ������ ����������� CTRL + R\n��������� �������������� ��� ���� ���������� �� ��������� � ��������� �� ����� �� ����������, ���� ������ �� ����������\n{FFFF00}�� ��� ������ ��������� {FFFFFF}����� {FFFF00}�� ������ :)\n���� {00FF00}�{FFFF00}���� � ��������, {FFFFFF}���", "{ff0000}����� ���", nil, DIALOG_STYLE_MSGBOX)
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
	message = "������, � ��������� ������ \"FindPlayers\" ��������� �����'��. ��� ��������� ����� ���������� �������������!",
	message2 = "��� ��������� ���� ���������� ������ �� �����.",
	message3 = "� ��� �������.",
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

	sampAddChatMessage(tag .. color_text .. "������ ����� � ������. ����� - " .. "{FFFFFF}" ..  "�����" .. color_text .. "! ���� �������: " .. "{FFFFFF}/" .. cmd, main_color)
	
	bindKey = rkeys.registerHotKey(activeKeys.v, 1, true, function() if not loadScr then window.v = not window.v imgui.Process = not imgui.Process else sampAddChatMessage(tag .. color_text .. "�� ������� ������� ���� {FFFFFF}������ ����� ����� {FFFF00}�� ������!", main_color) end end)

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
					sampAddChatMessage(tag .. color_text .. "���� {FFFFFF}����������{FFFF00}! ����� ������: {FFFFFF}" .. updateIni.info.vers_text .."{FFFF00}. ������� ������: {FFFFFF}".. script_vers_text .. "{FFFF00}.", main_color)
					sampAddChatMessage(tag .. color_text .. "����� {FFFFFF}����������{FFFF00} ����������, ���������� ������� � ������ {FFFFFF}\"����������\"{FFFF00} � ���� �������", main_color)
					mbobnova = true
					checkupd = false
				else
					checkupd = false
					sampAddChatMessage(tag .. color_text .. "���������� {FFFFFF}�� �������{FFFF00}.", main_color)
				end
				os.remove(update_path)
				checkupd = false
			else
				os.remove(update_path)
				checkupd = false
				sampAddChatMessage(tag .. color_text .. "��������� �����-�� {FFFFFF}������{FFFF00}! �� ������� ��������� ������� ����������...", main_color)
				sampAddChatMessage(tag .. color_text .. "�� ������ ����������� ��������� ������� ���������� ������, ������� �� ������� \"{FFFFFF}����������{FFFF00}\" � ���� �������", main_color)
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
						sampAddChatMessage(tag .. color_text .. "������: {FFFFFF}Arizona Role Play: " .. k .. "{FFFF00}. ������ {FFFFFF}����� {FFFF00}� ������.", main_color)
					end
					break
				else
					ik = ik + 1
					if ik == 18 then
						for i = 1, 10 do
							sampAddChatMessage(tag .. color_text .. "������ �������� ������ �� �������� {FFFFFF}ARIZONA GAMES{FFFF00}!", main_color)
							print("������ �� ������. ������ �������� ������ �� �������� ARIZONA GAMES!")
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
					sampAddChatMessage(tag .. color_text .. "���������� {FFFFFF}�������{FFFF00} �����������. ����� ������: {FFFFFF}" .. updateIni.info.vers_text, main_color)
					sampAddChatMessage(tag .. color_text .. "{FFFFFF}������{FFFF00} ������� ���������� ����� � ������� {FFFFFF}\"����������\"{FFFF00} � ���� �������", main_color)
					sampAddChatMessage(tag .. color_text .. "������ ��� ������������� {FFFFFF}������� {FFFF00}�� ��������� �� ���������", main_color)
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
		sampAddChatMessage(tag .. color_text .. "������� ���������� {FFFFFF}����� {FFFF00}�� ������!", main_color)
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
							table.insert(nicksandnumbers, {0, "������ �� �������", 0, 0})
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
		if msg:match("^� ��� ��� ���������� ������$") then
			table.insert(nicksandnumbers, {nickse, "��� ���������� ������", id, lvl})
			sended = true
			process = false
			sampAddChatMessage(tag .. color_text .. "� ��� ��� {FFFFFF}���������� ������{FFFF00}, ����������� ��� ������ �������. ������ � � ����� �������� {FFFFFF}24/7", main_color)
			return false
		elseif msg:match("^%[������%] {......}� ����� ������ ��� sim �����!$") then
			if not FindPlayer.cfg.ignore then
				table.insert(nicksandnumbers, {nickse, "��� ���-�����", id, lvl})
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
		elseif msg:match("^%[������%] {......}����� �� � ����!$") then
			table.insert(nicksandnumbers, {nickse, "�� � ����", id, lvl})
			sended = true
			return false
		elseif msg:match("^%[������%] {......}� ��� ��� ������ �������.$") then
			sampAddChatMessage(tag .. color_text .. "����� ������� �� ������ {FFFFFF}�������{FFFF00} �������.", main_color)
		elseif msg:match("^%[����������%] {......}�� ������� ������") then
			process = false
			sampAddChatMessage(tag .. color_text .. "�� �������� �� {FFFFFF}������{FFFF00}. ����� ������� ��� �������� {FFFFFF}��������{FFFF00}.", main_color)
		end
	end
	if waitCalling then
		if msg:match("^%[����������%] {FFFFFF}���������� ���� ������$") then
			local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
			local a = file:read("*a")
			file:close()
			local json = decodeJson(a)
			if #json["hnicks"] == 0 then
				table.insert(json["hnicks"], nick_x)
				table.insert(json["hlvl"], lvl_x)
				table.insert(json["hnumber"], number_x)
				table.insert(json["hinfo"], "{009900}����� ��������")
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
							json["hinfo"][i] = "{009900}����� ��������"
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
							sampAddChatMessage(tag .. color_text .. "����-��������� ��� ������� ���� ��������, �� �� ���������, ������ ��� ��������� {FFFFFF}������", main_color)
							sampAddChatMessage(tag .. color_text .. "��������� � ���� �������, � ������� ������� \"{FFFFFF}/" .. cmd .. "{FFFF00}\"", main_color)
							sampAddChatMessage(tag .. color_text .. "��������� �� ������� \"{FFFFFF}��������� �������{FFFF00}\" � ������� ������ ����� � ����(��/��) ���(�/�).", main_color)

						else
							sampAddChatMessage(tag .. color_text .. "����-��������� ��� ������� ���� ��������, �� �� ���������, ������ ��� ��������� {FFFFFF}������", main_color)
							sampAddChatMessage(tag .. color_text .. "��������� � ���� ������� � ������� �������  ������� \"{FFFFFF}/" .. cmd .. "{FFFF00}\"", main_color)
							sampAddChatMessage(tag .. color_text .. "��� � ������� ����� {FFFFFF}" .. ShowHotkey(FindPlayer.cfg.bindKey) .. "{FFFF00}", main_color)
							sampAddChatMessage(tag .. color_text .. "��������� �� ������� \"{FFFFFF}��������� �������{FFFF00}\" � ������� ������ ����� � ����(��/��) ���(�/�).", main_color)
						end
					end
				end
			end
		end
		if msg:match("%[����������%] {......}������ �������! ����� ��������� {......}%d+ ������%.") then
			calling = false
			waitCalling = false
			lua_thread.create(function ()
				while true do
					wait(0)
					sampSendClickTextdraw(65535)
					wait(100)
					sampAddChatMessage(tag .. color_text .. "{FFFF00}������ ��� {FFFFFF}��������{FFFF00}. ����� ���������: {FFFFFF}" .. msg:match("%[����������%] {......}������ �������! ����� ��������� {......}(%d+) ������%.") .. " {FFFF00}������", main_color)
					break
				end
			end)
			return false
		end
		if msg:match("^%[����������%] {FFFFFF}���������� ������� ������$") then
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
				table.insert(json["hinfo"], "{660000}����� �������� (���������)")
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
							json["hinfo"][i] = "{660000}����� �������� (���������)"
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
					sampAddChatMessage(tag .. color_text .. "{FFFFFF}������� {FFFF00}�������� ��� ������.", main_color)
					break
				end
			end)
			return false
		end
		if msg:match("^%[����������%] {......}�� �������� ������$") then
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
				table.insert(json["hinfo"], "{660000}����� �������� (����)")
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
							json["hinfo"][i] = "{660000}����� �������� (����)"
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
		if msg:match("^%[������%] {FFFFFF}���������, ���� �������� ���� ����������� %( 2%-3 ������ %)!$") then
			sampAddChatMessage(tag .. color_text .. "�� ������� ������� {FFFFFF}���������{FFFF00}, ������� ��������� ����������������� � ���������. {FFFFFF}���������{FFFF00}, ���� ��� ��������.", main_color)
			phoneProcess = false
		end
		if msg:match("^� ��� ��� sim �����!$") then
			phoneProcess = false
			waitCalling = false
			sampAddChatMessage(tag .. color_text .. "� ��� �� ����������� {FFFFFF}���-����� {FFFF00}� �������!", main_color)
			return false
		end
		if msg:match("^%[����������%] {......}�� �������� ������$") then
			phoneProcess = false
			waitCalling = false
			calling = false
			sampSendClickTextdraw(65535)
		end
		if msg:match("^%[���������%] {......}������ ��������� ��������������� �����:$") then
			return false
		end
		if msg:match("^{......}1%.{......} 111 %- {......}��������� ������ ��������$") then
			return false
		end
		if msg:match("^{......}2%.{......} 060 %- {......}������ ������� �������$") then
			return false
		end
		if msg:match("^{......}3%.{......} 911 %- {......}����������� �������$") then
			return false
		end
		if msg:match("^{......}4%.{......} 912 %- {......}������ ������$") then
			return false
		end
		if msg:match("^{......}5%.{......} 913 %- {......}�����$") then
			return false
		end
		if msg:match("^{......}6%.{......} 914 %- {......}�������$") then
			return false
		end
		if msg:match("^{......}7%.{......} 8828 %- {......}���������� ������������ �����$") then
			return false
		end
		if msg:match("^{......}8%.{......} 997 %- {......}������ �� �������� ����� ������������ %(������ ��������� ����%)$") then
			return false
		end
	end
end

function sampev.onShowDialog(id, style, title, b1, b2, text)
	print(text)
	if phoneProcess or waitCalling or calling then
		if text == "{B03131}��� ������� ��� ���� �������� ����!\n{FFFFFF}�� ������ �������� ��� ���������, ��� ������ �� �������� � ���� �� ��� ������ ���������." then
			sampAddChatMessage(tag .. color_text .. "� �������� {FFFFFF}�������� {FFFF00}������� (����� �����)!", main_color)
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
				table.insert(json["hinfo"], "{660000}����� �������� (�������� �������)")
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
							json["hinfo"][i] = "{660000}����� �������� (�������� �������)"
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
			sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}��������� {FFFF00}������������, ����� ����� ����� {FFFFFF}�������{FFFF00}!", main_color)
			return false
		end
	end
	if phoneProcess then
		if not cmd:find("/phone") then
			sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}��������� {FFFF00}������������, ����� ����-������ {FFFFFF}�������{FFFF00}!", main_color)
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
			sampAddChatMessage(tag .. color_text .. "��������� {FFFFFF}�������{ffff00}...", main_color)
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
				sampAddChatMessage(tag .. color_text .. "������: {FFFFFF}Arizona Role Play: " .. k .. "{FFFF00}. ������ {FFFFFF}����� {FFFF00}� ������.", main_color)
			end
			break
		else
			ik = ik + 1
			if ik == 18 then
				for i = 1, 10 do
					sampAddChatMessage(tag .. color_text .. "������ �������� ������ �� �������� {FFFFFF}ARIZONA GAMES{FFFF00}!", main_color)
					print("������ �� ������. ������ �������� ������ �� �������� ARIZONA GAMES!")
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
			sampAddChatMessage(tag .. color_text .. "�������� �� ������� ���������, ����� ������� ����-������ {FFFFFF}�������{FFFF00}!", main_color)
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
					imgui.Button(fa.ICON_FA_SEARCH .. u8" ����� �����", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_SEARCH .. u8" ����� �����", imgui.ImVec2(355, 35)) then
					menuSelected = 1
				end
			end
			if menuSelected == 2 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_MOBILE .. u8" ������� �������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_MOBILE .. u8" ������� �������", imgui.ImVec2(355, 35)) then
					menuSelected = 2
				end
			end
			if menuSelected == 4 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_COG .. u8" ��������� �������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_COG .. u8" ��������� �������", imgui.ImVec2(355, 35)) then
					menuSelected = 4
				end
			end
			if menuSelected == 5 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_KEYBOARD .. u8" ��������� ��������� �������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_KEYBOARD .. u8" ��������� ��������� �������", imgui.ImVec2(355, 35)) then
					menuSelected = 5
				end
			end
			if menuSelected == 6 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_BAN .. u8" ������� ������������� �������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_BAN .. u8" ������� ������������� �������", imgui.ImVec2(355, 35)) then
					menuSelected = 6
				end
			end
			if menuSelected == 7 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_PALETTE .. u8" ������������ ����������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_PALETTE .. u8" ������������ ����������", imgui.ImVec2(355, 35)) then
					menuSelected = 7
				end
			end
			if menuSelected == 8 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_FOLDER_PLUS .. u8" ����������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_FOLDER_PLUS .. u8" ����������", imgui.ImVec2(355, 35)) then
					menuSelected = 8
				end
			end
			if menuSelected == 9 then
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
					imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8" ���������� � �������", imgui.ImVec2(355, 35))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			else
				if imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8" ���������� � �������", imgui.ImVec2(355, 35)) then
					menuSelected = 9
				end
			end
			if theme == 1 then
				local style = imgui.GetStyle()
				local colors = style.Colors
				local clr = imgui.Col
				local ImVec4 = imgui.ImVec4
				colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
				if imgui.CustomButton(fa.ICON_FA_BRUSH .. u8" ������� �� ����� ����", imgui.ImVec4(0.00, 0.00, 0.00, 0.95),  imgui.ImVec4(0.00, 0.00, 0.00, 1.00), imgui.ImVec4(0.00, 0.00, 0.00, 0.8), imgui.ImVec2(355, 35))  then
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
				if imgui.CustomButton(fa.ICON_FA_BRUSH .. u8" ������� �� ������� ����", imgui.ImVec4(1.00, 1.00, 1.00, 0.8),  imgui.ImVec4(1.00, 1.00, 1.00, 1.00), imgui.ImVec4(1.00, 1.00, 1.00, 0.40), imgui.ImVec2(355, 35))  then
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
					if imgui.Button(fa.ICON_FA_TOGGLE_ON .. u8" ������ ����� ", imgui.ImVec2(453, 35)) then
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
						imgui.Button(fa.ICON_FA_POWER_OFF .. u8" ���������� ����� ", imgui.ImVec2(453, 35))
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
						imgui.TextUnformatted(u8"����� ������� ���������")
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
						if nicksandnumbers[1][2] == "������ �� �������" then
							imgui.TextColoredRGB("{660000}������ � ������� �� " .. d1 .. findLVLiO .. " {660000}�� " .. d1 .. findLVLiD .. " {660000}�� ���� ������� �� �������.")
						elseif nicksandnumbers[1][2] == "��� ���������� ������" then
							imgui.TextColoredRGB("{660000}� ��� ��� " .. d1 .. "���������� ������{660000}, ����������� ��� ������ �������, ������ � � ����� �������� " .. d1 .. "24/7{660000}.")
						else
							local clipper = imgui.ImGuiListClipper(#nicksandnumbers)
							while clipper:Step() do
								for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
									local style = imgui.GetStyle()
									style.FrameRounding = 8
									if theme == 1 then
										if nicksandnumbers[i][2] == "��� ���-�����" or nicksandnumbers[i][2] == "�� � ����" then
											imgui.TextColoredRGB("{000000}�������: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, ����� �������� - {660000}" .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
											imgui.TextColoredRGB("{000000}�������: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, ����� �������� - " .. d1 .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" ���������##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "��������� ������������, ����� {FFFFFF}������� {FFFF00}����� �����!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}����-������ {FFFF00}��� �����������, ��������� �������!", main_color)
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
													sampAddChatMessage(tag .. color_text .. "�� ������� ����������� ����� {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} � ����� ������", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									elseif theme == 2 then
										if nicksandnumbers[i][2] == "��� ���-�����" or nicksandnumbers[i][2] == "�� � ����" then
											imgui.TextColoredRGB("{FFFFFF}�������: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, ����� �������� - {660000}" .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
											imgui.TextColoredRGB("{FFFFFF}�������: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, ����� �������� - " .. d1 .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" ���������##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "��������� ������������, ����� {FFFFFF}������� {FFFF00}����� �����!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}������ {FFFF00}��� �����������, ��������� �������!", main_color)
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
													sampAddChatMessage(tag .. color_text .. "�� ������� ����������� ����� {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} � ����� ������", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									end
									style.FrameRounding = 12.0
								end
							end
							if not process then
								imgui.TextColoredRGB("{009900}����� ��� ��������. ������� " .. d1 .. #nicksandnumbers .. " {009900}�����(�/��) � ������� �� " .. d1 .. findLVLiO .. "{009900} �� " .. d1 .. findLVLiD .. ".")
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
						imgui.Button(fa.ICON_FA_TOGGLE_ON .. u8" ������ ����� ", imgui.ImVec2(453, 35))
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
						imgui.TextUnformatted(u8"����� ������� ��� �������")
						imgui.PopTextWrapPos()
						imgui.EndTooltip()
						imgui.PopStyleColor()
					end
					imgui.SameLine()
					imgui.PopFont()
					imgui.PushFont(fontsize25)
					if imgui.Button(fa.ICON_FA_POWER_OFF .. u8" ���������� ����� ", imgui.ImVec2(453, 35)) then
						process = false
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					imgui.PopFont()
					imgui.PushFont(fontsize20)
					if #nicksandnumbers ~= 0 then
						if nicksandnumbers[1][2] == "������ �� �������" then
							imgui.TextColoredRGB("{660000}������ � �������" .. d1 .. findLVLiO .. " {660000}�� ���� ������� �� �������.")
						else
							local clipper = imgui.ImGuiListClipper(#nicksandnumbers)
							while clipper:Step() do
								for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
									local style = imgui.GetStyle()
									style.FrameRounding = 8
									if theme == 1 then
										if nicksandnumbers[i][2] == "��� ���-�����" or nicksandnumbers[i][2] == "�� � ����" then
											imgui.TextColoredRGB("{000000}�������: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, ����� �������� - {660000}" .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
											imgui.TextColoredRGB("{000000}�������: " .. d1 .. nicksandnumbers[i][1] .. "{000000}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{000000}, ����� �������� - " .. d1 .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" ���������##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "��������� ������������, ����� {FFFFFF}������� {FFFF00}����� �����!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}����-������ {FFFF00}��� �����������, ��������� �������!", main_color)
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
													sampAddChatMessage(tag .. color_text .. "�� ������� ����������� ����� {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} � ����� ������", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									elseif theme == 2 then
										if nicksandnumbers[i][2] == "��� ���-�����" or nicksandnumbers[i][2] == "�� � ����" then
											imgui.TextColoredRGB("{FFFFFF}�������: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, ����� �������� - {660000}" .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
											imgui.TextColoredRGB("{FFFFFF}�������: " .. d1 .. nicksandnumbers[i][1] .. "{FFFFFF}[" .. nicksandnumbers[i][3] .. "], �������: " .. d1 .. nicksandnumbers[i][4] .. "{FFFFFF}, ����� �������� - " .. d1 .. nicksandnumbers[i][2])
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
															if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" �� ������������##" .. i, imgui.ImVec2(140, 23)) then
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
																if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
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
													if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" ������������##" .. i, imgui.ImVec2(140, 23)) then
														table.insert(insideTabl["nicks"], u8:decode(nicksandnumbers[i][1]))
														encodedTable = encodeJson(insideTabl)
														local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
														file:write(encodedTable)
														file:flush()
														file:close()
													end
												end
												imgui.SameLine()
												if imgui.Button(fa.ICON_FA_PHONE .. u8" ���������##" .. i, imgui.ImVec2(100, 23)) then
													if process then
														sampAddChatMessage(tag .. color_text .. "��������� ������������, ����� {FFFFFF}������� {FFFF00}����� �����!", main_color)
													else
														if phoneProcess then
															sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}����-������ {FFFF00}��� �����������, ��������� �������!", main_color)
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
													sampAddChatMessage(tag .. color_text .. "�� ������� ����������� ����� {FFFFFF}" .. nicksandnumbers[i][2] .. "{FFFF00} � ����� ������", main_color)
												end
											imgui.PopFont()
											imgui.PushFont(fontsize20)
										end
									end
									style.FrameRounding = 12.0
								end
							end
							if not process then
								imgui.TextColoredRGB("{009900}����� ��� ��������. ������� " .. d1 .. #nicksandnumbers .. " {009900}�������(�) � ������� " .. d1 .. findLVLiO .. "{009900}.")
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
					imgui.TextColoredRGB(gocheck and "{e28b00}������� ������ �������... �������� ���������� � " .. d1 .. nickse .. colorxx .. "[" .. idforinfo .. "]" or "{e28b00}������� ������ �������...")
					if gocheck then
						imgui.TextColoredRGB("{e28b00}���� ������ ���������� �� ����� ������, ������ ������� ����� ������")
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
							imgui.TextColoredRGB("{000000}�������: " .. d1 .. insideTabl["hnicks"][i] .. "{000000}, �������: " .. d1 .. insideTabl["hlvl"][i] .. "{000000}, ����� ��������: " .. d1 .. insideTabl["hnumber"][i] .. "{000000}, ������ - " .. d1 .. insideTabl["hinfo"][i])
						elseif theme == 2 then
							imgui.TextColoredRGB("{FFFFFF}�������: " .. d1 .. insideTabl["hnicks"][i] .. "{FFFFFF}, �������: " .. d1 .. insideTabl["hlvl"][i] .. "{FFFFFF}, ����� ��������: " .. d1 .. insideTabl["hnumber"][i] .. "{FFFFFF}, ������ - " .. d1 .. insideTabl["hinfo"][i])
						end
					end
				else
					imgui.PopFont()
					imgui.PushFont(fontsize25)
					local width = imgui.GetWindowWidth()
					local calc = imgui.CalcTextSize(u8"����� ����� ��������� ���������� � 20 ����� ��������� �������")
					local height = imgui.GetWindowHeight()
					imgui.SetCursorPosX( width / 2 - calc.x / 2 )
					imgui.SetCursorPosY( height / 2 - calc.y / 2 )
					imgui.Text(u8"����� ����� ��������� ���������� � 20 ����� ��������� �������")
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
					imgui.Text(u8"������� ����, ����� ������� ������ ������ ������ ����� ������.")
					imgui.PushItemWidth(150)
					local style = imgui.GetStyle()
					style.FrameRounding = 8
						imgui.Text(u8"��")
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
						imgui.Text(u8"�� (������������)")
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
							if imgui.Checkbox(u8"- �������� ������������ ������ � ��� ��� �������", chkmsg) then
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
								if imgui.InputTextWithHint(u8"##1", u8"������� ���� �����-�� �����", message) then
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
										imgui.TextUnformatted(u8"������� ���� ���������, ������� ����� ���������� ������������� ��� �������")
										imgui.PopTextWrapPos()
										imgui.EndTooltip()
										imgui.PopStyleColor()
									end
									imgui.PopFont()
									imgui.PushFont(fontsize25)
								end
							end
							if FindPlayer.cfg.messages > 1 then
								if imgui.InputTextWithHint(u8"##2", u8"������� ���� �����-�� �����", message2) then
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
										imgui.TextUnformatted(u8"������� ���� ���������, ������� ����� ���������� ������������� ��� �������")
										imgui.PopTextWrapPos()
										imgui.EndTooltip()
										imgui.PopStyleColor()
									end
									imgui.PopFont()
									imgui.PushFont(fontsize25)
								end
							end
							if FindPlayer.cfg.messages > 2 then
								if imgui.InputTextWithHint(u8"##3", u8"������� ���� �����-�� �����", message3) then
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
										imgui.TextUnformatted(u8"������� ���� ���������, ������� ����� ���������� ������������� ��� �������")
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
									imgui.Button(fa.ICON_FA_PLUS_CIRCLE .. u8" ���������� ��� ���� ���������", imgui.ImVec2(453, 35))
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
									imgui.TextUnformatted(u8"������ ���������� ������ ��� ���������")
									imgui.PopTextWrapPos()
									imgui.EndTooltip()
									imgui.PopStyleColor()
								end
								imgui.PopFont()
								imgui.PushFont(fontsize25)
							else 
								if imgui.Button(fa.ICON_FA_PLUS_CIRCLE .. u8" ���������� ��� ���� ���������", imgui.ImVec2(453, 35)) then
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
									imgui.Button(fa.ICON_FA_MINUS_CIRCLE .. u8" ������� ���� ���. ���������", imgui.ImVec2(453, 35))
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
									imgui.TextUnformatted(u8"������ ���������� ������ ������ ���������")
									imgui.PopTextWrapPos()
									imgui.EndTooltip()
									imgui.PopStyleColor()
								end
								imgui.PopFont()
								imgui.PushFont(fontsize25)
							else
								if imgui.Button(fa.ICON_FA_MINUS_CIRCLE .. u8" ������� ���� ���. ���������", imgui.ImVec2(453, 35)) then
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
							imgui.TextUnformatted(u8"������ ������� �������� �� �������� ����� ������� ��������� �� ����� ������\n\n�������� ������������ � ��������\n�� ���������: 1 ������� (������������� ��������)")
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
					if imgui.Button(fa.ICON_FA_UNDO .. u8" ������������� ������", imgui.ImVec2(453, 35)) then
						thisScript():reload()
						setPlayerControl(PlayerPed, true)
					end
					imgui.SameLine()
					if imgui.Button(fa.ICON_FA_POWER_OFF .. u8" ��������� ������", imgui.ImVec2(453, 35)) then
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
					imgui.Text(u8"- �������, ���������� �� ��������� ����")
					local style = imgui.GetStyle()
					style.ItemSpacing = imgui.ImVec2(0, 6.5)
					imgui.PushFont(fontsize23)
						imgui.Text("/")
					imgui.PopFont()
					imgui.SameLine()
					imgui.PushItemWidth(572)
						if imgui.InputTextWithHint(u8"##cmd", u8"������� ������� ��� '/'. ��������: findp", command) then
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
								imgui.TextUnformatted(u8"���������� ������ �������, ������� ����� �������������� � ���������� ��� ��������� ����")
								imgui.PopTextWrapPos()
								imgui.EndTooltip()
								imgui.PopStyleColor()
							end
						end
					imgui.PopItemWidth()
					style.ItemSpacing = imgui.ImVec2(12.0, 6.5)
					imgui.SameLine(600)
					imgui.Text(u8"- �������, ���������� �� ��������� ����")
				imgui.PopFont()
				imgui.PushFont(fontsize25)
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
					if imgui.Button(fa.ICON_FA_EJECT .. u8" �������� ������� ���������� �� ��������� ���� �� ��������� �� ���������", imgui.ImVec2(918, 35)) then
						if cmd ~= "findplayers" then
							local lastCmd = cmd
							sampUnregisterChatCommand(cmd)
							FindPlayer.cfg.command = "findplayers"
							inicfg.save(FindPlayer, "FindPlayer")
							cmd = FindPlayer.cfg.command
							command.v = cmd
							sampRegisterChatCommand(cmd, activation)
							sampAddChatMessage(tag .. color_text .. "������� \"{FFFFFF}/" .. lastCmd .. "{FFFF00}\", ���������� �� ��������� ���� ���� �������� �� \"{FFFFFF}/" .. cmd .. "{FFFF00}\"", main_color)
						else
							sampAddChatMessage(tag .. color_text .. "�������, ���������� �� ��������� ���� {FFFFFF}�� ���� ��������{FFFF00}, ��� ��� ��� � ��� �������� �������� �� ���������.", main_color)
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
					if imgui.InputTextWithHint(u8"�������", u8"��������: Sam_Mason", nickIgnore) then
						nickIgnore.v = nickIgnore.v:gsub(' ', '')
					end
					imgui.PopItemWidth()
					imgui.SameLine(480)
					imgui.TextQuestion(u8"������ ������� �������� �� ������������� ���������...\n������ ����� ������������ �������� ������� ��� ������,\n���� ���� �� ������� � ������� ������� ����� ����� ����� ���������")
					imgui.SameLine()
					imgui.TextDisabled(u8"- ������ ������ �� ��������")
				imgui.PopFont()
				imgui.PushFont(fontsize25)
					if imgui.Button(fa.ICON_FA_PLUS_SQUARE .. u8" �������� ������� � �������������", imgui.ImVec2(453, 35)) then
						if #nickIgnore.v == 0 then
							sampAddChatMessage(tag .. color_text .. "���� ��� ����� {FFFFFF}������", main_color)
						else
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							a = file:read("*a")
							file:close()
							local insideTabl = decodeJson(a)
							if #insideTabl["nicks"] ~= 0 then
								local i = 1
								for _,v in ipairs(insideTabl["nicks"]) do
									if u8:decode(nickIgnore.v) == v then
										sampAddChatMessage(tag .. color_text .. "����� ������� ��� ������������ � {FFFFFF}�������������", main_color)
										break
									else
										i = i + 1
										if i > #insideTabl["nicks"] then
											sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}�������{FFFF00} �������� � {FFFFFF}�������������", main_color)
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
								sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}�������{FFFF00} �������� �{FFFFFF} �������������", main_color)
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
					if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" ������� ������� �� �������������", imgui.ImVec2(453, 35)) then
						if #nickIgnore.v == 0 then
							sampAddChatMessage(tag .. color_text .. "���� ��� ����� {FFFFFF}������", main_color)
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
									sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}������� {FFFF00}�����:", main_color)
									sampAddChatMessage(tag .. "{FFFFFF}" .. v, main_color)
									break
								else
									i = i + 1
								end
							end
							if not linkDeleted then
								sampAddChatMessage(tag .. color_text .. "������ ������� {FFFFFF}�� ������{FFFF00} � {FFFFFF}�������������", main_color)
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
							imgui.Button(fa.ICON_FA_EYE .. u8" ���������� ��� �������� � �������������", imgui.ImVec2(918, 35))
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
							imgui.TextUnformatted(u8"� ������������� ��� �� ������ ��������")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
							imgui.PopStyleColor()
						end
					else
						if imgui.Button(fa.ICON_FA_EYE .. u8" ���������� ��� �������� � �������������", imgui.ImVec2(918, 35)) then
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							local a = file:read("*a")
							file:close()
							sampAddChatMessage(tag .. color_text .. "���� � ��� ����� {FFFFFF}��������{FFFF00} ��� ��������, ������� ��������� � {FFFFFF}�������������", main_color)
							local allnicks = decodeJson(a)
							for _, v in ipairs(allnicks["nicks"]) do
								sampAddChatMessage(tag .. "{FFFFFF}" .. v, main_color)
							end
							sampAddChatMessage(tag .. color_text .. "������ � {FFFFFF}������������� {FFFF00}��������� {FFFFFF}" .. #allnicks["nicks"] .. " {FFFF00}���������", main_color)
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
							imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" ������� ��� �������� �� �������������", imgui.ImVec2(918, 35))
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
							imgui.TextUnformatted(u8"� ������������� ��� �� ������ ��������")
							imgui.PopTextWrapPos()
							imgui.EndTooltip()
							imgui.PopStyleColor()
						end
					else
						if imgui.Button(fa.ICON_FA_MINUS_SQUARE .. u8" ������� ��� �������� �� �������������", imgui.ImVec2(918, 35)) then
							local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "r")
							a = file:read("*a")
							file:close()
							local insideTabl = decodeJson(a)
							if #insideTabl["nicks"] ~= 0 then
								local count = #insideTabl["nicks"]
								for i = 1, count do
									table.remove(insideTabl["nicks"], 1)
								end
								sampAddChatMessage(tag .. color_text .. "��� �������� �� {FFFFFF}������������� {FFFF00}����{FFFFFF} ������� {FFFF00}�������", main_color)
								encodedTable = encodeJson(insideTabl)
								local file = io.open(MoonFolder .."\\config\\FindPlayer.json", "w")
								file:write(encodedTable)
								file:flush()
								file:close()
							else
								sampAddChatMessage(tag .. color_text .. "� {FFFFFF}������������� {FFFF00}��� �� ������ ��������", main_color)
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
					if imgui.Checkbox(u8"- ������������ ������� ��� ���-���� (������ ������ �� �����, ��� ����� ������ ����������)", ignore) then
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
						imgui.TextUnformatted(u8"����� ������ �� ���� ��������� �� ���������. ������ ����� ����� �������� ������� ��� ���-����, �� ����� ������ �� ����� ������������ � ����")
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
					imgui.Text(u8"-  �������� ���� �����")
				imgui.PopFont()
				imgui.PushFont(fontsize25)
					if imgui.Button(fa.ICON_FA_SAVE .. u8" ��������� ����� ����� � ������", imgui.ImVec2(918, 35)) then
						if changeColor then
							if rgb_style then
								sampAddChatMessage(tag .. color_text .. "����� {ff4c5b}R{99ff99}G{00ffff}B{FFFFFF} ����� {FFFF00}������� {FFFFFF}�������� {FFFF00}� ������", main_color)
								FindPlayer.cfg.rgb_style = true
								inicfg.save(FindPlayer, "FindPlayer")
							else
								sampAddChatMessage(tag .. color_text .. "����� " .. d1 .. "����� {FFFF00}������� {FFFFFF}�������� {FFFF00}� ������", main_color)
								FindPlayer.cfg.color1 = a1
								FindPlayer.cfg.color2 = b1
								FindPlayer.cfg.color3 = c1
								inicfg.save(FindPlayer, "FindPlayer")
							end
						else
							sampAddChatMessage(tag .. color_text .. "������� ���������� {FFFFFF}�������� {FFFF00}����", main_color)
						end
					end
					if imgui.Button(fa.ICON_FA_EJECT .. u8" �������� �� ����� �� ���������", imgui.ImVec2(918, 35)) then
						sampAddChatMessage(tag .. color_text .. "����� ������� �� ��������� �� ��������� �{FFFF00} ������� {FFFFFF}�������� {FFFF00}� ������", main_color)
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
						if imgui.CustomButton(fa.ICON_FA_PAINT_ROLLER .. u8" RGB �����", imgui.ImVec4(r, g, b, 0.95),  imgui.ImVec4(r, g, b, 1.00), imgui.ImVec4(r, g, b, 0.8), imgui.ImVec2(918, 35)) then
							sampAddChatMessage(tag .. color_text .. "{ff4c5b}R{99ff99}G{00ffff}B{FFFFFF} ����� {FFFF00}������� {FFFFFF}��������{FFFF00}, �� �� �������� � ������", main_color)
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
							imgui.CustomButton(fa.ICON_FA_PAINT_ROLLER .. u8" RGB �����", imgui.ImVec4(r, g, b, 0.3),  imgui.ImVec4(r, g, b, 0.3), imgui.ImVec4(r, g, b, 0.3), imgui.ImVec2(918, 35))
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
							imgui.TextUnformatted(u8"RGB ����� ��� �����������")
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
					if imgui.Button(fa.ICON_FA_CLOUD_UPLOAD_ALT .. u8" ��������� ������� ����������", imgui.ImVec2(918, 35)) then
						if not checkupd then
							sampAddChatMessage(tag .. color_text .. "{FFFFFF}��������� {FFFF00}������� ����������...", main_color)
							downloadUrlToFile(update_url, update_path, function(id, status)
								if status == dlstatus.STATUS_ENDDOWNLOADDATA then
									checkupd = true
									updateIni = inicfg.load(nil, update_path)
									if updateIni ~= nil then
										if tonumber(updateIni.info.vers) > script_vers then
											sampAddChatMessage(tag .. color_text .. "������� {FFFFFF}����������{FFFF00}! ����� ������: {FFFFFF}" .. updateIni.info.vers_text .."{FFFF00}. ������� ������: {FFFFFF}".. script_vers_text .. "{FFFF00}.", main_color)
											sampAddChatMessage(tag .. color_text .. "����� {FFFFFF}����������{FFFF00} ����������, ���������� ������� � ������ {FFFFFF}\"����������\"{FFFF00} � ���� �������", main_color)
											mbobnova = true
											checkupd = false
										else
											checkupd = false
											sampAddChatMessage(tag .. color_text .. "���������� {FFFFFF}�� �������{FFFF00}.", main_color)
										end
										os.remove(update_path)
										checkupd = false
									else
										os.remove(update_path)
										checkupd = false
										sampAddChatMessage(tag .. color_text .. "��������� �����-�� {FFFFFF}������{FFFF00}! �� ������� ��������� ������� ����������... ���������� ��� ���.", main_color)
									end
								end
							end)
						else
							sampAddChatMessage(tag .. color_text .. "��������� �������� �� ������� ���������� ���� {FFFFFF}�����{FFFF00}! ������ ��� �������� ������ ��������.", main_color)
						end
					end
					if mbobnova then
						if imgui.Button(fa.ICON_FA_DOWNLOAD .. u8" ��������", imgui.ImVec2(918, 35)) then
							if mbobnova then
								sampAddChatMessage(tag .. color_text .. "���������� {FFFFFF}��������� {FFFF00}���������� ����������", main_color)
								window.v = not window.v
								imgui.Process = window.v
								obnova = true
							end
						end
						if imgui.Button(fa.ICON_FA_BOOK .. u8" ������ ���������", imgui.ImVec2(918, 35)) then
							downloadUrlToFile(update_url, update_path, function(id, status)
								if status == dlstatus.STATUS_ENDDOWNLOADDATA then
									updateIni = inicfg.load(nil, update_path)
									if updateIni ~= nil then
										sampShowDialog(1337, "{FFFF00}������ ���������", u8:decode(updateIni.info.changelog):gsub("\\([n])", {n="\n"}), "{ff0000}�������", nil, DIALOG_STYLE_MSGBOX)
										window.v = false
										windowActive = true
									else
										sampAddChatMessage(tag .. color_text .. "��������� {FFFFFF}������{FFFF00}, ���������� ��� ���", main_color)
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
							imgui.Button(fa.ICON_FA_DOWNLOAD .. u8" ��������", imgui.ImVec2(918, 35))
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
						imgui.PopStyleColor()
					end
					if imgui.Button(fa.ICON_FA_HISTORY .. u8" ������� ����������", imgui.ImVec2(918, 35)) then
						sampShowDialog(1337, "{FFFF00}������� ���������� ������� {FFFFFF}FindPlayers", "{FFFF00}������ {FFFFFF}1.0 {808080}(���� ������: {a5a5a5}28.10.21{808080}){FFFF00}:\n{FFFFFF}- �����\n{FFFF00}������ {FFFFFF}1.1 {808080}(���� ������: {a5a5a5}28.10.21{808080}){FFFF00}:\n{FFFFFF}- ���������� ��������� ������\n{FFFF00}������ {FFFFFF}1.2 {808080}(���� ������: {a5a5a5}31.10.21{808080}){FFFF00}:\n{FFFFFF}- ���������� ����� ������\n{FFFFFF}- ������������ � ������� ��������� ��������� ���\n{FFFFFF}- ��������� ��������� ����������� � ���������� �������\n{FFFF00}������ {FFFFFF}1.3 {808080}(���� ������: {a5a5a5}18.11.22{808080}){FFFF00}:\n{FFFFFF}- ���������� ������ ������\n- ������� ����-������� ������������ ��� ����� ��������� ��������\n- ��������� ������� �������\n- ������ ����� ������ ������� � ��������� ���������\n- ��������� ������ ����������� ������ � ������ ������ �������\n- ������� ������� ������\n- �������� �����������", "{ff0000}�������", nil, DIALOG_STYLE_MSGBOX)
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
							imgui.TextColoredRGB("" .. d1 .. "������ {000000}FindPlayers " .. d1 .. "��� ������ ��� �������� ������ ����� � ����������� ������� �� ����� �������. ��� ������ ������\n" .. d1 .. "������� �������� � ������ �������, �� ������������� �������� ��� {000000}����" .. d1 .. ", {000000}���-����" .. d1 .. ", � ����� {000000}����� ��������" .. d1 .. ", � �����\n" .. d1 .. "������� ��� ��� ���������� � ����. � ���� �� ���� ����� ����������� ������ ����� {000000}������� ������ " .. d1 .. "(���� � ���� ���� \n" .. d1 .. "���-�����) � {000000}������������� ������� ������������� ��������� " .. d1 .. "(�� ������� - ������ ������ ��� ���������)\n" .. d1 .. "��� ����, ����� ������ ����� ������ ����� �� ������� � ������ �������, ���������� ������� � ������ {000000}\"����� �����\"\n" .. d1 .. "� ������ �� ����������� ������. �� ��������� ������ ����� ������ ���� ����� � {000000}1-��" .. d1 .. " �������, �� �������� ���\n" .. d1 .. "����� � ������� {000000}\"��������� �������\"" .. d1 .. ". ����� � ���� ������� �����: {000000}��������� �������� ��������� ��� ������� �� ������" .. d1 .. ",\n{000000}������������� ������" .. d1 .. " � {000000}��������� ������ ���������" .. d1 .. ". ��� ����, ����� �������� {000000}����" .. d1 .. ", ���� {000000}������� ��������� ���� " .. d1 .. "�������,\n" .. d1 .. "���������� ������� � ������ {000000}\"��������� ��������� �������\"" .. d1 .. ", � ��� ��� ��������� �� �� ������. � ������� {000000}\"�������\n������������� ���������\"" .. d1 .. " �����: {000000}���������� ��� �������� ����������� � �������������" .. d1 .. ", {000000}������� ��� �������� ��\n�������������" .. d1 .. ", {000000}�������� ������� � �������������" .. d1 .. " � {000000}������� ������� �� �������������" .. d1 .. ". ������ ������� �������� ��\n" .. d1 .. "������������ ����������� ������� ��� ������, ���� ���� �� ������� ������������� �������.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_FORWARD .. u8" ��������� ��������", imgui.ImVec2(205, 25)) then
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
							imgui.TextColoredRGB("" .. d1 .. "���� �� ��� ������� ����������� �������� ����� � �������, �� ������ ������� � ������ {000000}\"������������ ����������\"" .. d1 .. ", � ���\n" .. d1 .. "��� ��������� �������� ��� �������� �����, � ����� ������������ {000000}RGB �����" .. d1 .. " � ������������ ���� ������. �� � �������\n" .. d1 .. "�� ������ �������� � ����� �������, ��� {000000}\"����������\"" .. d1 .. ". � ���� ������� �����: {000000}��������� ������� ����������" .. d1 .. ", {000000}��������\n������ " .. d1 .. "(���� ���������� ��������), � ����� ���������� {000000}������� ���� ���������� ����� �������" .. d1 .. ".\n" .. d1 .. "����� �������: {000000}https://vk.com/klamet1/" .. d1 .. ". ���� �� ����� ����� ���� {000000}���" .. d1 .. ", ������ ������ �������� {000000}�������������" .. d1 .. " ��� ��������\n" .. d1 .. "����� ���� {000000}������" .. d1 .. ", �� ������ ��� ������� �� {000000}���������\n" .. d1 .. "����� ����� ��������� � {000000}������������ �������������" .. d1 .. ". �� ������ �������� ������� ������� �� ��� {000000}QIWI ������� " .. d1 .. "��\n��������" .. d1 .. ", ��� ������� � {000000}QIWI" .. d1 .. " ��������: {000000}KLAMET" .. d1 .. ".\n{000000}������� " .. d1 .. "�� ������������� ����� �������. {000000}�������" .. d1 .. ", ��� �� ����� ��������� ���� ������.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_BACKWARD .. u8" ���������� ��������", imgui.ImVec2(205, 25)) then
								page = 1
							end
							imgui.PopFont()
							imgui.PushFont(fontsize25)
							imgui.Spacing()
							imgui.Separator()
							imgui.Spacing()
							imgui.Spacing()
							if imgui.Button(fa.ICON_FA_GLOBE .. u8" ��������� � �������", imgui.ImVec2(453, 35)) then
								os.execute("start www.vk.com/klamet1")
							end
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_USERS .. u8" ���� � ���� �������� �� ������ BlastHack", imgui.ImVec2(453, 35)) then
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
							imgui.TextColoredRGB("" .. d1 .. "������ {FFFFFF}FindPlayers " .. d1 .. "��� ������ ��� �������� ������ ����� � ����������� ������� �� ����� �������. ��� ������ ������\n" .. d1 .. "������� �������� � ������ �������, �� ������������� �������� ��� {FFFFFF}����" .. d1 .. ", {FFFFFF}���-����" .. d1 .. ", � ����� {FFFFFF}����� ��������" .. d1 .. ", � �����\n" .. d1 .. "������� ��� ��� ���������� � ����. � ���� �� ���� ����� ����������� ������ ����� {FFFFFF}������� ������ " .. d1 .. "(���� � ���� ���� \n" .. d1 .. "���-�����) � {FFFFFF}������������� ������� ������������� ��������� " .. d1 .. "(�� ������� - ������ ������ ��� ���������)\n" .. d1 .. "��� ����, ����� ������ ����� ������ ����� �� ������� � ������ �������, ���������� ������� � ������ {FFFFFF}\"����� �����\"\n" .. d1 .. "� ������ �� ����������� ������. �� ��������� ������ ����� ������ ���� ����� � {FFFFFF}1-��" .. d1 .. " �������, �� �������� ���\n" .. d1 .. "����� � ������� {FFFFFF}\"��������� �������\"" .. d1 .. ". ����� � ���� ������� �����: {FFFFFF}��������� �������� ��������� ��� ������� �� ������" .. d1 .. ",\n{FFFFFF}������������� ������" .. d1 .. " � {FFFFFF}��������� ������ ���������" .. d1 .. ". ��� ����, ����� �������� {FFFFFF}����" .. d1 .. ", ���� {FFFFFF}������� ��������� ���� " .. d1 .. "�������,\n" .. d1 .. "���������� ������� � ������ {FFFFFF}\"��������� ��������� �������\"" .. d1 .. ", � ��� ��� ��������� �� �� ������. � ������� {FFFFFF}\"�������\n������������� ���������\"" .. d1 .. " �����: {FFFFFF}���������� ��� �������� ����������� � �������������" .. d1 .. ", {FFFFFF}������� ��� �������� ��\n�������������" .. d1 .. ", {FFFFFF}�������� ������� � �������������" .. d1 .. " � {FFFFFF}������� ������� �� �������������" .. d1 .. ". ������ ������� �������� ��\n" .. d1 .. "������������� ����������� ������� ��� ������, ���� ���� �� ������� ������������� �������.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_FORWARD .. u8" ��������� ��������", imgui.ImVec2(205, 25)) then
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
							imgui.TextColoredRGB("" .. d1 .. "���� �� ��� ������� ����������� �������� ����� � �������, �� ������ ������� � ������ {FFFFFF}\"������������ ����������\"" .. d1 .. ", � ���\n" .. d1 .. "��� ��������� �������� ��� �������� �����, � ����� ������������ {FFFFFF}RGB �����" .. d1 .. " � ������������ ���� ������. �� � �������\n" .. d1 .. "�� ������ �������� � ����� �������, ��� {FFFFFF}\"����������\"" .. d1 .. ". � ���� ������� �����: {FFFFFF}��������� ������� ����������" .. d1 .. ", {FFFFFF}��������\n������ " .. d1 .. "(���� ���������� ��������), � ����� ���������� {FFFFFF}������� ���� ���������� ����� �������" .. d1 .. ".\n" .. d1 .. "����� �������: {FFFFFF}https://vk.com/klamet1/" .. d1 .. ". ���� �� ����� ����� ���� {FFFFFF}���" .. d1 .. ", ������ ������ �������� {FFFFFF}�������������" .. d1 .. " ��� ��������\n" .. d1 .. "����� ���� {FFFFFF}������" .. d1 .. ", �� ������ ��� ������� �� {FFFFFF}���������\n" .. d1 .. "����� ����� ��������� � {FFFFFF}������������ �������������" .. d1 .. ". �� ������ �������� ������� ������� �� ��� {FFFFFF}QIWI ������� " .. d1 .. "��\n��������" .. d1 .. ", ��� ������� � {FFFFFF}QIWI" .. d1 .. " ��������: {FFFFFF}KLAMET" .. d1 .. ".\n{FFFFFF}������� " .. d1 .. "�� ������������� ����� �������. {FFFFFF}�������" .. d1 .. ", ��� �� ����� ��������� ���� ������.")
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_BACKWARD .. u8" ���������� ��������", imgui.ImVec2(205, 25)) then
								page = 1
							end
							imgui.PopFont()
							imgui.PushFont(fontsize25)
							imgui.Spacing()
							imgui.Separator()
							imgui.Spacing()
							imgui.Spacing()
							if imgui.Button(fa.ICON_FA_GLOBE .. u8" ��������� � �������", imgui.ImVec2(453, 35)) then
								os.execute("start www.vk.com/klamet1")
							end
							imgui.SameLine()
							if imgui.Button(fa.ICON_FA_USERS .. u8" ���� � ���� �������� �� ������ BlastHack", imgui.ImVec2(453, 35)) then
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