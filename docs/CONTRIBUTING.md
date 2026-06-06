# Contributing to Methos Linux

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/methos-linux.git`
3. Build locally: `make iso`

## Development Workflow

```bash
# Make changes to archiso files
# Validate configuration
make validate

# Run tests
make test

# Build ISO
make iso
```

## Code Standards

- Shell scripts: Bash, 4-space indentation, `set -euo pipefail`
- Calamares configs: YAML, 4-space indentation
- Package lists: One package per line, comments with `#`
- No AUR packages in Alpha profile lists

## Pull Request Process

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make changes and test: `make test && make validate`
3. Commit: `git commit -m "feat: description"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

## Reporting Issues

Use GitHub Issues: https://github.com/methos-linux/methos-linux/issues

- Bug reports: Include ISO version, hardware specs, and logs (/var/log/methos-install.log)
- Feature requests: Describe the use case and expected behavior