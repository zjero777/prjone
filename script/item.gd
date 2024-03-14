class_name Item



var	resource: Prod_resource
var count: int

func create(_id: int, _count: int):
	resource = Prod_resource.new()
	resource.add(_id)
	count = _count
	
