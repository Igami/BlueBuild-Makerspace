# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a BlueBuild configuration repository for creating a custom Fedora Atomic desktop image for a local makerspace. The project uses BlueBuild's framework to customize Fedora Bluefin-DX with maker-focused applications and tools.

## Build and Deployment

### Building the Image
- Images are automatically built via GitHub Actions on push, PR, and daily schedule
- Manual builds can be triggered using workflow dispatch in GitHub Actions
- The build process is handled by `blue-build/github-action@v1.8`
- Builds are signed with cosign using the repository's signing secret

### Testing Changes
- The GitHub Actions workflow builds on every push and PR
- No local build commands are available - all builds happen in CI
- Monitor build status at: https://github.com/igami/bluebuild-makerspace/actions

### Installation Commands
To rebase to this custom image:
```bash
# First rebase to unsigned image
rpm-ostree rebase ostree-unverified-registry:ghcr.io/igami/bluebuild-makerspace:latest
systemctl reboot

# Then rebase to signed image
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/igami/bluebuild-makerspace:latest
systemctl reboot
```

## Architecture

### Core Configuration
- **Base Image**: `ghcr.io/ublue-os/bluefin-dx-hwe-nvidia` (Fedora Bluefin-DX with NVIDIA drivers)
- **Recipe File**: `recipes/recipe.yml` - Main configuration defining the image build
- **Scripts**: `files/scripts/` - Custom installation scripts for applications not available via Flatpak

### Module Structure
The build uses BlueBuild modules in this order:
1. **Script modules** - Run custom bash scripts for specialized software installation
2. **Default-flatpaks module** - Install a curated set of makerspace applications via Flatpak
3. **Signing module** - Set up image signing policies

### Key Components

#### Installation Scripts (`files/scripts/`)
- `inkstitch.sh` - Installs Ink/Stitch extension for Inkscape (embroidery design)
- `lightburn.sh` - Installs LightBurn (laser cutting/engraving software)
- Scripts download latest releases dynamically from upstream sources

#### Flatpak Applications
The image includes 40+ pre-installed applications covering:
- **CAD/3D Design**: FreeCAD, OpenSCAD, SolveSpace, LeoCAD, Blender
- **Electronics**: KiCad, Arduino IDE
- **Media/Graphics**: GIMP, Inkscape, Darktable, Blender, Audacity
- **Office/Productivity**: LibreOffice, OnlyOffice, Logseq, Anki
- **Development**: VS Code, VSCodium
- **3D Printing**: PrusaSlicer, Ultimaker Cura

## Development Workflow

### Making Changes
1. Edit `recipes/recipe.yml` to modify the image configuration
2. Add new installation scripts to `files/scripts/` if needed
3. Commit changes - GitHub Actions will build and test automatically
4. Once merged to main, signed images are published to `ghcr.io/igami/bluebuild-makerspace`

### Adding New Software
- **Flatpak applications**: Add to the `system.install` list in `recipe.yml`
- **Non-Flatpak software**: Create installation script in `files/scripts/` and reference it in `recipe.yml`
- **System files**: Add to `files/system/` directory structure (mirrors root filesystem)

### Script Guidelines
- Scripts should download software dynamically using latest release APIs when possible
- Use `curl` with GitHub/project APIs to get current version URLs
- Clean up temporary files after installation
- Test installations work with the base Bluefin-DX environment

## Git Commit Guidelines

Follow atomic commit practices:
- **One logical change per commit** - Each commit should represent a single, complete change
- **Clear, descriptive subject lines** - Use imperative mood (e.g., "add Zotero to flatpak list")
- **Keep commits focused** - Don't mix unrelated changes like adding software and fixing scripts
- **Commit message format**:
  ```
  add/update/fix/remove: brief description in imperative mood
  
  Optional longer explanation if needed
  ```
- **Examples of good commits**:
  - `add Zotero to flatpak applications`
  - `fix inkstitch script download URL parsing`
  - `update base image to latest Bluefin-DX`
  - `remove deprecated applications from recipe`