windows_build_file_content = """
alias(
    name = "winrar",
    visibility = ["//visibility:public"],
    actual = "{WINRAR_VERSION}/winrar.exe",
)
"""

_known_archives = {
    "5.9.1": {
        "windows64": struct(
            urls = [
                "http://pan.aqrose.com/seafhttp/files/e53f6fb6-6fc2-4496-a75c-05723bf48fc7/WinRAR5.9.1_x64.zip",
                "https://github.com/Zeratul-Aiur/rules_winrar/releases/download/v0.1.0/WinRAR5.9.1_x64.zip",
            ],
            strip_prefix = "WinRAR",
            sha256 = "0890cdcd98f18fb6268191e977f55c9eec662ef03b9613c615aa9ac0bfb14fa0",
            build_file_content = windows_build_file_content,
        ),
    },
}

def _os_key(os):
    if os.name.find("windows") != -1:
        return "windows64"
    return os.name

def _get_winrar_archive(rctx):
    winrar_version = rctx.attr.winrar_version
    archives = _known_archives.get(winrar_version)

    if not archives:
        fail("rules_winrar unsupported winrar_version: {}".format(winrar_version))

    archive = archives.get(_os_key(rctx.os))

    if not archive:
        fail("rules_winrar unknown winrar version / operating system combo: winrar_version={} os=".format(winrar_version, rctx.os.name))

    return archive

def _winrar_repository(rctx):
    archive = _get_winrar_archive(rctx)
    rctx.download_and_extract(archive.urls, output = rctx.attr.winrar_version, stripPrefix = archive.strip_prefix, sha256 = archive.sha256)
    rctx.file("BUILD.bazel", archive.build_file_content.format(winrar_VERSION = rctx.attr.winrar_version), executable = False)

winrar_repository = repository_rule(
    implementation = _winrar_repository,
    attrs = {
        "winrar_version": attr.string(
            default = "5.9.1",
            values = _known_archives.keys(),
        ),
    },
)
