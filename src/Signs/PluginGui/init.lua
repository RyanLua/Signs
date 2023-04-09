local targetFolder = script.Parent.StudioWidgets

local CollapsibleTitledSection = require(targetFolder.CollapsibleTitledSection)
local CustomTextButton = require(targetFolder.CustomTextButton)
local CustomTextLabel = require(targetFolder.CustomTextLabel)
local GuiUtilities = require(targetFolder.GuiUtilities)
local HorizontalTabBar = require(targetFolder.HorizontalTabBar)
local LabeledCheckbox = require(targetFolder.LabeledCheckbox)
local LabeledMultiChoice = require(targetFolder.LabeledMultiChoice)
local LabeledSlider = require(targetFolder.LabeledSlider)
local LabeledTextInput = require(targetFolder.LabeledTextInput)
local ScalingFrame = require(targetFolder.ScalingFrame)
local VerticalScrollingFrameScrollingFrame = require(targetFolder.VerticalScrollingFrame)
local VerticallyScalingListFrame = require(targetFolder.VerticallyScalingListFrame)

local Color = require(script.Color)
local FontFace = require(script.FontFace)
local GuiObjectPart = require(script.GuiObjectPart)
local LineJoinMode = require(script.LineJoinMode)
local AspectRatio = require(script.AspectRatio)
local TextXAlignment = require(script.TextXAlignment)
local TextYAlignment = require(script.TextYAlignment)

local PluginGui = {}

