%=========================================================================================
% This is journal.cls (v1.0.0, 20 Oct 2023) written by
% Dario Trinchero (dario.trinchero@pm.me).
%=========================================================================================
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{journal}[2023/10/20 Journal v1.0.0, template for research project journal.]

%-----------------------------------------------------------------------------------------
% Class options
%-----------------------------------------------------------------------------------------

% TODO actually use this option
\newif\if@widetoc
\DeclareOption{widetoc}{\@widetoctrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions\relax

\LoadClass[10pt,twocolumn]{report}

%-----------------------------------------------------------------------------------------
% General package requirements
%-----------------------------------------------------------------------------------------

% Formatting
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[margin=2.0cm,top=1cm]{geometry}
\RequirePackage{truncate}
\RequirePackage[section]{tocbibind} % include table-of-contents & list-of-X in TOC

% Helper packages for log commands
\RequirePackage{advdate,datetime}
\RequirePackage{calc}
\RequirePackage{enumitem} % adjust 'description' indent
\RequirePackage{xparse} % provides \NewDocumentCommand
\RequirePackage[titles]{tocloft} % for open issue list

% Symbols
\RequirePackage{amssymb,amsmath,amsthm}

% TikZ & graphics
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{pgfgantt}
\RequirePackage{tikz}
\usetikzlibrary{calendar}

% Citations & hyperlinks
\RequirePackage[unicode,pdfusetitle]{hyperref}
\RequirePackage[tocbib]{apacite}
\RequirePackage{bookmark}
\RequirePackage{doi} % automatic doi links

%-----------------------------------------------------------------------------------------
% Custom metadata
%-----------------------------------------------------------------------------------------

% Custom metadata fields
\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\project}[1]{\def\@project{#1}}
\newcommand{\subject}[1]{\def\@subject{#1}}

% Default values
\def\@project{}
\def\@subject{}

% Document title & PDF metadata
\title{\Huge\@name\\\vspace{0.5em}\LARGE\@project}
\AtBeginDocument{%
	\hypersetup{
		pdftitle={\@name: \@project},
		pdfsubject={\@subject}
	}
}

%-----------------------------------------------------------------------------------------
% General styling
%-----------------------------------------------------------------------------------------

\setlength{\parindent}{0pt}

% Hyperlinks & bookmarks
\hypersetup{
	bookmarksnumbered,
	bookmarksopenlevel=4,
	bookmarksopen=true,
	colorlinks=true,
	linkcolor=WildStrawberry,
	citecolor=WildStrawberry
}

% Date formats
\date{}
\def\shortisodate{\the\year-\twodigit{\the\month}}
\def\isodate{\shortisodate-\twodigit{\the\day}}
\newdateformat{secdate}{\shortdayofweekname{\THEDAY}{\THEMONTH}{\THEYEAR}~\THEDAY}
\def\tocdate{%
	\parbox[b]{2em}{\ordinaldate{\the\day}}~---~%
	\protect\dayofweekname{\the\day}{\the\month}{\the\year}
}

% Table of contents & numbering
\renewcommand{\tableofcontents}{% two column t.o.c.
	\newpage%
	\pdfbookmark[chapter]{\contentsname}{toc}
	\chapter*{\contentsname
		\@mkboth{%
			\MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
			\@starttoc{toc}%
}
\setlength{\cftsecindent}{1.5em}
\setlength{\cftsubsecindent}{3em}
\setcounter{secnumdepth}{-\maxdimen}
\setcounter{tocdepth}{2}

% Bibliography
\bibliographystyle{apacite}
\renewcommand{\doitext}{} % drop "doi:" prefix from doi package
\renewcommand{\cite}{\shortciteauthorA} % default \cite style

%-----------------------------------------------------------------------------------------
% Theorem declarations
%-----------------------------------------------------------------------------------------

\newtheorem*{theorem}{Theorem}
\newtheorem*{corollary}{Corollary}
\newtheorem*{lemma}{Lemma}
\newtheorem*{proposition}{Proposition}
\theoremstyle{definition}
\newtheorem*{definition}{Definition}

\renewcommand{\qedsymbol}{$\blacksquare$}

%-----------------------------------------------------------------------------------------
% Log entry commands
%-----------------------------------------------------------------------------------------

% Usage:
%	\logstart{2022-11-03} --- set first log date to 2022-11-03
%			  ^^^^^^^^^^ ---- iso format yyyy-mm-dd required
\newcommand{\logstart}[1]{%
	\def\parsedate##1-##2-##3\endparse{%
		\SetDate[##3/##2/##1] % format dd/mm/yyyy required by \SetDate
	}%
	\parsedate#1\endparse
	\SaveDate[\logstartday]% remember start date for use in \logday definition
}

% Usage:
%	\logday ------ begin subsection for next day's log
%	\logday[3] --- skip 3 days, then begin subsection for next day's log
\newcommand{\logday}[1][0]{% optional argument skips days
	\SaveDate[\logcurrday]%
	\def\islogstart{\equal{\logstartday}{\logcurrday}}
	\edef\prevyear{\the\year}%
	\edef\prevmonth{\the\month}%
	\global\advance\day#1\advance\day1\FixDate%
	\ifthenelse{\islogstart\OR\NOT\equal{\prevyear}{\the\year}}{%
		\chapter{\the\year}%
	}{}%
	\ifthenelse{\islogstart\OR\NOT\equal{\prevmonth}{\the\month}}{%
		\section{\texorpdfstring{\monthname[\the\month]}{\the\month}}%
	}{}%
	\subsection[\texorpdfstring{\tocdate}{\the\day}]{\secdate\today}\label{\isodate}%
}

%-----------------------------------------------------------------------------------------
% Checklist environment
%-----------------------------------------------------------------------------------------

% Usage
%	\begin{checklist}
%		\item task 1 ---- unchecked task
%		\item* task 2 --- checked task
%		\item! task 3 --- crossed task
%	\end{checklist}
\newenvironment{checklist}{
\let\olditem\item
\def\bluesq{\color{black!80}$\square$}
\RenewDocumentCommand{\item}{st!}{%
	\olditem[\IfBooleanTF##1{%
		\rlap{\bluesq}{\raisebox{2pt}{\large\color{Green}\hspace{1pt}\checkmark}}%
		\hspace{-3.2pt}%
	}{\IfBooleanTF##2{%
		\rlap{\bluesq}{\raisebox{1.2pt}{\hspace{1.6pt}\sffamily\color{Red}\textbf{x}}}%
		\hspace{1.2pt}%
	}{\bluesq}}]%
}
\begin{itemize}
	\setlength{\itemsep}{0.3em}
	\setlength{\parskip}{0pt}
}{\end{itemize}\ignorespacesafterend}

%-----------------------------------------------------------------------------------------
% Task list environment
%-----------------------------------------------------------------------------------------

% global issue lists
\newlistof{issues}{iss}{}
\newlistof{optionalissues}{opt}{}
\renewcommand{\listofissues}{\begingroup
	\onecolumn
	\chapter{Open Issues}
	\tocfile{High priority}{iss}
	\tocfile{Low priority}{opt}
	\twocolumn
\endgroup}
\newcounter{openissues}
\newcounter{openoptissues}

% Usage:
%	\maybecite ----------------- blank output (likewise if either option is empty)
%	\maybecite[le18a] ---------- italic reference
%	\maybecite[le18a][\#~2] ---- italic reference + suffix
%	\maybecite*[le18a] --------- non-italic reference with period
%	\maybecite*[le18a][\#~2] --- non-italic reference with period + suffix
\NewDocumentCommand{\maybecite}{sO{}O{}}{%
	\ifthenelse{\equal{#2}{}}{}{%
		\IfBooleanTF#1{\cite[#3]{#2}.}%
		{\textit{\cite[#3]{#2}.}}%
	}%
}

\NewDocumentCommand{\issuelineprefix}{mmmmm}{%
	\NoHyper%
	{\color{Gray}#1. {\small(#2)}} \parbox[b]{3em}{\textbf{#3}}%
	\maybecite[#4][#5]\ifthenelse{\equal{#4}{}}{}{ }%
	\endNoHyper%
}

% Usage:
%	\begin{tasklist}
%		\todo[le18a][\#~2] "Be" attentive ---- unresolved todo
%		     ^^^^^^^^^^^^^ ------------------- optional reference & suffix
%                          ^^^^ -------------- issue list entry line content
%		\todo*[le18a][\#~2] "Be"
%		     ^ ------------------------------- 'resolved' (ticked & omitted from issue list)
%		\todo?[le18a][\#~2] "Be"
%		     ^ ------------------------------- 'low-priority' (added to separate issue list)
%
%		\qstn*[ul12b] "How?" ----------------- question: same arguments as \todo
%
%		\ex[le18a][1,3--6] "ez." ------------- exercise task: same arguments as \todo
%		\ex?*[le18a][1,3--6] "ez."
%		   ^^ -------------------------------- marks exercise task as having been completed in the future
%		\read[le18a][1,5--8] ":)" ------------ reading task: same arguments as \ex
%
%		\ans[q:how] No ----------------------- answer
%		    ^^^^^^^ -------------------------- optional ref to \label-ed question
%	\end{tasklist}
\newenvironment{tasklist}{
\newcommand{\issue}[6]{%
	\item[##3\IfBooleanTF##2{\IfBooleanT##1{\color{Orange}}$^\checkmark$}{\IfBooleanT##1{$^?$}}]%
	\refstepcounter{issues}%
	\maybecite[##4][##5]\ifthenelse{\equal{##6}{}}{}{ }##6%
	\IfBooleanF##2{% if unstarred, add to open issue list
		\IfBooleanTF##1{%
			\stepcounter{openoptissues}%
			\def\ext{opt}\def\theissuecount{\theopenoptissues}%
		}{%
			\stepcounter{openissues}%
			\def\ext{iss}\def\theissuecount{\theopenissues}%
		}%
		\def\pfx{\issuelineprefix{\theissuecount}{\isodate}{##3}{##4}{##5}}%
		\addcontentsline{\ext}{issues}{%
			\pfx{\color{black}\truncate{\linewidth-\@tocrmarg-\widthof{\pfx}}{##6}}%
		}%
	}%
}
\RenewDocumentCommand{\read}{t?sO{}O{}D""{}}{\issue{##1}{##2}{\color{BlueViolet}read}{##3}{##4}{##5}}
\NewDocumentCommand{\ex}{t?sO{}O{}D""{}}{\issue{##1}{##2}{\color{BlueViolet}ex}{##3}{##4}{##5}}
\NewDocumentCommand{\todo}{t?sO{}O{}D""{}}{\issue{##1}{##2}{\color{Orange}todo}{##3}{##4}{##5}}
\NewDocumentCommand{\qstn}{t?sO{}O{}D""{}}{\issue{##1}{##2}{\color{Red}qstn}{##3}{##4}{##5}}
\NewDocumentCommand{\ans}{O{}}{%
	\item[\color{Green}ans\ifthenelse{\equal{##1}{}}{}{$^{\hyperref[##1]{\uparrow}}$}]%
}
\begin{description}
	[
		leftmargin=!,
		labelwidth=\widthof{\bfseries todo$^{\checkmark}$}
	]
	\setlength{\itemsep}{1pt}
	\setlength{\parskip}{0pt}
}{\end{description}\ignorespacesafterend}

%-----------------------------------------------------------------------------------------
% Calendar commands
%-----------------------------------------------------------------------------------------

% Usage
%	\yearcalendar{2015} ---------- entire 2015 calendar
%	\yearcalendar[03-28]{2015} --- 2015 calendar starting Mar 28 2015
%				  ^^^^^ ---------- format mm-dd required
\newcommand{\yearcalendar}[2][01-01]{%
	\section*{#2}
	\footnotesize\color{CadetBlue!15!black}
	\tikz[every day/.style={anchor=mid},]\calendar
		[
			name=d,
			dates=#2-#1 to #2-12-last,
			month list,
			month label left,
			month yshift=1.25em,
			set style={{every month}+=[anchor=mid east]},
			day code={
				\node[name=\pgfcalendarsuggestedname,every day]
				{\ttfamily\@ifundefined{r@\%y--\%m0-\%d0}{\%d-}%
					{\hyperref[\%y--\%m0-\%d0]{\%d-}}};
			}
		]
		if (weekend) [CadetBlue!15!black!50]
		if (equals=\year-\month-\day) {\draw[CadetBlue!60,very thin] circle (5.8pt);}
		if (at most=\year-\month-\day) {}
		else [gray!38];
	\vspace{-1.5em}
}

% Usage
%	\calendar{2015}{2018} ---------- calendar from 1 Jan 2015 to 31 Dec 2018
%	\calendar[03-28]{2015}{2018} --- calendar from 28 Mar 2015 to 31 Dec 2018
%			  ^^^^^ ---------------- format mm-dd required
\newcommand{\calendar}[3][01-01]{%
	\onecolumn%
	\chapter{Calendar}
	\foreach \n in {#2,...,#3}{
		\ifthenelse{\n=#2}{\yearcalendar[#1]{\n}}{\yearcalendar{\n}}
	}
	\twocolumn%
}

%-----------------------------------------------------------------------------------------
% Gantt chart
%-----------------------------------------------------------------------------------------

\setganttlinklabel{f-s}{}
\newganttlinktype{rdldr*}{%
	\draw [/pgfgantt/link]
	(\xLeft, \yUpper) --
	(\xLeft + \ganttvalueof{link bulge 1} * \ganttvalueof{x unit}, \yUpper) --
	($(\xLeft + \ganttvalueof{link bulge 1} * \ganttvalueof{x unit}, \yUpper)!%
		\ganttvalueof{link mid}!%
		(\xLeft + \ganttvalueof{link bulge 1} * \ganttvalueof{x unit}, \yLower)$) --
	($(\xRight - \ganttvalueof{link bulge 2} * \ganttvalueof{x unit}, \yUpper)!%
		\ganttvalueof{link mid}!%
		(\xRight - \ganttvalueof{link bulge 2} * \ganttvalueof{x unit}, \yLower)$) --
	(\xRight - \ganttvalueof{link bulge 2} * \ganttvalueof{x unit}, \yLower) --
	(\xRight, \yLower);%
}
\ganttset{
	% general
	inline,
	expand chart=\textwidth,
	time slot format=isodate-yearmonth, time slot unit=month,
	title height=.75, title label font=\footnotesize,
	% grid
	vgrid, hgrid,
	y unit chart=2.0em,
	y unit title=2.2em,
	vgrid={*1{Gray!70, dotted}},hgrid={*1{Gray!70, dotted}},
	canvas/.style={draw=Gray},
	title/.style={draw=Gray},
	% current day
	today=\shortisodate, today offset=.5, today label=,
	today rule/.style={draw=WildStrawberry, thick},
	progress=today,
	% labels
	progress label text={\pgfmathprintnumber[precision=0, verbatim]{#1}\%},
	bar progress label node/.style={opacity=0},
	milestone progress label node/.style={opacity=0},
	bar inline label node/.append style={font=\footnotesize},
	group inline label node/.append style={font=\color{CadetBlue!15!black}\bf\small},
	milestone inline label node/.append style={%
		left=0.2em,%
		font=\color{Green!50!black}\small%
	},
	% shape style
	group peaks tip position=0,
	bar height=0.6, bar top shift=0.2,
	group/.append style={fill=CadetBlue!50!Gray},
	milestone/.append style={draw=none, fill=Green!50!Gray},
	bar/.append style={draw=CadetBlue!60!black},
	bar incomplete/.append style={fill=Gray!17},
	% link style
	link/.append style={draw=CadetBlue!60!black},
	link bulge=.5,
	link bulge 1/.link=/pgfgantt/link bulge,
	link bulge 2/.link=/pgfgantt/link bulge,
}

\newenvironment{gantt}[3][]{
% shorthand definitions & commands
\def\phase{\ganttgroup}
\def\link{\ganttlink}
\newcommand{\milestone}[2]{\ganttmilestone{##1$\,^\checkmark$}{##2}}
\NewDocumentCommand{\task}{somm}{%
	\IfBooleanTF##1%
		{\ganttlinkedbar[name=##2]{##3}{##4}}%
		{\ganttbar[name=##2]{##3}{##4}}%
}
\ifthenelse{\equal{#1}{}}{}{\section{#1}}
\begin{ganttchart}{#2}{#3}
\gantttitlecalendar{year, month}\\
}{\end{ganttchart}\ignorespacesafterend}

\newcommand*{\timelines}[1][figures/gantt]{%
	\onecolumn%
	\chapter{Planned Timeline}\label{ch:timeline}%
	\input{#1}%
	\twocolumn%
}
