-- -------------------- Comment Toggle --------------------
local fileTypes
local function setup(settings)
	fileTypes = settings.filetypes
end

local ToggleComments = function (args)
	local fileType = vim.bo.filetype
	if (args.line1 == nil or args.line2 == nil) then
		print("You need to have text selected")
	end
	local line_start = args.line1
	local line_end = args.line2
	if line_start > line_end then
		-- Swap line_start with line_end
		line_start = line_start + line_end
		line_end = line_start - line_end
		line_start = line_start - line_end
	end
	local lines = vim.fn.getline(line_start, line_end)

	if fileTypes[fileType] then
		local indicator = fileTypes[fileType] .. " "
		local indicatorLen = string.len(indicator)

		local lineFirstChars = string.sub(lines[1], 1, indicatorLen)
		if (lineFirstChars == indicator) then
			local lineNumber = line_start
			for _,line in pairs(lines) do
				local isLineCommented = string.sub(line, 1, indicatorLen) == indicator
				if isLineCommented then
					vim.fn.setline(lineNumber, string.sub(line, (indicatorLen+1)))
				end
				lineNumber = lineNumber + 1
			end
		else
			local lineNumber = line_start
			for _,line in pairs(lines) do
				vim.fn.setline(lineNumber, (indicator .. line))
				lineNumber = lineNumber + 1
			end
		end
	else
		print("fileType not supported for comment toggle")
	end
end

vim.api.nvim_create_user_command('CowCommentToggle', ToggleComments, {range = true})

return {
	setup = setup
}
