#!/bin/bash
set -e
cd /radicle/radicle-bins
cargo run -p radicle-seed-node --release -- \
	  --root /radicle \
	    --peer-listen 0.0.0.0:12345 \
	      --http-listen 0.0.0.0:80 \
	        --name "home-urbit seedling" \
		    --assets-path seed/ui/public \
		      < /radicle/secret.key
