----------------------------------------
--
-- CollapsibleItem
--
-- A CollapsibleItem is a frame that can be expanded and collapsed. Behaves like the items in the properties window
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)
local VerticallyScalingListFrame = require(script.Parent.VerticallyScalingListFrame)

local kLightHelpImage = "rbxasset://studio_svg_textures/Shared/Navigation/Light/Large/Help.png"
local kDarkHelpImage = "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Large/Help.png"
local kLightArrowImage = "rbxasset://studio_svg_textures/Shared/Navigation/Light/Large/Arrow.png" -- Check to see if this directory exists
local kDarkArrowImage = "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Large/Arrow.png" -- Do the same here

local ItemClass = {}
ItemClass.__index = ItemClass

-- Creates a new CollapsibleItem
function ItemClass.new(nameSuffix: string, labelText: string, multiLine: boolean, url: string)
	local self = {}
	setmetatable(self, ItemClass)

	self._valueChangedFunction = nil
	self._multiLine = multiLine

	-- Frame that contains the label and the content
	local frame = Instance.new("TextButton")
	frame.Name = "Item" .. nameSuffix
	frame.BorderSizePixel = 0
	frame.Text = ""
	frame.AutoButtonColor = false
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.Size = UDim2.new(1, 0, 0, GuiUtilities.kDefaultPropertyHeight)
	GuiUtilities.syncGuiElementBackgroundColor(frame)
	-- GuiUtilities.syncGuiElementShadowColor(frame)
	self._frame = frame

	-- Frame that contains the label so label can auto clip to size.
	local labelFrame = Instance.new("Frame")
	labelFrame.Name = "LabelFrame"
	labelFrame.Size = UDim2.new(0.5, 0, 0, GuiUtilities.kDefaultPropertyHeight)
	labelFrame.BackgroundTransparency = 1
	labelFrame.Position = UDim2.new(0, 0, 0, 0)
	labelFrame.ClipsDescendants = true
	labelFrame.Parent = frame

	-- Label that contains the property text
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.BackgroundTransparency = 1
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Font = GuiUtilities.kDefaultFontFace
	label.TextSize = GuiUtilities.kDefaultFontSize
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = labelText
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, GuiUtilities.DefaultLineLabelLeftMargin, 0.5, GuiUtilities.kTextVerticalFudge)
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.Parent = labelFrame
	GuiUtilities.syncGuiElementFontColor(label)
	self._label = label

	-- This is a bad way of doing this. I've removed this as this sucks and needs a better way of doing this.

	-- if not multiLine then
	-- 	local contentFrame = Instance.new("Frame")
	-- 	contentFrame.Name = "ContentFrame"
	-- 	contentFrame.Size = UDim2.new(0.5, 0, 0, GuiUtilities.kDefaultPropertyHeight)
	-- 	contentFrame.Position = UDim2.new(0.5, 0, 0, 0)
	-- 	contentFrame.Parent = frame
	-- 	GuiUtilities.syncGuiElementBackgroundColor(contentFrame)
	-- 	GuiUtilities.syncGuiElementShadowColor(contentFrame)
	-- 	frame:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
	-- 		contentFrame.BackgroundColor3 = frame.BackgroundColor3
	-- 	end)
	-- else
	-- 	VerticallyScalingListFrame.new("ItemFrame" .. nameSuffix)
	-- end

	-- Move this down to a function
	if url then
		local help = Instance.new("ImageButton")
		help.Name = "Help"
		help.BackgroundTransparency = 1
		help.Size = UDim2.new(0, GuiUtilities.kDefaultFontSize, 0, GuiUtilities.kDefaultFontSize)
		help.Position = UDim2.new(0, label.AbsoluteSize.X + 4, 0.5, 0)
		help.AnchorPoint = Vector2.new(0, 0.5)
		help.Parent = labelFrame
		self._help = help

		label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			help.Position = UDim2.new(0, GuiUtilities.kInlineTitleBarHeight + label.AbsoluteSize.X + 4, 0.5, 0)
		end)

		local function updateImages()
			if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
				help.Image = kDarkHelpImage
			else
				help.Image = kLightHelpImage
			end
			help.ImageColor3 = label.TextColor3
		end
		settings().Studio.ThemeChanged:Connect(updateImages)
		label:GetPropertyChangedSignal("TextColor3"):Connect(updateImages)
		updateImages()

		local plugin = script.Parent.Parent.Parent

		help.MouseEnter:Connect(function()
			plugin:GetMouse().Icon = "rbxasset://SystemCursors/PointingHand"
		end)
		help.MouseLeave:Connect(function()
			plugin:GetMouse().Icon = ""
		end)
		help.MouseButton1Click:Connect(function()
			plugin:OpenWikiPage(url)
		end)
	end

	self._hovered = false
	self._selected = false

	self:_SetupMouseClickHandling()

	return self
