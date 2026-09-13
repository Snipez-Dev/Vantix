-- // VantixUI Elixer
-- Instance based UI library. Window -> Page -> Section -> element.
-- loadstring(game:HttpGet(URL))({ cheatname = 'Vantix', gamename = 'Game', fileext = '.json' })

local Players      = game:GetService("Players")
local UserInput    = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")

-- gethui keeps the ScreenGui out of the game's PlayerGui scan; cloneref(CoreGui)
-- is the fallback for executors that expose cloneref but not gethui.
local host = CoreGui
if typeof(gethui) == "function" then
	local ok, res = pcall(gethui)
	if ok and res then host = res end
elseif typeof(cloneref) == "function" then
	local ok, res = pcall(cloneref, CoreGui)
	if ok and res then host = res end
end

local library = {}
local utility = {}
local obelus = {
	connections = {},
	windows     = {},
}

library.version   = "1.0.0"
library.fileext   = ".json"
library.cheatname = "Vantix"
library.gamename  = "Universal"
library.open      = true
library.toggleKey = Enum.KeyCode.RightShift
library.builtInToggle = true

library.Flags   = {}
library.Options = {}
library.flags   = library.Flags
library.options = library.Options

library.Theme = {
	Accent     = Color3.fromRGB(170, 85, 235),
	AccentDim  = Color3.fromRGB(101, 51, 141),
	Backdrop   = Color3.fromRGB(12, 12, 12),
	Shell      = Color3.fromRGB(51, 51, 51),
	ShellLine  = Color3.fromRGB(0, 0, 0),
	Panel      = Color3.fromRGB(19, 19, 19),
	Page       = Color3.fromRGB(13, 13, 13),
	Rail       = Color3.fromRGB(1, 1, 1),
	Tab        = Color3.fromRGB(41, 41, 41),
	Section    = Color3.fromRGB(45, 45, 45),
	Control    = Color3.fromRGB(25, 25, 25),
	Off        = Color3.fromRGB(63, 63, 63),
	Line       = Color3.fromRGB(48, 48, 48),
	Text       = Color3.fromRGB(180, 180, 180),
	TextBright = Color3.fromRGB(205, 205, 205),
	TextDim    = Color3.fromRGB(142, 142, 142),
	Muted      = Color3.fromRGB(90, 90, 90),
	White      = Color3.fromRGB(255, 255, 255),
	Risk       = Color3.fromRGB(205, 70, 70),
	Good       = Color3.fromRGB(80, 200, 120),
}

local Theme = library.Theme
local FONT = "Code"
local TEXT_SIZE = 13
local CORNER = 2

-- Roblox auto-translates any text that matches the experience's translation
-- table, which turns English labels back into the client's locale. Library text
-- is authored, never localized, so opt every text element out.
local TEXT_CLASSES = { TextLabel = true, TextButton = true, TextBox = true }

local function New(class, props, parent)
	local inst = Instance.new(class)
	if props then
		for key, value in pairs(props) do
			if key ~= "Parent" then
				inst[key] = value
			end
		end
	end
	if TEXT_CLASSES[class] and (not props or props.AutoLocalize == nil) then
		inst.AutoLocalize = false
	end
	local par = (props and props.Parent) or parent
	if par then inst.Parent = par end
	return inst
end

local function Corner(inst, radius)
	return New("UICorner", { CornerRadius = UDim.new(0, radius or CORNER) }, inst)
end

local function Stroke(inst, color, thickness, transparency)
	return New("UIStroke", {
		Color = color or Theme.Line,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
end

local function Gradient(parent, from, to, rotation)
	return New("UIGradient", {
		Color = ColorSequence.new(from, to),
		Rotation = rotation or 90,
	}, parent)
end

local function Tween(inst, time, props, style)
	local tween = TweenService:Create(inst, TweenInfo.new(time, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tween:Play()
	return tween
end

local function Vertical(holder, padding)
	return New("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDim.new(0, padding or 5),
	}, holder)
end

local function Pad(inst, top, bottom, left, right)
	return New("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft = UDim.new(0, left or 0),
		PaddingRight = UDim.new(0, right or 0),
	}, inst)
end

local function Round(value, step)
	if step <= 0 then return value end
	return math.floor(value / step + 0.5) * step
end

local function Format(value)
	local text = string.format("%.4f", value)
	text = text:gsub("0+$", ""):gsub("%.$", "")
	return text
end

local function Mouse()
	return UserInput:GetMouseLocation()
end

function utility:Create(createInfo)
	local info = createInfo or {}
	if not info.Type then return nil end
	return New(info.Type, info.Properties)
end

function utility:Connection(connectionInfo)
	local info = connectionInfo or {}
	if not info.Type then return nil end
	local connection = info.Type:Connect(info.Callback or function() end)
	obelus.connections[#obelus.connections + 1] = connection
	return connection
end

function utility:RemoveConnection(connectionInfo)
	local info = connectionInfo or {}
	local connection = info.Connection
	if not connection then return end
	local index = table.find(obelus.connections, connection)
	if index then
		connection:Disconnect()
		table.remove(obelus.connections, index)
	end
end

function utility:DisconnectAll()
	for _, connection in ipairs(obelus.connections) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(obelus.connections)
end

local overlay = New("ScreenGui", {
	Name = "VantixElixerOverlay",
	DisplayOrder = 8889,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	Parent = host,
})

local tooltip = New("TextLabel", {
	Name = "Tooltip",
	BackgroundColor3 = Theme.Backdrop,
	BorderMode = Enum.BorderMode.Inset,
	BorderColor3 = Theme.AccentDim,
	BorderSizePixel = 1,
	Font = FONT,
	TextSize = 12,
	TextColor3 = Theme.Text,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrapped = true,
	Visible = false,
	Size = UDim2.new(0, 220, 0, 26),
	AutomaticSize = Enum.AutomaticSize.Y,
	ZIndex = 5,
}, overlay)
Pad(tooltip, 5, 5, 7, 7)

local function PositionTooltip()
	if not tooltip.Visible then return end
	local pos = Mouse()
	local size = tooltip.AbsoluteSize
	tooltip.Position = UDim2.fromOffset(math.min(pos.X + 14, workspace.CurrentCamera.ViewportSize.X - size.X - 8), pos.Y + 14)
end

local function ShowTooltip(text)
	if not text or text == "" then return end
	tooltip.Text = tostring(text)
	tooltip.Visible = true
	PositionTooltip()
end

local function HideTooltip()
	tooltip.Visible = false
end

utility:Connection({ Type = UserInput.InputChanged, Callback = function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then PositionTooltip() end
end })

local toastHolder = New("Frame", {
	Name = "Toasts",
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -18, 1, -18),
	Size = UDim2.new(0, 262, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	ZIndex = 4,
}, overlay)
Vertical(toastHolder, 6)

local toastOrder = 0

local function Notify(message, duration, color)
	if not overlay then return end
	toastOrder = toastOrder + 1
	local accent = color or Theme.Accent
	local card = New("Frame", {
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = toastOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 4,
	}, toastHolder)
	Corner(card, 3)
	local stroke = Stroke(card, Theme.Line, 1, 0.2)
	local stripe = New("Frame", {
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 2, 1, 0),
		ZIndex = 5,
	}, card)
	Pad(card, 9, 9, 12, 12)
	local label = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 0),
		Size = UDim2.new(1, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Font = FONT,
		TextSize = 12,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Text = tostring(message),
		ZIndex = 5,
	}, card)
	task.delay(duration or 4, function()
		if not card.Parent then return end
		Tween(card, 0.25, { BackgroundTransparency = 1 })
		Tween(stripe, 0.25, { BackgroundTransparency = 1 })
		Tween(stroke, 0.25, { Transparency = 1 })
		Tween(label, 0.25, { TextTransparency = 1 })
		task.delay(0.3, function() card:Destroy() end)
	end)
