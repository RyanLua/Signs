local GuiUtilities = require(script.Parent.GuiUtilities)

local kSliderThumbImage = "rbxasset://textures/RoactStudioWidgets/slider_handle_light.png"
local kPreThumbImage = "rbxasset://textures/RoactStudioWidgets/slider_bar_light.png"
local kPostThumbImage = "rbxasset://textures/RoactStudioWidgets/slider_bar_background_light.png"

local kSliderThumbImageDark = "rbxasset://textures/RoactStudioWidgets/slider_handle_dark.png"
local kPreThumbImageDark = "rbxasset://textures/RoactStudioWidgets/slider_bar_dark.png"
local kPostThumbImageDark = "rbxasset://textures/RoactStudioWidgets/slider_bar_background_dark.png"

local kThumbSize = 12

local t = {}

local function getLayerCollectorAncestor(instance)
	local localInstance = instance
	while localInstance and not localInstance:IsA("LayerCollector") do
		localInstance = localInstance.Parent
	end
	return localInstance
end

local function setSliderPos(newAbsPosX, slider, sliderPosition, bar, steps)
	local newStep = steps - 1 --otherwise we really get one more step than we want
	local relativePosX = math.min(1, math.max(0, (newAbsPosX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X))
	local wholeNum, remainder = math.modf(relativePosX * newStep)
	if remainder > 0.5 then
		wholeNum = wholeNum + 1
	end
	relativePosX = wholeNum / newStep

	local result = math.ceil(relativePosX * newStep)
	if sliderPosition.Value ~= (result + 1) then --only update if we moved a step
		sliderPosition.Value = result + 1
		slider.Position =
			UDim2.new(relativePosX, -slider.AbsoluteSize.X / 2, slider.Position.Y.Scale, slider.Position.Y.Offset)
	end
end

local function cancelSlide(areaSoak)
	areaSoak.Visible = false
end

t.CreateSlider = function(steps: number, size: UDim2, position: UDim2)
	local sliderGui = Instance.new("Frame")
	sliderGui.Size = size
	sliderGui.BackgroundTransparency = 1
	sliderGui.Name = "SliderGui"

	if
		position["X"]
		and position["X"]["Scale"]
		and position["X"]["Offset"]
		and position["Y"]
		and position["Y"]["Scale"]
		and position["Y"]["Offset"]
	then
		sliderGui.Position = position
	end

	local sliderSteps = Instance.new("IntValue")
	sliderSteps.Name = "SliderSteps"
	sliderSteps.Value = steps
	sliderSteps.Parent = sliderGui

	local areaSoak = Instance.new("TextButton")
	areaSoak.Name = "AreaSoak"
	areaSoak.Text = ""
	areaSoak.BackgroundTransparency = 1
	areaSoak.Active = false
	areaSoak.Size = UDim2.new(1, 0, 1, 0)
	areaSoak.Visible = false
	areaSoak.ZIndex = 4

	sliderGui.AncestryChanged:Connect(function(parent)
		if parent == nil then
			areaSoak.Parent = nil
		else
			areaSoak.Parent = getLayerCollectorAncestor(sliderGui)
		end
	end)

	local sliderPosition = Instance.new("IntValue")
	sliderPosition.Name = "SliderPosition"
	sliderPosition.Value = 0
	sliderPosition.Parent = sliderGui

	local bar = Instance.new("ImageButton")
	bar.Name = "Bar"
	bar.BackgroundTransparency = 1
	bar.BorderSizePixel = 0
	bar.Position = UDim2.new(0, 0, 0.5, 0)
	bar.AnchorPoint = Vector2.new(0, 0.5)
	bar.Size = UDim2.new(1, 0, 0, 5)
	bar.ZIndex = 2
	bar.Parent = sliderGui

	local preBar = Instance.new("ImageLabel")
	preBar.Name = "PreThumb"
	preBar.Parent = bar
	preBar.BackgroundTransparency = 1
	preBar.ScaleType = Enum.ScaleType.Slice
	preBar.SliceCenter = Rect.new(3, 0, 4, 3)
	preBar.Size = UDim2.new(0, 0, 1, 0)
	preBar.Position = UDim2.new(0, 0, 0, 0)
	preBar.Image = kPreThumbImage
	preBar.BorderSizePixel = 0

	local postBar = Instance.new("ImageLabel")
	postBar.Name = "PostThumb"
	postBar.Parent = bar
	postBar.BackgroundTransparency = 1
	postBar.ScaleType = Enum.ScaleType.Slice
	postBar.SliceCenter = Rect.new(3, 0, 4, 3)
	postBar.Size = UDim2.new(1, 0, 1, 0)
	postBar.Position = UDim2.new(0, 0, 0, 0)
	postBar.Image = kPostThumbImage
	postBar.BorderSizePixel = 0

	sliderPosition.Changed:Connect(function()
		local scale = (sliderPosition.Value - 1) / (steps - 1)

		preBar.Size = UDim2.new(scale, 0, 1, 0)
		postBar.Size = UDim2.new(1 - scale, 0, 1, 0)
		postBar.Position = UDim2.new(scale, 0, 0, 0)
	end)

	local slider = Instance.new("ImageButton")
	slider.Name = "Slider"
	slider.BackgroundTransparency = 1
	slider.Image = kSliderThumbImage
	slider.Position = UDim2.new(0, -kThumbSize / 2, 0.5, 0)
	slider.AnchorPoint = Vector2.new(0, 0.5)
	slider.Size = UDim2.new(0, kThumbSize, 0, kThumbSize)
	slider.ZIndex = 3
	slider.Parent = bar

	local areaSoakMouseMoveCon = nil

	areaSoak.MouseLeave:Connect(function()
		if areaSoak.Visible then
			cancelSlide(areaSoak)
		end
	end)
	areaSoak.MouseButton1Up:Connect(function()
		if areaSoak.Visible then
			cancelSlide(areaSoak)
		end
	end)

	slider.MouseButton1Down:Connect(function()
		areaSoak.Visible = true
		if areaSoakMouseMoveCon then
			areaSoakMouseMoveCon:Disconnect()
		end
		areaSoakMouseMoveCon = areaSoak.MouseMoved:Connect(function(x)
			setSliderPos(x, slider, sliderPosition, bar, steps)
		end)
	end)

	slider.MouseButton1Up:Connect(function()
		cancelSlide(areaSoak)
	end)

	sliderPosition.Changed:Connect(function()
		sliderPosition.Value = math.min(steps, math.max(1, sliderPosition.Value))
		local relativePosX = (sliderPosition.Value - 1) / (steps - 1)
		slider.Position =
			UDim2.new(relativePosX, -slider.AbsoluteSize.X / 2, slider.Position.Y.Scale, slider.Position.Y.Offset)
	end)

	bar.MouseButton1Down:Connect(function(x)
		setSliderPos(x, slider, sliderPosition, bar, steps)
	end)

	local function setImages()
		if GuiUtilities:ShouldUseIconsForDarkerBackgrounds() then
			slider.Image = kSliderThumbImageDark
			preBar.Image = kPreThumbImageDark
			postBar.Image = kPostThumbImageDark
		else
			slider.Image = kSliderThumbImage
			preBar.Image = kPreThumbImage
			postBar.Image = kPostThumbImage
		end
	end
	settings().Studio.ThemeChanged:Connect(setImages)
	setImages()

	return sliderGui, sliderPosition, sliderSteps
end

return t
