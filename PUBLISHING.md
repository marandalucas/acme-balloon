# Publishing the Helm Chart

This document explains how to publish the ACME Balloon Helm chart to the public repository.

## Prerequisites

- GitHub repository with GitHub Pages enabled
- Helm 3.x installed locally
- Git configured with access to the repository

## Setup GitHub Pages

1. Go to your GitHub repository settings
2. Navigate to **Pages** section
3. Set source to **GitHub Actions** (or deploy from `docs/` branch)
4. Save the settings

## Publishing a New Version

### Automatic (Recommended)

The GitHub Actions workflow will automatically:
- Package the chart when you push a tag
- Create a GitHub Release
- Deploy to GitHub Pages

To release a new version:

1. Update the version in `Chart.yaml`
2. Commit and push:
   ```bash
   git add Chart.yaml
   git commit -m "chore: Bump version to X.Y.Z"
   git push
   ```
3. Create and push a tag:
   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```
4. The GitHub Actions workflow will handle the rest automatically

### Manual Release

If you prefer to release manually:

1. Run the release script:
   ```bash
   ./scripts/release.sh
   ```

2. Review the generated files in `docs/`

3. Commit and push:
   ```bash
   git add docs/
   git commit -m "chore: Release chart vX.Y.Z"
   git push
   ```

4. Create and push the tag:
   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

## Using the Public Repository

Once published, users can install the chart with:

```bash
# Add the repository
helm repo add acme-balloon https://marandalucas.github.io/acme-balloon
helm repo update

# Search for the chart
helm search repo acme-balloon

# Install the chart
helm install my-release acme-balloon/acme-balloon
```

## Repository URL

The public repository is available at:
**https://marandalucas.github.io/acme-balloon**

This URL serves the `index.yaml` file and chart packages from the `docs/` directory via GitHub Pages.

