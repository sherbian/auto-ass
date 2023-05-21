script_author('GHMS | vk.com/tomlas')
script_version('21.05.23')

if not pcall(function() sampev = require('samp.events') end) then sampAddChatMessage('NETY SAMP.LUA', -1)sampAddChatMessage('NETY SAMP.LUA', -1)sampAddChatMessage('NETY SAMP.LUA', -1);end
local d=require('moonloader').download_status;
local inicfg = require('inicfg')
dirConfig = 'auto-ass'
settings = inicfg.load({main = {parts=true,dialog=true,posX=420,posY=400}},dirConfig)
if settings.main.finder == nil then settings.main.finder = false end
inicfg.save(settings, dirConfig)
draw = false
mynick = ''
wheelcount = 0
carPos = {
    x=1910.6994628906, 
    y=652.15032958984, 
    z=10.714400291443,
    getPosFront = function()
        radius = 2.7
        x1 = carPos.x + radius * math.sin(math.rad(0))
        y1 = carPos.y + radius * math.cos(math.rad(0))
        return {x=x1, y=y1,z=carPos.z}
    end,
    getPosRear = function()
        radius = 2.9
        x1 = carPos.x + radius * math.sin(math.rad(180))
        y1 = carPos.y + radius * math.cos(math.rad(180))
        return {x=x1, y=y1,z=carPos.z}
    end,
    getPosWheelFrontRight = function()
        radius = 1.6
        x1 = carPos.x + radius * math.sin(math.rad(45))
        y1 = carPos.y + radius * math.cos(math.rad(45))
        return {x=x1, y=y1,z=carPos.z}
    end,
    getPosWheelFrontLeft = function()
        radius = 1.6
        x1 = carPos.x + radius * math.sin(math.rad(315))
        y1 = carPos.y + radius * math.cos(math.rad(315))
        return {x=x1, y=y1,z=carPos.z}
    end,
    getPosWheelRearRight = function()
        radius = 1.8
        x1 = carPos.x + radius * math.sin(math.rad(140))
        y1 = carPos.y + radius * math.cos(math.rad(140))
        return {x=x1, y=y1,z=carPos.z}
    end,
    getPosWheelRearLeft = function()
        radius = 1.8
        x1 = carPos.x + radius * math.sin(math.rad(220))
        y1 = carPos.y + radius * math.cos(math.rad(220))
        return {x=x1, y=y1,z=carPos.z}
    end,
}
buttonList = {}
marker1 = 0
marker2 = 0
sendDialog = lua_thread.create_suspended(function(id) wait(50); sampSendDialogResponse(id,1,0,'') end)
sendDialogEx = lua_thread.create_suspended(function(id, lab, inp) wait(50); sampSendDialogResponse(id, 1, lab, inp) end)
sendH = lua_thread.create_suspended(function() setVirtualKeyDown(0x48, true); wait(10); setVirtualKeyDown(0x48, false) end)
sendEsc = lua_thread.create_suspended(function() if sampTextdrawIsExists(449) then setVirtualKeyDown(0x1B, true); wait(10); setVirtualKeyDown(0x1B, false) end end)
starter = lua_thread.create_suspended(function()
    wait(100)
    if not getter.active then
        e = buttonList[1]
        getter.start(e[3], e[4])
    end
end)
dialogSettings = lua_thread.create_suspended(function()
	setPlayerControl(PLAYER_HANDLE, false)
	setGxtEntry('CMLUTTL', 'AutoAss')
    setGxtEntry('CMLUMSG', string.format('Version: ~y~~h~%s', thisScript().version))
	setGxtEntry('CMLU1', 'CHANGELOG')
	setGxtEntry('CMLU2', string.format('PARTS ORDER: %s', settings.main.parts and '~y~on' or '~r~off'))
	setGxtEntry('CMLU3', string.format('AUTO DIALOG: %s', settings.main.dialog and '~y~on' or '~r~off'))
    setGxtEntry('CMLU4', string.format('AUTO FINDER: %s', settings.main.finder and '~y~on' or '~r~off'))
	setGxtEntry('CMLU5', 'CHANGE TEXT POSITION')
	setGxtEntry('CMLU6', 'Exit')

	local menu = createMenu('CMLUTTL', 180, 280, 200, 1, true, true, 1)
	setMenuColumn(menu, 0, 'CMLUMSG', 'CMLU1', 'CMLU2', 'CMLU3', 'CMLU4', 'CMLU5', 'CMLU6')

	setActiveMenuItem(menu, 5)
	while true do
		wait(0)
		if isKeyJustPressed(0x0D) then break
		elseif isKeyJustPressed(0x20) then
			if getMenuItemSelected(menu) == 5 then break
            elseif getMenuItemSelected(menu) == 0 then
                sampShowDialog(0,'{00FF00}CHANGELOG','15.05.23 - First version\n16.05.23 - Фикс склада\n17.05.23 - Фикс сборки, автозавершение\n19.05.23 - Настройки, автозакрытие меню\n{ffffff}21.05.23 - Добавлены 2 способа запуска поиска детали:\n\t- номерная клавиша [n] детали\n\t- при открытии меню', 'ok', nil, 0)
            elseif getMenuItemSelected(menu) == 1 then
                settings.main.parts = not settings.main.parts
                inicfg.save(settings, dirConfig)
                setGxtEntry('CMLU2', string.format('PARTS ORDER: %s', settings.main.parts and '~y~on' or '~r~off'))
            elseif getMenuItemSelected(menu) == 2 then
                settings.main.dialog = not settings.main.dialog
                inicfg.save(settings, dirConfig)
                setGxtEntry('CMLU3', string.format('AUTO DIALOG: %s', settings.main.dialog and '~y~on' or '~r~off'))
            elseif getMenuItemSelected(menu) == 3 then
                settings.main.finder = not settings.main.finder
                inicfg.save(settings, dirConfig)
                setGxtEntry('CMLU4', string.format('AUTO FINDER: %s', settings.main.finder and '~y~on' or '~r~off'))
            elseif getMenuItemSelected(menu) == 4 then
                local lastDraw = draw
                draw = false
                local posX, posY = 0, 0
                sampSetCursorMode(2)
                repeat
                    wait(0)
                    local spacer, textY = 22, 0
                    posX, posY = getCursorPos()
                    textY = posY
                    renderFontDrawText(font,'[0] Двигатель: 0000',  posX, textY,0xFFFFFFFF)textY = textY + spacer*1.5
                    renderFontDrawText(font,'[0] БамперП: 0000',    posX, textY,0xFFFFFFFF)textY = textY + spacer
                    renderFontDrawText(font,'[0] Колеса: 0000',     posX, textY,0xFFFFFFFF)textY = textY + spacer
                    renderFontDrawText(font,'[0] БамперЗ: 0000',    posX, textY,0xFFFFFFFF)textY = textY + spacer
                    renderFontDrawText(font,'[0] Нитро: 0000',      posX, textY,0xFFFFFFFF)textY = textY + spacer
                    renderFontDrawText(font,'[0] Спойлер: 0000',    posX, textY,0xFFFFFFFF)textY = textY + spacer
                    renderFontDrawText(font,'[0] Крыша: 0000',      posX, textY,0xFFFFFFFF)
                    until isKeyJustPressed(0x1)
                    sampSetCursorMode(0)
                    settings.main.posX = posX; settings.main.posY = posY;
                    inicfg.save(settings, dirConfig)
                    draw = lastDraw
			end
		end
	end
	wait(0)
	deleteMenu(menu)
	setPlayerControl(PLAYER_HANDLE, true)
end)

