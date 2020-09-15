# steer clear of anaconda
ENV["JUPYTER"] = "/usr/local/bin/jupyter"
ENV["PYTHON"] = "/usr/bin/python3"

ENV["JULIA_WARN_COLOR"] = :yellow
ENV["JULIA_INFO_COLOR"] = :cyan
const SEPARATOR = "\n\n" * "#"^80 * "\n\n"

function recompile_packages()
    for pkg in keys(Pkg.installed())
        try
            info("Compiling: $pkg")
            eval(Expr(:toplevel, Expr(:using, Symbol(pkg))))
            println(SEPARATOR)
        catch err
            warn("Unable to precompile: $pkg")
            warn(err)
            println(SEPARATOR)
        end
    end
end

emerge() = (Pkg.update(); Pkg.build(); recompile_packages())

println("Loaded .juliarc.jl")
