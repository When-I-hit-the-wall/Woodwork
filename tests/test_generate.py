"""The generated trees (founding spec REQ-003, REQ-004, UI-002, ARCH-004): sheets/ and templates/ are what tools/generate.py writes from source/, byte for byte, in three languages, one named argument a line."""

import re
import subprocess
import sys
from pathlib import Path

from conftest import ROOT

sys.path.insert(0, str(ROOT / "tools"))
import generate  # noqa: E402

LANGS = ("fr", "de", "en")


def test_the_trees_are_what_the_generator_writes():
    proc = subprocess.run([sys.executable, str(ROOT / "tools" / "generate.py"), "--check"], capture_output=True, text=True, encoding="utf-8")
    assert proc.returncode == 0, "sheets/ or templates/ differ from source/ -- run python tools/generate.py:\n" + proc.stdout + proc.stderr


def test_the_three_trees_hold_the_same_files():
    for kind in generate.KINDS:
        counts = {lang: len([p for p in (ROOT / kind / lang).rglob("*") if p.is_file()]) for lang in LANGS if (ROOT / kind / lang).exists()}
        assert len(set(counts.values())) <= 1, (kind, counts)
    assert (ROOT / "sheets" / "fr").exists()


def test_no_key_is_left_and_no_word_is_the_english_in_french():
    for p in (ROOT / "sheets").rglob("*.typ"):
        text = p.read_text(encoding="utf-8")
        assert not generate.KEY.search(text), (p, generate.KEY.search(text).group(0))
    labels, _ = generate.load_labels()
    fr = "\n".join(p.read_text(encoding="utf-8") for p in (ROOT / "sheets" / "fr").rglob("*.typ"))
    for key, entry in labels.items():
        if entry["fr"] != entry["en"] and ('"%s"' % entry["en"]) in fr:
            raise AssertionError("the English of %r stands in a French sheet" % key)


def test_one_named_argument_a_line():
    # UI-002: `#var("b", 140, "mm",` then one argument a line, indented with a tab
    command = re.compile(r"#(domain|var|eq|verify|material)\(")
    for p in (ROOT / "sheets").rglob("*.typ"):
        for n, line in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
            if command.search(line):
                named = re.findall(r"(?<![\w-])[a-z][\w-]*:\s", line.split("`")[0] if "`" in line else line)
                assert len(named) == 0, "%s:%d holds a named argument on the command's line: %s" % (p.relative_to(ROOT), n, line)
            elif line.startswith("\t"):
                assert len(re.findall(r"(?<![\w-])[a-z][\w-]*: ", line)) <= 1, "%s:%d: %s" % (p.relative_to(ROOT), n, line)


def test_a_missing_label_is_named_with_its_file():
    try:
        generate.translate_text('label: "{no-such-key}"', "fr", {}, "source/sheets/x.typ")
    except generate.GenerationError as e:
        assert str(e) == "source/sheets/x.typ: no label 'no-such-key' in source/labels.json", e
    else:
        raise AssertionError("no refusal")
    try:
        generate.translate_text('label: "{some-key}"', "de", {"some-key": {"fr": "x", "en": "y"}}, "s.typ")
    except generate.GenerationError as e:
        assert "has no de" in str(e), e
    else:
        raise AssertionError("no refusal")


def test_a_key_of_one_word_known_to_the_labels_is_refused():
    try:
        generate.translate_text('label: "{width}"', "fr", {"width": {"fr": "Largeur"}}, "s.typ")
    except generate.GenerationError as e:
        assert "holds a hyphen" in str(e), e
    else:
        raise AssertionError("no refusal")
    # a code block of one word is left alone
    assert generate.translate_text("#{x}", "fr", {}, "s.typ") == "#{x}"


def test_names_and_the_detailed_suffix_are_translated():
    paths = {"tension": {"fr": "traction", "de": "zug"}, "tension-parallel": {"fr": "traction-axe", "de": "zug-parallel"}, "detailed": {"fr": "detaille", "de": "detailliert"}}
    assert generate.target_of(Path("tension/tension-parallel-detailed.typ"), "fr", paths) == Path("traction/traction-axe-detaille.typ")
    assert generate.target_of(Path("tension/tension-parallel.typ"), "en", paths) == Path("tension/tension-parallel.typ")
    try:
        generate.target_of(Path("other/x.typ"), "de", paths)
    except generate.GenerationError as e:
        assert "no name for 'other'" in str(e), e
    else:
        raise AssertionError("no refusal")
