CV of Elvin Luff
================

Source for my CV, built with the AltaCV class. AltaCV lives in the `AltaCV/`
submodule; this repository only holds my own content, so pulling upstream
template changes is a submodule bump and nothing else.

Layout
------

    elvinluff.tex   the CV itself (content + styling)
    avatar.jpg      photo used by \photoR
    AltaCV/         submodule -> https://github.com/liantze/AltaCV (branch main)

Building
--------

    make            # -> elvinluff.pdf (2 pages, A4)
    make clean      # remove build artifacts and the PDF

`latexmk` needs to find `AltaCV/altacv.cls`, which the Makefile handles via
`TEXINPUTS`. By hand that is:

    TEXINPUTS="$PWD/AltaCV:$PWD/AltaCV/figures:" latexmk -pdf -interaction=nonstopmode elvinluff.tex

With XeLaTeX or LuaLaTeX (see the `\iftutex` branch in the preamble):

    TEXINPUTS="$PWD/AltaCV:" xelatex -shell-escape -output-driver="xdvipdfmx -z 0" elvinluff.tex

No TeX on the host? Build in the TeX Live container:

    docker run --rm -v "$PWD":/w -w /w -e TEXINPUTS=/w/AltaCV: \
      texlive/texlive:latest-medium bash -c '
        tlmgr option repository https://ftp.fau.de/ctan/systems/texlive/tlnet >/dev/null 2>&1
        tlmgr install pdfx xmpincl accsupp simpleicons fontawesome5 paracol lato roboto \
          collection-latexextra collection-fontsrecommended >/dev/null 2>&1
        latexmk -pdf -g -interaction=nonstopmode elvinluff.tex'

(the `medium` scheme lacks `pdfx`/`xmpincl`/`tcolorbox`, hence the `tlmgr` step;
add `-g` to latexmk or it will report "nothing to do" after a failed run).

Checking a build
----------------

    grep -n '^!' elvinluff.log        # must print nothing
    grep -c 'Overfull\|Underfull' elvinluff.log   # expect ~12, don't let it jump
    pdfinfo elvinluff.pdf | grep -E 'Pages|Page size'   # 2 pages, A4
    pdftotext elvinluff.pdf - | head    # text must be selectable

Updating the template
---------------------

    git submodule update --remote AltaCV   # pull the latest AltaCV
    git add AltaCV && git commit -m "Bump AltaCV"

If a class upgrade renames macros, the CV stops compiling: diff
`AltaCV/sample.tex` against `elvinluff.tex` and port the preamble. The last
such upgrade (v1.7.4) changed `\ifxetexorluatex` -> `\iftutex`,
`\itemmarker`/`\ratingmarker` -> `\cvItemMarker`/`\cvRatingMarker`, and moved
the pdflatex fonts to `[rm]{roboto}` + `[defaultsans]{lato}`.

Cloning this repository elsewhere
---------------------------------

    git clone --recurse-submodules <url>
    # or, if already cloned:
    git submodule update --init --recursive
