[![Build & release](https://github.com/dariotrinchero/research-journal/actions/workflows/compile_release.yaml/badge.svg)](https://github.com/dariotrinchero/research-journal/actions/workflows/compile_release.yaml)

# Research Journal

This is a LaTeX template for a **research project journal**. I designed it for my PhD
thesis, but it could probably be used for more general project management. It is intended
as a place for recording daily *work*, tracking *progress*, outstanding *tasks*, lingering
*questions*, *answers* to those questions, and so on.

## Showcase

Here are some screenshots showing off the basic layout and some key features:

<p float="left">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-3.jpg" width="48%">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-4.jpg" width="48%">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-5.jpg" width="48%">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-6.jpg" width="48%">
</p>

## Requirements

I designed the journal to fulfil the following minimal desiderata, ranked by importance:

1. **Low activation energy**: It should require *almost no effort* to add entries.
1. **Cross-referencing**: Wherever they make sense, hyperlinks should be inserted
   (preferably automatically, given #1): questions should link their corresponding
   answers & vice-versa, there should be hyperlinked PDF bookmarks, table-of-contents,
   reference lists, etc.
1. **Issue tracking**: Unresolved **issues** (questions & TODOs) should be collected
   into a single (hyperlinked) list, and automatically removed upon being resolved.
1. **Progress tracking**: There should be high-level progress indicators & goal
   trackers (eg. calendar & Gantt chart), as well as records of completed low-level
   **tasks** (eg. reading & exercises).
1. **Readability**: Layout should be compact, color-coded, & readable.

## Feature list

Here is a selection of the core functionality, designed to meet the requirements detailed
above:

- Simple syntax for new entries with automatic date headings
- Compact hyperlinked table of contents & automatic PDF bookmarks
- Project calendar linking to entries & highlighting current day
- Gantt charts for high-level timeline
- Global lists of unresolved issues, separated by high- & low priority, & sorted by date
- Automatic hyperlinks between questions & their answers
- Easy checklists

## Getting started

### Dependencies

- `pdflatex`
- `latexmk`
- GNU Make

### Setup

1. Fork & clone the repo.
1. Install the dependencies listed above.
1. Test compilation by running `make` in the repo root directory. Sometimes it needs to be
   run twice for the initial compilation; subsequent compilations are faster.
1. Customize the metadata & entries on the lines indicated by comments in `journal.tex`.
1. Customize the references in `references.bib`.
1. Optionally create Gantt charts for your project progress in `figures/gantt.tex`.

### Compilation

The build process is orchestrated by GNU Make and `latexmk`. The following Make targets are
implemented:

- `all`: default target; build journal
- `bg`: background compilation; watch files & recompile on changes
- `clean`: delete compilation artifacts

## Usage guide

For the most part, the file `journal.tex` documents the package via comments. If you need
to change things in the class definition file, `journal.cls`, you will find this file
equally well-documented by comments.
