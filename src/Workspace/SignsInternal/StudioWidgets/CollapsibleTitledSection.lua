----------------------------------------
--
-- CollapsibleTitledSectionClass
--
-- Creates a section with a title label:
--
-- "SectionXXX"
--     "TitleBarVisual"
--     "Contents"
--
-- Requires "parent" and "sectionName" parameters and returns the section and its contentsFrame
-- The entire frame will resize dynamically as contents frame changes size.
--
-- "autoScalingList" is a boolean that defines wheter or not the content frame automatically resizes when children are added.
-- This is important for cases when you want minimize button to push or contract what is below it.
--
-- Both "minimizeable" and "minimizedByDefault" are false by default
-- These parameters define if the section will have an arrow button infront of the title label, 
-- which the user may use to hide the section's contents
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)

local kRightButtonAsset = "rbxasset://textures/DeveloperFramework/button_arrow_right.png"
local kDownButtonAsset = "rbxasset://textures/DeveloperFramework/button_arrow_down.png"

local kArrowSize = 7

CollapsibleTitledSectionClass = {}
CollapsibleTitledSectionClass.__index = CollapsibleTitledSectionClass


function CollapsibleTitledSectionClass.new(nameSuffix, titleText, autoScalingList, minimizable, minimizedByDefault)
	local self = {}
	setmetatable(self, CollapsibleTitledSectionClass)
	
	self._minimized = minimizedByDefault
	self._minimizable = minimizable

	self._titleBarHeight = GuiUtilities.kTitleBarHeight

	local frame = Instance.new('Frame')
	frame.Name = 'CTSection' .. nameSuffix
	frame.BackgroundTransparency = 1
	self._frame = frame

	local uiListLayout = Instance.new('UIListLayout')
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = frame
	self._uiListLayout = uiListLayout

	local contentsFrame = Instance.new('Frame')
	contentsFrame.Name = 'Contents'
	contentsFrame.BackgroundTransparency = 1
	contentsFrame.Size = UDim2.new(1, 0, 0, 1)
	contentsFrame.Position = UDim2.new(0, 0, 0, 0)
	contentsFrame.Parent = frame
	contentsFrame.LayoutOrder = 2
	GuiUtilities.syncGuiElementBackgroundColor(contentsFrame)

	self._contentsFrame = contentsFrame

	uiListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		self:_UpdateSize()
	end)
	self:_UpdateSize()

	self:_CreateTitleBar(titleText)
	self:SetCollapsedState(self._minimized)
	
	if (autoScalingList) then
		GuiUtilities.MakeFrameAutoScalingList(self:GetContentsFrame())
	end

	return self
end


function CollapsibleTitledSectionClass:GetSectionFrame()
	return self._frame
end

function CollapsibleTitledSectionClass:GetContentsFrame()
	return self._contentsFrame
end

function CollapsibleTitledSectionClass:_UpdateSize()
	local totalSize = self._uiListLayout.AbsoluteContentSize.Y
	self._frame.Size = UDim2.new(1, 0, 0, totalSize)
end

function CollapsibleTitledSectionClass:_UpdateMinimizeButton()
	-- We can't rotate it because rotated images don't get clipped by parents.
	-- This is all in a scroll widget.
	-- :(
	if (self._minimized) then 
		self._minimizeButton.Image = kRightButtonAsset
	else
		self._minimizeButton.Image = kDownButtonAsset
	end
end

function CollapsibleTitledSectionClass:SetCollapsedState(bool)
	self._minimized = bool
	self._contentsFrame.Visible = not bool
	self:_UpdateMinimizeButton()
	self:_UpdateSize()
end

function CollapsibleTitledSectionClass:_ToggleCollapsedState()
	self:SetCollapsedState(not self._minimized)
end

function CollapsibleTitledSectionClass:_CreateTitleBar(titleText)
	local titleTextOffset = self._titleBarHeight

	local titleBar = Instance.new('ImageButton')
	titleBar.Name = 'TitleBarVisual'
	titleBar.AutoButtonColor = false
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.Size = UDim2.new(1, 0, 0, self._titleBarHeight)
	titleBar.Parent = self._frame
	titleBar.LayoutOrder = 1

	GuiUtilities.syncGuiElementShadowColor(titleBar)
	GuiUtilities.syncGuiElementTitleColor(titleBar)

	local titleLabel = Instance.new('TextLabel')
	titleLabel.Name = 'TitleLabel'
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = GuiUtilities.kDefaultFontFaceBold
	titleLabel.TextSize = GuiUtilities.kDefaultFontSize
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = titleText
	titleLabel.Position = UDim2.new(0, titleTextOffset, 0, 0)
	titleLabel.Size = UDim2.new(1, -titleTextOffset, 1, GuiUtilities.kTextVerticalFudge)
	titleLabel.Parent = titleBar
	GuiUtilities.syncGuiElementFontColor(titleLabel)

	self._minimizeButton = Instance.new('ImageButton')
	self._minimizeButton.Name = 'MinimizeSectionButton'
	self._minimizeButton.Image = kRightButtonAsset              -- TODO: input arrow image from spec
	self._minimizeButton.Size = UDim2.new(0, kArrowSize, 0, kArrowSize)
	self._minimizeButton.AnchorPoint = Vector2.new(0.5, 0.5)
	self._minimizeButton.Position = UDim2.new(0, self._titleBarHeight*.5,
		 0, self._titleBarHeight*.5)
	self._minimizeButton.BackgroundTransparency = 1
	self._minimizeButton.Visible = self._minimizable -- only show when minimizable
	self._minimizeButton.Parent = titleBar

	self._titleBar = titleBar

	local function _UpdateMinimizeButtonTheme()
		self._minimizeButton.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
	settings().Studio.ThemeChanged:Connect(_UpdateMinimizeButtonTheme)
	_UpdateMinimizeButtonTheme()

	titleBar.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			self._hovered = true
			self:_updateButtonVisual()
		end
	end)

	titleBar.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			self._hovered = false
			self._clicked = false
			self:_updateButtonVisual()
		end
	end)

	titleBar.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_updateButtonVisual()

		if self._minimizable == true then
			self:_ToggleCollapsedState()
		end
	end)

	titleBar.MouseButton1Up:Connect(function()
		self._clicked = false
		self:_updateButtonVisual()
	end)
end

function CollapsibleTitledSectionClass:_updateButtonVisual()
	local kTitlebarDefaultBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem, Enum.StudioStyleGuideModifier.Default)
	local kTitlebarHoverBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
	local kTitlebarPressedBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)

	if (self._clicked) then 
		self._titleBar.BackgroundColor3 = kTitlebarHoverBackgroundColor
	elseif (self._hovered) then 
		self._titleBar.BackgroundColor3 = kTitlebarHoverBackgroundColor
	else
		self._titleBar.BackgroundColor3 = kTitlebarDefaultBackgroundColor
	end
end

return CollapsibleTitledSectionClass