load(
    "@io_bazel_rules_go//go:def.bzl",
    "GoLibrary",
    "GoSource",
    "go_context",
)
load("@bazel_skylib//:lib.bzl", "shell")

GoAbiCompiler = provider()

solidity_filetype = FileType([".sol"])
AbiCompiler = provider()

def _sol2go_impl(ctx):
  in_file = ctx.files.src
  output = ctx.outputs.out
  script = ctx.files._script[0]
  abigen = ctx.executable._abigen

  go_files_out = []
  go_files_out.append(output)

  ctx.actions.run_shell(
      tools=[abigen, script],
      inputs=in_file,
      outputs=go_files_out,
      command="%s %s %s %s %s" % (script.path, in_file[0].path, abigen.path, output.path, ctx.attr.pkg))

  return [ AbiCompiler(go_file = [output]) ]


sol2go = rule(
  _sol2go_impl,
  provides = [AbiCompiler],
  attrs = {
    "pkg": attr.string(
        mandatory = True,
        doc = "Destination package",
    ),
    "src":  attr.label(allow_files=solidity_filetype),
    "deps": attr.label_list(
        providers = [GoLibrary]
    ),
    "_abigen": attr.label(
        default = "@com_github_ethereum_go_ethereum//cmd/abigen:abigen",
        cfg = "host",
        executable = True,
    ),
    "_script": attr.label(
        default = "//soltest/rules:sol2go.sh",
        allow_single_file = True,
    ),
  },
  outputs = {"out": "%{name}/%{src}.go"},
)
