--// Services
local Players = cloneref(game:GetService(\'Players\'))
local RunService = cloneref(game:GetService(\'RunService\'))
local GuiService = cloneref(game:GetService(\'GuiService\'))

--// Variables
local flags = {}
local characterposition
local lp = Players.LocalPlayer

--// Functions
FindChildOfClass = function(parent, classname)
    return parent:FindFirstChildOfClass(classname)
end

getchar = function()
    return lp.Character or lp.CharacterAdded:Wait()
end

gethrp = function()
    return getchar():WaitForChild(\'HumanoidRootPart\')
end

FindRod = function()
    if FindChildOfClass(getchar(), \'Tool\') and FindChild(FindChildOfClass(getchar(), \'Tool\'), \'values\') then
        return FindChildOfClass(getchar(), \'Tool\')
    else
        return nil
    end
end

--// UI
local library
if CheckFunc(makefolder) and (CheckFunc(isfolder) and not isfolder(\'fisch\')) then
    makefolder(\'fisch\')
end
if CheckFunc(writefile) and (CheckFunc(isfile) and not isfile(\'fisch/library.lua\')) then
    writefile(\'fisch/library.lua\', game:HttpGet(\'https://raw.githubusercontent.com/xataxell/fisch/refs/heads/main/library.lua\'))
end
if CheckFunc(loadfile) then
    library = loadfile(\'fisch/library.lua\')()
else
    library = loadstring(game:HttpGet(\'https://raw.githubusercontent.com/xataxell/fisch/refs/heads/main/library.lua\'))()
end

local Automation = library:CreateWindow(\'Automation\')
Automation:Section(\'Autofarm\')
Automation:Toggle(\'Freeze Character\', {location = flags, flag = \'freezechar\'})
Automation:Dropdown(\'Freeze Character Mode\', {location = flags, flag = \'freezecharmode\', list = {\'Rod Equipped\', \'Toggled\'}})
Automation:Toggle(\'Auto Cast\', {location = flags, flag = \'autocast\'})
Automation:Toggle(\'Auto Shake\', {location = flags, flag = \'autoshake\'})
Automation:Toggle(\'Auto Reel\', {location = flags, flag = \'autoreel\'})

--// Loops
RunService.Heartbeat:Connect(function()
    -- Autofarm
    if flags[\'freezechar\'] then
        if characterposition == nil then
            characterposition = gethrp().CFrame
        else
            gethrp().CFrame = characterposition
        end
    else
        characterposition = nil
    end

    if flags[\'autoshake\'] then
        if FindChild(lp.PlayerGui, \'shakeui\') and FindChild(lp.PlayerGui[\'shakeui\'], \'safezone\') and FindChild(lp.PlayerGui[\'shakeui\'][\'safezone\'], \'button\') then
            GuiService.SelectedObject = lp.PlayerGui[\'shakeui\'][\'safezone\'][\'button\']
            if GuiService.SelectedObject == lp.PlayerGui[\'shakeui\'][\'safezone\'][\'button\'] then
                game:GetService(\'VirtualInputManager\'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService(\'VirtualInputManager\'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end

    if flags[\'autocast\'] then
        local rod = FindRod()
        if rod ~= nil and rod[\'values\'][\'lure\'].Value <= .001 and task.wait(.5) then
            rod.events.cast:FireServer(100, 1)
        end
    end

    if flags[\'autoreel\'] then
        local rod = FindRod()
        if rod ~= nil and rod[\'values\'][\'lure\'].Value == 100 and task.wait(.5) then
            ReplicatedStorage.events.reelfinished:FireServer(100, true)
        end
    end
end)