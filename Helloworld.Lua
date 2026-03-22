--[[
    ╔══════════════════════════════════════════╗
    ║         H4LL0 W0RLD HUB                 ║
    ║      Rivals & Universal  •  v2.0        ║
    ║         Fixed & Optimized               ║
    ╚══════════════════════════════════════════╝
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

local C = {
    BG_Main    = Color3.fromRGB(8,   3,  3),
    BG_Side    = Color3.fromRGB(15,  5,  5),
    BG_Content = Color3.fromRGB(18,  6,  6),
    BG_Card    = Color3.fromRGB(25,  8,  8),
    Accent     = Color3.fromRGB(180, 20, 20),
    AccentDim  = Color3.fromRGB(100, 10, 10),
    AccentGlow = Color3.fromRGB(220, 40, 40),
    ON         = Color3.fromRGB(200, 30, 30),
    OFF        = Color3.fromRGB(45,  15, 15),
    TextMain   = Color3.fromRGB(220, 180, 180),
    TextSub    = Color3.fromRGB(150, 100, 100),
    TextDim    = Color3.fromRGB(80,  50,  50),
    Border     = Color3.fromRGB(80,  20,  20),
    Blood      = Color3.fromRGB(140, 10,  10),
    Green      = Color3.fromRGB(50,  200, 120),
}

local Toggles = {
    SpeedHack  = false,
    Fly        = false,
    ESP        = false,
    Aimbot     = false,
    WallCheck  = false,
    NoClip     = false,
    InfJump    = false,
}

local Connections = {}
local Minimized   = false
local VALID_KEY   = "Hello_world_code"

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Corner(p, r)
    return New("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p)
end

local function Stroke(p, col, th)
    return New("UIStroke", {Color = col or C.Border, Thickness = th or 1}, p)
end

local function Tween(obj, props, t)
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quart), props):Play()
    end)
end

local function StopAll()
    for k, c in pairs(Connections) do
        pcall(function() c:Disconnect() end)
        Connections[k] = nil
    end
end

local function GetChar()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, hrp, hum
end

local function ApplyFeature(key, val)
    local char, hrp, hum = GetChar()
    if not char then return end

    if key == "SpeedHack" then
        if hum then hum.WalkSpeed = val and 60 or 16 end

    elseif key == "InfJump" then
        if val then
            Connections.InfJump = UserInputService.JumpRequest:Connect(function()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if Connections.InfJump then
                pcall(function() Connections.InfJump:Disconnect() end)
                Connections.InfJump = nil
            end
        end

    elseif key == "Fly" then
        if val then
            pcall(function()
                local bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
                bg.P = 1e4
                bg.Parent = hrp
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.zero
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                bv.Parent = hrp
                Connections.Fly = RunService.Heartbeat:Connect(function()
                    local cam = workspace.CurrentCamera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        bv.Velocity = cam.CFrame.LookVector * 40
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        bv.Velocity = -cam.CFrame.LookVector * 40
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        bv.Velocity = Vector3.new(0,40,0)
                    else
                        bv.Velocity = Vector3.zero
                    end
                    bg.CFrame = cam.CFrame
                end)
            end)
        else
            if Connections.Fly then
                pcall(function() Connections.Fly:Disconnect() end)
                Connections.Fly = nil
            end
            if hrp then
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end

    elseif key == "NoClip" then
        if val then
            Connections.NoClip = RunService.Stepped:Connect(function()
                local c = LocalPlayer.Character
                if c then
                    for _, p in ipairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then
                            pcall(function() p.CanCollide = false end)
                        end
                    end
                end
            end)
        else
            if Connections.NoClip then
                pcall(function() Connections.NoClip:Disconnect() end)
                Connections.NoClip = nil
            end
        end

    elseif key == "ESP" then
        if val then
            Connections.ESP = RunService.Heartbeat:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root and not root:FindFirstChild("ESP_BB") then
                            pcall(function()
                                local bb = New("BillboardGui", {
                                    Name = "ESP_BB",
                                    Size = UDim2.new(0,80,0,22),
                                    StudsOffset = Vector3.new(0,3,0),
                                    AlwaysOnTop = true,
                                }, root)
                                New("TextLabel", {
                                    Size = UDim2.new(1,0,1,0),
                                    BackgroundTransparency = 1,
                                    Text = plr.Name,
                                    TextColor3 = C.AccentGlow,
                                    TextSize = 12,
                                    Font = Enum.Font.GothamBold,
                                }, bb)
                            end)
                        end
                    end
                end
            end)
        else
            if Connections.ESP then
                pcall(function() Connections.ESP:Disconnect() end)
                Connections.ESP = nil
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local bb = root:FindFirstChild("ESP_BB")
                        if bb then pcall(function() bb:Destroy() end) end
                    end
                end
            end
        end

    elseif key == "Aimbot" then
        if val then
            Connections.Aimbot = RunService.Heartbeat:Connect(function()
                local cam = workspace.CurrentCamera
                local closest, dist = nil, math.huge
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local head = plr.Character:FindFirstChild("Head")
                        if head then
                            local d = (head.Position - cam.CFrame.Position).Magnitude
                            if d < dist then dist = d; closest = head end
                        end
                    end
                end
                if closest then
                    pcall(function()
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, closest.Position)
                    end)
                end
            end)
        else
            if Connections.Aimbot then
                pcall(function() Connections.Aimbot:Disconnect() end)
                Connections.Aimbot = nil
            end
        end
    end
