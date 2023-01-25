----------------------------------------
--
-- LabeledCheckbox.lua
--
-- Creates a frame containing a label and a checkbox.
--
-- TODO: Overhaul this to support new checkboxes along with GuiUtilities support.
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)

local kCheckboxWidth = GuiUtilities.kCheckboxWidth

local kMinTextSize = 14
local kMinHeight = 24
local kMinLabelWidth = GuiUtilities.kCheckboxMinLabelWidth
local kMinMargin = GuiUtilities.kCheckboxMinMargin
local kMinButtonWidth = kCheckboxWidth;

local kMinLabelSize = UDim2.new(0, kMinLabelWidth, 0, kMinHeight)
local kMinLabelPos = UDim2.new(0, kMinButtonWidth + kMinMargin, 0, kMinHeight/2)

local kMinButtonSize = UDim2.new(0, kMinButtonWidth, 0, kMinButtonWidth)
local kMinButtonPos = UDim2.new(0, 0, 0, kMinHeight/2)

local kCheckImageWidth = kMinMargin
local kMinCheckImageWidth = kCheckImageWidth

local kCheckImageSize = UDim2.new(0, kCheckImageWidth, 0, kCheckImageWidth)
local kMinCheckImageSize = UDim2.new(0, kMinCheckImageWidth, 0, kMinCheckImageWidth)

local kEnabledCheckImage = "rbxasset://textures/DeveloperFramework/checkbox_checked_light.png"
local kDisabledCheckImage = "rbxasset://textures/DeveloperFramework/checkbox_indeterminate_light.png"
local kHoverCheckImage = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_hover_light.png"
local kCheckboxFrameImage = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_light.png"

local kEnabledCheckImageDark = "rbxasset://textures/DeveloperFramework/checkbox_checked_dark.png"
local kDisabledCheckImageDark = "rbxasset://textures/DeveloperFramework/checkbox_indeterminate_dark.png"
local kHoverCheckImageDark = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_hover_dark.png"
local kCheckboxFrameImageDark = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_dark.png"

LabeledCheckboxClass = {}
LabeledCheckboxClass.__index = LabeledCheckboxClass

LabeledCheckboxClass.kMinFrameSize = UDim2.new(0, kMinLabelWidth + kMinMargin + kMinButtonWidth, 0, kMinHeight)


function LabeledCheckboxClass.new(nameSuffix, labelText, initValue, initDisabled)
	local self = {}
	setmetatable(self, LabeledCheckboxClass)

	local initValue = not not initValue
	local initDisabled = not not initDisabled

	local frame = GuiUtilities.MakeDefaultFixedHeightFrame("CBF" .. nameSuffix)

	local fullBackgroundButton = Instance.new("TextButton")
	fullBackgroundButton.Name = "FullBackground"
	fullBackgroundButton.Parent = frame
	fullBackgroundButton.BackgroundTransparency = 1
	fullBackgroundButton.Size = UDim2.new(1, 0, 1, 0)
	fullBackgroundButton.Position = UDim2.new(0, 0, 0, 0)
	fullBackgroundButton.Text = ""

	local label = GuiUtilities.MakeDefaultPropertyLabel(labelText, true)
	label.Parent = fullBackgroundButton

	local button = Instance.new('ImageButton')
	button.Name = 'Button'
	button.Size = UDim2.new(0, kCheckboxWidth, 0, kCheckboxWidth)
	button.AnchorPoint = Vector2.new(0, .5)
	button.BackgroundTransparency = 1
	button.Position = UDim2.new(0, GuiUtilities.DefaultLineElementLeftMargin, .5, 0)
	button.Parent = fullBackgroundButton
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	
	local checkImage = Instance.new("ImageLabel")
	checkImage.Name = "CheckImage"
	checkImage.Parent = button
	checkImage.Visible = false
	checkImage.Size = kCheckImageSize
	checkImage.AnchorPoint = Vector2.new(0.5, 0.5)
	checkImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	checkImage.BackgroundTransparency = 1
	checkImage.BorderSizePixel = 0

	self._frame = frame
	self._button = button
	self._label = label

	self._clicked = false
	self._hovered = false

	self._checkImage = checkImage
	self._fullBackgroundButton = fullBackgroundButton
	self._useDisabledOverride = false
	self._disabledOverride = false
	self:SetDisabled(initDisabled)

	self._value = not initValue
	self:SetValue(initValue)

	self:_SetupMouseClickHandling()

	local function updateImages()
		if (GuiUtilities:ShouldUseIconsForDarkerBackgrounds()) then
			self._button.Image = kCheckboxFrameImageDark
			if self._checkImage.Image == kDisabledCheckImage then
				self._checkImage.Image = kDisabledCheckImageDark
			else
				self._checkImage.Image = kEnabledCheckImageDark
			end
		else
			self._button.Image = kCheckboxFrameImage
			if self._checkImage.Image == kDisabledCheckImageDark then
				self._checkImage.Image = kDisabledCheckImage
			else
				self._checkImage.Image = kEnabledCheckImage
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

