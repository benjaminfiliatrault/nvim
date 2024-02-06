require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")

-- Set keymaps to control the debugger
vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
    require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)


require("dap-vscode-js").setup({
    -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    -- which adapters to register in nvim-dap
    adapters = {
        'chrome',
        'pwa-node',
        'pwa-chrome',
        'pwa-msedge',
        'node-terminal',
        'pwa-extensionHost',
        'node',
    },
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})


local js_based_languages = { "typescript", "javascript", "typescriptreact" }

local function find_node_pid()
    local res = require('dap.utils').get_processes({ filter = "--inspect"})
    return res.pid
end

for _, language in ipairs(js_based_languages) do
    require("dap").configurations[language] = {
        {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- attach to an already running node process with --inspect flag
            -- default port: 9222
            request = "attach",
            -- Node process id where node --inpect is used
            processId = find_node_pid,
            -- name of the debug action
            name = "Attach debugger to existing `node --inspect` process",
            -- for compiled languages like TypeScript or Svelte.js
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
            -- path to src in vite based projects (and most other projects as well)
            cwd = "${workspaceFolder}/src",
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
        },
    }
end


-- DAPUI configurations
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local function inspect_floating()
    dapui.float_element('5')
end

vim.keymap.set('n', '<leader>ui', require 'dapui'.toggle)
vim.keymap.set('n', '<leader>K', require 'dapui'.float_element)

