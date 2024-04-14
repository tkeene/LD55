extends Area2D

func on_body_entered(node: PhysicsBody2D):
	if node is Player:
		node.kill()
