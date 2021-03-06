# Package Guide

## Installation

The package can be installed by cloning the code from the github repository
[POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl)

Installation with POMDPs.jl:
```julia
Pkg.add("POMDPs")
```

The package is currently not registered in meta-data.

## Usage

POMDPs serves as the interface used by a number of packages under the [JuliaPOMDP]() framework. It is essentially the
agreed upon API used by all the other packages in JuliaPOMDP. If you are using this framework, you may be trying to
accomplish one or more of the following three goals:

- Solve a decision or planning problem with stochastic dynamics (MDP) or partial observability (POMDP)
- Evaluate a solution in simulation
- Test your custom algorithm for solving MDPs or POMDPs against other state-of-the-art algorithms

If you are attempting to complete the first two goals, take a look at these Jupyer Notebook tutorials:

* [MDP Tutorial](http://nbviewer.ipython.org/github/sisl/POMDPs.jl/blob/master/examples/GridWorld.ipynb) for beginners gives an overview of using Value Iteration and Monte-Carlo Tree Search with the classic grid world problem
* [POMDP Tutorial](http://nbviewer.ipython.org/github/sisl/POMDPs.jl/blob/master/examples/Tiger.ipynb) gives an overview of using SARSOP and QMDP to solve the tiger problem

If you are trying to write your own algorithm for solving MDPs or POMDPs with this interface take a look at the API section of this guide.


## Example Simulation

The following code snippets show how some of the most important functions in the interface are to be used together. (Please note that this example is written for clarity and not efficiency; several other simulators are available in the [JuliaPOMDP/POMDPToolbox.jl]() package.)

First, here is a definition of a simple simulator showing the use of the important functions [`rand`](@ref), [`initialize_belief`](@ref), [`isterminal`](@ref), [`action`](@ref), [`transition`](@ref), [`reward`](@ref), [`observation`](@ref), [`update`](@ref), and [`discount`](@ref).

```julia
using POMDPs

type ReferenceSimulator
    rng::AbstractRNG
    max_steps::Int
end

function simulate{S,A,O,B}(sim::ReferenceSimulator,
                           pomdp::POMDP{S,A,O},
                           policy::Policy,
                           updater::Updater{B},
                           initial_distribution::AbstractDistribution)

    s = rand(sim.rng, initial_distribution)
    b = initialize_belief(updater, initial_distribution)

    disc = 1.0
    r_total = 0.0

    step = 1

    while !isterminal(pomdp, s) && step <= sim.max_steps
        a = action(policy, b)

        trans_dist = transition(pomdp, s, a)
        sp = rand(sim.rng, trans_dist)

        r_total += disc*reward(pomdp, s, a, sp)

        obs_dist = observation(pomdp, s, a, sp)
        o = rand(sim.rng, obs_dist)

        b = update(updater, b, a, o)

        disc *= discount(pomdp)
        s = sp
        step += 1
    end

    return r_total
end
```

The following snippet shows how a solver should be used to solve a problem and run a simulation.

```julia
using SARSOP
using POMDPModels

solver = SARSOP()

problem = BabyPOMDP()

policy = solve(solver, problem)
up = updater(policy)
sim = ReferenceSimulator(MersenneTwister(1), 10)

r = simulate(sim, problem, policy, up, initial_state_distribution(problem))

println("Reward: $r")
```
