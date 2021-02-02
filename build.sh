#! /bin/bash -e

if [ ! -d "public" ] ; then
  git worktree add -B gh-pages public origin/gh-pages
fi

asciidoctor docs/microservices-assessment-platform-api.adoc -b html -o public/index.html -a allow-uri-read

cp -Rf docs/images public/images
