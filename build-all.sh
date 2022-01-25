#!/bin/sh
VERSIONS="519b710bd09ebe3c10703293093d3cf70ce44333 adab52acbbc0fb65b35856abf53937360bb52026 a4d514a59c8014fe60b70c1aec0b494ee654aad3 2afe98c0a9f842cdad0b1bc25aedb1fd66ac1db0 35efa19ca7662489b7388c4a00b16645d73ccc48 33d9b4c97c7b16a10b49a00b50aba1a7520e95a9 d68c367218f4fb55d37b89cefc7fd13438588f6e 43193ef55866f3ea99789325529906500c256e82"

# cd nwchem-tce-ccsd
cd nwchem
for version in $VERSIONS; do
	# tag=jtronge/nwchem:`echo $version | cut -d'/' -f2`
	# tag=jtronge/nwchem:$version
	tag=jtronge/nwchem:$version
	ch-image build --force -t $tag --build-arg VERSION=$version .
	ch-image push $tag
	ch-image reset
done
