"""The engine taken from Woodcore lives alone (founding spec ARCH-002, ARCH-005, ARCH-006): woodwork/ compiles in an empty project, reads nothing outside itself, and speaks the document's language."""

import json
import re

from conftest import ENGINE, compile_typ, panic_message

SHEET = """#import "/woodwork/woodwork.typ": *
#domain("t",
	norm: "SIA 265")[
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 200, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Section",
	norm-section: "4.2.1.1")
]
"""


def test_woodwork_compiles_alone_in_an_empty_project():
    ok, _, err, pdf = compile_typ(SHEET)
    assert ok, err
    assert pdf.exists()


def test_the_engine_reads_nothing_outside_woodwork():
    # every json( and read( of the engine names a file of woodwork/, relative to the file that reads it; the one read( of a user's file is show-bibliography's project:, a path the user writes
    found = []
    for f in sorted((ENGINE / "lib").glob("*.typ")):
        for n, line in enumerate(f.read_text(encoding="utf-8").splitlines(), 1):
            if line.lstrip().startswith("//"):
                continue
            # every relative path the engine writes, whether read at once or kept in a constant: it resolves inside woodwork/
            for m in re.finditer(r'"(\.\./[^"]*|[\w-]+\.json)"', line):
                target = (f.parent / m.group(1)).resolve()
                if ENGINE.resolve() not in target.parents:
                    found.append("%s:%d %s" % (f.name, n, m.group(0)))
    assert not found, found


def test_nothing_of_a_woodcore_project_is_left():
    gone = ("find-calculation", "load-domain-state", "domain-heading", "uniform-level", "show-masked", "sync-depth",
            "load-position", "load-calculations", "load-journal", "project-info", "woodcore-document", "load-connections", "wc-meta", "woodcore-var")
    text = "\n".join(f.read_text(encoding="utf-8") for f in (ENGINE / "lib").glob("*.typ"))
    left = [name for name in gone if re.search(r"(?<![\w-])%s(?![\w-])" % re.escape(name), text)]
    assert not left, left


def test_every_engine_word_has_three_languages():
    glossary = json.loads((ENGINE / "lib" / "strings.json").read_text(encoding="utf-8"))
    assert glossary["languages"] == ["de", "fr", "en"]
    keys = set(glossary["engine"]) | set(glossary["templates"])
    for block in ("engine", "templates"):
        for key, entry in glossary[block].items():
            for lang in ("de", "fr", "en"):
                assert entry.get(lang), "%s has no %s" % (key, lang)
    used, prefixes = set(), set()
    for f in (ENGINE / "lib").glob("*.typ"):
        text = re.sub(r"^\s*///.*$", "", f.read_text(encoding="utf-8"), flags=re.M)
        for m in re.finditer(r'(?<![\w-])(t-str|t|t-label|t-pattern)\("([^"]+)"( \+)?', text):
            (prefixes if m.group(3) else used).add(m.group(2))
    assert used - keys == set(), used - keys
    for p in prefixes:
        assert any(k.startswith(p) for k in keys), p


def test_the_engine_speaks_the_documents_language():
    # the header of a table of variables is a word of the engine: it follows text.lang
    src = SHEET + '#var-table(domain: "t", columns: ("label", "value"))\n'
    words = {}
    for lang in ("de", "fr", "en"):
        ok, _, err, _ = compile_typ(src, lang=lang)
        assert ok, err
        glossary = json.loads((ENGINE / "lib" / "strings.json").read_text(encoding="utf-8"))
        words[lang] = glossary["engine"]["var_table.label"][lang]
    assert len(set(words.values())) == 3, words
    from conftest import query
    for lang in ("de", "fr", "en"):
        got = query('#import "/woodwork/lib/i18n.typ": report-lang\n#context [#metadata(report-lang()) <l>]', "<l>", lang=lang)
        assert got[0]["value"] == lang, got
    got = query('#import "/woodwork/lib/i18n.typ": report-lang\n#context [#metadata(report-lang()) <l>]', "<l>", lang="it")
    assert got[0]["value"] == "en", got


def test_a_sheet_sees_the_commands_and_not_the_helpers():
    ok, _, err, _ = compile_typ('#import "/woodwork/woodwork.typ": *\n#evaluate-formula\n')
    assert not ok and "unknown variable" in err, err
