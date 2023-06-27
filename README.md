# n3tuk Upstream Template Synchroniser

A GitHub Action for running [`cookiecutter`][cookiecutter] from upstream
template repositories in the `n3tuk` Organisation and apply them over the
templates repositories and submit any changes as a pull request for review and
merging.

[cookiecutter]: https://github.com/cookiecutter/cookiecutter

## Features

This GitHub Action provides the following features:

- Merge upstream changes to the `cookiecutter.json` default configuration file
  with the downstream `cookiecutter.json` configuration for each templated
  repository, allowing new settings to be automatically added with the provided
  default value.
- Optionally re-render the upstream template files with the downstream
  `cookiecutter.json` configuration (with updates, if updated) and apply over
  the current repository files.
- Allow the downstream repository to ignore upstream changes to selected files
  with `.templateignore` in the root directory in the same format as
  `.gitignore`. Follow the [glob pattern][glob-pattern] in defining the files
  and folders that the action should excluded.

[glob-pattern]: https://en.wikipedia.org/wiki/Glob_(programming)

## Upstream

The codebase for this GitHub Action is an update on the
[`actions-template-sync`][actions-template-sync] GitHub Action, with handling of
templated file overrides (ignores), merging of upstream and downstream
cookiecutter configurations, and building the cookiecutter repository upstream
and overlaying it downstream.

[actions-template-sync]: https://github.com/AndreasAugustin/actions-template-sync

## Usage

You can use the [synchronise-upstream GitHub
Action][synchronise-upstream-marketplace] in a [GitHub
Workflow][github-workflow] by configuring a YAML file in your GitHub repository
(under `.github/workflows/synchronise-upstream.yaml`), with the following contents:

[github-workflow]: https://help.github.com/en/articles/about-github-actions
[synchronise-upstream-marketplace]: https://github.com/marketplace/actions/synchronise-upstream

```yaml
---
name: Synchronise Upstream

on:
  # Run at 18:15 on Wednesdays
  schedule:
    - cron: "15 18 * * 3"
  # Allow this GitHub Action to be manually triggered
  workflow_dispatch:

permissions:
  contents: write
  packages: read
  issues: write
  pull-requests: write

jobs:
  template-sync:
    name: Template Synchronise
    runs-on: ubuntu-latest
    env:
      SYNCHRONISER_TOKEN:
        { { secrets.SYNCHRONISER_TOKEN || secrets.GITHUB_TOKEN } }
    steps:
      - name: Checkout the Repository
        uses: actions/checkout@v3
        with:
          token: { { env.SYNCHRONISER_TOKEN } }

      - name: Render and synchronise the template repository
        uses: n3tuk/action-synchronise-upstream@v1
        with:
          github-token: { { env.SYNCHRONISER_TOKEN } }
          template-repository: n3tuk/template-terraform-module
          template-render: true
          pr-labels: release/skip,dependencies
```

## Inputs

| Variable              | Description                                                                                                                                                     | Required | Default                               |
| :-------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: | :------------------------------------ |
| `github-token`        | The GitHub Token to fetch the template repository and to make changes against the local repository. This is typically set to `secrets.GITHUB_TOKEN`.            |  `true`  |                                       |
| `template-repository` | The owner/name (i.e. n3tuk/template-terraform-module) of the GitHub repository used to provide the cookiecutter templates for this local repository.            |  `true`  |                                       |
| `template-branch`     | The name of the branch to use in the GitHub repository used to provide the cookiecutter templates for the local repository.                                     | `false`  | `main`                                |
| `template-render`     | Render (`true`) or skip (`false`) the cookiecutter templates when processing for changes in the template repository or local configuration.                     | `false`  | `true`                                |
| `target-branch`       | The target branch of the local repository to raise the pull request against whem procesing for changes in the template repository or local configuration.       | `false`  | `main`                                |
| `pr-branch-prefix`    | The prefix for the name of the pull request branch created by this GitHub Action when processing for changes in the template repository or local configuration. | `false`  | `chore/synchronise-upstream`          |
| `pr-title`            | The title of the pull request set by this GitHub Action when processing for changes in the template repository or local configuration.                          | `false`  | Synchronise Upstream Template Changes |
| `pr-labels`           | A comma-separated list of pull request labels to add by this GitHub Action on any created pull request.                                                         | `false`  | `[]`                                  |
