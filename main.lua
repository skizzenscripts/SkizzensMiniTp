local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- CONFIG
local MAX_POSES = 5  -- Set a maximum limit for the number of saved poses

local poseCount = 0
local positions = {}

-- Helpers
local function getHRP()
    return (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- Logo (Original size)
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0,75,0,75)  -- Original size for the logo
logo.Position = UDim2.new(0,18,0,18)
logo.Text = "TP"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 30  -- Original text size
logo.TextColor3 = Color3.fromRGB(255,170,255)
logo.BackgroundColor3 = Color3.fromRGB(18,18,18)
logo.Parent = gui
Instance.new("UICorner",logo).CornerRadius = UDim.new(0,16)

-- Glow Effect for Logo
local logoGlow = Instance.new("UIStroke", logo)
logoGlow.Thickness = 4
logoGlow.Transparency = 0.5  -- Adjust glow intensity
logoGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
logoGlow.Color = Color3.fromRGB(255, 0, 255)  -- Purple glow color

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0,300,0,300)  -- Smaller main window size
main.Position = UDim2.new(0.5,-150,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

-- Glow Effect for the UI
local uiGlow = Instance.new("UIStroke", main)
uiGlow.Thickness = 6  -- Slightly thicker glow for the UI
uiGlow.Transparency = 0.5  -- Adjust glow intensity
uiGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiGlow.Color = Color3.fromRGB(255, 0, 255)  -- Purple glow color

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)  -- Smaller size for title
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Skizzen's mini TP"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14  -- Smaller text size
titleLabel.TextColor3 = Color3.fromRGB(255,170,255)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = main

-- Content Frame
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,10,0,55)  -- Adjusted position for content
content.Size = UDim2.new(1,-20,1,-75)  -- Adjusted size
content.BackgroundTransparency = 1

local tpFrame = Instance.new("Frame",content)
tpFrame.Size = UDim2.new(1,0,1,0)
tpFrame.BackgroundTransparency = 1

local tpLayout = Instance.new("UIListLayout", tpFrame)
tpLayout.Padding = UDim.new(0,4)  -- Smaller padding

-- Create Position Box
local function createPositionBox(i)
    local box = Instance.new("Frame", tpFrame)
    box.Size = UDim2.new(1, 0, 0, 35)  -- Smaller box size
    box.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", box)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = "XPosition " .. i
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10  -- Smaller text size
    label.TextColor3 = Color3.fromRGB(255,170,255)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0.05, 0, 0, 0)

    local function makeBtn(txt, x)
        local b = Instance.new("TextButton", box)
        b.Size = UDim2.new(0, 40, 0, 20)  -- Smaller button size
        b.Position = UDim2.new(x, 0, 0.5, -10)
        b.Text = txt
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9  -- Smaller text size for buttons
        b.BackgroundColor3 = Color3.fromRGB(45,0,70)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end

    local save = makeBtn("Save", 0.6)
    local tp = makeBtn("TP", 0.78)

    save.MouseButton1Click:Connect(function()
        positions[i] = getHRP().CFrame
    end)

    tp.MouseButton1Click:Connect(function()
        if positions[i] then
            -- Teleport to saved position
            getHRP().CFrame = positions[i]
        end
    end)
end

-- Initialize with 1 position box when the UI is opened
poseCount = 1
createPositionBox(poseCount)

-- Add Button to create new position box
local addBtn = Instance.new("TextButton", tpFrame)
addBtn.Size = UDim2.new(0, 26, 0, 26)  -- Smaller size for add button
addBtn.Text = "+"
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 14  -- Smaller text size
addBtn.BackgroundColor3 = Color3.fromRGB(55,0,80)
addBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(1, 0)

addBtn.MouseButton1Click:Connect(function()
    if poseCount >= MAX_POSES then return end
    poseCount += 1
    createPositionBox(poseCount)
    if poseCount >= MAX_POSES then addBtn.Visible = false end
end)

-- Create Teleport to Sequence Button (Placed above first position)
local tpSequenceBtn = Instance.new("TextButton", tpFrame)
tpSequenceBtn.Size = UDim2.new(0, 120, 0, 26)  -- Adjust the size for the sequence button
tpSequenceBtn.Position = UDim2.new(0, 80, 0, -30)  -- Positioned above the first position tab
tpSequenceBtn.Text = "Auto Tp⚡"
tpSequenceBtn.Font = Enum.Font.GothamBold
tpSequenceBtn.TextSize = 12  -- Text size for the button
tpSequenceBtn.BackgroundColor3 = Color3.fromRGB(55,0,80)
tpSequenceBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpSequenceBtn).CornerRadius = UDim.new(0, 8)

tpSequenceBtn.MouseButton1Click:Connect(function()
    -- Loop through the saved positions in reverse order and teleport to each one
    for i = poseCount, 1, -1 do  -- Start from the last position (poseCount) to the first (1)
        if positions[i] then
            -- Wait for a short duration between teleports to make it smooth
            wait(0.2)  -- 0.2 second delay between teleports
            getHRP().CFrame = positions[i]
        end
    end
end)

-- Open GUI
logo.MouseButton1Click:Connect(function()
    logo.Visible = false
    main.Visible = true
    main.Size = UDim2.new(0, 300, 0, 300)  -- Adjusted size when opening
end)

-- Minimize Button (_)
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 22, 0, 22)  -- Minimize button size
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

-- Close Button (Original size)
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 22, 0, 22)  -- Original size for close button
closeBtn.Position = UDim2.new(1, -28, 0, 8)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12  -- Original text size
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