function LabeledCheckboxClass:_MaybeToggleState()
	if not self._disabled then
		self:SetValue(not self._value)
	end
end

function LabeledCheckboxClass:_SetupMouseClickHandling()
	self._button.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_MaybeToggleState()
	end)

	self._fullBackgroundButton.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			self._hovered = true
			self:_updateCheckboxVisual()
		end
	end)

	self._fullBackgroundButton.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			self._hovered = false
			self._clicked = false
			self:_updateCheckboxVisual()
		end
	end)

	self._fullBackgroundButton.MouseButton1Down:Connect(function()
		self._clicked = true
		self:_updateCheckboxVisual()
		self:_MaybeToggleState()
	end)
end

-- Too buggy with other GuiObjects to be used.
function LabeledCheckboxClass:_updateCheckboxVisual()
	-- if (self._clicked) then 
	-- 	self._button.Image = kCheckboxFrameImage
	-- elseif (self._hovered) then 
	-- 	self._button.Image = kHoverCheckImage
	-- else
	-- 	self._button.Image = kCheckboxFrameImage
	-- end
end

function LabeledCheckboxClass:_HandleUpdatedValue()
	self._checkImage.Visible = self:GetValue()

	if (self._valueChangedFunction) then 
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

	self._frame.Size = LabeledCheckboxClass.kMinFrameSize
	self._frame.BackgroundTransparency = 1
end

function LabeledCheckboxClass:GetFrame()
	return self._frame
end

function LabeledCheckboxClass:GetValue()
	-- If button is disabled, and we should be using a disabled override, 
	-- use the disabled override.
	if (self._disabled and self._useDisabledOverride) then 
		return self._disabledOverride
	else
		return self._value
	end
end

function LabeledCheckboxClass:GetLabel()
	return self._label
end

function LabeledCheckboxClass:GetButton()
	return self._button
end

function LabeledCheckboxClass:SetValueChangedFunction(vcFunction) 
	self._valueChangedFunction = vcFunction
end

function LabeledCheckboxClass:SetDisabled(newDisabled)
	local newDisabled = not not newDisabled

	local originalValue = self:GetValue()

	if newDisabled ~= self._disabled then
		self._disabled = newDisabled

		-- if we are no longer disabled, then we don't need or want 
		-- the override any more.  Forget it.
		if (not self._disabled) then 
			self._useDisabledOverride = false
		end

		if (newDisabled) then 
			if (GuiUtilities:ShouldUseIconsForDarkerBackgrounds()) then
				self._checkImage.Image = kDisabledCheckImageDark
			else
				self._checkImage.Image = kDisabledCheckImage
			end
		else
			if (GuiUtilities:ShouldUseIconsForDarkerBackgrounds()) then
				self._checkImage.Image = kEnabledCheckImageDark
			else
				self._checkImage.Image = kEnabledCheckImage
			end
		end

		self:UpdateFontColors()
		self._button.BackgroundColor3 = self._disabled and GuiUtilities.kButtonDisabledBackgroundColor or GuiUtilities.kButtonDefaultBackgroundColor
		self._button.BorderColor3 = self._disabled and GuiUtilities.kButtonDisabledBorderColor or GuiUtilities.kButtonDefaultBorderColor
		if self._disabledChangedFunction then
			self._disabledChangedFunction(self._disabled)
		end
	end

	local newValue = self:GetValue()
	if (newValue ~= originalValue) then 
		self:_HandleUpdatedValue()
	end
end

function LabeledCheckboxClass:UpdateFontColors()
	if self._disabled then 
		self._label.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.DimmedText)
	else
		self._label.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
end

function LabeledCheckboxClass:DisableWithOverrideValue(overrideValue)
	-- Disable this checkbox.  While disabled, force value to override
	-- value.
	local oldValue = self:GetValue()
	self._useDisabledOverride = true
	self._disabledOverride = overrideValue
	self:SetDisabled(true)
	local newValue = self:GetValue()
	if (oldValue ~= newValue) then 
		self:_HandleUpdatedValue()
	end		
end

function LabeledCheckboxClass:GetDisabled()
	return self._disabled
end

function LabeledCheckboxClass:SetValue(newValue)
	local newValue = not not newValue
	
	if newValue ~= self._value then
		self._value = newValue

		self:_HandleUpdatedValue()
	end
end

return LabeledCheckboxClass