local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local jabby = require(ReplicatedStorage.Packages.jabby)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local client = jabby.obtain_client()

local function create_widget(_, state: Enum.UserInputState)
    if state ~= Enum.UserInputState.Begin then
        return
    end
    client.spawn_app(client.apps.home, nil)
end

ContextActionService:BindAction("Open Jabby Home", create_widget, false, Enum.KeyCode.LeftAlt)