// docs/e01-structure.png 생성 스크립트: swift docs/diagram/e01-structure.swift docs/e01-structure.png
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let W = 1260, H = 420
let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0,
  space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
ctx.translateBy(x: 0, y: CGFloat(H)); ctx.scaleBy(x: 1, y: -1)   // 왼쪽 위 원점
ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1)); ctx.fill(CGRect(x: 0, y: 0, width: W, height: H))

func c(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> CGColor { CGColor(red: r, green: g, blue: b, alpha: 1) }
let purple = c(0.52, 0.32, 0.82), green = c(0.16, 0.56, 0.28), blue = c(0.15, 0.40, 0.80)
let ink = c(0.12, 0.12, 0.14), gray = c(0.40, 0.40, 0.44)

func box(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ color: CGColor, fill: CGColor? = nil, dashed: Bool = false, lw: CGFloat = 3) {
  let p = CGPath(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerWidth: 14, cornerHeight: 14, transform: nil)
  if let f = fill { ctx.addPath(p); ctx.setFillColor(f); ctx.fillPath() }
  ctx.addPath(p); ctx.setStrokeColor(color); ctx.setLineWidth(lw)
  ctx.setLineDash(phase: 0, lengths: dashed ? [12, 8] : []); ctx.strokePath(); ctx.setLineDash(phase: 0, lengths: [])
}

// center: true면 x를 글자 가운데로 봄
func text(_ s: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, bold: Bool = false, color: CGColor = ink, center: Bool = false) {
  let font = CTFontCreateWithName((bold ? "AppleSDGothicNeo-Bold" : "AppleSDGothicNeo-Regular") as CFString, size, nil)
  let attr = NSAttributedString(string: s, attributes: [NSAttributedString.Key(kCTFontAttributeName as String): font,
                                                        NSAttributedString.Key(kCTForegroundColorAttributeName as String): color])
  let line = CTLineCreateWithAttributedString(attr)
  let w = center ? CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil)) : 0
  ctx.saveGState(); ctx.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
  ctx.textPosition = CGPoint(x: x - w / 2, y: y + size); CTLineDraw(line, ctx); ctx.restoreGState()
}

// 꺾은선. head면 끝에 화살촉
func path(_ pts: [CGPoint], _ color: CGColor, dashed: Bool = false, head: Bool = false) {
  ctx.setStrokeColor(color); ctx.setFillColor(color); ctx.setLineWidth(4)
  ctx.setLineDash(phase: 0, lengths: dashed ? [12, 8] : [])
  let end = pts[pts.count - 1], prev = pts[pts.count - 2]
  let a = atan2(end.y - prev.y, end.x - prev.x), hl: CGFloat = 20
  ctx.move(to: pts[0])
  for p in pts.dropFirst().dropLast() { ctx.addLine(to: p) }
  ctx.addLine(to: head ? CGPoint(x: end.x - cos(a) * hl * 0.8, y: end.y - sin(a) * hl * 0.8) : end); ctx.strokePath()
  ctx.setLineDash(phase: 0, lengths: [])
  guard head else { return }
  ctx.move(to: end)
  ctx.addLine(to: CGPoint(x: end.x - hl * cos(a - 0.45), y: end.y - hl * sin(a - 0.45)))
  ctx.addLine(to: CGPoint(x: end.x - hl * cos(a + 0.45), y: end.y - hl * sin(a + 0.45)))
  ctx.closePath(); ctx.fillPath()
}

func flow(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat) {
  path([CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y2)], blue, head: true)
}

// 한 줄로 읽음: 인터넷 ⇄ IGW ⇄ 서브넷. 위 줄은 들어올 때(→), 아래 줄은 나갈 때(←)
let inY: CGFloat = 240, outY: CGFloat = 280

box(400, 40, 820, 340, purple)
text("VPC", 430, 56, 24, bold: true, color: purple)

box(40, 220, 140, 80, blue, fill: c(0.93, 0.96, 1.0))
text("인터넷", 110, 246, 24, bold: true, color: blue, center: true)

box(280, 200, 240, 120, purple, fill: c(0.97, 0.95, 1.0))   // VPC 왼쪽 경계에 걸침
text("Internet Gateway", 400, 246, 24, bold: true, color: purple, center: true)

box(860, 200, 320, 120, green, fill: c(0.95, 0.99, 0.95))
text("Public Subnet", 1020, 246, 24, bold: true, color: green, center: true)

flow(180, inY, 280, inY); flow(520, inY, 860, inY)
flow(860, outY, 520, outY); flow(280, outY, 180, outY)
text("들어올 때", 690, 204, 20, color: gray, center: true)
text("나갈 때", 690, 292, 20, color: gray, center: true)

// Route Table: 0.0.0.0/0 줄이 IGW를 가리킴
box(880, 70, 280, 80, ink, fill: c(0.97, 0.97, 0.97), lw: 2)
text("Route Table", 900, 80, 22, bold: true)
ctx.setFillColor(c(0.95, 0.92, 1.0)); ctx.fill(CGRect(x: 900, y: 110, width: 240, height: 30))
text("0.0.0.0/0 → IGW", 910, 113, 20, bold: true, color: purple)
path([CGPoint(x: 900, y: 125), CGPoint(x: 460, y: 125), CGPoint(x: 460, y: 200)], purple, head: true)

// 라우팅 테이블 ↔ 서브넷 연결
path([CGPoint(x: 1020, y: 150), CGPoint(x: 1020, y: 200)], green, dashed: true)
text("연결", 1032, 162, 18, color: gray)

let out = CGImageDestinationCreateWithURL(URL(fileURLWithPath: CommandLine.arguments[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(out, ctx.makeImage()!, nil)
CGImageDestinationFinalize(out)
