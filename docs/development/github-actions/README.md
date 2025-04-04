
- @TODO: Document that when using `find`, `-print0` MUST be the last argument, and that `xargs` MUST use `-0` as an argument.

- @TODO: Explain `working-directory: "solid"` in the solid-nextcloud repo PHP GHA

- @TODO: Document the CHECKS SHOULD ALWAYS BE GREEN (✅) on the `main` branch!

- @TODO: Document the reason for `fail-fast: false` when `strategy.matrix` is used!

- @TODO: Explain that, when using docker://pipelinecomponent/*, the `with.options` MUST include the command that is being called.

- @TODO: Document that `continue-on-error: ${{ matrix.php < '8.1' || matrix.php > '8.4' }}` is not used, as (although the MR could still be merged) there would be a red cross ❌ in the PR checks. 

- @TODO: Document that EOL version do not have to be supported but MAY be in matrix as long as they do not fail 
        Support for failing EOL versions is, deppendant on effort/cost to support them

- @TODO: Explain why `find` uses `-name '*.sh'` instead of `\(-name '*.sh' -o -name '*.bash'\)`

# GitHub Actions

This repository contains building blocks to construct GitHub Actions (GHA) with

An effort has been made to create a CI/CD pipeline that is:

- **Performant**
  Runs only when needed, in as short a time as possible
- **Portable**
  Uses tools that can be run locally or on other CI/CD platforms
- **Reusable**
  Can be used in other projects with minimal changes

To achieve this certain choices have been made, for instance, using a Docker
container for the CI/CD pipeline (instead of a GitHub Action) or GitHub Actions
provided by Pipeline Components (as they can also be run locally and on other
CI/CD platforms).

This document contains these choices and other information regarding GHA.

## Available "Building blocks"

- _**TBD:** Explain files:
  - [ ] `00.header`
  - [ ] `01.preflight.json.lint-syntax`
  - [ ] `01.preflight.php.lint-syntax`
  - [ ] `01.preflight.php.validate.dependencies-file`
  - [ ] `01.preflight.xml.lint-syntax`
  - [ ] `01.preflight.yaml.lint`
  - [ ] `02.test.php.test-unit`
  - [ ] `03.quality.docker.lint`
  - [ ] `03.quality.markdown.lint-spelling`
  - [ ] `03.quality.markdown.lint-syntax`
  - [ ] `03.quality.php.lint-version-compatibility`
  - [ ] `03.quality.php.scan.dependencies-vulnerabilities`
  - [ ] `03.quality.shell.lint`

- _**TBD:** Explain:
  - Paths
  - Dependencies between jobs (in the same workflow file)
  - Dependencies between workflows (in separate files)

## Configuration

Instead of adding configuration as parameters to GHA calls, configuration files should be used where possible.

Configuration files (for GHA, CI, or other purposes) should live in the `.config` directory, unless explicitly stated otherwise in the projects README and/or CONTRIBUTING files.

This means that calls to tools that require configuration files include the path to the configuration file.

Examples of configuration files are:

- `.github_changelog_generator`
- `.remarkrc`
- `.yamllint`
- `phpcs.xml.dist`
- `phpunit.xml.dist`

Config files that can not be placed in the `.config` directory (for instance because the companion tool does not support this), should be placed in the root of the repository.

    @TODO: In later itteration, logic should be added to move these files to the root (from the `.config` directory) before the CI/CD pipeline is run.

Examples of these are:

- `.spelling`

## When to add what

Which GitHub Actions are used depends mostly on which programming or markup language is used.

