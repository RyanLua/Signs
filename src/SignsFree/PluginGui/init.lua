local targetFolder = script.Parent.StudioWidgets

local CollapsibleTitledSection = require(targetFolder.CollapsibleTitledSection)
local CustomTextButton = require(targetFolder.CustomTextButton)
local CustomTextLabel = require(targetFolder.CustomTextLabel)
local GuiUtilities = require(targetFolder.GuiUtilities)
--local ImageButtonWithText = require(targetFolder.ImageButtonWithText)
local LabeledCheckbox = require(targetFolder.LabeledCheckbox)
local LabeledMultiChoice = require(targetFolder.LabeledMultiChoice)
local LabeledRadioButton = require(targetFolder.LabeledRadioButton)
local LabeledSlider = require(targetFolder.LabeledSlider)
local LabeledTextInput = require(targetFolder.LabeledTextInput)
local RbxGui = require(targetFolder.RbxGui)
--local StatefulImageButton = require(targetFolder.StatefulImageButton)
local ScrollingFrame = require(targetFolder.VerticalScrollingFrame)
local VerticallyScalingListFrame = require(targetFolder.VerticallyScalingListFrame)

local Color = require(script.Color)
local FontFace = require(script.FontFace)
local GuiObjectPart = require(script.GuiObjectPart)

local PluginGui = {}

function PluginGui:newPluginGui(widgetGui)

	local scrollFrame = ScrollingFrame.new(
		"scrollFrame"
	)

	local listFrame = VerticallyScalingListFrame.new( -- Scrolling frame
		"listFrame" -- name suffix of gui object
	)

	local previewLabel = CustomTextLabel.new(
		"Preview",
		150
	)
	previewLabel:GetFrame().Parent = scrollFrame:GetContentsFrame()

	local insertButton = CustomTextButton.new( -- Insert button
		"insertButton", -- name of the gui object
		"Insert" -- the text displayed on the button
	)
	local buttonObject = insertButton:GetButton()
	buttonObject.Size = UDim2.new(1, -5, 0, 50)
	buttonObject.Parent = scrollFrame:GetContentsFrame()

	local textCollapse = CollapsibleTitledSection.new( -- Text collapse
		"textCollapse", -- name suffix of the gui object
		"Text", -- the text displayed beside the collapsible arrow
		true, -- have the content frame auto-update its size?
		false, -- minimizable?
		false -- minimized by default?
	)
	listFrame:AddChild(textCollapse:GetSectionFrame()) -- add child to expanding VerticallyScalingListFrame

	local textInput = LabeledTextInput.new( -- Asks user for text
		"textInput", -- name suffix of gui object
		"Text", -- title text of the multi choice
		"" -- default value
	)
	textInput:SetMaxGraphemes(4096)
	textInput:GetFrame().Parent = textCollapse:GetContentsFrame()

	local transparencyTextSlider = LabeledSlider.new( -- Size Slider
		"transparencyTextSlider", -- name suffix of gui object
		"Transparency", -- title text of the multi choice
		11, -- how many intervals to split the slider into
		1 -- the starting value of the slider
	)
	transparencyTextSlider:GetFrame().Parent = textCollapse:GetContentsFrame()

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

	local colorTextChoice = LabeledMultiChoice.new( -- Another hacky way to display color.
		"colorSelection", -- name suffix of gui object
		"Text Color", -- title text of the multi choice
		Color, -- choices array
		11 -- the starting index of the selection (in this case choice 1)
	)
	if settings().Studio.Theme == settings().Studio:GetAvailableThemes()[2] then
		colorTextChoice:SetSelectedIndex(1)
	end
	colorTextChoice:GetFrame().Parent = textCollapse:GetContentsFrame()

	local boldCheckbox = LabeledCheckbox.new(
		"boldCheckbox", -- name suffix of gui object
		"Bold", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	boldCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()

	local italicCheckbox = LabeledCheckbox.new(
		"italicCheckbox", -- name suffix of gui object
		"Italic", -- text beside the checkbox
		false, -- initial value
		false -- initially disabled?
	)
	italicCheckbox:GetFrame().Parent = textCollapse:GetContentsFrame()

	local fontTextChoice = LabeledMultiChoice.new( -- Basically in beta thingy for fonts. New system prob done by another PluginGui soon. This will suffice.
		"fontTextChoice", -- name suffix of gui object
		"Font Face", -- title text of the multi choice
		FontFace, -- choices array
		32 -- the starting index of the selection (in this case choice 1)
	)
	fontTextChoice:GetFrame().Parent = textCollapse:GetContentsFrame()

	--listFrame:AddBottomPadding() -- add padding to VerticallyScalingListFrame

	listFrame:GetFrame().Parent = scrollFrame:GetContentsFrame() -- scroll content will be the VerticallyScalingListFrame
	scrollFrame:GetSectionFrame().Parent = widgetGui -- set the section parent

	-- Below is utter hell. There is no workaround, only pain.

	insertButton:GetButton().MouseButton1Click:Connect(function()
		local label = CustomTextLabel:GetLabel()
		GuiObjectPart.new(label)
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
		local color = Color[newIndex].Color
		CustomTextLabel:UpdateTextColor3(color)
	end)

	fontTextChoice:SetValueChangedFunction(function(newIndex)
		local font = FontFace[newIndex].Font
		CustomTextLabel:UpdateFontFace(font)
	end)
end

function PluginGui:destoryPluginGui(widgetGui)
	for i,v in pairs(widgetGui:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end

return PluginGui