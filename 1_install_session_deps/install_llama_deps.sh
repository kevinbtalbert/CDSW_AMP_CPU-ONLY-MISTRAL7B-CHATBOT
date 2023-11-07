#!/bin/bash

export FORCE_CMAKE=1

## Build llama-cpp-python w/ CUDA enablement
pip install llama-cpp-python==0.2.11 --force-reinstall --no-cache-dir --user