For most of these language, the [rule of thumb](https://en.wiktionary.org/wiki/rule_of_thumb) is that if a language is present, GitHub Actions are added for quality control or other automation.

The list of languages contains, but is not limited to:

<sup>
  <input type="checkbox" checked disabled> Indicates workflows are available<br>
  <input type="checkbox"> Indicates workflows are not (yet) available
</sup>

- [ ] CSS (`*.css`, `*.scss`)
- [x] Docker (`Dockerfile`, `.dockerignore`)
- [ ] HTML (`*.html`)
- [ ] Images (`*.png`, `*.jpg`, `*.svg`)
- [ ] Javascript (`*.js`, `*.mjs`)
- [x] JSON (`*.json`)
- [x] Markdown (`*.md`)
- [x] PHP (`*.php`)
- [ ] PlantUML (`*.puml`, `*.iuml`)
- [x] Shell (`*.bash, *.sh`)
- [x] YAML (`*.yaml`, `*.yml`)
- [x] XML (`*.xml`)

## Docker files

- Paths:
  ```yaml
    paths:
      # Docker generic, Files or folders used in the creation of the docker image.
      - '.dockerignore'
      - 'docker-compose.yml'
      - 'Dockerfile'
      - '.config/hadolint.yml'
      # Docker project specific, Dockerfile "COPY" and "ADD" entries.
      # Ideally, these all live in a single folder, for instance called `/docker/`
      - 'src/'
      - 'site.conf'
  ```

## Dockerfile files

- Paths:
  ```yaml
    paths:
      - 'Dockerfile'
      - '.config/hadolint.yml'
  ```

## JSON files

- Paths:
  ```yaml
    paths:
      - '**.json'
      - '.github/workflows/json.yml'

      - '!composer.json'
      - '!**/composer.json'
      - '!package.json'
      - '!package-lock.json'
      - '!**/package.json'
      - '!**/package-lock.json'
  ```

### Exceptions and Caveats

- `composer.json` files are not linted using a JSON Linter.
  These file should be checked using PHP Composer specific workflow(s).

- `package.json` and `comoer-lock.json` files are not linted using a JSON Linter. 
  These file should be checked using NPM specific workflow(s).

## Markdown files

- Config file(s): `.remarkrc`, `.spelling`
- Paths:
  ```yaml
    paths:
      - '**.md'
      - '.github/workflows/markdown.yml'
  ```

Markdown files can be checked for three things:

- Correct Content (check spelling)
- Correct Form (check syntax and code style inconsistencies)
- Correct Tone (check for insensitive or inconsiderate writing)

Where content and form should be checked as part of common quality control, the tone is checked as per the Code Manifesto "Discrimination limits us" and "Boundaries honor us" values (part of the [Contributor Code of Conduct][3])

[3]: https://pdsinterop.org/code-of-conduct/

## PHP files

- Config file(s): `phpcs.xml.dist`, `phpunit.xml.dist`
- Paths:
  ```yaml
    paths:
      - '**.php'
      - '.config/phpcs.xml.dist'
      - '.config/phpunit.xml.dist'
  ```

### PHP dependencies

- Paths:
  ```yaml
    paths:
      - 'composer.json'
      - 'composer.lock'
  ```

If a PHP project uses other packages (declared in the `composer.json` and optional `composer.lock` files), these will also need to be checked. there are two checks for this. One to check if the declared dependencies are up to date, and one to check whether the dependencies contain possible security issues.

#### Validate dependencies file (`composer validate`)

This workflow will check if the `composer.json` file is valid.
If a `composer.lock` file exists, it will also check if it is up to date with the `composer.json`.

To make sure a project remains in a deployable state, `composer validate` should be run  before changes to the `composer.json` (and `composer.lock`) file are committed, or before a release is tagged.

As this command can not be configured through a config file, settings needs to be configured through parameters.

Which settings are desirable depends on the project. Available parameters are:

- `--check-lock` / `--no-check-lock`: Check if lock file is up to date with declarations in `composer.json`
- `--no-check-all`: Do not emit a warning if requirements in composer.json use unbound or overly strict version constraints.
- `--no-check-publish`: Do not emit an error if `composer.json` is unsuitable for publishing as a package on Packagist but is otherwise valid.
- `--no-check-version`: Do not emit an error if the version field is present.
- `--strict`: Return a non-zero exit code for warnings as well as errors.
- `--with-dependencies`: Also validate the composer.json of all installed dependencies.

For full details visit: https://getcomposer.org/doc/03-cli.md#validate

#### Scan dependencies vulnerabilities (`composer audit`)

This workflow will audit packages for potential security issues. It also detects abandoned packages.

The Security vulnerability advisories listing is taken from [the Packagist.org API][6].

Only the "abandoned" setting can be configured in the `composer.json` file, under `config.audit.abandoned`.
It defaults to `report `in Composer 2.6, and to `fail` from Composer 2.7 onwards.

- `fail`   means abandoned packages will cause audits to fail with a non-zero code.
- `ignore` means the audit command does not consider abandoned packages at all.
- `report` means abandoned packages are reported as an error but do not cause the command to exit with a non-zero code.

As this command can not be configured through a config file, settings needs to be configured through parameters.
Available parameters are:

- `--abandoned <fail|ignore|report>`: Behavior on abandoned packages. This flag overrides the config value and the environment variable.
- `--format <json|plain|table|summary>`: Audit output format, the default is "table".
- `--ignore-severity <low|medium|high|critical>`: Ignore advisories of a certain severity level. Can be passed multiple times to ignore multiple severities.
- `--locked`: Audit packages from the lock file, regardless of what is currently in vendor dir.
- `--no-dev`: Disables auditing of require-dev packages.

For full details visit: https://getcomposer.org/doc/03-cli.md#audit

[6]: https://packagist.org/apidoc#list-security-advisories

## Shell files

- Paths:
  ```yaml
    paths:
      - '**.bash'
      - '**.sh'
      - '.github/workflows/shell.yml'
  ```

## XML files

- Paths:
  ```yaml
    paths:
      - '**.xml'
      - '**.xml.dist'
      - '.github/workflows/xml.yml'
  ```

## YAML files

- Config file(s): `.yamllint`
- Paths:
  ```yaml
    paths:
      - '**.yml'
      - '**.yaml'
      - '!.github/workflows/**.yml'
      - '!.github/workflows/**.yaml'
  ```

### Exceptions and Caveats

GitHub Actions YAML files are not linted using a YAML linter. The reason for this is that, opposed to other YAMl files, GHA will tell us when things are wrong.
So, unless other YAML files are present in a repository, a YAML Lint is not used.

## Other file types

- Paths:
  ```yaml
    paths:
      # OTHERS
      - /src/**
      - solid/lib/**
      - solid/templates/**
      - 
  ```

## A few words about GitHub Actions YAML

### Filter patterns (in `branch`, `path`, and `tag` entries)

Special characters can be used to filter path, branch, and tag values (similar to ["globbing"][4]).

For instance when `paths` is used in a GHA to only trigger a workflow when specific files or folders have changed.

The following characters can be used:

- `*`: Matches zero or more characters, but does not match the `/` character. For example, `Octo*` matches `Octocat` but **not** `Octo/cat`.
- `**`: Matches zero or more of any character (including `/`). For example, `Octo**` matches `Octocat` and `Octo/cat`.
- `?`: Matches zero or one of the preceding character.
- `+`: Matches one or more of the preceding character.
- `[` and `]` Matches one alphanumeric character listed in the brackets or included in ranges. Ranges can only include `a-z`, `A-Z`, and `0-9`. For example, the range `[0-9a-z]` matches any digit or lowercase letter. For example, `[CB]at` matches `Cat` and `Bat` and `[1-2]00` matches `100` and `200`.
- `!`: At the start of a pattern makes it negate previous positive patterns. It has no special meaning if not the first character.

If a pattern starts with `*`, `[`, and `!`, or contains `[` and/or `]`, the pattern MUST be quoted.

For full details visit: the [Filter Pattern Cheat Sheet in the GitHub Workflow Syntax documentation][5]

[4]: https://en.wikipedia.org/wiki/Globbing
[5]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet

## A few words about YAML

### Strings (or: [To quote, or not to quote?][1])

There are subtle differences in how YAML behaves when it encounters values that are unquote, single quoted, or double-quoted.

If a value is meant to be an integer, boolean or null value, it does not need quotes.

If a value is meant as a string, it is best to use single or double quotes, to avoid unexpected behaviour.

The main difference between single and double quotes is:

- Single quotes does not parse escape codes. For example, `'\n'` would be returned as the string "\n".
- Double quotes parse escape codes. "\n" would be returned as a line break (i.e. [newline character][2])

So, if a value is meant to be a string, use single quotes, unless it contains escape codes that should be parsed.

[1]: https://www.yaml.info/learn/quote.html
[2]: https://en.wikipedia.org/wiki/Newline

For longer, or more complex strings, block Style and Chomping indicators can be used.
These also allow to spread a string across multiple lines.

### Multiline strings ("Blocks")

_**TBD:** Explain Blocks (edit text below)_

#### Block Scalar Style

- `>` Replace newlines with spaces ("folded")
- `|` Keep newlines ("literal")

The block style indicates how newlines inside the block should behave.
If you would like them to be kept as newlines, use the literal style, indicated by a pipe (|).
If instead you want them to be replaced by spaces, use the folded style, indicated by a right angle bracket (>).
(To get a newline using the folded style, leave a blank line by putting two newlines in. Lines with extra indentation are also not folded.)

#### Block Chomping

- Single newline at end ("clip")
- `-` No newline at end ("strip")
- `+` All newlines from end ("keep")

The chomping indicator controls what should happen with newlines at the end of the string.
The default, clip, puts a single newline at the end of the string.
To remove all newlines, strip them by putting a minus sign (-) after the style indicator.
Both clip and strip ignore how many newlines are actually at the end of the block; to keep them all put a plus sign (+) after the style indicator.


For full details visit: https://www.yaml.info/learn/quote.html
