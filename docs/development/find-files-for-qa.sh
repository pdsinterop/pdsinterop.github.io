#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

# @FIXME: Add check for config files required by specific tools
# - Dockerfile files: .config/hadolint.yaml (hadolint)
#
# - Markdown files:
#   - `.spelling` (markdown-spellcheck)
#   - `.config/.remarkrc` (remark-lint)
#
# - PHP files:
#   - `.config/phpcs.xml.dist` (phpcs)
#   - `.config/phpunit.xml.dist` (phpunit)
#
# - YAML files: `.config/.yamllint` (yamllint)
#
# ? `.config/.github_changelog_generator/

find_files_for_qa() {
    local bVerbose sName sPath sResult

    sPath="${1?One parameter required: <path>}"
    bVerbose="${2:-}"

    if [[ "${sPath}" == '--verbose' && ${#} -eq 1 ]]; then
        echo "$0: line ${LINENO}: 1: One parameter required: <path>"
        return 1
        #elif verbose is set, then set it to true
    elif [[ "${sPath}" == '--verbose' ]]; then
        readonly sPath="${bVerbose}"
        readonly bVerbose=true
    elif [[ "${bVerbose}" == '--verbose' ]]; then
        readonly sPath
        readonly bVerbose=true
    else
        readonly sPath
        readonly bVerbose=false
    fi

    for sName in flysystem-nextcloud flysystem-rdf php-solid-auth php-solid-crud php-solid-pubsub-server php-solid-server solid-nextcloud; do
        echo -e " =====> ${sName}"

        sResult="$(find "${sPath}/${sName}" -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' -name 'Dockerfile')"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> Dockerfile"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        sResult="$(find "${sPath}/${sName}" -not -name 'codealike.json' -not -name 'composer.json' -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' -name '*.json')"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> JSON"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        sResult="$(find "${sPath}/${sName}" -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' -name '*.md')"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> Markdown"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        sResult="$(find "${sPath}/${sName}" -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' -name '*.php')"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> PHP"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        sResult="$(find "${sPath}/${sName}" -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' -name '*.sh')"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> Shell"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        sResult="$(find "${sPath}/${sName}" -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' -name '*.xml')"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> XML"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        sResult="$(find "${sPath}/${sName}" -not -name '_config.yml' -not -path '*/vendor/*' -not -path '*/.github/*' -not -path '*/.idea/*' \( -name '*.yml' -o -name '*.yaml' \))"
        if [[ "${sResult}" != '' ]]; then
            echo -e " -----> YML"
            if [[ "${bVerbose}" == true ]]; then
                echo -e "${sResult}"
            fi
        fi

        echo ''
    done
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f find_files_for_qa
else
    find_files_for_qa "${@}"
fi
