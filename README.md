# CV of Elvin Luff

Because every CV needs a proper production release, with versioning and CI/CD.
You can grab the latest copy over on the [Releases](https://github.com/Eelviny/cv-elvinluff/releases) page.

I'm all about putting energy into my strengths, and I won't claim that graphic design
makes the top of the list. The CV design itself is based on [AltaCV](https://github.com/liantze/AltaCV),
which is included as a git submodule.

Everything else in this repository is my own, and is what I do best. I follow the K.I.S.S. principle religiously.


## Building

    make            # -> elvinluff.pdf (2 pages, A4)
    make clean      # remove build artifacts and the PDF

`latexmk` needs to find `AltaCV/altacv.cls`, which the Makefile handles via
`TEXINPUTS`. By hand that is:

    TEXINPUTS="$PWD/AltaCV:$PWD/AltaCV/figures:" latexmk -pdf -interaction=nonstopmode elvinluff.tex

With XeLaTeX or LuaLaTeX (see the `\iftutex` branch in the preamble):

    TEXINPUTS="$PWD/AltaCV:" xelatex -shell-escape -output-driver="xdvipdfmx -z 0" elvinluff.tex

No TeX on the host? Build in the TeX Live container:

    docker run --rm -v "$PWD":/w -w /w -e TEXINPUTS=/w/AltaCV: \
      texlive/texlive:latest-full make

## CI

`.github/workflows/build.yml` builds the PDF on every push to `main`, on pull
requests, and on demand, then uploads it as the `cv-elvinluff` artifact (30-day
retention).

Get the artifact from the run page: Actions -> Build CV -> run -> Artifacts.

Releasing


    git tag v1
    git push origin v1

Pushing a `v*` tag builds the PDF and publishes a release named after the tag with
`elvinluff.pdf` attached (release notes generated from the commits). The `release`
job runs only for `refs/tags/v*`, takes the artifact from the `build` job, and needs
`contents: write` — granted at job level, while the workflow default stays read-only.

Bump the tag for a new release; re-pushing an existing tag fails because that
release already exists (`gh release upload "$TAG" dist/elvinluff.pdf --clobber`
updates the asset instead).

The `release` job cannot be replayed with `act`: act's runner image has no `gh`
binary, while GitHub-hosted runners ship it preinstalled. Locally the build and
artifact steps are what you can verify.

### Running the same pipeline locally

`act` (https://github.com/nektos/act) executes the workflow on your machine:

    act push -W .github/workflows/build.yml --artifact-server-path /tmp/act-art

    unzip -o /tmp/act-art/1/cv-elvinluff/cv-elvinluff.zip -d /tmp/cv
    pdfinfo /tmp/cv/elvinluff.pdf

To skip the workflow and just run the build step it contains:

    docker run --rm -v "$PWD":/w -w /w -e TEXINPUTS=/w/AltaCV: \
      texlive/texlive:latest-full make

## Updating the template

    git submodule update --remote AltaCV   # pull the latest AltaCV
    git add AltaCV && git commit -m "Bump AltaCV"
