module MarsMission
export gravity_from_throw, escape_speed, posterior, weighted_quantile, mission_summary

"Gravity in m/s² from range in metres, time in seconds, and angle in degrees."
function gravity_from_throw(distance, time, angle)
    distance > 0 && time > 0 && 0 < angle < 90 || throw(ArgumentError("positive range/time and angle between 0 and 90 required"))
    2distance * tand(angle) / time^2
end

"Ideal escape speed in km/s, using the chapter's approximate Earth/Mars ratio."
function escape_speed(g)
    g >= 0 || throw(ArgumentError("gravity cannot be negative"))
    11sqrt(g / (2 * 9.8))
end

"""
Grid posterior with a uniform g prior and one shared uncertain launch angle.
Distance errors are independent Normal(0, sigma); recorded times are treated as exact.
Equal grid cells make normalized likelihoods discrete posterior masses.
"""
function posterior(distances, times; sigma=3.0, angle=45.0, halfwidth=7.5,
                   gs=collect(0.02:0.02:10.0), angle_points=61)
    length(distances) == length(times) && !isempty(times) || throw(ArgumentError("matching nonempty measurements required"))
    all(isfinite, distances) && all(>(0), distances) && all(isfinite, times) && all(>(0), times) || throw(ArgumentError("measurements must be finite and positive"))
    isfinite(sigma) && sigma > 0 || throw(ArgumentError("sigma must be positive and finite"))
    0 <= halfwidth && 0 < angle-halfwidth <= angle+halfwidth < 90 || throw(ArgumentError("angle interval must lie inside (0,90)"))
    length(gs) >= 2 && all(isfinite, gs) && all(>(0), gs) && issorted(gs) && all(>(0), diff(gs)) || throw(ArgumentError("increasing positive finite gravity grid required"))
    all(d -> isapprox(d, gs[2]-gs[1]; rtol=1e-10), diff(gs)) || throw(ArgumentError("gravity grid must be uniform"))
    angle_points >= 2 || throw(ArgumentError("at least two angle cells required"))
    # Midpoint cells avoid giving endpoints extra mass. A known angle is one cell.
    angles = halfwidth == 0 ? [angle] : [angle-halfwidth + (j-0.5)*2halfwidth/angle_points for j in 1:angle_points]
    logweights = [-sum(((distances[i] - g*times[i]^2/(2tand(a)))/sigma)^2 for i in eachindex(times))/2 for g in gs, a in angles]
    weights = exp.(logweights .- maximum(logweights))
    masses = vec(sum(weights; dims=2))
    masses ./= sum(masses)
    (; gs, masses)
end

function weighted_quantile(values, masses, probability)
    0 <= probability <= 1 || throw(ArgumentError("probability must be between zero and one"))
    length(values) == length(masses) && !isempty(values) && issorted(values) || throw(ArgumentError("matching sorted values required"))
    all(isfinite, masses) && all(>=(0), masses) && sum(masses) > 0 || throw(ArgumentError("nonnegative finite masses with positive total required"))
    values[min(searchsortedfirst(cumsum(masses), probability*sum(masses)), length(values))]
end

function mission_summary(result; budget=5.0)
    speeds = escape_speed.(result.gs)
    interval = [weighted_quantile(speeds, result.masses, q) for q in (0.05, 0.5, 0.95)]
    (; interval, probability_within_budget=sum(result.masses[speeds .<= budget]))
end
end