mark1 = lua_thread.create_suspended(function(x, y, z)
    deleteCheckpoint(marker1)
    marker1 = createCheckpoint(1, x, y, z, 1, 1, 1, 0.4)
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < 0.5
    deleteCheckpoint(marker1)
    deleteCheckpoint(marker2)
    mark2:terminate()
    addOneOffSound(0, 0, 0, 1149)
    for i = 0, 7, 1 do
        setVirtualKeyDown(0x48, true); wait(30); setVirtualKeyDown(0x48, false)
        wait(10)
    end
end)
mark2 = lua_thread.create_suspended(function(x, y, z)
    deleteCheckpoint(marker2)
    marker2 = createCheckpoint(1, x, y, z, 1, 1, 1, 0.4)
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < 0.4
    deleteCheckpoint(marker1)
    deleteCheckpoint(marker2)
    mark1:terminate()
    addOneOffSound(0, 0, 0, 1149)
    for i = 0, 5, 1 do
        setVirtualKeyDown(0x48, true); wait(50); setVirtualKeyDown(0x48, false)
        wait(10)
    end
end)
elementList = {
    engine = 0,
    bumpFront = 0,
    wheel = 0,
    nitro = 0,
    spoler = 0,
    bumpRear = 0,
    roof = 0,
}
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() and not isPlayerPlaying(PLAYER_HANDLE) do wait(111) end
    wait(1000)
    font = renderCreateFont('Arial', 12, 13)
    mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    allZero()
    spacer = 22
    col1 = 0xFFFFFFFF
    col2 = 0xFFED760E
    col3 = 0xFF78858B
    col4 = 0xFF4C9141
    local fpath = os.getenv('TEMP') .. '\\auto-ass-version.json';if doesFileExist(fpath) then os.remove(fpath)end;downloadUrlToFile('https://raw.githubusercontent.com/sherbian/auto-ass/main/version.json', fpath, function(id, status, p1, p2)if status == d.STATUS_ENDDOWNLOADDATA then local f = io.open(fpath, 'r') if f then local info = decodeJson(f:read('*a'))if info and info.latest then if info.latest~=thisScript().version then lua_thread.create(function()local m=-1;local b='auto-ass (o|o) ';sampAddChatMessage(b..'Обновочка. c '..thisScript().version..' на '..info.latest,m)wait(250)downloadUrlToFile(info.url,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка завершена')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Ошибка автообновления',m)end end end)end)end end end end end)
    sampAddChatMessage('auto-ass (o|o) загружен. {c0c0c0}/draw /draw menu', -1)
    local getColor = function(e) 
        if e == 'wheel' then
            
            return wheelcount % 2 == 0 and (taskList.wheelRear.put and col3 or (taskList.wheelRear.get and col2 or col1)) or (taskList.wheelFront.put and col3 or (taskList.wheelFront.get and col2 or col1))
        else
            return taskList[e].put and col3 or (taskList[e].get and col2 or col1)
        end
    end
    while 1 do wait(0)
        if draw then
            textY = settings.main.posY
            buttonList = getList()
            for k, v in ipairs(buttonList) do
                if drawClickableText(font, string.format('[%s] %s: %s', k, v[2], v[3]),  settings.main.posX, textY, getColor(v[1]), col4) and not not getter.active then getter.start(v[3], v[4]) end textY = textY + (k == 1 and spacer * 1.5 or spacer)
            end
        end
    end
