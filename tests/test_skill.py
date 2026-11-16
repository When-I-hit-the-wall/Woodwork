"""The user's Claude skill «woodwork-report» (spec 2026-11-16-skill-woodwork-report-et-simple-report): written once in skill/, its copies assembled by tools/install_skill.py, installed only where it is told -- never into the real ~/.claude by a test."""

import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from conftest import ROOT, TMP, compile_typ, typst

sys.path.insert(0, str(ROOT / "tools"))
import install_skill  # noqa: E402

SKILL_MD = (ROOT / "skill" / "woodwork-report" / "SKILL.md").read_text(encoding="utf-8")
TYP_BLOCK = re.compile(r"```typ\n(.*?)```", re.S)


def tmp_dest():
    TMP.mkdir(parents=True, exist_ok=True)
    return Path(tempfile.mkdtemp(dir=TMP))


def test_the_skill_is_named_and_says_when_to_use_it():
    head = SKILL_MD.split("---")[1]
    assert re.search(r"^name: woodwork-report$", head, re.M), head
    assert re.search(r"^description: .*Typst.*", head, re.M), head


def test_the_skill_source_holds_no_copy_of_the_engine_or_the_docs():
    # ARCH-001: skill/ holds what is written by hand; every copy is made by tools/install_skill.py
    files = [p.relative_to(ROOT / "skill").as_posix() for p in (ROOT / "skill").rglob("*") if p.is_file()]
    assert files == ["woodwork-report/SKILL.md"], files


def test_the_assembled_skill_is_the_repository_byte_for_byte():
    # REQ-003, REQ-004, ARCH-001: the engine, the sheets, the templates and the commands' reference, as they are in the repository
    files = install_skill.assemble()
    for prefix, tree in (("assets/woodwork", ROOT / "woodwork"), ("assets/sheets", ROOT / "sheets"), ("assets/templates", ROOT / "templates")):
        on_disk = {"%s/%s" % (prefix, p.relative_to(tree).as_posix()): p.read_bytes() for p in tree.rglob("*") if p.is_file()}
        assert on_disk, prefix
        assembled = {k: v for k, v in files.items() if k.startswith(prefix + "/")}
        assert assembled == on_disk, prefix
    assert files["references/commands.md"] == (ROOT / "docs" / "typst" / "commands.md").read_bytes()


def test_the_installed_skill_carries_the_engines_version():
    # REQ-002, ARCH-RISK-003: one number, woodwork-version of woodwork.typ
    version = re.search(r'#let woodwork-version = "([^"]+)"', (ROOT / "woodwork" / "woodwork.typ").read_text(encoding="utf-8")).group(1)
    text = install_skill.assemble()["SKILL.md"].decode("utf-8")
    assert "Woodwork version of this copy: %s." % version in text, text[:600]
    assert install_skill.VERSION_MARK not in text


def test_the_catalogue_lists_exactly_the_sheets():
    # REQ-004: every standard and detailed sheet of every language, and nothing else
    catalog = install_skill.assemble()["references/catalog.md"].decode("utf-8")
    named = set(re.findall(r"`([^`]+\.typ)`", catalog))
    for lang in ("fr", "de", "en"):
        tree = ROOT / "sheets" / lang
        for p in tree.rglob("*.typ"):
            assert p.relative_to(tree).as_posix() in named, (lang, p)
    every = {p.relative_to(ROOT / "sheets" / lang).as_posix() for lang in ("fr", "de", "en") for p in (ROOT / "sheets" / lang).rglob("*.typ")}
    assert named <= every, named - every
    assert "| Bending parallel to the grain (SIA 265) |" in catalog, catalog[:800]
    assert "`M_y_d` 12 kNm" in catalog


