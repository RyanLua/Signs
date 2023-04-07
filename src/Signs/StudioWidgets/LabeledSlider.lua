----------------------------------------
--
-- LabeledSlider.lua
--
-- Creates a frame containing a label, text input, and a slider control.
--
----------------------------------------
local GuiUtilities = require(script.Parent.GuiUtilities)
local CollapsibleItem = require(script.Parent.CollapsibleItem)

local rbxGuiLibrary = require(script.Parent.RbxGui)
local LabeledTextInput = require(script.Parent.LabeledTextInput)

local kInputOffset = GuiUtilities.kTextInputWidth + GuiUtilities.kTextInputPadding + GuiUtilities.kSliderPadding
local kSliderOffset = -kInputOffset - GuiUtilities.kSliderPadding

local LabeledSliderClass = {}
LabeledSliderClass.__index = LabeledSliderClass

function LabeledSliderClass.new(
	nameSuffix: string,
	labelText: string,
	sliderIntervals: number,
	defaultValue: number,
	multiplier: number,
	url: string?
)
	local self = {}
	setmetatable(self, LabeledSliderClass)

	self._valueChangedFunction = nil

	local value = defaultValue or 1
	self._value = value
	self._multiplier = multiplier or 1

	local item = CollapsibleItem.new(nameSuffix, labelText, false, url)
	self._item = item

	-- Creates the input
	local input =
		LabeledTextInput.new("SliderInput" .. nameSuffix, labelText, (self._value - 1) * self._multiplier, url)
	input:UseSmallSize()
	input:SetMaxGraphemes(5)
	input:SetValue(tostring(self._value * self._multiplier))
	input:GetFrame().Parent = item:GetFrame()
	self._input = input

	-- Creates the slider.
	local slider, sliderValue = rbxGuiLibrary.CreateSlider(
		sliderIntervals,
		UDim2.new(0.5, kSliderOffset, 1, 0),
		UDim2.new(0.5, kInputOffset, 0.5, 0)
	)
	self._slider = slider
	self._sliderValue = sliderValue
	slider.Parent = item:GetFrame()

	-- Sets the slider value to the input value when the slider is changed
	sliderValue.Changed:Connect(function()
		self._value = sliderValue.Value

		if not input._textBox:IsFocused() then
			input:SetValue((self._value - 1) * self._multiplier)
		end

		if self._valueChangedFunction then
			self._valueChangedFunction((self._value - 1) * self._multiplier)
		end
	end)

	-- Sets the input value to the slider value when the input is changed
	input:SetValueChangedFunction(function(vcf)
		if vcf == "" then
			self:SetValue(value)
		else
			if vcf ~= nil then
				self:SetValue(tonumber(vcf) / self._multiplier + 1)
			end
		end
	end)

	-- Sets the slider value to the input value when the input is unfocused
	input._textBox.FocusLost:Connect(function()
		if input._textBox.Text == "" then
			input:SetValue((value - 1) * self._multiplier)
		else
			self:SetValue(tonumber(input._textBox.Text) / self._multiplier + 1)
		end
	end)

	self:SetValue(value)

	return self
end

function LabeledSliderClass:SetValueChangedFunction(vcf)
	self._valueChangedFunction = vcf
end

function LabeledSliderClass:GetFrame()
	return self._item:GetFrame()
end

function LabeledSliderClass:SetValue(newValue)
	if self._sliderValue.Value ~= newValue then
		self._sliderValue.Value = newValue
	end
end

function LabeledSliderClass:GetValue()
	return self._sliderValue.Value
end

return LabeledSliderClass
