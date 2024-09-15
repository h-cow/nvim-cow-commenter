# nvim-cow-commenter

A NeoVim plugin for toggling comments in code.

## Why
I didn't like the comment toggle plugins I was using because it used keybindings I used else where and felt to large with multiple features.
- Super tiny code
- No default keyboard shortcuts

## Install

### Lazy
Install using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "h-cow/nvim-cow-commenter",
    config = function()
        require("nvim-cow-commenter").setup({
            filetypes = {
                javascript = "//",
                lua = "--",
                tmux = "#",
            }
        })

        vim.keymap.set('n', '<leader>cc', ':CowCommentToggle<CR>')
        vim.keymap.set('v', '<leader>cc', ':CowCommentToggle<CR>')
    end,
},
```
The only `filetypes` supported are the ones you put in the config above. To add a new programming language...
- Open a file
- Run `:set filetype` and copy the type printed out
- In the config above add add your `filetype` with the comment characters used to make a comment
- Example `rust = "//"`

