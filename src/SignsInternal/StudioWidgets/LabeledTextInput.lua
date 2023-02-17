----------------------------------------
--
-- LabeledTextInput.lua
--
-- Creates a frame containing a label and a text input control.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local kTextBoxInternalPadding = 8

local LabeledTextInputClass = {}
LabeledTextInputClass.__index = LabeledTextInputClass

function LabeledTextInputClass.new(nameSuffix, labelText, defaultValue, url)
	local self = {}
	setmetatable(self, LabeledTextInputClass)

	-- Note: we are using "graphemes" instead of characters.
	-- In modern text-manipulation-fu, what with internationalization,
	-- emojis, etc, it's not enough to count characters, particularly when
	-- concerned with "how many <things> am I rendering?".
	-- We are using the
	self._MaxGraphemes = 10

	self._valueChangedFunction = nil

	local value = defaultValue or ""

	local frame = GuiUtilities.MakeDefaultFixedHeightFrame("TextInput " .. nameSuffix)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	self._frame = frame

	local label = GuiUtilities.MakeDefaultPropertyLabel(labelText, false, url)
	label.Parent = frame
	self._label = label

	self._value = value

	local textBoxBorder = Instance.new("ImageLabel")
	textBoxBorder.Name = "TextBoxBorder"
	textBoxBorder.Size = UDim2.new(1, -GuiUtilities.DefaultRightMargin, 0, GuiUtilities.kTextInputHeight)
	textBoxBorder.Position = UDim2.new(0, GuiUtilities.DefaultLineElementLeftMargin, 0, 4)
	textBoxBorder.AnchorPoint = Vector2.new(0, 0)
	textBoxBorder.BackgroundTransparency = 1
	textBoxBorder.ScaleType = Enum.ScaleType.Slice
	textBoxBorder.SliceCenter = Rect.new(3, 3, 13, 13)
	textBoxBorder.Image = "rbxasset://textures/StudioToolbox/RoundedBorder.png"
	-- textBoxBorder.ImageColor3 = GuiUtilities.kDefaultBorderColor
	textBoxBorder.AutomaticSize = Enum.AutomaticSize.Y
	textBoxBorder.ZIndex = 2
	textBoxBorder.Parent = frame
	GuiUtilities.syncGuiInputFieldBorderColor(textBoxBorder)
	self._textBoxBorder = textBoxBorder

	-- Dumb hack to add padding to text box,
	local textBoxBackground = Instance.new("ImageLabel")
	textBoxBackground.Name = "TextBoxFrame"
	textBoxBackground.Size = UDim2.new(1, 0, 0, GuiUtilities.kTextInputHeight)
	textBoxBackground.BorderSizePixel = 0
	textBoxBackground.Image = "rbxasset://textures/StudioToolbox/RoundedBackground.png"
	textBoxBackground.AnchorPoint = Vector2.new(0, 0)
	textBoxBackground.Position = UDim2.new(0, 0, 0, 0)
	textBoxBackground.ScaleType = Enum.ScaleType.Slice
	textBoxBackground.SliceCenter = Rect.new(3, 3, 13, 13)
	textBoxBackground.AutomaticSize = Enum.AutomaticSize.Y
	textBoxBackground.BackgroundTransparency = 1
	textBoxBackground.Parent = textBoxBorder
	GuiUtilities.syncGuiInputFieldBackgroundColor(textBoxBackground)
	self._textBoxBackground = textBoxBackground

	local textBox = Instance.new("TextBox")
	textBox.Parent = textBoxBackground
	textBox.Name = "TextBox"
	textBox.ClearTextOnFocus = false
	textBox.MultiLine = true
	textBox.Text = ""
	textBox.PlaceholderText = value
	textBox.Font = GuiUtilities.kDefaultFontFace
	textBox.TextSize = GuiUtilities.kDefaultFontSize
	textBox.TextWrapped = true
	textBox.BackgroundTransparency = 1
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.TextYAlignment = Enum.TextYAlignment.Center
	textBox.AnchorPoint = Vector2.new(0.5, 0)
	textBox.Size = UDim2.new(1, -kTextBoxInternalPadding, 0, GuiUtilities.kTextInputHeight)
	textBox.Position = UDim2.new(0.5, 0, 0, 0)
	textBox.AutomaticSize = Enum.AutomaticSize.Y
	textBox.ClipsDescendants = true
	GuiUtilities.syncGuiElementPlaceholderColor(textBox)
	GuiUtilities.syncGuiElementFontColor(textBox)
	self._textBox = textBox

	textBox:GetPropertyChangedSignal("Text"):Connect(function()
		-- Never let the text be too long.
		-- Careful here: we want to measure number of graphemes, not characters,
		-- in the text, and we want to clamp on graphemes as well.
		if utf8.len(self._textBox.Text) > self._MaxGraphemes then
			local count = 0
			for start, stop in utf8.graphemes(self._textBox.Text) do
				count = count + 1
				if count > self._MaxGraphemes then
					-- We have gone one too far.
					-- clamp just before the beginning of this grapheme.
					self._textBox.Text = string.sub(self._textBox.Text, 1, start - 1)
					break
				end
			end
			-- Don't continue with rest of function: the resetting of "Text" field
			-- above will trigger re-entry.  We don't need to trigger value
			-- changed function twice.
			return
		end

		self._value = self._textBox.Text
		if self._valueChangedFunction then
			self._valueChangedFunction(self._value)
		end
	end)

	self._selected = false

	self:_SetupMouseClickHandling()
	self:_updateInputVisual()

	return self
