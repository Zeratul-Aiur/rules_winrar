# rules_winrar

Bazel rules for running winrar.

## Install

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_winrar",
    # See release page for latest version url and sha.
)

load("@rules_winrar//:repo.bzl", "winrar_repository")

winrar_repository(name = "winrar")
```

## Usage

Run winrar through bazel.

```sh
bazel run @winrar//:winrar -- a test.zip .\test\
```

## LICENSE

MIT
