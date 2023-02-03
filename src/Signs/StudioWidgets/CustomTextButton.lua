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
	GuiUtilities.syncGuiButtonColor(button)

	local border = Instance.new('ImageLabel')
	border.Size = UDim2.new(1, 0, 1, 0)
	border.Name = "Border"
	border.BackgroundTransparency = 1
	border.ScaleType = Enum.ScaleType.Slice
	border.SliceCenter = Rect.new(3, 3, 13, 13)
	border.Image = kButtonBorder
	border.Parent = button
	GuiUtilities.syncGuiImageBorderColor(border)

	local label = Instance.new('TextLabel')
	label.Text = labelText
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0) -- 1, 0, 1, GuiUtilities.kButtonVerticalFudge
	label.Font = GuiUtilities.kDefaultFontFace
	label.TextSize = GuiUtilities.kDefaultFontSize
	label.Parent = button
	GuiUtilities.syncGuiElementFontColor(label)

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

	return self
end

function CustomTextButtonClass:_updateButtonVisual()
	local kButtonDefaultBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
	local kButtonPressedBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
	local kButtonHoverBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
	
	if self._clicked then
		self._button.ImageColor3 = kButtonPressedBackgroundColor
	elseif self._hovered then 
		self._button.ImageColor3 = kButtonHoverBackgroundColor
	else
		self._button.ImageColor3 = kButtonDefaultBackgroundColor
	end
end

function CustomTextButtonClass:GetButton()
	return self._button
end

return CustomTextButtonClass