def test_install_writes_only_where_it_is_told_and_replaces_an_earlier_copy():
    # REQ-002, ARCH-RISK-002: --dest; a second install replaces the first; --check says up to date, then out of date
    home = install_skill.default_dest() / "woodwork-report"
    before = home.exists() and sorted(p.as_posix() for p in home.rglob("*"))
    dest = tmp_dest()
    folder = install_skill.install(dest)
    assert folder == dest / "woodwork-report"
    (folder / "stale.txt").write_text("from an older install", encoding="utf-8")
    install_skill.install(dest)
    assert not (folder / "stale.txt").exists()
    assert install_skill.main(["--check", "--dest", str(dest)]) == 0
    (folder / "references" / "commands.md").write_text("old", encoding="utf-8")
    assert install_skill.main(["--check", "--dest", str(dest)]) == 1
    after = home.exists() and sorted(p.as_posix() for p in home.rglob("*"))
    assert before == after, "a test touched the real ~/.claude/skills"


def test_the_zip_holds_the_skill_under_its_folder_and_installs_nothing():
    # D-25: --zip writes every assembled file under woodwork-report/, byte for byte, and leaves ~/.claude alone
    import zipfile
    home = install_skill.default_dest() / "woodwork-report"
    before = home.exists() and sorted(p.as_posix() for p in home.rglob("*"))
    path = tmp_dest() / "woodwork-report.zip"
    assert install_skill.main(["--zip", str(path)]) == 0
    files = install_skill.assemble()
    with zipfile.ZipFile(path) as z:
        held = {name: z.read(name) for name in z.namelist()}
    assert held == {"woodwork-report/" + rel: data for rel, data in files.items()}
    assert b"Woodwork version of this copy: " in held["woodwork-report/SKILL.md"]
    after = home.exists() and sorted(p.as_posix() for p in home.rglob("*"))
    assert before == after, "--zip touched the real ~/.claude/skills"


def test_the_skills_examples_compile_in_an_empty_project_with_its_engine():
    # REQ-003, REQ-005: what the skill teaches compiles with the engine it carries, and nothing else
    exe = typst()
    folder = install_skill.install(tmp_dest())
    blocks = [b for b in TYP_BLOCK.findall(SKILL_MD) if b.startswith('#import "/woodwork/woodwork.typ"')]
    assert blocks, "SKILL.md shows no example that compiles"
    for i, block in enumerate(blocks):
        project = tmp_dest()
        shutil.copytree(folder / "assets" / "woodwork", project / "woodwork")
        (project / "main.typ").write_text(block, encoding="utf-8", newline="\n")
        proc = subprocess.run([exe, "compile", "--root", str(project), str(project / "main.typ"), str(project / "main.pdf")], capture_output=True, text=True, encoding="utf-8")
        assert proc.returncode == 0, (i, proc.stderr[-1500:])


def test_the_simple_report_of_the_skill_compiles_with_a_pasted_sheet():
    # the method of SKILL.md, step 3 and 4: the skeleton, a sheet pasted under «Section», its heading demoted, its domain renamed
    files = install_skill.assemble()
    skeleton = files["assets/templates/en/simple-report/simple-report.typ"].decode("utf-8")
    sheet = files["assets/sheets/en/timber-sections/bending/bending.typ"].decode("utf-8")
    sheet = sheet.replace('#import "/woodwork/woodwork.typ": *\n', "").replace("\n= ", "\n== Purlin P1 -- ", 1).replace('#domain("bending"', '#domain("bending-p1"')
    marker = "// TO FILL IN: paste your calculation sheets here"
    assert marker in skeleton
    skeleton = skeleton.replace(marker, sheet + "\n" + marker, 1)
    ok, _, err, _ = compile_typ('#include "simple-report/simple-report.typ"\n', files={"simple-report/simple-report.typ": skeleton})
    assert ok, err


def test_the_skill_keeps_to_woodwork_and_to_typst():
    # REQ-006, ARCH-003, CON-001: woodcore's tools are excluded by name; no Woodcore path; no Python in the user's project
    assert "Do not use the `mcp__woodcore__*` tools" in SKILL_MD
    method = SKILL_MD.split("## Method", 1)[1]
    assert "python" not in method.lower(), "the method asks for Python in the user's project"
    for gone in ("Woodcore/", "woodcore/lib", "C:\\", "/Users/"):
        assert gone not in SKILL_MD, gone
