extends Node

# esport a variable exposes it to the renderer
# Useful when you want to get a reference to a different scene
#export var exportedVariable = 10
export(PackedScene) var trunkScene

onready var firstTrunkPosition = $FirstTrunkPosition
onready var grave = $Dead
onready var timeLeft = $TimeLeft
onready var player = $Player
onready var timer = $Timer
onready var score = $PlayerScore


var lastSpawnPosition
var trunks = []
var lastHasAxe = false
var lastAxeRight = false
var dead = false
var scoreTally = 0

func _ready():
	lastSpawnPosition = firstTrunkPosition.position
	_spawnfirstTrunks()
	score.text = str(scoreTally)
	
func _process(delta):
	if dead:
		return
	timeLeft.value -= delta
	if timeLeft.value <= 0:
		die()

# creates our trees
func _spawnfirstTrunks():
	for counter in range(5):
		var newTrunk = trunkScene.instance()
		add_child(newTrunk)
		newTrunk.position = lastSpawnPosition
		lastSpawnPosition.y -= newTrunk.spriteHeight
		newTrunk.initializeTrunk(false, false)
		trunks.append(newTrunk)
		
func _addTrunk(axe, axeRight):
	var newTrunk = trunkScene.instance()
	add_child(newTrunk)
	newTrunk.position = lastSpawnPosition
	newTrunk.initializeTrunk(axe, axeRight)
	trunks.append(newTrunk)

func punchTree(fromRight):

	if !lastHasAxe:
		if rand_range(0, 100) > 50:
			lastAxeRight = rand_range(0, 100) >50
			lastHasAxe = true
			# Spawn trunk
		else:
			lastHasAxe = false
			# Spawn trunk
	else:
		if rand_range(0, 100) > 50:
			lastHasAxe = true
			# Spawn trunk with axe on same position as the last
		else:
			lastHasAxe = false
			# Spawn a trunk w/o an axe
	_addTrunk(lastHasAxe, lastAxeRight)
	
	trunks[0].remove(fromRight)
	trunks.pop_front()
	for trunk in trunks:
		trunk.position.y += trunk.spriteHeight
	
	timeLeft.value += 0.25
	if timeLeft.value > timeLeft.max_value:
		timeLeft.value = timeLeft.max_value
	
	scoreTally += 1
	score.text = str(scoreTally)


func die():
	grave.position.x = player.position.x
	player.queue_free()
	timer.start()
	grave.visible = true
	dead = true

func _on_Timer_timeout():
	get_tree().reload_current_scene()