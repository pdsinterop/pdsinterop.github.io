#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

# ==============================================================================
#                               RUN QA DOCKER
# ------------------------------------------------------------------------------
#/ This script runs the Docker equivalent of tools used in GitHub workflows.
#/
#/ It expects to be given a path that all the tools should be run on.
#/
#/ Usage:
#/
#/     run-qa-docker [options] <path>
#/
#/ Where:
#/
#/    <path>    Is the path of the directory to run the tools on.
#/
#/ Options:
#/
#/  -h, --help
#/          Display this help message.
#/  -j, --job
#/          Run only the specified job. To list available jobs, run with --list.
#/  -l, --list
#/          Lists available tools.
#   -n, --dry-run
#          Do not actually run the tools.
#  -q, --quiet, --silent
#          Display no output.
#  -s, --summary, --short
#          Only show a summary
#  -v, --version
#          Display the version of this script.
#  -v, --verbose
#          Display verbose output.
#/
#/ Usage example:
#/
#/     run-qa-docker /path/to/project
#/
# ===============================================================================

: readonly "${RESET_TEXT:=$(tput sgr0)}" # turn off all attributes
# ==============================================================================

# Avoid `tput` to mess up output in debug mode (bash -x)
if [[ $- == *x* ]]; then
    bRestoreX=true
    set +x
fi

# ==============================================================================
# Background colors
# ------------------------------------------------------------------------------
: readonly "${BACKGROUND_BLACK:=$(tput setab 0)}"
: readonly "${BACKGROUND_BLUE:=$(tput setab 4)}"
: readonly "${BACKGROUND_CYAN:=$(tput setab 6)}"
: readonly "${BACKGROUND_GREEN:=$(tput setab 2)}"
: readonly "${BACKGROUND_MAGENTA:=$(tput setab 5)}"
: readonly "${BACKGROUND_RED:=$(tput setab 1)}"
: readonly "${BACKGROUND_WHITE:=$(tput setab 7)}"
: readonly "${BACKGROUND_YELLOW:=$(tput setab 3)}"
# ==============================================================================

# ==============================================================================
# Foreground colors
# ------------------------------------------------------------------------------
: readonly "${COLOR_BLACK:=$(tput setaf 0)}"
: readonly "${COLOR_BLUE:=$(tput setaf 4)}"
: readonly "${COLOR_CYAN:=$(tput setaf 6)}"
: readonly "${COLOR_GREEN:=$(tput setaf 2)}"
: readonly "${COLOR_MAGENTA:=$(tput setaf 5)}"
: readonly "${COLOR_RED:=$(tput setaf 1)}"
: readonly "${COLOR_WHITE:=$(tput setaf 7)}"
: readonly "${COLOR_YELLOW:=$(tput setaf 3)}"
# ==============================================================================

# ==============================================================================
# Text attributes
# ------------------------------------------------------------------------------
: readonly "${TEXT_BOLD:=$(tput bold)}"       # turn on bold (extra bright) mode
: readonly "${TEXT_DIM:=$(tput dim)}"         # turn on half-bright mode
: readonly "${TEXT_INVERSE:=$(tput rev)}"     # turn on color inverse mode
: readonly "${TEXT_INVISIBLE:=$(tput invis)}" # turn on blank mode (characters invisible)
: readonly "${TEXT_ITALIC:=$(tput sitm)}"     # turn on italic mode
: readonly "${TEXT_UNDERLINE:=$(tput smul)}"  # turn on underline mode
# ==============================================================================

if [[ ${bRestoreX:=false} == true ]]; then
    bRestoreX=false
    set -x
fi

#action_compatibility_check_php() {
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#
#    echo " =====> PHP Compatibility Check"
#
#    # @TODO: Make PHP versions a parameter
#    for sVersion in 8.0 8.1 8.2 8.3 8.4 8.5;do
#        echo -n " -----> ${sVersion}"
#        {
#            docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/php-codesniffer \
#                -s \
#                --extensions=php \
#                --basepath=/code \
#                --ignore='*vendor/*' \
#                --runtime-set testVersion "${sVersion}" \
#                --standard=PHPCompatibility \
#                . \
#        && mark "$0"
#        }|| mark 1
#    done
#}
#
#action_json_lint_syntax() {
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#
#    echo -n " =====> # 01.preflight.json.lint-syntax.yml"
#
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/jsonlint \
#        find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" \
#            -not -path '*/.git/*' \
#            -not -path '*/node_modules/*' \
#            -not -path '*/vendor/*' \
#            -name '*.json' \
#            -type f \
#            -exec jsonlint --quiet {} \; \
#        && mark "$0"
#    }|| mark 1
#}

