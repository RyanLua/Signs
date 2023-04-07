----------------------------------------
--
-- LabeledCheckbox
--
-- Creates a frame containing a label and a checkbox.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)
local CollapsibleItem = require(script.Parent.CollapsibleItem)

local kCheckboxSize = GuiUtilities.kCheckboxSize

local kMinTextSize = 14
local kMinHeight = 24
local kMinLabelWidth = GuiUtilities.kCheckboxMinLabelWidth
local kMinMargin = GuiUtilities.kCheckboxMinMargin
local kMinButtonWidth = kCheckboxSize
local kMinFrameSize = UDim2.new(0, kMinLabelWidth + kMinMargin + kMinButtonWidth, 0, kMinHeight)

local kMinLabelSize = UDim2.new(0, kMinLabelWidth, 0, kMinHeight)
local kMinLabelPos = UDim2.new(0, kMinButtonWidth + kMinMargin, 0, kMinHeight / 2)

local kMinButtonSize = UDim2.new(0, kMinButtonWidth, 0, kMinButtonWidth)
local kMinButtonPos = UDim2.new(0, 0, 0, kMinHeight / 2)

local kCheckImageWidth = kMinMargin
local kMinCheckImageWidth = kCheckImageWidth

local kCheckImageSize = UDim2.new(0, kCheckboxSize, 0, kCheckboxSize)
local kMinCheckImageSize = UDim2.new(0, kMinCheckImageWidth, 0, kMinCheckImageWidth)

local kLightEnabledCheckImage = "rbxasset://textures/CollisionGroupsEditor/checked-bluebg.png"
local kLightDisabledCheckImage = "rbxasset://textures/DeveloperFramework/checkbox_indeterminate_light.png"
local kLightHoverCheckImage = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_hover_light.png"
local kLightCheckboxFrameImage = "rbxasset://textures/CollisionGroupsEditor/unchecked.png"

local kEnabledCheckImageDark = "rbxasset://textures/DeveloperFramework/checkbox_checked_dark.png"
local kDisabledCheckImageDark = "rbxasset://textures/DeveloperFramework/checkbox_indeterminate_dark.png"
local kHoverCheckImageDark = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_hover_dark.png"
local kCheckboxFrameImageDark = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_dark.png"

local LabeledCheckboxClass = {}
LabeledCheckboxClass.__index = LabeledCheckboxClass

-- Creates a new LabeledCheckbox
function LabeledCheckboxClass.new(
	nameSuffix: string,
	labelText: string,
	initValue: boolean,
	initDisabled: boolean,
	url: string
)
	local self = {}
	setmetatable(self, LabeledCheckboxClass)

	local item = CollapsibleItem.new(nameSuffix, labelText, false, url)
	self._item = item
	self._frame = item:GetFrame()
	self._label = item:GetLabel()

	local button = Instance.new("ImageButton")
	button.Name = "Button"
	button.Size = UDim2.new(0, kCheckboxSize, 0, kCheckboxSize)
	button.AnchorPoint = Vector2.new(0, 0.5)
	button.BackgroundTransparency = 1
	button.Position = UDim2.new(0.5, GuiUtilities.kCheckboxPadding, 0.5, 0)
	button.Parent = item:GetFrame()
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	self._button = button

	local checkImage = Instance.new("ImageLabel")
	checkImage.Name = "CheckImage"
	checkImage.Parent = button
	checkImage.Visible = false
	checkImage.Size = kCheckImageSize
	checkImage.AnchorPoint = Vector2.new(0, 0.5)
	checkImage.Position = UDim2.new(0, 0, 0.5, 0)
	checkImage.BackgroundTransparency = 1
	checkImage.BorderSizePixel = 0
	self._checkImage = checkImage

	self._clicked = false
	self._hovered = false

	self._useDisabledOverride = false
	self._disabledOverride = false
	self:SetDisabled(initDisabled)

	self._value = not initValue
	self:SetValue(initValue)

	self:_SetupMouseClickHandling()

	local function updateImages()
		if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
			self._button.Image = kCheckboxFrameImageDark
			if self._checkImage.Image == kLightDisabledCheckImage then
				self._checkImage.Image = kDisabledCheckImageDark
			else
				self._checkImage.Image = kEnabledCheckImageDark
			end
		else
			self._button.Image = kLightCheckboxFrameImage
			if self._checkImage.Image == kDisabledCheckImageDark then
				self._checkImage.Image = kLightDisabledCheckImage
			else
				self._checkImage.Image = kLightEnabledCheckImage
			end
		end
	end
	settings().Studio.ThemeChanged:Connect(updateImages)
	updateImages()

	local function updateFontColors()
		self:UpdateFontColors()
	end
	settings().Studio.ThemeChanged:Connect(updateFontColors)
	updateFontColors()

	return self