end

function library:Notify(message, duration, color)
	Notify(message, duration, color)
end

library.SendNotification = library.Notify

-- Section methods live on a shared metatable so every page builds sections with
-- the full element set without re-declaring it per page.
local Section = {}
Section.__index = Section

local Page = {}
Page.__index = Page

-- // Keybind indicators

library.Indicators = {}
library.indicatorsVisible = true
library.indicatorPosition = UDim2.new(1, -18, 0, 110)

local indicatorPanel, indicatorConn

local function refreshIndicators()
	if not indicatorPanel then return end
	for _, entry in ipairs(library.Indicators) do
		local row = entry.row
		if row then
			local on = false
			if entry.getState then
				local ok, state = pcall(entry.getState)
				on = (ok and state) and true or false
			end
			local key = entry.getKey and entry.getKey() or nil
			local keyName = "None"
			if key ~= nil then
				if typeof(key) == "EnumItem" then keyName = key.Name
				elseif type(key) == "string" then keyName = key
				else keyName = tostring(key) end
			end
			local text = string.format("%s   [%s]", entry.label, keyName)
			if row.label.Text ~= text then row.label.Text = text end
			local badge = on and "ON" or "OFF"
			if row.badge.Text ~= badge then row.badge.Text = badge end
			local labelColor = on and Theme.TextBright or Theme.Muted
			if row.label.TextColor3 ~= labelColor then row.label.TextColor3 = labelColor end
			local badgeColor = on and Theme.Good or Theme.Muted
			if row.badge.TextColor3 ~= badgeColor then row.badge.TextColor3 = badgeColor end
		end
	end
	indicatorPanel.Visible = library.indicatorsVisible and (#library.Indicators > 0)
end

local function buildIndicatorPanel()
	if indicatorPanel then return indicatorPanel end
	indicatorPanel = New("Frame", {
		Name = "Indicators",
		AnchorPoint = Vector2.new(1, 0),
		Position = library.indicatorPosition,
		Size = UDim2.new(0, 196, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.Backdrop,
		BorderColor3 = Theme.AccentDim,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		ZIndex = 6,
		Parent = overlay,
	})
	Pad(indicatorPanel, 8, 8, 9, 9)
	Vertical(indicatorPanel, 3)

	local header = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 12),
		Text = "ACTIVE",
		Font = FONT,
		TextSize = 11,
		TextColor3 = Theme.Accent,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		LayoutOrder = 0,
		ZIndex = 7,
		Parent = indicatorPanel,
	})

	local dragging, dragStart, startPos = false, nil, nil
	utility:Connection({ Type = header.MouseButton1Down, Callback = function()
		dragging = true
		dragStart = Mouse()
		startPos = indicatorPanel.Position
	end })
	utility:Connection({ Type = UserInput.InputEnded, Callback = function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end })
	utility:Connection({ Type = UserInput.InputChanged, Callback = function(input)
		if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		local now = Mouse()
		local delta = now - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		indicatorPanel.Position = position
		library.indicatorPosition = position
	end })

	if not indicatorConn then
		indicatorConn = utility:Connection({ Type = RunService.RenderStepped, Callback = refreshIndicators })
	end
	return indicatorPanel
end

local function indicatorRow(entry)
	buildIndicatorPanel()
	local row = New("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 13),
		LayoutOrder = entry.order + 1,
		ZIndex = 7,
	}, indicatorPanel)
	local label = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -30, 1, 0),
		Font = FONT,
		TextSize = 11,
		Text = "",
		TextColor3 = Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 8,
	}, row)
	local badge = New("TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 26, 1, 0),
		Font = FONT,
		TextSize = 11,
		Text = "OFF",
		TextColor3 = Theme.Muted,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 8,
	}, row)
	return { row = row, label = label, badge = badge }
end