end

function LabeledTextInputClass:_SetupMouseClickHandling()
	self._textBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self._selected = true
			self:_updateInputVisual()
		end
	end)

	self._textBox.Focused:Connect(function()
		self._selected = true
		self:_updateInputVisual()
	end)

	self._textBox.FocusLost:Connect(function()
		self._selected = false
		self:_updateInputVisual()
	end)

	self._textBox.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self._selected = false
			self:_updateInputVisual()
		end
	end)
end

function LabeledTextInputClass:_updateInputVisual()
	if self._selected then
		self._textBoxBorder.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.CheckedFieldBackground,
			Enum.StudioStyleGuideModifier.Selected
		)
		self._textBoxBackground.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.InputFieldBackground,
			Enum.StudioStyleGuideModifier.Selected
		)
	else
		self._textBoxBorder.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.InputFieldBorder,
			Enum.StudioStyleGuideModifier.Default
		)
		self._textBoxBackground.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.InputFieldBackground,
			Enum.StudioStyleGuideModifier.Default
		)
	end
end

function LabeledTextInputClass:UseSmallSize()
	self._textBoxBorder.AutomaticSize = Enum.AutomaticSize.None
	self._textBoxBorder.Size = UDim2.new(0, GuiUtilities.kTextInputWidth, 0, GuiUtilities.kTextInputHeight)
	self._textBox.TextXAlignment = Enum.TextXAlignment.Center
	self._textBox.TextYAlignment = Enum.TextYAlignment.Center
	self._textBox.ClearTextOnFocus = true
	self._textBox.MultiLine = false
end

function LabeledTextInputClass:SetValueChangedFunction(vcf)
	self._valueChangedFunction = vcf
end

function LabeledTextInputClass:GetFrame()
	return self._frame
end

function LabeledTextInputClass:GetValue()
	return self._value
end

function LabeledTextInputClass:GetMaxGraphemes()
	return self._MaxGraphemes
end

function LabeledTextInputClass:SetMaxGraphemes(newValue)
	self._MaxGraphemes = newValue
end

function LabeledTextInputClass:SetValue(newValue)
	if self._value ~= newValue then
		self._textBox.Text = newValue
	end
end

return LabeledTextInputClass
