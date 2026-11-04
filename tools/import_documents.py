"""The one-time conversion of Woodcore's three content templates into skeletons (founding spec REQ-017, D-17), kept to show where each section came from.

    python tools/import_documents.py <path of Woodcore>

Reads Woodcore's templates/documents/{cu,bp,rs}/standard/{fr,de,en}/ and writes, under source/templates/<document>/, every section as a file of its language (`Sections/<name>.<lang>.typ`, generate.py sending it to that tree alone) and a new entry file per language. A section keeps its headings, its prose and its tables to fill; what read a Woodcore project's export -- the loops over its positions, plans, loads and models, a value kept in step (`#sync`), a value read from the export (`#var(…, domain: (…))`), the annexes and the journal -- gives way to a comment saying what to paste there. Woodcore's object tags (`// woodcore:…`) are dropped. Run it once; the files are then Woodwork's.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "source" / "templates"

# Woodcore's document → Woodwork's folder (English; labels.json `paths` translates it), and the entry file's name in each language.
DOCUMENTS = {
    "cu": ("service-criteria-agreement", {"fr": "convention-d-utilisation", "de": "nutzungsvereinbarung", "en": "service-criteria-agreement"}),
    "bp": ("basis-of-design", {"fr": "base-de-projet", "de": "projektbasis", "en": "basis-of-design"}),
    "rs": ("statical-report", {"fr": "rapport-de-statique", "de": "statischer-bericht", "en": "statical-report"}),
}
TITLE = {"fr": "titre-bfh", "de": "titel-bfh", "en": "title-bfh"}

# What stands where Woodcore read its export, in the language of the section.
TODO = {
    "sheets": {"fr": "À COMPLÉTER : collez ici vos feuilles de calcul (sheets/fr/…), ou incluez-les : #include \"…\".",
               "de": "ZU ERGÄNZEN: Fügen Sie hier Ihre Rechenblätter ein (sheets/de/…) oder binden Sie sie ein: #include \"…\".",
               "en": "TO COMPLETE: paste your calculation sheets here (sheets/en/…), or include them: #include \"…\"."},
    "plans": {"fr": "À COMPLÉTER : vos plans, par exemple #figure(image(\"plan.pdf\"), caption: […]).",
              "de": "ZU ERGÄNZEN: Ihre Pläne, zum Beispiel #figure(image(\"plan.pdf\"), caption: […]).",
              "en": "TO COMPLETE: your plans, for instance #figure(image(\"plan.pdf\"), caption: […])."},
    "annexes": {"fr": "À COMPLÉTER : vos annexes.", "de": "ZU ERGÄNZEN: Ihre Anhänge.", "en": "TO COMPLETE: your annexes."},
    "journal": {"fr": "À COMPLÉTER : l'historique des versions du document (version, date, modification).",
                "de": "ZU ERGÄNZEN: das Änderungsverzeichnis des Dokuments (Version, Datum, Änderung).",
                "en": "TO COMPLETE: the document's revision history (version, date, change)."},
}
ABOUT = {
    "fr": "Squelette tiré du modèle de Woodcore : complétez le texte entre crochets, collez vos feuilles de calcul là où un commentaire le demande. Placez la page de titre ({title}.typ) dans le dossier au-dessus de celui-ci, et le dossier woodwork/ à la racine du projet.",
    "de": "Gerüst aus der Vorlage von Woodcore: Ergänzen Sie den Text in eckigen Klammern, fügen Sie Ihre Rechenblätter dort ein, wo ein Kommentar es verlangt. Legen Sie die Titelseite ({title}.typ) in den Ordner über diesem und den Ordner woodwork/ in das Wurzelverzeichnis des Projekts.",
    "en": "Skeleton taken from Woodcore's template: complete the text in brackets, paste your calculation sheets where a comment asks for them. Put the title page ({title}.typ) in the folder above this one, and the folder woodwork/ at the root of the project.",
}


def balanced(text, start, open_ch, close_ch):
    """The index just past the bracket that closes the one at `start`."""
    depth = 0
    i = start
    while i < len(text):
        c = text[i]
        if c == '"':
            j = text.index('"', i + 1)
            while text[j - 1] == "\\":
                j = text.index('"', j + 1)
            i = j
        elif c == open_ch:
            depth += 1
        elif c == close_ch:
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    raise ValueError("unbalanced %s at %d" % (open_ch, start))


def todo(kind, lang):
    return "// " + TODO[kind][lang]


def kind_of(header):
    if "plan" in header or "static-model" in header:
        return "plans"
    if "annex" in header:
        return "annexes"
    if "journal" in header:
        return "journal"
    return "sheets"


def convert(text, lang):
    text = text.replace('#import "/commands.typ": *', '#import "/woodwork/woodwork.typ": *')
    # Woodcore's object tags, and its comments about its own export
    # every comment line of Woodcore's: its object tags and its notes on its own engine and window
    text = "\n".join(l for l in text.split("\n") if not l.lstrip().startswith("//"))
    # a sentence's end that sends the reader to a tab of Woodcore's window («-- saisies dans l'onglet « Journal » de Woodcore»)
    text = re.sub(r"\s*--[^.\n]*Woodcore[^.\n]*", "", text)
    # a column Woodcore's table editor kept hidden, noted at the end of a line
    text = re.sub(r"[ \t]*// woodcore:[^\n]*", "", text)
    # #sync("…")[X] → X
    while True:
        m = re.search(r'#sync\("[^"]*"\)\[', text)
        if not m:
            break
        end = balanced(text, m.end() - 1, "[", "]")
        text = text[:m.start()] + text[m.end():end - 1] + text[end:]
    # a value read from the export → a value to fill
    while True:
        m = re.search(r"#var\([^()]*domain: \(", text)
        if not m:
            break
        end = balanced(text, m.start() + 4, "(", ")")
        text = text[:m.start()] + "[…]" + text[end:]
    # the loops and conditions over the export, and its files and annexes → what to paste there
    while True:
        m = re.search(r"#(for [^\n]*?ids\(\"[^\"]+\"\)[^\n]*?\{|if ids\(\"[^\"]+\"\)[^\n]*?\[)", text)
        if not m:
            break
        opener = text[m.end() - 1]
        end = balanced(text, m.end() - 1, opener, "}" if opener == "{" else "]")
        text = text[:m.start()] + todo(kind_of(m.group(0)), lang) + text[end:]
    text = re.sub(r"#include domain-file\(\"journal\"[^)]*\)", todo("journal", lang), text)
    text = re.sub(r"#include domain-file\([^)]*\)", todo("sheets", lang), text)
    text = re.sub(r"#show-annexes\([^)]*\)", todo("annexes", lang), text)
    text = text.replace('#show-bibliography(project: "references.bib")', "#show-bibliography()")
    return re.sub(r"\n{3,}", "\n\n", text).strip() + "\n"


def entry(src_entry, doc, lang):
    lines = src_entry.read_text(encoding="utf-8").split("\n")
    start = next(i for i, l in enumerate(lines) if l.startswith("// --- Sections"))
    sections = [l for l in lines[start + 1:] if l.startswith("#include") or l.startswith("// disabled:") or l.startswith("// #include")]
    title = TITLE[lang]
    head = [
        "// " + ABOUT[lang].replace("{title}", title),
        '#import "/woodwork/woodwork.typ": *',
        '#import "/woodwork/forms/bfh.typ": bfh',
        '#set text(lang: "%s")' % lang,
        "#show: bfh",
        "",
        '#include "../%s.typ"' % title,
        "",
        "#outline()",
        "#pagebreak()",
        "",
    ]
    return "\n".join(head + sections).rstrip() + "\n"


def main():
    woodcore = Path(sys.argv[1]).resolve() / "templates" / "documents"
    count = 0
    for doc, (folder, names) in DOCUMENTS.items():
        for lang in ("fr", "de", "en"):
            src = woodcore / doc / "standard" / lang
            dst = OUT / folder
            for f in sorted((src / "Sections").glob("*.typ")):
                target = dst / "Sections" / (f.stem + "." + lang + ".typ")
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(convert(f.read_text(encoding="utf-8"), lang), encoding="utf-8", newline="\n")
                count += 1
            src_entry = next(p for p in src.glob("*.typ"))
            (dst / (names[lang] + "." + lang + ".typ")).write_text(entry(src_entry, doc, lang), encoding="utf-8", newline="\n")
            count += 1
    print("%d files" % count)


if __name__ == "__main__":
    main()