function library:AddIndicator(indicatorInfo)
	local info = indicatorInfo or {}
	local entry = {
		label = tostring(info.Label or info.label or "feature"),
		order = tonumber(info.Order or info.order) or (#library.Indicators + 1),
		getKey = info.Key or info.key,
		getState = info.State or info.state,
	}
	entry.row = indicatorRow(entry)
	library.Indicators[#library.Indicators + 1] = entry

	local handle = {}
	function handle:Set(newLabel, newKey, newState)
		if newLabel ~= nil then entry.label = tostring(newLabel) end
		if newKey ~= nil then entry.getKey = newKey end
		if newState ~= nil then entry.getState = newState end
		refreshIndicators()
		return handle
	end
	function handle:Remove()
		local index = table.find(library.Indicators, entry)
		if index then table.remove(library.Indicators, index) end
		if entry.row then entry.row.row:Destroy() end
		refreshIndicators()
	end
	refreshIndicators()
	return handle
end

function library:RemoveIndicator(handle)
	if handle and handle.Remove then handle:Remove() end
end

function library:SetIndicatorsVisible(state)
	library.indicatorsVisible = state and true or false
	refreshIndicators()
end

function library:SetIndicatorPosition(position)
	library.indicatorPosition = position
	if indicatorPanel then indicatorPanel.Position = position end
end

function library:Window(windowInfo)
	if not obelus.initialized then
		library:init()
	end
	local info = windowInfo or {}
	local window = {
		Pages    = {},
		Dragging = false,
		Delta    = UDim2.new(),
		Delta2   = Vector3.new(),
		Title    = tostring(info.Name or info.name or info.Title or info.title or "elixer"),
	}

	local screen = New("ScreenGui", {
		Name = "elixer",
		DisplayOrder = 8888,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		Enabled = library.open,
		Parent = host,
	})
	window.Screen = screen
	obelus.windows[#obelus.windows + 1] = window

	local main = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.Shell,
		BorderColor3 = Theme.ShellLine,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		Position = info.Position or UDim2.new(0.5, 0, 0.5, 0),
		Size = info.Size or UDim2.new(0, 516, 0, 563),
		Parent = screen,
	})
	local frame = New("Frame", {
		BackgroundColor3 = Theme.Backdrop,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = main,
	})

	local draggingButton = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 24),
		Text = "",
		AutoButtonColor = false,
		Parent = frame,
	})
	local title = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 9, 0, 6),
		Size = UDim2.new(1, -16, 0, 15),
		Font = FONT,
		RichText = true,
		Text = window.Title,
		TextColor3 = Theme.TextDim,
		TextStrokeTransparency = 0.5,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame,
	})

	local accent = New("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 22),
		Size = UDim2.new(1, -16, 0, 2),
		Parent = frame,
	})
	New("Frame", { BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 1), Parent = accent })
	New("Frame", { BackgroundColor3 = Theme.AccentDim, BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 1), Size = UDim2.new(1, 0, 0, 1), Parent = accent })

	local tabs = New("Frame", {
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 29),
		Size = UDim2.new(1, -16, 0, 30),
		Parent = frame,
	})
	local tabsInline = New("Frame", {
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, -1, 1, 0),
		Parent = tabs,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0),
	}, tabsInline)

	local pagesHolder = New("Frame", {
		BackgroundColor3 = Theme.Shell,
		BorderColor3 = Theme.ShellLine,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		Position = UDim2.new(0, 8, 0, 65),
		Size = UDim2.new(1, -16, 1, -76),
		Parent = frame,
	})
	local pagesFrame = New("Frame", {
		BackgroundColor3 = Theme.Page,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = pagesHolder,
	})
	local pagesFolder = New("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = pagesFrame,
	})

	function window:SetTitle(text)
		window.Title = tostring(text)
		title.Text = window.Title
	end

	function window:RefreshTabs()
		local count = math.max(1, #window.Pages)
		for _, page in ipairs(window.Pages) do
			page.Tab.Size = UDim2.new(1 / count, 0, 1, 0)
		end
	end

	function window:SelectPage(target)
		window.ActivePage = target
		for _, page in ipairs(window.Pages) do
			page:Turn(page == target)
		end
	end

	function window:Destroy()
		screen:Destroy()
		local index = table.find(obelus.windows, window)
		if index then table.remove(obelus.windows, index) end
	end

	utility:Connection({ Type = draggingButton.InputBegan, Callback = function(input)
		if window.Dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			window.Dragging = true
			window.Delta = main.Position
			window.Delta2 = input.Position
		end
	end })

	utility:Connection({ Type = UserInput.InputEnded, Callback = function(input)
		if window.Dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
			window.Dragging = false
			window.Delta = UDim2.new()
			window.Delta2 = Vector3.new()
		end
	end })

	utility:Connection({ Type = UserInput.InputChanged, Callback = function(input)
		if not window.Dragging then return end
		local delta = input.Position - window.Delta2
		main.Position = UDim2.new(
			window.Delta.X.Scale, window.Delta.X.Offset + delta.X,
			window.Delta.Y.Scale, window.Delta.Y.Offset + delta.Y
		)
	end })

	utility:Connection({ Type = UserInput.InputBegan, Callback = function(input, gameProcessed)
		if gameProcessed or not library.builtInToggle then return end
		if library.toggleKey and input.KeyCode == library.toggleKey then
			library:SetOpen(not library.open)
		end
	end })

	function window:Page(pageInfo)
		local page = {
			Open     = false,
			Sections = {},
			Defaults = {},
		}
		setmetatable(page, Page)

		local pageInfoResolved = pageInfo or {}
		local pageName = tostring(pageInfoResolved.Name or pageInfoResolved.name or pageInfoResolved.Text or pageInfoResolved.text or "tab")
		local pageOrder = pageInfoResolved.Order or pageInfoResolved.order or (#window.Pages + 1)

		local tab = New("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = pageOrder,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = tabsInline,
		})
		local tabButton = New("TextButton", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			AutoButtonColor = false,
			ZIndex = 3,
			Parent = tab,
		})
		local tabInline = New("Frame", {
			BackgroundColor3 = Theme.Tab,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -1, 1, -2),
			Parent = tab,
		})
		local tabInlineGradient = New("Frame", {
			BackgroundColor3 = Theme.Tab,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			Parent = tabInline,
		})
		local tabGradient = Gradient(tabInlineGradient, Color3.fromRGB(255, 255, 255), Color3.fromRGB(100, 100, 100), 90)
		local tabTitle = New("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 4, 0.5, 0),
			Size = UDim2.new(1, -8, 0, 15),
			Font = FONT,
			RichText = true,
			Text = pageName,
			TextColor3 = Theme.TextDim,
			TextStrokeTransparency = 0.5,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 4,
			Parent = tabInlineGradient,
		})

		local pageHolder = New("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 10, 0, 10),
			Size = UDim2.new(1, -20, 1, -20),
			Visible = false,
			Parent = pagesFolder,
		})
		local function column(anchor, position)
			local holder = New("ScrollingFrame", {
				AnchorPoint = anchor,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = position,
				Size = UDim2.new(0.5, -5, 1, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = Theme.Line,
				ElasticBehavior = Enum.ElasticBehavior.Never,
				Parent = pageHolder,
			})
			Vertical(holder, 5)
			return holder
		end
		local leftHolder = column(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0))
		local rightHolder = column(Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))

		function page:Turn(state)
			state = state and true or false
			tabTitle.TextColor3 = state and Theme.Accent or Theme.TextDim
			tabGradient.Color = ColorSequence.new(
				Color3.fromRGB(255, 255, 255),
				state and Color3.fromRGB(155, 155, 155) or Color3.fromRGB(100, 100, 100)
			)
			pageHolder.Visible = state
			page.Open = state
		end

		function page:Select()
			window:SelectPage(page)
		end

		function page:SetText(text)
			tabTitle.Text = tostring(text)
		end

		function page:Section(sectionInfo)
			local info = sectionInfo or {}
			local side = info.Side or info.side or 1
			if type(side) == "string" then
				side = (side:lower() == "right") and 2 or 1
			end
			side = (side == 2) and 2 or 1

			local name = tostring(info.Name or info.name or info.Text or info.text or "")
			local minSize = tonumber(info.Size or info.size) or 0
			local column = (side == 2) and rightHolder or leftHolder
			local titleHeight = (name ~= "") and 20 or 6

			local section = {
				Name    = name,
				Side    = side,
				Enabled = true,
				Rows    = {},
				MinSize = minSize,
				Order   = info.Order or info.order or (#page.Sections + 1),
			}
			page.Sections[#page.Sections + 1] = section
			setmetatable(section, Section)

			local background = New("Frame", {
				BackgroundColor3 = Theme.Section,
				BorderColor3 = Theme.Page,
				BorderMode = Enum.BorderMode.Inset,
				BorderSizePixel = 1,
				Size = UDim2.new(1, 0, 0, minSize + titleHeight + 6),
				LayoutOrder = section.Order,
				Parent = column,
			})
			local inner = New("Frame", {
				BackgroundColor3 = Theme.Panel,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				Parent = background,
			})

			local sectionTitle
			if name ~= "" then
				sectionTitle = New("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 11, 0, 0),
					Size = UDim2.new(1, -22, 0, 18),
					Font = FONT,
					RichText = true,
					Text = name,
					TextColor3 = Theme.TextBright,
					TextStrokeTransparency = 0.5,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 3,
					Parent = inner,
				})
				New("Frame", {
					BackgroundColor3 = Theme.Line,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 5, 0, 18),
					Size = UDim2.new(1, -10, 0, 1),
					Parent = inner,
				})
			end

			local content = New("ScrollingFrame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 5, 0, titleHeight),
				Size = UDim2.new(1, -10, 1, -(titleHeight + 6)),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = Theme.Line,
				ElasticBehavior = Enum.ElasticBehavior.Never,
				ZIndex = 2,
				Parent = inner,
			})
			Vertical(content, 6)
			Pad(content, 2, 4, 0, 6)

			section.Background = background
			section.Content = content
			section.RowOrder = 0

			function section:NextOrder()
				section.RowOrder = section.RowOrder + 1
				return section.RowOrder
			end

			function section:Update()
				local canvas = content.AbsoluteCanvasSize.Y
				local wanted = math.max(minSize + titleHeight + 6, math.floor(canvas + 0.5) + titleHeight + 6)
				background.Size = UDim2.new(1, 0, 0, wanted)
			end

			function section:SetText(text)
				section.Name = tostring(text)
				if sectionTitle then sectionTitle.Text = section.Name end
			end

			function section:SetEnabled(state)
				section.Enabled = state and true or false
				background.Visible = section.Enabled
			end

			function section:AttachTooltip(row, text)
				if not text or text == "" then return end
				utility:Connection({ Type = row.MouseEnter, Callback = function() ShowTooltip(text) end })
				utility:Connection({ Type = row.MouseLeave, Callback = HideTooltip })
			end

			function section:Row(height)
				local row = New("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, height),
					LayoutOrder = section:NextOrder(),
					Parent = content,
				})
				section.Rows[#section.Rows + 1] = row
				return row
			end

			utility:Connection({ Type = content:GetPropertyChangedSignal("AbsoluteCanvasSize"), Callback = function()
				section:Update()
			end })

			section:Update()
			return section
		end

		function page:DefaultSection(side)
			side = (side == 2) and 2 or 1
			local existing = page.Defaults[side]
			if existing then return existing end
			local created = page:Section({ Name = "", Side = side, Size = 0 })
			page.Defaults[side] = created
			return created
		end

		function page:AddSection(text, side, order)
			return page:Section({ Name = text, Side = side, Order = order })
		end

		utility:Connection({ Type = tabButton.MouseButton1Down, Callback = function()
			window:SelectPage(page)
		end })

		page.Tab = tab
		page.PageHolder = pageHolder
		page.Left = leftHolder
		page.Right = rightHolder

		window.Pages[#window.Pages + 1] = page
		window:RefreshTabs()
		if not window.ActivePage then
			window:SelectPage(page)
		end

		return page
	end

	function window:AddTab(text, order)
		return window:Page({ Name = text, Order = order })
	end

	return window
end

local function RegisterFlag(element, flag, value)
	if type(flag) ~= "string" then return nil end
	element.Flag = flag
	library.Flags[flag] = value
	library.Options[flag] = element
	return flag
end

function Section:Label(labelInfo)
	local section = self
	local info = labelInfo or {}
	local offset = tonumber(info.Offset or info.offset) or 36
	local row = section:Row(14)
	local labelText = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, offset, 0, 0),
		Size = UDim2.new(1, -(offset + 4), 1, 0),
		Font = FONT,
		TextSize = TEXT_SIZE,
		RichText = true,
		Text = tostring(info.Name or info.name or info.Text or info.text or "label"),
		TextColor3 = (info.Risky or info.risky) and Theme.Risk or Theme.Text,
		TextStrokeTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local element = { Row = row, Kind = "Label" }
	function element:Get() return labelText.Text end
	function element:Set(value) labelText.Text = tostring(value) end
	function element:Remove()
		row:Destroy()
		section:Update()
	end
	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	section:Update()
	return element
end

function Section:Text(textInfo)
	local info = textInfo or {}
	local height = tonumber(info.Height or info.height) or 30
	local element = self:Label(info)
	element.Row.Size = UDim2.new(1, 0, 0, height)
	element.Row:FindFirstChildOfClass("TextLabel").TextWrapped = true
	element.Row:FindFirstChildOfClass("TextLabel").Size = UDim2.new(1, -40, 1, 0)
	self:Update()
	return element
end

function Section:Separator(separatorInfo)
	local section = self
	local info = separatorInfo or {}
	local name = info.Name or info.name or info.Text or info.text
	local row = section:Row(name and 16 or 6)
	if name then
		New("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 16, 0, 1),
			Size = UDim2.new(1, -32, 0, 14),
			Font = FONT,
			TextSize = 12,
			Text = tostring(name),
			TextColor3 = Theme.Muted,
			TextStrokeTransparency = 0.6,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = row,
		})
	end
	New("Frame", {
		BackgroundColor3 = Theme.Line,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 4, 0.5, 0),
		Size = UDim2.new(1, -8, 0, 1),
		Parent = row,
	})
	local element = { Row = row, Kind = "Separator" }
	function element:Remove()
		row:Destroy()
		section:Update()
	end
	section:Update()
	return element
