import AppKit

// Draws the app icon: an original tomato on a plain tile, laid out on the macOS
// icon grid (1024 canvas, 824 tile) so it sits at the same size as other apps.
let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil, pixelsWide: 1024, pixelsHigh: 1024, bitsPerSample: 8,
    samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
    bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let ctx = NSGraphicsContext.current!.cgContext

func color(_ hex: Int, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(srgbRed: CGFloat(hex >> 16 & 0xFF) / 255, green: CGFloat(hex >> 8 & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255, alpha: alpha)
}

// Tile with a soft drop shadow.
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -10), blur: 24, color: color(0x000000, 0.22).cgColor)
color(0xFBF4EC).setFill()
NSBezierPath(roundedRect: NSRect(x: 100, y: 100, width: 824, height: 824), xRadius: 185, yRadius: 185).fill()
ctx.restoreGState()

// Body: slightly wider than tall, lit from the top left.
let body = NSBezierPath(ovalIn: NSRect(x: 222, y: 210, width: 580, height: 520))
NSGradient(colors: [color(0xFF6A55), color(0xE5302A), color(0xB81B1B)])!
    .draw(in: body, relativeCenterPosition: NSPoint(x: -0.35, y: 0.35))

// Highlight.
ctx.saveGState()
ctx.translateBy(x: 372, y: 590)
ctx.rotate(by: 0.6)
color(0xFFFFFF, 0.38).setFill()
NSBezierPath(ovalIn: NSRect(x: -70, y: -34, width: 140, height: 68)).fill()
ctx.restoreGState()

// Calyx: a flat five-point star with rounded tips, then the stem.
let calyx = NSBezierPath()
let center = CGPoint(x: 512, y: 690)
for i in 0..<10 {
    let angle = CGFloat.pi / 2 + CGFloat(i) * .pi / 5
    let radius: CGFloat = i % 2 == 0 ? 170 : 48
    let point = CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius * 0.42)
    i == 0 ? calyx.move(to: point) : calyx.line(to: point)
}
calyx.close()
calyx.lineJoinStyle = .round
calyx.lineWidth = 22
color(0x3E9B3E).set()
calyx.fill()
calyx.stroke()

let stem = NSBezierPath(roundedRect: NSRect(x: 496, y: 690, width: 32, height: 92), xRadius: 16, yRadius: 16)
color(0x2F7A30).setFill()
stem.fill()

let out = URL(fileURLWithPath: CommandLine.arguments[1])
try rep.representation(using: .png, properties: [:])!.write(to: out)
