local module = {}

module.kTitleBarHeight = 27
module.kInlineTitleBarHeight = 24

module.kDefaultContentAreaWidth = 180

module.kDefaultFontSize = 16
module.kDefaultFontFace = Enum.Font.SourceSans
module.kDefaultFontFaceBold = Enum.Font.SourceSansBold

module.kDefaultPropertyHeight = 30
module.kSubSectionLabelHeight = 30

module.kDefaultBorderColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)

module.kDefaultVMargin = 7
module.kDefaultHMargin = 16

module.kCheckboxMinLabelWidth = 52
module.kCheckboxMinMargin = 16 -- Default: 12
module.kCheckboxWidth = module.kCheckboxMinMargin -- Default: 12

module.kRadioButtonsHPadding = 54

module.DefaultLineLabelLeftMargin = module.kTitleBarHeight
module.DefaultLineElementLeftMargin = (module.DefaultLineLabelLeftMargin + module.kCheckboxMinLabelWidth
+ module.kCheckboxMinMargin + module.kCheckboxWidth + module.kRadioButtonsHPadding)
module.DefaultLineLabelWidth = (module.DefaultLineElementLeftMargin - module.DefaultLineLabelLeftMargin - 10 )

module.kDropDownHeight = 55

module.kBottomButtonsFrameHeight = 50
module.kBottomButtonsHeight = 28

module.kShapeButtonSize = 32
module.kTextVerticalFudge = 0
module.kButtonVerticalFudge = -5

module.kBottomButtonsWidth = 100

module.kDisabledTextColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText, Enum.StudioStyleGuideModifier.Disabled)
module.kDefaultButtonTextColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText, Enum.StudioStyleGuideModifier.Default)

module.kButtonDefaultBorderColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
module.kButtonDefaultBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
module.kButtonPressedBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
module.kButtonHoverBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
module.kButtonDisabledBackgroundColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled)

module.kButtonBackgroundTransparency = 0.5
module.kButtonBackgroundIntenseTransparency = 0.4

module.kMainFrame = nil

function module.ShouldUseIconsForDarkerBackgrounds()
	local mainColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	return (mainColor.r + mainColor.g + mainColor.b) / 3 < 0.5
end

function module.SetMainFrame(frame)
	module.kMainFrame = frame
end

function module.syncGuiElementTitleColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementInputFieldColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementBackgroundColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end


function module.syncGuiElementScrollBarBackgroundColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScrollBarBackground)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementStripeColor(guiElement)
	local function setColors()
		if guiElement.LayoutOrder + 1 % 2 == 0 then 
			guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
		else
			guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem)
		end
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementBorderColor(guiElement)
	local function setColors()
		guiElement.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementShadowColor(guiElement)
	local function setColors()
		guiElement.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Mid)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementFontColor(guiElement)
	local function setColors()
		guiElement.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiElementScrollColor(guiElement)
	local function setColors()
		guiElement.ScrollBarImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScrollBar)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiImageBorderColor(guiElement)
	local function setColors()
		guiElement.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiButtonColor(guiElement)
	local function setColors()
		guiElement.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

-- A frame with standard styling.
function module.MakeFrame(name)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0

	module.syncGuiElementBackgroundColor(frame)

	return frame
end
	

-- A frame that is a whole line, containing some arbitrary sized widget.
function module.MakeFixedHeightFrame(name, height)
	local frame = module.MakeFrame(name)
	frame.Size = UDim2.new(1, 0, 0, height)

	return frame
end

-- A frame that is one standard-sized line, containing some standard-sized widget (label, edit box, dropdown, 
-- checkbox)
function module.MakeDefaultFixedHeightFrame(name)
	return module.MakeFixedHeightFrame(name, module.kDefaultPropertyHeight)
end

function module.AdjustHeightDynamicallyToLayout(frame, uiLayout, optPadding)
	if not optPadding then 
		optPadding = 0
	end

	local function updateSizes()
		frame.Size = UDim2.new(1, 0, 0, uiLayout.AbsoluteContentSize.Y + optPadding)
	end
	uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSizes)
	updateSizes()
end

-- Assumes input frame has a List layout with sort order layout order.
-- Add frames in order as siblings of list layout, they will be laid out in order.
-- Color frame background accordingly.
function module.AddStripedChildrenToListFrame(listFrame, frames)
	for index, frame in ipairs(frames) do 
		frame.Parent = listFrame
		frame.LayoutOrder = index
		frame.BackgroundTransparency = 0
		frame.BorderSizePixel = 1
		module.syncGuiElementStripeColor(frame)
		module.syncGuiElementBorderColor(frame)
	end
end

function module.MakeDefaultPropertyLabel(text, opt_ignoreThemeUpdates)
	local label = Instance.new('TextLabel')
	label.RichText = true
	label.Name = 'Label'
	label.BackgroundTransparency = 1
	label.Font = module.kDefaultFontFace
	label.TextSize = module.kDefaultFontSize
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, module.DefaultLineLabelLeftMargin, 0.5, module.kTextVerticalFudge)
	label.Size = UDim2.new(0, module.DefaultLineLabelWidth, 1, 0)

	if not opt_ignoreThemeUpdates then
		module.syncGuiElementFontColor(label)
	end

	return label
end

function module.MakeFrameWithSubSectionLabel(name, text)
	local row = module.MakeFixedHeightFrame(name, module.kSubSectionLabelHeight)
	row.BackgroundTransparency = 1
		
	local label = module.MakeDefaultPropertyLabel(text)
	label.BackgroundTransparency = 1
	label.Parent = row

	return row
end

function module.MakeFrameAutoScalingList(frame)
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	module.AdjustHeightDynamicallyToLayout(frame, uiListLayout)
end


return module