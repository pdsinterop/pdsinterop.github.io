# GitHub Actions Dependencies

In GitHub Actions, a workflow made up of multiple jobs runs in parallel by default.

A job can be made dependent on another job, or a workflow can depend on another workflow.

When creating dependencies, the main goal is to reduce the time it takes to run the pipeline.

It is important to document _why_ the dependency is needed.

For instance, with the stages defined in [Quality Assistance Stages for Continuous Integration (QAS4CI)][1], there is no need to run proceeding stages when preceding stages fail, as developers are expected to fix the issues before proceeding.

[1]: https://gist.github.com/Potherca/e2903ad6adcf3db161d93deb2c1ec196

1. **`preflight`**
   Things that MUST pass before running the pipeline.
2. **`test`**
   Things that MUST pass and DO mean the code is broken.
3. **`quality`**
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

## Dependencies between Jobs

A workflow, made up of multiple jobs, runs in parallel by default.

To create dependencies between jobs, the `needs` keyword can be used.

For instance:

```yaml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```

For full documentation see the documentation for [Using jobs in a workflow](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/using-jobs-in-a-workflow)

## Dependencies between Workflows

To create dependencies between workflows, the `workflow_run` event can be used.

For example, this workflow will run whenever a workflow named "Build" completes:

```yaml
# build.yml
---
name: Build
```

```yaml
# deploy.yml
---
name: Deploy
on:
  workflow_run:
    workflows: ["Build"]
    types:
      - completed
```

For full documentation see the documentation for [Events that trigger workflows](https://docs.github.com/en/actions/learn-github-actions/events-that-trigger-workflows)

## FAQ

- #### When should a job or workflow not run?

When a previous job or workflow has failed, there is no need to run the next job or workflow.

For instance, when a unit-test fails, there is no need to build a Docker image. 

But if quality checks fail, it might still make sense to build the Docker image, as the image might be needed for further testing. 

- #### Where do security scans of dependencies belong?

Security scans of dependencies never fall under `scan`. They might be considered assets, but they have not been created by the project under test. 

Under similar logic, they also don't fall under `build`, `deploy`, `manifest`, or `publish`.

So they can only fall under `preflight`, `test`, or `quality`.

Which one depends on the project's Security Vulnerability Policy:

- If vulnerabilities in dependencies MUST be fixed as soon as encountered, the security scan falls under `preflight`.
- If vulnerabilities in dependencies MUST be fixed before deployment, the security scan falls under `test`.
- If vulnerabilities in dependencies SHOULD be fixed, but do not block deployment, the security scan falls under `quality`.
