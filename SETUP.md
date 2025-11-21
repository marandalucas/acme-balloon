# Setup Guide for Public Helm Repository

This guide will help you set up the public Helm repository on GitHub Pages.

## Step 1: Enable GitHub Pages

1. Go to your GitHub repository: https://github.com/marandalucas/acme-balloon
2. Click on **Settings**
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select:
   - **Deploy from a branch**: Choose `main` branch and `/docs` folder
   - OR
   - **GitHub Actions** (recommended - will use the workflow)
5. Click **Save**

## Step 2: Push the Initial Release

The repository already has the chart packaged in `docs/`. You need to:

1. Commit all the new files:
   ```bash
   git add .
   git commit -m "feat: Add Helm repository setup and GitHub Actions workflow"
   git push github main
   ```

2. The GitHub Actions workflow will automatically deploy to GitHub Pages when you push a tag.

## Step 3: Verify the Repository

After pushing, wait a few minutes for GitHub Pages to deploy, then test:

```bash
# Add the repository
helm repo add acme-balloon https://marandalucas.github.io/acme-balloon

# Update repositories
helm repo update

# Search for the chart
helm search repo acme-balloon

# You should see:
# NAME                    CHART VERSION   APP VERSION     DESCRIPTION
# acme-balloon/acme-balloon   0.1.1           1.0.0           ACME Balloon Helm chart for Kubernetes cluster...
```

## Step 4: Future Releases

For future releases, simply:

1. Update version in `Chart.yaml`
2. Commit and push
3. Create and push a tag:
   ```bash
   git tag v0.1.2
   git push github v0.1.2
   ```
4. The GitHub Actions workflow will automatically:
   - Package the chart
   - Create a GitHub Release
   - Update the index.yaml
   - Deploy to GitHub Pages

## Troubleshooting

### Repository not found
- Wait a few minutes after enabling GitHub Pages
- Check that the `docs/` folder contains `index.yaml` and `.tgz` files
- Verify GitHub Pages is enabled in repository settings

### Chart not found
- Ensure `index.yaml` is in the `docs/` folder
- Check that the chart package (`.tgz`) exists in `docs/`
- Verify the URLs in `index.yaml` point to the correct GitHub Pages URL

### GitHub Actions not running
- Check that GitHub Actions are enabled in repository settings
- Verify the workflow file is in `.github/workflows/`
- Check the Actions tab for any errors

