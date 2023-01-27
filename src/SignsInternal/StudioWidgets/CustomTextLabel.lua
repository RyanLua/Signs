----------------------------------------
--
-- CustomTextButton.lua
--
-- Custom text button class which can be used in any gui.
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)

CustomTextLabelClass = {}
CustomTextLabelClass.__index = CustomTextLabelClass

function CustomTextLabelClass.new(nameSuffix, height)
	local self = {}
	setmetatable(self, CustomTextLabelClass)

	local frame = GuiUtilities.MakeFixedHeightFrame('TextLabel ' .. nameSuffix, height)
	frame.BorderSizePixel = 1
	frame.Size = UDim2.new(1, 0, 0, height)
	GuiUtilities.syncGuiElementShadowColor(frame)

	local label = Instance.new('TextLabel')
	label.Text = "Preview"
	label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	if (GuiUtilities:ShouldUseIconsForDarkerBackgrounds()) then
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Font = GuiUtilities.kDefaultFontFace
	label.TextSize = GuiUtilities.kDefaultFontSize
	label.TextWrapped = true
	label.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Enabled = false
	stroke.Color = Color3.fromRGB(255, 255, 255)
	if (GuiUtilities:ShouldUseIconsForDarkerBackgrounds()) then
		stroke.Color = Color3.fromRGB(0, 0, 0)
	end
	stroke.Parent = label

	function CustomTextLabelClass:UpdateText(newValue: string)
		label.Text = newValue
	end
	
	function CustomTextLabelClass:UpdateTextTransparency(newValue: number)
		label.TextTransparency = newValue
	end

	function CustomTextLabelClass:UpdateTextSize(newValue: number)
		label.TextSize = newValue
	end

	function CustomTextLabelClass:UpdateLineHeight(newValue: number)
		label.LineHeight = newValue
	end

	function CustomTextLabelClass:UpdateRichText(newValue: boolean)
		label.RichText = newValue
	end

	function CustomTextLabelClass:UpdateTextScaled(newValue: boolean)
		label.TextScaled = newValue
	end

	function CustomTextLabelClass:UpdateTextWrapped(newValue: boolean)
		label.TextWrapped = newValue
	end

	function CustomTextLabelClass:UpdateTextColor3(newValue: Color3)
		label.TextColor3 = newValue
	end

	function CustomTextLabelClass:UpdateFontFaceBold(newValue: boolean)
		local font = label.FontFace.Family
		local italic = label.FontFace.Style

		if newValue == true then
			label.FontFace = Font.new(font, Enum.FontWeight.Bold, italic)
		else
			label.FontFace = Font.new(font, Enum.FontWeight.Regular, italic)
		end
	end

	function CustomTextLabelClass:UpdateFontFaceItalic(newValue: boolean)
		local font = label.FontFace.Family

		local bold = label.FontFace.Bold
		if bold == true then
			bold = Enum.FontWeight.Bold
		else
			bold = Enum.FontWeight.Regular
		end

		if newValue == true then
			label.FontFace = Font.new(font, bold, Enum.FontStyle.Italic)
		else
			label.FontFace = Font.new(font, bold, Enum.FontStyle.Normal)
		end
	end

	function CustomTextLabelClass:UpdateFontFace(newValue: Font)
		label.FontFace = newValue
	end

	function CustomTextLabelClass:UpdateVerticalAlignment(newValue: Enum.VerticalAlignment)
		label.TextYAlignment = newValue
	end

	function CustomTextLabelClass:UpdateHorizontalAlignment(newValue: Enum.HorizontalAlignment)
		label.TextXAlignment = newValue
	end

	-- function CustomTextLabelClass:UpdateTextStrokeTransparency(newValue: number)
	-- 	label.TextStrokeTransparency = newValue
	-- end

	-- function CustomTextLabelClass:UpdateTextStrokeColor3(newValue: Color3)
	-- 	label.TextStrokeColor3 = newValue
	-- end

	function CustomTextLabelClass:UpdateStroke(newValue: boolean)
		stroke.Enabled = newValue
	end

	function CustomTextLabelClass:UpdateStrokeTransparency(newValue: number)
		stroke.Transparency = newValue
	end

	function CustomTextLabelClass:UpdateStrokeColor(newValue: Color3)
		stroke.Color = newValue
	end

	function CustomTextLabelClass:UpdateStrokeJoin(newValue: Enum.LineJoinMode)
		stroke.LineJoinMode = newValue
	end

	function CustomTextLabelClass:UpdateStrokeThickness(newValue: number)
		stroke.Thickness = newValue
	end

	function CustomTextLabelClass:UpdateBackgroundTransparency(newValue: number)
		label.BackgroundTransparency = newValue
	end

	function CustomTextLabelClass:UpdateBackgroundColor3(newValue: Color3)
		label.BackgroundColor3 = newValue
	end

	function CustomTextLabelClass:GetLabel()
		return label
	end

	function CustomTextLabelClass:GetFrame()
		return frame
	end

	self._frame = frame
	self._label = label

	return self
end


return CustomTextLabelClass