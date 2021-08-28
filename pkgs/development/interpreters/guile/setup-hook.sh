addGuileLibPath () {
    addToSearchPath GUILE_LOAD_PATH          "$1/share/guile/site/@versionMajMin@"
    addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site/@versionMajMin@"

    addToSearchPath GUILE_LOAD_PATH          "$1/share/guile/site"
    addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site"

    addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/@versionMajMin@/ccache"
    addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/@versionMajMin@/site-ccache"
}

addEnvHooks "$hostOffset" addGuileLibPath
