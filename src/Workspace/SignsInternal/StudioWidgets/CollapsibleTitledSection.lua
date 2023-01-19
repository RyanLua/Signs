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
local kDoubleClickTimeSec = 0.5

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
	if self._minimizable == true then
		titleBar.AutoButtonColor = true --  TODO: Set this to false when you implement a better solution.
	else
		titleBar.AutoButtonColor = false --  TODO: Set this to false when you implement a better solution.
	end
	titleBar.Name = 'TitleBarVisual'
	titleBar.BorderSizePixel = 0
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.Size = UDim2.new(1, 0, 0, self._titleBarHeight)
	titleBar.Parent = self._frame
	titleBar.LayoutOrder = 1
	GuiUtilities.syncGuiElementTitleColor(titleBar)

	local titleLabel = Instance.new('TextLabel')
	titleLabel.Name = 'TitleLabel'
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.SourceSansBold                -- TODO: input spec font
	titleLabel.TextSize = 15                                  -- TODO: input spec font size
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

	local function _UpdateMinimizeButtonTheme()
		if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() == false then
			self._minimizeButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
		else
			self._minimizeButton.ImageColor3 = Color3.fromRGB(237, 237, 237)
		end
	end
	settings().Studio.ThemeChanged:Connect(_UpdateMinimizeButtonTheme)
	_UpdateMinimizeButtonTheme()

	self._minimizeButton.MouseButton1Down:Connect(function()
		self:_ToggleCollapsedState()
	end)
	self:_UpdateMinimizeButton()
	self._minimizeButton.Parent = titleBar

	self._latestClickTime = 0
	titleBar.MouseButton1Down:Connect(function()
		-- commented out the code so it takes 1 click to open titlebar now instead of 2

		--local now = tick()	
		--if (now - self._latestClickTime < kDoubleClickTimeSec) then 
		if self._minimizable == true then -- if check was added in to fix bug. idk why this was left unfixed.
			self:_ToggleCollapsedState()
		end
		--	self._latestClickTime = 0
		--else
		--	self._latestClickTime = now
		--end
	end)
end

return CollapsibleTitledSectionClass