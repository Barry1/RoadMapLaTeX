```markdown
# AGENTS – Lessons learned & guidelines for the RoadMapLaTeX project

## 1. General philosophy
- **Never ship a change that does not compile**.  
  Every pull‑request, patch or snippet must be verified with `xelatex` (the
  engine used by the project).  If the compilation fails, the change is
  rejected outright unless a safe fallback is provided.
- Keep the **`newenvironment` approach** (as requested by the product manager).  
  Do **not** replace it by a start‑/stop‑command unless the team explicitly
  decides to do so.

## 2. Concrete technical learnings
| Issue | Fix / Recommendation |
|-------|----------------------|
| `\myroadmapwidth` undefined | Add `\newlength\myroadmapwidth` and initialise it (`\setlength\myroadmapwidth{\linewidth}`). |
| Missing `pgfgantt` keys (`harvey radius`, `roadmap start`, `roadmap end`) | Define only the keys that really exist (`harvey radius`, `harvey color`).  Remove the non‑existent keys from the `ganttchart` option list. |
| No helper for date conversion | Provide `\newcommand{\myroaddate}[2]{#1-#2}` (or a more robust version). |
| Use of `\IfInteger` without package | Either load `xifthen` or (preferred) drop the test – the helper macro already guarantees a proper `YYYY‑MM` string. |
| Trailing whitespace in `\define@key` | Write `\define@key{myroadmap}{font}{\def\myroadmap@font{#1}}` **without** any space after the closing brace. |
| Colour expressions like `…!40` | Enclose them in braces: `fill={\myroadmap@OpportunityColor!40}` or pre‑define a lighter alias (`\colorlet{OpportunityLight}{\myroadmap@OpportunityColor!40}`). |
| Missing `\roadmaplayer` macro | Define a minimal macro (e.g. `\newcommand{\roadmaplayer}[1]{\ganttnewline\textbf{#1}\ganttnewline}`) or agree on a richer implementation. |
| Undefined key `harvey percent` in link types | Register the key (`\pgfkeys{/pgfgantt/harvey percent/.initial=50}`) or hard‑code a default inside the link definition. |
| Font not found (Arial) | Keep the warning, or supply a safe fallback like `Helvetica`. |
| Environment termination errors | They disappear once all the above missing definitions are added. |

## 3. Coding style & safety
- **All custom keys must be declared** before they are used (`\pgfkeys{/pgfgantt/...}`).
- **Lengths, counters, and macros** that are referenced in options need to exist **even if they are later overwritten**.
- **Colour modifications** should always be wrapped in braces to avoid the “undefined colour `40`” error.
- **Avoid fragile commands** in the `ganttchart` options (e.g. `\IfFontExistsTF`) unless they are guaranteed to be defined.
- **Document any new macro** with a short comment explaining its purpose and usage.

## 4. Validation workflow (recommended)
1. Edit the package (`myroadmap.sty`) or example file.  
2. Run `xelatex -interaction=nonstopmode exampleRoadmap.tex`.  
3. Ensure the log ends with `Output written on …pdf (… pages).` and **no** `!` error messages.  
4. Commit only if step 3 succeeds.

---

### ✅ Bottom line for you (Dr. Bastian Ebeling)

> **Only accept patch fragments that are guaranteed to compile.**  
> If a change is ambiguous or could break the build, ask for clarification first.  

Feel free to tell me which of the open points (e.g. the exact behaviour of `\roadmaplayer` or the handling of `harvey percent`) you prefer, and I will supply the final, compile‑ready code snippets. 🚀
