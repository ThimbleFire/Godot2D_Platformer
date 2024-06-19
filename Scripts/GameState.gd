class_name GameState

# GameState is a master class that stores global save data

var toolbelt : Array[byte] = []
var current_level : byte = 0
var position_in_current_level : Vector2 = Vector2.Zero

# `quest_progression` represents a bit mask value storing which quests are flagged as complete; see `Objective::ID`
# This behaviour is not yet implemented and is entirely in its design phase.
# For example, quests are currently stored as an enumerable constant and might be replaced with a Array<>
var quest_progression : int = 0
