--[[
═══════════════════════════════════════════
   Flex ur Playtime — Glitcher
   Made with Neo's Hub Framework
   by @mrneoner
═══════════════════════════════════════════
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local Theme = {
	Accent = Color3.fromRGB(111, 90, 255),
	AccentDark = Color3.fromRGB(80, 65, 200),
	Bg = Color3.fromRGB(18, 18, 24),
	Card = Color3.fromRGB(28, 28, 38),
	CardHover = Color3.fromRGB(38, 38, 52),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(140, 140, 160),
	Success = Color3.fromRGB(80, 220, 120),
	Danger = Color3.fromRGB(255, 80, 80),
	DangerDark = Color3.fromRGB(180, 50, 50),
	Warning = Color3.fromRGB(255, 180, 50),
}

local function tween(obj, props, duration, style, direction)
	local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, tweenInfo, props)
	t:Play()
	return t
end

local function Create(className, properties)
	local obj = Instance.new(className)
	for k, v in pairs(properties) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	if properties.Parent then
		obj.Parent = properties.Parent
	end
	return obj
end

local function Corner(parent, radius)
	return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function AddStroke(parent, color, thickness, transparency)
	return Create("UIStroke", {
		Color = color or Theme.Accent,
		Thickness = thickness or 1.5,
		Transparency = transparency or 0.5,
		Parent = parent
	})
end

pcall(function() CoreGui:FindFirstChild("FlexPlaytimeGlitcher"):Destroy() end)
pcall(function() player.PlayerGui:FindFirstChild("FlexPlaytimeGlitcher"):Destroy() end)

local fullSize = UDim2.new(0, 340, 0, 420)
local minSize = UDim2.new(0, 340, 0, 60)

local ScreenGui = Create("ScreenGui", {
	Name = "FlexPlaytimeGlitcher",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = CoreGui
})

local MainFrame = Create("Frame", {
	Name = "Main",
	Size = UDim2.new(0, 0, 0, 0),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Theme.Bg,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = ScreenGui
})
Corner(MainFrame, 16)
AddStroke(MainFrame, Theme.Accent, 2, 0.3)

tween(MainFrame, {Size = fullSize}, 0.5, Enum.EasingStyle.Back)

local Header = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 60),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = MainFrame
})
Corner(Header, 16)

Create("Frame", {
	Size = UDim2.new(1, 0, 0, 20),
	Position = UDim2.new(0, 0, 1, -20),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Header
})

local LogoFrame = Create("Frame", {
	Size = UDim2.new(0, 40, 0, 40),
	Position = UDim2.new(0, 14, 0.5, -20),
	BackgroundColor3 = Theme.Accent,
	BorderSizePixel = 0,
	Parent = Header
})
Corner(LogoFrame, 20)

Create("TextLabel", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "⚡",
	TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	Parent = LogoFrame
})

task.spawn(function()
	while LogoFrame and LogoFrame.Parent do
		tween(LogoFrame, {BackgroundTransparency = 0.3}, 0.8)
		task.wait(0.8)
		tween(LogoFrame, {BackgroundTransparency = 0}, 0.8)
		task.wait(0.8)
	end
end)

Create("TextLabel", {
	Size = UDim2.new(1, -130, 0, 24),
	Position = UDim2.new(0, 64, 0, 10),
	BackgroundTransparency = 1,
	Text = "Flex ur Playtime",
	TextColor3 = Theme.Text,
	Font = Enum.Font.GothamBlack,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Header
})

Create("TextLabel", {
	Size = UDim2.new(1, -130, 0, 16),
	Position = UDim2.new(0, 64, 0, 34),
	BackgroundTransparency = 1,
	Text = "Neo's Hub Framework",
	TextColor3 = Theme.Accent,
	Font = Enum.Font.GothamSemibold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Header
})

local CloseBtn = Create("TextButton", {
	Size = UDim2.new(0, 34, 0, 34),
	Position = UDim2.new(1, -44, 0.5, -17),
	BackgroundColor3 = Theme.Card,
	Text = "X",
	TextColor3 = Theme.Danger,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Parent = Header
})
Corner(CloseBtn, 10)

