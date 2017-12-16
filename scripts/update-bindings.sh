#!/bin/bash

set -e

which bindgen || cargo install bindgen
which rustfmt || cargo install rustfmt-nightly

bindgen -o src/bindings.rs \
        --rustified-enum 'napi_.+' \
        --whitelist-function 'napi_.+' \
        --whitelist-type 'napi_.+' \
        "$1"

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(rustc --print sysroot)/lib \
  rustfmt crates/napi-sys/src/bindings.rs