end

getList = function()
    local tbl = {}
    local isGood = function(n) return elementList[n] ~= 'None' and not taskList[n].put end
    local add = function(i, n, e, t) tbl[#tbl+1] = {i, n, e, t} end
    if isGood('engine') then    add('engine',   'Двигатель', '0002', 6) end
    if isGood('bumpFront') then add('bumpFront', 'БамперП', elementList.bumpFront, 1) end
    if elementList.wheel ~= 'None' and wheelcount < 3 and not taskList.wheelRear.put then 
                                add('wheel',   'Колеса',   elementList.wheel, 3) end
    if isGood('bumpRear') then  add('bumpRear', 'БамперЗ',  elementList.bumpRear, 2) end
    if isGood('nitro') then     add('nitro',    'Нитро',    elementList.nitro, 6) end
    if isGood('spoler') then    add('spoler',   'Спойлер',  elementList.spoler, 4) end
    if isGood('roof') then      add('roof',     'Крыша',    elementList.roof, 5) end
    return tbl
end


toIds = {['0120']=1,['0155']=1,['0156']=1,['0158']=1,['0160']=1,['0163']=1,['0168']=1,['0169']=1,['0172']=1,['0173']=1,['0174']=1,['0175']=1,['0176']=1,['0177']=1,['0178']=1,['0182']=1,['0184']=1,['0185']=1,['0188']=1,['0191']=1,['0192']=1,['0193']=1,['0194']=1,
        ['0143']=2,['0144']=2,['0151']=2,['0152']=2,['0153']=2,['0154']=2,['0157']=2,['0159']=2,['0162']=2,['0164']=2,['0170']=2,['0171']=2,['0179']=2,['0180']=2,['0181']=2,['0183']=2,['0186']=2,['0187']=2,['0189']=2,['0190']=2,['0195']=2,['0196']=2,
        ['0028']=3,['0076']=3,['0077']=3,['0078']=3,['0079']=3,['0080']=3,['0081']=3,['0082']=3,['0083']=3,['0084']=3,['0085']=3,['0086']=3,['0087']=3,['0088']=3,['0099']=3,['0100']=3,['0101']=3,
        ['0003']=4,['0004']=4,['0005']=4,['0006']=4,['0017']=4,['0018']=4,['0019']=4,['0026']=4,['0052']=4,['0053']=4,['0061']=4,['0063']=4,['0141']=4,['0142']=4,['0149']=4,['0150']=4,['0161']=4,['0165']=4,['0166']=4,['0167']=4,
        ['0009']=5,['0035']=5,['0036']=5,['0038']=5,['0041']=5,['0056']=5,['0057']=5,['0058']=5,['0064']=5,['0070']=5,['0071']=5,['0091']=5,['0094']=5,['0106']=5,['0131']=5,['0133']=5,['0134']=5,
        ['0001']=6,['0011']=6,['0012']=6,['0013']=6,
}
sendClick = lua_thread.create_suspended(function(id) wait(50); sampSendClickTextdraw(id); wait(20) end)
getter = {
    active = false,
    elementType = 1,
    findElement = '0000',
    refoundActive = false,
    elementId = 0,
    dialogBuy = false,
    put = false,
    nextPage = function()
        getter.refoundActive = true
        sendClick:run(itemsPos[getter.elementType].button3.id)
    end,
    found = function(id)
        getter.refoundActive = false
        getter.elementId = id
        sendClick:run(id)
        dialogBuy = true
    end,
    find = function()
        if      getter.findElement == string.match(itemsPos[getter.elementType].item1.num.text, '(%d%d%d%d)~n~~y~%d+~n~_') then getter.found(itemsPos[getter.elementType].item1.label.id)
        elseif  getter.findElement == string.match(itemsPos[getter.elementType].item2.num.text, '(%d%d%d%d)~n~~y~%d+~n~_') then getter.found(itemsPos[getter.elementType].item2.label.id)
        elseif  getter.findElement == string.match(itemsPos[getter.elementType].item3.num.text, '(%d%d%d%d)~n~~y~%d+~n~_') then getter.found(itemsPos[getter.elementType].item3.label.id)
        else
            getter.nextPage()
        end
    end,
    start = function(element, t)
        getter.active = true
        getter.elementType = t
        getter.findElement = element
        getter.dialogBuy = settings.main.parts
        getter.find()
    end,
}
_refound = lua_thread.create_suspended(function() if getter.refoundActive then wait(10); getter.find() end end)
function refound()
    if (_refound:status() == 'dead' or _refound:status() == 'suspended') and getter.refoundActive then _refound:run() end  
end

taskList = {
    engine      = {exits=false,get=false,put=false},
    bumpFront   = {exits=false,get=false,put=false},
    wheelFront  = {exits=false,get=false,put=false},
    wheelRear   = {exits=false,get=false,put=false},
    nitro       = {exits=false,get=false,put=false},
    spoler      = {exits=false,get=false,put=false},
    bumpRear    = {exits=false,get=false,put=false},
    roof        = {exits=false,get=false,put=false},
}

itemsPos = {
    [1] = {
        item1 = {
            label = {x=199.333,y=146.978},
            num = {x=234.833,y=147.792}
        },
        item2 = {
            label = {x=239.733,y=146.978},
            num = {x=274.833,y=147.792}
        },
        item3 = {
            label = {x=279.966,y=146.978},
            num = {x=314.633,y=147.792}
        },
        button1 = {x=245.000,y=195.652},
        button2 = {x=258.333,y=195.652},
        button3 = {x=272.633,y=195.652},
    },
    [2] = {
        item1 = {
            label = {x=324.933,y=146.978},
            num = {x=359.800,y=147.792}
        },
        item2 = {
            label = {x=365.333,y=146.978},
            num = {x=400.133,y=147.792}
        },
        item3 = {
            label = {x=405.566,y=146.978},
            num = {x=440.367,y=147.792}
        },
        button1 = {x=370.333,y=195.652},
        button2 = {x=383.666,y=195.652},
        button3 = {x=397.966,y=195.652},
    },
    [3] = {
        item1 = {
            label = {x=199.333,y=225.378},
            num = {x=234.833,y=226.192}
        },
        item2 = {
            label = {x=239.733,y=225.378},
            num = {x=274.833,y=226.192}
        },
        item3 = {
            label = {x=279.966,y=225.378},
            num = {x=314.633,y=226.192}
        },
        button1 = {x=245.000,y=274.052},
        button2 = {x=258.333,y=274.052},
        button3 = {x=272.633,y=274.052},
    },
    [4] = {
        item1 = {
            label = {x=324.933,y=225.378},
            num = {x=359.800,y=226.192}
        },
        item2 = {
            label = {x=365.333,y=225.378},
            num = {x=400.133,y=226.192}
        },
        item3 = {
            label = {x=405.566,y=225.378},
            num = {x=440.367,y=226.192}
        },
        button1 = {x=370.333,y=274.052},
        button2 = {x=383.666,y=274.052},
        button3 = {x=397.966,y=274.052},
    },
    [5] = {
        item1 = {
            label = {x=199.333,y=302.663},
            num = {x=234.833,y=303.478}
        },
        item2 = {
            label = {x=239.733,y=302.663},
            num = {x=274.833,y=303.478}
        },
        item3 = {
            label = {x=279.966,y=302.663},
            num = {x=314.633,y=303.478}
        },
        button1 = {x=245.000,y=351.337},
        button2 = {x=258.333,y=351.337},
        button3 = {x=272.633,y=351.337},
    },
    [6] = {
        item1 = {
            label = {x=324.933,y=302.663},
            num = {x=359.800,y=303.478}
        },
        item2 = {
            label = {x=365.333,y=302.663},
            num = {x=400.133,y=303.478}
        },
        item3 = {
            label = {x=405.566,y=302.663},
            num = {x=440.367,y=303.478}
        },
        button1 = {x=370.333,y=351.337},
        button2 = {x=383.666,y=351.337},
        button3 = {x=397.966,y=351.337},
    },
}
itemCar = {
    engine = {
        label = {x=273.333,y=132.185}, -- id: 2182
        num   = {x=301.067,y=132.556}, -- id: 2198
    },
    roof = {
        label = {x=323.667,y=132.285}, -- id: 2183
        num   = {x=351.800,y=132.556}, -- id: 2199
    },
    spoler = {
        label = {x=372.701,y=163.211}, -- id: 2185
        num   = {x=400.467,y=163.252}, -- id: 2201
    },
    nitro = {
        label = {x=372.433,y=199.385}, -- id: 2184
        num   = {x=400.467,y=199.756}, -- id: 2200
    },
    bumpRear = {
        label = {x=357.133,y=241.696}, -- id: 2186
        num   = {x=385.467,y=242.067}, -- id: 2202
    },
    wheelRear = {
        label = {x=308.333,y=241.696}, -- id: 2187
        num   = {x=337.133,y=242.067}, -- id: 2203
    },
    wheelFront = {
        label = {x=265.033,y=241.781}, -- id: 2188
        num   = {x=293.133,y=242.067}, -- id: 2204
    },
    bumpFront = {
        label = {x=241.000,y=190.759}, -- id: 2181
        num   = {x=268.733,y=191.030}, -- id: 2197
    },
}

function postostr(p)
    return string.format('%.3f', p)
end
function isFind(pos1, pos2)
    return postostr(pos1.x) == postostr(pos2.x) and postostr(pos1.y) == postostr(pos2.y)
end
function elementEmpty()
    return not getter.put and (sendClick:status() == 'dead' or sendClick:status() == 'suspended')
end
putter = lua_thread.create_suspended(function(element)
    taskList[element].put = true
    getter.put = true
    isExits = false
    wait(300)
    for _, v in ipairs({'engine', 'bumpFront', 'wheelFront', 'wheelRear', 'nitro', 'spoler', 'bumpRear', 'roof'}) do
        if taskList[v].exits and (taskList[v].get == false or taskList[v].put == false) then
            isExits = true
        end
    end
    if isExits == false then
        wait(300)
        sendClick:run(448)
    else
        sendEsc:run()
    end
end)
-- 306.866   118.640
function sampev.onShowTextDraw(id, data)
    if id == 106 and isFind(data.position, {x=306.866,y=118.640}) and settings.main.finder then starter:run() end
    if draw then
        if getter.findElement == '0002' and sampTextdrawIsExists(449) then
            if elementEmpty() then 
                sendClick:run(itemCar.engine.label.id) 
                putter:run('engine')
            elseif getter.put and not getter.check and (sendClick:status() == 'dead' or sendClick:status() == 'suspended') then 
                sendClick:run(449)
                getter.check = true; 
            end
        elseif toIds[getter.findElement] == 1 and sampTextdrawIsExists(449)  then
            if elementEmpty() then 
                sendClick:run(itemCar.bumpFront.label.id) 
                putter:run('bumpFront')
            end
        elseif toIds[getter.findElement] == 2 and sampTextdrawIsExists(449)  then
            if elementEmpty() then 
                sendClick:run(itemCar.bumpRear.label.id); 
                putter:run('bumpRear')
            end
        elseif toIds[getter.findElement] == 3 and sampTextdrawIsExists(449)  then 
            if elementEmpty() then 
                if wheelcount % 2 == 0 then
                    sendClick:run(itemCar.wheelRear.label.id)
                    putter:run('wheelRear')
                else
                    sendClick:run(itemCar.wheelFront.label.id)
                    putter:run('wheelFront')
                end
            end
        elseif toIds[getter.findElement] == 4 and sampTextdrawIsExists(449)  then
            if elementEmpty() then 
                sendClick:run(itemCar.spoler.label.id); 
                putter:run('spoler')
            end
        elseif toIds[getter.findElement] == 5 and sampTextdrawIsExists(449)  then
            if elementEmpty() then 
                sendClick:run(itemCar.roof.label.id); 
                putter:run('roof')
            end
        elseif toIds[getter.findElement] == 6 and sampTextdrawIsExists(449)  then
            if elementEmpty() then 
                sendClick:run(itemCar.nitro.label.id); 
                putter:run('nitro')
            end
        end
        if      isFind(data.position, itemsPos[1].item1.label) then itemsPos[1].item1.label.id = id
        elseif  isFind(data.position, itemsPos[1].item2.label) then itemsPos[1].item2.label.id = id
        elseif  isFind(data.position, itemsPos[1].item3.label) then itemsPos[1].item3.label.id = id
        elseif  isFind(data.position, itemsPos[1].item1.num) then itemsPos[1].item1.num.id = id; itemsPos[1].item1.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[1].item2.num) then itemsPos[1].item2.num.id = id; itemsPos[1].item2.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[1].item3.num) then itemsPos[1].item3.num.id = id; itemsPos[1].item3.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[1].button1) then itemsPos[1].button1.id = id 
        elseif  isFind(data.position, itemsPos[1].button3) then itemsPos[1].button3.id = id 

        elseif  isFind(data.position, itemsPos[2].item1.label) then itemsPos[2].item1.label.id = id
        elseif  isFind(data.position, itemsPos[2].item2.label) then itemsPos[2].item2.label.id = id
        elseif  isFind(data.position, itemsPos[2].item3.label) then itemsPos[2].item3.label.id = id
        elseif  isFind(data.position, itemsPos[2].item1.num) then itemsPos[2].item1.num.id = id; itemsPos[2].item1.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[2].item2.num) then itemsPos[2].item2.num.id = id; itemsPos[2].item2.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[2].item3.num) then itemsPos[2].item3.num.id = id; itemsPos[2].item3.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[2].button1) then itemsPos[2].button1.id = id 
        elseif  isFind(data.position, itemsPos[2].button3) then itemsPos[2].button3.id = id 

        elseif  isFind(data.position, itemsPos[3].item1.label) then itemsPos[3].item1.label.id = id
        elseif  isFind(data.position, itemsPos[3].item2.label) then itemsPos[3].item2.label.id = id
        elseif  isFind(data.position, itemsPos[3].item3.label) then itemsPos[3].item3.label.id = id
        elseif  isFind(data.position, itemsPos[3].item1.num) then itemsPos[3].item1.num.id = id; itemsPos[3].item1.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[3].item2.num) then itemsPos[3].item2.num.id = id; itemsPos[3].item2.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[3].item3.num) then itemsPos[3].item3.num.id = id; itemsPos[3].item3.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[3].button1) then itemsPos[3].button1.id = id 
        elseif  isFind(data.position, itemsPos[3].button3) then itemsPos[3].button3.id = id 

        elseif  isFind(data.position, itemsPos[4].item1.label) then itemsPos[4].item1.label.id = id
        elseif  isFind(data.position, itemsPos[4].item2.label) then itemsPos[4].item2.label.id = id
        elseif  isFind(data.position, itemsPos[4].item3.label) then itemsPos[4].item3.label.id = id
        elseif  isFind(data.position, itemsPos[4].item1.num) then itemsPos[4].item1.num.id = id; itemsPos[4].item1.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[4].item2.num) then itemsPos[4].item2.num.id = id; itemsPos[4].item2.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[4].item3.num) then itemsPos[4].item3.num.id = id; itemsPos[4].item3.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[4].button1) then itemsPos[4].button1.id = id 
        elseif  isFind(data.position, itemsPos[4].button3) then itemsPos[4].button3.id = id 

        elseif  isFind(data.position, itemsPos[5].item1.label) then itemsPos[5].item1.label.id = id
        elseif  isFind(data.position, itemsPos[5].item2.label) then itemsPos[5].item2.label.id = id
        elseif  isFind(data.position, itemsPos[5].item3.label) then itemsPos[5].item3.label.id = id
        elseif  isFind(data.position, itemsPos[5].item1.num) then itemsPos[5].item1.num.id = id; itemsPos[5].item1.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[5].item2.num) then itemsPos[5].item2.num.id = id; itemsPos[5].item2.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[5].item3.num) then itemsPos[5].item3.num.id = id; itemsPos[5].item3.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[5].button1) then itemsPos[5].button1.id = id 
        elseif  isFind(data.position, itemsPos[5].button3) then itemsPos[5].button3.id = id 

        elseif  isFind(data.position, itemsPos[6].item1.label) then itemsPos[6].item1.label.id = id
        elseif  isFind(data.position, itemsPos[6].item2.label) then itemsPos[6].item2.label.id = id
        elseif  isFind(data.position, itemsPos[6].item3.label) then itemsPos[6].item3.label.id = id
        elseif  isFind(data.position, itemsPos[6].item1.num) then itemsPos[6].item1.num.id = id; itemsPos[6].item1.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[6].item2.num) then itemsPos[6].item2.num.id = id; itemsPos[6].item2.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[6].item3.num) then itemsPos[6].item3.num.id = id; itemsPos[6].item3.num.text = data.text; refound()
        elseif  isFind(data.position, itemsPos[6].button1) then itemsPos[6].button1.id = id 
        elseif  isFind(data.position, itemsPos[6].button3) then itemsPos[6].button3.id = id 


        elseif  isFind(data.position, itemCar.engine.label) then itemCar.engine.label.id = id 
        elseif  isFind(data.position, itemCar.engine.num) then itemCar.engine.num.id = id 
        elseif  isFind(data.position, itemCar.roof.label) then itemCar.roof.label.id = id
        elseif  isFind(data.position, itemCar.roof.num) then itemCar.roof.num.id = id 
        elseif  isFind(data.position, itemCar.spoler.label) then itemCar.spoler.label.id = id 
        elseif  isFind(data.position, itemCar.spoler.num) then itemCar.spoler.num.id = id 
        elseif  isFind(data.position, itemCar.nitro.label) then itemCar.nitro.label.id = id 
        elseif  isFind(data.position, itemCar.nitro.num) then itemCar.nitro.num.id = id 
        elseif  isFind(data.position, itemCar.bumpRear.label) then itemCar.bumpRear.label.id = id 
        elseif  isFind(data.position, itemCar.bumpRear.num) then itemCar.bumpRear.num.id = id 
        elseif  isFind(data.position, itemCar.wheelRear.label) then itemCar.wheelRear.label.id = id 
        elseif  isFind(data.position, itemCar.wheelRear.num) then itemCar.wheelRear.num.id = id 
        elseif  isFind(data.position, itemCar.wheelFront.label) then itemCar.wheelFront.label.id = id 
        elseif  isFind(data.position, itemCar.wheelFront.num) then itemCar.wheelFront.num.id = id 
        elseif  isFind(data.position, itemCar.bumpFront.label) then itemCar.bumpFront.label.id = id 
        elseif  isFind(data.position, itemCar.bumpFront.num) then itemCar.bumpFront.num.id = id 
        end
    end
