#!/bin/bash
# Methos Linux - Build Test Suite
# Validates the ISO build configuration

set -euo pipefail

PASS=0
FAIL=0

test_pass() { PASS=$((PASS + 1)); echo "  [PASS] $1"; }
test_fail() { FAIL=$((FAIL + 1)); echo "  [FAIL] $1"; }

echo "=== Methos Linux Build Tests ==="

# Test 1: profiledef.sh exists
[ -f "archiso/profiledef.sh" ] && test_pass "profiledef.sh exists" || test_fail "profiledef.sh missing"

# Test 2: GRUB config exists
[ -f "archiso/grub/cfg/grub.cfg" ] && test_pass "grub.cfg exists" || test_fail "grub.cfg missing"

# Test 3: Calamares settings exist
[ -f "archiso/airootfs/etc/calamares/settings.conf" ] && test_pass "settings.conf exists" || test_fail "settings.conf missing"

# Test 4: All 6 profiles exist
for p in developer pentester ai-engineer devops student minimal; do
    [ -f "archiso/profiles/${p}.pkgs" ] && test_pass "Profile: ${p}" || test_fail "Profile: ${p} missing"
done

# Test 5: merge_profiles.sh exists
[ -f "archiso/airootfs/etc/calamares/scripts/merge_profiles.sh" ] && test_pass "merge_profiles.sh exists" || test_fail "merge_profiles.sh missing"

# Test 6: No syslinux directory (should be deleted)
[ ! -d "archiso/syslinux" ] && test_pass "Syslinux removed" || test_fail "Syslinux still present"

# Test 7: No efiboot directory (should be deleted)  
[ ! -d "archiso/efiboot" ] && test_pass "efiboot removed" || test_fail "efiboot still present"

echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"
[ "$FAIL" -eq 0 ] || exit 1