end

function Section:Toggle(toggleInfo)
	local section = self
	local info = toggleInfo or {}
	local flag = info.Flag or info.flag
	local callback = info.Callback or info.callback
	local risky = info.Risky or info.risky
	local state = (info.Default or info.default or info.Def or info.def or info.State or info.state or false) and true or false
	local row = section:Row(14)

	local button = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = row,
	})
	local box = New("Frame", {
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 2),
		Size = UDim2.new(0, 10, 0, 10),
		Parent = row,
	})
	local fill = New("Frame", {
		BackgroundColor3 = state and Theme.Accent or Theme.Off,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = box,
	})
	Gradient(fill, Color3.fromRGB(255, 255, 255), Color3.fromRGB(125, 125, 125), 90)
	local title = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 36, 0, 0),
		Size = UDim2.new(1, -42, 1, 0),
		Font = FONT,
		RichText = true,
		Text = tostring(info.Name or info.name or info.Text or info.text or "toggle"),
		TextColor3 = risky and Theme.Risk or Theme.Text,
		TextStrokeTransparency = 0.5,
		TextSize = TEXT_SIZE,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local element = { Row = row, Kind = "Toggle" }

	local function render(animate)
		local target = state and Theme.Accent or Theme.Off
		if animate then
			Tween(fill, 0.12, { BackgroundColor3 = target })
		else
			fill.BackgroundColor3 = target
		end
	end

	function element:Get() return state end
	function element:Set(value, silent)
		state = value and true or false
		render(true)
		if flag then library.Flags[flag] = state end
		if not silent and callback then pcall(callback, state) end
	end
	function element:Remove()
		row:Destroy()
		section:Update()
	end

	utility:Connection({ Type = button.MouseButton1Down, Callback = function()
		element:Set(not state)
	end })
	utility:Connection({ Type = row.MouseEnter, Callback = function()
		if not risky then Tween(title, 0.12, { TextColor3 = Theme.TextBright }) end
	end })
	utility:Connection({ Type = row.MouseLeave, Callback = function()
		if not risky then Tween(title, 0.12, { TextColor3 = Theme.Text }) end
	end })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	RegisterFlag(element, flag, state)
	render(false)
	section:Update()
	return element
end

function Section:Button(buttonInfo)
	local section = self
	local info = buttonInfo or {}
	local callback = info.Callback or info.callback
	local confirm = info.Confirm or info.confirm
	local name = tostring(info.Name or info.name or info.Text or info.text or "button")
	local risky = info.Risky or info.risky
	local row = section:Row(20)

	local hit = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = row,
	})
	local border = New("Frame", {
		BackgroundColor3 = Theme.Section,
		BorderColor3 = Theme.Rail,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -32, 1, 0),
		Parent = row,
	})
	local inline = New("Frame", {
		BackgroundColor3 = Theme.Control,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = border,
	})
	local title = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -32, 1, 0),
		Font = FONT,
		RichText = true,
		Text = name,
		TextColor3 = risky and Theme.Risk or Theme.Text,
		TextStrokeTransparency = 0.5,
		TextSize = TEXT_SIZE,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 4,
		Parent = row,
	})

	local element = { Row = row, Kind = "Button" }
	local armed = false

	local function reset()
		armed = false
		title.Text = name
	end

	local function fire()
		if confirm and not armed then
			armed = true
			title.Text = "Confirm"
			task.delay(3, function()
				if armed then reset() end
			end)
			return
		end
		reset()
		if callback then pcall(callback) end
	end

	function element:Get() return name end
	function element:SetText(text)
		name = tostring(text)
		if not armed then title.Text = name end
	end
	function element:AddButton(subInfo)
		section:Button(subInfo)
		return element
	end
	function element:Remove()
		row:Destroy()
		section:Update()
	end

	utility:Connection({ Type = hit.MouseButton1Down, Callback = fire })
	utility:Connection({ Type = row.MouseEnter, Callback = function()
		Tween(inline, 0.12, { BackgroundColor3 = Theme.Tab })
	end })
	utility:Connection({ Type = row.MouseLeave, Callback = function()
		Tween(inline, 0.12, { BackgroundColor3 = Theme.Control })
	end })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	section:Update()
	return element
end

