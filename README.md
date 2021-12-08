The project is to generate non-js project template. For js project, there are better tools for lint, format or release.

# Project Template

ref
- https://github.com/Josee9988/project-template
- https://github.com/cfpb/open-source-project-template
- https://github.com/embeddedartistry/templates

## Basic

## README

- Getting Started
    - Requirements / Prerequisites
    - Installation
- Usage
- Known issues
- Contributing
- License
- Acknowledgments: thanks to

ref:

- https://github.com/Ismaestro/markdown-template
- https://github.com/othneildrew/Best-README-Template
- https://github.com/dbader/readme-template

### Content
ref: https://github.com/cfpb/open-source-project-template
### Badge
ref: https://github.com/Josee9988/project-template

## Development

Style

- format: [Prettier](https://prettier.io/)
- commit lint:

## CICD

[on-PR](./github/workflows/PR.yml)
- label PR
- build, test, etc.


[release.yml](./github/workflows/release.yml)
- draft release when pushing tag

[on-release.yml](./github/workflows/on-release.yml)
- append release body to CHANGELOG.md


## Community health files

Pull Request Template

- template file: [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md)
- example: [stevemao/github-issue-templates](https://github.com/stevemao/github-issue-templates)

Issue Template
- template file: [.github/ISSUE_TEMPLATE.md](.github/ISSUE_TEMPLATE.md)
- example: [stevemao/github-issue-templates](https://github.com/stevemao/github-issue-templates)

Others: refer to [this link](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)

## MISC
- TERMS.md:
