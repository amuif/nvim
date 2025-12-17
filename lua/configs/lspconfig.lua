require("nvchad.configs.lspconfig").defaults()

vim.diagnostic.config {
  virtual_text = true,
  float = {
    border = "rounded",
    source = "always",
    focusable = true,
  },
}

local nvlsp = require "nvchad.configs.lspconfig"
-- local util = require "lspconfig.util"

-- Shared LSP options
local base_opts = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

-- List of servers using mostly default config
local servers = {
  "html",
  "cssls",
  "vtsls",
  "tailwindcss",
  "eslint",
  -- "astro",
  -- "intelephense",
  "emmet_language_server",
  "prismals",
}

for _, lsp in ipairs(servers) do
  local opts = vim.deepcopy(base_opts)

  if lsp == "tailwindcss" then
    opts.filetypes = {
      "html",
      "php",
      "blade",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
    }
    opts.init_options = {
      userLanguages = {
        php = "html",
      },
    }
  end

  vim.lsp.config(lsp, opts)
  vim.lsp.enable(lsp)
end

-- Svelte LSP setup (corrected for new API)
vim.lsp.config(
  "svelte",
  vim.tbl_deep_extend("force", base_opts, {
    filetypes = { "svelte" },
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)

      -- Refresh Svelte language server on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.svelte", "*.js", "*.ts" },
        callback = function(ctx)
          if client and client.running then
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
          end
        end,
      })
    end,
  })
)
vim.lsp.enable "svelte"

-- Go LSP setup
-- vim.lsp.config("gopls", vim.tbl_deep_extend("force", base_opts, {
--   cmd = { "gopls" },
--   filetypes = { "go", "gomod", "gowork", "gotmpl" },
--   root_dir = util.root_pattern("go.work", "go.mod", ".git"),
--   settings = {
--     gopls = {
--       completeUnimported = true,
--       usePlaceholders = true,
--       analyses = {
--         unusedparams = true,
--       },
--     },
--   },
-- }))
-- vim.lsp.enable("gopls")
--
-- Python LSP setup
-- vim.lsp.config("pyright", vim.tbl_deep_extend("force", base_opts, {
--   filetypes = { "python" },
-- }))
-- vim.lsp.enable("pyright")
--
-- -- Optional: auto-attach keymaps or buffer options
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
--   callback = function(args)
--     local bufnr = args.buf
--     vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
--   end,
-- })
