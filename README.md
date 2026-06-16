# deploy_agent_mcyusa-byte

## How to Run the Script

```bash
bash setup_project.sh
```

When prompted, enter a project name (e.g. `v1`). The script will create the full attendance tracker directory structure automatically.

## How to Trigger the Archive (Trap)

While the script is running, press **Ctrl+C** at any point. The script will:
1. Catch the interrupt signal
2. Bundle the incomplete directory into a `.tar.gz` archive
3. Delete the incomplete directory to keep the workspace clean

## Project Structure Created
git add README.md
git commit -m "Add README"
git push
