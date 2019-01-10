package samples

type Bridge struct {}

func (b *Bridge) Connect(user, pw string) {
	println(user, pw)
}

func init() {
	//gml.Register("bridge", &Bridge{})
}