lint_github_action() {
    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"

    echo -n " =====> GitHub Action (GHA) Linting"

    {
        docker run --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' rhysd/actionlint -color \
            && mark "$?"
    } || mark 1
}

#action_lint_markdown() {
#    echo -n " =====> Markdown Linting"
#
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/remark-lint \
#            remark \
#                --ignore-pattern='*/vendor/*' \
#                --rc-path=.config/.remarkrc \
#                --silent \
#            . \
#        && mark "$0"
#    } || mark 1
#}
#
#action_spellcheck_markdown() {
#    echo -n " =====> Markdown Spellcheck"
#
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/markdown-spellcheck \
#        mdspell \
#            --en-us \
#            --ignore-numbers \
#            --report \
#            '**/*.md' '!**/node_modules/**/*.md' '!**/vendor/**/*.md' \
#        && mark "$0"
#    } || mark 1
#}
#
#action_php_lint_syntax() {
#    echo " =====> # 01.preflight.php.lint-syntax.yml"
#
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/php-linter \
#            parallel-lint . \
#            --exclude .git \
#            --exclude vendor \
#            --no-progress \
#            . \
#        && mark "$0"
#    }|| mark 1
#}
#
#action_lint_yaml() {
#    echo -n " =====> YAML Linting"
#
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/yamllint \
#            yamllint \
#            --config-file=.config/.yamllint\
#            . \
#        && mark "$0"
#    }|| mark 1
#}
#
#action_style_check_php() {
#    echo " =====> PHP Style Check"
#
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' pipelinecomponents/php-codesniffer \
#            -q \
#            -s \
#            --standard=PSR12 \
#            --report=summary \
#            --basepath=/code \
#            . \
#            --ignore='vendor' \
#        && mark "$0"
#    }|| mark 1
#}
#
#action_validate_php_composer() {
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#
#    echo -n " =====> Validate Composer files"
#
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/app" composer \
#        composer validate \
#            --check-lock \
#            --no-plugins \
#            --no-scripts \
#            --strict \
#        && mark "$0"
#    }|| mark 1
#}
#
#action_validate_php_dependencies() {
#    local -r sWorkingDirectory="${1?One parameter required: <working-directory>}"
#
#    echo -n " =====> Validate Composer Dependencies"
#
#    {
#        docker run -it --rm --volume "${sWorkingDirectory}:/app" composer \
#        composer audit \
#            --abandoned=report \
#            --locked \
#            --no-dev \
#            --no-plugins \
#            --no-scripts \
#        && mark "$0"
#    }|| mark 1
#}

run() {
    local sCommand sDockerImage sMessage sWorkingDirectory

    readonly sWorkingDirectory="${1?Four parameters required: <working-directory> <message> <docker-image> <command> [parameters]}"
    readonly sMessage="${2?Four parameters required: <working-directory> <message> <docker-image> <command> [parameters]}"
    readonly sDockerImage="${3?Four parameters required: <working-directory> <message> <docker-image> <command> [parameters]}"
    sCommand="${4?Four parameters required: <working-directory> <message> <docker-image> <command> [parameters]}"

    if [[ ${sCommand} == *".config/"* ]]; then
        local sConfigFile
        sConfigFile="$(echo "${sCommand}" | grep -oP '\.config\/\K[^ ]+')"
        if [ ! -f "${sWorkingDirectory}/.config/${sConfigFile}" ]; then
            echo " =====> ${TEXT_BOLD}${sMessage}${RESET_TEXT} ⏭️"
            echo "        ${TEXT_DIM}Required config file not found: '.config/${sConfigFile}'${RESET_TEXT}"
            return 0
        fi
    fi

    echo -n " =====> ${TEXT_BOLD}${sMessage}${RESET_TEXT} "
    {
        {
            # If command contains PHPUnit calls, we need to set `--env 'XDEBUG_MODE=coverage'`
            if [[ ${sCommand} == *"phpunit"* ]]; then
                docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' \
                    --env 'XDEBUG_MODE=coverage' \
                    --user "$(id -u ${USER}):$(id -g ${USER})" \
                    "${sDockerImage}" sh -c "${sCommand}"
            else
                docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' \
                    --user "$(id -u ${USER}):$(id -g ${USER})" \
                    "${sDockerImage}" sh -c "${sCommand}"
            fi
        } && mark "$?"
    } || mark 1
}

