----------------------------------------
--
-- VerticalScrollingFrame.lua
--
-- Creates a scrolling frame that automatically updates canvas size
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local kScrollbarWidth = 12
local kScrollbarBackgroundPadding = 2

local kScrollbarTopImage = "rbxasset://textures/StudioToolbox/ScrollBarTop.png"
local kScrollbarMiddleImage = "rbxasset://textures/StudioToolbox/ScrollBarMiddle.png"
local kScrollbarBottomImage = "rbxasset://textures/StudioToolbox/ScrollBarBottom.png"

local VerticalScrollingFrame = {}
VerticalScrollingFrame.__index = VerticalScrollingFrame

-- Creates a new VerticalScrollingFrame
function VerticalScrollingFrame.new(suffix: string)
	local self = {}
	setmetatable(self, VerticalScrollingFrame)

	local section = Instance.new("Frame")
	section.BorderSizePixel = 0
	section.Size = UDim2.new(1, 0, 1, 0)
	section.Position = UDim2.new(0, 0, 0, 0)
	section.BackgroundTransparency = 0
	section.Name = "VFrame" .. suffix
	GuiUtilities.syncGuiElementBackgroundColor(section)
	self._section = section

	-- local scrollBackground = Instance.new("Frame")
	-- scrollBackground.Name = "ScrollbarBackground"
	-- scrollBackground.BackgroundTransparency = 0
	-- scrollBackground.BorderMode = Enum.BorderMode.Inset
	-- scrollBackground.Size = UDim2.new(0, kScrollbarWidth + (kScrollbarBackgroundPadding * 2), 1, 0)
	-- scrollBackground.AnchorPoint = Vector2.new(1, 0.5)
	-- scrollBackground.Position = UDim2.new(1, 0, 0.5, 0)
	-- scrollBackground.Parent = section
	-- scrollBackground.ZIndex = 2
	-- GuiUtilities.syncGuiElementBorderColor(scrollBackground)
	-- GuiUtilities.syncGuiElementScrollBarBackgroundColor(scrollBackground)
	-- self._scrollBackground = scrollBackground

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame" .. suffix
	scrollFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	scrollFrame.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollFrame.ScrollBarThickness = kScrollbarWidth
	scrollFrame.BorderSizePixel = 0
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ZIndex = 2
	scrollFrame.TopImage = kScrollbarTopImage
	scrollFrame.MidImage = kScrollbarMiddleImage
	scrollFrame.BottomImage = kScrollbarBottomImage
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = section
	GuiUtilities.syncGuiElementScrollColor(scrollFrame)
	self._scrollFrame = scrollFrame

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 5)
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.Parent = scrollFrame
	self._uiListLayout = uiListLayout

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingRight = UDim.new(0, 0)
	uiPadding.Parent = scrollFrame
	self._uiPadding = uiPadding

	scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:_updateScrollingFrameCanvas()
	end)
	uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self:_updateScrollingFrameCanvas()
	end)
	self:_updateScrollingFrameCanvas()

	return self
end

-- Updates the visibility of the scrollbar backing
function VerticalScrollingFrame:_updateScrollbarBackingVisibility()
	local visible = self._scrollFrame.AbsoluteSize.y < self._uiListLayout.AbsoluteContentSize.y

	if visible then
		self._uiPadding.PaddingRight = UDim.new(0, 0)
	else
		self._uiPadding.PaddingRight = UDim.new(0, 0)
	end
end

-- Updates the canvas size of the ScrollingFrame
function VerticalScrollingFrame:_updateScrollingFrameCanvas()
	self._scrollFrame.CanvasSize = UDim2.new(0, 0, 0, self._uiListLayout.AbsoluteContentSize.Y)
	self:_updateScrollbarBackingVisibility()
end

-- Returns the ScrollingFrame used by this VerticalScrollingFrame
function VerticalScrollingFrame:GetContentsFrame(): Frame
	return self._scrollFrame
end

-- Returns the Frame used by this VerticalScrollingFrame
function VerticalScrollingFrame:GetSectionFrame(): Frame
	return self._section
end

return VerticalScrollingFrame
