#!/bin/bash

set -e

which bindgen || cargo install bindgen
which rustfmt || cargo install rustfmt-nightly

bindgen -o src/bindings.rs \
        --rustified-enum '(napi_|uv_).+' \
        --whitelist-function '(napi_|uv_).+' \
        --whitelist-type '(napi_|uv_).+' \
        --no-rustfmt-bindings \
        "./wrapper.h" \
        -- -I"$1"

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(rustc --print sysroot)/lib \
  rustfmt './src/bindings.rs'
