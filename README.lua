# TDR-RioRp-Hub


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TDR Hub",
   Icon = nil,
   LoadingTitle = "TDR Hub",
   LoadingSubtitle = "por TDR",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "TDRHub"
   },

   Discord = {
      Enabled = false,
   },

   KeySystem = true,
   KeySettings = {
      Title = "TDR Hub",
      Subtitle = "Key System",
      Note = "Use a key: TDR",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"TDR"}
   }
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =============================================
-- Variáveis do sistema de carro
-- =============================================

local velocityEnabled = true
local flightEnabled = false
local flightSpeed = 1
local velocityMult = 0.025
local velocityMult2 = 0.15



-- =============================================

-- Aba de Carro

-- =============================================

local CarTab = Window:CreateTab("Carro Nitro", 4483362458)

-- Seção de Uso
local UsageSection = CarTab:CreateSection("Uso")

local VelocityToggle = CarTab:CreateToggle({
   Name = "Keybinds Ativos",
   CurrentValue = velocityEnabled,
   Flag = "VelocityEnabled",
   Callback = function(Value)
      velocityEnabled = Value
   end,
})

-- Seção de Voo
local FlightSection = CarTab:CreateSection("Voo")

local FlightToggle = CarTab:CreateToggle({
   Name = "Voo Ativado",
   CurrentValue = flightEnabled,
   Flag = "FlightEnabled",
   Callback = function(Value)
      flightEnabled = Value
   end,
})

local FlightSpeedSlider = CarTab:CreateSlider({
   Name = "Velocidade do Voo",
   Range = {1, 800},
   Increment = 1,
   Suffix = " unidades",
   CurrentValue = 100,
   Flag = "FlightSpeed",
   Callback = function(Value)
      flightSpeed = Value / 100
   end,
})

-- Seção de Aceleração
local SpeedSection = CarTab:CreateSection("Aceleração")

local VelocityMultSlider = CarTab:CreateSlider({
   Name = "Multiplicador de Velocidade",
   Range = {1, 50},
   Increment = 1,
   Suffix = " milésimos",
   CurrentValue = 25,
   Flag = "VelocityMultiplier",
   Callback = function(Value)
      velocityMult = Value / 1000
   end,
})

-- Seção de Desaceleração
local DecelerationSection = CarTab:CreateSection("Desaceleração")

local BrakeForceSlider = CarTab:CreateSlider({
   Name = "Força do Freio",
   Range = {1, 300},
   Increment = 1,
   Suffix = " milésimos",
   CurrentValue = 150,
   Flag = "BrakeForce",
   Callback = function(Value)
      velocityMult2 = Value / 1000
   end,
})

-- Seção de Molas
local SpringSection = CarTab:CreateSection("Molas")

local SpringToggle = CarTab:CreateToggle({
   Name = "Molas Visíveis",
   CurrentValue = false,
   Flag = "SpringsVisible",
   Callback = function(Value)
      local Character = LocalPlayer.Character
      if Character then
         local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
         if Humanoid then
            local SeatPart = Humanoid.SeatPart
            if SeatPart and SeatPart:IsA("VehicleSeat") then
               local Vehicle = GetVehicleFromDescendant(SeatPart)
               for _, SpringConstraint in pairs(Vehicle:GetDescendants()) do
                  if SpringConstraint:IsA("SpringConstraint") then
                     SpringConstraint.Visible = Value
                  end
               end
            end
         end
      end
   end,
})

-- Botões de ação
local ActionSection = CarTab:CreateSection("Ações Rápidas")

CarTab:CreateButton({
   Name = "🛑 Parar Veículo Imediatamente",
   Callback = function()
      if not velocityEnabled then return end
      local Character = LocalPlayer.Character
      if Character then
         local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
         if Humanoid then
            local SeatPart = Humanoid.SeatPart
            if SeatPart and SeatPart:IsA("VehicleSeat") then
               SeatPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
               SeatPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
               Rayfield:Notify({
                  Title = "🛑 Veículo Parado",
                  Content = "Velocidade zerada com sucesso",
                  Duration = 3,
                  Image = 4483362458
               })
            end
         end
      end
   end,
})

-- Status do sistema
local StatusSection = CarTab:CreateSection("Status")

local FlightStatus = CarTab:CreateLabel("Status Voo: Desativado")
local VelocityStatus = CarTab:CreateLabel("Status Velocidade: Ativo")

-- Atualizar status
RunService.Heartbeat:Connect(function()
   FlightStatus:Set("Status Voo: " .. (flightEnabled and "🟢 Ativado" or "🔴 Desativado"))
   VelocityStatus:Set("Status Velocidade: " .. (velocityEnabled and "🟢 Ativo" or "🔴 Desativado"))
end)

-- Funções do sistema de carro
local function GetVehicleFromDescendant(Descendant)
   return
      Descendant:FindFirstAncestor(LocalPlayer.Name .. "\'s Car") or
      (Descendant:FindFirstAncestor("Body") and Descendant:FindFirstAncestor("Body").Parent) or
      (Descendant:FindFirstAncestor("Misc") and Descendant:FindFirstAncestor("Misc").Parent) or
      Descendant:FindFirstAncestorWhichIsA("Model")
end

