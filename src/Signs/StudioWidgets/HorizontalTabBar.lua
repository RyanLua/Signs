----------------------------------------
--
-- HorizontalTabBar.lua
--
-- Creates a horizontal tab bar with a set amount of tabs.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local HorizontalTabClass = {}
HorizontalTabClass.__index = HorizontalTabClass
-- setmetatable(HorizontalTabClass, HorizontalTab)

function HorizontalTabClass.new(suffix: string)
	local self = {}
	setmetatable(self, HorizontalTabClass)

	local titlebar = Instance.new("Frame")
	titlebar.Name = "TabBar" .. suffix
	titlebar.BorderSizePixel = 0
	titlebar.Size = UDim2.new(1, 0, 0, 29)
	titlebar.Position = UDim2.new(0, 0, 0, 0)
	GuiUtilities.syncGuiTabBarBackgroundColor(titlebar)
	self._titlebar = titlebar

	local frame = Instance.new("Frame")
	frame.Name = "TabFrame" .. suffix
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0
	frame.Size = UDim2.new(1, 0, 1, -30)
	frame.Position = UDim2.new(0, 0, 0, 30)
	GuiUtilities.syncGuiElementBackgroundColor(frame)
	self._frame = frame

	local uiPageLayout = Instance.new("UIPageLayout")
	uiPageLayout.Name = "TabBarPageLayout" .. suffix
	uiPageLayout.EasingStyle = Enum.EasingStyle.Cubic
	uiPageLayout.TweenTime = 0.2
	uiPageLayout.Parent = frame
	self._uiPageLayout = uiPageLayout

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Name = "TabBarListLayout" .. suffix
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 2)
	uiListLayout.Parent = titlebar
	self._uiListLayout = uiListLayout

	self._selected = false
	self._hovered = false

	self:_SetupTabHandling(self)
	-- HorizontalTabClass._SetupMouseClickHandling()

	return self
end

function HorizontalTabClass:_SetupTabHandling(self)
	self._titlebar.ChildAdded:Connect(function()
		local tabButtonWidth = 1 / (#self._titlebar:GetChildren() - 1)
		for _, child in pairs(self._titlebar:GetChildren()) do
			if child:IsA("TextButton") then
				child.Size = UDim2.new(tabButtonWidth, 0, 0, 27)
			end
		end
	end)
	self._titlebar.ChildRemoved:Connect(function()
		local tabButtonWidth = 1 / (#self._titlebar:GetChildren() - 1)
		for _, child in pairs(self._titlebar:GetChildren()) do
			if child:IsA("TextButton") then
				child.Size = UDim2.new(tabButtonWidth, 0, 0, 27)
			end
		end
	end)
end

function HorizontalTabClass:_SetupMouseClickHandling()
	self._tabButton.InputBegan:Connect(function()
			self._hovered = true
			self:_updateCheckboxVisual()
	end)

	self._tabButton.InputEnded:Connect(function()
			self._hovered = false
			self:_updateCheckboxVisual()
	end)

	self._tabButton.MouseButton1Down:Connect(function()
		self._selected = true
		self:_updateCheckboxVisual()
	end)
end

function HorizontalTabClass:_UpdateCheckboxVisual()
	local kButtonDefaultBackgroundColor =
		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab, Enum.StudioStyleGuideModifier.Default)
	local kButtonHoverBackgroundColor =
		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab, Enum.StudioStyleGuideModifier.Hover)
	local kButtonSelectedBackgroundColor =
		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab, Enum.StudioStyleGuideModifier.Selected)

	if self._selected then
		self._tabButton.BackgroundColor3 = kButtonSelectedBackgroundColor
	elseif self._hovered then
		self._tabButton.BackgroundColor3 = kButtonHoverBackgroundColor
	else
		self._tabButton.BackgroundColor3 = kButtonDefaultBackgroundColor
	end
end

function HorizontalTabClass:AddTab(suffix: string, name: string)
	local tabButton = Instance.new("TextButton")
	tabButton.AutoButtonColor = true
	tabButton.Name = "TabButton" .. suffix
	tabButton.BorderSizePixel = 2
	tabButton.Position = UDim2.new(0, 0, 0, 0)
	tabButton.Size = UDim2.new(1, 0, 0, 27)
	tabButton.Font = GuiUtilities.kDefaultFontFace
	tabButton.TextSize = GuiUtilities.kDefaultFontSize
	tabButton.AutoButtonColor = false
	tabButton.Text = name
	tabButton.Parent = self._titlebar
	GuiUtilities.syncGuiElementFontColor(tabButton)
	GuiUtilities.syncGuiElementTitlebarColor(tabButton)
	GuiUtilities.syncGuiElementBorderColor(tabButton)

	tabButton.MouseButton1Down:Connect(function()
		-- self._uiPageLayout:JumpTo(self:GetContentsFrame(suffix))
	end)
end

function HorizontalTabClass:GetTitlebar(): Frame
	return self._titlebar
end

function HorizontalTabClass:GetContentsFrame(suffix: string): Frame
	for _, child in pairs(self._frame:GetChildren()) do
		if child.Name == "VFrame" .. suffix then
			return child
		end
	end
end

function HorizontalTabClass:GetFrame(): Frame
	return self._frame
end

return HorizontalTabClass
