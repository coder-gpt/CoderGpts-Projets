local KeySystemAPI = {}
KeySystemAPI.__index = KeySystemAPI

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Constructor
function KeySystemAPI.new(config)
    local self = setmetatable({}, KeySystemAPI)

    self.Title = config.Title or "Key Verification"
    self.SaveFile = config.SaveFile or "SavedKey.txt"
    self.KeyURL = config.KeyURL or ""
    self.ValidKey = config.ValidKey or ""
    self.GetLink = config.GetLink or ""
    self.Debug = config.Debug or false
    self.OnSuccess = config.OnSuccess or function() end

    return self
end

-- Logging Helper
function KeySystemAPI:_log(message)
    if self.Debug then
        print("[KeySystemAPI] " .. tostring(message))
    end
end

-- Safe GUI Parent helper
function KeySystemAPI:_getGuiParent()
    local success, parent = pcall(function()
        return CoreGui
    end)
    if success and parent then
        return parent
    end
    return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Fetch Key dynamically from URL
function KeySystemAPI:FetchRemoteKey()
    if self.KeyURL == "" then return nil end

    local success, response = pcall(function()
        return game:HttpGet(self.KeyURL)
    end)

    if success and response then
        return response:gsub("^%s*(.-)%s*$", "%1")
    end
    return nil
end

-- Check session or stored file
function KeySystemAPI:IsVerified()
    if getgenv().KeyVerified == true then
        self:_log("Session already verified via getgenv().")
        return true
    end

    local expectedKey = self:FetchRemoteKey() or self.ValidKey

    if isfile and isfile(self.SaveFile) then
        local savedKey = readfile(self.SaveFile):gsub("^%s*(.-)%s*$", "%1")
        if savedKey ~= "" and savedKey == expectedKey then
            getgenv().KeyVerified = true
            self:_log("Restored valid key from local storage.")
            return true
        end
    end

    return false
end

-- Validate key string manually
function KeySystemAPI:VerifyKey(inputKey)
    if type(inputKey) ~= "string" then return false, "Key must be a string." end

    local cleanInput = inputKey:gsub("^%s*(.-)%s*$", "%1")
    local expectedKey = self:FetchRemoteKey() or self.ValidKey

    if expectedKey == "" then
        return false, "No target key configured."
    end

    if cleanInput == expectedKey then
        getgenv().KeyVerified = true

        if writefile then
            pcall(function()
                writefile(self.SaveFile, cleanInput)
            end)
        end

        self:_log("Key verified successfully.")
        return true, "Success! Key verified."
    else
        self:_log("Invalid key input.")
        return false, "Invalid key provided."
    end
end

-- Built-in Custom Notification UI
function KeySystemAPI:CreateNotification(text, isError)
    local parent = self:_getGuiParent()
    local notifGui = parent:FindFirstChild("KeySystemNotifGui") or Instance.new("ScreenGui")
    notifGui.Name = "KeySystemNotifGui"
    notifGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 40)
    frame.Position = UDim2.new(0.5, -110, 0.85, 0)
    frame.BackgroundColor3 = isError and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(50, 180, 80)
    frame.BorderSizePixel = 0
    frame.Parent = notifGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame

    task.delay(2.5, function()
        frame:Destroy()
    end)
end

-- Built-in Custom Native GUI Window
function KeySystemAPI:CreateGUI()
    -- Check if auto-login passes
    if self:IsVerified() then
        self.OnSuccess()
        return
    end

    local parent = self:_getGuiParent()
    if parent:FindFirstChild("KeySystemScreenGui") then
        parent.KeySystemScreenGui:Destroy()
    end

    -- Core ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemScreenGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parent

    -- Main Container Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 340, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 10)
    WindowCorner.Parent = MainFrame

    -- Title Bar
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Parent = MainFrame

    -- Input Box
    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0.85, 0, 0, 38)
    InputBox.Position = UDim2.new(0.075, 0, 0.28, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    InputBox.BorderSizePixel = 0
    InputBox.PlaceholderText = "Enter key here..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 14
    InputBox.Font = Enum.Font.SourceSans
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = MainFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputBox

    -- Submit Button
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(self.GetLink ~= "" and 0.41 or 0.85, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.56, 0)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 240)
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14
    SubmitBtn.Font = Enum.Font.SourceSansBold
    SubmitBtn.Parent = MainFrame

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitBtn

    -- Get Key Link Button (Optional)
    if self.GetLink ~= "" then
        local LinkBtn = Instance.new("TextButton")
        LinkBtn.Size = UDim2.new(0.41, 0, 0, 38)
        LinkBtn.Position = UDim2.new(0.515, 0, 0.56, 0)
        LinkBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        LinkBtn.BorderSizePixel = 0
        LinkBtn.Text = "Get Link"
        LinkBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        LinkBtn.TextSize = 14
        LinkBtn.Font = Enum.Font.SourceSansBold
        LinkBtn.Parent = MainFrame

        local LinkCorner = Instance.new("UICorner")
        LinkCorner.CornerRadius = UDim.new(0, 6)
        LinkCorner.Parent = LinkBtn

        LinkBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(self.GetLink)
                self:CreateNotification("Link copied to clipboard!", false)
            else
                self:CreateNotification("Clipboard not supported.", true)
            end
        end)
    end

    -- Click Logic
    SubmitBtn.MouseButton1Click:Connect(function()
        local success, msg = self:VerifyKey(InputBox.Text)
        if success then
            self:CreateNotification("Access Granted!", false)
            task.wait(0.5)
            ScreenGui:Destroy()
            self.OnSuccess()
        else
            self:CreateNotification(msg, true)
        end
    end)
end

return KeySystemAPI
