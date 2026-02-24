local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local MAX_POSES = 5

local poseCount = 0
local positions = {}
local orbs = {}

local function getHRP()
    return (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
end

-- Create orb at saved position with text background
local function createOrb(i, cframe)
    if orbs[i] then
        orbs[i]:Destroy()
        orbs[i] = nil
    end

    local orb = Instance.new("Part")
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(2,2,2)
    orb.Material = Enum.Material.Neon
    orb.Color = Color3.fromRGB(255, 0, 255)
    orb.Anchored = true
    orb.CanCollide = false
    orb.CFrame = cframe
    orb.Name = "SavedOrb_" .. i
    orb.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = false
    billboard.Parent = orb

    -- Background Frame for text visibility
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 0
    bg.Parent = billboard

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,170,255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard

    game:GetService("RunService").RenderStepped:Connect(function()
        if orb and orb.Parent then
            local hrp = getHRP()
            local dist = (hrp.Position - orb.Position).Magnitude
            text.Text = "Pos #" .. i .. "\n" .. math.floor(dist) .. " studs"
        end
    end)

    orbs[i] = orb
end

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0,75,0,75)
logo.Position = UDim2.new(0,18,0,18)
logo.Text = "TP"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 30
logo.TextColor3 = Color3.fromRGB(255,170,255)
logo.BackgroundColor3 = Color3.fromRGB(18,18,18)
logo.Parent = gui
Instance.new("UICorner",logo).CornerRadius = UDim.new(0,16)

local logoGlow = Instance.new("UIStroke", logo)
logoGlow.Thickness = 4
logoGlow.Transparency = 0.5
logoGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
logoGlow.Color = Color3.fromRGB(255, 0, 255)

local main = Instance.new("Frame")
main.Size = UDim2.new(0,300,0,300)
main.Position = UDim2.new(0.5,-150,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

local uiGlow = Instance.new("UIStroke", main)
uiGlow.Thickness = 6
uiGlow.Transparency = 0.5
uiGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiGlow.Color = Color3.fromRGB(255, 0, 255)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Skizzen's mini TP"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextColor3 = Color3.fromRGB(255,170,255)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = main

local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,10,0,55)
content.Size = UDim2.new(1,-20,1,-75)
content.BackgroundTransparency = 1

local tpFrame = Instance.new("Frame",content)
tpFrame.Size = UDim2.new(1,0,1,0)
tpFrame.BackgroundTransparency = 1

local tpLayout = Instance.new("UIListLayout", tpFrame)
tpLayout.Padding = UDim.new(0,4)

local function createPositionBox(i)
    local box = Instance.new("Frame", tpFrame)
    box.Size = UDim2.new(1, 0, 0, 35)
    box.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", box)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = "XPosition " .. i
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(255,170,255)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0.05, 0, 0, 0)

    local function makeBtn(txt, x)
        local b = Instance.new("TextButton", box)
        b.Size = UDim2.new(0, 40, 0, 20)
        b.Position = UDim2.new(x, 0, 0.5, -10)
        b.Text = txt
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9
        b.BackgroundColor3 = Color3.fromRGB(45,0,70)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end

    local save = makeBtn("Save", 0.6)
    local tp = makeBtn("TP", 0.78)

    save.MouseButton1Click:Connect(function()
        local cf = getHRP().CFrame
        positions[i] = cf
        createOrb(i, cf)
    end)

    tp.MouseButton1Click:Connect(function()
        if positions[i] then
            getHRP().CFrame = positions[i]
        end
    end)
end

poseCount = 1
createPositionBox(poseCount)

local addBtn = Instance.new("TextButton", tpFrame)
addBtn.Size = UDim2.new(0, 26, 0, 26)
addBtn.Text = "+"
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 14
addBtn.BackgroundColor3 = Color3.fromRGB(55,0,80)
addBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(1, 0)

addBtn.MouseButton1Click:Connect(function()
    if poseCount >= MAX_POSES then return end
    poseCount += 1
    createPositionBox(poseCount)
    if poseCount >= MAX_POSES then addBtn.Visible = false end
end)

local tpSequenceBtn = Instance.new("TextButton", tpFrame)
tpSequenceBtn.Size = UDim2.new(0, 120, 0, 26)
tpSequenceBtn.Position = UDim2.new(0, 80, 0, -30)
tpSequenceBtn.Text = "Auto Tp⚡"
tpSequenceBtn.Font = Enum.Font.GothamBold
tpSequenceBtn.TextSize = 12
tpSequenceBtn.BackgroundColor3 = Color3.fromRGB(55,0,80)
tpSequenceBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpSequenceBtn).CornerRadius = UDim.new(0, 8)

tpSequenceBtn.MouseButton1Click:Connect(function()
    for i = poseCount, 1, -1 do
        if positions[i] then
            wait(0.2)
            getHRP().CFrame = positions[i]
        end
    end
end)

logo.MouseButton1Click:Connect(function()
    logo.Visible = false
    main.Visible = true
    main.Size = UDim2.new(0, 300, 0, 300)
end)

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -55, 0, 8)
minBtn.Text = "_"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 12
minBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 70)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    logo.Visible = true
end)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 8)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
