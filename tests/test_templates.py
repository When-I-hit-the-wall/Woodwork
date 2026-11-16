"""The templates of form and of content (founding spec REQ-015 to REQ-017, D-17): a form is one function called by #show, prints no title page; the title pages and the three documents are content templates that compile in three languages."""

import shutil
import subprocess

from conftest import ENGINE, ROOT, compile_typ, panic_message, pdf_text, project, typst

FORMS = ("neutral", "compact", "bfh")
TITLES = {"fr": ("titre-bfh", "titre-neutre"), "de": ("titel-bfh", "titel-neutral"), "en": ("title-bfh", "title-neutral")}
DOCUMENTS = {"fr": ("convention-d-utilisation", "base-de-projet", "rapport-de-statique", "rapport-simple"),
             "de": ("nutzungsvereinbarung", "projektbasis", "statischer-bericht", "einfacher-bericht"),
             "en": ("service-criteria-agreement", "basis-of-design", "statical-report", "simple-report")}
# The simple report (spec 2026-11-16-skill-woodwork-report-et-simple-report): its two chapters, then the words of a table of contents and a bibliography it must not print.
SIMPLE = {"fr": ("rapport-simple", "1 Section", "2 Annexes", ("Table des matières", "Bibliographie")),
          "de": ("einfacher-bericht", "1 Abschnitt", "2 Anhang", ("Inhaltsverzeichnis", "Literaturverzeichnis")),
          "en": ("simple-report", "1 Section", "2 Appendices", ("Contents", "Bibliography"))}


def test_a_form_is_one_function_named_after_its_file_and_prints_no_title_page():
    for form in FORMS:
        ok, _, err, pdf = compile_typ('#import "/woodwork/forms/%s.typ": %s\n#show: %s\n= Chapitre\nTexte.\n' % (form, form, form), lang="fr")
        assert ok, (form, err)
        t = pdf_text(pdf)
        assert t.lstrip().startswith("1 Chapitre") or "1 Chapitre" in t.splitlines()[0:3], (form, t)
        assert "Rapport de statique" not in t, form


def test_a_form_keeps_the_documents_language_unless_told():
    # the figure's word is Typst's own: French («Fig.») where the document is, German where the form says so
    body = '#import "/woodwork/forms/neutral.typ": neutral\n#show: neutral%s\n#figure(rect(), caption: [x])\n'
    ok, _, err, pdf = compile_typ(body % "", lang="fr")
    assert ok, err
    assert "Fig. 1" in pdf_text(pdf), pdf_text(pdf)
    ok, _, err, pdf = compile_typ(body % '.with(lang: "de")', lang="fr")
    assert ok, err
    assert "Abbildung 1" in pdf_text(pdf), pdf_text(pdf)


def test_the_bfh_form_sets_its_header_and_footer():
    ok, _, err, pdf = compile_typ('#import "/woodwork/forms/bfh.typ": bfh\n#show: bfh\n= Chapitre\nTexte.\n', lang="fr")
    assert ok, err
    assert "Berner Fachhochschule | Haute école spécialisée bernoise | Bern University of Applied Sciences" in pdf_text(pdf).replace("  ", " "), pdf_text(pdf)


BFH_TABLE = """#figure(caption: [Schichtaufbau Dach], {
  table(columns: (auto, 1fr, auto),
    table.header([Typ], [Schicht], [Last]),
    [$a_k$], [Latte C24], [0.006],
    [$g_k$], [Brettschichtholz GL24h], [0.352],
    table.footer([$g_k$], [Total Eigengewicht], [0.352]))
  [Legende unter der Tabelle.]
})
"""


def test_the_bfh_form_sets_a_table_its_title_above_and_its_legend_below():
    # spec 2026-11-05-style-tableaux-bfh: title above, centred; the totals of table.footer; the legend under the table
    ok, _, err, pdf = compile_typ('#import "/woodwork/forms/bfh.typ": bfh\n#show: bfh.with(lang: "de")\n= Kapitel\n' + BFH_TABLE)
    assert ok, err
    # pypdf reads a space after the no-break space of a bold caption, though the page shows one: collapse them
    t = " ".join(pdf_text(pdf).split())
    assert t.index("Tabelle 1") < t.index("Typ") < t.index("Total Eigengewicht") < t.index("Legende"), t
    # the other forms keep Typst's own figure: the caption under the table
    ok, _, err, pdf = compile_typ('#import "/woodwork/forms/neutral.typ": neutral\n#show: neutral.with(lang: "de")\n' + BFH_TABLE)
    assert ok, err
    t = pdf_text(pdf)
    assert t.index("Typ") < t.index("Tabelle 1"), t


def generated(lang):
    return {p.relative_to(ROOT / "templates" / lang).as_posix(): p.read_text(encoding="utf-8") for p in (ROOT / "templates" / lang).rglob("*.typ")}


