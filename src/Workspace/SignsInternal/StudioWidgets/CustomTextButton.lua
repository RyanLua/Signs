----------------------------------------
--
-- CustomTextButton.lua
--
-- Creates text button with custom look & feel, hover/click effects.
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)

local kButtonImageIdDefault = "rbxasset://textures/StudioToolbox/RoundedBackground.png"
local kButtonImageIdHovered = "rbxasset://textures/TerrainTools/button_hover.png"
local kButtonImageIdPressed = "rbxasset://textures/TerrainTools/button_pressed.png"

local kButtonBorder = "rbxasset://textures/StudioToolbox/RoundedBorder.png"

CustomTextButtonClass = {}
CustomTextButtonClass.__index = CustomTextButtonClass

function CustomTextButtonClass.new(buttonName, labelText)
	local self = {}
	setmetatable(self, CustomTextButtonClass)

	local button = Instance.new('ImageButton')
	button.Name = buttonName
	button.Image = kButtonImageIdDefault
	button.BackgroundTransparency = 1
	button.ScaleType = Enum.ScaleType.Slice
	button.SliceCenter = Rect.new(3, 3, 13, 13)
	button.AutoButtonColor = false

	local border = Instance.new('ImageLabel')
	border.Size = UDim2.new(1, 0, 1, 0)
	border.BackgroundTransparency = 1
	border.ScaleType = Enum.ScaleType.Slice
	border.SliceCenter = Rect.new(3, 3, 13, 13)
	border.Image = kButtonBorder
	border.Parent = button

	local label = Instance.new('TextLabel')
	label.Text = labelText
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0) -- 1, 0, 1, GuiUtilities.kButtonVerticalFudge
	label.Font = Enum.Font.SourceSans
	label.TextSize = 15
	label.Parent = button

	self._label = label
	self._border = border
	self._button = button

	self._clicked = false
	self._hovered = false

	button.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			self._hovered = true
			self:_updateButtonVisual()
		end
	end)


	button.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			self._hovered = false
			self._clicked = false
			self:_updateButtonVisual()
		end
	end)

	button.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_updateButtonVisual()
	end)

	button.MouseButton1Up:Connect(function()
		self._clicked = false
		self:_updateButtonVisual()
	end)
	
	self:_updateButtonVisual()

	return self
end

function CustomTextButtonClass:_updateButtonVisual()
	self._border.ImageColor3 = GuiUtilities.kButtonStandardBorderColor
	if (self._clicked) then 
		self._button.ImageColor3 = GuiUtilities.kButtonPressedBackgroundColor
		self._label.TextColor3 = GuiUtilities.kStandardButtonTextColor
	elseif (self._hovered) then 
		self._button.ImageColor3 = GuiUtilities.kButtonHoverBackgroundColor
		self._label.TextColor3 = GuiUtilities.kStandardButtonTextColor
	else
		self._button.ImageColor3 = GuiUtilities.kButtonStandardBackgroundColor
		self._label.TextColor3 = GuiUtilities.kStandardButtonTextColor
	end
end

function CustomTextButtonClass:GetButton()
	return self._button
end

return CustomTextButtonClass

