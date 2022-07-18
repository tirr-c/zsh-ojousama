# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# Copyright (c) 2022 Wonwoo Choi

# According to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

# Then ${0:h} to get plugin's directory

if [[ ${zsh_loaded_plugins[-1]} != */zsh-ojousama && -z ${fpath[(r)${0:h}]} ]] {
    fpath+=( "${0:h}" )
}

# Standard hash for plugins, to not pollute the namespace
typeset -gA Plugins
Plugins[ZSH_OJOUSAMA_DIR]="${0:h}"

function .ojou_accept-line() {
    local stripped_buffer=${BUFFER%%[[:blank:]]##}
    if [[ -n $stripped_buffer ]]; then
        if [[ $LANG == *.UTF-8 ]]; then
            PREDISPLAY='お'
            POSTDISPLAY='ですわ〜'
        else
            PREDISPLAY='o'
            POSTDISPLAY=' desuwa~'
        fi
    fi

    zle .ojou_orig_accept-line
}

function zsh-ojousama_plugin_unload() {
    zle -A .ojou_orig_accept-line accept-line
    zle -D .ojou_orig_accept-line
}

zsh-ojousama_plugin_unload 2>/dev/null

zle -A accept-line .ojou_orig_accept-line
zle -N accept-line .ojou_accept-line

# Use alternate vim marks [[[ and ]]] as the original ones can
# confuse nested substitutions, e.g.: ${${${VAR}}}

# vim:ft=zsh:tw=80:sw=4:sts=4:et:foldmarker=[[[,]]]
