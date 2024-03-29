local PluginGuiService = game:GetService("PluginGuiService")

-- Find the PluginToolbar class, or create it if it doesn't exist
local PluginToolbars = PluginGuiService:FindFirstChild("PluginToolbars")
if PluginToolbars == nil then
	PluginToolbars = Instance.new("Folder")
	PluginToolbars.Archivable = false -- Don't want to save this to the place file
	PluginToolbars.Name = "PluginToolbars"
	PluginToolbars.Parent = PluginGuiService
end

local PluginToolbar = {}
local plugin = nil -- Unfortunately, even if this module is require()'d in a plugin context, this does not exist

-- Creates a new toolbar with the given name
local function CreateNewToolbar(name)
	local toolbar = plugin:CreateToolbar(name)
	toolbar.Name = name
	toolbar.Parent = PluginToolbars
	return toolbar
end

-- Creates a new button on the given toolbar
function PluginToolbar:CreateToolbar(name)
	assert(
		typeof(name) == "string",
		"Incorrect parameter type for param 'name' (expected string, got " .. typeof(name) .. ")"
	)
	assert(#name > 0, "Cannot have zero-length toolbar name.")
	return PluginToolbars:FindFirstChild(name) or CreateNewToolbar(name)
end

-- Sets the reference stored in the plugin variable.
-- Returns the table for chaining calls (e.g. you can call this in-line on the require function itself)
function PluginToolbar:SetPlugin(reference: Plugin)
	plugin = reference
	return self
end

return PluginToolbar
