#!/bin/bash
rm -rf "content/NOTES PERMANENTES" content/RESSOURCES
cp -rL "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/RESSOURCES" content/RESSOURCES
cp -rL "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/NOTES PERMANENTES" "content/NOTES PERMANENTES"
cp "/Users/julesbelo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Stage M2/RESSOURCES/Visualisation/Poster_final_Belo_Jules.png" content/

python3 - << 'PYEOF'
import os, re

def strip_dataview(content):
    return re.sub(
        r'```dataview\n.*?```',
        '*→ Contenu dynamique — voir Obsidian pour la vue complète.*',
        content, flags=re.DOTALL
    )

for root, dirs, files in os.walk('content'):
    for f in files:
        if f.endswith('.md'):
            path = os.path.join(root, f)
            with open(path, 'r', encoding='utf-8') as fh:
                txt = fh.read()
            new = strip_dataview(txt)
            if new != txt:
                with open(path, 'w', encoding='utf-8') as fh:
                    fh.write(new)
                print(f"  Dataview stripped: {path}")
PYEOF

npx quartz sync --no-pull
