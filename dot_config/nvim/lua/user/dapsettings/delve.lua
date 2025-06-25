return {
  adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  },
  configurations = {
    go = {
      {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
        outputMode = "remote",
      },
      {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}",
        outputMode = "remote",
      },
      -- works with go.mod packages and sub packages
      {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
        outputMode = "remote",
      },
    },
  },
}
