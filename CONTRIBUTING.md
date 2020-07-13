---
title: Contributing
permalink: /contributing/
---

# Contributing to PDS Interop

Thank you for your interest in contributing!

All PDS Interop projects are open source and community-friendly.

Questions can be asked (or feedback given) by opening an issues on Github.

<!--
If you have a question, please visit [our chat channel](#todo).
The Github issue tracker is only for **bug reports and feature requests**.
-->

We accept contributions via merge-request<sup>1</sup> on [Github](https://github.com/pdsinterop/).

_Any_ contribution is welcome and your will be given full credit for your efforts.

## Contributor Code of Conduct

Please note that this project adheres to a [Contributor Code of Conduct](https://pdsinterop.org/code-of-conduct/). When participating in this project and its community, you are expected to abide by its terms.

## Security

If you discover any security related issues, please email <security@pdsinterop.org> instead of using the issue tracker.

## Reporting issues

**To ensure your privacy and security, please do not include passwords or personally identifiable information in your bug report and sample code.**

Some general guidelines:

- Before opening an new issue, please use the GitHub search feature to see if
  the issue has already been reported

- If your issue is not specific to one repository but more about things in
  general, [open an issue with project administration](https://github.com/pdsinterop/project-admin/issues)

- If your issue is about the website or generic documentation, [open an issue at
  the website repository](https://github.com/pdsinterop/pdsinterop.github.io/issues)

When reporting issues, please try to be as descriptive as possible, and include
as much relevant information as you can to help us reproduce the issue.

A good bug report includes:

- Expected outcome
- Actual outcome
- Steps to reproduce (including any relevant sample code)
- Any other information that will help us debug and reproduce the issue (error messages, stack traces, system/environment information, screenshots, etc.)

A step by step guide on how to reproduce the issue will greatly increase the
chances of your issue being resolved in a timely manner.

If your issue involves installing, updating or resolving dependencies, the
chance of us being able to reproduce your issue will be much higher if you
share the file defining your dependency with us.

Due to time constraints, we are not always able to respond as quickly as we would like. Please do not take delays personal and feel free to remind us if you feel that we forgot to respond!

## Development

There is a common development workflow that goes (more or less) like this:

1. Fork the project.
2. Make code changes (add a feature, fix a bug, update the documentation).
3. Add tests for the code changes.
4. Commit your work
5. Send a merge request. Bonus points for topic branches.

### 1. Fork the project

1. Visit the project on GitHub
2. Click on the "Fork" button
3. Clone you forked project to your development environment

### 2. Code changes

Things that are common to all PDS Interop projects are listed below.

Beyond that, each project has its own project specific development instructions,
either in the project's `README.md` file or its `docs/` folder. Please visit the
project you are contributing to for futher development details.


#### Common coding guidelines

- **PHP code** should follow the [PSR-12 coding standard](http://www.php-fig.org/psr/psr-12/).

<!--
- **Javascript code** should follow the [(?)](#TODO).

- **TypeScript code** should follow the [(?)](#TODO).

- **Documentation** (markdown files) should follow the PDS Interop Remark lint configuration. It should US English spelling and non-offensive wording.

- **YAML files** should pass the PDS Interop YAML Lint configuration.
Full details can be found at [https://pdsinterop.org/coding-standards/](https://pdsinterop.org/coding-standards/)
-->

### 3. Add tests

Please **write tests** for any new features you add.

Any contribution must provide tests for additional introduced conditions

Any un-confirmed issue needs a failing test case before being accepted

This is important so we don't unintentionally break your code changes in a
future version.

Please **ensure that all tests pass** before making commits. There is a pipeline
that automatically runs tests for pull requests and commits. Running the tests locally will help save time.

### 4. Commit your work

Before making commits, please make sure that you have [set up your user name and email address](http://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) for use with Git. Strings such as `silly nick name <root@localhost>` look really stupid in the commit history of a project.

Pull requests must be sent from a new fix/feature branch, not from `master`.
Make sure you are working on a new branch.

Next, think about your commit message for a while. What should it convey? What
do you want to tell us and future developers about the work you did?

Your commit message can be as long as you want, just make sure to give it a
summary as a title if you need more than one sentence to discribe your work.

### 5. Send a merge request

Your pull request description should clearly detail the changes you have made.
We will use this description to add to our CHANGELOG. If there is no description
or it does not adequately describe your feature, we will ask you to update the description.

Other things to keep in mind are:

- **Consider our release cycle**
  We try to follow [Semantic Versioning](http://semver.org/). Randomly breaking
  public APIs is not an option.

- **Document any change in behaviour**
  Make sure the `README.md`or other relevant documentation are kept up-to-date.

- **Ensure all checks pass**
  We have a GitHub Actions pipeline that runs automatically for pull requests.
  All checks need to pass before changes will be considered.

- **One pull request per change/feature/fix**
  If you want to do more than one thing, send multiple pull requests.

- **Send a coherent history**
  Make sure each individual commit in your pull request is meaningful. Please do
  not squash your commits or send all your changes in a _single_ commit.

- **Use topic/feature branches.**
  Please do not ask us to pull from your fork's main branch.

## Footnotes

1. merge requests (or MRs) are the same as pull pequests (or PRs). They are sometimes also referred to as "patches".

<!--

If you'd like to contribute, please read the following documents:

* [Coding Standards][1]
* [Core Team and Cntributers][2]
* [Running Tests][3]
* [Security Issues][4]

[1]: https://pdsinterop.org/coding-standards/
[2]: https://pdsinterop.org/contributing/contributers/
[3]: https://pdsinterop.org/contributing/tests/
[4]: https://pdsinterop.org/contributing/security/

- The project will follow strict [object calisthenics](http://www.slideshare.net/guilhermeblanco/object-calisthenics-applied-to-php)

## Adding New Features

If you have an idea for a new feature, it's a good idea to check out our [issues](https://github.com/ramsey/uuid/issues) or active [pull requests](https://github.com/ramsey/uuid/pulls) first to see if the feature is already being worked on. If not, feel free to submit an issue first, asking whether the feature is beneficial to the project. This will save you from doing a lot of development work only to have your feature rejected. We don't enjoy rejecting your hard work, but some features just don't fit with the goals of the project.
-->
