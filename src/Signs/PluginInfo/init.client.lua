-- Create new "DockWidgetPluginGuiInfo" object for "PluginGuiService"
local widgetInfo: DockWidgetPluginGuiInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left, -- Widget will be initialized in left panel
	false, -- Widget will be initially enabled
	false, -- Don't override the previous enabled state
	275, -- Default width of the floating window
	660, -- Default height of the floating window
	165, -- Minimum width of the floating window
	420 -- Minimum height of the floating window
)

-- Require plugin toolbar so other plugins can share toolbar
local pluginToolbar: any = require(script.PluginToolbar)
pluginToolbar:SetPlugin(plugin)

-- Create a new toolbar section titled
local toolbar: PluginToolbar = pluginToolbar:CreateToolbar("Text Tool")

-- Add a toolbar button
local button: PluginToolbarButton = toolbar:CreateButton(
	"Signs",
	"Hide/show the Signs Widget.\n\nSigns is a Roblox Studio plugin that helps users create TextLabels for their projects quickly and safely. Simple to use UI and lots of options for customization.\n\nLearn more at https://github.com/RyanLua/Signs.",
	"rbxassetid://12135392705",
	"Signs"
)
button.ClickableWhenViewportHidden = true

-- Create new widget GUI and name it
local widget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui("Signs", widgetInfo)
widget.Title = "Signs 3.2.0"
widget.Name = "Signs"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Initialize PluginGui or DevelopmentGui
local AddOns: any = require(script.Parent.PluginGui)

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
