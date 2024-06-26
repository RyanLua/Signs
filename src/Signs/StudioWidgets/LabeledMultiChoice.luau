----------------------------------------
--
-- LabeledMultiChoice.luau
--
-- Creates a frame containing a label and list of choices, of which exactly one
-- is always selected.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)
local CollapsibleItem = require(script.Parent.CollapsibleItem)

local LabeledRadioButton = require(script.Parent.LabeledRadioButton)
local VerticallyScalingListFrame = require(script.Parent.VerticallyScalingListFrame)

local LabeledMultiChoiceClass = {}
LabeledMultiChoiceClass.__index = LabeledMultiChoiceClass

-- Note:
-- "choices" is an array of entries.
-- each entry must have at least 2 fields:
-- "Id" - a unique (in the scope of choices) string id.  Not visible to user.
-- "Text" - user-facing string: the label for the choice.
function LabeledMultiChoiceClass.new(nameSuffix, labelText, choices, initChoiceIndex, url)
	local self = {}
	setmetatable(self, LabeledMultiChoiceClass)

	self._buttonObjsByIndex = {}

	if not initChoiceIndex then
		initChoiceIndex = 1
	end
	if initChoiceIndex > #choices then
		initChoiceIndex = #choices
	end

	local vsl = VerticallyScalingListFrame.new("MCC_" .. nameSuffix)
	vsl:AddBottomPadding()

	-- local titleLabel = GuiUtilities.MakeFrameWithSubSectionLabel("Title", labelText, url)
	local titleLabel = GuiUtilities.MakeFrameWithSubSectionLabel("Title", labelText, url)
	vsl:AddChild(titleLabel)

	-- Container for cells.
	local cellFrame = self:_MakeRadioButtons(choices)
	vsl:AddChild(cellFrame)

	self._vsl = vsl

	self:SetSelectedIndex(initChoiceIndex)

	return self
end

function LabeledMultiChoiceClass:SetSelectedIndex(selectedIndex)
	self._selectedIndex = selectedIndex
	for i = 1, #self._buttonObjsByIndex do
		self._buttonObjsByIndex[i]:SetValue(i == selectedIndex)
	end

	if self._valueChangedFunction then
		self._valueChangedFunction(self._selectedIndex)
	end
end

function LabeledMultiChoiceClass:GetSelectedIndex()
	return self._selectedIndex
end

function LabeledMultiChoiceClass:SetValueChangedFunction(vcf)
	self._valueChangedFunction = vcf
end

function LabeledMultiChoiceClass:GetFrame()
	return self._vsl:GetFrame()
end

-- Small checkboxes are a different entity.
-- All the bits are smaller.
-- Fixed width instead of flood-fill.
-- Box comes first, then label.
function LabeledMultiChoiceClass:_MakeRadioButtons(choices)
	local frame = GuiUtilities.MakeFrame("RadioButtons")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, -GuiUtilities.DefaultLineLabelLeftMargin * 2, 1, 0)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, GuiUtilities.DefaultLineLabelLeftMargin)
	padding.PaddingRight = UDim.new(0, GuiUtilities.DefaultLineLabelLeftMargin)
	padding.Parent = frame

	-- Make a grid to put checkboxes in.
	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.CellSize = UDim2.new(1, 0, 0, GuiUtilities.kTitleBarHeight)
	uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiGridLayout.Parent = frame
	uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	for i, choiceData in ipairs(choices) do
		self:_AddRadioButton(frame, i, choiceData)
	end

	-- Sync size with content size.
	GuiUtilities.AdjustHeightDynamicallyToLayout(frame, uiGridLayout)

	return frame
end

function LabeledMultiChoiceClass:_AddRadioButton(parentFrame, index, choiceData)
	local radioButtonObj = LabeledRadioButton.new(choiceData.Id, choiceData.Text)
	self._buttonObjsByIndex[index] = radioButtonObj

	radioButtonObj:SetValueChangedFunction(function(value)
		-- If we notice the button going from off to on, and it disagrees with
		-- our current notion of selection, update selection.
		if value and self._selectedIndex ~= index then
			self:SetSelectedIndex(index)
		end
	end)

	radioButtonObj:GetFrame().LayoutOrder = index
	radioButtonObj:GetFrame().Parent = parentFrame
end

return LabeledMultiChoiceClass
