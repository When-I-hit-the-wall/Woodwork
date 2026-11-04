"""Runs Woodwork's tests. Standard library only.

    python tests/run_tests.py                 every test file, each in a process of its own
    python tests/run_tests.py -k material     only the files or functions whose name matches
    python tests/run_tests.py --failed        only what failed in the previous run
    python tests/run_tests.py --related woodwork/lib/formula.typ
                                              the test files that name one of these files, plus the previous failures
    python tests/run_tests.py -v              the traceback of a failure

A test is a function `test_*` of a file `tests/test_*.py`. It fails on any exception; `conftest.Skip` skips it. Each file runs in a process of its own (`--one <file>`), stopped after `--timeout` seconds. What failed is kept in `tests/.last-run.json` for `--failed`. Exits 0 when nothing failed.
"""

import argparse
import importlib.util
import json
import os
import subprocess
import sys
import time
import traceback
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
LAST = HERE / ".last-run.json"


def run_one(path, pattern, only, verbose):
    """Runs the tests of one file in this process and prints one JSON line per test."""
    sys.path.insert(0, str(HERE))
    spec = importlib.util.spec_from_file_location(path.stem, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    import conftest
    names = [n for n in dir(module) if n.startswith("test_") and callable(getattr(module, n))]
    names.sort(key=lambda n: getattr(module, n).__code__.co_firstlineno)
    for name in names:
        full = "%s::%s" % (path.name, name)
        if pattern and pattern not in full:
            continue
        if only is not None and full not in only:
            continue
        start = time.time()
        try:
            getattr(module, name)()
            outcome, detail = "passed", ""
        except conftest.Skip as skip:
            outcome, detail = "skipped", str(skip)
        except Exception as exc:  # noqa: BLE001 -- any exception is a failure
            outcome = "failed"
            detail = traceback.format_exc() if verbose else "%s: %s" % (type(exc).__name__, exc)
        print(json.dumps({"test": full, "outcome": outcome, "detail": detail, "time": round(time.time() - start, 2)}), flush=True)


def main():
    # a failure quotes a PDF's text, math letters included: never die on the console's code page
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser()
    parser.add_argument("-k", dest="pattern", default="")
    parser.add_argument("--failed", action="store_true")
    parser.add_argument("--related", nargs="+", default=None)
    parser.add_argument("-v", action="store_true", dest="verbose")
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--one", default=None, help=argparse.SUPPRESS)
    parser.add_argument("--only", default=None, help=argparse.SUPPRESS)
    args = parser.parse_args()

    if args.one:
        only = set(json.loads(args.only)) if args.only else None
        run_one(Path(args.one), args.pattern, only, args.verbose)
        return 0

    files = sorted(HERE.glob("test_*.py"))
    previous = json.loads(LAST.read_text(encoding="utf-8")) if LAST.exists() else []
    only = None
    if args.failed:
        only = set(previous)
        files = [f for f in files if any(t.startswith(f.name + "::") for t in only)]
    elif args.related:
        names = [Path(r).name for r in args.related] + [Path(r).stem for r in args.related]
        files = [f for f in files if any(n in f.read_text(encoding="utf-8") for n in names) or any(t.startswith(f.name + "::") for t in previous)]
    if args.pattern:
        files = [f for f in files if args.pattern in f.name or args.pattern in f.read_text(encoding="utf-8")]

    results = []
    start = time.time()
    for f in files:
        cmd = [sys.executable, "-X", "utf8", str(Path(__file__).resolve()), "--one", str(f), "-k", args.pattern]
        if args.verbose:
            cmd.append("-v")
        if only is not None:
            cmd += ["--only", json.dumps(sorted(only))]
        try:
            proc = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", timeout=args.timeout)
            lines = [json.loads(l) for l in proc.stdout.splitlines() if l.startswith("{")]
            if proc.returncode != 0 and not lines:
                lines = [{"test": f.name + "::<import>", "outcome": "failed", "detail": proc.stderr.strip()[-2000:], "time": 0}]
        except subprocess.TimeoutExpired:
            lines = [{"test": f.name + "::<timeout>", "outcome": "failed", "detail": "stopped after %d s" % args.timeout, "time": args.timeout}]
        for r in lines:
            mark = {"passed": ".", "skipped": "s", "failed": "F"}[r["outcome"]]
            print(mark, end="", flush=True)
        results += lines
    print()
    failed = [r for r in results if r["outcome"] == "failed"]
    for r in failed:
        print("FAILED %s\n  %s" % (r["test"], r["detail"].replace("\n", "\n  ")))
    for r in results:
        if r["outcome"] == "skipped":
            print("skipped %s -- %s" % (r["test"], r["detail"]))
    passed = sum(r["outcome"] == "passed" for r in results)
    skipped = sum(r["outcome"] == "skipped" for r in results)
    print("%d passed, %d failed, %d skipped in %.1f s" % (passed, len(failed), skipped, time.time() - start))
    LAST.write_text(json.dumps([r["test"] for r in failed]), encoding="utf-8", newline="\n")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