run_matrix() {
    local sCommand sDockerImage sMessage sVersion sWorkingDirectory

    readonly sWorkingDirectory="${1?Four parameters required: <working-directory> <message> <docker-image> <command>}"
    readonly sMessage="${2?Four parameters required: <working-directory> <message> <docker-image> <command>}"
    readonly sDockerImage="${3?Four parameters required: <working-directory> <message> <docker-image> <command>}"
    sCommand="${4?Four parameters required: <working-directory> <message> <docker-image> <command>}"

    if [[ ${sCommand} == *".config/"* ]]; then
        local sConfigFile
        sConfigFile="$(echo "${sCommand}" | grep -oP '\.config\/\K[^ ]+')"
        if [ ! -f "${sWorkingDirectory}/.config/${sConfigFile}" ]; then
            echo " =====> ${TEXT_BOLD}${sMessage}${RESET_TEXT} ⏭️"
            echo "        ${TEXT_DIM}Required config file not found: '.config/${sConfigFile}'${RESET_TEXT}"
            return 0
        fi
    fi

    echo " =====> ${TEXT_BOLD}${sMessage}${RESET_TEXT}"

    # @CHECKME: Make PHP versions a parameter?
    # for sVersion in 8.0 8.1 8.2 8.3 8.4 8.5;do

    for sVersion in 8.0 8.1 8.2 8.3; do
        # Replace any occurance of `${{ matrix.php }}` in sCommand= with the PHP version
        sCommand="${sCommand//\${{ matrix.php \}\}/${sVersion}}"

        echo -n " -----> ${sVersion} "
        {
            {
                # If command contains PHPUnit calls, we need to set `--env 'XDEBUG_MODE=coverage'`
                if [[ ${sCommand} == *"phpunit"* ]]; then
                    docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' \
                        --env 'XDEBUG_MODE=coverage' \
                        --user "$(id -u ${USER}):$(id -g ${USER})" \
                        "${sDockerImage}" sh -c "${sCommand}"
                else
                    docker run -it --rm --volume "${sWorkingDirectory}:/code" --workdir='/code' \
                        --user "$(id -u ${USER}):$(id -g ${USER})" \
                        "${sDockerImage}" sh -c "${sCommand}"
                fi

            } && mark "$?"
        } || mark 1
    done
}

