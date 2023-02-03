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

GuiObjectPart = {}
GuiObjectPart.__index = GuiObjectPart

function GuiObjectPart.new(label: GuiObject, autoLocalize: boolean?, lightInfluence: number?, alwaysOnTop: boolean?)
	local self = {}
	setmetatable(self, GuiObjectPart)

	local camera = workspace.CurrentCamera or Instance.new("Camera")

	local part = Instance.new("Part")
	part.Name = "SignPart"
	part.Anchored = true
	part.Parent = workspace
	part.Transparency = 1
	part.Size = Vector3.new(4, 4, 0)
	part.Position = (camera.CFrame + camera.CFrame.LookVector * 10).Position
	local yCameraRotation = camera.CFrame.Rotation.Y
	local yRotation = math.floor(yCameraRotation/90 + 0.5) * 90
	part.Rotation = Vector3.new(0, yRotation, 0)

	CollectionService:AddTag(part, "_Sign")

	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.LightInfluence = lightInfluence or 0
	surfaceGui.AlwaysOnTop = alwaysOnTop or false
	surfaceGui.AutoLocalize = autoLocalize or true
	surfaceGui.Parent = part

	local guiObject = label:Clone()
	guiObject.Parent = surfaceGui

	Selection:Set({part})

	ChangeHistoryService:SetWaypoint("Insert new SignPart")

	self._part = part
	self._surfaceGui = surfaceGui
	self._guiObject = guiObject

	return self
end

function GuiObjectPart:GetPart()
	return self._part
end

function GuiObjectPart:GetSurfaceGui()
	return self._surfaceGui
end

function GuiObjectPart:GetGuiObject()
	return self._guiObject
end

return GuiObjectPart