-- Join Discord pls  https://discord.gg/qVT2yR63fq
-- Piggy Page Collector Script (Made By Devnm0/DJxDevs). READ IMPORTANT NOTES BELOW/ IN CONSOLE!
-- SCRIPT WONT BE MAINTAINED MUCH ASWELL.

local allowedPlaces = {
    [5661005779] = true,
    [4623386862] = true
}

if not allowedPlaces[game.PlaceId] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Piggy Page Collector",
        Text = "Unsupported Game",
        Duration = 5
    })
    return
end
if workspace:FindFirstChild("ExecPages") then
    if workspace.ExecPages:IsA("StringValue") and workspace.ExecPages.Value == "YES" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Piggy Page Collector",
            Text = "Already Running!",
            Duration = 5
        })
        return
    end
else
    local flag = Instance.new("StringValue")
    flag.Name = "ExecPages"
    flag.Value = "YES"
    flag.Parent = workspace
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Piggy Page Collector",
    Text = "Made By Devnm0/DJxDevs. Check Console!",
    Duration = 5
})

print("")
print("")
print([[

==========================================================
     Piggy Pages AutoCollect - Made By Devnm0/DJxDevs
==========================================================

How to use:
 1 - Execute the script while in-game & Crouching
 2 - The script will automatically Look For Pages in a loaded Map
 3 - You'll be teleported to each page until all are collected
 4 - After All Pages Are Collected Your Character Is Reset 

IMPORTANT NOTES:
 - Sometimes the game may crash when you press play randomly After getting Pages
 To Fix This Just Rejoin Every Few Chapters After Pages Are Collected Or Go onto Skins Then Press Play to avoid It Crashing.

  - For Some Book 2 Maps It Won't Register You Clicking the Page. 
 To Fix This, Just Rejoin if you're on one of these maps below. The Pages Would automatically be 6/6 when rejoined. Also sometimes its just visual but you have picked it up. The Maps Are:
 - Book 2 Temple 
 - Book 2 Factory
 - Book 2 Ship
 - Book 2 Docks
 It Could also Happen On any other map But it's easily fixable just by rejoining. Contact me if further issues

 - For Some of the Maps You Might Need Noclip. The Script has one already built in but If it's Still Not collecting the Page then enable Noclip Via Infinite Yield  And if then it's still not collecting it, it's because of above issue So just rejoin

Contact :
 https://discord.gg/qVT2yR63fq
 djx_devs on Discord
 GitHub: RobloxExploitDev

==========================================================
]])

local noclip = false
RunService.Stepped:Connect(function()
    if noclip then
        local char = lp.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local function isValidCashmereFolder(folder)
    if not folder:IsA("Folder") then return false end

    local parts = {}
    for _, child in ipairs(folder:GetChildren()) do
        if not child:IsA("BasePart") or child.BrickColor.Name ~= "Cashmere" then
            return false
        end
        table.insert(parts, child)
    end

    local count = #parts
    return count >= 1 and count <= 6, parts
end


local function findCashmereFolder(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Folder") then
            local valid, parts = isValidCashmereFolder(child)
            if valid then
                return child, parts
            else
                local folder, foundParts = findCashmereFolder(child)
                if folder then return folder, foundParts end
            end
        elseif #child:GetChildren() > 0 then
            local folder, foundParts = findCashmereFolder(child)
            if folder then return folder, foundParts end
        end
    end
    return nil
end

local function processFolder(folder, parts)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    local originalPosition = hrp.CFrame

    task.wait(5)

    noclip = true

    for _, part in ipairs(parts) do
        while part and part.Parent and part:IsDescendantOf(workspace) do
            hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.2)
        end
    end

    local endTime = tick() + 2
    while tick() < endTime do
        hrp.CFrame = originalPosition
        task.wait(0.1)
    end


    noclip = false
    StarterGui:SetCore("SendNotification", {
        Title = "Page Collector",
        Text = "All Collected. Resetting...",
        Duration = 4
    })

    task.wait(5)

    hum.Health = 0
end

task.spawn(function()
    while true do
        local folder, parts = findCashmereFolder(workspace)
        if folder then
            processFolder(folder, parts)
        else
            task.wait(1)
        end
    end
end)
