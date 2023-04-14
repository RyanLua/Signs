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
	-- surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.CanvasSize = size or Vector2.new(200, 200)
	surfaceGui.LightInfluence = lightInfluence or 0
	surfaceGui.AlwaysOnTop = alwaysOnTop or false
	surfaceGui.AutoLocalize = autoLocalize or true
	surfaceGui.Parent = part

	local guiObject = label:Clone()
	guiObject.Parent = surfaceGui

	Selection:Set({ part })

	ChangeHistoryService:SetWaypoint("Insert new SignPart")

	self._part = part
	self._surfaceGui = surfaceGui
	self._guiObject = guiObject

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