-- Sistema de Voo
RunService.Stepped:Connect(function()
   local Character = LocalPlayer.Character
   if flightEnabled and Character then
      local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
      if Humanoid then
         local SeatPart = Humanoid.SeatPart
         if SeatPart and SeatPart:IsA("VehicleSeat") then
            local Vehicle = GetVehicleFromDescendant(SeatPart)
            if Vehicle and Vehicle:IsA("Model") then
               Character.Parent = Vehicle
               if not Vehicle.PrimaryPart then
                  if SeatPart.Parent == Vehicle then
                     Vehicle.PrimaryPart = SeatPart
                  else
                     Vehicle.PrimaryPart = Vehicle:FindFirstChildWhichIsA("BasePart")
                  end
               end
               local PrimaryPartCFrame = Vehicle:GetPrimaryPartCFrame()
               Vehicle:SetPrimaryPartCFrame(CFrame.new(PrimaryPartCFrame.Position, PrimaryPartCFrame.Position + workspace.CurrentCamera.CFrame.LookVector) * (UserInputService:GetFocusedTextBox() and CFrame.new(0, 0, 0) or CFrame.new((UserInputService:IsKeyDown(Enum.KeyCode.D) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -flightSpeed) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.E) and flightSpeed / 2) or (UserInputService:IsKeyDown(Enum.KeyCode.Q) and -flightSpeed / 2) or 0, (UserInputService:IsKeyDown(Enum.KeyCode.S) and flightSpeed) or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -flightSpeed) or 0)))
               SeatPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
               SeatPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
         end
      end
   end
end)

-- Sistema de Aceleração (W)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
   if gameProcessed or not velocityEnabled then return end
   
   if input.KeyCode == Enum.KeyCode.W then
      local connection
      connection = RunService.Heartbeat:Connect(function()
         if not UserInputService:IsKeyDown(Enum.KeyCode.W) then
            connection:Disconnect()
            return
         end
         
         local Character = LocalPlayer.Character
         if Character then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid then
               local SeatPart = Humanoid.SeatPart
               if SeatPart and SeatPart:IsA("VehicleSeat") then
                  SeatPart.AssemblyLinearVelocity = SeatPart.AssemblyLinearVelocity * Vector3.new(1 + velocityMult, 1, 1 + velocityMult)
               end
            end
         end
      end)
   end
end)

-- Sistema de Freio (S)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
   if gameProcessed or not velocityEnabled then return end
   
   if input.KeyCode == Enum.KeyCode.S then
      local connection
      connection = RunService.Heartbeat:Connect(function()
         if not UserInputService:IsKeyDown(Enum.KeyCode.S) then
            connection:Disconnect()
            return
         end
         
         local Character = LocalPlayer.Character
         if Character then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid then
               local SeatPart = Humanoid.SeatPart
               if SeatPart and SeatPart:IsA("VehicleSeat") then
                  SeatPart.AssemblyLinearVelocity = SeatPart.AssemblyLinearVelocity * Vector3.new(1 - velocityMult2, 1, 1 - velocityMult2)
               end
            end
         end
      end)
   end
end)

-- Seção de Instruções
local InstructionsSection = CarTab:CreateSection("Instruções")

CarTab:CreateParagraph({
   Title = "🎮 Controles",
   Content = "W - Acelerar veículo\nS - Frear veículo\nWASD + QE - Voar (quando ativado)\n\nConfigure as velocidades nos sliders acima"
})



-- =============================================
-- ABA “SCRIPTS EXTERNOS”
-- =============================================
local ScriptsTab = Window:CreateTab("Scripts Externos", 4483362458)

----------- 1) AirHub -----------
local AirHubSection = ScriptsTab:CreateSection("AirHub (Exunys)")
local AirHubStatus  = ScriptsTab:CreateLabel("AirHub: Não carregado")

ScriptsTab:CreateButton({
    Name = "🚀 Carregar AirHub (Exunys)",
    Callback = function()
        AirHubStatus:Set("AirHub: Carregando...")
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/AirHub.lua"))()
        end)
        if ok then
            AirHubStatus:Set("AirHub: ✅ Carregado!")
            Rayfield:Notify({Title = "✅ Sucesso", Content = "AirHub ativado!", Duration = 3, Image = 4483362458})
        else
            AirHubStatus:Set("AirHub: ❌ Erro")
            Rayfield:Notify({Title = "❌ Erro", Content = tostring(err), Duration = 3, Image = 4483362458})
        end
    end
})

----------- 2) Infinite Yield -----------
local IYSection = ScriptsTab:CreateSection("Infinite Yield")
local IYStatus  = ScriptsTab:CreateLabel("I-Y: Aguardando")

ScriptsTab:CreateButton({
    Name = "⚡ Executar Infinite Yield",
    Callback = function()
        IYStatus:Set("I-Y: Carregando...")
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        if ok then
            IYStatus:Set("I-Y: ✅ Rodando!")
            Rayfield:Notify({Title = "✅ Sucesso", Content = "Infinite Yield executado!", Duration = 3, Image = 4483362458})
        else
            IYStatus:Set("I-Y: ❌ Erro")
            Rayfield:Notify({Title = "❌ Erro", Content = tostring(err), Duration = 3, Image = 4483362458})
        end
    end
})

----------- 3) PasteWare -----------
local PWSection = ScriptsTab:CreateSection("PasteWare")
local PWStatus  = ScriptsTab:CreateLabel("PasteWare: Aguardando")

ScriptsTab:CreateButton({
    Name = "🔥 Executar PasteWare",
    Callback = function()
        PWStatus:Set("PasteWare: Carregando...")
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeAngles/PasteWare/refs/heads/main/PasteWare.lua"))()
        end)
        if ok then
            PWStatus:Set("PasteWare: ✅ Rodando!")
            Rayfield:Notify({Title = "✅ Sucesso", Content = "PasteWare executado!", Duration = 3, Image = 4483362458})
        else
            PWStatus:Set("PasteWare: ❌ Erro")
            Rayfield:Notify({Title = "❌ Erro", Content = tostring(err), Duration = 3, Image = 4483362458})
        end
    end
})

----------- 4) Portal Gun -----------

local PWSection = ScriptsTab:CreateSection("Portal Gun")
local PWStatus  = ScriptsTab:CreateLabel("Portal Gun: Aguardando")

