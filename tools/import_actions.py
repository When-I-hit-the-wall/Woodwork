"""The one-time copy of what the workbooks of actions/ need from Woodcore and is no norm table (woodwork/data/ holds those): its catalogue of materials and its templates of build-ups, kept to show where each came from.

    python tools/import_actions.py <path of Woodcore>

Writes, from Woodcore's own modules (calc/domains/materials_catalogue.py, calc/domains/materials.py, calc/libraries/dead-load-templates.json):

* `source/actions/materials.json` -- every material Woodcore's «Poids propre et surcharge» tab offers, merged as its catalogue merges them: its id, its names, its category, its origin (SIA 261 Tabellen 28 to 30, SIA 265, SIA 265/1, the office's load workbook), its weight in kN/m³ or kN/m² and where that weight is read; `aliases`, the ids a template may name for a material the catalogue merged; `roles`, what a layer may be for, in three languages, and `batten_roles`, the battens a tile «inkl. Lattung» already carries;
* `source/actions/dead-load-templates.json` -- the eight build-ups of Lignum's *Holzbau mit System*, verbatim.

tools/build_actions.py reads them to write the workbooks. Woodwork does not read Woodcore at any other time.
"""

import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "source" / "actions"


def main():
    woodcore = Path(sys.argv[1]).resolve()
    sys.path.insert(0, str(woodcore / "calc"))
    sys.path.insert(0, str(woodcore / "calc" / "tools"))
    from domains import dead_load_layers, materials, materials_catalogue
    import load_words
    commit = subprocess.run(["git", "-C", str(woodcore), "log", "-1", "--format=%H %cs"], capture_output=True, text=True).stdout.strip()
    rows = []
    for m in materials_catalogue.catalogue():
        weight = m.get("weight") or {}
        rows.append({"id": m["id"], "names": m["names"], "category": m.get("category"), "origin": m["origin"],
                     "value": weight.get("value"), "unit": weight.get("unit"), "ref": weight.get("ref") or (m.get("source") or {}).get("ref", ""),
                     "includes_battens": bool(materials.includes_battens(m["id"]))})
    shown = {r["id"] for r in rows}
    aliases = {}
    for alias, m in sorted(materials_catalogue.by_id().items()):
        if alias not in shown and m["id"] in shown:
            aliases[alias] = m["id"]
    OUT.mkdir(parents=True, exist_ok=True)
    data = {"_source": "Woodcore's catalogue of materials (calc/domains/materials_catalogue.py), read out by tools/import_actions.py at Woodcore commit %s. The weights of SIA 261 are Tabellen 28 to 30 of SIA 261:2020 (woodwork/data/sia261/); those of origin «ext» the office's load workbook, kg converted to kN with g = 10 m/s²." % commit,
            "materials": rows, "aliases": aliases,
            "roles": {role: {lang: load_words.STRINGS[lang]["ld_role_" + role] for lang in ("fr", "de", "en")} for role in dead_load_layers.ROLES},
            "batten_roles": list(dead_load_layers.BATTEN_ROLES)}
    (OUT / "materials.json").write_text(json.dumps(data, ensure_ascii=False, indent=1) + "\n", encoding="utf-8", newline="\n")
    templates = json.loads((woodcore / "calc" / "libraries" / "dead-load-templates.json").read_text(encoding="utf-8"))
    templates["_source"] = "Woodcore's calc/libraries/dead-load-templates.json, copied by tools/import_actions.py at Woodcore commit %s." % commit
    (OUT / "dead-load-templates.json").write_text(json.dumps(templates, ensure_ascii=False, indent=1) + "\n", encoding="utf-8", newline="\n")
    print("%d materials, %d aliases, %d templates" % (len(rows), len(aliases), len(templates["templates"])))


if __name__ == "__main__":
    main()
