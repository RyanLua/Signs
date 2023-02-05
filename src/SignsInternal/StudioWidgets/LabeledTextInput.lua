----------------------------------------
--
-- LabeledTextInput.lua
--
-- Creates a frame containing a label and a text input control.
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)

local kTextInputWidth = 100
local kTextInputHeight = 22
local kTextBoxInternalPadding = 3

LabeledTextInputClass = {}
LabeledTextInputClass.__index = LabeledTextInputClass

function LabeledTextInputClass.new(nameSuffix, labelText, defaultValue)
	local self = {}
	setmetatable(self, LabeledTextInputClass)

	-- Note: we are using "graphemes" instead of characters.
	-- In modern text-manipulation-fu, what with internationalization, 
	-- emojis, etc, it's not enough to count characters, particularly when 
	-- concerned with "how many <things> am I rendering?".
	-- We are using the 
	self._MaxGraphemes = 10
	
	self._valueChangedFunction = nil

	local defaultValue = defaultValue or ""

	local frame = GuiUtilities.MakeDefaultFixedHeightFrame('TextInput ' .. nameSuffix)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	self._frame = frame

	local label = GuiUtilities.MakeDefaultPropertyLabel(labelText)
	label.Parent = frame
	self._label = label

	self._value = defaultValue

	local textBoxBorder = Instance.new("ImageLabel")
	textBoxBorder.Name = "TextBox"
	textBoxBorder.Size = UDim2.new(1, -GuiUtilities.DefaultRightMargin, 0, GuiUtilities.kTextInputHeight)
	textBoxBorder.Position = UDim2.new(0, GuiUtilities.DefaultLineElementLeftMargin, 0, kTextBoxInternalPadding)
	textBoxBorder.AnchorPoint = Vector2.new(0, 0)
	textBoxBorder.BackgroundTransparency = 1
	textBoxBorder.Image = "rbxasset://textures/DeveloperFramework/checkbox_unchecked_dark.png"
	textBoxBorder.ScaleType = Enum.ScaleType.Slice
	textBoxBorder.SliceCenter = Rect.new(3, 3, 13, 13)
	-- textBoxBorder.ImageColor3 = GuiUtilities.kDefaultBorderColor
	textBoxBorder.AutomaticSize = Enum.AutomaticSize.Y
	textBoxBorder.Parent = frame
	-- GuiUtilities.syncGuiImageBorderColor(textBoxBorder)

	-- Dumb hack to add padding to text box,
	local textBoxWrapperFrame = Instance.new("Frame")
	textBoxWrapperFrame.Name = "TextBoxFrame"
	textBoxWrapperFrame.Size = UDim2.new(1, 0, 0, kTextInputHeight)
	textBoxWrapperFrame.BorderSizePixel = 0
	textBoxWrapperFrame.AnchorPoint = Vector2.new(0, 0)
	textBoxWrapperFrame.Position = UDim2.new(0, 0, 0, 1)
	textBoxWrapperFrame.AutomaticSize = Enum.AutomaticSize.Y
	textBoxWrapperFrame.BackgroundTransparency = 1
	textBoxWrapperFrame.Parent = textBoxBorder
	GuiUtilities.syncGuiElementInputFieldColor(textBoxWrapperFrame)

	local textBox = Instance.new("TextBox")
	textBox.Parent = textBoxWrapperFrame
	textBox.Name = "TextBox"
	textBox.ClearTextOnFocus = false
	textBox.MultiLine = true
	textBox.Text = ""
	textBox.PlaceholderText = defaultValue
	textBox.Font = GuiUtilities.kDefaultFontFace
	textBox.TextSize = GuiUtilities.kDefaultFontSize
	textBox.TextWrapped = true
	textBox.BackgroundTransparency = 1
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.TextYAlignment = Enum.TextYAlignment.Center
	textBox.Size = UDim2.new(1, -kTextBoxInternalPadding, 0, GuiUtilities.kTextVerticalFudge)
	textBox.Position = UDim2.new(0, kTextBoxInternalPadding, 0, kTextBoxInternalPadding)
	textBox.AutomaticSize = Enum.AutomaticSize.Y
	textBox.ClipsDescendants = true
	GuiUtilities.syncGuiElementFontColor(textBox)
	
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
					self._textBox.Text = string.sub(self._textBox.Text, 1, start-1)
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
	
	self._textBox = textBox

	return self
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
