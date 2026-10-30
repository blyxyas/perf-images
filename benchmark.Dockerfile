FROM rust:latest

RUN apt update && \
    apt install valgrind -y

ARG NIGHTLY_TODAY
ENV NIGHTLY_TODAY=$NIGHTLY_TODAY

WORKDIR /usr/
ENV LC_ALL=C.UTF-8

RUN git clone -b auto-clippy-benchmarker https://github.com/blyxyas/rustc-perf

WORKDIR rustc-perf

RUN git submodule update --init --remote

WORKDIR rust-clippy
ENV LD_LIBRARY_PATH=$(rustc --print=sysroot)/lib


RUN cargo b -r --config profile.release.debug=true
# Pull that rust-clippy submodule

# Propagate Clippy version to rustc-perf
RUN cp rust-toolchain.toml ..

# And now build rustc-perf
WORKDIR ..
RUN cargo b -r

ENTRYPOINT LD_LIBRARY_PATH=$(rustc --print=sysroot)/lib target/release/collector profile_local callgrind $NIGHTLY_TODAY --profiles Clippy,Check --clippy rust-clippy/target/release/clippy-driver