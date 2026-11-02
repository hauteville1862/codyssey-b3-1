// docs/e01-structure.png 생성 스크립트: swift docs/diagram/e01-structure.swift docs/e01-structure.png
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let W = 1620, H = 900
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

func internet(_ x: CGFloat, _ cy: CGFloat) {
  box(x, cy - 40, 140, 80, blue, fill: c(0.93, 0.96, 1.0))
  text("인터넷", x + 70, cy - 18, 28, bold: true, color: blue, center: true)
}

func igw(_ cx: CGFloat, _ cy: CGFloat) {
  box(cx - 130, cy - 60, 260, 120, purple, fill: c(0.97, 0.95, 1.0))
  text("Internet Gateway", cx, cy - 38, 26, bold: true, color: purple, center: true)
  text("b3-1-igw", cx, cy + 4, 22, color: gray, center: true)
}

func subnet(_ x: CGFloat, _ y: CGFloat, _ h: CGFloat) {
  box(x, y, 360, h, green, fill: c(0.95, 0.99, 0.95))
  text("Public Subnet", x + 24, y + 16, 26, bold: true, color: green)
  text("b3-1-public-subnet", x + 24, y + 56, 22)
  text("10.0.1.0/24", x + 24, y + 88, 22, color: gray)
}

func vpc(_ x: CGFloat, _ y: CGFloat, _ h: CGFloat) {
  box(x, y, 1190, h, purple)
  text("VPC  b3-1-vpc  ·  10.0.0.0/16", x + 30, y + 16, 24, bold: true, color: purple)
}

// 제목
text("E01 구조: VPC · Public Subnet · Internet Gateway · Route Table", 60, 30, 30, bold: true)

// ① 들어올 때: 인터넷 → IGW → 서브넷 (모든 화살표가 오른쪽을 향함)
text("① 들어올 때 (요청)", 40, 100, 24, bold: true)
let y1: CGFloat = 290
vpc(370, 150, 250)
internet(40, y1)
igw(370, y1)
subnet(1150, y1 - 60, 120)
path([CGPoint(x: 180, y: y1), CGPoint(x: 240, y: y1)], blue, head: true)
path([CGPoint(x: 500, y: y1), CGPoint(x: 1150, y: y1)], blue, head: true)

// ② 나갈 때: 서브넷 → IGW → 인터넷. 라우팅 테이블의 0.0.0.0/0 줄이 IGW를 가리킴
text("② 나갈 때 (응답)", 40, 430, 24, bold: true)
let y2: CGFloat = 780
vpc(60, 475, 380)
subnet(110, 580, 240)
igw(1250, y2)
internet(1440, y2)
path([CGPoint(x: 470, y: y2), CGPoint(x: 1120, y: y2)], blue, head: true)
path([CGPoint(x: 1380, y: y2), CGPoint(x: 1440, y: y2)], blue, head: true)

// Route Table (흐름선 위)
box(570, 520, 420, 190, ink, fill: c(0.97, 0.97, 0.97), lw: 2)
text("Route Table", 594, 534, 24, bold: true)
text("b3-1-public-rt", 744, 538, 20, color: gray)
let tx: CGFloat = 594, tw: CGFloat = 372, ty: CGFloat = 574, rh: CGFloat = 40, split: CGFloat = 770
ctx.setFillColor(c(0.95, 0.92, 1.0)); ctx.fill(CGRect(x: tx, y: ty + rh * 2, width: tw, height: rh))
ctx.setStrokeColor(gray); ctx.setLineWidth(1.5)
for i in 0...3 { ctx.move(to: CGPoint(x: tx, y: ty + rh * CGFloat(i))); ctx.addLine(to: CGPoint(x: tx + tw, y: ty + rh * CGFloat(i))) }
for x in [tx, split, tx + tw] { ctx.move(to: CGPoint(x: x, y: ty)); ctx.addLine(to: CGPoint(x: x, y: ty + rh * 3)) }
ctx.strokePath()
text("대상", tx + 16, ty + 8, 20, bold: true)
text("타깃", split + 16, ty + 8, 20, bold: true)
text("10.0.0.0/16", tx + 16, ty + rh + 8, 20)
text("local", split + 16, ty + rh + 8, 20)
text("0.0.0.0/0", tx + 16, ty + rh * 2 + 8, 20, bold: true, color: purple)
text("b3-1-igw", split + 16, ty + rh * 2 + 8, 20, bold: true, color: purple)

// 0.0.0.0/0 줄 → IGW
let ry = ty + rh * 2 + rh / 2
path([CGPoint(x: tx + tw, y: ry), CGPoint(x: 1200, y: ry), CGPoint(x: 1200, y: y2 - 60)], purple, head: true)

// 서브넷 ↔ 라우팅 테이블 연결
path([CGPoint(x: 470, y: 620), CGPoint(x: 570, y: 620)], green, dashed: true)
text("연결", 520, 584, 20, color: gray, center: true)

let out = CGImageDestinationCreateWithURL(URL(fileURLWithPath: CommandLine.arguments[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(out, ctx.makeImage()!, nil)
CGImageDestinationFinalize(out)
