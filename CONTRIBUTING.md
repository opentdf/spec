# Contribution guidelines

Contributions to the TDF specification are welcome! Please be sure to follow these guidelines when proposing changes or submitting feedback.

## Proposing Changes

1. Pull Requests(PRs) proposing changes should be made in branches prefixed with `draft-<change>`
2. If the changes proposed to the spec would result in a _Major_ or _Minor_ semver version bump (see [versioning guidelines](#version-changes)) to the spec, the spec change MUST LINK TO A REFERENCE IMPLEMENTATION OF THE CHANGES in a publicly-visible Git repository.
   - It is suggested that the PR include a link to one or more reference implementation PRs in [the openTDF project's reference implementation](https://github.com/opentdf)

Proposed changes must specify what kind of semver change they would cause - (see [guidelines](#version-changes)).

* _Major_ version changes must include a detailed writeup motivating the change and its impact. These PRs must be left open for review for at least 7 days.
* _Minor_ version changes must include a brief writeup motivating the change and its impact. These PRs must be left open for review for at least 3 days.
* _Patch_ version changes must include a brief writeup motivating the change and its impact. These PRs must be left open for review for at least 3 days.

### Version Changes

We follow the [semver](https://semver.org/spec/v2.0.0.html) guidelines on version changes, although reviewers may exercise their discretion on individual PRs.

* _Major_ version revs when a backwards-incompatible change is made that would break clients. (Example: new required manifest fields or new required API call, or client code changes required)
* _Minor_ version revs when backwards-compatible functionality is added that would not break clients. (Example: new optional API parameter.)
* _Patch_ version revs when a change does not affect functionality but could affect how readers interpret the spec. (Example: Substantive new diagram illustrating a previously poorly-documented protocol interaction.)
* Cosmetic changes should _not_ affect the version number. (Example: Fixing typos, reformatting docs.)

The spec version is this repo's most recent semver Git tag - this means that if the spec version is 4.1.0, then the protocol version and all associated schema versions are also 4.1.0

Any changes that affect _project_ version must update both `git tag` and the [VERSION](VERSION) file.

#### Tracking Versions
Rather than use a CHANGELOG file, we ask that you use annotated `git tags` when bumping the spec Semver, and use the annotation message to describe the change.
> Example: `git tag -s 4.1.0 -m "Spec version 4.1.0 - twiddled a doohickey"`)

Please use the raw semver when tagging - no `v4.1.0`, just `4.1.0`

A list of `git tag` versions and their annotations can be generated at will via `git tag -n`

To create a CHANGELOG file, run the following command

`git tag -n --sort=-v:refname > CHANGELOG`

## Asking Questions & Submitting Feeback

Please use GitHub issues to ask questions, submit suggestions, or otherwise provide feedback. Thank you!
