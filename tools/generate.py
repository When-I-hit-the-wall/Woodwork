"""Writes the three language trees of the sheets and the content templates from their one source (founding spec REQ-003, REQ-004, ARCH-004, D-6).

    python tools/generate.py            writes sheets/<lang>/ and templates/<lang>/ from source/
    python tools/generate.py --check    writes nothing; lists what differs, exits 1 if anything does

`source/sheets/` and `source/templates/` hold every file once, its folders and its name in English, every visible word a **label key** in braces -- `{tension-force}`, a key being lower-case words joined by hyphens, at least two of them, so that no Typst code block (`{ x }`) is ever mistaken for one. `source/labels.json` gives each key in fr, de and en (`labels`), and the name of every folder and file in each language (`paths`; English is the source's own name unless `paths` gives another). A key or a name missing from labels.json stops the generation, naming it and the file. The trees are written in LF and UTF-8; `--check` compares byte for byte, which tests/test_generate.py does.
"""

import json
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "source"
LANGS = ("fr", "de", "en")
# What a source tree becomes: source/<kind>/ → <kind>/<lang>/
KINDS = ("sheets", "templates")
KEY = re.compile(r"\{([a-z][a-z0-9]*(?:-[a-z0-9]+)+)\}")
# A line `// @insert <name>` is replaced by source/parts/<name>.typ: the lines a standard and a detailed sheet share, written once and copied into both, so that each generated sheet stands alone.
INSERT = re.compile(r"^[ \t]*// @insert ([\w-]+)[ \t]*\n", re.M)
PARTS = SOURCE / "parts"
# A file `name.fr.typ` (de, en) is of one language: written to that tree alone, as it is.
ONE_LANGUAGE = re.compile(r"^(.*)\.(fr|de|en)\.typ$")


class GenerationError(Exception):
    """A key or a name the labels do not give, with the file it stands in."""


def load_labels():
    data = json.loads((SOURCE / "labels.json").read_text(encoding="utf-8"))
    return data["labels"], data.get("paths", {})


def translate_text(text, lang, labels, where):
    def one(m):
        key = m.group(1)
        if key not in labels:
            raise GenerationError("%s: no label %r in source/labels.json" % (where, key))
        entry = labels[key]
        if not entry.get(lang):
            raise GenerationError("%s: the label %r has no %s" % (where, key, lang))
        return entry[lang]
    out = KEY.sub(one, text)
    # a key of one word is never read as a key (a Typst code block may be one word in braces): one that the labels hold was meant as a key, and is refused rather than left in the sheet
    for m in re.finditer(r"\{([a-z][a-z0-9]*)\}", out):
        if m.group(1) in labels:
            raise GenerationError("%s: {%s} -- a label key holds a hyphen, two words at least" % (where, m.group(1)))
    return out


def expand(text, where, depth=0):
    """`text` with every `// @insert <name>` replaced by its part, itself expanded."""
    def one(m):
        part = PARTS / (m.group(1) + ".typ")
        if not part.exists():
            raise GenerationError("%s: no part %r in source/parts/" % (where, m.group(1)))
        if depth > 5:
            raise GenerationError("%s: parts inserted more than five deep" % where)
        body = expand(part.read_text(encoding="utf-8"), where, depth + 1)
        return body if body.endswith("\n") else body + "\n"
    return INSERT.sub(one, text)


def translate_name(name, lang, paths, where):
    """A folder or a file stem in a language: `paths` gives it, else it keeps its English name in English and is missing elsewhere."""
    entry = paths.get(name)
    if lang == "en" and (entry is None or not entry.get("en")):
        return name
    if entry is None:
        raise GenerationError("%s: no name for %r in source/labels.json `paths`" % (where, name))
    if not entry.get(lang):
        raise GenerationError("%s: the name %r has no %s" % (where, name, lang))
    return entry[lang]


def target_of(rel, lang, paths):
    """The path a source file is written to in one language: every folder translated, the stem too, a `-detailed` suffix as the language writes it."""
    where = rel.as_posix()
    parts = [translate_name(p, lang, paths, where) for p in rel.parts[:-1]]
    stem = rel.stem
    detailed = stem.endswith("-detailed")
    base = stem[: -len("-detailed")] if detailed else stem
    name = translate_name(base, lang, paths, where)
    if detailed:
        name += "-" + translate_name("detailed", lang, paths, where)
    return Path(*parts, name + rel.suffix)


