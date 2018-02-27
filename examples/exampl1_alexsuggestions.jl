#!/usr/bin/env julia
include("../src/RHEOS.jl")
using RHEOS
using PyPlot

filedir = "../data/rheologyData1.csv"

data_raw = fileload(filedir, ["time","stress","strain"], "strlx")

data_raw.insight = true

# data_resampled = var_resample(data_raw, :σ, 0.1, _mapback = true)
# data_resampled = downsample(data_raw, [1,450,500], [2,1])
data_resampled = fixed_resample(data_raw, [1,450],[8],["up"])

# # SLS fit
# lb = [0.0, 0.0, 0.0]
# ub = [1e5, 1e5, 1e5]
# p0 = [1000.0, 1000.0, 100.0]
# modelfit!(data, "strlx", "SLS", p0, lb, ub)
#
# # Spring-pot fit
# lb = [0.0, 0.0]
# ub = [1e5, 1.0]
# p0 = [1000.0, 0.5]
# modelfit!(data, "strlx", "springpot", p0, lb, ub; singularity = true)
#
# fiteval(data, "SLS", "strlx")
# fiteval(data, "springpot", "strlx"; singularity = true)
