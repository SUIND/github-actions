#!/bin/bash
set -e

# Replace GitHub Actions expressions with environment variables
source="${GITHUB_HEAD_REF}"
target="${GITHUB_BASE_REF}"

echo "Source branch: $source"
echo "Target branch: $target"

# Extract prefix and type (if applicable)
if [[ "$source" == */* ]]; then
  source_prefix=$(echo "$source" | cut -d'/' -f1)
  source_type=$(echo "$source" | cut -d'/' -f2)
else
  source_prefix="none"
  source_type="$source"
fi

if [[ "$target" == */* ]]; then
  target_prefix=$(echo "$target" | cut -d'/' -f1)
  target_type=$(echo "$target" | cut -d'/' -f2)
else
  target_prefix="none"
  target_type="$target"
fi

echo "Source prefix: $source_prefix"
echo "Source type: $source_type"
echo "Target prefix: $target_prefix"
echo "Target type: $target_type"

# Validation logic
if [[ ("$target_type" == "deploy" || "$source_type" == "testing") && "$source_prefix" != "$target_prefix" ]]; then
  echo "Error: Source prefix ($source_prefix) does not match target prefix ($target_prefix)."
  exit 1
fi

if [[ "$target_type" == "deploy" && "$source_type" != "testing" ]]; then
  echo "Error: PR to 'deploy' branches must originate from 'testing' branches."
  exit 1
elif [[ "$target_type" == "testing" && "$source_type" != "development" ]]; then
  echo "Error: PR to 'testing' branches must originate from 'development' branches."
  exit 1
fi

echo "Branch rules validated successfully."
