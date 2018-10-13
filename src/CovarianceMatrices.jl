module CovarianceMatrices

using Reexport
using LinearAlgebra
using Statistics
abstract type RobustVariance end
abstract type HAC{G} <: RobustVariance end
abstract type HC <: RobustVariance end
abstract type CRHC <: RobustVariance end

@reexport using GLM
@reexport using DataFrames

using StatsBase
using StatsModels
import StatsBase: confint, vcov, nobs, residuals, RegressionModel
import GLM: LinPredModel, LinearModel, GeneralizedLinearModel, ModelMatrix, df_residual, AbstractGLM
import StatsModels: DataFrameRegressionModel

import StatsBase: stderror

const twohalftoπ² = 2.5 / π^2

export QuadraticSpectralKernel, TruncatedKernel, ParzenKernel, BartlettKernel,
       TukeyHanningKernel, VARHAC, HC0, HC1, HC2, HC3, HC4, HC4m, HC5, CRHC0, CRHC1,
       CRHC2, CRHC3, vcov, stderror, NeweyWest, Andrews, optimalbw, Variance, HACConfig

struct HC0  <: HC end
struct HC1  <: HC end
struct HC2  <: HC end
struct HC3  <: HC end
struct HC4  <: HC end
struct HC4m <: HC end
struct HC5  <: HC end

#const CLVector{T<:Integer} = DenseArray{T,1}

mutable struct CRHC0{V<:AbstractVector}  <: CRHC
    cl::V
end

mutable struct CRHC1{V<:AbstractVector}  <: CRHC
    cl::V
end

mutable struct CRHC2{V<:AbstractVector}  <: CRHC
    cl::V
end

mutable struct CRHC3{V<:AbstractVector}  <: CRHC
    cl::V
end

#include("varhac.jl")
include("HAC.jl")
include("HC.jl")
include("CRHC.jl")
end # module
