-- Create new "DockWidgetPluginGuiInfo" object for "PluginGuiService"
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left,  -- Widget will be initialized in left panel
	false,	-- Widget will be initially enabled
	false,	-- Don't override the previous enabled state
	290,	-- Default width of the floating window
	500,	-- Default height of the floating window
	280,	-- Minimum width of the floating window
	320		-- Minimum height of the floating window
)

-- Require plugin toolbar
local pluginToolbar = require(script.PluginToolbar)
pluginToolbar:SetPlugin(plugin)

-- Create a new toolbar section titled
local toolbar = pluginToolbar:CreateToolbar("Text Tools")

-- Add a toolbar button
local button = toolbar:CreateButton("Signs", "Hide/show the Signs Widget.", "rbxassetid://12060887019", "Signs")
button.ClickableWhenViewportHidden = true

-- Create new widget GUI and name it
local widget = plugin:CreateDockWidgetPluginGui("Signs", widgetInfo)
widget.Title = "Signs"
widget.Name = "Signs"

-- Set CreateButton.Icon to match Studio theme
local function setIcon()
	if settings().Studio.Theme == settings().Studio:GetAvailableThemes()[1] then -- Light theme
		button.Icon = "rbxassetid://12060897756"
	elseif settings().Studio.Theme == settings().Studio:GetAvailableThemes()[2] then -- Dark theme
		button.Icon = "rbxassetid://12060890851"
	else
		button.Icon = "rbxassetid://12060887019"
		warn("Failed to get Studio Theme. Button Icon may have low visibility.")
	end
end
settings().Studio.ThemeChanged:Connect(setIcon)
setIcon()

-- Initialize PluginGui or DevelopmentGui
local AddOns = require(script.Parent.PluginGui)

-- GuiObject logic
local function openGui()
	AddOns:newPluginGui(widget)
	button:SetActive(true)
	widget.Enabled = true
end

local function closeGui()
	AddOns:destoryPluginGui(widget)
	button:SetActive(false)
	widget.Enabled = false
end

local function toggleGui()
	if widget.Enabled == true then
		closeGui()
	else
		openGui()
	end
end

-- openGui up if widget already .Enabled
if widget.Enabled then
	openGui()
end

-- PluginGui logic
button.Click:Connect(toggleGui)
widget:BindToClose(closeGui)