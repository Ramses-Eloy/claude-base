"""Agrega model/env de la plantilla al settings.json de un proyecto, solo si faltan."""
import json, sys
p, t = sys.argv[1:3]
d = json.load(open(p, encoding="utf8")); b = json.load(open(t, encoding="utf8")); c = []
for k in ("model", "env"):
    if k not in d: d[k] = b[k]; c.append(k)
    elif k == "env":
        for e, v in b[k].items():
            if e not in d[k]: d[k][e] = v; c.append("env." + e)
if c:
    with open(p, "w", encoding="utf8") as f: json.dump(d, f, indent=2, ensure_ascii=False); f.write("\n")
print("  settings.json: agregado " + ", ".join(c) if c else "  settings.json: política de modelos ya presente")