ScriptsTab:CreateButton({
    Name = "🔥 Executar Portal Gun",
    Callback = function()
        PWStatus:Set("Portal Gun: Carregando...")
        local ok, err = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/portal%20gun.txt'))()
        end)
        if ok then
            PWStatus:Set("Portal Gun: ✅ Rodando!")
            Rayfield:Notify({Title = "✅ Sucesso", Content = "Portal Gunexecutado!", Duration = 3, Image = 4483362458})
        else
            PWStatus:Set("Portal Gun: ❌ Erro")
            Rayfield:Notify({Title = "❌ Erro", Content = tostring(err), Duration = 3, Image = 4483362458})
        end
    end
})

----------- Instruções -----------
ScriptsTab:CreateParagraph({
    Title = "📖 Instruções",
    Content = "1. AirHub: interface própria (ESP, Aimbot, etc.)\n"..
              "2. Infinite Yield: clássico comando admin\n"..
              "3. PasteWare: outro script completo\n"..
              "Clique no botão desejado para executar."
})


-- =============================================
-- ABA ESP - ATUALIZAÇÃO EM TEMPO REAL
-- =============================================
local ESPTab = Window:CreateTab("ESP", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Configurações
local ESPConfig = {
    Enabled = false,
    ShowTeam = true,
    ShowDistance = false,
    ShowWeapon = false,
    Boxes = false,
    Names = true,
    MaxDistance = 1000,
    TextSize = 14
}

-- Cores
local TeamColors = {
    DefaultEnemy = Color3.fromRGB(255, 0, 0),
    DefaultFriendly = Color3.fromRGB(0, 255, 0),
    Neutral = Color3.fromRGB(255, 255, 0)
}

-- Pasta dos ESPs
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "TDR_ESP"
ESPFolder.Parent = game:GetService("CoreGui")

local ESPObjects = {}

-- =============================================
-- CONTROLES
-- =============================================
ESPTab:CreateToggle({Name = "ESP Ativado", CurrentValue = false, Callback = function(v) ESPConfig.Enabled = v RefreshAllESP() end})
ESPTab:CreateToggle({Name = "Caixas 3D", CurrentValue = false, Callback = function(v) ESPConfig.Boxes = v RefreshAllESP() end})
ESPTab:CreateToggle({Name = "Nomes", CurrentValue = true, Callback = function(v) ESPConfig.Names = v RefreshAllESP() end})
ESPTab:CreateToggle({Name = "Distância", CurrentValue = false, Callback = function(v) ESPConfig.ShowDistance = v RefreshAllESP() end})
ESPTab:CreateToggle({Name = "Armas", CurrentValue = false, Callback = function(v) ESPConfig.ShowWeapon = v RefreshAllESP() end})
ESPTab:CreateToggle({Name = "Mostrar Time", CurrentValue = true, Callback = function(v) ESPConfig.ShowTeam = v RefreshAllESP() end})

ESPTab:CreateSlider({Name = "Distância Máxima", Range = {100, 5000}, Increment = 100, CurrentValue = 1000, Callback = function(v) ESPConfig.MaxDistance = v end})
ESPTab:CreateSlider({Name = "Tamanho do Texto", Range = {8, 24}, Increment = 1, CurrentValue = 14, Callback = function(v) ESPConfig.TextSize = v UpdateAllESPStyles() end})

-- =============================================
-- FUNÇÕES CORE
-- =============================================
function GetPlayerColor(player)
    if not player.Team then return TeamColors.Neutral end
    if LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return TeamColors.DefaultFriendly
    else
        return TeamColors.DefaultEnemy
    end
end

function GetEquippedWeapon(player)
    if not player or not player.Character then return "Nenhuma" end
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then return tool.Name end
    end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then return tool.Name end
        end
    end
    return "Nenhuma"
end

function CreateESP(player)
    if ESPObjects[player] then RemoveESP(player) end

    local esp = {Player = player}
    ESPObjects[player] = esp

    -- Caixa 3D
    if ESPConfig.Boxes then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = nil
        box.AlwaysOnTop = true
        box.Size = Vector3.new(4, 6, 1)
        box.Transparency = 0.3
        box.Color3 = GetPlayerColor(player)
        box.Parent = ESPFolder
        esp.Box = box
    end

    -- Billboard principal
    local bill = Instance.new("BillboardGui")
    bill.Adornee = nil
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 200, 0, 100)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.Parent = ESPFolder

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = bill

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = frame

    -- Nome do jogador
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0, ESPConfig.TextSize + 4)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = GetPlayerColor(player)
    name.TextStrokeColor3 = Color3.new(0, 0, 0)
    name.TextStrokeTransparency = 0
    name.TextSize = ESPConfig.TextSize
    name.Font = Enum.Font.GothamBold
    name.LayoutOrder = 1
    name.Parent = frame
    esp.NameLabel = name

    -- Nome do time
    if ESPConfig.ShowTeam and player.Team then
        local teamLabel = Instance.new("TextLabel")
        teamLabel.Size = UDim2.new(1, 0, 0, ESPConfig.TextSize - 2)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Text = player.Team.Name
        teamLabel.TextColor3 = player.Team.TeamColor and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
        teamLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        teamLabel.TextStrokeTransparency = 0
        teamLabel.TextSize = ESPConfig.TextSize - 2
        teamLabel.Font = Enum.Font.GothamBold
        teamLabel.LayoutOrder = 0
        teamLabel.Parent = frame
        esp.TeamLabel = teamLabel
    end

    -- Distância
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0, ESPConfig.TextSize)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = Color3.new(1, 1, 1)
    dist.TextStrokeColor3 = Color3.new(0, 0, 0)
    dist.TextStrokeTransparency = 0
    dist.TextSize = ESPConfig.TextSize - 2
    dist.Font = Enum.Font.GothamBold
    dist.LayoutOrder = 2
    dist.Parent = frame
    esp.DistanceLabel = dist

    -- Arma
    local weapon = Instance.new("TextLabel")
    weapon.Size = UDim2.new(1, 0, 0, ESPConfig.TextSize)
    weapon.BackgroundTransparency = 1
    weapon.Text = "Arma: Nenhuma"
    weapon.TextColor3 = Color3.new(1, 1, 1)
    weapon.TextStrokeColor3 = Color3.new(0, 0, 0)
    weapon.TextStrokeTransparency = 0
    weapon.TextSize = ESPConfig.TextSize - 2
    weapon.Font = Enum.Font.GothamBold
    weapon.LayoutOrder = 3
    weapon.Parent = frame
    esp.WeaponLabel = weapon

    -- Label "Morto!"
    local dead = Instance.new("TextLabel")
    dead.Size = UDim2.new(1, 0, 0, ESPConfig.TextSize)
    dead.BackgroundTransparency = 1
    dead.Text = player.Name .. " Morreu!"
    dead.TextColor3 = Color3.new(1, 0, 0)
    dead.TextStrokeColor3 = Color3.new(0, 0, 0)
    dead.TextStrokeTransparency = 0
    dead.TextSize = ESPConfig.TextSize
    dead.Font = Enum.Font.GothamBold
    dead.LayoutOrder = 4
    dead.Parent = frame
    esp.DeadLabel = dead

    esp.Billboard = bill
