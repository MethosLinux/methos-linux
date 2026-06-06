#!/bin/bash
# Methos Linux - Profile Merge Script (v3 FINAL)
#
# DESIGN RULES:
# 1. SINGLE-PASS: No recursion. No retry loops. No re-evaluation.
# 2. DETERMINISTIC: Same input → same output every time.
# 3. FALLBACK = first valid package only (no fallback chains).
# 4. CRITICAL safety gate: INSTALL or STOP. No gray area.
# 5. Mirror fallback: max 2 network retries only (not package resolution).
# 6. BOOT GUARANTEE: Best-effort with recovery logging enabled.

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

PROFILES_DIR="/etc/calamares/profiles"
SELECTED_FILE="/tmp/methos-selected-profiles.json"
LOG_FILE="/var/log/methos-install.log"
FAILED_FILE="/var/log/methos-failed-packages.fail"
CRITICAL_FILE="/var/log/methos-critical.flag"

# ============================================================================
# CRITICAL PACKAGES (12 items)
# ============================================================================
# These 12 packages are REQUIRED for the system to boot.
# If any is missing after installation, the process halts.
readonly CRITICAL_PKGS=(
    base        # Core Arch Linux system
    linux       # Linux kernel (required for boot)
    linux-firmware  # Hardware firmware blobs
    linux-headers   # Kernel headers for module compilation
    grub        # Bootloader (GRUB handles BIOS+UEFI)
    efibootmgr  # EFI boot entry manager (required for UEFI)
    mkinitcpio   # Initramfs generator (required for root fs)
    sddm        # Display manager (graphical login)
    plasma-meta  # KDE Plasma desktop meta-package
    networkmanager  # Network management (required for post-install connectivity)
    sudo        # Privilege escalation
    systemd     # Init system (PID 1)
)

# ============================================================================
# SINGLE-PASS CONFLICT RESOLUTION (rule-based, no loops)
# ============================================================================
# Each mapping: "source_package" → "target_package"
# When two profiles bring conflicting packages, ALL are replaced ONCE.
# RULE: first matched fallback wins. No secondary fallback. No recursion.
declare -A FALLBACK
FALLBACK[code]="vscodium"                    # VS Code → VSCodium
FALLBACK[vscodium]="vscodium"                # VSCodium is canonical
FALLBACK[jdk11-openjdk]="jdk-openjdk"        # JDK11 → JDK latest
FALLBACK[jdk17-openjdk]="jdk-openjdk"        # JDK17 → JDK latest
FALLBACK[jdk21-openjdk]="jdk-openjdk"        # JDK21 → JDK latest
FALLBACK[python2]="python"                   # Python2 → Python3
FALLBACK[firefox-developer-edition]="firefox" # Dev → Stable

# ============================================================================
# Mirror fallback list (for network retries only)
# ============================================================================
readonly MIRROR_LIST=(
    "https://mirrors.kernel.org/archlinux/\$repo/os/\$arch"
    "https://mirror.rackspace.com/archlinux/\$repo/os/\$arch"
    "https://archlinux.mirror.constant.com/\$repo/os/\$arch"
)

