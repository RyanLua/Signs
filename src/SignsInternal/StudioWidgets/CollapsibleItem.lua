----------------------------------------
--
-- CollapsibleItem
--
-- A CollapsibleItem is a frame that can be expanded and collapsed. Behaves like the items in the properties window
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)

local VerticallyScalingListFrame = require(script.Parent.VerticallyScalingListFrame)

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
	frame.Text = ""
	frame.AutoButtonColor = false
	frame.Size = UDim2.new(1, 0, 0, GuiUtilities.kDefaultPropertyHeight)
	GuiUtilities.syncGuiElementBackgroundColor(frame)
	GuiUtilities.syncGuiElementShadowColor(frame)
	self._frame = frame

	-- Frame that contains the label so label can auto clip to size.
	local labelFrame = Instance.new("Frame")
	labelFrame.Name = "LabelFrame"
	labelFrame.Size = UDim2.new(1, 0, 0, GuiUtilities.kDefaultPropertyHeight)
	labelFrame.BackgroundTransparency = 1
	labelFrame.Position = UDim2.new(0, 0, 0, 0)
	labelFrame.ClipsDescendants = true
	labelFrame.Parent = frame

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

	if not multiLine then
		local contentFrame = Instance.new("Frame")
		contentFrame.Name = "ContentFrame"
		contentFrame.Size = UDim2.new(0.5, 0, 0, GuiUtilities.kDefaultPropertyHeight)
		contentFrame.Position = UDim2.new(0.5, 0, 0, 0)
		contentFrame.Parent = frame
		GuiUtilities.syncGuiElementBackgroundColor(contentFrame)
		GuiUtilities.syncGuiElementShadowColor(contentFrame)
		frame:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
			contentFrame.BackgroundColor3 = frame.BackgroundColor3
		end)
	else
		VerticallyScalingListFrame.new("ItemFrame" .. nameSuffix)
	end

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
				help.Image = "rbxasset://studio_svg_textures/Shared/Navigation/Dark/Large/Help.png"
			else
				help.Image = "rbxasset://studio_svg_textures/Shared/Navigation/Light/Large/Help.png"
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
			self:_UpdateVisualState()
	end)

	self._frame.MouseButton1Down:Connect(function()
		self:SetValue(true)
		self:_UpdateVisualState()
	end)
end

-- Update the visual state of the CollapsibleItem
function ItemClass:_UpdateVisualState()
	if self._selected then
		self._frame.BackgroundColor3 =
			settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected)
	elseif self._hovered then
		self._frame.BackgroundColor3 =
			settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
	else
		self._frame.BackgroundColor3 =
			settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
	end
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
