# rename-to-main

Renames the `master` branch of GitHub repositories to `main` where the default branch points to `master`.

The script is configured through ``config.yaml`` to for the GitHub login and owner name. 
Create a [personal access token](https://github.com/settings/tokens) that has the `repo` scope so the script can reconfigure the default branch.

```yaml
login: <your-github-login>
owner: <your-github-login>
access_token: …
```

Note: ``owner`` may point to an organization for which you want to run the migration.

Note: Consider that you might have open pull requests. Removing a branch will close these without merge so you might want to switch the base head to `main` before removing the `master` branch.

Then, run ``rename-to-main.rb``.