end

-- Setup the mouse click handling for the CollapsibleItem
function ItemClass:_SetupMouseClickHandling()
	self._frame.InputBegan:Connect(function()
		self._hovered = true
		self:_UpdateVisualState()
	end)

	self._frame.InputEnded:Connect(function()
		self._hovered = false
		self:SetValue(false)
		self:_UpdateVisualState()
	end)

	self._frame.MouseButton1Down:Connect(function()
		self:SetValue(true)
		self:_UpdateVisualState()
	end)
end

-- Update the visual state of the CollapsibleItem
function ItemClass:_UpdateVisualState()
	-- TODO: Fix this or cut it out

	-- if self._selected then
	-- 	self._frame.BackgroundColor3 =
	-- 		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected)
	-- elseif self._hovered then
	-- 	self._frame.BackgroundColor3 =
	-- 		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
	-- else
	-- 	self._frame.BackgroundColor3 =
	-- 		settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
	-- end
end

-- Use the help icon. This will open the url in the wiki when clicked
function ItemClass:UseHelp(url: string)
	
end

-- Use the CollapsibleItem as a toggleable frame
function ItemClass:UseCollapsible()
	-- Create a frame that is toggleable on click
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = "ToggleFrame"
	toggleFrame.Size = UDim2.new(1, 0, 0, GuiUtilities.kDefaultPropertyHeight)
	toggleFrame.Position = UDim2.new(0, 0, 0, 0)
	toggleFrame.Parent = self._frame

	local toggle = Instance.new("ImageButton")
	toggle.Name = "Toggle"
	toggle.BackgroundTransparency = 1
	toggle.Size = UDim2.new(0, GuiUtilities.kDefaultFontSize, 0, GuiUtilities.kDefaultFontSize)
	toggle.Position = UDim2.new(0, 0, 0.5, 0)
	toggle.AnchorPoint = Vector2.new(0, 0.5)
	toggle.Parent = toggleFrame
	self._toggle = toggle

	local function updateImages()
		if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
			toggle.Image = kLightArrowImage
		else
			toggle.Image = kDarkArrowImage
		end
		toggle.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
	settings().Studio.ThemeChanged:Connect(updateImages)
	updateImages()

	local function updateTogglePosition()
		local labelWidth = self._label.TextBounds.X
		toggle.Position = UDim2.new(0, labelWidth + 4, 0.5, 0)
	end
	self._label:GetPropertyChangedSignal("TextBounds"):Connect(updateTogglePosition)
	updateTogglePosition()

	self._selected = true

	self:_UpdateVisualState()

	-- Create a frame that is the content of the CollapsibleItem
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, 0, 0, 0)
	contentFrame.Position = UDim2.new(0, 0, 1, 0)
	contentFrame.Parent = self._frame
	self._contentFrame = contentFrame

	toggle.MouseButton1Click:Connect(function()
		self._selected = not self._selected
		self:_UpdateVisualState()
		self:_UpdateContentVisualState()
		if self._valueChangedFunction then
			self._valueChangedFunction(self._selected)
		end
	end)

	self:_UpdateContentVisualState()
end

-- Fires when the CollapsibleItem is selected
function ItemClass:SetValueChangedFunction(vcf): boolean
	self._valueChangedFunction = vcf
	return self._selected
end

-- Get the frame for the CollapsibleItem
function ItemClass:GetFrame(): Frame
	return self._frame
end

-- Get the label for the CollapsibleItem
function ItemClass:GetLabel(): TextLabel
	return self._label
end

-- Get the help button for the CollapsibleItem
function ItemClass:GetHelp(): ImageButton
	return self._help
end

-- Set the selected value of the CollapsibleItem
function ItemClass:SetValue(selected: boolean)
	self._selected = selected
	self:_UpdateVisualState()
end

function ItemClass:Selected()
	return self._selected
end

function ItemClass:Unselected() end

function ItemClass:Hovered() end

function ItemClass:Unhovered() end

return ItemClass
