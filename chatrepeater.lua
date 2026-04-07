--[[
═══════════════════════════════════════════
   Chat Auto-Repeater — Neo's Hub
   Made with Neo's Hub Framework
   by @mrneoner
═══════════════════════════════════════════
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")

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

-- Restricted regions (chat limited or Roblox blocked) 
local restrictedRegions = {
	RU = "Russia",
	CN = "China",
	TR = "Turkey",
	KP = "North Korea",
	IR = "Iran",
	SY = "Syria",
	UA = "Ukraine (partial)"
}

local userRegion = "Unknown"
local isRestricted = false
local regionChecked = false

task.spawn(function()
	pcall(function()
		local countryCode = LocalizationService:GetCountryRegionForPlayerAsync(player)
		userRegion = countryCode
		
		if restrictedRegions[countryCode] then
			isRestricted = true
		end
		
		regionChecked = true
	end)
	if not regionChecked then
		regionChecked = true
	end
end)

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

local function clamp(n, a, b)
	if n < a then return a end
	if n > b then return b end
	return n
end

local function safeWait(seconds)
	local t = os.clock()
	while os.clock() - t < seconds do
		RunService.Heartbeat:Wait()
	end
end

local function canUseTextChatService()
	return TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
end

local function sendChatMessage(message)
	message = tostring(message or "")
	if message == "" then
		return false, "Message is empty"
	end

	if canUseTextChatService() then
		local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
		if not channel then
			for _, ch in ipairs(TextChatService.TextChannels:GetChildren()) do
				if ch:IsA("TextChannel") then
					channel = ch
					break
				end
			end
		end

		if channel then
			local ok, err = pcall(function()
				channel:SendAsync(message)
			end)
			if ok then
				return true
			else
				return false, tostring(err)
			end
		end
	end

	local ok, err = pcall(function()
		local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
			chatEvents.SayMessageRequest:FireServer(message, "All")
		else
			error("Legacy chat events not found")
		end
	end)

	if ok then
		return true
	end
	return false, tostring(err)
end

pcall(function() CoreGui:FindFirstChild("ChatAutoRepeaterNeo"):Destroy() end)
pcall(function() player.PlayerGui:FindFirstChild("ChatAutoRepeaterNeo"):Destroy() end)

local fullSize = UDim2.new(0, 360, 0, 480)
local minSize = UDim2.new(0, 360, 0, 60)

local ScreenGui = Create("ScreenGui", {
	Name = "ChatAutoRepeaterNeo",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = CoreGui
})

local NotificationContainer = Create("Frame", {
	Name = "NotificationContainer",
	Size = UDim2.new(0, 300, 0, 0),
	Position = UDim2.new(1, -320, 0, 20),
	BackgroundTransparency = 1,
	Parent = ScreenGui
})

Create("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
	Parent = NotificationContainer
})

local function showNotification(title, message, icon, duration, color)
	icon = icon or "💬"
	duration = duration or 4
	color = color or Theme.Accent
	
	local notif = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.Bg,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = NotificationContainer
	})
	Corner(notif, 12)
	AddStroke(notif, color, 2, 0.3)
	
	local notifInner = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		BackgroundTransparency = 1,
		Parent = notif
	})
	
	local colorBar = Create("Frame", {
		Size = UDim2.new(0, 4, 1, -16),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = notifInner
	})
	Corner(colorBar, 2)
	
	Create("TextLabel", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(0, 20, 0, 12),
		BackgroundTransparency = 1,
		Text = icon,
		TextSize = 20,
		Parent = notifInner
	})
	
	Create("TextLabel", {
		Size = UDim2.new(1, -70, 0, 20),
		Position = UDim2.new(0, 54, 0, 12),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = notifInner
	})
	
	Create("TextLabel", {
		Size = UDim2.new(1, -70, 0, 30),
		Position = UDim2.new(0, 54, 0, 32),
		BackgroundTransparency = 1,
		Text = message,
		TextColor3 = Theme.SubText,
		Font = Enum.Font.GothamSemibold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = notifInner
	})
	
	local progressBg = Create("Frame", {
		Size = UDim2.new(1, -24, 0, 3),
		Position = UDim2.new(0, 12, 1, -8),
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		Parent = notifInner
	})
	Corner(progressBg, 2)
	
	local progressBar = Create("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = progressBg
	})
	Corner(progressBar, 2)
	
	tween(notif, {Size = UDim2.new(1, 0, 0, 70)}, 0.3, Enum.EasingStyle.Back)
	tween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
	
	task.delay(duration, function()
		tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
		task.delay(0.35, function()
			notif:Destroy()
		end)
	end)
	
	return notif
