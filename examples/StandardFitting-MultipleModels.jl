#!/usr/bin/env julia
include("../src/RHEOS.jl")
using PyPlot
using RHEOS

filedir = "../data/rheologyData1.csv"

data_raw = fileload(["time","stress","strain"], filedir)

# data_resampled = var_resample(data_raw, :σ, 0.1; _mapback = false)
# data_resampled = downsample(data_raw, [1, 450], [3])
# data_resampled = fixed_resample(data_raw, [1, 200, 450], [8, 25], ["up", "down"])
data_resampled = fixed_resample(data_raw, [1, 450], [8], ["up"])
# data_resampled = smooth(data_raw, 5.0)
# data_resampled = mapbackdata(data_resampled, data_raw)

# plot(data_raw.t, data_raw.ϵ)
# plot(data_resampled.t, data_resampled.ϵ)
# show()

# plot(data_raw.t, data_raw.σ)
# plot(data_resampled.t, data_resampled.σ)
# show()

# SLS fit
p0 = [1000.0, 1000.0, 100.0]
lb = [0.0, 0.0, 0.0]
ub = [1e5, 1e5, 1e5]
fittedmodel = modelfit(data_resampled, G_SLS; p0=p0, lo=lb, hi=ub, verbose=true)

# # Spring-pot fit
# p0 = [1000.0, 0.5]
# lb = [0.0, 0.0]
# ub = [1e5, 1.0]
# modelfit!(data_resampled, "springpot", p0, lb, ub)

# # Fract Special fit
# p0 = [247.0, 6.48e2, 0.25, 4.26e3]
# lb = [0.0, 0.0, 0.02, 0.0]
# ub = [1e3, 1e4, 0.98, 1e5]
# modelfit!(data_resampled, "fractspecial", p0, lb, ub)

# fiteval(data_resampled, "SLS")
# fiteval(data_resampled, "springpot")
# fiteval(data_resampled, "fractspecial")

# fiteval(data_resampled)

# saveresult(data_resampled; include_data = true)
# saveresult(data_resampled; include_data = false)

# alldatasaved = loadresult("../data/rheologyData1_RheologyData.jld")
# allmetasaved = loadresult("../data/rheologyData1_RheologyMetadata.jld")

# println(" ")
# for n in fieldnames(data_resampled)

#     println(String(n), " field is same as datasaved: ", getfield(data_resampled, n)==getfield(alldatasaved, n))
#     println(String(n), " field is same as METAsaved: ", getfield(data_resampled, n)==getfield(allmetasaved, n))

#     if getfield(data_resampled, n)!=getfield(allmetasaved, n)
#         println(String(n), " field = ", getfield(allmetasaved, n))
#     end

#     println(" ")

# end