function Section:Slider(sliderInfo)
	local section = self
	local info = sliderInfo or {}
	local flag = info.Flag or info.flag
	local callback = info.Callback or info.callback
	local risky = info.Risky or info.risky
	local name = info.Name or info.name or info.Text or info.text

	local min = tonumber(info.Minimum or info.minimum or info.Min or info.min) or 0
	local max = tonumber(info.Maximum or info.maximum or info.Max or info.max) or 100
	if max <= min then max = min + 1 end
	local step = tonumber(info.Increment or info.increment or info.Step or info.step)
	if not step or step <= 0 then
		local decimals = tonumber(info.Decimals or info.decimals or info.Tick or info.tick)
		step = (decimals and decimals > 0) and decimals or ((max - min) <= 20 and 0.1 or 1)
	end
	local suffix = tostring(info.Suffix or info.suffix or info.Ending or info.ending or "")
	local value = math.clamp(Round(tonumber(info.Default or info.default or info.Value or info.value or info.Def or info.def) or min, step), min, max)

	local hasTitle = name ~= nil and tostring(name) ~= ""
	local row = section:Row(hasTitle and 26 or 10)
	local barY = hasTitle and 15 or 0

	if hasTitle then
		New("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 16, 0, 0),
			Size = UDim2.new(1, -16, 0, 14),
			Font = FONT,
			RichText = true,
			Text = tostring(name),
			TextColor3 = risky and Theme.Risk or Theme.Text,
			TextStrokeTransparency = 0.5,
			TextSize = TEXT_SIZE,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = row,
		})
	end

	local bar = New("Frame", {
		BackgroundColor3 = Theme.Rail,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, barY),
		Size = UDim2.new(1, -32, 0, 10),
		Parent = row,
	})
	local barInner = New("Frame", {
		BackgroundColor3 = Theme.Off,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = bar,
	})
	Gradient(barInner, Color3.fromRGB(255, 255, 255), Color3.fromRGB(125, 125, 125), 90)
	local track = New("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = bar,
	})
	local fill = New("Frame", {
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = track,
	})
	Gradient(fill, Color3.fromRGB(255, 255, 255), Color3.fromRGB(125, 125, 125), 90)
	local valueLabel = New("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 5, 0.5, 0),
		Size = UDim2.new(0, 140, 0, 12),
		Font = FONT,
		Text = "",
		TextColor3 = Theme.TextDim,
		TextStrokeTransparency = 0.5,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
		Parent = fill,
	})
	local hit = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, barY - 2),
		Size = UDim2.new(1, -32, 0, 14),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 4,
		Parent = row,
	})

	local element = { Row = row, Kind = "Slider", Min = min, Max = max, Step = step }
	local holding = false

	local function render()
		local pct = math.clamp((value - min) / (max - min), 0, 1)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		valueLabel.Text = Format(value) .. suffix
	end

	function element:Get() return value end
	function element:Set(newValue, silent)
		value = math.clamp(Round(tonumber(newValue) or min, step), min, max)
		render()
		if flag then library.Flags[flag] = value end
		if not silent and callback then pcall(callback, value) end
	end
	function element:Remove()
		row:Destroy()
		section:Update()
	end

	local function fromX(x)
		local rel = (x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X)
		element:Set(min + (max - min) * math.clamp(rel, 0, 1))
	end

	utility:Connection({ Type = hit.MouseButton1Down, Callback = function()
		holding = true
		fromX(Mouse().X)
	end })
	utility:Connection({ Type = UserInput.InputChanged, Callback = function(input)
		if holding and input.UserInputType == Enum.UserInputType.MouseMovement then
			fromX(input.Position.X)
		end
	end })
	utility:Connection({ Type = UserInput.InputEnded, Callback = function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then holding = false end
	end })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	RegisterFlag(element, flag, value)
	render()
	section:Update()
	return element
end

