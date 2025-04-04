# The filename pattern

The filename should have the following format:

```text
${stage}.${language}.${action}.yml
```
## Available stages

The available stages are taken from  [Quality Assistance Stages for Continuous Integration (QAS4CI)][1], which are:

1. **`preflight`**
   Things that MUST pass before running the pipeline.
2. **`test`**
   Things that MUST pass and DO mean the code is broken.
3. **`quality`** (or: linting?)
   Things that SHOULD pass but DO NOT mean the code is broken. 
4. **`build`**
   Create assets from the working code.
5. **`scan`**
   Scan any created assets for vulnerabilities.
6. **`deploy`**
   Send the assets somewhere.
7. **`manifest`**
   Create manifests for assets (hashes, manifests, keys, etc.).
8. **`publish`**
   Publish created manifests

These stages can be used to create dependencies in the pipeline, to reduce the time it takes to run the pipeline.

[1]: https://gist.github.com/Potherca/e2903ad6adcf3db161d93deb2c1ec196

## Languages

The list of languages contains, but is not limited to:

- CSS (`*.css`, `*.scss`)
- Docker (`Dockerfile`)
- HTML (`*.html`)
- Images (`*.png`, `*.jpg`, `*.svg`)
- Javascript (`*.js`, `*.mjs`)
- JSON (`*.json`)
- Markdown (`*.md`)
- PHP (`*.php`)
- PlantUML (`*.puml`, `*.iuml`)
- Shell (`*.bash, *.sh`)
- YAML (`*.yaml`, `*.yml`)
- XML (`*.xml`)

## Actions

The list of actions contains, but is not limited to:

- `lint`
- `scan`
- `test`
- `validate`

For instance:

- `lint-syntax`
- `lint-version-compatibility`
- `scan-dependencies-vulnerabilities`
- `test-integration`
- `test-unit`
- `validate-dependencies-file`

## Examples

- `02.test.php.test-unit.yml`
- `03.quality.json.lint.yml`
- `03.quality.markdown.lint.yml`
- `03.quality.php.lint-syntax.yml`
- `03.quality.php.lint-version-compatibility.yml`
- `03.quality.php.validate-dependencies-file.yml`
- `03.quality.yaml.lint.yml`
- `04.build.docker.yml`
- `05.scan.php.dependencies.yml`