run_qa_docker() {

    all_jobs() {
        local sCommand sWorkingDirectory

        readonly sWorkingDirectory="${1?One parameter required: <working-directory>}"

        # CHECKME: Does Alpine work for bash syntax check?
        # CHECKME: does '"*"' work? OR should we use "'*'"?

        # 01.preflight.json.lint-syntax.yml
        run "${sWorkingDirectory}" 'JSON Syntax Linting' 'pipelinecomponents/jsonlint' \
            'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -name "*.json" -type f -exec jsonlint --quiet {} \;'
        # 01.preflight.php.lint-syntax.yml
        sCommand='parallel-lint --no-progress --exclude ./.git --exclude ./vendor .'
        if [ -d "${sWorkingDirectory}/solid" ]; then
            sCommand="${sCommand//vendor/solid\/vendor}"
        fi
        run "${sWorkingDirectory}" 'PHP Syntax Linting' 'pipelinecomponents/php-linter' "${sCommand}"
        # 01.preflight.shell.lint-syntax.yml
        run "${sWorkingDirectory}" 'Shell Syntax Linting' 'bash' \
            'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -name "*.sh" -print0 | xargs -0 -P"$(nproc)" -I{} bash -n "{}"'
        # 01.preflight.xml.lint-syntax.yml
        run "${sWorkingDirectory}" 'XML Linting' 'pipelinecomponents/xmllint' \
            'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -iname "*.xml" -type f -print0 | xargs -0 -r -n1 xmllint --noout'
        # 01.preflight.yaml.lint.yml
        run "${sWorkingDirectory}" 'YAML Linting' 'pipelinecomponents/yamllint' \
            'yamllint --config-file=.config/.yamllint .'
        # 01.quality.markdown.lint-syntax.yml
        run "${sWorkingDirectory}" 'Markdown Linting' 'pipelinecomponents/remark-lint' \
            'remark --rc-path=.config/.remarkrc --ignore-pattern="**/vendor/**/*.md" .'
        # 01.quality.php.validate.dependencies-file.yml
        sCommand='composer validate --check-lock --no-plugins --no-scripts --strict --quiet'
        if [ -d "${sWorkingDirectory}/solid" ]; then
            sCommand="${sCommand} --working-dir=solid/"
        fi
        run "${sWorkingDirectory}" 'Validate dependencies file' 'composer' "${sCommand}"
        # 02.test.php.test-unit.yml
        run "${sWorkingDirectory}" 'PHP Unit Tests' 'pipelinecomponents/phpunit:0.32.1' \
            'bin/phpunit --configuration .config/phpunit.xml.dist'
        # 03.quality.docker.lint.yml
        run "${sWorkingDirectory}" 'Dockerfile Linting' 'pipelinecomponents/hadolint' \
            'hadolint --config .config/hadolint.yml Dockerfile'
        # 03.quality.php.lint-quality.yml
        run "${sWorkingDirectory}" 'PHP Quality Linting' 'pipelinecomponents/php-codesniffer' \
            'phpcs -s --extensions=php --ignore="*vendor/*" --standard=.config/phpcs.xml.dist .'
        # 03.quality.php.lint-version-compatibility.yml
        run_matrix "${sWorkingDirectory}" 'PHP Version Compatibility' 'pipelinecomponents/php-codesniffer' \
            'phpcs -s --extensions=php --ignore="*vendor/*" --runtime-set testVersion ${{ matrix.php }} --standard=PHPCompatibility .'
        # 03.quality.php.scan.dependencies-vulnerabilities.yml
        sCommand='composer audit --abandoned=report --no-dev --no-plugins --no-scripts --quiet'
        if [ -d "${sWorkingDirectory}/solid" ]; then
            sCommand="${sCommand} --working-dir=solid/"
        fi
        if grep --silent 'composer.lock' "${sWorkingDirectory}/.gitignore"; then
            sCommand="${sCommand} --locked"
        fi
        run "${sWorkingDirectory}" 'Scan Dependencies Vulnerabilities' 'composer' "${sCommand}"

        # 03.quality.shell.lint.yml
        run "${sWorkingDirectory}" 'Shell Quality Linting' 'pipelinecomponents/shellcheck' \
            'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -name "*.sh" -type f  -print0 | xargs -0 -r -n1 shellcheck -x'

        # 00.quality.github-action.lint.yml
        lint_github_action "${sWorkingDirectory}"
    }

    mark() {
        local -r sMark="${1?One parameter required: <check-value>}"

        if [ "${sMark}" == "0" ]; then
            echo " ✅"
        else
            echo " ❌"
        fi
    }

    local sCommand sTool sPath
    local bSummaryOnly=false bVerbose=false

    parse_arguments() {
        local sParameter

        while [[ $# -gt 0 ]]; do
            sParameter="${1}"
            shift

            #            # Strip first one or two dashes
            #            sParameter="${sParameter#-}"

            # If the parameter has two dashes but only one letter, strip the first dash
            if [ "${sParameter:0:2}" == "--" ] && [ "${#sParameter}" -eq 3 ]; then
                sParameter="${sParameter:1}"
            fi

            case ${sParameter} in
                -\? | -h | --help)
                    # Displays all lines in main script that start with '#/'
                    grep '^#/' < "${0}" | cut -c4-
                    exit 0
                    ;;
                -j | --job)
                    # If the next argument is not an option, assume it is the job name
                    if [[ $# -gt 0 ]] && [[ ${1:0:1} != "-" ]]; then
                        sTool="${1}"
                        shift
                    else
                        echo -e "ERROR: Missing job name\nTo list available jobs, run:\n\t$0 --list"
                        exit 1
                    fi
                    ;;
                -j=* | --job=*)
                    # split the job from the parameter
                    sTool="${sParameter#*=}"
                    ;;
                -l | --list)
                    echo -e "Available checks:\n"
                    grep '#job' < "${0}" | grep -v 'grep\|##' | cut -d ')' -f1 | cut -c8- | sort
                    exit 0
                    ;;
                -q | --quiet | --silent)
                    bSummaryOnly=true
                    ;;
                -s | --summary | --short)
                    bSummaryOnly=true
                    ;;
                -v | --verbose)
                    bVerbose=true
                    ;;
                *)
                    if [[ ${sPath} == '' ]]; then
                        sPath="$(realpath "${sParameter}")"
                        readonly sPath
                    fi
                    ;;
            esac
        done
    }

    : "${1?One parameter required: <path-to-scan>}"
    sPath=''
    sTool=''

    parse_arguments "${@}"

    # If no job name is given, run all jobs. Otherwise, only run given job
    if [[ ${sTool} != '' ]]; then
        case ${sTool} in
            github-action.lint) #job
                lint_github_action "${sPath}"
                ;;
            json.lint-syntax) #job
                run "${sPath}" 'JSON Syntax Linting' 'pipelinecomponents/jsonlint' \
                    'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -name "*.json" -type f -exec jsonlint --quiet {} \;'
                ;;
            php.lint-syntax) #job
                sCommand='parallel-lint --no-progress --exclude ./.git --exclude ./vendor .'
                if [ -d "${sPath}/solid" ]; then
                    sCommand="${sCommand//vendor/solid\/vendor}"
                fi
                run "${sPath}" 'PHP Syntax Linting' 'pipelinecomponents/php-linter' "${sCommand}"
                ;;
            shell.lint-syntax) #job
                run "${sPath}" 'Shell Syntax Linting' 'bash' \
                    'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -regex ".*\.\(ba\)\?sh" -print0 | xargs -0 -P"$(nproc)" -I{} bash -n "{}"'
                ;;
            xml.lint-syntax) #job
                run "${sPath}" 'XML Linting' 'pipelinecomponents/xmllint' \
                    'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -iname "*.xml" -type f -print0 | xargs -0 -r xmllint --noout'
                ;;
            yaml.lint) #job
                run "${sPath}" 'YAML Linting' 'pipelinecomponents/yamllint' \
                    'yamllint --config-file=.config/.yamllint .'
                ;;
            markdown.lint-syntax) #job
                run "${sPath}" 'Markdown Linting' 'pipelinecomponents/remark-lint' \
                    'remark --rc-path=.config/.remarkrc --ignore-pattern="**/vendor/**/*.md" .'
                ;;
            php.validate.dependencies-file) #job
                sCommand='composer validate --check-lock --no-plugins --no-scripts --strict'
                if [ -d "${sPath}/solid" ]; then
                    sCommand="${sCommand} --working-dir=solid/"
                fi
                run "${sPath}" 'Validate dependencies file' 'composer' "${sCommand}"
                ;;
            php.test-unit) #job
                run "${sPath}" 'PHP Unit Tests' 'pipelinecomponents/phpunit:0.32.1' \
                    'bin/phpunit --configuration .config/phpunit.xml.dist'
                ;;
            docker.lint) #job
                run "${sPath}" 'Dockerfile Linting' 'pipelinecomponents/hadolint' \
                    'hadolint --config .config/hadolint.yml Dockerfile'
                ;;
            php.lint-quality) #job
                run "${sPath}" 'PHP Quality Linting' 'pipelinecomponents/php-codesniffer' \
                    'phpcs -s --extensions=php --ignore="*vendor/*" --standard=.config/phpcs.xml.dist .'
                ;;
            php.lint-version-compatibility) #job
                run_matrix "${sPath}" 'PHP Version Compatibility' 'pipelinecomponents/php-codesniffer' \
                    'phpcs -s --extensions=php --ignore="*vendor/*" --runtime-set testVersion ${{ matrix.php }} --standard=PHPCompatibility .'
                ;;
            php.scan.dependencies-vulnerabilities) #job
                local sCommand='composer audit --abandoned=report --no-dev --no-plugins --no-scripts --quiet'
                if [ -d "${sPath}/solid" ]; then
                    sCommand="${sCommand} --working-dir=solid/"
                fi
                if grep --silent 'composer.lock' "${sPath}/.gitignore"; then
                    sCommand="${sCommand} --locked"
                fi
                run "${sPath}" 'Scan Dependencies Vulnerabilities' 'composer' "${sCommand}"
                ;;
            shell.lint) #job
                run "${sPath}" 'Shell Quality Linting' 'pipelinecomponents/shellcheck' \
                    'find . -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -name "*.sh" -type f -print0 | xargs -0 -r -n1 shellcheck -x'
                ;;

            *)
                echo -e "ERROR: Unknown job ${sTool}\nTo list available jobs, run:\n\t$0 --list"
                exit 1
                ;;
        esac
    else
        all_jobs "${sPath}"
    fi
    ##        case ${sTool} in
    ##            compat) #job
    ##                action_compatibility_check_php "${sPath}"
    ##            ;;
    ##            composer) #job
    ##                action_validate_php_composer "${sPath}"
    ##            ;;
    ##            json) #job
    ##                action_json_lint_syntax "${sPath}"
    ##            ;;
    ##            markdown) #job
    ##                action_lint_markdown "${sPath}"
    ##            ;;
    ##            php) #job
    ##                action_php_lint_syntax "${sPath}"
    ##            ;;
    ##            style) #job
    ##                action_style_check_php "${sPath}"
    ##            ;;
    ##            yaml) #job
    ##                action_lint_yaml "${sPath}"
    ##            ;;
    ##            *)
    ##                echo -e "ERROR: Unknown job echo -n " =====> ${sTool}\nTo list available jobs, run:\n\t$0 --list""
    ##                exit 1
    ##            ;;
    ##        esac
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f run_qa_docker
else
    run_qa_docker "${@}"
fi
