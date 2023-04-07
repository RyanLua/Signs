local TweenService = game:GetService("TweenService")
local Selection = game:GetService("Selection")

local selectColor = Color3.fromRGB(214, 129, 0)
local hoverColor = Color3.fromRGB(255, 184, 0)
local selectionColors = { selectColor, hoverColor }

local HighlightSelectionClass = {}
HighlightSelectionClass.__index = HighlightSelectionClass

-- Create a new highlight and set it to the selection.
function HighlightSelectionClass.setup(selection: Instance?)
	local self = {}
	setmetatable(self, HighlightSelectionClass)

	local highlight = Instance.new("Highlight")
	highlight.Name = "HighlightSelection"
	highlight.FillTransparency = 1
	highlight.OutlineColor = selectionColors[1]
	-- highlight.Adornee = selection
	highlight.Parent = script
	self._highlight = highlight

	self._selection = selection
	self._hover = false

	self:SetHoverOver(true)
	self:SetEnabled(true)

	self:_SetupSelectionHandling()

	return self
end

-- Detects if the selection is selected from Roblox Studio and changes the highlight color.
function HighlightSelectionClass:_SetupSelectionHandling()
	Selection.SelectionChanged:Connect(function()
		local selected = Selection:Get()[1]

		if selected == self._selection then
			self:SetHoverOver(true)
		else
			self:SetHoverOver(false)
		end
	end)
end

-- Tweens the highlight color like in Roblox Studio depending on hover boolean.
function HighlightSelectionClass:SetHoverOver(hover: boolean)
	self._hover = hover
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, math.huge, true)

	if self._hover == true then
		local tween = TweenService:Create(self._highlight, tweenInfo, { OutlineColor = selectionColors[2] })
		tween:Play()
	else
		self._highlight.OutlineColor = selectionColors[2]
	end
end

-- Changes Enabled property of the Highlight based on the disabled boolean.
function HighlightSelectionClass:SetEnabled(enabled: boolean)
	if enabled == true then
		self._highlight.Enabled = false
	else
		self._highlight.Enabled = true
	end
end

-- Set highlight's parent to the new selection.
function HighlightSelectionClass:Set(selection: Instance)
	self._highlight.Parent = selection
end

-- Add instances to the selection.
function HighlightSelectionClass:Add(instance: Instance)
	if self._highlight ~= nil then
		self._highlight.Adornee = instance
	end
end

-- Add table to the selection.
function HighlightSelectionClass:AddTable(table)
	for _, instance in ipairs(table) do
		self:Add(instance)
	end
end

-- Returns selection of HighlightSelectionClass.
function HighlightSelectionClass:GetSelection(): Instance?
	return self._selection
end

-- Returns the highlight of HighlightSelectionClass.
function HighlightSelectionClass:GetHighlight(): Highlight?
	return self._highlight
end

return HighlightSelectionClass
