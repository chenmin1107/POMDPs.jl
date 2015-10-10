# POMDP model functions

abstract POMDP

abstract State
abstract Action
abstract Observation
typealias Reward Float64

# return the space sizes
@pomdp_func n_states(pomdp::POMDP)
@pomdp_func n_actions(pomdp::POMDP)
@pomdp_func n_observations(pomdp::POMDP)

@pomdp_func discount(pomdp::POMDP)

@pomdp_func transition(pomdp::POMDP, state::State, action::Action, distribution=create_transition_distribution(pomdp))
@pomdp_func observation(pomdp::POMDP, state::State, action::Action, distribution=create_observation_distribution(pomdp))
@pomdp_func reward(pomdp::POMDP, state::State, action::Action)
@pomdp_func reward(pomdp::POMDP, state::State, action::Action, statep::State)

@pomdp_func create_state(pomdp::POMDP)
@pomdp_func create_observation(pomdp::POMDP)

@pomdp_func isterminal(pomdp::POMDP, state::State)

@pomdp_func index(pomdp::POMDP, state::State)
