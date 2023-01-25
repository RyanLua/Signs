----------------------------------------
--
-- LabeledRadioButton.lua
--
-- Creates a frame containing a label and a radio button.
--
----------------------------------------
GuiUtilities = require(script.Parent.GuiUtilities)
LabeledButton = require(script.Parent.LabeledButton)

LabeledRadioButtonClass = {}
LabeledRadioButtonClass.__index = LabeledRadioButtonClass
setmetatable(LabeledRadioButtonClass, LabeledButton)

function LabeledRadioButtonClass.new(nameSuffix, labelText)
	local newButton = LabeledButton.new(nameSuffix, labelText, false)
	setmetatable(newButton, LabeledRadioButtonClass)

	-- newButton:UseSmallSize()
	-- newButton._checkImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	-- newButton._checkImage.Image = kBulletImage
	-- newButton._checkImage.Size = UDim2.new(0, kBulletSize, 0, kBulletSize)

	-- newButton._button.Image = kButtonImage
	-- newButton._button.Size = UDim2.new(0, kFrameSize, 0, kFrameSize)
	-- newButton._button.BackgroundTransparency = 1

	-- local function updateImages()
	-- 	if (GuiUtilities:ShouldUseIconsForDarkerBackgrounds()) then 
	-- 		newButton._checkImage.Image = kBulletImageDark
	-- 		newButton._button.Image = kButtonImageDark
	-- 	else
	-- 		newButton._checkImage.Image = kBulletImage
	-- 		newButton._button.Image = kButtonImage
	-- 	end
	-- end
	-- settings().Studio.ThemeChanged:Connect(updateImages)
	-- updateImages()

	return newButton
end

function LabeledRadioButtonClass:_MaybeToggleState()
	-- A checkbox can never be toggled off. 
	-- Only turns off because another one turns on.
	if (not self._disabled and not self._value) then 
		self:SetValue(not self._value)
	end
end

return LabeledRadioButtonClass