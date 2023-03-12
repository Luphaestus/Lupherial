extends Entity

var ra = [0.661133,-0.450579,-0.102644,0.003019,-0.017206,-0.010087]
var rb = [-0.228901,-0.139233,0.029436,0.047411,0.007989]
var ga = [0.626849,-0.437814,-0.050352,-0.009737,-0.028222,0.002317]
var gb = [-0.279056,-0.106992,0.066646,0.032230,-0.001321]
var ba = [0.725802,-0.268970,-0.035903,-0.006988,-0.021679,-0.002546]
var bb = [-0.175541,-0.079950,0.034039,0.021785,-0.000069]
var w = [0.258071,0.264981,0.258893]

func  _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)


	var r = 0
	var g = 0
	var b = 0
	for i in range(6):
		r += ra[i]*cos(i*get_tree().get_nodes_in_group("core")[0].TIME*w[0])
		g += ga[i]*cos(i*get_tree().get_nodes_in_group("core")[0].TIME*w[1])
		b += ba[i]*cos(i*get_tree().get_nodes_in_group("core")[0].TIME*w[2])
	for i in range(1,6):
		r += rb[i-1]*sin(i*get_tree().get_nodes_in_group("core")[0].TIME*w[0])
		g += gb[i-1]*sin(i*get_tree().get_nodes_in_group("core")[0].TIME*w[1])
		b += bb[i-1]*sin(i*get_tree().get_nodes_in_group("core")[0].TIME*w[2])
	r = min(r,1)
	g = min(g,1)
	b = min(b,1)
	self.color = Color(r,g,b,1)
	