CloseBtn.MouseEnter:Connect(function()
	tween(CloseBtn, {BackgroundColor3 = Theme.Danger, TextColor3 = Color3.new(1, 1, 1)}, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
	tween(CloseBtn, {BackgroundColor3 = Theme.Card, TextColor3 = Theme.Danger}, 0.15)
end)
CloseBtn.MouseButton1Click:Connect(function()
	tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.delay(0.35, function()
		ScreenGui:Destroy()
	end)
end)

local MinBtn = Create("TextButton", {
	Size = UDim2.new(0, 34, 0, 34),
	Position = UDim2.new(1, -84, 0.5, -17),
	BackgroundColor3 = Theme.Card,
	Text = "−",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Parent = Header
})
Corner(MinBtn, 10)

MinBtn.MouseEnter:Connect(function()
	tween(MinBtn, {BackgroundColor3 = Theme.CardHover}, 0.15)
end)
MinBtn.MouseLeave:Connect(function()
	tween(MinBtn, {BackgroundColor3 = Theme.Card}, 0.15)
end)

local Content = Create("Frame", {
	Name = "Content",
	Size = UDim2.new(1, -24, 1, -72),
	Position = UDim2.new(0, 12, 0, 66),
	BackgroundTransparency = 1,
	Parent = MainFrame
})

local InputSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 80),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(InputSection, 12)

Create("TextLabel", {
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.new(0, 14, 0, 10),
	BackgroundTransparency = 1,
	Text = "📊 Enter Number",
	TextColor3 = Theme.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = InputSection
})

local InputBox = Create("TextBox", {
	Size = UDim2.new(1, -28, 0, 38),
	Position = UDim2.new(0, 14, 0, 34),
	BackgroundColor3 = Theme.Bg,
	Text = "",
	PlaceholderText = "Enter playtime value...",
	PlaceholderColor3 = Theme.SubText,
	TextColor3 = Theme.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Parent = InputSection
})
Corner(InputBox, 8)
local InputStroke = AddStroke(InputBox, Theme.Accent, 1, 0.7)

InputBox.Focused:Connect(function()
	tween(InputStroke, {Transparency = 0.2}, 0.15)
end)
InputBox.FocusLost:Connect(function()
	tween(InputStroke, {Transparency = 0.7}, 0.15)
end)

local ButtonsSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 50),
	Position = UDim2.new(0, 0, 0, 90),
	BackgroundTransparency = 1,
	Parent = Content
})