end
function sampev.onTextDrawSetString(id, text)
    if draw then
        if sampTextdrawIsExists(106) then
            if      id == itemsPos[1].item1.num.id then itemsPos[1].item1.num.text = text
            elseif  id == itemsPos[1].item2.num.id then itemsPos[1].item2.num.text = text
            elseif  id == itemsPos[1].item3.num.id then itemsPos[1].item3.num.text = text

            elseif  id == itemsPos[2].item1.num.id then itemsPos[2].item1.num.text = text
            elseif  id == itemsPos[2].item2.num.id then itemsPos[2].item2.num.text = text
            elseif  id == itemsPos[2].item3.num.id then itemsPos[2].item3.num.text = text

            elseif  id == itemsPos[3].item1.num.id then itemsPos[3].item1.num.text = text
            elseif  id == itemsPos[3].item2.num.id then itemsPos[3].item2.num.text = text
            elseif  id == itemsPos[3].item3.num.id then itemsPos[3].item3.num.text = text

            elseif  id == itemsPos[4].item1.num.id then itemsPos[4].item1.num.text = text
            elseif  id == itemsPos[4].item2.num.id then itemsPos[4].item2.num.text = text
            elseif  id == itemsPos[4].item3.num.id then itemsPos[4].item3.num.text = text

            elseif  id == itemsPos[5].item1.num.id then itemsPos[5].item1.num.text = text
            elseif  id == itemsPos[5].item2.num.id then itemsPos[5].item2.num.text = text
            elseif  id == itemsPos[5].item3.num.id then itemsPos[5].item3.num.text = text

            elseif  id == itemsPos[6].item1.num.id then itemsPos[6].item1.num.text = text
            elseif  id == itemsPos[6].item2.num.id then itemsPos[6].item2.num.text = text
            elseif  id == itemsPos[6].item3.num.id then itemsPos[6].item3.num.text = text
            end
        elseif sampTextdrawIsExists(449) then
            if      id == itemCar.engine.num.id and text ~= '0' and text ~= '0000' then
                elementList.engine = text
            elseif id == itemCar.roof.num.id and text ~= '0' and text ~= '0000' then
                elementList.roof = text
                taskList.roof.exits = true
            elseif id == itemCar.spoler.num.id and text ~= '0' and text ~= '0000' then
                elementList.spoler = text
                taskList.spoler.exits = true
            elseif id == itemCar.nitro.num.id and text ~= '0' and text ~= '0000' then
                elementList.nitro = text
                taskList.nitro.exits = true
            elseif id == itemCar.bumpRear.num.id and text ~= '0' and text ~= '0000' then
                elementList.bumpRear = text
                taskList.bumpRear.exits = true
            elseif id == itemCar.wheelRear.num.id and text ~= '0' and text ~= '0000' then
                elementList.wheel = text
                taskList.wheelRear.exits = true
            elseif id == itemCar.wheelFront.num.id and text ~= '0' and text ~= '0000' then
                elementList.wheel = text
                taskList.wheelFront.exits = true
            elseif id == itemCar.bumpFront.num.id and text ~= '0' and text ~= '0000' then
                elementList.bumpFront = text
                taskList.bumpFront.exits = true
            end
        end
    end
