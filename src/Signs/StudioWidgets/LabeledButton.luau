----------------------------------------
--
-- LabeledButton.luau
--
-- Creates a labeled square button.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local kCheckboxWidth = GuiUtilities.kCheckboxWidth

local kMinHeight = 24
local kMinLabelWidth = GuiUtilities.kCheckboxMinLabelWidth
local kMinMargin = GuiUtilities.kCheckboxMinMargin
local kMinButtonWidth = kCheckboxWidth

local LabeledButtonClass = {}
LabeledButtonClass.__index = LabeledButtonClass

LabeledButtonClass.kMinFrameSize = UDim2.new(0, kMinLabelWidth + kMinMargin + kMinButtonWidth, 0, kMinHeight)

-- Creates a new LabeledButtonClass.
function LabeledButtonClass.new(nameSuffix: string, labelText: string, value: number, disabled: boolean)
	local self = {}
	setmetatable(self, LabeledButtonClass)

	local initValue = not not value
	local initDisabled = not not disabled

	local frame = Instance.new("Frame")
	frame.Name = "LabeledButton" .. nameSuffix
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, GuiUtilities.kDefaultPropertyHeight, 0)

	local fullBackgroundButton = Instance.new("TextButton")
	fullBackgroundButton.Name = "FullBackground"
	fullBackgroundButton.Parent = frame
	fullBackgroundButton.BorderSizePixel = 0
	fullBackgroundButton.BackgroundTransparency = 0
	fullBackgroundButton.Size = UDim2.new(1, 0, 1, 0)
	fullBackgroundButton.Position = UDim2.new(0, 0, 0, 0)
	fullBackgroundButton.Text = ""
	fullBackgroundButton.AutoButtonColor = false

	local label = Instance.new("TextButton")
	label.Text = labelText
	label.RichText = true
	label.Name = "Label"
	label.Font = GuiUtilities.kDefaultFontFace
	label.TextSize = GuiUtilities.kDefaultFontSize
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.AutoButtonColor = false
	label.Position = UDim2.new(0.5, GuiUtilities.DefaultLineLabelLeftMargin, 0.5, GuiUtilities.kTextVerticalFudge)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Parent = fullBackgroundButton

	self._frame = frame
	self._label = label

	self._clicked = false
	self._hovered = false

	self._button = fullBackgroundButton
	self._useDisabledOverride = false
	self._disabledOverride = false
	self:SetDisabled(initDisabled)

	self._value = not initValue
	self:SetValue(initValue)

	self:_SetupMouseClickHandling()

	local function updateFontColors()
		self:UpdateFontColors()
	end
	settings().Studio.ThemeChanged:Connect(updateFontColors)
	updateFontColors()

	local function updateButtonColors()
		self:_updateCheckboxVisual()
	end
	settings().Studio.ThemeChanged:Connect(updateButtonColors)
	updateButtonColors()

	return self
end

-- Internal function to update button toggle state.
function LabeledButtonClass:_MaybeToggleState()
	if not self._disabled then
		self:SetValue(not self._value)
	end
end

-- Internal function to setup mouse click handling.
function LabeledButtonClass:_SetupMouseClickHandling()
	self._label.InputBegan:Connect(function()
		self._hovered = true
		self:_updateCheckboxVisual()
	end)

	self._label.InputEnded:Connect(function()
		self._hovered = false
		self._clicked = false
		self:_updateCheckboxVisual()
	end)

	self._label.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_updateCheckboxVisual()
		self:_MaybeToggleState()
	end)
end

-- Internal function to update button visual state.
function LabeledButtonClass:_updateCheckboxVisual()
	local kButtonDefaultBackgroundColor = settings().Studio.Theme:GetColor(
		Enum.StudioStyleGuideColor.FilterButtonDefault,
		Enum.StudioStyleGuideModifier.Default
	)
	local kButtonHoverBackgroundColor = settings().Studio.Theme:GetColor(
		Enum.StudioStyleGuideColor.FilterButtonHover,
		Enum.StudioStyleGuideModifier.Hover
	)
	local kButtonPressedBackgroundColor = settings().Studio.Theme:GetColor(
		Enum.StudioStyleGuideColor.FilterButtonChecked,
		Enum.StudioStyleGuideModifier.Pressed
	)

	if self._value then
		self._button.BackgroundColor3 = kButtonPressedBackgroundColor
	elseif self._hovered then
		self._button.BackgroundColor3 = kButtonHoverBackgroundColor
	else
		self._button.BackgroundColor3 = kButtonDefaultBackgroundColor
	end
