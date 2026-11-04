"""The development tooling: the skills and agents name no Woodcore code, and the maps of CLAUDE.md and docs/README.md point at files that exist."""

import re

from conftest import ROOT

SKILLS = ("requirements", "big-feature", "small-feature", "architecture-review", "implementation",
          "verify-requirements", "finish", "issue", "typst-sheet", "typst-writing-document")
AGENTS = ("code-scout", "requirements-analyst", "architecture-reviewer", "requirements-verifier")


def test_every_skill_and_agent_is_there():
    for name in SKILLS:
        text = (ROOT / ".claude" / "skills" / name / "SKILL.md").read_text(encoding="utf-8")
        assert text.startswith("---\nname: %s\n" % name), name
    for name in AGENTS:
        text = (ROOT / ".claude" / "agents" / (name + ".md")).read_text(encoding="utf-8")
        assert text.startswith("---\nname: %s\n" % name), name


def test_no_woodcore_code_is_named():
    # The tooling was adapted from Woodcore's: none of it may send a session to Woodcore's code, window or tabs.
    banned = re.compile(r"calc/domains|calc/tools|PySide|WRITERS|woodcore_gui|commands\.json|docs/ui/")
    files = list((ROOT / ".claude").rglob("*.md")) + [ROOT / "CLAUDE.md"]
    found = [(f.relative_to(ROOT).as_posix(), m.group(0)) for f in files for m in banned.finditer(f.read_text(encoding="utf-8"))]
    assert not found, found


def test_the_maps_point_at_files_that_exist():
    for doc in (ROOT / "CLAUDE.md", ROOT / "docs" / "README.md"):
        base = ROOT if doc.name == "CLAUDE.md" else ROOT / "docs"
        text = doc.read_text(encoding="utf-8")
        for rel in re.findall(r"`((?:docs/)?[\w/-]+\.md)`", text):
            # a name is relative to the map's folder, or to the repository's root (CHANGELOG.md)
            assert (base / rel).exists() or (ROOT / rel).exists(), "%s names %s" % (doc.name, rel)


def test_the_spec_template_speaks_of_woodwork():
    text = (ROOT / "docs" / "requirements" / "TEMPLATE.md").read_text(encoding="utf-8")
    assert "Woodcore" not in text
