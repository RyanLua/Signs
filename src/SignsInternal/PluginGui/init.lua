local targetFolder = script.Parent.StudioWidgets

local CollapsibleTitledSection = require(targetFolder.CollapsibleTitledSection)
local CustomTextButton = require(targetFolder.CustomTextButton)
local CustomTextLabel = require(targetFolder.CustomTextLabel)
local GuiUtilities = require(targetFolder.GuiUtilities)
local LabeledCheckbox = require(targetFolder.LabeledCheckbox)
local LabeledMultiChoice = require(targetFolder.LabeledMultiChoice)
local LabeledSlider = require(targetFolder.LabeledSlider)
local LabeledTextInput = require(targetFolder.LabeledTextInput)
local ScrollingFrame = require(targetFolder.VerticalScrollingFrame)
local VerticallyScalingListFrame = require(targetFolder.VerticallyScalingListFrame)

local Color = require(script.Color)
local FontFace = require(script.FontFace)
local GuiObjectPart = require(script.GuiObjectPart)
local LineJoinMode = require(script.LineJoinMode)
local TextXAlignment = require(script.TextXAlignment)
local TextYAlignment = require(script.TextYAlignment)

local PluginGui = {}

function PluginGui:newPluginGui(widgetGui)
	local scrollFrame = ScrollingFrame.new("scrollFrame")

	local listFrame = VerticallyScalingListFrame.new( -- Scrolling frame
		"listFrame" -- name suffix of gui object
	)

	local previewLabel = CustomTextLabel.new("Preview", 150)
	previewLabel:GetFrame().Parent = scrollFrame:GetContentsFrame()

	local insertButton = CustomTextButton.new( -- Insert button
		"insertButton", -- name of the gui object
		"Insert" -- the text displayed on the button
	)
	local buttonObject = insertButton:GetButton()
	buttonObject.Size = UDim2.new(1, -10, 0, 50)
	buttonObject.Parent = scrollFrame:GetContentsFrame()

	local textCollapse = CollapsibleTitledSection.new( -- Text collapse
		"textCollapse", -- name suffix of the gui object
		"Text", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		false -- minimized by default?
	)
	listFrame:AddChild(textCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local textInput = LabeledTextInput.new( -- Asks user for text
		"textInput", -- name suffix of gui object
		"Text", -- title text of the multi choice
		"Text here" -- default value
	)
	textInput:SetMaxGraphemes(8192)
	textInput:GetFrame().Parent = textCollapse:GetContentsFrame()

	local transparencyTextSlider = LabeledSlider.new( -- Size Slider
		"transparencyTextSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		1 -- the starting value of the slider
	)
	transparencyTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()

	local rotationTextSlider = LabeledSlider.new( -- Rotation Slider
		"rotationSlider", -- name suffix of gui object
		"Text Rotation", -- title text of the multi choice
		13, -- how many intervals to split the slider into
		1 -- the starting value of the slider
	)
	rotationTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()

	local sizeTextSlider = LabeledSlider.new( -- Size Slider
		"sizeSlider", -- name suffix of gui object
		"Text Size", -- title text of the multi choice
		21, -- how many intervals to split the slider into
		4 -- the starting value of the slider
	)
	sizeTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()

	local heightTextSlider = LabeledSlider.new( -- Line height slider. Intended for onlt paid supporters.
		"heightSlider", -- name suffix of gui object
		"Line Height", -- title text of the multi choice
		5, -- how many intervals to split the slider into
		3 -- the starting value of the slider
	)
	heightTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()

	local markupCheckbox = LabeledCheckbox.new(
		"markupCheckbox", -- name suffix of gui object
		"Rich Text", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	markupCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()

	local scaledCheckbox = LabeledCheckbox.new(
		"scaledCheckbox", -- name suffix of gui object
		"Text Scaled", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	scaledCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()

	local wrappedCheckbox = LabeledCheckbox.new(
		"wrappedCheckbox", -- name suffix of gui object
		"Text Wrapped", -- text beside the checkbox
		true, -- initial value
		false -- initially disabled?
	)
	wrappedCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()

	local fontCollapse = CollapsibleTitledSection.new( -- Fonts collapse
		"fontCollapse", -- name suffix of the gui object
		"Font", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	listFrame:AddChild(fontCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local boldCheckbox = LabeledCheckbox.new(
		"boldCheckbox", -- name suffix of gui object
		"Bold", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	boldCheckbox:GetFrame().Parent = fontCollapse:GetContentsFrame()

	local italicCheckbox = LabeledCheckbox.new(
		"italicCheckbox", -- name suffix of gui object
		"Italic", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	italicCheckbox:GetFrame().Parent = fontCollapse:GetContentsFrame()

	local colorTextChoice = LabeledMultiChoice.new(
		"colorSelection", -- name suffix of gui object
		"Text Color", -- title text of the multi choice
		Color, -- choices array
		11 -- the starting index of the selection
	)
	if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
		colorTextChoice:SetSelectedIndex(1)
	end
	colorTextChoice:GetFrame().Parent = fontCollapse:GetContentsFrame()

	local fontTextChoice =
		LabeledMultiChoice.new( -- Basically in beta thingy for fonts. New system prob done by another PluginGui soon. This will suffice.
			"fontTextChoice", -- name suffix of gui object
			"Font Face", -- title text of the multi choice
			FontFace, -- choices array
			32 -- the starting index of the selection
		)
	fontTextChoice:GetFrame().Parent = fontCollapse:GetContentsFrame()

	local alignmentCollapse = CollapsibleTitledSection.new( -- Fonts collapse
		"alignmentCollapse", -- name suffix of the gui object
		"Alignment", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	listFrame:AddChild(alignmentCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local yChoice = LabeledMultiChoice.new(
		"yChoice", -- name suffix of gui object
		"Horizontal Alignment", -- title text of the multi choice
		TextYAlignment, -- choices array
		2 -- the starting index of the selection
	)
	yChoice:GetFrame().Parent = alignmentCollapse:GetContentsFrame()

	local xChoice = LabeledMultiChoice.new(
		"xChoice", -- name suffix of gui object
		"Vertical Alignment", -- title text of the multi choice
		TextXAlignment, -- choices array
		2 -- the starting index of the selection
	)
	xChoice:GetFrame().Parent = alignmentCollapse:GetContentsFrame()

	local strokeCollapse = CollapsibleTitledSection.new( -- Fonts collapse
		"strokeCollapse", -- name suffix of the gui object
		"Stroke", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	listFrame:AddChild(strokeCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local strokeCheckbox = LabeledCheckbox.new(
		"strokeCheckbox", -- name suffix of gui object
		"Enabled", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	strokeCheckbox:GetFrame().Parent = strokeCollapse:GetContentsFrame()

	local thicknessStrokeSlider = LabeledSlider.new( -- Size Slider
		"thicknessStrokeSlider", -- name suffix of gui object
		"Thickness", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		2 -- the starting value of the slider
	)
	thicknessStrokeSlider:GetFrame().Parent = strokeCollapse:GetContentsFrame()

	local transparencyStrokeSlider = LabeledSlider.new( -- Size Slider
		"transparencyStrokeSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		1 -- the starting value of the slider
	)
	transparencyStrokeSlider:GetFrame().Parent = strokeCollapse:GetContentsFrame()

	local joinStrokeChoice = LabeledMultiChoice.new(
		"joinStrokeChoice", -- name suffix of gui object
		"Line Join Mode", -- title text of the multi choice
		LineJoinMode, -- choices array
		1 -- the starting index of the selection
	)
	joinStrokeChoice:GetFrame().Parent = strokeCollapse:GetContentsFrame()

	local colorStrokeChoice = LabeledMultiChoice.new(
		"colorStrokeChoice", -- name suffix of gui object
		"Color", -- title text of the multi choice
		Color, -- choices array
		11 -- the starting index of the selection
	)
	if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() == true then
		colorStrokeChoice:SetSelectedIndex(11)
	end
	colorStrokeChoice:GetFrame().Parent = strokeCollapse:GetContentsFrame()

	local backgroundCollapse = CollapsibleTitledSection.new( -- Fonts collapse
		"backgroundCollapse", -- name suffix of the gui object
		"Background", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	listFrame:AddChild(backgroundCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local transparencyBackgroundSlider = LabeledSlider.new( -- Size Slider
		"transparencyBackgroundSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		11 -- the starting value of the slider
	)
	transparencyBackgroundSlider:GetFrame().Parent = backgroundCollapse:GetContentsFrame()

	local colorBackgroundChoice = LabeledMultiChoice.new(
		"colorBackgroundSelection", -- name suffix of gui object
		"Background Color", -- title text of the multi choice
		Color, -- choices array
		1 -- the starting index of the selection
	)
	colorBackgroundChoice:GetFrame().Parent = backgroundCollapse:GetContentsFrame()

	local surfaceCollapse = CollapsibleTitledSection.new( -- Fonts collapse
		"surfaceCollapse", -- name suffix of the gui object
		"Other", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	listFrame:AddChild(surfaceCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local influenceSlider = LabeledSlider.new( -- Size Slider
		"influenceSlider", -- name suffix of gui object
		"Light Influence", -- title text of the multi choice
		5, -- how many intervals to split the slider into
		1 -- the starting value of the slider
	)
	influenceSlider:GetFrame().Parent = surfaceCollapse:GetContentsFrame()

	local topCheckbox = LabeledCheckbox.new(
		"topCheckbox", -- name suffix of gui object
		"Always On Top", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	topCheckbox:GetFrame().Parent = surfaceCollapse:GetContentsFrame()

	local localizeCheckbox = LabeledCheckbox.new(
		"localizeCheckbox", -- name suffix of gui object
		"Auto Localize", -- text beside the checkbox
		true, -- initial value
		false -- initially disabled?
	)
	localizeCheckbox:GetFrame().Parent = surfaceCollapse:GetContentsFrame()

	--listFrame:AddBottomPadding() -- add padding to VerticallyScalingListFrame

	listFrame:GetFrame().Parent = scrollFrame:GetContentsFrame() -- scroll content will be the VerticallyScalingListFrame
	scrollFrame:GetSectionFrame().Parent = widgetGui -- set the section parent

	-- Below is utter hell. There is no workaround, only pain.

	insertButton:GetButton().MouseButton1Click:Connect(function()
		local label = CustomTextLabel:GetLabel()
		local influence = ((influenceSlider:GetValue() - 1) / 4)
		local top = topCheckbox:GetValue()
		local localize = localizeCheckbox:GetValue()
		GuiObjectPart.new(label, localize, influence, top)
	end)

	textInput:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateText(newValue)
	end)

	transparencyTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextTransparency((newValue - 1) / 10)
	end)

	sizeTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextSize((newValue - 1) * 5)
	end)

	rotationTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextRotation((newValue - 1) * 30)
	end)

	heightTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateLineHeight((newValue - 1) / 2)
	end)

	markupCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateRichText(newValue)
	end)

	scaledCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextScaled(newValue)
		if scaledCheckbox:GetValue() == true then
			sizeTextSlider:SetValue(0)
			wrappedCheckbox:SetDisabled(true)
			wrappedCheckbox:SetValue(true)
		else
			sizeTextSlider:SetValue(4)
			wrappedCheckbox:SetDisabled(false)
		end
	end)

	boldCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateFontFaceBold(newValue)
	end)

	italicCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateFontFaceItalic(newValue)
	end)

	colorTextChoice:SetValueChangedFunction(function(newIndex)
		local newValue = Color[newIndex].Color
		CustomTextLabel:UpdateTextColor3(newValue)
	end)

	fontTextChoice:SetValueChangedFunction(function(newIndex)
		local newValue = FontFace[newIndex].Font
		CustomTextLabel:UpdateFontFace(newValue)
	end)

	yChoice:SetValueChangedFunction(function(newIndex)
		local newValue = TextYAlignment[newIndex].Mode
		CustomTextLabel:UpdateVerticalAlignment(newValue)
	end)

	xChoice:SetValueChangedFunction(function(newIndex)
		local newValue = TextXAlignment[newIndex].Mode
		CustomTextLabel:UpdateHorizontalAlignment(newValue)
	end)

	strokeCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateStroke(newValue)
	end)

	colorStrokeChoice:SetValueChangedFunction(function(newIndex)
		local newValue = Color[newIndex].Color
		CustomTextLabel:UpdateStrokeColor(newValue)
	end)

	joinStrokeChoice:SetValueChangedFunction(function(newIndex)
		local newValue = LineJoinMode[newIndex].Mode
		CustomTextLabel:UpdateStrokeJoin(newValue)
	end)

	thicknessStrokeSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateStrokeThickness((newValue - 1))
	end)

	transparencyStrokeSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateStrokeTransparency((newValue - 1) / 10)
	end)

	transparencyBackgroundSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateBackgroundTransparency((newValue - 1) / 10)
	end)

	colorBackgroundChoice:SetValueChangedFunction(function(newIndex)
		local newValue = Color[newIndex].Color
		CustomTextLabel:UpdateBackgroundColor3(newValue)
	end)
end

function PluginGui:destoryPluginGui(widgetGui)
	for i, v in pairs(widgetGui:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end

return PluginGui