def test_the_title_pages_compile_and_print_their_fields():
    for lang, (bfh, neutral) in TITLES.items():
        files = generated(lang)
        for title, form in ((bfh, "bfh"), (neutral, "neutral")):
            text = files[title + ".typ"].replace('#let project = "', '#let project = "Pont du Ruz ', 1)
            ok, _, err, pdf = compile_typ('#import "/woodwork/forms/%s.typ": %s\n#show: %s\n#include "t.typ"\n= X\n' % (form, form, form), files={"t.typ": text}, lang=lang)
            assert ok, (lang, title, err)
            t = pdf_text(pdf)
            assert "Pont du Ruz" in t, (lang, title, t[:200])
    assert "Bienne" in pdf_text(compile_typ('#include "t.typ"\n', files={"t.typ": generated("fr")["titre-bfh.typ"]}, lang="fr")[3])


def test_the_twelve_document_skeletons_compile():
    exe = typst()
    folder = project()
    shutil.copytree(ROOT / "templates", folder / "templates")
    for lang, names in DOCUMENTS.items():
        for name in names:
            entry = folder / "templates" / lang / name / (name + ".typ")
            assert entry.exists(), entry
            proc = subprocess.run([exe, "compile", "--root", str(folder), str(entry), str(folder / (name + ".pdf"))], capture_output=True, text=True, encoding="utf-8")
            assert proc.returncode == 0, (lang, name, proc.stderr[-1500:])


def test_no_skeleton_reads_a_woodcore_project():
    for p in (ROOT / "source" / "templates").rglob("*.typ"):
        text = p.read_text(encoding="utf-8")
        for gone in ("ids(", "domain-file", "#sync(", "woodcore:", "project-info", "title-page(", "set-report-language", "/commands.typ"):
            assert gone not in text, (p.relative_to(ROOT).as_posix(), gone)


def test_a_title_page_has_neither_header_nor_footer():
    # REQ-016: the form bfh's footer stands on the pages after the title page, not on it
    files = generated("fr")
    ok, _, err, pdf = compile_typ('#import "/woodwork/forms/bfh.typ": bfh\n#show: bfh\n#include "t.typ"\n= Chapitre\nTexte.\n', files={"t.typ": files["titre-bfh.typ"]}, lang="fr")
    assert ok, err
    from pypdf import PdfReader
    pages = [p.extract_text() for p in PdfReader(str(pdf)).pages]
    assert "Haute école spécialisée bernoise" not in pages[0], pages[0]
    assert "Haute école spécialisée bernoise" in pages[-1], pages[-1]


def test_the_bfh_form_sets_its_sans_font():
    # REQ-015: Lucida Sans, Segoe UI then Arial where it is not installed
    ok, _, err, pdf = compile_typ('#import "/woodwork/forms/bfh.typ": bfh\n#show: bfh\nTexte.\n', lang="fr")
    assert ok, err
    from pypdf import PdfReader
    names = " ".join(str(f.get_object()["/BaseFont"]) for f in PdfReader(str(pdf)).pages[0]["/Resources"]["/Font"].get_object().values())
    assert any(n in names for n in ("Lucida", "Segoe", "Arial")), names


def test_the_bfh_form_lets_a_chapter_follow_on_the_same_page():
    # REQ-008: chapter-break true (the default) starts every chapter on a page of its own, false does not; a value that is not a boolean is refused
    from pypdf import PdfReader
    body = '#import "/woodwork/forms/bfh.typ": bfh\n#show: bfh%s\n= Un\nTexte.\n= Deux\nTexte.\n'
    for arg, pages in (("", 2), (".with(chapter-break: true)", 2), (".with(chapter-break: false)", 1)):
        ok, _, err, pdf = compile_typ(body % arg, lang="fr")
        assert ok, (arg, err)
        assert len(PdfReader(str(pdf)).pages) == pages, arg
    ok, _, err, _ = compile_typ(body % '.with(chapter-break: "no")', lang="fr")
    assert not ok
    message = panic_message(err)
    assert message is not None and "chapter-break" in message and '"no"' in message, err


def test_the_simple_report_prints_its_title_and_two_chapters_on_its_first_page():
    # REQ-007, UI-001 to UI-003: no title page, the title block then «1 Section», then «2 Annexes»; no outline, no bibliography
    from pypdf import PdfReader
    for lang, (name, section, annexes, absent) in SIMPLE.items():
        text = generated(lang)[name + "/" + name + ".typ"]
        assert "outline(" not in text and "show-bibliography" not in text, lang
        text = text.replace('#let project = "', '#let project = "Pont du Ruz ', 1)
        ok, _, err, pdf = compile_typ('#include "%s/%s.typ"\n' % (name, name), files={name + "/" + name + ".typ": text})
        assert ok, (lang, err)
        pages = [" ".join(p.extract_text().split()) for p in PdfReader(str(pdf)).pages]
        assert len(pages) == 1, (lang, len(pages))
        first = pages[0]
        # the form's running header names the page's chapter first («1 Section»): the chapter itself is looked for after the title block
        title = first.index("Pont du Ruz")
        assert title < first.index(section, title) < first.index(annexes, title), (lang, first)
        for word in absent:
            assert word not in first, (lang, word)
