----------------------------------------
--
-- InsertGuiObject.lua
--
-- Creates a part from a GuiObject.
--
----------------------------------------

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local CollectionService = game:GetService("CollectionService")
local Selection = game:GetService("Selection")

local GuiObjectPart = {}
GuiObjectPart.__index = GuiObjectPart

-- Creates a new GuiObjectPart
function GuiObjectPart.new(
	label: GuiObject,
	autoLocalize: boolean?,
	lightInfluence: number?,
	alwaysOnTop: boolean?,
	size: Vector2
)
	local self = {}
	setmetatable(self, GuiObjectPart)

	local recording = ChangeHistoryService:TryBeginRecording("NewSignPart", "Create a new SignPart")

	if not recording then
		error("Could not begin recording data model changes")
	end

	local camera = workspace.CurrentCamera or Instance.new("Camera")

	local partSizeX = label.AbsoluteSize.X / 50
	local partSizeY = label.AbsoluteSize.Y / 50
	local part = Instance.new("Part")
	part.Name = "SignPart"
	part.Anchored = true
	part.Parent = workspace
	part.Transparency = 1
	part.Size = Vector3.new(partSizeX, partSizeY, 0)
	part.Position = (camera.CFrame + camera.CFrame.LookVector * 10).Position

	CollectionService:AddTag(part, "_Sign")

	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.PixelsPerStud = 50
	surfaceGui.LightInfluence = lightInfluence or 0
	surfaceGui.AlwaysOnTop = alwaysOnTop or false
	surfaceGui.AutoLocalize = autoLocalize or true
	surfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	surfaceGui.Parent = part

	local guiObject = label:Clone()
	guiObject.Parent = surfaceGui
	if guiObject:WaitForChild("UIStroke") then
		if guiObject.UIStroke.Thickness == 0 or guiObject.Transparency == 1 or guiObject.UIStroke.Enabled == false then
			guiObject.UIStroke:Destroy()
		end
	end
	if guiObject.Rotation % 90 ~= 0 then
		local canvas = Instance.new("CanvasGroup")
		canvas.BackgroundTransparency = 1
		canvas.Size = UDim2.new(1, 0, 1, 0)
		canvas.Parent = surfaceGui
		guiObject.Parent = canvas
	end

	Selection:Set({ part })

	self._part = part
	self._surfaceGui = surfaceGui
	self._guiObject = guiObject

	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)

	return self
end

-- Gets the GuiObjectPart
function GuiObjectPart:GetPart(): Part
	return self._part
end

-- Gets the SurfaceGui
function GuiObjectPart:GetSurfaceGui(): SurfaceGui
	return self._surfaceGui
end

-- Gets the GuiObject
function GuiObjectPart:GetGuiObject(): GuiObject
	return self._guiObject
end

return GuiObjectPart