end

-- Internal function to update button visual state.
function LabeledButtonClass:_HandleUpdatedValue()
	local kButtonDefaultBackgroundColor = settings().Studio.Theme:GetColor(
		Enum.StudioStyleGuideColor.FilterButtonDefault,
		Enum.StudioStyleGuideModifier.Default
	)
	local kButtonPressedBackgroundColor = settings().Studio.Theme:GetColor(
		Enum.StudioStyleGuideColor.FilterButtonChecked,
		Enum.StudioStyleGuideModifier.Pressed
	)

	if self:GetValue() then
		self._button.BackgroundColor3 = kButtonPressedBackgroundColor
	else
		self._button.BackgroundColor3 = kButtonDefaultBackgroundColor
	end

	if self._valueChangedFunction then
		self._valueChangedFunction(self:GetValue())
	end
end

-- Returns the frame GuiObject.
function LabeledButtonClass:GetFrame()
	return self._frame
end

-- Returns boolean of the button.
function LabeledButtonClass:GetValue()
	-- If button is disabled, and we should be using a disabled override,
	-- use the disabled override.
	if self._disabled and self._useDisabledOverride then
		return self._disabledOverride
	else
		return self._value
	end
end

-- Returns the label GuiObject.
function LabeledButtonClass:GetLabel()
	return self._label
end

-- Returns the button GuiObject.
function LabeledButtonClass:GetButton()
	return self._button
end

-- Fires when the button is clicked.
function LabeledButtonClass:SetValueChangedFunction(vcFunction)
	self._valueChangedFunction = vcFunction
end

-- Sets the button disabled state.
function LabeledButtonClass:SetDisabled(disabled)
	local newDisabled = not not disabled

	local originalValue = self:GetValue()

	if newDisabled ~= self._disabled then
		self._disabled = newDisabled

		-- if we are no longer disabled, then we don't need or want
		-- the override any more.  Forget it.
		if not self._disabled then
			self._useDisabledOverride = false
		end

		self:UpdateFontColors()
		self._button.BackgroundColor3 = self._disabled and GuiUtilities.kButtonDisabledBackgroundColor
			or GuiUtilities.kButtonDefaultBackgroundColor
		self._button.BorderColor3 = self._disabled and GuiUtilities.kButtonDisabledBorderColor
			or GuiUtilities.kButtonDefaultBorderColor
		if self._disabledChangedFunction then
			self._disabledChangedFunction(self._disabled)
		end
	end

	local newValue = self:GetValue()
	if newValue ~= originalValue then
		self:_HandleUpdatedValue()
	end
end

function LabeledButtonClass:UpdateFontColors()
	if self._disabled then
		self._label.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.DimmedText)
	else
		self._label.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
end

-- Sets the button disabled state when it is disabled.
function LabeledButtonClass:DisableWithOverrideValue(overrideValue)
	-- Disable this checkbox.  While disabled, force value to override
	-- value.
	local oldValue = self:GetValue()
	self._useDisabledOverride = true
	self._disabledOverride = overrideValue
	self:SetDisabled(true)
	local newValue = self:GetValue()
	if oldValue ~= newValue then
		self:_HandleUpdatedValue()
	end
end

-- Gets the button disabled state.
function LabeledButtonClass:GetDisabled()
	return self._disabled
end

-- Sets the button state.
function LabeledButtonClass:SetValue(newValue)
	local value = not not newValue

	if value ~= self._value then
		self._value = value

		self:_HandleUpdatedValue()
	end
end

return LabeledButtonClass
