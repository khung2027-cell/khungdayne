-- Khởi tạo Thư viện UI Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "99 Night Script | TikTok: khungkhongxinh",
   LoadingTitle = "Đang tải Menu...",
   LoadingSubtitle = "by khungkhongxinh",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "99NightConfig",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- Thiết lập phím tắt tắt/mở Menu là chữ K
Rayfield.NormalizeToggleKey = Enum.KeyCode.K

------------------------------------------------------------------------
-- Biến lưu trữ cấu hình (Variables)
------------------------------------------------------------------------
local KillAuraEnabled = false
local KillAuraRange = 10

local TreeAuraEnabled = false
local TreeAuraRange = 10

local WalkSpeedEnabled = false
local CustomSpeed = 16

local JumpPowerEnabled = false
local CustomJump = 50

local ESPPlayerEnabled = false
local ESPPlayerRange = 500

local ESPChestEnabled = false
local ESPChestRange = 500

local LocalPlayer = game.Players.LocalPlayer

------------------------------------------------------------------------
-- TAB 1: MAIN
------------------------------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458) -- Icon ID

MainTab:CreateSection("Kill Aura")

MainTab:CreateToggle({
   Name = "Bật Kill Aura",
   CurrentValue = false,
   Flag = "KillAuraToggle",
   Callback = function(Value)
      KillAuraEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Khoảng cách Kill Aura",
   Range = {5, 50},
   Increment = 1,
   Suffix = "m",
   CurrentValue = 10,
   Flag = "KillAuraRangeSlider",
   Callback = function(Value)
      KillAuraRange = Value
   end,
})

MainTab:CreateSection("Tree Aura")

MainTab:CreateToggle({
   Name = "Bật Tree Aura (Chặt cây tự động)",
   CurrentValue = false,
   Flag = "TreeAuraToggle",
   Callback = function(Value)
      TreeAuraEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Khoảng cách Tree Aura",
   Range = {5, 50},
   Increment = 1,
   Suffix = "m",
   CurrentValue = 10,
   Flag = "TreeAuraRangeSlider",
   Callback = function(Value)
      TreeAuraRange = Value
   end,
})

------------------------------------------------------------------------
-- TAB 2: SPEED
------------------------------------------------------------------------
local SpeedTab = Window:CreateTab("Speed & Jump", 4483362458)

SpeedTab:CreateSection("Tốc độ di chuyển")

SpeedTab:CreateToggle({
   Name = "Kích hoạt Siêu Tốc",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      WalkSpeedEnabled = Value
   end,
})

SpeedTab:CreateSlider({
   Name = "Chỉnh Tốc độ",
   Range = {16, 200},
   Increment = 1,
   Suffix = " Tốc độ",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      CustomSpeed = Value
   end,
})

SpeedTab:CreateSection("Sức bật (Nhảy)")

SpeedTab:CreateToggle({
   Name = "Kích hoạt Nhảy Cao",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(Value)
      JumpPowerEnabled = Value
   end,
})

SpeedTab:CreateSlider({
   Name = "Chỉnh Sức Bật",
   Range = {50, 300},
   Increment = 5,
   Suffix = " Lực",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      CustomJump = Value
   end,
})

------------------------------------------------------------------------
-- TAB 3: ESP
------------------------------------------------------------------------
local EspTab = Window:CreateTab("ESP", 4483362458)

EspTab:CreateSection("ESP Người chơi")

EspTab:CreateToggle({
   Name = "Bật ESP Player",
   CurrentValue = false,
   Flag = "ESPPlayerToggle",
   Callback = function(Value)
      ESPPlayerEnabled = Value
   end,
})

EspTab:CreateSlider({
   Name = "Khoảng cách thấy Player",
   Range = {50, 2000},
   Increment = 50,
   Suffix = "m",
   CurrentValue = 500,
   Flag = "ESPPlayerRangeSlider",
   Callback = function(Value)
      ESPPlayerRange = Value
   end,
})

EspTab:CreateSection("ESP Rương (Chest)")

EspTab:CreateToggle({
   Name = "Bật ESP Chest",
   CurrentValue = false,
   Flag = "ESPChestToggle",
   Callback = function(Value)
      ESPChestEnabled = Value
   end,
})

EspTab:CreateSlider({
   Name = "Khoảng cách thấy Chest",
   Range = {50, 2000},
   Increment = 50,
   Suffix = "m",
   CurrentValue = 500,
   Flag = "ESPChestRangeSlider",
   Callback = function(Value)
      ESPChestRange = Value
   end,
})


------------------------------------------------------------------------
-- HỆ THỐNG VÒNG LẶP XỬ LÝ CHỨC NĂNG (LOGIC LOOPS)
------------------------------------------------------------------------

