#!/bin/bash
# Methos Linux - Calamares Config Tests

set -euo pipefail

PASS=0; FAIL=0
test_pass() { PASS=$((PASS + 1)); echo "  [PASS] $1"; }
test_fail() { FAIL=$((FAIL + 1)); echo "  [FAIL] $1"; }

echo "=== Calamares Configuration Tests ==="

BASE="archiso/airootfs/etc/calamares"

# Core files
[ -f "$BASE/settings.conf" ] && test_pass "settings.conf" || test_fail "settings.conf"
[ -f "$BASE/branding/methos/branding.desc" ] && test_pass "branding.desc" || test_fail "branding.desc"

# Required modules (8 total)
for m in welcome locale keyboard partition users packages bootloader finished; do
    [ -f "$BASE/modules/${m}.conf" ] && test_pass "Module: ${m}" || test_fail "Module: ${m} missing"
done

# Verify NOT present (deleted modules)
for m in summary initcpiocfg grubcfg displaymanager shellprocess; do
    [ ! -f "$BASE/modules/${m}.conf" ] && test_pass "Deleted: ${m}" || test_fail "Still present: ${m}"
done

# Workflow order check
WORKFLOW=$(grep -A20 'exec:' "$BASE/settings.conf" | grep '\-' | head -10)
echo "$WORKFLOW" | grep -q "mount" && test_pass "mount in workflow" || test_fail "mount missing"
echo "$WORKFLOW" | grep -q "unpackfs" && test_pass "unpackfs in workflow" || test_fail "unpackfs missing"
echo "$WORKFLOW" | grep -q "packages" && test_pass "packages in workflow" || test_fail "packages missing"
echo "$WORKFLOW" | grep -q "machineid" && test_pass "machineid in workflow" || test_fail "machineid missing"
echo "$WORKFLOW" | grep -q "bootloader" && test_pass "bootloader in workflow" || test_fail "bootloader missing"

echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"
[ "$FAIL" -eq 0 ] || exit 1