end

-- ═══════════════════════════
--        KEY SCREEN
-- ═══════════════════════════
local GUI = New("ScreenGui", {
    Name = "H4ll0W0rldHub",
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, game.CoreGui)

local KeyScreen = New("Frame", {
    Size = UDim2.new(1,0,1,0),
    BackgroundColor3 = C.BG_Main,
    BorderSizePixel = 0,
}, GUI)

-- Blood drips deco
for i = 1, 12 do
    local drip = New("Frame", {
        Size = UDim2.new(0,math.random(3,8),0,math.random(20,80)),
        Position = UDim2.new(math.random(),0,0,0),
        BackgroundColor3 = C.Blood,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
    }, KeyScreen)
    Corner(drip, 3)
end

local flickLbl = New("TextLabel", {
    Size = UDim2.new(0,90,0,90),
    Position = UDim2.new(0.5,-45,0.1,0),
    BackgroundTransparency = 1,
    Text = "💀", TextSize = 68,
    Font = Enum.Font.GothamBold,
}, KeyScreen)

New("TextLabel", {
    Size = UDim2.new(0,400,0,44),
    Position = UDim2.new(0.5,-200,0.3,0),
    BackgroundTransparency = 1,
    Text = "H4LL0 W0RLD HUB",
    TextColor3 = C.Accent,
    TextSize = 28,
    Font = Enum.Font.GothamBold,
}, KeyScreen)

New("TextLabel", {
    Size = UDim2.new(0,400,0,24),
    Position = UDim2.new(0.5,-200,0.4,0),
    BackgroundTransparency = 1,
    Text = "ENTER KEY TO CONTINUE",
    TextColor3 = C.TextSub,
    TextSize = 12,
    Font = Enum.Font.Gotham,
}, KeyScreen)

local KBG = New("Frame", {
    Size = UDim2.new(0,340,0,32),
    Position = UDim2.new(0.5,-170,0.5,0),
    BackgroundColor3 = C.BG_Card,
    BorderSizePixel = 0,
}, KeyScreen)
Corner(KBG, 8); Stroke(KBG, C.Border, 1.5)

local KInput = New("TextBox", {
    Size = UDim2.new(1,-14,1,0),
    Position = UDim2.new(0,10,0,0),
    BackgroundTransparency = 1,
    PlaceholderText = "💀  Enter key...",
    PlaceholderColor3 = C.TextDim,
    Text = "",
    TextColor3 = C.TextMain,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    ClearTextOnFocus = false,
}, KBG)

local DiscordBtn = New("TextButton", {
    Size = UDim2.new(0,130,0,28),
    Position = UDim2.new(0.5,-170,0.62,0),
    BackgroundColor3 = C.AccentDim,
    Text = "💬 Get Key (Discord)",
    TextColor3 = C.TextMain,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
}, KeyScreen)
Corner(DiscordBtn, 7); Stroke(DiscordBtn, C.Border, 1)

local PasteBtn = New("TextButton", {
    Size = UDim2.new(0,72,0,28),
    Position = UDim2.new(0.5,-32,0.62,0),
    BackgroundColor3 = C.BG_Card,
    Text = "📋 Paste",
    TextColor3 = C.TextMain,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
}, KeyScreen)
Corner(PasteBtn, 7); Stroke(PasteBtn, C.Border, 1)

local EnterBtn = New("TextButton", {
    Size = UDim2.new(0,72,0,28),
    Position = UDim2.new(0.5,48,0.62,0),
    BackgroundColor3 = C.Accent,
    Text = "▶ Enter",
    TextColor3 = Color3.fromRGB(255,200,200),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
}, KeyScreen)
Corner(EnterBtn, 7)

local KStatus = New("TextLabel", {
    Size = UDim2.new(0,340,0,22),
    Position = UDim2.new(0.5,-170,0.7,0),
    BackgroundTransparency = 1,
    Text = "Enter key to proceed...",
    TextColor3 = C.TextDim,
    TextSize = 11,
    Font = Enum.Font.Gotham,
}, KeyScreen)

-- Skull flicker
task.spawn(function()
    while flickLbl and flickLbl.Parent do
        task.wait(math.random(2,5))
        for _ = 1, 2 do
            flickLbl.TextTransparency = 0.7
            task.wait(0.08)
            flickLbl.TextTransparency = 0
            task.wait(0.08)
        end
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/xCV9Tf4y5N") end)
    DiscordBtn.Text = "✓ Copied!"
    DiscordBtn.BackgroundColor3 = C.Green
    task.wait(2)
    DiscordBtn.Text = "💬 Get Key (Discord)"
    DiscordBtn.BackgroundColor3 = C.AccentDim
end)

PasteBtn.MouseButton1Click:Connect(function()
    local ok, cb = pcall(getclipboard)
    if ok and cb and cb ~= "" then KInput.Text = cb end
end)

-- ═══════════════════════════
--        MAIN GUI
-- ═══════════════════════════
local function BuildMain()
    KeyScreen:Destroy()

    local Win = New("Frame", {
        Size = UDim2.new(0,560,0,400),
        Position = UDim2.new(0.5,-280,0.5,-200),
        BackgroundColor3 = C.BG_Main,
        BorderSizePixel = 0,
        Active = true,
    }, GUI)
    Corner(Win, 12); Stroke(Win, C.Blood, 1.5)

    -- Drag
    local drag, dStart, dPos = false, nil, nil
    Win.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; dStart = i.Position; dPos = Win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dStart
            Win.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset+d.X,
                                     dPos.Y.Scale, dPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)

    -- TopBar
    local Top = New("Frame", {
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = C.BG_Side,
        BorderSizePixel = 0, ZIndex = 5,
    }, Win)
    Corner(Top, 12)
    New("Frame", {
        Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
        BackgroundColor3 = C.BG_Side, BorderSizePixel = 0, ZIndex = 4,
    }, Top)
    New("TextLabel", {
        Size = UDim2.new(0,30,1,0), Position = UDim2.new(0,8,0,0),
        BackgroundTransparency = 1, Text = "💀", TextSize = 20, ZIndex = 6,
    }, Top)
    New("TextLabel", {
        Size = UDim2.new(0,260,1,0), Position = UDim2.new(0,40,0,0),
        BackgroundTransparency = 1, Text = "H4ll0 W0rld Hub",
        TextColor3 = C.Accent, TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 6,
    }, Top)

    local MinBtn = New("TextButton", {
        Size = UDim2.new(0,26,0,20), Position = UDim2.new(1,-60,0.5,-10),
        BackgroundColor3 = C.BG_Card, Text = "─",
        TextColor3 = C.TextMain, TextSize = 13,
        Font = Enum.Font.GothamBold, BorderSizePixel = 0, ZIndex = 6,
    }, Top)
    Corner(MinBtn, 5)

    local CloseBtn = New("TextButton", {
        Size = UDim2.new(0,26,0,20), Position = UDim2.new(1,-28,0.5,-10),
        BackgroundColor3 = C.Blood, Text = "✕",
        TextColor3 = Color3.fromRGB(255,200,200), TextSize = 12,
        Font = Enum.Font.GothamBold, BorderSizePixel = 0, ZIndex = 6,
    }, Top)
    Corner(CloseBtn, 5)

    CloseBtn.MouseButton1Click:Connect(function()
        StopAll()
        Tween(Win, {Size = UDim2.new(0,560,0,0)}, 0.3)
        task.wait(0.35); GUI:Destroy()
    end)
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(Win, {Size = UDim2.new(0,560,0,40)}, 0.3)
            MinBtn.Text = "□"
        else
            Tween(Win, {Size = UDim2.new(0,560,0,400)}, 0.3)
            MinBtn.Text = "─"
        end
    end)

    -- Content
    local CH = New("Frame", {
        Size = UDim2.new(1,0,1,-40), Position = UDim2.new(0,0,0,40),
        BackgroundTransparency = 1, ClipsDescendants = true,
    }, Win)

    local Side = New("Frame", {
        Size = UDim2.new(0,130,1,0),
        BackgroundColor3 = C.BG_Side, BorderSizePixel = 0,
    }, CH)
    Stroke(Side, C.Border, 1)
    New("UIListLayout", {Padding = UDim.new(0,4)}, Side)
    New("UIPadding", {
        PaddingTop = UDim.new(0,8),
        PaddingLeft = UDim.new(0,6),
        PaddingRight = UDim.new(0,6),
    }, Side)

    local CA = New("Frame", {
        Size = UDim2.new(1,-130,1,0), Position = UDim2.new(0,130,0,0),
        BackgroundColor3 = C.BG_Content, BorderSizePixel = 0,
        ClipsDescendants = true,
    }, CH)
    New("UIPadding", {PaddingAll = UDim.new(0,10)}, CA)

    local Pages, TabBtns = {}, {}

    local function MakePage(name)
        local pg = New("ScrollingFrame", {
            Name = name, Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = C.Accent,
            CanvasSize = UDim2.new(0,0,0,0), Visible = false,
        }, CA)
        local ll = New("UIListLayout", {Padding = UDim.new(0,6)}, pg)
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pg.CanvasSize = UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+16)
        end)
        Pages[name] = pg
        return pg
    end

    local function SetTab(name)
        for n, pg in pairs(Pages) do pg.Visible = (n==name) end
        for n, btn in pairs(TabBtns) do
            if n == name then
                Tween(btn, {BackgroundColor3 = C.AccentDim}, 0.2)
                btn.BackgroundTransparency = 0
                btn.TextColor3 = C.Accent
            else
                btn.BackgroundTransparency = 1
                btn.TextColor3 = C.TextSub
            end
        end
    end

    for _, t in ipairs({{"Combat","💀"},{"Movement","👟"},{"Visual","👁"},{"Settings","⚙"}}) do
        MakePage(t[1])
        local btn = New("TextButton", {
            Size = UDim2.new(1,0,0,32),
            BackgroundTransparency = 1,
            BackgroundColor3 = C.BG_Side,
            Text = t[2].."  "..t[1],
            TextColor3 = C.TextSub,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 12, Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
        }, Side)
        Corner(btn, 7)
        New("UIPadding", {PaddingLeft = UDim.new(0,8)}, btn)
        TabBtns[t[1]] = btn
        btn.MouseButton1Click:Connect(function() SetTab(t[1]) end)
    end

    local function Section(parent, txt)
        local f = New("Frame", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1}, parent)
        New("TextLabel", {
            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text="  ▸  "..txt, TextColor3=C.Accent,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextSize=10, Font=Enum.Font.GothamBold,
        }, f)
    end

    local function Toggle(parent, label, key, desc)
        local card = New("Frame", {
            Size = UDim2.new(1,0,0, desc and 52 or 40),
            BackgroundColor3 = C.BG_Card, BorderSizePixel = 0,
        }, parent)
        Corner(card, 8); Stroke(card, C.Border, 1)

        New("TextLabel", {
            Size=UDim2.new(1,-70,0,20), Position=UDim2.new(0,10,0,5),
            BackgroundTransparency=1, Text=label,
            TextColor3=C.TextMain, TextXAlignment=Enum.TextXAlignment.Left,
            TextSize=12, Font=Enum.Font.GothamBold,
        }, card)

        if desc then
            New("TextLabel", {
                Size=UDim2.new(1,-70,0,16), Position=UDim2.new(0,10,0,26),
                BackgroundTransparency=1, Text=desc,
                TextColor3=C.TextDim, TextXAlignment=Enum.TextXAlignment.Left,
                TextSize=10, Font=Enum.Font.Gotham,
            }, card)
        end

        local tb = New("TextButton", {
            Size=UDim2.new(0,46,0,22), Position=UDim2.new(1,-54,0.5,-11),
            BackgroundColor3=C.OFF, Text="", BorderSizePixel=0,
        }, card)
        Corner(tb, 11)

        local circ = New("Frame", {
            Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,3,0.5,-8),
            BackgroundColor3=Color3.fromRGB(255,220,220), BorderSizePixel=0,
        }, tb)
        Corner(circ, 8)

        tb.MouseButton1Click:Connect(function()
            Toggles[key] = not Toggles[key]
            Tween(tb, {BackgroundColor3 = Toggles[key] and C.ON or C.OFF}, 0.2)
            Tween(circ, {Position = Toggles[key] and UDim2.new(0,27,0.5,-8) or UDim2.new(0,3,0.5,-8)}, 0.2)
            pcall(function() ApplyFeature(key, Toggles[key]) end)
        end)
    end

    -- ── Combat ──
    local CP = Pages["Combat"]
    Section(CP, "COMBAT")
    Toggle(CP, "Aimbot",    "Aimbot",    "Auto aim ke kepala musuh terdekat")
    Toggle(CP, "WallCheck", "WallCheck", "Cek musuh di balik tembok")
    Section(CP, "UTILITY")
    Toggle(CP, "NoClip",    "NoClip",    "Jalan menembus tembok")

    -- ── Movement ──
    local MP = Pages["Movement"]
    Section(MP, "MOVEMENT")
    Toggle(MP, "Speed Hack", "SpeedHack", "WalkSpeed 16 → 60")
    Toggle(MP, "Fly",        "Fly",       "Terbang bebas (W/S/Space)")
    Toggle(MP, "Inf Jump",   "InfJump",   "Loncat tanpa batas")
    Section(MP, "TELEPORT")

    local tpCard = New("Frame", {
        Size=UDim2.new(1,0,0,40), BackgroundColor3=C.BG_Card, BorderSizePixel=0,
    }, MP)
    Corner(tpCard, 8); Stroke(tpCard, C.Border, 1)
    New("TextLabel", {
        Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1, Text="💀 Teleport to Spawn",
        TextColor3=C.TextMain, TextXAlignment=Enum.TextXAlignment.Left,
        TextSize=12, Font=Enum.Font.GothamBold,
    }, tpCard)
    local tpBtn = New("TextButton", {
        Size=UDim2.new(0,62,0,24), Position=UDim2.new(1,-72,0.5,-12),
        BackgroundColor3=C.Accent, Text="Teleport",
        TextColor3=Color3.fromRGB(255,200,200),
        TextSize=11, Font=Enum.Font.GothamBold, BorderSizePixel=0,
    }, tpCard)
    Corner(tpBtn, 6)
    tpBtn.MouseButton1Click:Connect(function()
        local _, hrp, _ = GetChar()
        if hrp then
            hrp.CFrame = CFrame.new(0,10,0)
            tpBtn.Text = "✓ Done"
            tpBtn.BackgroundColor3 = C.Green
            task.wait(1.5)
            tpBtn.Text = "Teleport"
            tpBtn.BackgroundColor3 = C.Accent
        end
    end)

    -- ── Visual ──
    local VP = Pages["Visual"]
    Section(VP, "VISUAL")
    Toggle(VP, "ESP", "ESP", "Highlight nama player di map")

    -- ── Settings ──
    local SETP = Pages["Settings"]
    Section(SETP, "ABOUT")
    local about = New("Frame", {
        Size=UDim2.new(1,0,0,90), BackgroundColor3=C.BG_Card, BorderSizePixel=0,
    }, SETP)
    Corner(about, 8); Stroke(about, C.Blood, 1.5)
    New("TextLabel", {
        Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,
        Text="💀  H4ll0 W0rld Hub  v2.0\nGame  :  Rivals & Universal\nDiscord: discord.gg/xCV9Tf4y5N",
        TextColor3=C.TextSub, TextXAlignment=Enum.TextXAlignment.Left,
        TextSize=11, TextWrapped=true, Font=Enum.Font.Gotham,
    }, about)

    local stopBtn = New("TextButton", {
        Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Blood,
        Text="⛔  Stop All Features",
        TextColor3=Color3.fromRGB(255,200,200),
        TextSize=12, Font=Enum.Font.GothamBold, BorderSizePixel=0,
    }, SETP)
    Corner(stopBtn, 8)
    stopBtn.MouseButton1Click:Connect(function()
        StopAll()
        for k in pairs(Toggles) do Toggles[k] = false end
        stopBtn.Text = "✅ All Features Stopped"
        task.wait(2)
        stopBtn.Text = "⛔  Stop All Features"
    end)

    SetTab("Combat")
end

-- ═══════════════════════════
--      KEY VALIDATION
-- ═══════════════════════════
EnterBtn.MouseButton1Click:Connect(function()
    if KInput.Text == VALID_KEY then
        KStatus.Text = "✅ Key Valid! Loading..."
        KStatus.TextColor3 = C.Green
        for _, obj in ipairs(KeyScreen:GetDescendants()) do
            pcall(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    Tween(obj, {TextTransparency=1}, 0.3)
                end
                if obj:IsA("Frame") then
                    Tween(obj, {BackgroundTransparency=1}, 0.3)
                end
            end)
        end
        Tween(KeyScreen, {BackgroundTransparency=1}, 0.3)
        task.wait(0.5)
        BuildMain()
    else
        KStatus.Text = "❌ Key salah! Join Discord untuk key."
        KStatus.TextColor3 = C.Accent
        Tween(KBG, {BackgroundColor3=Color3.fromRGB(40,8,8)}, 0.2)
        task.wait(0.3)
        Tween(KBG, {BackgroundColor3=C.BG_Card}, 0.2)
    end
end)
