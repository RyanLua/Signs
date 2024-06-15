local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local tag = "_Sign" -- The tag you want to search for.
local radius = 124 -- The radius of the circle around the center of the viewport.
local minRadius = 32 -- The minimum radius of the circle around the center of the viewport.

local camera = Workspace.CurrentCamera
local viewportSize = camera.ViewportSize
local centerX = viewportSize.X / 2
local centerY = viewportSize.Y / 2

local taggedInstances = CollectionService:GetTagged(tag) -- Get all instances with the tag.
local filteredInstances = {} -- Tabe made of filteredInstances that isInRadius of camera.

-- Loop through each instance in taggedInstances and check if it is within radius of camera.
for _, instance in ipairs(taggedInstances) do -- Loop through each instance.
	local position = instance.Position -- Get instance position.
	local isInRadius = false -- Flag to check if instance is within radius.

	for angle = 0, 360, 10 do -- Loop through angles from 0 to 360 degrees with 10 degree increments.
		local x = centerX + math.cos(math.rad(angle)) * radius -- Calculate x coordinate on circle.
		local y = centerY + math.sin(math.rad(angle)) * radius -- Calculate y coordinate on circle.

		local ray = camera:ViewportPointToRay(x, y) -- Get ray from camera through point on circle.
		local closestPoint = ray:ClosestPoint(position) -- Get closest point on ray to instance position.

		local distance = (position - closestPoint).Magnitude -- Get distance between points.

		if distance < minRadius then -- If distance is less than minRadius.
			isInRadius = true -- Set flag to true.
			break -- Break out of angle loop.
		end
	end

	if isInRadius then -- If instance isInRadius then
		table.insert(filteredInstances, instance) -- Add instance to filteredInstances.
	end
end

return filteredInstances
