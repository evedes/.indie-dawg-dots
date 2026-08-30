-- JDTLS needs project-specific startup and extension bundles, so Java is kept
-- out of lsp/*.lua and started through nvim-jdtls for every Java buffer.
require("util.lazy").on_filetype("java", function(first_event)
  vim.pack.add({
    "https://codeberg.org/mfussenegger/nvim-jdtls",
  })

  local jdtls = require("jdtls")
  local java_tools = vim.fn.stdpath("data") .. "/java"

  local function add_test_bundles(bundles)
    local excluded = {
      ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
      ["jacocoagent.jar"] = true,
    }
    for _, jar in ipairs(vim.fn.glob(java_tools .. "/vscode-java-test/server/*.jar", false, true)) do
      if not excluded[vim.fs.basename(jar)] then
        table.insert(bundles, jar)
      end
    end
  end

  local function bundles()
    local result = vim.fn.glob(
      java_tools .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
      false,
      true
    )
    add_test_bundles(result)
    return result
  end

  local root_markers = {
    "mvnw",
    "gradlew",
    "pom.xml",
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    ".git",
  }

  local function start(bufnr)
    if vim.fn.executable("jdtls") ~= 1 then
      vim.notify("jdtls is missing; run nvim-doctor install", vim.log.levels.ERROR)
      return
    end

    local root_dir = vim.fs.root(bufnr, root_markers)
    if not root_dir then
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    end
    local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root_dir):sub(1, 16)

    jdtls.start_or_attach({
      name = "jdtls",
      cmd = { "jdtls", "-data", workspace },
      root_dir = root_dir,
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      settings = {
        java = {
          configuration = { updateBuildConfiguration = "interactive" },
          contentProvider = { preferred = "fernflower" },
          eclipse = { downloadSources = true },
          maven = { downloadSources = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          signatureHelp = { enabled = true },
        },
      },
      init_options = { bundles = bundles() },
      on_attach = function(_, attached_bufnr)
        if #bundles() > 0 then
          jdtls.setup_dap({ hotcodereplace = "auto" })
        end

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = attached_bufnr, desc = desc })
        end
        map("n", "<leader>co", jdtls.organize_imports, "Organize Java imports")
        map("n", "<leader>cv", jdtls.extract_variable, "Extract Java variable")
        map("v", "<leader>cv", function()
          jdtls.extract_variable(true)
        end, "Extract Java variable")
        map("n", "<leader>ck", jdtls.extract_constant, "Extract Java constant")
        map("v", "<leader>ck", function()
          jdtls.extract_constant(true)
        end, "Extract Java constant")
        map("v", "<leader>cm", function()
          jdtls.extract_method(true)
        end, "Extract Java method")
        map("n", "<leader>tc", jdtls.test_class, "Run Java test class")
        map("n", "<leader>tn", jdtls.test_nearest_method, "Run nearest Java test")
      end,
    })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function(ev)
      start(ev.buf)
    end,
  })
  start(first_event.buf)
end)