function Section:List(listInfo)
	local section = self
	local info = listInfo or {}
	local flag = info.Flag or info.flag
	local callback = info.Callback or info.callback
	local risky = info.Risky or info.risky
	local multi = info.Multi or info.multi
	local values = {}
	for index, value in ipairs(info.Values or info.values or info.Options or info.options or {}) do
		values[index] = tostring(value)
	end

	local selected = info.Selected or info.selected or info.Default or info.default
	if multi then
		local dict = {}
		if type(selected) == "table" then
			for key, value in pairs(selected) do
				dict[tostring(key)] = value and true or false
			end
		end
		selected = dict
	else
		selected = (selected ~= nil) and tostring(selected) or (values[1] or "")
	end

	local row = section:Row(16)
	local header = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 16),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = row,
	})
	New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(0.5, -16, 1, 0),
		Font = FONT,
		RichText = true,
		Text = tostring(info.Name or info.name or info.Text or info.text or "list"),
		TextColor3 = risky and Theme.Risk or Theme.Text,
		TextStrokeTransparency = 0.5,
		TextSize = TEXT_SIZE,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local valueLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 0),
		Size = UDim2.new(0.5, -14, 1, 0),
		Font = FONT,
		Text = "",
		TextColor3 = Theme.TextDim,
		TextStrokeTransparency = 0.5,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})

	local panel = New("Frame", {
		BackgroundColor3 = Theme.Backdrop,
		BorderColor3 = Theme.Rail,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		Position = UDim2.new(0, 16, 0, 19),
		Size = UDim2.new(1, -32, 0, 2),
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 5,
		Parent = row,
	})
	local panelInner = New("Frame", {
		BackgroundColor3 = Theme.Page,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		ZIndex = 6,
		Parent = panel,
	})
	Vertical(panelInner, 0)

	local element = { Row = row, Kind = "List" }
	local optionConnections = {}

	local function renderValue()
		if multi then
			local picked = {}
			for _, value in ipairs(values) do
				if selected[value] then picked[#picked + 1] = value end
			end
			valueLabel.Text = (#picked > 0) and table.concat(picked, ", ") or "None"
		else
			valueLabel.Text = (selected ~= "" and selected) or "None"
		end
	end

	local function setOpen(state)
		panel.Visible = state
		row.Size = UDim2.new(1, 0, 0, state and (#values * 16 + 27) or 16)
		section:Update()
	end

	local refresh
	refresh = function()
		for _, connection in ipairs(optionConnections) do
			utility:RemoveConnection({ Connection = connection })
		end
		table.clear(optionConnections)
		for _, child in ipairs(panelInner:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		for index, value in ipairs(values) do
			local option = New("TextButton", {
				BackgroundColor3 = Theme.Page,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 16),
				LayoutOrder = index,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 6,
				Parent = panelInner,
			})
			local optionText = New("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 7, 0, 0),
				Size = UDim2.new(1, -14, 1, 0),
				Font = FONT,
				Text = value,
				TextColor3 = Theme.Text,
				TextStrokeTransparency = 0.5,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 7,
				Parent = option,
			})

			local isPicked = multi and selected[value] or (not multi and selected == value)
			optionText.TextColor3 = isPicked and Theme.Accent or Theme.Text

			optionConnections[#optionConnections + 1] = utility:Connection({ Type = option.MouseEnter, Callback = function()
				option.BackgroundColor3 = Theme.Shell
			end })
			optionConnections[#optionConnections + 1] = utility:Connection({ Type = option.MouseLeave, Callback = function()
				option.BackgroundColor3 = Theme.Page
			end })
			optionConnections[#optionConnections + 1] = utility:Connection({ Type = option.MouseButton1Down, Callback = function()
				if multi then
					selected[value] = not selected[value] or nil
					renderValue()
					if flag then library.Flags[flag] = table.clone(selected) end
					if callback then pcall(callback, table.clone(selected)) end
					refresh()
				else
					selected = value
					renderValue()
					if flag then library.Flags[flag] = selected end
					if callback then pcall(callback, selected) end
					setOpen(false)
					refresh()
				end
			end })
		end

		panel.Size = UDim2.new(1, -32, 0, #values * 16 + 2)
	end

	function element:Get()
		if multi then return table.clone(selected) end
		return selected
	end
	function element:Set(value, silent)
		if multi then
			local dict = {}
			if type(value) == "table" then
				for key, flag_value in pairs(value) do dict[tostring(key)] = flag_value and true or false end
			end
			selected = dict
		else
			selected = tostring(value)
		end
		renderValue()
		if flag then library.Flags[flag] = multi and table.clone(selected) or selected end
		if not silent and callback then pcall(callback, multi and table.clone(selected) or selected) end
		refresh()
	end
	function element:AddValue(value)
		values[#values + 1] = tostring(value)
		renderValue()
		refresh()
		setOpen(panel.Visible)
		return element
	end
	function element:ClearValues()
		table.clear(values)
		if multi then
			table.clear(selected)
		else
			selected = ""
		end
		renderValue()
		refresh()
		setOpen(panel.Visible)
		return element
	end
	function element:Refresh()
		renderValue()
		refresh()
		return element
	end
	function element:Remove()
		row:Destroy()
		section:Update()
	end

	utility:Connection({ Type = header.MouseButton1Down, Callback = function()
		setOpen(not panel.Visible)
	end })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	RegisterFlag(element, flag, multi and table.clone(selected) or selected)
	refresh()
	renderValue()
	section:Update()
	return element
end

function Section:Bind(bindInfo)
	local section = self
	local info = bindInfo or {}
	local flag = info.Flag or info.flag
	local callback = info.Callback or info.callback
	local keycallback = info.KeyCallback or info.keycallback
	local mode = info.Mode or info.mode or "toggle"
	local nomouse = info.Nomouse or info.nomouse
	local onbind = info.OnBind or info.onbind
	local risky = info.Risky or info.risky

	local bind = info.Bind or info.bind
	if type(bind) == "string" then
		if bind == "none" then
			bind = nil
		else
			local ok, key = pcall(function() return Enum.KeyCode[bind] end)
			bind = ok and key or nil
		end
	end

	local row = section:Row(16)
	New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(0.5, -16, 1, 0),
		Font = FONT,
		RichText = true,
		Text = tostring(info.Name or info.name or info.Text or info.text or "bind"),
		TextColor3 = risky and Theme.Risk or Theme.Text,
		TextStrokeTransparency = 0.5,
		TextSize = TEXT_SIZE,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local keyLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 0),
		Size = UDim2.new(0.5, -14, 1, 0),
		Font = FONT,
		Text = "",
		TextColor3 = Theme.TextDim,
		TextStrokeTransparency = 0.5,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})
	local hit = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = row,
	})

	local element = { Row = row, Kind = "Bind" }
	local listening = false
	local pendingListen = false
	local held = false
	local armed = false

	local function render()
		if listening then
			keyLabel.Text = "Press key..."
			keyLabel.TextColor3 = Theme.Accent
		elseif pendingListen then
			keyLabel.Text = "..."
			keyLabel.TextColor3 = Theme.Accent
		else
			keyLabel.Text = bind and bind.Name or "None"
			keyLabel.TextColor3 = bind and Theme.TextDim or Theme.Muted
		end
	end

	-- Compare the concrete input fields instead of EnumType identity: a keyboard
	-- input carries KeyCode, everything else (mouse buttons, wheel, touch) carries
	-- UserInputType, and the two enum items are never equal to each other.
	local function matches(input)
		if not bind or typeof(bind) ~= "EnumItem" then return false end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			return input.KeyCode == bind
		end
		return input.UserInputType == bind
	end

	function element:Get() return bind end
	function element:Set(value, silent)
		if type(value) == "string" then
			if value == "none" then
				bind = nil
			else
				local ok, key = pcall(function() return Enum.KeyCode[value] end)
				bind = ok and key or nil
			end
		elseif value == nil then
			bind = nil
		elseif typeof(value) == "EnumItem" then
			bind = value
		end
		element:Assign(bind, silent)
		render()
	end
	function element:Assign(newBind, silent)
		bind = newBind
		armed = false
		if mode == "hold" and held then
			held = false
			if not silent and callback then pcall(callback, false) end
		end
		if flag then library.Flags[flag] = bind end
		if onbind then pcall(onbind, bind) end
	end
	function element:Remove()
		if element.Indicator then
			element.Indicator:Remove()
			element.Indicator = nil
		end
		row:Destroy()
		section:Update()
	end

	utility:Connection({ Type = hit.MouseButton1Down, Callback = function()
		-- Clicking again while the picker is open cancels it.
		if listening or pendingListen then
			listening = false
			pendingListen = false
			render()
			return
		end
		-- The press that opens the picker also reaches UserInputService, so the
		-- picker arms on that press's release instead of consuming itself.
		pendingListen = true
		listening = false
		render()
	end })

	utility:Connection({ Type = UserInput.InputBegan, Callback = function(input, gameProcessed)
		if listening then
			pendingListen = false
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode ~= Enum.KeyCode.Escape then
					element:Assign(input.KeyCode)
				end
			elseif not nomouse and (function()
				local name = input.UserInputType and input.UserInputType.Name or ""
				return string.find(name, "MouseButton", 1, true) ~= nil or name == "MouseWheel"
			end)() then
				element:Assign(input.UserInputType)
			else
				return
			end
			listening = false
			render()
			return
		end

		if gameProcessed then return end
		if not matches(input) then return end
		if keycallback then pcall(keycallback) end
		if mode == "hold" then
			if not held then
				held = true
				if callback then pcall(callback, true) end
			end
		else
			armed = not armed
			if callback then pcall(callback, armed) end
		end
	end })

	utility:Connection({ Type = UserInput.InputEnded, Callback = function(input)
		if pendingListen and (input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch) then
			pendingListen = false
			listening = true
			render()
			return
		end
		if mode ~= "hold" or not held then return end
		if matches(input) then
			held = false
			if callback then pcall(callback, false) end
		end
	end })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	RegisterFlag(element, flag, bind)

	if not (info.NoIndicator or info.noindicator) and info.Indicator ~= false then
		element.Indicator = library:AddIndicator({
			Label = info.Indicator or info.indicator or tostring(info.Name or info.name or info.Text or info.text or "bind"),
			Key = function() return bind end,
			State = info.State or info.state or function() return held or armed end,
		})
	end

	render()
	section:Update()
	return element
end

function Section:Box(boxInfo)
	local section = self
	local info = boxInfo or {}
	local flag = info.Flag or info.flag
	local callback = info.Callback or info.callback
	local value = tostring(info.Input or info.input or info.Default or info.default or info.Text or info.text or "")
	local row = section:Row(20)

	New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(0.5, -16, 1, 0),
		Font = FONT,
		RichText = true,
		Text = tostring(info.Name or info.name or info.Label or info.label or "input"),
		TextColor3 = Theme.Text,
		TextStrokeTransparency = 0.5,
		TextSize = TEXT_SIZE,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local container = New("Frame", {
		BackgroundColor3 = Theme.Rail,
		BorderColor3 = Theme.Rail,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.5, -2, 0.5, 0),
		Size = UDim2.new(0.5, -8, 1, -2),
		Parent = row,
	})
	local box = New("TextBox", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Font = FONT,
		Text = value,
		PlaceholderText = tostring(info.Placeholder or info.placeholder or ""),
		PlaceholderColor3 = Theme.Muted,
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 3,
		Parent = container,
	})
	Pad(box, 0, 0, 4, 4)

	local element = { Row = row, Kind = "Box" }
	function element:Get() return box.Text end
	function element:Set(text, silent)
		value = tostring(text or "")
		box.Text = value
		if flag then library.Flags[flag] = value end
		if not silent and callback then pcall(callback, value) end
	end
	function element:Remove()
		row:Destroy()
		section:Update()
	end

	local function commit()
		value = box.Text
		if flag then library.Flags[flag] = value end
		if callback then pcall(callback, value) end
	end

	utility:Connection({ Type = box.FocusLost, Callback = function() commit() end })
	utility:Connection({ Type = box.ReturnPressedFromOnScreenKeyboard, Callback = commit })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	RegisterFlag(element, flag, value)
	section:Update()
	return element
end

