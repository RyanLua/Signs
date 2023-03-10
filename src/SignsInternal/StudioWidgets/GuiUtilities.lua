local module = {}

module.kTitleBarHeight = 24
module.kInlineTitleBarHeight = 24

module.kDefaultContentAreaWidth = 180

module.kDefaultFontSize = 15
module.kDefaultFontFace = Enum.Font.SourceSans
module.kDefaultFontFaceBold = Enum.Font.SourceSansBold

module.kDefaultPropertyHeight = 30
module.kSubSectionLabelHeight = 30

module.kDefaultBorderColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)

module.kDefaultVMargin = 7
module.kDefaultHMargin = 16

module.kCheckboxSize = 16
module.kCheckboxPadding = (module.kDefaultPropertyHeight - module.kCheckboxSize) / 2
module.kCheckboxMinLabelWidth = 52
module.kCheckboxMinMargin = 16 -- Default: 12
module.kCheckboxWidth = module.kCheckboxMinMargin -- Default: 12

module.kTextInputHeight = 22
module.kTextInputPadding = (module.kDefaultPropertyHeight - module.kTextInputHeight) / 2
module.kTextInputWidth = module.kCheckboxWidth * 2

module.kSliderPadding = module.kTextInputPadding * 2

module.kRadioButtonsHPadding = 54

module.DefaultLineLabelLeftMargin = module.kTitleBarHeight
module.DefaultLineElementLeftMargin = (
	module.DefaultLineLabelLeftMargin
	+ module.kCheckboxMinLabelWidth
	+ module.kCheckboxMinMargin
	+ module.kCheckboxWidth
	+ module.kRadioButtonsHPadding
)
module.DefaultLineLabelWidth = (module.DefaultLineElementLeftMargin - module.DefaultLineLabelLeftMargin - 10)

module.DefaultRightMargin = module.DefaultLineLabelLeftMargin + module.DefaultLineLabelWidth + 15

module.kDropDownHeight = 55

module.kBottomButtonsFrameHeight = 50
module.kBottomButtonsHeight = 28

module.kShapeButtonSize = 32
module.kTextVerticalFudge = 0
module.kButtonVerticalFudge = -5

module.kBottomButtonsWidth = 100

module.kDisabledTextColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText, Enum.StudioStyleGuideModifier.Disabled)
module.kDefaultButtonTextColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText, Enum.StudioStyleGuideModifier.Default)

module.kButtonDefaultBorderColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
module.kButtonDefaultBackgroundColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
module.kButtonPressedBackgroundColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
module.kButtonHoverBackgroundColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
module.kButtonDisabledBackgroundColor =
	settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled)

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

function module.syncGuiElementTitlebarColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Titlebar)
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

function module.syncGuiInputFieldBorderColor(guiElement)
	local function setColors()
		guiElement.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiTabBarBackgroundColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiTabBackgroundColor(guiElement)
	local function setColors()
		guiElement.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiInputFieldBackgroundColor(guiElement)
	local function setColors()
		guiElement.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground)
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

function module.syncGuiElementPlaceholderColor(guiElement)
	local function setColors()
		guiElement.PlaceholderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.DimmedText)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiImageColor(guiElement)
	local function setColors()
		guiElement.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
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
		guiElement.ImageColor3 =
			settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

function module.syncGuiButtonColor(guiElement)
	local function setColors()
		guiElement.ImageColor3 =
			settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
	end
	settings().Studio.ThemeChanged:Connect(setColors)
	setColors()
end

-- A frame with standard styling.
function module.MakeFrame(name)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.ClipsDescendants = true
	module.syncGuiElementBackgroundColor(frame)
	module.syncGuiElementShadowColor(frame)

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

function module.MakeDefaultPropertyLabel(text: string, multiLine: boolean, url: string?)
	local CollapsibleItem = require(script.Parent.CollapsibleItem)

	local collapsibleItem = CollapsibleItem.new(text, text, false, url)
	local frame = collapsibleItem:GetFrame()

	return frame
end

function module.MakeFrameWithSubSectionLabel(name, text, url)
	local row = module.MakeFixedHeightFrame(name, module.kSubSectionLabelHeight)
	row.BackgroundTransparency = 1

	local label = module.MakeDefaultPropertyLabel(text, false, url)
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
