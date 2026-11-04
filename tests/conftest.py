"""What Woodwork's tests share: the repository's paths, `Skip`, compiling Typst in a temporary project, reading a panic."""

import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ENGINE = ROOT / "woodwork"
TMP = ROOT / "tests" / ".tmp"


class Skip(Exception):
    """Raised by a test that cannot run here, with the reason."""


def typst():
    """The typst executable, or a Skip when Typst is not on the PATH."""
    exe = shutil.which("typst")
    if exe is None:
        raise Skip("typst is not on the PATH")
    return exe


def project(files=None):
    """A fresh temporary project holding a copy of `woodwork/` and `files` ({relative path: text}); returns its folder."""
    TMP.mkdir(parents=True, exist_ok=True)
    folder = Path(tempfile.mkdtemp(dir=TMP))
    if ENGINE.exists():
        shutil.copytree(ENGINE, folder / "woodwork")
    for rel, text in (files or {}).items():
        target = folder / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(text, encoding="utf-8", newline="\n")
    return folder


def compile_typ(source, files=None, lang=None):
    """Compiles `source` as `main.typ` of a fresh project holding `woodwork/`; returns (ok, stdout, stderr, pdf_path). `lang` puts `#set text(lang: …)` first."""
    exe = typst()
    head = '#set text(lang: "%s")\n' % lang if lang else ""
    folder = project(dict(files or {}, **{"main.typ": head + source}))
    pdf = folder / "main.pdf"
    proc = subprocess.run([exe, "compile", "--root", str(folder), str(folder / "main.typ"), str(pdf)],
                          capture_output=True, text=True, encoding="utf-8")
    return proc.returncode == 0, proc.stdout, proc.stderr, pdf


def query(source, selector, files=None, lang=None):
    """`typst query` of `selector` on `source` compiled as above; returns the parsed JSON, or raises AssertionError with the stderr."""
    exe = typst()
    head = '#set text(lang: "%s")\n' % lang if lang else ""
    folder = project(dict(files or {}, **{"main.typ": head + source}))
    proc = subprocess.run([exe, "query", "--root", str(folder), str(folder / "main.typ"), selector],
                          capture_output=True, text=True, encoding="utf-8")
    assert proc.returncode == 0, proc.stderr
    return json.loads(proc.stdout)


# Typst 0.15 prints a panic as `panicked with: <message>` without quotes; 0.14 quoted it. Both are read.
_PANIC = re.compile(r'panicked with: (?:"(?P<quoted>.*?)"\n|(?P<plain>.*?)(?:\n *┌─|\Z))', re.S)


def panic_message(stderr):
    """The message of a Typst panic, alone -- or None where `stderr` holds no panic."""
    found = _PANIC.search(stderr)
    if found is None:
        return None
    quoted = found.group("quoted")
    return (quoted if quoted is not None else found.group("plain")).strip()


def pdf_text(pdf):
    """The text of a compiled PDF, or a Skip when no PDF text reader is installed (pypdf)."""
    try:
        from pypdf import PdfReader
    except ImportError:
        raise Skip("pypdf is not installed")
    return "\n".join(page.extract_text() or "" for page in PdfReader(str(pdf)).pages)