end

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
	ClipsDescendants = true,
	Parent = MainFrame
})
Corner(Header, 16)

local HeaderBottomCover = Create("Frame", {
	Name = "BottomCover",
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
	Text = "💬",
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
	Text = "Chat Auto-Repeater",
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
		MainFrame.Visible = false
		MainFrame.Size = fullSize
		
		showNotification(
			"Menu Hidden",
			"Press INSERT to open again",
			"👁️",
			4,
			Theme.Accent
		)
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

local ContentContainer = Create("Frame", {
	Name = "ContentContainer",
	Size = UDim2.new(1, 0, 1, -66),
	Position = UDim2.new(0, 0, 0, 66),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Parent = MainFrame
})

local ScrollingContent = Create("ScrollingFrame", {
	Name = "ScrollingContent",
	Size = UDim2.new(1, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Theme.Accent,
	ScrollBarImageTransparency = 0.3,
	CanvasSize = UDim2.new(0, 0, 0, 460),
	AutomaticCanvasSize = Enum.AutomaticSize.None,
	Parent = ContentContainer
})

local Content = Create("Frame", {
	Name = "Content",
	Size = UDim2.new(1, -24, 0, 450),
	Position = UDim2.new(0, 12, 0, 0),
	BackgroundTransparency = 1,
	Parent = ScrollingContent
})

local MessageSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 80),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(MessageSection, 12)

Create("TextLabel", {
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.new(0, 14, 0, 10),
	BackgroundTransparency = 1,
	Text = "💬 Message",
	TextColor3 = Theme.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = MessageSection
})

local MessageBox = Create("TextBox", {
	Size = UDim2.new(1, -28, 0, 38),
	Position = UDim2.new(0, 14, 0, 34),
	BackgroundColor3 = Theme.Bg,
	Text = "Hello world!",
	PlaceholderText = "Type message to repeat...",
	PlaceholderColor3 = Theme.SubText,
	TextColor3 = Theme.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Parent = MessageSection
})
Corner(MessageBox, 8)
local MessageStroke = AddStroke(MessageBox, Theme.Accent, 1, 0.7)

MessageBox.Focused:Connect(function()
	tween(MessageStroke, {Transparency = 0.2}, 0.15)
end)
MessageBox.FocusLost:Connect(function()
	tween(MessageStroke, {Transparency = 0.7}, 0.15)
end)

local IntervalSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 80),
	Position = UDim2.new(0, 0, 0, 90),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(IntervalSection, 12)

Create("TextLabel", {
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.new(0, 14, 0, 10),
	BackgroundTransparency = 1,
	Text = "⏱️ Interval (seconds)",
	TextColor3 = Theme.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = IntervalSection
})

local IntervalBox = Create("TextBox", {
	Size = UDim2.new(0.4, -14, 0, 38),
	Position = UDim2.new(0, 14, 0, 34),
	BackgroundColor3 = Theme.Bg,
	Text = "5",
	PlaceholderText = "Min 3",
	PlaceholderColor3 = Theme.SubText,
	TextColor3 = Theme.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Parent = IntervalSection
})
Corner(IntervalBox, 8)
local IntervalStroke = AddStroke(IntervalBox, Theme.Accent, 1, 0.7)

IntervalBox.Focused:Connect(function()
	tween(IntervalStroke, {Transparency = 0.2}, 0.15)
end)
IntervalBox.FocusLost:Connect(function()
	tween(IntervalStroke, {Transparency = 0.7}, 0.15)
end)

Create("TextLabel", {
	Size = UDim2.new(0.6, -20, 0, 38),
	Position = UDim2.new(0.4, 6, 0, 34),
	BackgroundTransparency = 1,
	Text = "📌 Range: 3-120 seconds",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamSemibold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = IntervalSection
})

local ButtonsSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 50),
	Position = UDim2.new(0, 0, 0, 180),
	BackgroundTransparency = 1,
	Parent = Content
})