-- 1. Loop cho Speed và Jump
---
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                if WalkSpeedEnabled then
                    Humanoid.WalkSpeed = CustomSpeed
                else
                    Humanoid.WalkSpeed = 16 -- Tốc độ mặc định
                end
                
                if JumpPowerEnabled then
                    Humanoid.UseJumpPower = true
                    Humanoid.JumpPower = CustomJump
                else
                    Humanoid.JumpPower = 50 -- Sức bật mặc định
                end
            end
        end)
    end
end)

-- 2. Loop cho Kill Aura và Tree Aura
---
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local Character = LocalPlayer.Character
            local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            if not RootPart then return end

            -- Logic Kill Aura (Tìm quái vật / kẻ địch gần nhất)
            if KillAuraEnabled then
                for _, v in pairs(workspace:GetChildren()) do
                    -- Bạn cần đổi tên "Enemy" hoặc "Mob" theo đúng cấu trúc của game 99 Night
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
                        local EnemyRoot = v.HumanoidRootPart
                        local Distance = (RootPart.Position - EnemyRoot.Position).Magnitude
                        if Distance <= KillAuraRange and v.Humanoid.Health > 0 then
                            -- Gửi tín hiệu tấn công lên Server (Cần chỉnh sửa RemoteEvent cho đúng game)
                            -- Ví dụ: game:GetService("ReplicatedStorage").Remotes.Attack:FireServer(v)
                        end
                    end
                end
            end

            -- Logic Tree Aura (Tìm cây cối)
            if TreeAuraEnabled then
                for _, v in pairs(workspace:GetChildren()) do
                    -- Đổi "Tree" thành tên Model cây trong game 99 Night
                    if (v.Name:lower():find("tree") or v.Name:lower():find("cây")) and v:IsA("Model") then
                        local TreePart = v:FindFirstChildOfClass("Part") or v:FindFirstChildOfClass("MeshPart")
                        if TreePart then
                            local Distance = (RootPart.Position - TreePart.Position).Magnitude
                            if Distance <= TreeAuraRange then
                                -- Gửi tín hiệu chặt cây lên Server
                                -- Ví dụ: game:GetService("ReplicatedStorage").Remotes.ChopTree:FireServer(v)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- 3. Hệ thống ESP (Player & Chest) đơn giản sử dụng Highlight/BillboardGui
---
local function CreateESP(object, color, text, maxDist, isPlayer)
    if object:FindFirstChild("MyESP") then return end
    
    local Folder = Instance.new("Folder")
    Folder.Name = "MyESP"
    Folder.Parent = object

    -- Hiệu ứng viền phát sáng qua tường
    local Highlight = Instance.new("Highlight")
    Highlight.Parent = Folder
    Highlight.FillColor = color
    Highlight.FillTransparency = 0.5
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.Adornee = object

    -- Chữ hiển thị khoảng cách và tên
    local Billboard = Instance.new("BillboardGui")
    Billboard.Parent = Folder
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Adornee = object

    local Label = Instance.new("TextLabel")
    Label.Parent = Billboard
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = color
    Label.TextWeight = Enum.TextWeight.Bold
    Label.TextSize = 14

    task.spawn(function()
        while object and Folder and parent do
            pcall(function()
                local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local ObjRoot = object:IsA("Model") and (object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildOfClass("Part")) or object
                
                local isEnabled = isPlayer and ESPPlayerEnabled or ESPChestEnabled
                local currentMaxDist = isPlayer and ESPPlayerRange or ESPChestRange

                if MyRoot and ObjRoot and isEnabled then
                    local dist = math.floor((MyRoot.Position - ObjRoot.Position).Magnitude)
                    if dist <= currentMaxDist then
                        Highlight.Enabled = true
                        Billboard.Enabled = true
                        Label.Text = text .. " [" .. tostring(dist) .. "m]"
                    else
                        Highlight.Enabled = false
                        Billboard.Enabled = false
                    end
                else
                    Highlight.Enabled = false
                    Billboard.Enabled = false
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- Quét ESP liên tục
task.spawn(function()
    while task.wait(2) do
        -- ESP Người chơi
        if ESPPlayerEnabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESP(p.Character, Color3.fromRGB(255, 0, 0), p.Name, ESPPlayerRange, true)
                end
            end
        end

        -- ESP Rương (Chest)
        if ESPChestEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                -- Tìm các object có tên chứa chữ "chest" hoặc "rương"
                if (v.Name:lower():find("chest") or v.Name:lower():find("rương")) and (v:IsA("Model") or v:IsA("Part")) then
                    CreateESP(v, Color3.fromRGB(255, 215, 0), "Rương", ESPChestRange, false)
                end
            end
        end
    end
end)

-- Thông báo khi chạy thành công
Rayfield:Notify({
   Name = "Khởi chạy thành công!",
   Content = "Nhấn phím 'K' để Ẩn/Hiện Menu. Chúc idol Tiktok khungkhongxinh chơi game vui vẻ!",
   Duration = 5,
   Image = 4483362458,
})