function Section:Color(colorInfo)
	local section = self
	local info = colorInfo or {}
	local flag = info.Flag or info.flag
	local callback = info.Callback or info.callback
	local risky = info.Risky or info.risky
	local color = info.Color or info.color or info.Default or info.default
	if typeof(color) ~= "Color3" then color = Color3.new(1, 1, 1) end

	local row = section:Row(16)
	New("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(0.5, -16, 1, 0),
		Font = FONT,
		RichText = true,
		Text = tostring(info.Name or info.name or info.Text or info.text or "color"),
		TextColor3 = risky and Theme.Risk or Theme.Text,
		TextStrokeTransparency = 0.5,
		TextSize = TEXT_SIZE,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local swatchButton = New("TextButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 40, 0, 12),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 4,
		Parent = row,
	})
	local swatch = New("Frame", {
		BackgroundColor3 = color,
		BorderColor3 = Theme.Rail,
		BorderMode = Enum.BorderMode.Inset,
		BorderSizePixel = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = swatchButton,
	})

	local panel = New("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 18),
		Size = UDim2.new(1, -32, 0, 0),
		Visible = false,
		ClipsDescendants = true,
		Parent = row,
	})
	Vertical(panel, 2)

	local element = { Row = row, Kind = "Color" }
	local channels = {}

	local function apply(silent)
		color = Color3.new(channels.R(), channels.G(), channels.B())
		swatch.BackgroundColor3 = color
		if flag then library.Flags[flag] = color end
		if not silent and callback then pcall(callback, color) end
	end

	local function channel(parent, label, initial, setter)
		local line = New("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 16),
			Parent = parent,
		})
		New("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 12, 1, 0),
			Font = FONT,
			Text = label,
			TextColor3 = Theme.Muted,
			TextStrokeTransparency = 0.6,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = line,
		})
		local bar = New("Frame", {
			BackgroundColor3 = Theme.Rail,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 14, 0, 3),
			Size = UDim2.new(1, -22, 0, 10),
			Parent = line,
		})
		local barInner = New("Frame", {
			BackgroundColor3 = Theme.Off,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			Parent = bar,
		})
		Gradient(barInner, Color3.fromRGB(255, 255, 255), Color3.fromRGB(125, 125, 125), 90)
		local fill = New("Frame", {
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			Size = UDim2.new(initial, 0, 1, 0),
			Parent = barInner,
		})
		local hit = New("TextButton", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 14, 0, 0),
			Size = UDim2.new(1, -22, 1, 0),
			Text = "",
			AutoButtonColor = false,
			ZIndex = 3,
			Parent = line,
		})

		local value = initial
		local holding = false
		local function commit(silent)
			fill.Size = UDim2.new(value, 0, 1, 0)
			if not silent then setter(value) end
		end
		local function fromX(x)
			value = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
			commit()
		end

		utility:Connection({ Type = hit.MouseButton1Down, Callback = function()
			holding = true
			fromX(Mouse().X)
		end })
		utility:Connection({ Type = UserInput.InputChanged, Callback = function(input)
			if holding and input.UserInputType == Enum.UserInputType.MouseMovement then fromX(input.Position.X) end
		end })
		utility:Connection({ Type = UserInput.InputEnded, Callback = function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if holding then holding = false end
			end
		end })

		return function(newValue, silent)
			if newValue == nil then return value end
			value = math.clamp(tonumber(newValue) or 0, 0, 1)
			commit(silent)
			return value
		end
	end

	channels.R = channel(panel, "R", color.R, function() apply() end)
	channels.G = channel(panel, "G", color.G, function() apply() end)
	channels.B = channel(panel, "B", color.B, function() apply() end)

	local function setOpen(state)
		panel.Visible = state
		row.Size = UDim2.new(1, 0, 0, state and 70 or 16)
		section:Update()
	end

	function element:Get() return color end
	function element:Set(newColor, silent)
		if typeof(newColor) == "Color3" then
			color = newColor
		elseif type(newColor) == "table" and newColor.R and newColor.G and newColor.B then
			color = Color3.new(newColor.R, newColor.G, newColor.B)
		end
		channels.R(color.R, true)
		channels.G(color.G, true)
		channels.B(color.B, true)
		swatch.BackgroundColor3 = color
		if flag then library.Flags[flag] = color end
		if not silent and callback then pcall(callback, color) end
	end
	function element:Remove()
		row:Destroy()
		section:Update()
	end

	utility:Connection({ Type = swatchButton.MouseButton1Down, Callback = function()
		setOpen(not panel.Visible)
	end })

	section:AttachTooltip(row, info.Tooltip or info.tooltip)
	RegisterFlag(element, flag, color)
	section:Update()
	return element
end

local PAGE_ELEMENTS = {
	Toggle = "Toggle", AddToggle = "Toggle",
	Slider = "Slider", AddSlider = "Slider",
	Button = "Button", AddButton = "Button",
	Label = "Label", AddLabel = "Label",
	Text = "Text", AddText = "Text",
	Separator = "Separator", AddSeparator = "Separator",
	List = "List", AddList = "List", Dropdown = "List", AddDropdown = "List",
	Bind = "Bind", AddBind = "Bind", Keybind = "Bind", AddKeybind = "Bind",
	Color = "Color", AddColor = "Color", ColorPicker = "Color", AddColorPicker = "Color",
	Box = "Box", AddBox = "Box", TextBox = "Box", AddTextBox = "Box",
}

for alias, method in pairs(PAGE_ELEMENTS) do
	Page[alias] = function(self, elementInfo)
		local info = elementInfo or {}
		local section = self:DefaultSection(info.Side or info.side)
		return section[method](section, info)
	end
end

local SECTION_ELEMENTS = {
	AddToggle = "Toggle", AddSlider = "Slider", AddButton = "Button", AddLabel = "Label",
	AddText = "Text", AddSeparator = "Separator", AddList = "List", AddDropdown = "List",
	AddBind = "Bind", AddKeybind = "Bind", AddColor = "Color", AddColorPicker = "Color",
	AddBox = "Box", AddTextBox = "Box", Dropdown = "List",
}

for alias, method in pairs(SECTION_ELEMENTS) do
	Section[alias] = function(self, elementInfo)
		return Section[method](self, elementInfo or {})
	end
end

function library:SetOpen(state)
	library.open = state and true or false
	for _, window in ipairs(obelus.windows) do
		if window.Screen then window.Screen.Enabled = library.open end
	end
end

function library:init(options)
	if type(options) == "table" then
		if options.cheatname then library.cheatname = tostring(options.cheatname) end
		if options.gamename then library.gamename = tostring(options.gamename) end
		if options.fileext then library.fileext = tostring(options.fileext) end
		if options.toggleKey then library.toggleKey = options.toggleKey end
	end
	if not obelus.toggleConnection then
		obelus.toggleConnection = utility:Connection({ Type = UserInput.InputBegan, Callback = function(input, gameProcessed)
			if gameProcessed or not library.builtInToggle then return end
			if library.toggleKey and input.KeyCode == library.toggleKey then
				library:SetOpen(not library.open)
			end
		end })
	end
	obelus.initialized = true
	return library
end

library.Init = library.init

local function hasFileSystem()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function configFolder()
	return library.cheatname .. "/" .. library.gamename .. "/configs"
end

local function configPath(name)
	return configFolder() .. "/" .. tostring(name) .. library.fileext
end

-- EnumItem.EnumType is an EnumType, which has no Name property. Roblox tostring()s
-- it as the bare type name ("KeyCode"), so match the trailing identifier.
local function enumTypeName(item)
	if item.EnumType == nil then return nil end
	local ok, name = pcall(function()
		return string.match(tostring(item.EnumType), "([%a_][%w_]*)$")
	end)
	-- tostring(nil) is "nil", which would otherwise pass as a type name
	if not ok or type(name) ~= "string" or name == "nil" or Enum[name] == nil then return nil end
	return name
end

