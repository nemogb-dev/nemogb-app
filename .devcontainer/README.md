# Dev Container Configuration for NemoGB Shiny App

This directory contains configuration files for GitHub Codespaces and Visual Studio Code Dev Containers.

## What This Does

The `devcontainer.json` file defines a development environment that:

1. Uses your existing Docker Compose setup
2. Automatically forwards port 3838 for the Shiny app
3. Installs R language extensions
4. Configures VS Code settings for R development
5. Opens the main app file when you start a new Codespace

## Benefits

- **Faster Startup**: When using GitHub Codespaces with prebuilds enabled, your environment will be pre-configured
- **Consistent Environment**: Everyone gets the same development setup
- **Automatic Configuration**: Port forwarding and extensions are pre-configured
- **Better Integration**: Native support for GitHub Codespaces workflow

## Using with GitHub Codespaces

1. In your GitHub repository, go to the "Codespaces" tab
2. Click "New codespace"
3. The environment will be automatically configured based on this setup

## Using with VS Code Dev Containers

1. Install the "Remote - Containers" extension in VS Code
2. Open the project folder in VS Code
3. Click the green button in the bottom-left corner
4. Select "Reopen in Container"

## Enabling Prebuilds (GitHub Admin)

1. Go to your repository on GitHub
2. Navigate to Settings > Codespaces
3. Under "Prebuild configuration", click "Add prebuild configuration"
4. Select the branches you want to enable prebuilds for
5. Configure the prebuild options and save
