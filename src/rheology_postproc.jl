#!/usr/bin/env julia

"""
    fiteval(self::RheologyType, modelname::String; singularity = false)

Show plot of data vs. fitted data for specified model.
"""
function fiteval(self::RheologyType, modelname::String)

    # params
    params = self.fittedmodels[modelname]

    # modulus function
    model = moduli(modelname, self.test_type)

    # get fit
    if !model.singularity && self.sampling == "constant"
        fitted = boltzconvolve_nonsing(model, self.t, deriv(self.t), params, self.dcontrolled)

    elseif model.singularity && self.sampling == "constant"
        fitted = boltzconvolve_sing(model, self.t, deriv(self.t), params, self.dcontrolled)

    elseif !model.singularity && self.sampling == "variable"
        fitted = boltzintegral_nonsing(model, self.t, params, self.dcontrolled)

    elseif model.singularity && self.sampling == "variable"
        fitted = boltzintegral_sing(model, self.t, params, self.dcontrolled)

    end

    # print params
    println(modelname, " fit: ", self.fittedmodels[modelname])

    # stress subplot
    if model.singularity
        plot(self.t[1:end], self.measured)
        plot(self.t[2:end], fitted, "--")
        show()
    else
        plot(self.t, self.measured)
        plot(self.t, fitted, "--")
        show()
    end

end

"""
    saveresult(self::RheologyType; include_data::Bool = false)

Save RheologyType object using JLD format. If include_data set to false
(by default) then :σ, :ϵ, :t, :dσ, :dϵ fields are set to [0.0] to save
space on disk. If include_data is set as true then these fields are saved
as is.
"""
function saveresult(self::RheologyType; include_data::Bool = false)

    # include original/processed numerical data σ, ϵ, t...etc.
    if include_data

        # save
        jldopen(string(self.filedir[1:end-4], "_RheologyData.jld"), "w") do file
            # register RHEOS module (with RheologyType type) to JLD
            addrequire(file, RHEOS)
            # write self to file
            write(file, "self", self)
        end
    # or not    
    elseif !include_data

        # get copy
        self_copy = deepcopy(self)

        # member variables to erase
        to_reset = self.numericdata
        for n in to_reset
            setfield!(self_copy, n, [0.0])
        end

        # save 
        jldopen(string(self_copy.filedir[1:end-4], "_RheologyMetadata.jld"), "w") do file
            # register RHEOS module (with RheologyType type) to JLD
            addrequire(file, RHEOS)
            # write self_copy to file
            write(file, "self", self_copy)
        end
    end
end

"""
    loadresult(filedir::String)

Convenience function loads result without having to call loadresult(filedir)["self"]
"""
function loadresult(filedir::String)
    # load in result
    loaded_result = load(filedir)
    # return
    loaded_result["self"]
end
