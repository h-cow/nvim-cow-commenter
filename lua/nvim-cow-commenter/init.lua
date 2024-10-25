-- -------------------- Comment Toggle --------------------
local fileTypes
local function setup(settings)
	fileTypes = settings.filetypes
end

function insert_at(str, insert_str, index)
    local start = string.sub(str, 1, index - 1)
    local ending = string.sub(str, index)
    return start .. insert_str .. ending
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
		local indicator = fileTypes[fileType]
		local indicatorLen = string.len(indicator)
		local firstCharI = string.find(lines[1], "%S") or 1
		local lineFirstChars = string.sub(lines[1], firstCharI, firstCharI+indicatorLen-1)

		if (lineFirstChars == indicator) then
			local lineNumber = line_start
			for _,line in pairs(lines) do
				local charI = string.find(line, "%S") or 1
				if (charI >= 1) then
					local isLineCommented = string.sub(line, charI, charI+indicatorLen-1) == indicator
					if isLineCommented then
						if (charI == 1) then
							vim.fn.setline(lineNumber, string.sub(line, (indicatorLen+1)))
						elseif (charI > 1) then
							vim.fn.setline(lineNumber, string.sub(line, 1, charI-1)..string.sub(line, (charI + indicatorLen)))
						end
					end
				end
				lineNumber = lineNumber + 1
			end
		else
			local lineNumber = line_start
			for _,line in pairs(lines) do
				local charI = string.find(line, "%S") or 1
				local newLine = insert_at(line, indicator, charI)
				vim.fn.setline(lineNumber, newLine)

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
