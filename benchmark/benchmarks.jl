using CovarianceMatrices
using Random
using GLM
using DataFrames
using BenchmarkTools

Random.seed!(1)

u = zeros(3000)
for j in 1:2999
    u[j+1] = 0.97*u[j] + randn()
end

df = DataFrame(y = randn(300*50) .+ u[1500:3000])

for j in Symbol.("x".*string.(collect(1:5)))
    df[j] = randn(300*50)
end
df[:cluster] = repeat(1:50, inner = [300])


frm = @formula(y ~ x1 + x2 + x3 + x4 + x5)
lm1 = glm(frm, df, Normal(), IdentityLink())
k_fix = TruncatedKernel(10)
k_opt_andrews = TruncatedKernel()
#k_opt_newey = TruncatedKernel(NeweyWest)

SUITE = BenchmarkGroup()
SUITE["HAC"] = BenchmarkGroup(["Optimal Uncached", "Fixed Uncached"])
SUITE["HAC"]["Truncated Optimal Andrews"] = @benchmarkable vcov(lm1, $k_opt_andrews)
SUITE["HAC"]["Truncated Fixed "] = @benchmarkable vcov(lm1, $k_fix)

k_fix = ParzenKernel(10)
k_opt_andrews = ParzenKernel()
k_opt_newey = ParzenKernel(NeweyWest)

SUITE["HAC"]["Parzen Optimal Andrews"] = @benchmarkable vcov(lm1, $k_opt_andrews)
SUITE["HAC"]["Parzen Optimal Newey"] = @benchmarkable vcov(lm1, $k_opt_newey)
SUITE["HAC"]["Parzen Fixed "] = @benchmarkable vcov(lm1, $k_fix)

k = CRHC0(df[!,:cluster])
SUITE["HAC"]["Cluster HC0"] = @benchmarkable vcov(lm1, $k)
k = CRHC2(df[!,:cluster])
SUITE["HAC"]["Cluster HC2"] = @benchmarkable vcov(lm1, $k)
k = CRHC3(df[!,:cluster])
SUITE["HAC"]["Cluster HC3"] = @benchmarkable vcov(lm1, $k)
