# PlasmoCompute

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jalving.github.io/ComputingGraphs.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jalving.github.io/ComputingGraphs.jl/dev)
[![Build Status](https://travis-ci.com/jalving/ComputingGraphs.jl.svg?branch=master)](https://travis-ci.com/jalving/ComputingGraphs.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/jalving/ComputingGraphs.jl?svg=true)](https://ci.appveyor.com/project/jalving/ComputingGraphs-jl)
[![Codecov](https://codecov.io/gh/jalving/ComputingGraphs.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jalving/ComputingGraphs.jl)
[![Coveralls](https://coveralls.io/repos/github/jalving/ComputingGraphs.jl/badge.svg?branch=master)](https://coveralls.io/github/jalving/ComputingGraphs.jl?branch=master)

## Overview
PlasmoCompute.jl is a distributed algorithm simulation framework.  Its primary goal is to provide the capabilities to simulate
real-time algorithm execution and capture the various timing aspects that arise in a real-time system such as latencies and delays.  Example use cases of
PlasmoCompute.jl include simulating the effects of delays in distributed optimization algorithms, comparing distributed machine learning algorithmic variants,
and simulating failures in distributed real-time control systems.

## Installation
PlasmoCompute.jl is not yet a registered Julia package.  It can be installed using the following Julia Pkg command.
```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/jalving/PlasmoCompute.jl.git"))
```
