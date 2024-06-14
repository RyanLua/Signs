----------------------------------------
--
-- LabeledTextInput.luau
--
-- Creates a frame containing a label and a text input control.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)
local CollapsibleItem = require(script.Parent.CollapsibleItem)

local kTextBoxInternalPadding = 8

local kTextBoxBackgroundImage = "rbxasset://textures/StudioToolbox/RoundedBackground.png"
local kTextBoxBorderImage = "rbxasset://textures/StudioToolbox/RoundedBorder.png"

local LabeledTextInputClass = {}
LabeledTextInputClass.__index = LabeledTextInputClass

-- Creates a new LabeledTextInputClass
function LabeledTextInputClass.new(nameSuffix: string, labelText: string, defaultValue: string, url: string)
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

	local item = CollapsibleItem.new(nameSuffix, labelText, false, url)
	item.AutomaticSize = Enum.AutomaticSize.Y
	self._item = item
	self._frame = item:GetFrame()
	self._label = item:GetLabel()

	self._value = value

	local textBoxBorder = Instance.new("ImageLabel")
	textBoxBorder.Name = "TextBoxBorder"
	textBoxBorder.Size = UDim2.new(0.5, -GuiUtilities.kTextInputPadding * 2, 0, GuiUtilities.kTextInputHeight)
	textBoxBorder.Position = UDim2.new(0.5, GuiUtilities.kTextInputPadding, 0, 4)
	textBoxBorder.AnchorPoint = Vector2.new(0, 0)
	textBoxBorder.BackgroundTransparency = 1
	textBoxBorder.ScaleType = Enum.ScaleType.Slice
	textBoxBorder.SliceCenter = Rect.new(3, 3, 13, 13)
	textBoxBorder.Image = kTextBoxBorderImage
	textBoxBorder.AutomaticSize = Enum.AutomaticSize.Y
	textBoxBorder.ZIndex = 2
	textBoxBorder.Parent = item:GetFrame()
	GuiUtilities.syncGuiInputFieldBorderColor(textBoxBorder)
	self._textBoxBorder = textBoxBorder

	-- Dumb hack to add padding to text box,
	local textBoxBackground = Instance.new("ImageLabel")
	textBoxBackground.Name = "TextBoxFrame"
	textBoxBackground.Size = UDim2.new(1, 0, 0, GuiUtilities.kTextInputHeight)
	textBoxBackground.BorderSizePixel = 0
	textBoxBackground.Image = kTextBoxBackgroundImage
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
			for start, _ in utf8.graphemes(self._textBox.Text) do
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
	self:_UpdateVisualState()

	return self
end

-- Setup mouse click handling for the text box
function LabeledTextInputClass:_SetupMouseClickHandling()
	self._frame.MouseButton1Click:Connect(function()
		self._textBox:CaptureFocus()
	end)

	self._textBox.InputBegan:Connect(function()
		self._hovered = true
		self:_UpdateVisualState()
	end)

	self._textBox.Focused:Connect(function()
		self._selected = true
		self:_UpdateVisualState()
	end)

	self._textBox.FocusLost:Connect(function()
		self._selected = false
		self:_UpdateVisualState()
	end)

	self._textBox.InputEnded:Connect(function()
		self._hovered = false
		self:_UpdateVisualState()
	end)

	-- If textBox is focused, then select item.
	self._textBox.Focused:Connect(function()
		if self._textBox.Focused then
			self._item:SetValue(true)
			self:_UpdateVisualState()
		else
			self._item:SetValue(false)
			self:_UpdateVisualState()
		end
	end)
end

-- Update the visual state of the input field
function LabeledTextInputClass:_UpdateVisualState()
	if self._selected then
		self._textBoxBorder.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.CheckedFieldBackground,
			Enum.StudioStyleGuideModifier.Selected
		)
		self._textBoxBackground.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.InputFieldBackground,
			Enum.StudioStyleGuideModifier.Selected
		)
	elseif self._hovered then
		self._textBoxBorder.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.InputFieldBorder,
			Enum.StudioStyleGuideModifier.Hover
		)
		self._textBoxBackground.ImageColor3 = settings().Studio.Theme:GetColor(
			Enum.StudioStyleGuideColor.InputFieldBackground,
			Enum.StudioStyleGuideModifier.Default
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

-- Use the small size for the text box
function LabeledTextInputClass:UseSmallSize()
	self._textBoxBorder.AutomaticSize = Enum.AutomaticSize.None
	self._textBoxBorder.Size = UDim2.new(0, GuiUtilities.kTextInputWidth, 0, GuiUtilities.kTextInputHeight)
	self._textBox.TextXAlignment = Enum.TextXAlignment.Center
	self._textBox.TextYAlignment = Enum.TextYAlignment.Center
	self._textBox.ClearTextOnFocus = true
	self._textBox.MultiLine = false

	self._textBox:GetPropertyChangedSignal("Text"):Connect(function()
		for i = 1, #self._textBox.Text do
			local char = string.sub(self._textBox.Text, i, i)
			if not (char >= "0" and char <= "9") and char ~= "." then
				self._textBox.Text = string.sub(self._textBox.Text, 1, i - 1) .. string.sub(self._textBox.Text, i + 1)
			end
		end
	end)
end

-- Set the value changed function
function LabeledTextInputClass:SetValueChangedFunction(vcf)
	self._valueChangedFunction = vcf
end

-- Get the frame that contains the text box
function LabeledTextInputClass:GetFrame(): Frame
	return self._frame
end

-- Get the value of the text box
function LabeledTextInputClass:GetValue(): number
	return self._value
end

-- Get the maximum number of graphemes allowed in the text box
function LabeledTextInputClass:GetMaxGraphemes(): number
	return self._MaxGraphemes
end

-- Set the maximum number of graphemes allowed in the text box
function LabeledTextInputClass:SetMaxGraphemes(newValue)
	self._MaxGraphemes = newValue
end

-- Set the value of the text box
function LabeledTextInputClass:SetValue(newValue)
	if self._value ~= newValue then
		self._textBox.Text = newValue
	end
end

return LabeledTextInputClass
