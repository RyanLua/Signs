----------------------------------------
--
-- CustomTextButton.luau
--
-- Creates text button with custom look & feel, hover/click effects.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local kButtonImageIdDefault = "rbxasset://textures/StudioToolbox/RoundedBackground.png"

local kButtonBorder = "rbxasset://textures/StudioToolbox/RoundedBorder.png"

local CustomTextButtonClass = {}
CustomTextButtonClass.__index = CustomTextButtonClass

-- Creates a new CustomTextButtonClass
function CustomTextButtonClass.new(buttonName: string, labelText: string)
	local self = {}
	setmetatable(self, CustomTextButtonClass)

	local button = Instance.new("ImageButton")
	button.Name = buttonName
	button.Image = kButtonImageIdDefault
	button.BackgroundTransparency = 1
	button.ScaleType = Enum.ScaleType.Slice
	button.SliceCenter = Rect.new(3, 3, 13, 13)
	button.AutoButtonColor = false
	GuiUtilities.syncGuiButtonColor(button)

	local border = Instance.new("ImageLabel")
	border.Size = UDim2.new(1, 0, 1, 0)
	border.Name = "Border"
	border.BackgroundTransparency = 1
	border.ScaleType = Enum.ScaleType.Slice
	border.SliceCenter = Rect.new(3, 3, 13, 13)
	border.Image = kButtonBorder
	border.Parent = button
	GuiUtilities.syncGuiImageBorderColor(border)

	local label = Instance.new("TextLabel")
	label.Text = labelText
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Font = GuiUtilities.kDefaultFontFace
	label.TextSize = GuiUtilities.kDefaultFontSize
	label.Parent = button
	GuiUtilities.syncGuiElementFontColor(label)

	self._label = label
	self._border = border
	self._button = button

	self._clicked = false
	self._hovered = false

	button.InputBegan:Connect(function()
		self._hovered = true
		self:_updateButtonVisual()
	end)

	button.InputEnded:Connect(function()
		self._hovered = false
		self._clicked = false
		self:_updateButtonVisual()
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

-- Updates the button visual based on the current state
function CustomTextButtonClass:_updateButtonVisual()
	local kButtonDefaultBackgroundColor =
		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
	local kButtonPressedBackgroundColor =
		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
	local kButtonHoverBackgroundColor =
		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)

	if self._clicked then
		self._button.ImageColor3 = kButtonPressedBackgroundColor
	elseif self._hovered then
		self._button.ImageColor3 = kButtonHoverBackgroundColor
	else
		self._button.ImageColor3 = kButtonDefaultBackgroundColor
	end
end

-- Gets the button
function CustomTextButtonClass:GetButton(): ImageButton
	return self._button
end

return CustomTextButtonClass