end

-- Sets the value of the checkbox
function LabeledCheckboxClass:_MaybeToggleState()
	if not self._disabled then
		self:SetValue(not self._value)
	end
end

-- Setup the mouse click handling for the checkbox
function LabeledCheckboxClass:_SetupMouseClickHandling()
	self._frame.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_MaybeToggleState()
	end)

	self._button.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_UpdateCheckboxVisual()
	end)

	self._button.InputBegan:Connect(function()
		self._hovered = true
		self:_UpdateCheckboxVisual()
	end)

	self._frame.InputEnded:Connect(function()
		self._hovered = false
		self._clicked = false
		self:_UpdateCheckboxVisual()
	end)
end

-- Updates the visual state of the checkbox
function LabeledCheckboxClass:_UpdateCheckboxVisual()
	if self._hovered then
		if GuiUtilities.ShouldUseIconsForDarkerBackgrounds() then
			self._button.Image = kHoverCheckImageDark
		else
			self._button.Image = kLightHoverCheckImage
		end
	else
		if GuiUtilities.ShouldUseIconsForDarkerBackgrounds() then
			self._button.Image = kCheckboxFrameImageDark
		else
			self._button.Image = kLightCheckboxFrameImage
		end
	end
end

-- Handles the value being updated
function LabeledCheckboxClass:_HandleUpdatedValue()
	self._checkImage.Visible = self:GetValue()

	if self._valueChangedFunction then
		self._valueChangedFunction(self:GetValue())
	end
end

-- Small checkboxes are a different entity.
-- All the bits are smaller.
-- Fixed width instead of flood-fill.
-- Box comes first, then label.
function LabeledCheckboxClass:UseSmallSize()
	self._label.TextSize = kMinTextSize
	self._label.Size = kMinLabelSize
	self._label.Position = kMinLabelPos
	self._label.TextXAlignment = Enum.TextXAlignment.Left

	self._button.Size = kMinButtonSize
	self._button.Position = kMinButtonPos

	self._checkImage.Size = kMinCheckImageSize

	self._frame.Size = kMinFrameSize
	self._frame.BackgroundTransparency = 1
end

-- Gets the frame for the checkbox
function LabeledCheckboxClass:GetFrame()
	return self._frame
end

-- Gets the value of the checkbox
function LabeledCheckboxClass:GetValue()
	-- If button is disabled, and we should be using a disabled override,
	-- use the disabled override.
	if self._disabled and self._useDisabledOverride then
		return self._disabledOverride
	else
		return self._value
	end
end

-- Gets the label for the checkbox
function LabeledCheckboxClass:GetLabel()
	return self._label
end

-- Gets the button for the checkbox
function LabeledCheckboxClass:GetButton()
	return self._button
end

-- Set the value changed function
function LabeledCheckboxClass:SetValueChangedFunction(vcFunction: boolean)
	self._valueChangedFunction = vcFunction
end

-- Sets the disabled state of the checkbox
function LabeledCheckboxClass:SetDisabled(newDisabled: boolean)
	local originalValue = self:GetValue()

	if newDisabled ~= self._disabled then
		self._disabled = newDisabled

		-- if we are no longer disabled, then we don't need or want
		-- the override any more.  Forget it.
		if not self._disabled then
			self._useDisabledOverride = false
		end

		if newDisabled then
			if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
				self._checkImage.Image = kDisabledCheckImageDark
			else
				self._checkImage.Image = kLightDisabledCheckImage
			end
		else
			if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
				self._checkImage.Image = kEnabledCheckImageDark
			else
				self._checkImage.Image = kLightEnabledCheckImage
			end
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

-- Updates the font colors of the checkbox
function LabeledCheckboxClass:UpdateFontColors()
	if self._disabled then
		self._label.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.DimmedText)
	else
		self._label.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
end

-- Disables the checkbox, and forces the value to be the override value.
function LabeledCheckboxClass:DisableWithOverrideValue(overrideValue: boolean)
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

-- Gets the disabled state of the checkbox
function LabeledCheckboxClass:GetDisabled()
	return self._disabled
end

-- Sets the value of the checkbox
function LabeledCheckboxClass:SetValue(newValue: boolean)
	if newValue ~= self._value then
		self._value = newValue

		self:_HandleUpdatedValue()
	end
end

return LabeledCheckboxClass
