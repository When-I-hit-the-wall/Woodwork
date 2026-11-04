"""The one-time copy of Woodcore's norm tables into woodwork/data/ (founding spec REQ-010, D-13), kept to show where each table came from.

    python tools/import_norms.py <path of Woodcore>

Copies the tables of the norms listed in NORMS from Woodcore's calc/norms/, each into the folder of its norm, its name without the norm and the edition (`sia265-2021-tab09-brettschichtholz.json` → `sia265/tab09-brettschichtholz.json`; the edition stays in the file, `edition` and `_source`). The excerpts (`*-excerpts.json`), which quote the text of clauses, are not copied (CON-007). Every file is rewritten **textually**: its values, `_source`, titles and labels stay byte for byte; only a `_note` that sends the reader to Woodcore's code or docs loses the sentence or the parenthesis that does. It writes `woodwork/data/imported.json`: each copied file, the Woodcore file it came from, and Woodcore's commit.
"""

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "woodwork" / "data"

# The norms of phase 1 (timber sections and stability): the prefix of their files in Woodcore, and the folder they go to.
NORMS = {
    "sia265-2021-": "sia265",
    "sia265-1-2018-": "sia265-1",
    "sia260-2013-": "sia260",
    "sn-en-14592-2022-": "sn-en-14592",
}

# What a note may not send the reader to: Woodcore's code, docs, specs and window.
WOODCORE = re.compile(r"docs/|calc/|lib/|tests/|norm-library|spec 20\d\d-|Woodcore|woodcore|\b\w+\.py\b|Ctrl\+click|\bUI-\d+|\bREQ-\d+|snow tab")


def clean_note(text):
    """A note without what sends the reader to Woodcore: its parentheses that do, then its sentences that still do."""
    text = re.sub(r"\s*\([^()]*\)", lambda m: "" if WOODCORE.search(m.group(0)) else m.group(0), text)
    sentences = re.split(r"(?<=[.!?])\s+(?=[A-Z⚠`«*])", text)
    kept = [s for s in sentences if not WOODCORE.search(s)]
    return " ".join(kept).strip()


def notes(node, out):
    """Every string of a key starting with `_` but `_source`, wherever it stands."""
    if isinstance(node, dict):
        for k, v in node.items():
            if isinstance(v, str) and k.startswith("_") and k != "_source":
                out.append(v)
            else:
                notes(v, out)
    elif isinstance(node, list):
        for v in node:
            notes(v, out)
    return out


def literal(s):
    return json.dumps(s, ensure_ascii=False)


def copy(src, dst):
    text = src.read_text(encoding="utf-8")
    for note in notes(json.loads(text), []):
        if not WOODCORE.search(note):
            continue
        old = literal(note)
        assert old in text, "%s: cannot find a note textually" % src.name
        new = clean_note(note)
        text = text.replace(old, literal(new) if new else literal("(no note)"))
    json.loads(text)
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(text, encoding="utf-8", newline="\n")


def main():
    woodcore = Path(sys.argv[1]).resolve()
    norms = woodcore / "calc" / "norms"
    commit = subprocess.run(["git", "-C", str(woodcore), "log", "-1", "--format=%H %cs", "--", "calc/norms"], capture_output=True, text=True).stdout.strip()
    imported = {}
    for src in sorted(norms.glob("*.json")):
        if src.name.endswith("-excerpts.json"):
            continue
        if src.name == "norms.json":
            dst = DATA / "norms.json"
        else:
            prefix = next((p for p in sorted(NORMS, key=len, reverse=True) if src.name.startswith(p)), None)
            if prefix is None:
                continue
            dst = DATA / NORMS[prefix] / src.name[len(prefix):]
        copy(src, dst)
        imported[dst.relative_to(DATA).as_posix()] = "calc/norms/" + src.name
    out = {"_note": "Each table of this folder, and the file of Woodcore's calc/norms/ it was copied from by tools/import_norms.py; tests/test_data.py holds their values equal where Woodcore is beside Woodwork.",
           "woodcore_commit": commit, "files": imported}
    (DATA / "imported.json").write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print("%d files" % len(imported))


if __name__ == "__main__":
    main()