end

function UpdateESP(player)
    local esp = ESPObjects[player]
    if not esp or not ESPConfig.Enabled then return end

    local character = player.Character
    if not character then return end

    -- Aguarda o Humanoid existir (evita o bug do respawn)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        -- Tenta novamente no próximo frame
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Verifica vida
    local isDead = humanoid.Health <= 0

    -- Distância
    local distance = (root.Position - (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude
    if distance > ESPConfig.MaxDistance then
        if esp.Billboard then esp.Billboard.Enabled = false end
        if esp.Box       then esp.Box.Visible       = false end
        return
    end

    -- Atualiza cor
    local color = GetPlayerColor(player)

    -- Mostra / oculta elementos conforme estado
    if isDead then
        -- Modo "morto"
        if esp.DeadLabel   then
            esp.DeadLabel.Visible   = true
            esp.DeadLabel.Text = player.Name .. " Morreu!"
        end
        if esp.NameLabel   then esp.NameLabel.Visible   = false end
        if esp.TeamLabel   then esp.TeamLabel.Visible   = false end
        if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
        if esp.WeaponLabel then esp.WeaponLabel.Visible = false end
        if esp.Box         then esp.Box.Visible         = false end
        if esp.Billboard   then
            esp.Billboard.Enabled = true
            esp.Billboard.Adornee = root
        end
        return
    else
        -- Modo "vivo" – respeita as configurações normais
        if esp.DeadLabel then esp.DeadLabel.Visible = false end
    end

    -- Caixa
    if esp.Box then
        esp.Box.Adornee   = root
        esp.Box.Visible   = true
        esp.Box.Color3    = color
    end

    -- Billboard
    if esp.Billboard then
        esp.Billboard.Adornee = root
        esp.Billboard.Enabled = true

        -- Nome
        if esp.NameLabel then
            esp.NameLabel.Visible = ESPConfig.Names
            esp.NameLabel.Text    = player.Name
            esp.NameLabel.TextColor3 = player.Team and player.Team.TeamColor and player.Team.TeamColor.Color or color
            esp.NameLabel.TextSize   = ESPConfig.TextSize
        end

        -- Time
        if esp.TeamLabel then
            esp.TeamLabel.Visible = ESPConfig.ShowTeam
            esp.TeamLabel.Text    = player.Team and player.Team.Name or ""
            esp.TeamLabel.TextColor3 = player.Team and player.Team.TeamColor and player.Team.TeamColor.Color or Color3.new(1,1,1)
        end

        -- Distância
        if esp.DistanceLabel then
            esp.DistanceLabel.Visible = ESPConfig.ShowDistance
            esp.DistanceLabel.Text    = tostring(math.floor(distance)).."m"
        end

        -- Arma
        if esp.WeaponLabel then
            esp.WeaponLabel.Visible = ESPConfig.ShowWeapon
            esp.WeaponLabel.Text    = "Arma: "..GetEquippedWeapon(player)
        end
    end
end

function RemoveESP(player)
    local esp = ESPObjects[player]
    if esp then
        if esp.Box then esp.Box:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        ESPObjects[player] = nil
    end
end

function ClearAllESP()
    for _, esp in pairs(ESPObjects) do
        if esp.Box then esp.Box:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
    end
    ESPObjects = {}
end

function RefreshAllESP()
    ClearAllESP()
    if not ESPConfig.Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
end

function UpdateAllESPStyles()
    for _, esp in pairs(ESPObjects) do
        if esp.NameLabel then esp.NameLabel.TextSize = ESPConfig.TextSize end
        if esp.TeamLabel then esp.TeamLabel.TextSize = ESPConfig.TextSize - 2 end
        if esp.DistanceLabel then esp.DistanceLabel.TextSize = ESPConfig.TextSize - 2 end
        if esp.WeaponLabel then esp.WeaponLabel.TextSize = ESPConfig.TextSize - 2 end
        if esp.DeadLabel then esp.DeadLabel.TextSize = ESPConfig.TextSize end
    end
end

-- =============================================
-- ATUALIZAÇÃO EM TEMPO REAL
-- =============================================
-- Jogadores entrando/saindo
Players.PlayerAdded:Connect(function(player)
    if ESPConfig.Enabled then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Mudança de time
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player:GetPropertyChangedSignal("Team"):Connect(function()
            if ESPObjects[player] then
                RemoveESP(player)
                if ESPConfig.Enabled then
                    CreateESP(player)
                end
            end
        end)
    end
end

-- =============================================
-- LOOP PRINCIPAL
-- =============================================
spawn(function()
    while true do
        if ESPConfig.Enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    UpdateESP(player)
                end
            end
        end
        wait(0.2)
    end
end)

-- =============================================
-- ATALHO DE TECLADO: LIGAR/DESLIGAR ESP
-- =============================================
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Zero then
        ESPConfig.Enabled = not ESPConfig.Enabled
        RefreshAllESP()

        Rayfield:Notify({
            Title = "ESP",
            Content = ESPConfig.Enabled and "ESP ativado!" or "ESP desativado!",
            Duration = 2,
            Image = 4483362458
        })
    end
end)

-- =============================================

-- Aba de Teleporte

-- =============================================

local TeleportTab = Window:CreateTab("Locais Teleporte", 4483362458)

local savedLocations = {}
local maxSlots = 5

-- Inicializar slots vazios
for i = 1, maxSlots do
    savedLocations[i] = {name = "Vazio", position = nil, saved = false}
end

-- Função para teleportar
local function teleportToPosition(position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

-- Título
TeleportTab:CreateLabel("💾 Salve e teleporte para até 5 locais")

-- Lista vertical de slots
for i = 1, maxSlots do
    local slotName = "Slot " .. i

    -- Label do slot
    local slotLabel = TeleportTab:CreateLabel(slotName .. ": " .. savedLocations[i].name)

    -- Input para nome
    local nameInput = TeleportTab:CreateInput({
        Name = "📝 Nome do Local " .. i,
        PlaceholderText = "Nome do local...",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            -- não armazena aqui
        end,
    })

    -- Botão salvar/renomear
    TeleportTab:CreateButton({
        Name = "💾 Salvar/Renomear Slot " .. i,
        Callback = function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                Rayfield:Notify({Title = "❌ Erro", Content = "Personagem não encontrado!", Duration = 3, Image = 4483362458})
                return
            end

            local newName = nameInput.Value ~= "" and nameInput.Value or ("Local " .. i)
            savedLocations[i] = {
                name = newName,
                position = character.HumanoidRootPart.Position,
                saved = true
            }
            slotLabel:Set(slotName .. ": " .. newName)
            Rayfield:Notify({Title = "✅ Salvo!", Content = "Slot " .. i .. " atualizado.", Duration = 2, Image = 4483362458})
        end,
    })

    -- Botão teleportar
    TeleportTab:CreateButton({
        Name = "🚀 Teleportar para Slot " .. i,
        Callback = function()
            if not savedLocations[i].saved then
                Rayfield:Notify({Title = "❌ Vazio", Content = "Este slot está vazio!", Duration = 2, Image = 4483362458})
                return
            end
            if teleportToPosition(savedLocations[i].position) then
                Rayfield:Notify({Title = "🚀 Teleportado!", Content = "Você foi para: " .. savedLocations[i].name, Duration = 2, Image = 4483362458})
            else
                Rayfield:Notify({Title = "❌ Erro", Content = "Personagem não encontrado!", Duration = 2, Image = 4483362458})
            end
        end,
    })

    -- Linha separadora visual
    TeleportTab:CreateLabel("――――――――――――――――――")
end

-- Botão limpar tudo
TeleportTab:CreateButton({
    Name = "🗑️ Limpar Todos os Slots",
    Callback = function()
        for i = 1, maxSlots do
            savedLocations[i] = {name = "Vazio", position = nil, saved = false}
        end
        -- Atualiza labels (simples reload)
        Rayfield:Notify({Title = "🗑️ Limpo!", Content = "Todos os slots foram limpos.", Duration = 2, Image = 4483362458})
        -- Recarrega a aba inteira (simples)
        TeleportTab:Destroy()
        -- Re-cria a aba (opcional - se quiser reload total)
        -- Copie esse bloco todo de novo aqui se quiser
    end,
})


-- Aba de Teleporte
local TeleportTab = Window:CreateTab("Teleporte", 4483362458)

-- Sistema de Teleporte entre QUATRO Pontos
local teleporting = false
local points = {A = nil, B = nil, C = nil, D = nil}
local teleportSpeed = 1
local teleportConnection = nil
local currentIndex = 1          -- 1=A, 2=B, 3=C, 4=D
local lastTeleportTime = 0
local pointOrder = {"A", "B", "C", "D"}

-- Seção de Teleporte
local SectionTeleport = TeleportTab:CreateSection("Teleporte entre 4 Pontos")

-- Botões para marcar os 4 pontos
for _, p in ipairs(pointOrder) do
    TeleportTab:CreateButton({
        Name = "🎯 Marcar Ponto "..p,
        Callback = function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                points[p] = character.HumanoidRootPart.Position
                UpdatePointInfo()
                Rayfield:Notify({
                    Title = "✅ Ponto "..p.." Marcado!",
                    Content = "Posição salva como Ponto "..p,
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end
    })
end

-- Controle de velocidade
local SpeedSlider = TeleportTab:CreateSlider({
    Name = "⏱️ Tempo entre Teleportes",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = " segundos",
    CurrentValue = 1,
    Callback = function(Value)
        teleportSpeed = Value
        if teleporting then
            StatusLabel:Set("Status: Teleportando em loop (" .. string.format("%.1f", teleportSpeed) .. "s)")
        end
    end
})

-- Botões de velocidade rápida
local QuickSpeedSection = TeleportTab:CreateSection("Velocidades Rápidas")
local quickSpeeds = {0.1, 0.5, 1, 2, 5}
for _, speed in ipairs(quickSpeeds) do
    TeleportTab:CreateButton({
        Name = speed .. " segundos",
        Callback = function()
            teleportSpeed = speed
            SpeedSlider:Set(speed)
            Rayfield:Notify({
                Title = "⏱️ Velocidade Alterada",
                Content = "Tempo definido para " .. speed .. " segundos",
                Duration = 2,
                Image = 4483362458
            })
        end
    })
end

-- Botão principal de teleporte
local ToggleButton = TeleportTab:CreateButton({
    Name = "▶️ INICIAR TELEPORTE",
    Callback = function()
        ToggleTeleport()
    end
})

-- Status e informações
local StatusLabel  = TeleportTab:CreateLabel("Status: Aguardando pontos...")
local PointInfoLabel = TeleportTab:CreateLabel("Ponto A: Não marcado\nPonto B: Não marcado\nPonto C: Não marcado\nPonto D: Não marcado")

-- Atualiza label com as 4 posições
function UpdatePointInfo()
    local lines = {}
    for _, p in ipairs(pointOrder) do
        local pos = points[p]
        local txt = pos and string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z) or "Não marcado"
        table.insert(lines, "Ponto "..p..": "..txt)
    end
    PointInfoLabel:Set(table.concat(lines, "\n"))
end

-- Teleporta o jogador para uma posição
function teleportToPosition(position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Controla o ciclo A→B→C→D→A...
function controlledTeleport()
    local currentTime = tick()
    if currentTime - lastTeleportTime >= teleportSpeed then
        local targetPoint = pointOrder[currentIndex]
        if points[targetPoint] then
            teleportToPosition(points[targetPoint])
        end
        currentIndex = currentIndex % 4 + 1
        lastTeleportTime = currentTime
    end
end

-- Liga/desliga o loop
function ToggleTeleport()
    -- Verifica se todos os 4 pontos foram marcados
    for _, p in ipairs(pointOrder) do
        if not points[p] then
            Rayfield:Notify({
                Title = "❌ Erro",
                Content = "Marque todos os 4 pontos primeiro!",
                Duration = 3,
                Image = 4483362458
            })
            return
        end
    end

    if not teleporting then
        teleporting = true
        ToggleButton:Set("⏹️ PARAR TELEPORTE")
        StatusLabel:Set("Status: Teleportando em loop (" .. string.format("%.1f", teleportSpeed) .. "s)")

        -- Primeiro teleporte imediato
        teleportToPosition(points[pointOrder[currentIndex]])
        currentIndex = currentIndex % 4 + 1
        lastTeleportTime = tick()

        -- Loop contínuo
        teleportConnection = RunService.Heartbeat:Connect(function()
            if teleporting then controlledTeleport() end
        end)

        Rayfield:Notify({
            Title = "🔄 Teleporte Iniciado!",
            Content = "Loop A→B→C→D a cada " .. string.format("%.1f", teleportSpeed) .. "s",
            Duration = 3,
            Image = 4483362458
        })
    else
        teleporting = false
        if teleportConnection then teleportConnection:Disconnect(); teleportConnection = nil end
        ToggleButton:Set("▶️ INICIAR TELEPORTE")
        StatusLabel:Set("Status: Parado")
        Rayfield:Notify({
            Title = "⏹️ Teleporte Parado",
            Content = "Interrompido pelo usuário",
            Duration = 3,
            Image = 4483362458
        })
    end
end


-- =============================================

-- Aba de Servidor Privado

-- =============================================

local ServerTab = Window:CreateTab("Servidor Privado", 4483362458)

-- Sistema de Servidor Privado
local md5 = {}
local hmac = {}
local base64 = {}

do
	do
		local T = {
			0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
			0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
			0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
			0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
			0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
			0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
			0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
			0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
		}

		local function add(a, b)
			local lsw = bit32.band(a, 0xFFFF) + bit32.band(b, 0xFFFF)
			local msw = bit32.rshift(a, 16) + bit32.rshift(b, 16) + bit32.rshift(lsw, 16)
			return bit32.bor(bit32.lshift(msw, 16), bit32.band(lsw, 0xFFFF))
		end

		local function rol(x, n)
			return bit32.bor(bit32.lshift(x, n), bit32.rshift(x, 32 - n))
		end

		local function F(x, y, z) return bit32.bor(bit32.band(x, y), bit32.band(bit32.bnot(x), z)) end
		local function G(x, y, z) return bit32.bor(bit32.band(x, z), bit32.band(y, bit32.bnot(z))) end
		local function H(x, y, z) return bit32.bxor(x, bit32.bxor(y, z)) end
		local function I(x, y, z) return bit32.bxor(y, bit32.bor(x, bit32.bnot(z))) end

		function md5.sum(message)
			local a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
			local message_len = #message
			local padded_message = message .. "\128"
			while #padded_message % 64 ~= 56 do
				padded_message = padded_message .. "\0"
			end

			local len_bytes = ""
			local len_bits = message_len * 8
			for i = 0, 7 do
				len_bytes = len_bytes .. string.char(bit32.band(bit32.rshift(len_bits, i * 8), 0xFF))
			end
			padded_message = padded_message .. len_bytes

			for i = 1, #padded_message, 64 do
				local chunk = padded_message:sub(i, i + 63)
				local X = {}
				for j = 0, 15 do
					local b1, b2, b3, b4 = chunk:byte(j * 4 + 1, j * 4 + 4)
					X[j] = bit32.bor(b1, bit32.lshift(b2, 8), bit32.lshift(b3, 16), bit32.lshift(b4, 24))
				end

				local aa, bb, cc, dd = a, b, c, d
				local s = { 7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21 }

				for j = 0, 63 do
					local f, k, shift_index
					if j < 16 then
						f = F(b, c, d)
						k = j
						shift_index = j % 4
					elseif j < 32 then
						f = G(b, c, d)
						k = (1 + 5 * j) % 16
						shift_index = 4 + (j % 4)
					elseif j < 48 then
						f = H(b, c, d)
						k = (5 + 3 * j) % 16
						shift_index = 8 + (j % 4)
					else
						f = I(b, c, d)
						k = (7 * j) % 16
						shift_index = 12 + (j % 4)
					end

					local temp = add(a, f)
					temp = add(temp, X[k])
					temp = add(temp, T[j + 1])
					temp = rol(temp, s[shift_index + 1])

					local new_b = add(b, temp)
					a, b, c, d = d, new_b, b, c
				end

				a = add(a, aa)
				b = add(b, bb)
				c = add(c, cc)
				d = add(d, dd)
			end

			local function to_le_hex(n)
				local s = ""
				for i = 0, 3 do
					s = s .. string.char(bit32.band(bit32.rshift(n, i * 8), 0xFF))
				end
				return s
			end

			return to_le_hex(a) .. to_le_hex(b) .. to_le_hex(c) .. to_le_hex(d)
		end
	end

	do
		function hmac.new(key, msg, hash_func)
			if #key > 64 then key = hash_func(key) end
			local o_key_pad, i_key_pad = "", ""
			for i = 1, 64 do
				local byte = (i <= #key and string.byte(key, i)) or 0
				o_key_pad = o_key_pad .. string.char(bit32.bxor(byte, 0x5C))
				i_key_pad = i_key_pad .. string.char(bit32.bxor(byte, 0x36))
			end
			return hash_func(o_key_pad .. hash_func(i_key_pad .. msg))
		end
	end

	do
		local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		function base64.encode(data)
			return ((data:gsub(".", function(x)
				local r, b_val = "", x:byte()
				for i = 8, 1, -1 do
					r = r .. (b_val % 2 ^ i - b_val % 2 ^ (i - 1) > 0 and "1" or "0")
				end
				return r
			end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
				if #x < 6 then return "" end
				local c = 0
				for i = 1, 6 do
					c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
				end
				return b:sub(c + 1, c + 1)
			end) .. ({ "", "==", "=" })[#data % 3 + 1])
		end
	end
end

local function GenerateReservedServerCode(placeId)
	local uuid = {}
	for i = 1, 16 do uuid[i] = math.random(0, 255) end

	uuid[7] = bit32.bor(bit32.band(uuid[7], 0x0F), 0x40)
	uuid[9] = bit32.bor(bit32.band(uuid[9], 0x3F), 0x80)

	local firstBytes = ""
	for i = 1, 16 do firstBytes = firstBytes .. string.char(uuid[i]) end

	local gameCode = string.format("%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x", table.unpack(uuid))

	local placeIdBytes = ""
	local pIdRec = placeId
	for _ = 1, 8 do
		placeIdBytes = placeIdBytes .. string.char(pIdRec % 256)
		pIdRec = math.floor(pIdRec / 256)
	end

	local content = firstBytes .. placeIdBytes
	local SUPERDUPERSECRETROBLOXKEY = "e4Yn8ckbCJtw2sv7qmbg"
	local signature = hmac.new(SUPERDUPERSECRETROBLOXKEY, content, md5.sum)
	local accessCodeBytes = signature .. content
	local accessCode = base64.encode(accessCodeBytes)
	accessCode = accessCode:gsub("+", "-"):gsub("/", "_")

	local pdding = 0
	accessCode, _ = accessCode:gsub("=", function() pdding = pdding + 1 return "" end)
	accessCode = accessCode .. tostring(pdding)

	return accessCode, gameCode
end

-- Seção do Servidor Privado
local ServerSection = ServerTab:CreateSection("Criar Servidor Privado")

local ServerStatus = ServerTab:CreateLabel("Status: Pronto para criar servidor")
local AccessCodeLabel = ServerTab:CreateLabel("Código de acesso: Nenhum")

local CreateServerButton = ServerTab:CreateButton({
   Name = "🛡️ Criar Servidor Privado",
   Callback = function()
       ServerStatus:Set("Status: Gerando código...")
       
       local accessCode, gameCode = GenerateReservedServerCode(game.PlaceId)
       
       if setclipboard then
           setclipboard(accessCode)
       end
       
       -- Enviar convite para servidor privado
       local success, error = pcall(function()
           game:GetService("RobloxReplicatedStorage").ContactListIrisInviteTeleport:FireServer(game.PlaceId, "", accessCode)
       end)
       
       if success then
           AccessCodeLabel:Set("Código de acesso: " .. accessCode)
           ServerStatus:Set("Status: Servidor criado com sucesso!")
           
           Rayfield:Notify({
               Title = "🛡️ Servidor Privado Criado!",
               Content = "Código copiado para área de transferência",
               Duration = 5,
               Image = 4483362458
           })
           
           print("✅ Servidor Privado Criado!")
           print("🔑 Código de acesso: " .. accessCode)
           print("🎮 Game Code: " .. gameCode)
       else
           ServerStatus:Set("Status: Erro ao criar servidor")
           Rayfield:Notify({
               Title = "❌ Erro",
               Content = "Falha ao criar servidor privado",
               Duration = 3,
               Image = 4483362458
           })
           print("❌ Erro ao criar servidor: " .. tostring(error))
       end
   end
})

-- Seção de instruções
local InstructionsSection = ServerTab:CreateSection("Como Usar")

ServerTab:CreateParagraph({
   Title = "📋 Instruções",
   Content = "1. Clique em 'Criar Servidor Privado'\n2. O código será copiado automaticamente\n3. Use o código para entrar com outra conta\n4. O servidor será criado instantaneamente"
})



-- =============================================

-- Aba DEX

-- =============================================

local DEXTab = Window:CreateTab("DEX", 4483362458)

-- Sistema DEX
local DexSection = DEXTab:CreateSection("Explorador de Destralha")

local DexStatus = DEXTab:CreateLabel("Status: Pronto para carregar")
local DexLoaded = false

-- Função para carregar o DEX
local function LoadDEX()
    if DexLoaded then
        Rayfield:Notify({
            Title = "⚠️ DEX Já Carregado",
            Content = "O Explorador de Destralha já está aberto",
            Duration = 3,
            Image = 4483362458
        })
        return
    end
    
    DexStatus:Set("Status: Carregando DEX...")
    
    Rayfield:Notify({
        Title = "🔄 Carregando DEX",
        Content = "Iniciando Explorador de Destralha...",
        Duration = 3,
        Image = 4483362458
    })
    
    local success = false
    
    -- Tentar carregar o DEX avançado primeiro
    local s, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua", true))()
        success = true
    end)
    
    if not success then
        -- Tentar método alternativo se o primeiro falhar
        local s2, err2 = pcall(function()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
            success = true
        end)
    end
    
    if success then
        DexLoaded = true
        DexStatus:Set("Status: 🟢 DEX Carregado!")
        Rayfield:Notify({
            Title = "✅ DEX Carregado!",
            Content = "Explorador de Destralha inicializado com sucesso",
            Duration = 5,
            Image = 4483362458
        })
    else
        DexStatus:Set("Status: 🔴 Falha ao carregar")
        Rayfield:Notify({
            Title = "❌ Erro ao Carregar DEX",
            Content = "Tente novamente mais tarde",
            Duration = 5,
            Image = 4483362458
        })
    end
end

-- Botão principal do DEX
DEXTab:CreateButton({
    Name = "🚀 Carregar DEX Avançado",
    Callback = function()
        LoadDEX()
    end,
})

-- Ferramentas do DEX
local ToolsSection = DEXTab:CreateSection("Ferramentas")

DEXTab:CreateButton({
    Name = "🧹 Limpar DEX",
    Callback = function()
        local CoreGui = game:GetService("CoreGui")
        local dex = CoreGui:FindFirstChild("DarkDex")
        if dex then
            dex:Destroy()
        end
        
        DexLoaded = false
        DexStatus:Set("Status: DEX Limpo")
        Rayfield:Notify({
            Title = "🧹 DEX Removido",
            Content = "Explorador de Destralha fechado",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

DEXTab:CreateButton({
    Name = "🔄 Reiniciar DEX",
    Callback = function()
        -- Primeiro limpa o DEX existente
        local CoreGui = game:GetService("CoreGui")
        local dex = CoreGui:FindFirstChild("DarkDex")
        if dex then
            dex:Destroy()
        end
        
        DexLoaded = false
        wait(0.5) -- Pequeno delay para garantir que foi destruído
        
        -- Depois carrega novamente
        LoadDEX()
    end,
})

-- Instruções do DEX
local InstructionsSection = DEXTab:CreateSection("Instruções")

DEXTab:CreateParagraph({
    Title = "📖 Como Usar o DEX",
    Content = "1. Clique em 'Carregar DEX Avançado'\n2. Use o explorador para navegar no jogo\n3. Clique nas pastas para expandir\n4. Inspecione propriedades de objetos\n5. Use as ferramentas para debugging"
})

DEXTab:CreateParagraph({
    Title = "⚠️ Aviso Importante",
    Content = "O DEX é para fins educacionais e de debugging. Use com responsabilidade e respeite os termos de serviço do jogo."
})

-- Status do sistema
local StatusSection = DEXTab:CreateSection("Status do Sistema")

local MemoryLabel = DEXTab:CreateLabel("Memória: Calculando...")
local PerformanceLabel = DEXTab:CreateLabel("Performance: OK")

-- Atualizar status do sistema
spawn(function()
    while wait(5) do
        local stats = game:GetService("Stats")
        local memory = stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryType.Script)
        MemoryLabel:Set(string.format("Memória: %.2f MB", memory))
        
        local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        PerformanceLabel:Set(string.format("Ping: %d ms", ping))
    end
end)


-- =============================================
-- ABA REVISAR MORTO PRÓXIMO (CORRIGIDA)
-- =============================================
local RevTab = Window:CreateTab("Revistar", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")

-- =============================================
-- FUNÇÕES
-- =============================================
local function notify(title, content, duration)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 4,
        Image = 4483362458
    })
end

local function getDeadClosest()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return nil, "Você não está spawnado"
    end

    local myRoot = char.HumanoidRootPart
    local closest = nil
    local dist = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health <= 0 then
            local d = (hrp.Position - myRoot.Position).Magnitude
            if d < dist then
                dist = d
                closest = plr
            end
        end
    end

    return closest, dist
end

local function revistarNearest()
    local dead, dist = getDeadClosest()
    if not dead then
        notify("❌ Ninguém morto", "Nenhum player morto encontrado.", 3)
        return
    end

    if dist > 6 then
    notify("❌ Muito longe", string.format("Morto mais próximo está a %.1f studs", dist), 3)
    	return
	end

    local cmd = "/revistar " .. dead.Name

    -- Tenta enviar pelo novo TextChatService
    local channel = TextChatService.TextChannels.RBXGeneral
    if channel then
        channel:SendAsync(cmd)
        notify("✅ Comando enviado", cmd .. string.format(" (%.1f studs)", dist), 3)
    else
        -- Fallback: escreve no chat local (apenas visual)
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[TDR] " .. cmd,
            Color = Color3.fromRGB(255, 255, 0)
        })
        notify("⚠️ Chat local", "Comando simulado: " .. cmd, 3)
    end
end

-- =============================================
-- CONTROLES
-- =============================================
RevTab:CreateButton({
    Name = "🔍 Revistar morto mais próximo (< 50 studs)",
    Callback = revistarNearest
})

-- Atalho: 6
game:GetService("UserInputService").InputBegan:Connect(function(inp, gP)
    if gP then return end
    if inp.KeyCode == Enum.KeyCode.Six then
        revistarNearest()
    end
end)



Rayfield:LoadConfiguration()
