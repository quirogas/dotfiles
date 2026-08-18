return {
  configurations = {
    go = {
      {
        type = "go",
        name = "Launch File",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Launch Package",
        request = "launch",
        program = "${fileDirname}",
      },
      {
        type = "go",
        name = "Attach (Remote)",
        mode = "remote",
        request = "attach",
      },
    },
  },
}
