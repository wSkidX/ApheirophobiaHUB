local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local flySpeed = 10 -- Adjusted fly speed for better control
local bodyGyro, bodyVelocity
local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local SPEED = 0

local function FLY()
    flying = true
    local player = Players.LocalPlayer
    local character = player.Character
    local T = character.PrimaryPart

    bodyGyro = Instance.new('BodyGyro')
    bodyVelocity = Instance.new('BodyVelocity')
    bodyGyro.P = 9e4
    bodyGyro.Parent = T
    bodyVelocity.Parent = T
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = T.CFrame
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

    task.spawn(function()
        repeat wait()
            if character:FindFirstChildOfClass('Humanoid') then
                character:FindFirstChildOfClass('Humanoid').PlatformStand = true
            end
            if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                SPEED = flySpeed
            elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                SPEED = 0
            end
            if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                bodyVelocity.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p)) * SPEED
                lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
            elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                bodyVelocity.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p)) * SPEED
            else
                bodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
            bodyGyro.cframe = workspace.CurrentCamera.CFrame
        until not flying
        CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        SPEED = 0
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
        if character:FindFirstChildOfClass('Humanoid') then
            character:FindFirstChildOfClass('Humanoid').PlatformStand = false
        end
    end)
end

local function enableFly()
    FLY()
end

local function disableFly()
    flying = false
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        CONTROL.F = flySpeed
    elseif input.KeyCode == Enum.KeyCode.S then
        CONTROL.B = -flySpeed
    elseif input.KeyCode == Enum.KeyCode.A then
        CONTROL.L = -flySpeed
    elseif input.KeyCode == Enum.KeyCode.D then
        CONTROL.R = flySpeed
    elseif input.KeyCode == Enum.KeyCode.E then
        CONTROL.Q = flySpeed * 2
    elseif input.KeyCode == Enum.KeyCode.Q then
        CONTROL.E = -flySpeed * 2
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        CONTROL.F = 0
    elseif input.KeyCode == Enum.KeyCode.S then
        CONTROL.B = 0
    elseif input.KeyCode == Enum.KeyCode.A then
        CONTROL.L = 0
    elseif input.KeyCode == Enum.KeyCode.D then
        CONTROL.R = 0
    elseif input.KeyCode == Enum.KeyCode.E then
        CONTROL.Q = 0
    elseif input.KeyCode == Enum.KeyCode.Q then
        CONTROL.E = 0
    end
end)