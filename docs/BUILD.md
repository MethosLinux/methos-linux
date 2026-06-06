# Building Methos Linux ISO

## Prerequisites

- Arch Linux (bare metal or Docker)
- `archiso` package installed
- `make` installed
- 10GB free disk space

## Quick Build

```bash
# Install dependencies
sudo pacman -S archiso make

# Build ISO
make iso

# Output: out/methos-linux-*.iso
```

## Build Methods

### Method 1: make (recommended)
```bash
make all        # Prepare + Build
make iso        # Build only
make validate   # Validate configs
make test       # Run tests
make clean      # Clean artifacts
make distclean  # Full clean
```

### Method 2: Docker
```bash
make docker
```

### Method 3: Direct script
```bash
./scripts/build.sh
./scripts/build.sh --clean
```

## Output

After build:
```
out/methos-linux-0.1.0-alpha-YYYY.MM.DD-x86_64.iso
```

## Testing the ISO

1. Boot in VM: `qemu-system-x86_64 -cdrom out/*.iso -m 4096`
2. Boot on real hardware: Write to USB with `dd`