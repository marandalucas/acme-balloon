#!/bin/bash
# Script para empaquetar y preparar el release del Helm chart

set -e

CHART_NAME="acme-balloon"
VERSION=$(grep '^version:' Chart.yaml | awk '{print $2}')
TAG="v${VERSION}"

echo "=========================================="
echo "Release Helm Chart: $CHART_NAME"
echo "Version: $VERSION"
echo "Tag: $TAG"
echo "=========================================="
echo ""

# Verificar que estamos en un estado limpio
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  Warning: You have uncommitted changes"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Verificar que la versión existe en Chart.yaml
if [ -z "$VERSION" ]; then
    echo "❌ Error: Could not determine version from Chart.yaml"
    exit 1
fi

# Verificar que el tag no existe ya
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "⚠️  Warning: Tag $TAG already exists"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Crear directorio docs si no existe
mkdir -p docs

# Empaquetar el chart
echo "📦 Packaging Helm chart..."
helm package . -d docs/

# Generar index.yaml
echo "📝 Generating index.yaml..."
helm repo index docs/ --url https://marandalucas.github.io/acme-balloon/

echo ""
echo "✅ Chart packaged successfully!"
echo ""
echo "Files created in docs/:"
ls -lh docs/
echo ""
echo "Next steps:"
echo "1. Review the packaged chart: ls -lh docs/"
echo "2. Commit and push if needed:"
echo "   git add docs/"
echo "   git commit -m 'chore: Package chart for release $TAG'"
echo "   git push"
echo "3. Create and push the tag:"
echo "   git tag $TAG"
echo "   git push origin $TAG"
echo ""
echo "Or use GitHub Actions workflow to automate the release."