local StartBtn = Create("TextButton", {
	Size = UDim2.new(0.48, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundColor3 = Theme.Accent,
	Text = "▶️  START",
	TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBlack,
	TextSize = 14,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Parent = ButtonsSection
})
Corner(StartBtn, 10)

StartBtn.MouseEnter:Connect(function()
	tween(StartBtn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
end)
StartBtn.MouseLeave:Connect(function()
	tween(StartBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
end)

local StopBtn = Create("TextButton", {
	Size = UDim2.new(0.48, 0, 1, 0),
	Position = UDim2.new(0.52, 0, 0, 0),
	BackgroundColor3 = Theme.Card,
	Text = "⏹️  STOP",
	TextColor3 = Theme.Danger,
	Font = Enum.Font.GothamBlack,
	TextSize = 14,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Parent = ButtonsSection
})
Corner(StopBtn, 10)
AddStroke(StopBtn, Theme.Danger, 2, 0.5)

StopBtn.MouseEnter:Connect(function()
	tween(StopBtn, {BackgroundColor3 = Theme.Danger, TextColor3 = Color3.new(1, 1, 1)}, 0.15)
end)
StopBtn.MouseLeave:Connect(function()
	tween(StopBtn, {BackgroundColor3 = Theme.Card, TextColor3 = Theme.Danger}, 0.15)
end)

local StatusSection = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 100),
	Position = UDim2.new(0, 0, 0, 240),
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
	Text = "Idle",
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
	Text = "Click START to begin",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamSemibold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTransparency = 0.3,
	Parent = ResultFrame
})

local StatsBar = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 36),
	Position = UDim2.new(0, 0, 0, 350),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(StatsBar, 10)

local MessagesSentCount = 0
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

local RunStatusLabel = Create("TextLabel", {
	Size = UDim2.new(0.5, -14, 1, 0),
	Position = UDim2.new(0.5, 0, 0, 0),
	BackgroundTransparency = 1,
	Text = "🔴 Stopped",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = StatsBar
})

local RegionBar = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 30),
	Position = UDim2.new(0, 0, 0, 394),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Parent = Content
})
Corner(RegionBar, 8)

local RegionLabel = Create("TextLabel", {
	Size = UDim2.new(1, -20, 1, 0),
	Position = UDim2.new(0, 10, 0, 0),
	BackgroundTransparency = 1,
	Text = "🌍 Region: Checking...",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamSemibold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = RegionBar
})

local Footer = Create("Frame", {
	Size = UDim2.new(1, 0, 0, 20),
	Position = UDim2.new(0, 0, 0, 430),
	BackgroundTransparency = 1,
	Parent = Content
})

Create("TextLabel", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "Made with 💜 by @mrneoner • F6 Toggle • INSERT Hide",
	TextColor3 = Theme.SubText,
	Font = Enum.Font.GothamSemibold,
	TextSize = 10,
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
		HeaderBottomCover.Visible = false
		ContentContainer.Visible = false
		tween(MainFrame, {Size = minSize}, 0.25, Enum.EasingStyle.Quint)
	else
		MinBtn.Text = "−"
		tween(MainFrame, {Size = fullSize}, 0.25, Enum.EasingStyle.Quint)
		task.delay(0.15, function()
			HeaderBottomCover.Visible = true
			ContentContainer.Visible = true
		end)
	end
end)

local running = false
local MIN_INTERVAL = 3
local MAX_INTERVAL = 120
local MAX_MESSAGE_LEN = 120

local function updateStatus(icon, text, subtext, color)
	ResultIcon.Text = icon
	ResultText.Text = text
	ResultText.TextColor3 = color or Theme.Text
	ResultSubText.Text = subtext
end

local function getInterval()
	local n = tonumber(IntervalBox.Text)
	if not n then
		return MIN_INTERVAL
	end
	return clamp(n, MIN_INTERVAL, MAX_INTERVAL)
end

local function getMessage()
	local msg = tostring(MessageBox.Text or "")
	msg = string.gsub(msg, "\n", " ")
	msg = string.sub(msg, 1, MAX_MESSAGE_LEN)
	return msg
end

local function setRunningState(isRunning)
	if isRunning then
		RunStatusLabel.Text = "🟢 Running"
		RunStatusLabel.TextColor3 = Theme.Success
		
		task.spawn(function()
			while running and LogoFrame and LogoFrame.Parent do
				local hue = (tick() * 0.5) % 1
				LogoFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.6, 0.9)
				task.wait(0.05)
			end
			if LogoFrame and LogoFrame.Parent then
				LogoFrame.BackgroundColor3 = Theme.Accent
			end
		end)
	else
		RunStatusLabel.Text = "🔴 Stopped"
		RunStatusLabel.TextColor3 = Theme.SubText
		LogoFrame.BackgroundColor3 = Theme.Accent
	end
end

local function stopRepeater()
	running = false
	setRunningState(false)
	updateStatus("⏹️", "Stopped", "Click START to begin again", Theme.SubText)
end

