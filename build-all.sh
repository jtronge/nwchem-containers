#!/bin/sh
VERSIONS="519b710bd09ebe3c10703293093d3cf70ce44333 05aafc87223af82f58865d8b0f924dabd1adacbc f29685d5bde59ac9c7f71b7ce6193720aaba1a8b"

cd nwchem-lanl
for version in $VERSIONS; do
	tag=jtronge/nwchem:`printf $version | head -c 7`
	ch-image build --force -t $tag --build-arg VERSION=$version . || exit 1
	ch-image push $tag || exit 1
	ch-image reset || exit 1
done
