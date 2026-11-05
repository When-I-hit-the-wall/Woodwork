"""Double-click: the window that exports a case of these workbooks to Typst (tools/actions_typ.py, where everything is said)."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "tools"))
import actions_typ  # noqa: E402

actions_typ.window()