end
function allZero()
    zeroText = 'None'
    elementList.bumpFront = zeroText
    elementList.bumpRear = zeroText
    elementList.wheel = zeroText
    elementList.spoler = zeroText
    elementList.roof = zeroText
    elementList.nitro = zeroText
    getter.check = false

    taskList.wheelFront = {exits=false,get=false,put=false}
    taskList.wheelRear = {exits=false,get=false,put=false}
    taskList.bumpFront = {exits=false,get=false,put=false}
    taskList.bumpRear = {exits=false,get=false,put=false}
    taskList.engine = {exits=true,get=false,put=false}
    taskList.spoler = {exits=false,get=false,put=false}
    taskList.nitro = {exits=false,get=false,put=false}
    taskList.roof = {exits=false,get=false,put=false}

    wheelcount = 0
end
function sampev.onServerMessage(color,text)
    if draw then
        if text == ' Сборка транспорта успешно завершена' then
            allZero()
        elseif getter.dialogBuy and text:find('Вы успешно заказали выбранные детали на склад. Средства были списаны со счета авторынка') then
            getter.dialogBuy = false
            sendClick:run(getter.elementId)
        elseif getter.active and text == ' Вы взяли выбранную деталь со склада' then
            getter.active = false
            getter.put = false
            if getter.findElement == '0002' then
                pos = carPos.getPosFront()
                mark1:run(pos.x, pos.y, pos.z)
                taskList.engine.get = true
            elseif toIds[getter.findElement] == 1 then
                pos = carPos.getPosFront()
                mark1:run(pos.x, pos.y, pos.z)
                taskList.bumpFront.get = true
            elseif toIds[getter.findElement] == 2 then
                pos = carPos.getPosRear()
                mark1:run(pos.x, pos.y, pos.z)
                taskList.bumpRear.get = true
            elseif toIds[getter.findElement] == 3 then
                wheelcount = wheelcount + 1
                pos1 = wheelcount % 2 == 0 and carPos.getPosWheelRearRight() or carPos.getPosWheelFrontRight()
                pos2 = wheelcount % 2 == 0 and carPos.getPosWheelRearLeft() or carPos.getPosWheelFrontLeft()
                taskList[wheelcount % 2 == 0 and 'wheelRear' or 'wheelFront'].get = true
                mark1:run(pos1.x, pos1.y, pos1.z)
                mark2:run(pos2.x, pos2.y, pos2.z)
            elseif toIds[getter.findElement] == 4 then
                pos = carPos.getPosRear()
                mark1:run(pos.x, pos.y, pos.z)
                taskList.spoler.get = true
            elseif toIds[getter.findElement] == 5 then
                pos = carPos.getPosRear()
                mark1:run(pos.x, pos.y, pos.z)
                taskList.roof.get = true
            elseif toIds[getter.findElement] == 6 then
                pos = carPos.getPosRear()
                mark1:run(pos.x, pos.y, pos.z)
                taskList.nitro.get = true
            end
        end
    end
