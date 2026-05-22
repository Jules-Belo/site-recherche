#!/bin/bash
rm -rf "content/NOTES PERMANENTES" content/RESSOURCES
cp -rL "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/RESSOURCES" content/RESSOURCES
cp -rL "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/NOTES PERMANENTES" "content/NOTES PERMANENTES"
npx quartz sync --no-pull
