# block-highlight.nvim


A small plugin for neovim to highlight within or around a block. Based on tree-sitter and lua.

It provides a function that creates a visual selection inside or around objects.<br/>

![image](https://user-images.githubusercontent.com/80820813/197793147-31fd8822-482c-4f27-8704-09b24c9caa3c.png)  <br/>

With the cursor on a string, the string will be highlighted.

![image](https://user-images.githubusercontent.com/80820813/197793270-4ae84c51-9d4e-42a2-8557-f44993af8945.png)  <br/>

Otherwise the next surrounding brackets will be selected.

![image](https://user-images.githubusercontent.com/80820813/197793473-598d3ab6-44e3-402c-8a02-403c18cc4f36.png)  <br/>


## Installation

<a href="https://github.com/nvim-treesitter/nvim-treesitter" target="_blank" rel="noopener noreferrer"> Tree-sitter is required</a> <br/>

Packer:

```
use 'ccbiozhaw/block-highlight.nvim'
```

## Setup:

for your keymaps.lua

```
vim.keymap.set("n", "<leader>vib", "<cmd>lua require('block-highlight').select('inside')<CR>, {silent = true})
vim.keymap.set("n", "<leader>vab", "<cmd>lua require('block-highlight').select('around')<CR>, {silent = true})
```
