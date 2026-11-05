"""The norm tables of woodwork/data/ (founding spec REQ-010, CON-002, CON-007, D-13): each names its source, sends no reader to Woodcore's code, quotes no clause's text, and holds the values of the Woodcore table it was copied from."""

import json
import re
import sys

from conftest import ENGINE, ROOT, Skip

sys.path.insert(0, str(ROOT / "tools"))
from import_norms import QUOTES  # noqa: E402

DATA = ENGINE / "data"
IMPORTED = json.loads((DATA / "imported.json").read_text(encoding="utf-8"))
OWN = {"imported.json", "presets.json"}


def tables():
    return [p for p in sorted(DATA.rglob("*.json")) if p.relative_to(DATA).as_posix() not in OWN and "my-materials" not in p.parts]


def test_every_table_was_imported_and_names_its_source():
    for p in tables():
        rel = p.relative_to(DATA).as_posix()
        assert rel in IMPORTED["files"], rel
        assert p.read_text(encoding="utf-8").lstrip().startswith("{"), rel
        assert "_source" in json.loads(p.read_text(encoding="utf-8")), rel


def test_no_note_sends_the_reader_to_woodcore():
    sys.path.insert(0, str(ROOT / "tools"))
    from import_norms import WOODCORE, notes
    for p in tables():
        for note in notes(json.loads(p.read_text(encoding="utf-8")), []):
            assert not WOODCORE.search(note), "%s: %s" % (p.name, note[:120])


def test_no_excerpt_of_a_norm_is_copied():
    assert not list(DATA.rglob("*excerpts*")), list(DATA.rglob("*excerpts*"))
    for p in tables():
        assert not any(key in json.loads(p.read_text(encoding="utf-8")) for key in QUOTES), p.name


def strip_notes(node):
    if isinstance(node, dict):
        return {k: strip_notes(v) for k, v in node.items() if not (k.startswith("_") and k != "_source")}
    if isinstance(node, list):
        return [strip_notes(v) for v in node]
    return node


def test_the_values_are_woodcores():
    woodcore = ROOT.parent / "Woodcore" / "calc" / "norms"
    if not woodcore.exists():
        raise Skip("Woodcore is not beside Woodwork")
    for rel, origin in IMPORTED["files"].items():
        src = woodcore / origin.removeprefix("calc/norms/")
        if not src.exists():
            continue
        mine = strip_notes(json.loads((DATA / rel).read_text(encoding="utf-8")))
        theirs = {k: v for k, v in strip_notes(json.loads(src.read_text(encoding="utf-8"))).items() if k not in QUOTES}
        assert mine == theirs, rel


def test_the_bibliography_reads_the_norms_of_woodwork():
    from conftest import compile_typ, pdf_text
    ok, _, err, pdf = compile_typ('#import "/woodwork/woodwork.typ": *\n#var("b", 1, "mm", norm: "SIA 265", norm-section: "4.2.1")\n#show-bibliography()\n', lang="fr")
    assert ok, err
    assert re.search(r"SIA 265:2021", pdf_text(pdf)), pdf_text(pdf)
