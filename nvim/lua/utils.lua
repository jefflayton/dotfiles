local M = {}

function M.deno_or_node(deno, node)
    local fname = vim.api.nvim_buf_get_name(0)

    local deno_wd = nil
    if vim.uv.fs_stat(fname) ~= nil then
        deno_wd = vim.fs.dirname(
            vim.fs.find({ "deno.json", "deno.jsonc" }, { path = fname, upward = true })[1])
    end

    if deno_wd ~= nil then
        return deno
    else
        return node
    end
end

return M
