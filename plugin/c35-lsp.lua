local generator = vim.api.nvim_get_runtime_file('generate-c35-cmy-schema.py', false)[1]

local function setup_schema(uri)
  for _, client in pairs(vim.lsp.get_clients()) do
    if client['name'] == 'yamlls' then
      local settings = client['config']['settings']
      settings['yaml']['schemas'] = {}
      settings['yaml']['schemas'][uri] = '*'

      client:notify('workspace/didChangeConfiguration', {settings=settings})
    end
  end

  vim.defer_fn(function() os.remove(uri) end, 3000)
end

local function generate_cmy_schema(fname)
  vim.system({'tempfile'}, function(obj)
    tmpfile = obj.stdout
    tmpfile = tmpfile:sub(1, #tmpfile-1)

    vim.system({'ya', 'tool', 'tt', 'python', generator, fname}, function(obj)
      if obj.code ~= 0 then
        error('Failed to generate CMY JSON schema: ' .. obj.stderr)
	return
      end

      local file = io.open(tmpfile, 'w')
      file:write(obj.stdout)
      file:close()

      setup_schema(tmpfile)
    end)
  end
  )
end

vim.api.nvim_create_user_command('CMYGenerateSchema', function() generate_cmy_schema(vim.api.nvim_buf_get_name(0)) end, {})
