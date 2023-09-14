# Developer Notes for Chromatofore Filament Exchanger

This document serves as a guide for developers contributing to the `chromatofore` repository. 
It covers our branching strategy and provides commands to help you manage your contributions seamlessly.

## Branching Strategy

For the `chromatofore`, repository we use a feature-branch workflow. 
All development must be done in feature branches, which are created from the `main` branch. 
Direct commits to the `main` branch are not allowed. This ensures that the `main` branch 
always contains stable and deployable code.

### Creating a Feature Branch

To create a new feature branch, first ensure that you are on 
the `main` branch and that you have the latest changes. 
Then, create a new branch. Here's how you can do it:

```bash
# Ensure you're on the main branch
git checkout main

# Fetch the latest changes
git pull

# Create a new feature branch
git checkout -b feature/your-feature-name
```


Where `your-feature-name` should be a concise description of the feature or bugfix you're working on.

### Saving Changes in Your Feature Branch

Once you've made changes in your feature branch and want to save them:

Stage all your changes:


```bash
git status 
# Examine output for any new files and then add them if needed.
git add "path to new file"

git commit -am "Describe you changes here"
git push

```


### Merging Your Feature Branch

After you've finished your feature and pushed it to the repository, 
you'll typically create a pull request (PR). Your PR will be reviewed, 
and once approved, it can be merged into the main branch.

