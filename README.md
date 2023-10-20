[![Build & release](https://github.com/dariotrinchero/research-journal/actions/workflows/compile_release.yaml/badge.svg)](https://github.com/dariotrinchero/research-journal/actions/workflows/compile_release.yaml)

# Research Journal

This is a LaTeX template for a **research project journal**. I designed it for my PhD
thesis, but it could probably be used for more general project management. It is intended
as a place for recording daily *work*, tracking *progress*, outstanding *tasks*, lingering
*questions*, *answers* to those questions, and so on.

## Compiled output & screenshots

The compiled template is available alongside as a GitHub **release**.
Here are some screenshots showing off the basic layout and some key features:

<p float="left">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-3.jpg" width="49%">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-4.jpg" width="49%">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-5.jpg" width="49%">
<img src="https://github.com/dariotrinchero/research-journal/releases/download/latest/journal-6.jpg" width="49%">
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

- *Simple syntax* for new entries with *automatic date headings*
- Compact hyperlinked *table of contents* & automatic PDF *bookmarks*
- Project *calendar* that automatically links to entries & highlights current day
- Automatically-updating *Gantt charts* for high-level timeline
- Global *list of unresolved issues*, separated by high- & low priority, & sorted by date
- *Automatic hyperlinks* between questions & their answers
- Easy *checklists*

## Getting started

### Dependencies

- `pdflatex`
- `latexmk`
- GNU Make

### Overview of setup

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

We give an overview of the usage below, though it should be considered *less comprehensive*
than the documentation in the comments.

### Initial configuration

To use the class, save it in the same directory as your `.tex` file, then set
`\documentclass` to "`journal`" at the start of your preamble. There are a couple
of class options you can pass to toggle some functionality:
```latex
\documentclass[
	raggedright, % ragged-right alignment (instead of justified)
	%widetoc, % wide table-of-contents (instead of 2-column)
]{journal}
```

Then, still in the preamble, set up the journal metadata as such:
```latex
\name{Research Journal}
\project{PhD Journalism}
\subject{The use of LaTeX typesetting for journalism} % only in PDF file metadata
\author{Alice Atwood \and Bob Benston}
```

### Gantt chart(s)

The last thing to customize is the file defining the Gantt charts. By default, this is
at the path `/figures/gantt.tex`.

Here's the example Gantt chart definition from the template:
```latex
\begin{gantt}[Overview]{2022-11}{2025-12} % optional argument creates subsection heading
	% defining chart rows
	\phase{lit review}{2022-12}{2023-12}\\ % \\ moves to the next row in the chart
	\task{topic 1}{2022-12}{2023-03}
	\phase{research}{2024-01}{2025-01}\\
	\task[topic2]{topic 2}{2023-02}{2023-04}
	\task[research1]{research goal 1}{2024-01}{2024-07}\\
	\task*[research2]{research goal 2}{2024-07}{2025-01}
	\task[topic3]{topic 3}{2023-03}{2023-07}\\
	\task*{topic 4}{2023-06}{2023-09}\\
	\task*[topic4]{topic 4}{2023-08}{2023-12}
	\phase{writing}{2024-09}{2025-10}\\
	\milestone{reading}{2023-12}
	\task[paper1]{paper 1}{2024-09}{2024-12}\\
	\task*[paper2]{paper 2}{2025-02}{2025-04}\\
	\task*[thesis]{thesis}{2025-04}{2025-10}
	\milestone{1st paper}{2024-12}\\
	\milestone{2nd paper}{2025-04}
	\milestone{PhD}{2025-10}

	% additional links
	\link{topic2}{topic3}
	\link[link type=f-s]{topic4}{research1}
	\link[link type=rdldr*, link bulge 2=2.5, link mid=1/8]{research1}{paper1}
	\link[link type=rdldr*, link bulge 2=5.5, link mid=1/8]{research2}{paper2}
\end{gantt}
```
This is a little chunky, but you only need to design such a chart once or twice for your
entire project. Moreover, we are using a bunch of shortened commands (`\phase`, `\task`,
etc) defined by the class to simplify the syntax here. Otherwise, this syntax is
thoroughly documented in [pgfgantt documentation](https://ctan.org/pkg/pgfgantt).

See the second screenshot in the section above for the output of this definition.

### Front-matter

With the configuration done, generate the front-matter with:
```latex
\begin{document}
\maketitle
\tableofcontents % optional table of contents
\calendar[11-01]{2022}{2025} % optional calendar
\timelines % optional Gantt charts
\listofissues % optional list of unresolved questions & TODOs
```

### Journal entries

To add a new journal entry:
```latex
\logday % \logday[skip] to skip days
Your entry here.
```

We implement custom environments like **checklists** and **task lists**. The latter
records todos, questions & answers, plus completed reading & exercises. The "Open
Issues" lists are automatically kept up-to-date and hyperlinked accordingly.

Here is a demo of the syntax for this functionality:
```latex
\logday
Here is a checklist:
\begin{checklist}
	\item* Checked item
	\item! Crossed item
	\item Unchecked item
\end{checklist}
and here is a tasklist:
\begin{tasklist}
	\todo* "Learn how to use tasklists."
	\todo? "Tick this item off."
	\read*[baez1994gauge][pp.~10--26] "You can refer to citations."
	\ex[baez1994gauge][\#~1--3] "Exercises work just like reading tasks."
	\qstn[baez1994gauge] "Why did I use this book as an example?" \label{qstn:why}
		It just makes no sense.
	\ans[qstn:why] I probably just copied a piece of my actual reference list.
\end{tasklist}
```
More details about the command flags are in `journal.tex` and/or `journal.cls`.

## Contributing

Please feel free to give me feedback! I encourage comments, issues, and/or pull requests!
