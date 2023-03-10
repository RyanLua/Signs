----------------------------------------
--
-- ScalingFrame
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local ScalingFrameClass = {}
ScalingFrameClass.__index = ScalingFrameClass

local kPadding = 5

function ScalingFrameClass.new(nameSuffix)
	local self = {}
	setmetatable(self, ScalingFrameClass)

	self._resizeCallback = nil

	local frame = Instance.new("Frame")
	frame.Name = "VFrame" .. nameSuffix
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	GuiUtilities.syncGuiElementBackgroundColor(frame)

	self._frame = frame

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.Padding = UDim.new(0, kPadding)
	uiListLayout.Parent = frame
	self._uiListLayout = uiListLayout

	-- local function updateSizes()
	-- 	self._frame.Size = UDim2.new(1, 0, 0, uiListLayout.AbsoluteContentSize.Y)
	-- 	if self._resizeCallback then
	-- 		self._resizeCallback()
	-- 	end
	-- end
	-- self._uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSizes)
	-- updateSizes()

	self._childCount = 0

	return self
end

function ScalingFrameClass:AddTopPadding()
	local frame = Instance.new("Frame")
	frame.Name = "TopPadding"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, 0, 0, kPadding)
	frame.LayoutOrder = -1
	frame.Parent = self._frame
end

function ScalingFrameClass:AddBottomPadding()
	local frame = Instance.new("Frame")
	frame.Name = "BottomPadding"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, 0, 0, kPadding)
	frame.LayoutOrder = 1000
	frame.Parent = self._frame
end

function ScalingFrameClass:GetFrame(): Frame
	return self._frame
end

function ScalingFrameClass:AddChild(childFrame)
	childFrame.LayoutOrder = self._childCount
	self._childCount = self._childCount + 1
	childFrame.Parent = self._frame
end

function ScalingFrameClass:SetCallbackOnResize(callback)
	self._resizeCallback = callback
end

return ScalingFrameClass