local SendBtn = Create("TextButton", {
	Size = UDim2.new(0.48, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundColor3 = Theme.Accent,
	Text = "🚀  SEND",
	TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBlack,
	TextSize = 14,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Parent = ButtonsSection
})
Corner(SendBtn, 10)

SendBtn.MouseEnter:Connect(function()
	tween(SendBtn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
end)
SendBtn.MouseLeave:Connect(function()
	tween(SendBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
end)

local glitching = false

local GlitchBtn = Create("TextButton", {
	Size = UDim2.new(0.48, 0, 1, 0),
	Position = UDim2.new(0.52, 0, 0, 0),
	BackgroundColor3 = Theme.Card,
	Text = "⚡  GLITCH",
	TextColor3 = Theme.Warning,
	Font = Enum.Font.GothamBlack,
	TextSize = 14,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Parent = ButtonsSection
})
Corner(GlitchBtn, 10)
local GlitchStroke = AddStroke(GlitchBtn, Theme.Warning, 2, 0.5)

GlitchBtn.MouseEnter:Connect(function()
	if glitching then
		tween(GlitchBtn, {BackgroundColor3 = Theme.DangerDark}, 0.15)
	else
		tween(GlitchBtn, {BackgroundColor3 = Theme.CardHover}, 0.15)
	end
end)
GlitchBtn.MouseLeave:Connect(function()
	if glitching then
		tween(GlitchBtn, {BackgroundColor3 = Theme.Danger}, 0.15)
	else
		tween(GlitchBtn, {BackgroundColor3 = Theme.Card}, 0.15)
	end
end)

-- ═══ STATUS SECTION ═══
local StatusSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 100),
	Position = UDim2.new(0, 0, 0, 150),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(StatusSection, 12)

Create("TextLabel", {
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.new(0, 14, 0, 10),
	BackgroundTransparency = 1,
	Text = "📝 Status",
	TextColor3 = Theme.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = StatusSection
})

local ResultFrame = Create("Frame", {
	Size = UDim2.new(1, -28, 0, 58),
	Position = UDim2.new(0, 14, 0, 34),
	BackgroundColor3 = Theme.Bg,
	BorderSizePixel = 0,
	Parent = StatusSection
})
Corner(ResultFrame, 8)

local ResultIcon = Create("TextLabel", {
	Size = UDim2.new(0, 40, 1, 0),
	Position = UDim2.new(0, 14, 0, 0),
	BackgroundTransparency = 1,
	Text = "💤",
	TextSize = 22,
	Parent = ResultFrame
})

local ResultText = Create("TextLabel", {
	Size = UDim2.new(1, -80, 0, 20),
	Position = UDim2.new(0, 58, 0, 10),
	BackgroundTransparency = 1,
	Text = "Waiting for action...",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = ResultFrame
})

local ResultSubText = Create("TextLabel", {
	Size = UDim2.new(1, -80, 0, 16),
	Position = UDim2.new(0, 58, 0, 30),
	BackgroundTransparency = 1,
	Text = "Enter a number and click Send",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamSemibold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTransparency = 0.3,
	Parent = ResultFrame
})

local StatsBar = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 36),
	Position = UDim2.new(0, 0, 0, 260),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(StatsBar, 10)

local SentCount = 0
local SentCountLabel = Create("TextLabel", {
	Size = UDim2.new(0.5, 0, 1, 0),
	Position = UDim2.new(0, 14, 0, 0),
	BackgroundTransparency = 1,
	Text = "📤 Sent: 0",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = StatsBar
})

local GlitchStatusLabel = Create("TextLabel", {
	Size = UDim2.new(0.5, -14, 1, 0),
	Position = UDim2.new(0.5, 0, 0, 0),
	BackgroundTransparency = 1,
	Text = "⚡ Glitch: OFF",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = StatsBar
})

local Footer = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 30),
	Position = UDim2.new(0, 0, 0, 302),
	BackgroundTransparency = 1,
	Parent = Content
})

Create("TextLabel", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "Made with 💜 by @mrneoner • Neo's Hub",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamSemibold,
	TextSize = 11,
	TextTransparency = 0.3,
	Parent = Footer
})

local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mousePos = input.Position
		local closeBtnPos = CloseBtn.AbsolutePosition
		local closeBtnSize = CloseBtn.AbsoluteSize
		local minBtnPos = MinBtn.AbsolutePosition
		local minBtnSize = MinBtn.AbsoluteSize
		
		local onCloseBtn = mousePos.X >= closeBtnPos.X and mousePos.X <= closeBtnPos.X + closeBtnSize.X and mousePos.Y >= closeBtnPos.Y and mousePos.Y <= closeBtnPos.Y + closeBtnSize.Y
		local onMinBtn = mousePos.X >= minBtnPos.X and mousePos.X <= minBtnPos.X + minBtnSize.X and mousePos.Y >= minBtnPos.Y and mousePos.Y <= minBtnPos.Y + minBtnSize.Y
		
		if not onCloseBtn and not onMinBtn then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

local minimized = false

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	if minimized then
		MinBtn.Text = "+"
		Content.Visible = false
		tween(MainFrame, {Size = minSize}, 0.25, Enum.EasingStyle.Quint)
	else
		MinBtn.Text = "−"
		tween(MainFrame, {Size = fullSize}, 0.25, Enum.EasingStyle.Quint)
		task.delay(0.2, function()
			Content.Visible = true
		end)
	end
end)

local remote = ReplicatedStorage:WaitForChild("UpdatePlaytime", 10)

local function updateStatus(icon, text, subtext, color)
	ResultIcon.Text = icon
	ResultText.Text = text
	ResultText.TextColor3 = color or Theme.Text
	ResultSubText.Text = subtext
end

