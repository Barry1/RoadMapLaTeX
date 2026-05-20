# Technische Erkenntnisse: Entwicklung des `myroadmap` Pakets

Dieses Dokument hält die technischen Herausforderungen, Fehleranalysen und Lösungen fest, die während der Entwicklung und Optimierung des `myroadmap` Pakets aufgetreten sind. Es dient als Warnung und Leitfaden für die Erweiterung von `pgfgantt` in einem benutzerdefinierten LaTeX-Paket.

## 1. Die Gefahr der "Über-Optimierung" (Regression)
**Beobachtung:** Das Paket verfügte ursprünglich über eine funktionierende Schriftart-Steuerung mittels `\IfFontExistsTF`, die eine saubere Unterscheidung zwischen System-Schriften (z.B. Arial) und Fallbacks ermöglichte.

**Analyse:** Durch den Versuch, die Logik "robuster" zu gestalten und in komplexere Makro-Ketten zu kapseln, wurde die ursprüngliche Funktionalität zerstört. Dies führte dazu, dass XeLaTeX die Schriftart-Prüfung ignorierte und stattdessen in den aggressiven METAFONT-Modus (`mktextfm`) sprang, was zum Absturz des Compilers führte.

**Learning:** Ein funktionierender, simpler Ansatz ist wertvoller als eine theoretisch "elegantere" Lösung. Man sollte funktionierende Basis-Logiken nicht ohne vollständige lokale Testumgebung verändern.

---

## 2. Instabilität von `\newenvironment` bei `pgfgantt`
**Problem:** Die Kapselung von `\begin{ganttchart}` innerhalb einer `\newenvironment` führte zum Fehler:  
`! Use of \ganttchart doesn't match its definition.`

**Analyse:** `pgfgantt` nutzt eine komplexe interne Makro-Struktur für die Zeitberechnung. Die Nutzung von `\newenvironment` korrumpiert die Argumentübergabe an den `ganttchart`-Kern, da LaTeX die Zuordnung der Parameter verliert, sobald die ersten Elemente (wie `\gantttitle`) innerhalb der Umgebung aufgerufen werden.

**Lösung:** Verzicht auf `\newenvironment`. Stattdessen Nutzung von expliziten Start- und End-Befehlen:
- `\startroadmap{Startdatum}{Enddatum}` $\rightarrow$ ruft `\begin{ganttchart}` auf.
- `\stoproadmap` $\rightarrow$ ruft `\end{ganttchart}` auf.

---

## 3. Fehleranfälligkeit von Wrapper-Befehlen
**Problem:** Die Einführung von Komfort-Befehlen wie `\placeOpp{Name}{Datum}` führte zu:  
`! Missing number, treated as zero.`

**Analyse:** `\ganttbar` erwartet zwingend drei Argumente: `{Label}{Start}{Ende}`. Durch die Kapselung in einem Wrapper-Befehl wurden die Argumente falsch übergeben (z.B. wurde der Name als Startdatum interpretiert). Da `pgfgantt` im Hintergrund mathematische Berechnungen durchführt, führt ein falscher Datentyp (Buchstabe statt Zahl) zum sofortigen Abbruch.

**Lösung:** Keine Kapselung der Kern-Zeichenbefehle. Stattdessen "Style-Setter" verwenden, die nur die Farbe ändern, gefolgt vom Original-Befehl `\ganttbar` mit allen drei erforderlichen Argumenten.

---

## 4. Unsichtbare Zeichen in `pgfkeys`
**Problem:** Fehlermeldungen wie `I do not know the key '/myroadmap/ font'` (beachte das Leerzeichen vor "font").

**Analyse:** LaTeX ist extrem empfindlich gegenüber Whitespaces innerhalb von `\pgfkeys{...}` Definitionen. Ein Tabulator oder ein Leerzeichen nach einem Komma kann vom Parser als Teil des Key-Namens interpretiert werden.

**Lösung:** Definitionen der Keys kompakt schreiben und unnötige Einrückungen innerhalb der Key-Familie vermeiden, um sicherzustellen, dass keine unsichtbaren Zeichen in den Namen rutschen.

---

## Zusammenfassung für stabile Paketentwicklung
- [ ] **Funktionierendes belassen:** Bestehende, funktionierende Logik (wie den ursprünglichen `\IfFontExistsTF` Check) nicht ohne Not ändern.
- [ ] **Einfachheit vor Eleganz:** Original-Befehle des Basis-Pakets bevorzugen statt komplexer Wrapper-Ketten.
- [ ] **Keine `\newenvironment`** für komplexe PGF/TikZ-Charts; Nutzung von `\start...` / `\stop...` Befehlen.
- [ ] **Saubere Keys:** `pgfkeys` ohne führende oder folgende Leerzeichen definieren.
