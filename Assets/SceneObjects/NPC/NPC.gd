class_name NPC

extends Actor

enum NPCBehaviours { IDLE, WANDERING, FOLLOWING, FOLLOWING_AND_ATTACKING, CONVERSATION_LOCKED }

# Map pathfinding nodes
# Flag nodes as floor, walls and air
# If the desination node is above the starting node along the Y axis, calculate an initial path using all node types
# Raycast in the direction of left and right of each non-ground node to determine where the walls are
# calculate the jump arch from each of these walls

func update(delta):
  
  pass
