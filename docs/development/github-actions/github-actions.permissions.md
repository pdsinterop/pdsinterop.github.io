# GitHub Action Permissions

GitHub Action Permission can be set in the root for all jobs, or per job.

Permissions in the root can be set to `read-all`, `write-all`, or `{}` for "none".

If any permission is specified, all permissions that are not specified are set to `none`.

For a job, permissions can be set to modify the permissions set in the root, adding or removing access as required.

In all actions `concurrency.cancel-in-progress` is to `true`, to allow for the cancellation of running workflows.

For this the `actions` permission needs to be set to `write`:

```yaml
---
name: Workflow Example

# Cancels all previous workflow runs for the same branch that have not yet completed.
concurrency:
  # The concurrency group contains the workflow name and the branch name.
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  # Needed to cancel a workflow run.
  actions: write
```

This means that the following permissions are _implicitly_ set in the root:

```yaml
permissions:
  actions: write
  attestations: none
  checks: none
  contents: none
  deployments: none
  discussions: none
  id-token: none
  issues: none
  packages: none
  pages: none
  pull-requests: none
  repository-projects: none
  security-events: none
  statuses: none
```
For most workflows this is fine, but if additional permissions are needed, they need to be _explicitly_ set in the root, or per job.

The most commonly needed permissions are:

- `contents` for instance to list git commits or creating a release (git tag)
- `issues` for instance to add a comment to an issue
- `packages` for instance to upload and publish a package to the GitHub Package Registry or a Docker image to the GitHub Container Registry
- `pages` to trigger a GitHub Pages build

A full list of available permissions can be found in the ["permissions" section of the "Workflow syntax for GitHub Actions" documentation](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#permissions).

For an overview of which permissions are required for which actions, visit: [Permissions required for GitHub Apps](https://docs.github.com/en/rest/authentication/permissions-required-for-github-apps) and [the "About scopes and permissions for package registries" section in the "About permissions for GitHub Packages" documentation](https://docs.github.com/en/packages/learn-github-packages/about-permissions-for-github-packages#about-scopes-and-permissions-for-package-registries)


## All Permissions

### With permissive permissions

```yaml
# If you specify the access for any of these permissions, all of those that are not specified are set to "none".
permissions:
  # Work with GitHub Actions. For example, actions: write permits an action to
  # cancel a workflow run. For more information, see Permissions required for GitHub Apps.
  actions: write
  # Work with artifact attestations. For example, attestations: write permits an action to generate an artifact attestation for a build. For more information, see Using artifact attestations to establish provenance for builds
  attestations: write
  # Work with check runs and check suites. For example, checks: write permits an action to create a check run. For more information, see Permissions required for GitHub Apps.
  checks: write
  # Work with the contents of the repository. For example, contents: read permits an action to list the commits, and contents: write allows the action to create a release. For more information, see Permissions required for GitHub Apps.
  contents: write
  # Work with deployments. For example, deployments: write permits an action to create a new deployment. For more information, see Permissions required for GitHub Apps.
  deployments: write
  # Work with GitHub Discussions. For example, discussions: write permits an action to close or delete a discussion. For more information, see Using the GraphQL API for Discussions.
  discussions: write
  # Fetch an OpenID Connect (OIDC) token. This requires id-token: write. For more information, see About security hardening with OpenID Connect
  id_token: none
  # Work with issues. For example, issues: write permits an action to add a comment to an issue. For more information, see Permissions required for GitHub Apps.
  issues: write

  metadata:	read

  # Work with GitHub Packages. For example, packages: write permits an action to upload and publish packages on GitHub Packages. For more information, see About permissions for GitHub Packages.
  packages: write
  # Work with GitHub Pages. For example, pages: write permits an action to request a GitHub Pages build. For more information, see Permissions required for GitHub Apps.
  pages: write
  # Work with pull requests. For example, pull-requests: write permits an action to add a label to a pull request. For more information, see Permissions required for GitHub Apps.
  pull_requests: write
  # -projects	Work with GitHub projects (classic). For example, repository-projects: write permits an action to add a column to a project (classic). For more information, see Permissions required for GitHub Apps.
  repository: write
  # Work with GitHub code scanning and Dependabot alerts. For example, security-events: read permits an action to list the Dependabot alerts for the repository, and security-events: write allows an action to update the status of a code scanning alert. For more information, see Repository permissions for 'Code scanning alerts' and Repository permissions for 'Dependabot alerts' in "Permissions required for GitHub Apps."
  security_events: write
  # Work with commit statuses. For example, statuses:read permits an action to list the commit statuses for a given reference. For more information, see Permissions required for GitHub Apps.
  statuses: write
```

### With restrictive permissions

```yaml
# If you specify the access for any of these permissions, all of those that are not specified are set to "none".
permissions:
  # Work with GitHub Actions. For example, actions: write permits an action to
  # cancel a workflow run. For more information, see Permissions required for GitHub Apps.
  actions: none
  # Work with artifact attestations. For example, attestations: write permits an action to generate an artifact attestation for a build. For more information, see Using artifact attestations to establish provenance for builds
  attestations: none
  # Work with check runs and check suites. For example, checks: write permits an action to create a check run. For more information, see Permissions required for GitHub Apps.
  checks: none
  # Work with the contents of the repository. For example, contents: read permits an action to list the commits, and contents: write allows the action to create a release. For more information, see Permissions required for GitHub Apps.
  contents: read
  # Work with deployments. For example, deployments: write permits an action to create a new deployment. For more information, see Permissions required for GitHub Apps.
  deployments: none
  # Work with GitHub Discussions. For example, discussions: write permits an action to close or delete a discussion. For more information, see Using the GraphQL API for Discussions.
  discussions: none
  # Fetch an OpenID Connect (OIDC) token. This requires id-token: write. For more information, see About security hardening with OpenID Connect
  id_token: none
  # Work with issues. For example, issues: write permits an action to add a comment to an issue. For more information, see Permissions required for GitHub Apps.
  issues: none
  # Work with GitHub Packages. For example, packages: write permits an action to upload and publish packages on GitHub Packages. For more information, see About permissions for GitHub Packages.

  metadata:	read

  packages: read
  # Work with GitHub Pages. For example, pages: write permits an action to request a GitHub Pages build. For more information, see Permissions required for GitHub Apps.
  pages: none
  # Work with pull requests. For example, pull-requests: write permits an action to add a label to a pull request. For more information, see Permissions required for GitHub Apps.
  pull_requests: none
  # -projects	Work with GitHub projects (classic). For example, repository-projects: write permits an action to add a column to a project (classic). For more information, see Permissions required for GitHub Apps.
  repository: none
  # Work with GitHub code scanning and Dependabot alerts. For example, security-events: read permits an action to list the Dependabot alerts for the repository, and security-events: write allows an action to update the status of a code scanning alert. For more information, see Repository permissions for 'Code scanning alerts' and Repository permissions for 'Dependabot alerts' in "Permissions required for GitHub Apps."
  security_events: none
  # Work with commit statuses. For example, statuses:read permits an action to list the commit statuses for a given reference. For more information, see Permissions required for GitHub Apps.
  statuses: none
```