local function encodeValue(value)
	local kind = typeof(value)
	if kind == "Color3" then
		return { __type = "Color3", R = value.R, G = value.G, B = value.B }
	end
	if kind == "EnumItem" then
		local enumName = enumTypeName(value)
		if enumName then
			return { __type = "Enum", EnumType = enumName, Name = value.Name }
		end
		-- never drop a setting just because the enum type could not be named
		return { __type = "EnumText", Value = tostring(value) }
	end
	return value
end

local function decodeValue(value)
	if type(value) == "table" then
		if value.__type == "Color3" then
			return Color3.new(value.R, value.G, value.B)
		end
		if value.__type == "Enum" then
			local enumType = Enum[value.EnumType]
			if enumType then return enumType[value.Name] end
			return nil
		end
		if value.__type == "EnumText" then
			return value.Value
		end
	end
	return value
end

function library:SaveConfig(name)
	if type(name) ~= "string" or name == "" then
		library:Notify("Enter a config name first", 4, Theme.Risk)
		return false
	end
	if not hasFileSystem() or type(makefolder) ~= "function" then
		library:Notify("This executor has no file system", 4, Theme.Risk)
		return false
	end

	local payload = { version = library.version, flags = {} }
	for flag, element in pairs(library.Options) do
		local ok, value = pcall(function() return element:Get() end)
		if ok then payload.flags[flag] = encodeValue(value) end
	end

	local ok = pcall(function()
		makefolder(library.cheatname)
		makefolder(library.cheatname .. "/" .. library.gamename)
		makefolder(configFolder())
		writefile(configPath(name), HttpService:JSONEncode(payload))
	end)
	if ok then
		library:Notify("Config saved: " .. name, 3, Theme.Good)
		return true
	end
	library:Notify("Failed to save config: " .. name, 4, Theme.Risk)
	return false
end

function library:LoadConfig(name)
	if type(name) ~= "string" or name == "" then
		library:Notify("Select a config first", 4, Theme.Risk)
		return false
	end
	if not hasFileSystem() then
		library:Notify("This executor has no file system", 4, Theme.Risk)
		return false
	end

	local path = configPath(name)
	local exists = false
	pcall(function() exists = isfile(path) end)
	if not exists then
		library:Notify("Config not found: " .. name, 4, Theme.Risk)
		return false
	end

	local ok, payload = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
	if not ok or type(payload) ~= "table" or type(payload.flags) ~= "table" then
		library:Notify("Config is unreadable: " .. name, 4, Theme.Risk)
		return false
	end

	for flag, value in pairs(payload.flags) do
		local element = library.Options[flag]
		if element and element.Set then
			pcall(function() element:Set(decodeValue(value)) end)
		end
	end
	library:Notify("Config loaded: " .. name, 3, Theme.Good)
	return true
end

function library:GetConfig(name)
	if type(name) ~= "string" or not hasFileSystem() then return nil end
	local ok, exists = pcall(isfile, configPath(name))
	if not ok or not exists then return nil end
	local read, content = pcall(readfile, configPath(name))
	return read and content or nil
end

function library:DeleteConfig(name)
	if type(name) ~= "string" or type(delfile) ~= "function" then return false end
	local ok = pcall(delfile, configPath(name))
	return ok
end

function library:ListConfigs()
	local out = {}
	if type(listfiles) ~= "function" then return out end
	local ok, files = pcall(listfiles, configFolder())
	if not ok or type(files) ~= "table" then return out end
	for _, file in ipairs(files) do
		local name = tostring(file):match("([^/\\]+)$")
		if name and #name > #library.fileext and name:sub(-#library.fileext) == library.fileext then
			out[#out + 1] = name:sub(1, #name - #library.fileext)
		end
	end
	table.sort(out)
	return out
end

function library:CreateSettingsTab(menu)
	local tab = menu:AddTab("Settings", 999)
	local configSection = tab:AddSection("Config", 1)
	local mainSection = tab:AddSection("Main", 1)

	-- the Open / Close bind below owns the hotkey from here on, so the built in
	-- handler has to stand down or every press toggles twice
	library.builtInToggle = false

	configSection:AddBox({ text = "Config Name", flag = "configinput", placeholder = "new config" })
	configSection:AddList({ text = "Config", flag = "selectedconfig", values = library:ListConfigs() })

	local function refreshConfigs()
		local list = library.Options.selectedconfig
		if not list then return end
		local current = list:Get()
		list:ClearValues()
		for _, name in ipairs(library:ListConfigs()) do
			list:AddValue(name)
		end
		if current and current ~= "" and library:GetConfig(current) then
			list:Set(current, true)
		end
	end

	configSection:AddButton({ text = "Load", callback = function()
		library:LoadConfig(library.Flags.selectedconfig)
	end }):AddButton({ text = "Save", callback = function()
		if library:SaveConfig(library.Flags.configinput) then
			refreshConfigs()
		end
	end })

	configSection:AddButton({ text = "Create", callback = function()
		local name = library.Flags.configinput
		if type(name) ~= "string" or name == "" then
			library:Notify("Enter a config name first", 4, Theme.Risk)
			return
		end
		if library:GetConfig(name) then
			library:Notify("Config already exists: " .. name, 4, Theme.Risk)
			return
		end
		library:SaveConfig(name)
		refreshConfigs()
	end }):AddButton({ text = "Delete", confirm = true, callback = function()
		local name = library.Flags.selectedconfig
		if library:DeleteConfig(name) then
			library:Notify("Config deleted: " .. tostring(name), 3, Theme.Good)
			refreshConfigs()
		end
	end })

	local interfaceSection = tab:AddSection("Interface", 2)
	interfaceSection:AddToggle({
		text = "Key Indicators",
		flag = "indicators",
		state = library.indicatorsVisible,
		tooltip = "List the bound features and their keys on screen",
		callback = function(v) library:SetIndicatorsVisible(v) end,
	})
	interfaceSection:AddButton({ text = "Reset Indicator Position", callback = function()
		library:SetIndicatorPosition(UDim2.new(1, -18, 0, 110))
	end })

	mainSection:AddBind({
		text = "Open / Close",
		flag = "togglekey",
		NoIndicator = true,
		bind = library.toggleKey,
		mode = "toggle",
		callback = function()
			library:SetOpen(not library.open)
		end,
		OnBind = function(key)
			library.toggleKey = key
		end,
	})

	mainSection:AddButton({ text = "Rejoin Server", confirm = true, callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end })
	mainSection:AddButton({ text = "Rejoin Game", confirm = true, callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId)
	end })
	mainSection:AddButton({ text = "Copy Join Script", callback = function()
		if type(setclipboard) ~= "function" then return end
		pcall(setclipboard, ([[game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s")]]):format(game.PlaceId, game.JobId))
		library:Notify("Join script copied", 3, Theme.Good)
	end })
	mainSection:AddButton({ text = "Unload", confirm = true, callback = function()
		library:Unload()
	end })

	refreshConfigs()
	return tab
end

function library:Unload()
	for _, window in ipairs(obelus.windows) do
		if window.Screen then window.Screen:Destroy() end
	end
	table.clear(obelus.windows)
	utility:DisconnectAll()
	if overlay then
		overlay:Destroy()
		overlay = nil
	end
	if type(getgenv) == "function" then
		local env = getgenv()
		if env.VantixElixer == library then env.VantixElixer = nil end
	end
end

function library.NewWindow(self, windowInfo)
	return self:Window(windowInfo)
end

library.CreateWindow = library.NewWindow

local loadOptions = ...
if type(loadOptions) == "table" then
	library:init(loadOptions)
end

if type(getgenv) == "function" then
	local env = getgenv()
	if env.VantixElixer and env.VantixElixer ~= library and env.VantixElixer.Unload then
		pcall(env.VantixElixer.Unload, env.VantixElixer)
	end
	env.VantixElixer = library
end

return library, utility, obelus
