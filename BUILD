#load("@io_bazel_rules_go//go:def.bzl", "go_prefix", "gazelle")
load("@io_bazel_rules_go//go:def.bzl", "gazelle")

#go_prefix("testbazel/github.com/hubris/solrules")

# bazel rule definition
gazelle(
  prefix = "testbazel/github.com/hubris/solrules",
  name = "gazelle",
  command = "fix",
)

exports_files(["soltest"])

filegroup(
    name = "all",
    srcs = [
        "//soltest",
    ]
)