local function setGlitchButtonState(active)
	if active then
		GlitchBtn.Text = "🛑  STOP GLITCH"
		GlitchBtn.TextColor3 = Color3.new(1, 1, 1)
		GlitchStroke.Color = Theme.Danger
		tween(GlitchBtn, {BackgroundColor3 = Theme.Danger}, 0.2)
		GlitchStatusLabel.Text = "🔥 Glitch: ON"
		GlitchStatusLabel.TextColor3 = Theme.Danger
	else
		GlitchBtn.Text = "⚡  GLITCH"
		GlitchBtn.TextColor3 = Theme.Warning
		GlitchStroke.Color = Theme.Warning
		tween(GlitchBtn, {BackgroundColor3 = Theme.Card}, 0.2)
		GlitchStatusLabel.Text = "⚡ Glitch: OFF"
		GlitchStatusLabel.TextColor3 = Theme.SubText
		LogoFrame.BackgroundColor3 = Theme.Accent
	end
end

SendBtn.MouseButton1Click:Connect(function()
	local number = tonumber(InputBox.Text)
	if number then
		if remote then
			remote:FireServer(number)
			SentCount = SentCount + 1
			SentCountLabel.Text = "📤 Sent: " .. SentCount
			updateStatus("✅", "Sent Successfully!", "Value: " .. tostring(number), Theme.Success)
			
			tween(ResultFrame, {BackgroundColor3 = Theme.Success}, 0.1)
			task.delay(0.1, function()
				tween(ResultFrame, {BackgroundColor3 = Theme.Bg}, 0.3)
			end)
		else
			updateStatus("❌", "Remote Not Found!", "UpdatePlaytime doesn't exist", Theme.Danger)
		end
	else
		updateStatus("⚠️", "Invalid Number!", "Please enter a valid number", Theme.Warning)
		
		local originalPos = InputBox.Position
		for i = 1, 3 do
			tween(InputBox, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05)
			task.wait(0.05)
			tween(InputBox, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05)
			task.wait(0.05)
		end
		tween(InputBox, {Position = originalPos}, 0.05)
	end
end)

GlitchBtn.MouseButton1Click:Connect(function()
	glitching = not glitching
	setGlitchButtonState(glitching)
	
	if glitching then
		task.spawn(function()
			local num = "123456"
			local glitchCount = 0
			
			while glitching do
				if remote then
					remote:FireServer(tonumber(num))
					glitchCount = glitchCount + 1
					SentCount = SentCount + 1
					SentCountLabel.Text = "📤 Sent: " .. SentCount
					
					updateStatus("🔥", "Glitching... [" .. glitchCount .. "]", "Current: " .. num, Theme.Danger)
					
					local hue = (tick() * 2) % 1
					LogoFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 1)
				end
				
				local newDigit = tostring(math.random(0, 9))
				num = num:sub(2) .. newDigit
				
				task.wait(0.001)
			end
		end)
	else
		updateStatus("⏹️", "Glitch Stopped", "Click Glitch to restart", Theme.SubText)
	end
end)

player.CharacterAdded:Connect(function()
	glitching = false
	setGlitchButtonState(false)
	updateStatus("🔄", "Character Respawned", "Glitch was reset", Theme.SubText)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.Insert then
		MainFrame.Visible = not MainFrame.Visible
	end
	
	if input.KeyCode == Enum.KeyCode.Return and InputBox:IsFocused() then
		InputBox:ReleaseFocus()
		task.defer(function()
			local number = tonumber(InputBox.Text)
			if number and remote then
				remote:FireServer(number)
				SentCount = SentCount + 1
				SentCountLabel.Text = "📤 Sent: " .. SentCount
				updateStatus("✅", "Sent Successfully!", "Value: " .. tostring(number), Theme.Success)
				tween(ResultFrame, {BackgroundColor3 = Theme.Success}, 0.1)
				task.delay(0.1, function()
					tween(ResultFrame, {BackgroundColor3 = Theme.Bg}, 0.3)
				end)
			end
		end)
	end
end)

task.delay(0.5, function()
	if remote then
		updateStatus("✅", "Ready!", "Remote found successfully", Theme.Success)
		task.delay(2, function()
			updateStatus("💤", "Waiting...", "Enter a number and click Send", Theme.SubText)
		end)
	else
		updateStatus("❌", "Remote Not Found!", "UpdatePlaytime not found", Theme.Danger)
	end
end)

print("═══════════════════════════════════════════")
print("  Flex ur Playtime — Glitcher")
print("  Neo's Hub Framework by @mrneoner")
print("  Press INSERT to toggle visibility")
print("═══════════════════════════════════════════")
