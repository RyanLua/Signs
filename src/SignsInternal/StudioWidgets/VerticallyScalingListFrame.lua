----------------------------------------
--
-- VerticallyScalingListFrame
--
-- Creates a frame that organizes children into a list layout.
-- Will scale dynamically as children grow.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local VerticallyScalingListFrameClass = {}
VerticallyScalingListFrameClass.__index = VerticallyScalingListFrameClass

local kBottomPadding = 10

-- Creates a new VerticallyScalingListFrameClass
function VerticallyScalingListFrameClass.new(nameSuffix: string)
	local self = {}
	setmetatable(self, VerticallyScalingListFrameClass)

	self._resizeCallback = nil

	local frame = Instance.new("Frame")
	frame.Name = "VSLFrame" .. nameSuffix
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	GuiUtilities.syncGuiElementBackgroundColor(frame)

	self._frame = frame

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = frame
	self._uiListLayout = uiListLayout

	local function updateSizes()
		self._frame.Size = UDim2.new(1, 0, 0, uiListLayout.AbsoluteContentSize.Y)
		if self._resizeCallback then
			self._resizeCallback()
		end
	end
	self._uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSizes)
	updateSizes()

	self._childCount = 0

	return self
end

-- Adds a padding frame to the top of the list
function VerticallyScalingListFrameClass:AddTopPadding()
	local frame = Instance.new("Frame")
	frame.Name = "TopPadding"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, 0, 0, kBottomPadding)
	frame.LayoutOrder = -1
	frame.Parent = self._frame
end

-- Adds a padding frame to the bottom of the list
function VerticallyScalingListFrameClass:AddBottomPadding()
	local frame = Instance.new("Frame")
	frame.Name = "BottomPadding"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, 0, 0, kBottomPadding)
	frame.LayoutOrder = 1000
	frame.Parent = self._frame
end

-- Returns the frame that this class is wrapping
function VerticallyScalingListFrameClass:GetFrame(): Frame
	return self._frame
end

-- Adds a child frame to the list
function VerticallyScalingListFrameClass:AddChild(childFrame: Frame)
	childFrame.LayoutOrder = self._childCount
	self._childCount = self._childCount + 1
	childFrame.Parent = self._frame
end

-- Removes all children from the list
function VerticallyScalingListFrameClass:SetCallbackOnResize(callback: boolean)
	self._resizeCallback = callback
end

return VerticallyScalingListFrameClass
