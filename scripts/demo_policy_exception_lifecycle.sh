#!/bin/bash
set -e

echo "================================================="
echo "🏃 Running Kyverno Policy Exception Demo"
echo "================================================="

echo "1. Attempting to deploy privileged pod (No Exception)..."
echo "❌ Admission webhook denied the request: Privileged containers are not allowed."

echo "2. SecOps team reviews exception request for 'legacy-db' namespace..."
echo "✅ Creating PolicyException resource for 'legacy-db'..."
# Simulate PolicyException creation
# kubectl apply -f policies/exceptions/allow-privileged-legacy.yaml

echo "3. Retrying deployment in 'legacy-db' namespace..."
echo "✅ PolicyException applied. Pod deployed successfully."

echo "4. PolicyException Expiry..."
echo "✅ (Simulated) Exception expires after 30 days. Future deployments will be blocked."

echo "✅ Exception lifecycle demo complete."
