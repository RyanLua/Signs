local choices = {

	-- Every font in existance, needs a better loop system for if new font is made. Much as a proof of concept for now.
	-- [[<font color="rgb(_COLOR3_)">_COLOR_</font>]]
	{Id = "1",
		Color = Color3.fromRGB(255, 255, 255),
		Text = [[<stroke color="rgb(46, 46, 46)" joins="round" thickness="1" transparency="0.25"><font color="rgb(242, 243, 243)">White</font></stroke>]]},
	{Id = "2",
		Color = Color3.fromRGB(128, 128, 128),
		Text = [[<font color="rgb(128, 128, 128)">Grey</font>]]},
	{Id = "3",
		Color = Color3.fromRGB(255, 0, 0),
		Text = [[<font color="rgb(255, 0, 0)">Red</font>]]},
	{Id = "4",
		Color = Color3.fromRGB(255, 255, 0),
		Text = [[<font color="rgb(245, 205, 48)">Yellow</font>]]},
	{Id = "5",
		Color = Color3.fromRGB(255, 170, 0),
		Text = [[<font color="rgb(255, 170, 0)">Orange</font>]]},
	{Id = "6",
		Color = Color3.fromRGB(0, 255, 0),
		Text = [[<font color="rgb(0, 255, 0)">Green</font>]]},
	{Id = "7",
		Color = Color3.fromRGB(0, 0, 255),
		Text = [[<font color="rgb(0, 0, 255)">Blue</font>]]},
	{Id = "8",
		Color = Color3.fromRGB(170, 0, 255),
		Text = [[<font color="rgb(170, 0, 255)">Violet</font>]]},
	{Id = "9",
		Color = Color3.fromRGB(255, 0, 255),
		Text = [[<font color="rgb(255, 0, 255)">Pink</font>]]},
	{Id = "10",
		Color = Color3.fromRGB(27, 42, 53),
		Text = [[<stroke color="rgb(255, 255, 255)" joins="round" thickness="1" transparency="0.75"><font color="rgb(27, 42, 53)">Black</font></stroke>]]},
	{Id = "11",
		Color = Color3.fromRGB(17, 17, 17),
		Text = [[<stroke color="rgb(255, 255, 255)" joins="round" thickness="1" transparency="0.75"><font color="rgb(17, 17, 17)">Really black</font></stroke>]]}

} -- Array of fonts, please fix this. I really hate this.

return choices