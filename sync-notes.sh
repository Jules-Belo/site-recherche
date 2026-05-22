#!/bin/bash
rm -rf "content/NOTES PERMANENTES" content/RESSOURCES
cp -rL "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/RESSOURCES" content/RESSOURCES
cp -rL "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/NOTES PERMANENTES" "content/NOTES PERMANENTES"
cp "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/RESSOURCES/Visualisation/Poster_final_Belo_Jules.png" content/
npx quartz sync --no-pull
