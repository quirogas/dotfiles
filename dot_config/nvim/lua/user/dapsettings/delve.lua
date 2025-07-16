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
        type = "go",
        name = "Launch file",
        request = "launch",
        mode = "debug",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
        outputMode = "remote",
      },
    },
  },
}