end
function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if draw then
        if settings.main.dialog and dialogId == 20124 and style == 0 and title == '{FFFFFF}Работа | {ae433d}Авторынок' and (text == '{ffffff}Вы действительно желаете завершить работу в автомастерской?' or text == '{ffffff}Вы действительно желаете устроиться на работу в автомастерскую?') then
            sendDialog:run(dialogId)
            allZero()
            return false
        end
        if getter.active and dialogId == 20125 and title:find('{FFFFFF}.+ | {ae433d}Склад') then
            if getter.dialogBuy then
                sendDialogEx:run(dialogId, 1, '')
                return false
            else
                sendDialog:run(dialogId)
                return false
            end
        elseif getter.active and dialogId == 20126 and getter.dialogBuy and title:find('{FFFFFF}Заказать деталь | {ae433d}Склад') then
            sendDialogEx:run(dialogId, 0, '1')
            return false
        elseif getter.active and dialogId == 20127 and getter.dialogBuy and title:find('{FFFFFF}Подтверждение заказа | {ae433d}Склад') then
            sendDialog:run(dialogId)
            return false
        end
    end
end

function sampev.onCreate3DText(id, color, pos, dist, testLOS, attachedPlayerId, attachedVehicleId, text)
    if draw then
        if text:find('{FFCC99}Рабочее место:(.+){ffffff}'..mynick) and dist == 4.25 then
            carPos.x = pos.x
            carPos.y = pos.y
            carPos.z = pos.z
        end
    end
end
function sampev.onSendCommand(cmd) if cmd:find('^/draw menu') then dialogSettings:run()elseif cmd:find('^/draw') then draw = not draw; printStringNow('draw '..tostring(draw), 300)end end
function drawClickableText(font, text, posX, posY, color, colorA)
    renderFontDrawText(font, text, posX, posY, color)
    local textLenght = renderGetFontDrawTextLength(font, text)
    local textHeight = renderGetFontDrawHeight(font)
    local curX, curY = getCursorPos()
    if curX >= posX and curX <= posX + textLenght and curY >= posY and curY <= posY + textHeight and sampTextdrawIsExists(106) then
        renderFontDrawText(font, text, posX, posY, colorA)
        if wasKeyPressed(1) then return true end
    end
end
function onWindowMessage(msg, wparam, lparam)
    if draw and not getter.active and msg == 0x101 and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and sampTextdrawIsExists(106) then
        for k, v in ipairs(buttonList) do
            if wparam == 0x30 + k then getter.start(v[3], v[4])  end
        end
    end
end