def plan():
    """{output path: bytes} for every file of every tree."""
    labels, paths = load_labels()
    out = {}
    for kind in KINDS:
        src = SOURCE / kind
        if not src.exists():
            continue
        for f in sorted(p for p in src.rglob("*") if p.is_file()):
            rel = f.relative_to(src)
            own = ONE_LANGUAGE.match(f.name)
            if own:
                # a file of one language (a section of a document, written in each language by hand): to that tree alone, its name and text as they are, its folders translated
                lang = own.group(2)
                where = rel.as_posix()
                folders = [translate_name(p, lang, paths, where) for p in rel.parts[:-1]]
                target = ROOT / kind / lang / Path(*folders, own.group(1) + ".typ")
                data = f.read_bytes()
                if target in out and out[target] != data:
                    raise GenerationError("%s: two sources write %s" % (where, target.relative_to(ROOT).as_posix()))
                out[target] = data
                continue
            for lang in LANGS:
                target = ROOT / kind / lang / target_of(rel, lang, paths)
                if f.suffix == ".typ":
                    text = expand(f.read_text(encoding="utf-8"), "source/%s/%s" % (kind, rel.as_posix()))
                    data = translate_text(text, lang, labels, "source/%s/%s" % (kind, rel.as_posix())).encode("utf-8")
                else:
                    data = f.read_bytes()
                if target in out and out[target] != data:
                    raise GenerationError("%s: two sources write %s" % (rel.as_posix(), target.relative_to(ROOT).as_posix()))
                out[target] = data
    out.update(examples(out))
    return out


# The title page each language's example opens with, beside the form bfh.
EXAMPLE_TITLE = {"fr": "titre-bfh", "de": "titel-bfh", "en": "title-bfh"}


def examples(out):
    """examples/<lang>.typ: one document per language that sets the form bfh, its title page, and includes every sheet of that language -- what shows the whole, and what a reviewer compiles (`typst compile --root . examples/fr.typ`)."""
    made = {}
    for lang in LANGS:
        tree = ROOT / "sheets" / lang
        sheets = sorted(p.relative_to(tree).as_posix() for p in out if p.is_relative_to(tree))
        lines = ["// Generated by tools/generate.py: every sheet of sheets/%s/, in one document. Compile from the repository's root: typst compile --root . examples/%s.typ" % (lang, lang),
                 '#import "/woodwork/forms/bfh.typ": bfh',
                 '#set text(lang: "%s")' % lang,
                 "#show: bfh",
                 '#include "/templates/%s/%s.typ"' % (lang, EXAMPLE_TITLE[lang]),
                 "#outline()"]
        lines += ['#include "/sheets/%s/%s"' % (lang, s) for s in sheets]
        made[ROOT / "examples" / (lang + ".typ")] = ("\n".join(lines) + "\n").encode("utf-8")
    return made


def differences(out):
    """What the trees on disk lack or hold otherwise than the plan, and what they hold beyond it."""
    diff = []
    for path, data in out.items():
        if not path.exists():
            diff.append("missing " + path.relative_to(ROOT).as_posix())
        elif path.read_bytes() != data:
            diff.append("differs " + path.relative_to(ROOT).as_posix())
    for kind in KINDS:
        for lang in LANGS:
            tree = ROOT / kind / lang
            if tree.exists():
                for p in tree.rglob("*"):
                    if p.is_file() and p not in out:
                        diff.append("extra " + p.relative_to(ROOT).as_posix())
    return sorted(diff)


def write(out):
    for kind in KINDS:
        for lang in LANGS:
            tree = ROOT / kind / lang
            if tree.exists():
                shutil.rmtree(tree)
    for path, data in out.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)


def main(argv):
    try:
        out = plan()
    except GenerationError as e:
        print("generate: " + str(e), file=sys.stderr)
        return 2
    if "--check" in argv:
        diff = differences(out)
        for d in diff:
            print(d)
        return 1 if diff else 0
    write(out)
    print("%d files written" % len(out))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
