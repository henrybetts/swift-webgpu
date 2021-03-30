import WebGPU

extension Color {
    init(h: Double, s: Double, v: Double, a: Double) {
        if s == 0 { // Achromatic grey
            self.init(r: v, g: v, b: v, a: a)
            return
        }
        
        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60 // Sector
        let i = sector.rounded(.down)
        let f = sector - i // Factorial part of h
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            self.init(r: v, g: t, b: p, a: a)
        case 1:
            self.init(r: q, g: v, b: p, a: a)
        case 2:
            self.init(r: p, g: v, b: t, a: a)
        case 3:
            self.init(r: p, g: q, b: v, a: a)
        case 4:
            self.init(r: t, g: p, b: v, a: a)
        default:
            self.init(r: v, g: p, b: q, a: a)
        }
    }
}
