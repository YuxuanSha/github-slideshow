# Flash Note mockup (codex branch seed)

This folder is ready to become its own repository with a `codex` branch that contains the Flash Note mockup page.

## How to publish to a new repo
1. Create an empty repository on GitHub (without initializing files).
2. On your machine, copy this `codex-repo` folder somewhere outside the current repo, then run:
   ```bash
   git init
   git checkout -b codex
   git add .
   git commit -m "Add Flash Note mockup"
   git remote add origin git@github.com:<your-username>/<new-repo>.git
   git push -u origin codex
   ```
3. If you want `main` (or `master`) to mirror the `codex` branch, create it from `codex` and push it too:
   ```bash
   git checkout -b main
   git push -u origin main
   ```

## Preview locally
Open `note-home.html` in a browser (ideally around 390px wide) to see the recreated Flash Note home screen.