-- Creates a new plugin gui
function PluginGui:newPluginGui(widgetGui)
	local tabBar = HorizontalTabBar.new("Tabs")
	tabBar:GetTitlebar().Parent = widgetGui
	tabBar:GetFrame().Parent = widgetGui

	local createScalingFrame = ScalingFrame.new("CreateScalingFrame")
	createScalingFrame:GetFrame().Parent = tabBar:GetFrame()

	local createScrollFrame = VerticalScrollingFrameScrollingFrame.new("CreateScrollFrame")
	createScrollFrame:GetSectionFrame().Size = UDim2.new(1, 0, 1, -215)
	createScrollFrame:GetSectionFrame().LayoutOrder = 1
	createScrollFrame:GetSectionFrame().Parent = createScalingFrame:GetFrame()

	local createFrame = VerticallyScalingListFrame.new(
		"CreateFrame" -- name suffix of gui object
	)
	createFrame:GetFrame().Parent = createScrollFrame:GetContentsFrame()

	tabBar:AddTab("CreateScrollFrame", "Create")
	createScalingFrame:GetFrame().Parent = tabBar:GetFrame() -- set the section parent

	-- Top padding
	local padding = Instance.new("Frame")
	padding.Name = "Padding"
	padding.BackgroundTransparency = 1
	padding.BorderSizePixel = 0
	padding.Size = UDim2.new(1, 0, 0, 0)
	padding.Parent = createScalingFrame:GetFrame()

	-- Preview label
	local previewLabel = CustomTextLabel.new("Preview", 150)
	previewLabel:GetFrame().Parent = createScalingFrame:GetFrame()

	-- Insert button
	local insertButton = CustomTextButton.new(
		"InsertButton", -- name of the gui object
		"Insert" -- the text displayed on the button
	)

	-- Button object
	local buttonObject = insertButton:GetButton()
	buttonObject.Size = UDim2.new(1, -5, 0, 50)
	buttonObject.Parent = createScalingFrame:GetFrame()

	-- Text collapse
	local textCollapse = CollapsibleTitledSection.new(
		"TextCollapse", -- name suffix of the gui object
		"Text", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		false -- minimized by default?
	)
	createFrame:AddChild(textCollapse:GetSectionFrame())

	-- Text input
	local textInput = LabeledTextInput.new(
		"TextInput", -- name suffix of gui object
		"Text", -- title text of the multi choice
		"Text here" -- default value
	)
	textInput:SetMaxGraphemes(16384)
	textInput:GetFrame().Parent = textCollapse:GetContentsFrame()
	textInput:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateText(newValue)
	end)

	-- Text transparency slider
	local transparencyTextSlider = LabeledSlider.new(
		"TransparencyTextSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		1, -- the starting value of the slider
		0.1 -- multiplier for the slider value
	)
	transparencyTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()
	transparencyTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextTransparency(newValue)
	end)

	-- Text rotation slider
	local rotationTextSlider = LabeledSlider.new(
		"RotationSlider", -- name suffix of gui object
		"Text Rotation", -- title text of the multi choice
		9, -- how many intervals to split the slider into
		1, -- the starting value of the slider
		45 -- multiplier for the slider value
	)
	rotationTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()
	rotationTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextRotation(newValue)
	end)

	-- Size slider
	local sizeTextSlider = LabeledSlider.new(
		"SizeSlider", -- name suffix of gui object
		"Text Size", -- title text of the multi choice
		21, -- how many intervals to split the slider into
		4, -- the starting value of the slider
		5 -- multiplier for the slider value
	)
	sizeTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()
	sizeTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextSize(newValue)
	end)

	-- Line height slider
	local heightTextSlider = LabeledSlider.new(
		"HeightSlider", -- name suffix of gui object
		"Line Height", -- title text of the multi choice
		5, -- how many intervals to split the slider into
		3, -- the starting value of the slider
		0.5 -- multiplier for the slider value
	)
	heightTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()
	heightTextSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateLineHeight(newValue)
	end)

	-- Rich text checkbox
	local markupCheckbox = LabeledCheckbox.new(
		"MarkupCheckbox", -- name suffix of gui object
		"Rich Text", -- text beside the checkbox
		false, -- initial value
		false, -- initially disabled?
		"articles/gui-rich-text" -- link to wiki page
	)
	markupCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()
	markupCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateRichText(newValue)
	end)

	-- Text scaled checkbox
	local scaledCheckbox = LabeledCheckbox.new(
		"ScaledCheckbox", -- name suffix of gui object
		"Text Scaled", -- text beside the checkbox
		false, -- initial value
		false, -- initially disabled?
		"api-reference/property/TextLabel/TextScaled" -- link to wiki page
	)
	scaledCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()

	-- Text wrapped checkbox
	local wrappedCheckbox = LabeledCheckbox.new(
		"WrappedCheckbox", -- name suffix of gui object
		"Text Wrapped", -- text beside the checkbox
		true, -- initial value
		false, -- initially disabled?
		"api-reference/property/TextLabel/TextWrapped" -- link to wiki page
	)
	wrappedCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()
	wrappedCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateTextWrapped(newValue)
	end)

	-- Text scaled checkbox
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

	-- Font collapse
	local fontCollapse = CollapsibleTitledSection.new(
		"FontCollapse", -- name suffix of the gui object
		"Font", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	createFrame:AddChild(fontCollapse:GetSectionFrame())

	-- Bold checkbox
	local boldCheckbox = LabeledCheckbox.new(
		"BoldCheckbox", -- name suffix of gui object
		"Bold", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	boldCheckbox:GetFrame().Parent = fontCollapse:GetContentsFrame()
	boldCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateFontFaceBold(newValue)
	end)

	-- Italic checkbox
	local italicCheckbox = LabeledCheckbox.new(
		"ItalicCheckbox", -- name suffix of gui object
		"Italic", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	italicCheckbox:GetFrame().Parent = fontCollapse:GetContentsFrame()
	italicCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateFontFaceItalic(newValue)
	end)

	-- Font face choice
	local colorTextChoice = LabeledMultiChoice.new(
		"ColorSelection", -- name suffix of gui object
		"Text Color", -- title text of the multi choice
		Color, -- choices array
		11 -- the starting index of the selection
	)
	if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
		colorTextChoice:SetSelectedIndex(1)
	end
	colorTextChoice:GetFrame().Parent = fontCollapse:GetContentsFrame()
	colorTextChoice:SetValueChangedFunction(function(newIndex)
		local newValue = Color[newIndex].Color
		CustomTextLabel:UpdateTextColor3(newValue)
	end)

	-- Font face choice
	local fontTextChoice = LabeledMultiChoice.new(
		"FontTextChoice", -- name suffix of gui object
		"Font Face", -- title text of the multi choice
		FontFace, -- choices array
		32 -- the starting index of the selection
	)
	fontTextChoice:GetFrame().Parent = fontCollapse:GetContentsFrame()
	fontTextChoice:SetValueChangedFunction(function(newIndex)
		local newValue = FontFace[newIndex].Font
		CustomTextLabel:UpdateFontFace(newValue)
	end)

	-- Alignment collapse
	local alignmentCollapse = CollapsibleTitledSection.new(
		"AlignmentCollapse", -- name suffix of the gui object
		"Alignment", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	createFrame:AddChild(alignmentCollapse:GetSectionFrame())

	-- Horizontal alignment choice
	local yChoice = LabeledMultiChoice.new(
		"YChoice", -- name suffix of gui object
		"Horizontal Alignment", -- title text of the multi choice
		TextYAlignment, -- choices array
		2 -- the starting index of the selection
	)
	yChoice:GetFrame().Parent = alignmentCollapse:GetContentsFrame()
	yChoice:SetValueChangedFunction(function(newIndex)
		local newValue = TextYAlignment[newIndex].Mode
		CustomTextLabel:UpdateVerticalAlignment(newValue)
	end)

	-- Vertical alignment choice
	local xChoice = LabeledMultiChoice.new(
		"XChoice", -- name suffix of gui object
		"Vertical Alignment", -- title text of the multi choice
		TextXAlignment, -- choices array
		2 -- the starting index of the selection
	)
	xChoice:GetFrame().Parent = alignmentCollapse:GetContentsFrame()
	xChoice:SetValueChangedFunction(function(newIndex)
		local newValue = TextXAlignment[newIndex].Mode
		CustomTextLabel:UpdateHorizontalAlignment(newValue)
	end)

	-- Stroke collapse
	local strokeCollapse = CollapsibleTitledSection.new(
		"StrokeCollapse", -- name suffix of the gui object
		"Stroke", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	createFrame:AddChild(strokeCollapse:GetSectionFrame())

	-- Stroke enabled checkbox
	local strokeCheckbox = LabeledCheckbox.new(
		"StrokeCheckbox", -- name suffix of gui object
		"Enabled", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	strokeCheckbox:GetFrame().Parent = strokeCollapse:GetContentsFrame()
	strokeCheckbox:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateStroke(newValue)
	end)

	-- Stroke thickness slider
	local thicknessStrokeSlider = LabeledSlider.new(
		"ThicknessStrokeSlider", -- name suffix of gui object
		"Thickness", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		2, -- the starting value of the slider
		1, -- the multiplier for the slider
		"api-reference/property/UIStroke/Thickness" -- link to wiki page
	)
	thicknessStrokeSlider:GetFrame().Parent = strokeCollapse:GetContentsFrame()
	thicknessStrokeSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateStrokeThickness(newValue)
	end)

	-- Stroke transparency slider
	local transparencyStrokeSlider = LabeledSlider.new(
		"TransparencyStrokeSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		1, -- the starting value of the slider
		0.1, -- the multiplier for the slider
		"api-reference/property/UIStroke/Transparency" -- link to wiki page
	)
	transparencyStrokeSlider:GetFrame().Parent = strokeCollapse:GetContentsFrame()
	transparencyStrokeSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateStrokeTransparency(newValue)
	end)

	-- Stroke join choice
	local joinStrokeChoice = LabeledMultiChoice.new(
		"JoinStrokeChoice", -- name suffix of gui object
		"Line Join Mode", -- title text of the multi choice
		LineJoinMode, -- choices array
		1, -- the starting index of the selection
		"api-reference/property/UIStroke/LineJoinMode" -- link to wiki page
	)
	joinStrokeChoice:GetFrame().Parent = strokeCollapse:GetContentsFrame()
	joinStrokeChoice:SetValueChangedFunction(function(newIndex)
		local newValue = LineJoinMode[newIndex].Mode
		CustomTextLabel:UpdateStrokeJoin(newValue)
	end)

	-- Stroke color choice
	local colorStrokeChoice = LabeledMultiChoice.new(
		"ColorStrokeChoice", -- name suffix of gui object
		"Color", -- title text of the multi choice
		Color, -- choices array
		11, -- the starting index of the selection
		"api-reference/property/UIStroke/Color" -- link to wiki page
	)
	if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() == true then
		colorStrokeChoice:SetSelectedIndex(11)
	end
	colorStrokeChoice:GetFrame().Parent = strokeCollapse:GetContentsFrame()
	colorStrokeChoice:SetValueChangedFunction(function(newIndex)
		local newValue = Color[newIndex].Color
		CustomTextLabel:UpdateStrokeColor(newValue)
	end)

	-- Size collapse
	local sizeCollapse = CollapsibleTitledSection.new(
		"SizeCollapse", -- name suffix of the gui object
		"Size", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	createFrame:AddChild(sizeCollapse:GetSectionFrame())

	-- Size choice
	local ratioChoice = LabeledMultiChoice.new(
		"RatioChoice", -- name suffix of gui object
		"Aspect Ratio", -- title text of the multi choice
		AspectRatio, -- choices array
		5 -- the starting index of the selection
	)
	ratioChoice:GetFrame().Parent = sizeCollapse:GetContentsFrame()
	ratioChoice:SetValueChangedFunction(function(newIndex)
		local newValue = AspectRatio[newIndex].Value
		CustomTextLabel:UpdateAspectRatio(newValue)
	end)

	-- Background collapse
	local backgroundCollapse = CollapsibleTitledSection.new(
		"BackgroundCollapse", -- name suffix of the gui object
		"Background", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	createFrame:AddChild(backgroundCollapse:GetSectionFrame())

	-- Background transparency slider
	local transparencyBackgroundSlider = LabeledSlider.new(
		"TransparencyBackgroundSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		11, -- the starting value of the slider
		0.1 -- the multiplier for the slider
	)
	transparencyBackgroundSlider:GetFrame().Parent = backgroundCollapse:GetContentsFrame()
	transparencyBackgroundSlider:SetValueChangedFunction(function(newValue)
		CustomTextLabel:UpdateBackgroundTransparency(newValue)
	end)

	-- Background color choice
	local colorBackgroundChoice = LabeledMultiChoice.new(
		"ColorBackgroundSelection", -- name suffix of gui object
		"Background Color", -- title text of the multi choice
		Color, -- choices array
		1 -- the starting index of the selection
	)
	if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
		colorTextChoice:SetSelectedIndex(11)
	end
	colorBackgroundChoice:GetFrame().Parent = backgroundCollapse:GetContentsFrame()
	colorBackgroundChoice:SetValueChangedFunction(function(newIndex)
		local newValue = Color[newIndex].Color
		CustomTextLabel:UpdateBackgroundColor3(newValue)
	end)

	-- Other collapse
	local surfaceCollapse = CollapsibleTitledSection.new(
		"SurfaceCollapse", -- name suffix of the gui object
		"Other", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		true, -- minimizable?
		true -- minimized by default?
	)
	createFrame:AddChild(surfaceCollapse:GetSectionFrame())

	-- Light influence slider
	local influenceSlider = LabeledSlider.new(
		"InfluenceSlider", -- name suffix of gui object
		"Light Influence", -- title text of the multi choice
		5, -- how many intervals to split the slider into
		1, -- the starting value of the slider
		0.1 -- the multiplier for the slider
	)
	influenceSlider:GetFrame().Parent = surfaceCollapse:GetContentsFrame()

	-- Always on top checkbox
	local topCheckbox = LabeledCheckbox.new(
		"TopCheckbox", -- name suffix of gui object
		"Always On Top", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	topCheckbox:GetFrame().Parent = surfaceCollapse:GetContentsFrame()

	-- Auto localize checkbox
	local localizeCheckbox = LabeledCheckbox.new(
		"LocalizeCheckbox", -- name suffix of gui object
		"Auto Localize", -- text beside the checkbox
		true, -- initial value
		false -- initially disabled?
	)
	localizeCheckbox:GetFrame().Parent = surfaceCollapse:GetContentsFrame()

	-- Insert sign button
	insertButton:GetButton().MouseButton1Click:Connect(function()
		local label = CustomTextLabel:GetLabel()
		local influence = ((influenceSlider:GetValue() - 1) / 4)
		local top = topCheckbox:GetValue()
		local localize = localizeCheckbox:GetValue()
		local size = CustomTextLabel:GetLabel().AbsoluteSize
		GuiObjectPart.new(label, localize, influence, top, size)
	end)

	-- -- Edit tab

	-- local editScrollFrame = VerticalScrollingFrameScrollingFrame.new("EditScrollFrame")

	-- local editFrame = VerticallyScalingListFrame.new( -- Scrolling frame
	-- 	"EditFrame" -- name suffix of gui object
	-- )

	-- local editButton = CustomTextButton.new(
	-- 	"EditButton", -- name of the gui object
	-- 	"Edit" -- the text displayed on the button
	-- )
	-- local editObject = editButton:GetButton()
	-- editObject.Size = UDim2.new(1, -5, 0, 50)
	-- editObject.Parent = editScrollFrame:GetContentsFrame()

	-- local hint = GuiUtilities.MakeFrameWithSubSectionLabel("Hint", "Selected is not a SignsPart.")
	-- editFrame:AddChild(hint)

	-- tabBar:AddTab("EditScrollFrame", "Edit")
	-- editFrame:GetFrame().Parent = editScrollFrame:GetContentsFrame() -- scroll content will be the VerticallyScalingListFrame
	-- editScrollFrame:GetSectionFrame().Parent = tabBar:GetFrame() -- set the section parent

	-- editButton:GetButton().MouseButton1Click:Connect(function()
	-- 	local Selection = game:GetService("Selection")

	-- 	Selection:Get()
	-- 	HighlightEditable:highlight()
	-- end)
end

-- Destorys the plugin gui so a new one can be created
function PluginGui:destoryPluginGui(widgetGui)
	for _, GuiObject in pairs(widgetGui:GetChildren()) do
		GuiObject:Destroy()
	end
end

return PluginGui
