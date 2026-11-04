"""examples/ (founding spec REQ-001, ARCH-001, ARCH-005): one document a language, generated, that includes every sheet with the form bfh and its title page; it compiles with Typst alone in a folder holding only what it names. And one sheet copied into an empty project compiles."""

import shutil
import subprocess
import tempfile

from conftest import ROOT, TMP, compile_typ, typst

LANGS = ("fr", "de", "en")
ONE = {"fr": "sections-bois/traction/traction-axe.typ", "de": "holzquerschnitte/zug/zug-parallel.typ", "en": "timber-sections/tension/tension-parallel.typ"}


def test_the_examples_compile_alone():
    exe = typst()
    TMP.mkdir(parents=True, exist_ok=True)
    folder = tempfile.mkdtemp(dir=TMP)
    for part in ("woodwork", "sheets", "templates", "examples"):
        shutil.copytree(ROOT / part, folder + "/" + part)
    for lang in LANGS:
        proc = subprocess.run([exe, "compile", "--root", folder, folder + "/examples/%s.typ" % lang, folder + "/%s.pdf" % lang], capture_output=True, text=True, encoding="utf-8")
        assert proc.returncode == 0, (lang, proc.stderr[-1500:])


def test_one_sheet_copied_into_an_empty_project_compiles():
    # REQ-001: woodwork/ and one sheet, nothing else
    for lang, rel in ONE.items():
        text = (ROOT / "sheets" / lang / rel).read_text(encoding="utf-8")
        ok, _, err, _ = compile_typ('#include "sheet.typ"\n', files={"sheet.typ": text}, lang=lang)
        assert ok, (lang, err)