local function startRepeater()
	if running then
		return
	end
	
	local msg = getMessage()
	if msg == "" then
		updateStatus("⚠️", "No Message!", "Please enter a message first", Theme.Warning)
		
		local originalPos = MessageBox.Position
		for i = 1, 3 do
			tween(MessageBox, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05)
			task.wait(0.05)
			tween(MessageBox, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05)
			task.wait(0.05)
		end
		tween(MessageBox, {Position = originalPos}, 0.05)
		return
	end
	
	running = true
	setRunningState(true)
	updateStatus("🔄", "Running...", "Sending messages automatically", Theme.Success)
	
	showNotification(
		"Repeater Started",
		"Messages will be sent every " .. getInterval() .. " seconds",
		"▶️",
		3,
		Theme.Success
	)
	
	tween(ResultFrame, {BackgroundColor3 = Theme.Success}, 0.1)
	task.delay(0.1, function()
		tween(ResultFrame, {BackgroundColor3 = Theme.Bg}, 0.3)
	end)
	
	task.spawn(function()
		while running do
			local interval = getInterval()
			local message = getMessage()
			
			if message == "" then
				updateStatus("⚠️", "Message Empty", "Paused - add a message", Theme.Warning)
				safeWait(interval)
			else
				local ok, err = sendChatMessage(message)
				if ok then
					MessagesSentCount = MessagesSentCount + 1
					SentCountLabel.Text = "📤 Sent: " .. MessagesSentCount
					updateStatus("✅", "Message Sent!", "Next in " .. interval .. "s", Theme.Success)
					
					tween(ResultFrame, {BackgroundColor3 = Theme.Success}, 0.1)
					task.delay(0.1, function()
						tween(ResultFrame, {BackgroundColor3 = Theme.Bg}, 0.3)
					end)
				else
					updateStatus("❌", "Send Failed", tostring(err), Theme.Danger)
				end
				safeWait(interval)
			end
		end
	end)
end

StartBtn.MouseButton1Click:Connect(function()
	startRepeater()
end)

StopBtn.MouseButton1Click:Connect(function()
	if running then
		stopRepeater()
		showNotification(
			"Repeater Stopped",
			"Message sending has been stopped",
			"⏹️",
			3,
			Theme.Warning
		)
	end
end)

IntervalBox.FocusLost:Connect(function()
	IntervalBox.Text = tostring(getInterval())
end)

MessageBox.FocusLost:Connect(function()
	MessageBox.Text = getMessage()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.Insert then
		if MainFrame.Visible then
			tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			task.delay(0.35, function()
				MainFrame.Visible = false
				MainFrame.Size = fullSize
			end)
		else
			MainFrame.Size = UDim2.new(0, 0, 0, 0)
			MainFrame.Visible = true
			tween(MainFrame, {Size = minimized and minSize or fullSize}, 0.4, Enum.EasingStyle.Back)
		end
	end
	
	if input.KeyCode == Enum.KeyCode.F6 then
		if running then
			stopRepeater()
			showNotification(
				"Repeater Stopped",
				"Toggled off via F6 hotkey",
				"⏹️",
				3,
				Theme.Warning
			)
		else
			startRepeater()
		end
	end
end)

player.CharacterAdded:Connect(function()
	running = false
	setRunningState(false)
	updateStatus("🔄", "Character Respawned", "Repeater was stopped", Theme.SubText)
end)

task.spawn(function()
	while not regionChecked do
		task.wait(0.1)
	end
	
	local regionName = restrictedRegions[userRegion] or userRegion
	
	if isRestricted then
		RegionLabel.Text = "🌍 Region: " .. regionName .. " — ⚠️ May not work"
		RegionLabel.TextColor3 = Theme.Warning
		
		showNotification(
			"Region Warning",
			"Chat may be restricted in " .. regionName,
			"⚠️",
			5,
			Theme.Warning
		)
	else
		RegionLabel.Text = "🌍 Region: " .. regionName .. " — ✅ OK"
		RegionLabel.TextColor3 = Theme.Success
	end
end)

task.delay(0.5, function()
	updateStatus("✅", "Ready!", "Enter message and click START", Theme.Success)
	
	showNotification(
		"Script Loaded",
		"Chat Auto-Repeater is ready!",
		"💬",
		3,
		Theme.Accent
	)
	
	task.delay(2, function()
		if not running then
			updateStatus("💤", "Idle", "Click START to begin", Theme.SubText)
		end
	end)
end)

print("═══════════════════════════════════════════")
print("  Chat Auto-Repeater — Neo's Hub")
print("  Neo's Hub Framework by @mrneoner")
print("  Press INSERT to toggle visibility")
print("  Press F6 to toggle repeater")
print("═══════════════════════════════════════════")