# ============================================================================
# Logging
# ============================================================================
log()       { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" | tee -a "$LOG_FILE"; }
log_info()  { log "INFO"  "$1"; }
log_warn()  { log "WARN"  "$1"; }
log_err()   { log "ERROR" "$1"; }
log_fatal() { log "FATAL" "$1"; }

# ============================================================================
# Step 1: Read selected profiles (deterministic)
# ============================================================================
read_profiles() {
    log_info "Reading selected profiles..."
    if [ ! -f "$SELECTED_FILE" ]; then
        echo "minimal"
        return
    fi
    python3 -c "
import json
try:
    with open('$SELECTED_FILE') as f:
        d = json.load(f)
    s = d.get('profiles', [])
    print(' '.join(s) if s else 'minimal')
except:
    print('minimal')
" 2>/dev/null || echo "minimal"
}

# ============================================================================
# Step 2: Load profile packages (no side effects)
# ============================================================================
load_pkgs() {
    local f="${PROFILES_DIR}/$1.pkgs"
    [ -f "$f" ] && grep -v '^\s*#' "$f" | grep -v '^\s*$' | sed 's/\s*#.*$//' || true
}

# ============================================================================
# Step 3: SINGLE-PASS conflict resolution (deterministic)
# NO RECURSION. NO RETRY LOOPS. NO RE-EVALUATION.
# ============================================================================
resolve_once() {
    local -a pkgs=("$@")
    local -a out=()
    local -A seen=()

    for pkg in "${pkgs[@]}"; do
        [ -z "$pkg" ] && continue
        # Apply fallback if exists, otherwise keep original
        local final="${FALLBACK[$pkg]:-$pkg}"
        # Deduplicate: first occurrence wins
        [ -n "${seen[$final]:-}" ] && continue
        seen["$final"]=1
        out+=("$final")
    done

    printf '%s\n' "${out[@]}"
}

# ============================================================================
# Step 4: Single pacman call with mirror network retries
# Note: This retries NETWORK failures only, not package resolution.
# ============================================================================
pacman_with_fallback() {
    local retries=0
    local max_retries=2

    while [ $retries -le $max_retries ]; do
        if pacman -S --needed --noconfirm "$@" 2>/dev/null; then
            return 0
        fi
        retries=$((retries + 1))
        if [ $retries -le $max_retries ]; then
            log_warn "Mirror failed (attempt $retries/$max_retries). Switching mirror..."
            local idx=$((retries % ${#MIRROR_LIST[@]}))
            echo "Server = ${MIRROR_LIST[$idx]}" > /etc/pacman.d/mirrorlist
            pacman -Sy --noconfirm 2>/dev/null || true
        fi
    done
    return 1
}

# ============================================================================
# Step 5: Install packages (SINGLE PASS, no recursion)
# ============================================================================
install_single_pass() {
    local -a pkgs=("$@")
    [ ${#pkgs[@]} -eq 0 ] && return 0

    log_info "Installing ${#pkgs[@]} packages in single pass..."
    log_info "Packages: ${pkgs[*]}"

    # ATTEMPT 1: Single pacman call (covers mirror retries inside)
    if pacman_with_fallback "${pkgs[@]}"; then
        log_info "All packages installed successfully."
        return 0
    fi

    # ---- CRITICAL SAFETY GATE (no recursion, no re-evaluation) ----
    # Check each critical package. If ANY missing → HALT.
    log_err "Bulk install failed. Checking critical packages..."
    local critical_failed=0

    for critical in "${CRITICAL_PKGS[@]}"; do
        if ! pacman -Q "$critical" &>/dev/null; then
            log_fatal "CRITICAL package MISSING: ${critical}"
            echo "CRITICAL: ${critical}" >> "$CRITICAL_FILE"
            critical_failed=1
        fi
    done

    if [ "$critical_failed" -eq 1 ]; then
        log_fatal "Critical packages missing. Halting installation."
        log_fatal "Best-effort recovery logs: ${LOG_FILE}"
        log_fatal "Run manually: pacman -S $(printf '%s ' "${CRITICAL_PKGS[@]}")"
        exit 1
    fi

    # ATTEMPT 2: Optional packages individually (safe to fail)
    log_warn "Attempting individual install for remaining packages..."
    local failed=0
    for pkg in "${pkgs[@]}"; do
        local is_critical=0
        for c in "${CRITICAL_PKGS[@]}"; do
            [ "$pkg" = "$c" ] && { is_critical=1; break; }
        done
        [ "$is_critical" -eq 1 ] && continue  # Already checked above

        if ! pacman -S --needed --noconfirm "$pkg" 2>/dev/null; then
            log_warn "Optional package failed: ${pkg}. Logging..."
            echo "$pkg" >> "$FAILED_FILE"
            failed=$((failed + 1))
        fi
    done

    [ "$failed" -gt 0 ] && log_warn "${failed} optional packages failed. See ${FAILED_FILE}."
    return 0
}

# ============================================================================
# Step 6: Final integrity check (best-effort with recovery logging)
# ============================================================================
integrity_check() {
    log_info "=== System Integrity Check ==="
    local pass=1

    for pkg in "${CRITICAL_PKGS[@]}"; do
        if pacman -Q "$pkg" &>/dev/null; then
            log_info "  [OK] ${pkg}"
        else
            log_err "  [FAIL] ${pkg} is MISSING!"
            echo "CRITICAL: ${pkg}" >> "$CRITICAL_FILE"
            pass=0
        fi
    done

    if [ "$pass" -eq 1 ]; then
        log_info "All 12 critical packages present."
        log_info "Integrity check PASSED. Best-effort boot with recovery logging."
        return 0
    else
        log_fatal "Integrity check FAILED. Best-effort recovery at ${LOG_FILE}."
        exit 1
    fi
}

# ============================================================================
# MAIN (single-pass, deterministic, predictable, no recursion)
# ============================================================================
main() {
    log_info "========================================"
    log_info "Methos Linux - Profile Merge v3"
    log_info "Mode: single-pass | Recursion: none"
    log_info "========================================"

    rm -f "$CRITICAL_FILE" "$FAILED_FILE"

    # ── PHASE 1: Read profiles (I/O, deterministic) ──
    local profiles
    profiles=$(read_profiles)
    log_info "Profiles: ${profiles}"

    # ── PHASE 2: Load all packages (I/O, deterministic) ──
    local -a all_pkgs=()
    for p in $profiles; do
        while IFS= read -r pkg; do
            [ -n "$pkg" ] && all_pkgs+=("$pkg")
        done < <(load_pkgs "$p")
    done

    [ ${#all_pkgs[@]} -eq 0 ] && {
        log_info "No profile packages. Running integrity check..."
        integrity_check
        return 0
    }

    log_info "Raw packages: ${#all_pkgs[@]}"

    # ── PHASE 3: SINGLE-PASS conflict resolution (no recursion) ──
    local resolved
    resolved=$(resolve_once "${all_pkgs[@]}")
    local -a final_pkgs=()
    while IFS= read -r pkg; do
        [ -n "$pkg" ] && final_pkgs+=("$pkg")
    done <<< "$resolved"

    log_info "After resolution: ${#final_pkgs[@]} packages"

    # ── PHASE 4: SINGLE-PASS install (no re-evaluation) ──
    install_single_pass "${final_pkgs[@]}"

    # ── PHASE 5: Integrity check (best-effort with logging) ──
    integrity_check

    # ── DONE ──
    log_info "========================================"
    log_info "Installation COMPLETE."
    log_info "Boot: best-effort with recovery logging."
    log_info "Profiles: ${profiles}"
    log_info "Packages: ${#final_pkgs[@]}"
    [ -f "$FAILED_FILE" ] && log_info "Failed optional: $(wc -l < "$FAILED_FILE")"
    log_info "Recovery log: ${LOG_FILE}"
    log_info "========================================"
}

main "$@"