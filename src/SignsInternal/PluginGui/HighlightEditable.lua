local SignCollection = require(script.Parent.SignCollection)
local HighlightSelection = require(script.Parent.HighlightSelection)
local HighlightEditable = {}
HighlightEditable.__index = HighlightEditable

-- Create a new highlight and set it to the selection.
function HighlightEditable.highlight()
	local self = {}
	setmetatable(self, HighlightEditable)

	HighlightSelection:setup()
	HighlightSelection:AddTable(SignCollection)

	return self
end

return HighlightEditable
