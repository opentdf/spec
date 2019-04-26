# Contribution guidelines

Contributions to the TDF3 specification are welcome! Please be sure to follow these guidelines when proposing changes or submitting feedback.

## Proposing Changes

All changes must be proposed using a pull request against this repo. See the GitHub [howto](https://help.github.com/en/articles/about-pull-requests) for more information about publishing a PR from a fork. The PR template checklist must be satisfied before review can take place (with the exception of blocking items like wait time).

Changes must update version numbers as required (see [guidelines](#version-changes)).	
* _Major_ version changes must include a detailed writeup motivating the change and its impact. These PRs must be left open for review for at least 7 days.
* _Minor_ version changes must include a brief writeup motivating the change and its impact. These PRs must be left open for review for at least 3 days.

### Version Changes

We follow the [semver](https://semver.org/spec/v2.0.0.html) guidelines on version changes, although reviewers may exercise their discretion on individual PRs.
* _Major_ version revs when a backwards-incompatible change is made. (Example: new required manifest fields or new required API call.)
* _Minor_ version revs when backwards-compatible functionality is added. (Example: new optional API parameter.)
* _Patch_ version revs when a change does not affect functionality but could affect how readers interpret the spec. (Example: Substantive new diagram illustrating a previously poorly-documented protocol interaction.)
* Cosmetic changes should _not_ affect the version number. (Example: Fixing typos, reformatting docs.)

There are three version numbers which contributors may need to change depending on the type and breadth of the proposed change:
* **Project version** - Version of the top-level project specification. This version should change accordingly if changes are made to the encrypt or decrypt workflow, or if new components or interactions are added to the architecture. Note that the project version isn't necessarily dependent on the API and schema versions, for instance, API parameters or the manifest format can change without affecting the overall workflow.
* **Schema version** - Shared data objects are versioned indepedent of the project version. If the schema for any of these objects changes, then the corresponding schema version should be changed accordingly.
* **API version** - Each swagger-defined API has an associated version number. If the API changes then the corresponding swagger version number should be changed accordingly.

Any changes that affect _project_ version must update both `git tag` and the [VERSION](VERSION) file.

Any changes that affect _schema_ versions must add or update [validation tests](schema/test/) accordingly.


## Asking Questions & Submitting Feeback

Please use GitHub issues to ask questions, submit suggestions, or otherwise provide feedback. Thank you!
