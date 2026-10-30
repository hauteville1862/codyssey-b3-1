// docs/architecture.png 생성 스크립트: swift docs/diagram/architecture.swift docs/architecture.png
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let W = 1600, H = 1240
let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0,
  space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
ctx.translateBy(x: 0, y: CGFloat(H)); ctx.scaleBy(x: 1, y: -1)   // 왼쪽 위 원점
ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1)); ctx.fill(CGRect(x: 0, y: 0, width: W, height: H))

func c(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> CGColor { CGColor(red: r, green: g, blue: b, alpha: 1) }
let orange = c(0.90, 0.52, 0.10), purple = c(0.52, 0.32, 0.82), green = c(0.16, 0.56, 0.28)
let red = c(0.82, 0.18, 0.18), blue = c(0.15, 0.40, 0.80), ink = c(0.12, 0.12, 0.14), gray = c(0.40, 0.40, 0.44)

func box(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ color: CGColor, fill: CGColor? = nil, dashed: Bool = false, lw: CGFloat = 3) {
  let p = CGPath(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerWidth: 14, cornerHeight: 14, transform: nil)
  if let f = fill { ctx.addPath(p); ctx.setFillColor(f); ctx.fillPath() }
  ctx.addPath(p); ctx.setStrokeColor(color); ctx.setLineWidth(lw)
  ctx.setLineDash(phase: 0, lengths: dashed ? [12, 8] : []); ctx.strokePath(); ctx.setLineDash(phase: 0, lengths: [])
}

func text(_ s: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, bold: Bool = false, color: CGColor = ink) {
  let font = CTFontCreateWithName((bold ? "AppleSDGothicNeo-Bold" : "AppleSDGothicNeo-Regular") as CFString, size, nil)
  let attr = NSAttributedString(string: s, attributes: [NSAttributedString.Key(kCTFontAttributeName as String): font,
                                                        NSAttributedString.Key(kCTForegroundColorAttributeName as String): color])
  let line = CTLineCreateWithAttributedString(attr)
  ctx.saveGState(); ctx.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
  ctx.textPosition = CGPoint(x: x, y: y + size); CTLineDraw(line, ctx); ctx.restoreGState()
}

func arrow(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ color: CGColor, dashed: Bool = false) {
  ctx.setStrokeColor(color); ctx.setFillColor(color); ctx.setLineWidth(4)
  ctx.setLineDash(phase: 0, lengths: dashed ? [12, 8] : [])
  let a = atan2(y2 - y1, x2 - x1), hl: CGFloat = 20
  ctx.move(to: CGPoint(x: x1, y: y1)); ctx.addLine(to: CGPoint(x: x2 - cos(a) * hl * 0.8, y: y2 - sin(a) * hl * 0.8)); ctx.strokePath()
  ctx.setLineDash(phase: 0, lengths: [])
  ctx.move(to: CGPoint(x: x2, y: y2))
  ctx.addLine(to: CGPoint(x: x2 - hl * cos(a - 0.45), y: y2 - hl * sin(a - 0.45)))
  ctx.addLine(to: CGPoint(x: x2 - hl * cos(a + 0.45), y: y2 - hl * sin(a + 0.45)))
  ctx.closePath(); ctx.fillPath()
}

// 제목
text("B3-1 아키텍처: 외부 → Internet Gateway → Public Subnet → EC2", 60, 36, 34, bold: true)

// 사용자
box(560, 110, 400, 96, blue, fill: c(0.93, 0.96, 1.0))
text("인터넷 사용자", 690, 124, 28, bold: true, color: blue)
text("브라우저 · curl (내 Mac)", 660, 164, 22, color: gray)

// 리전 · VPC
box(60, 270, 1480, 900, orange, lw: 3)
text("AWS 서울 리전 (ap-northeast-2)", 84, 284, 24, bold: true, color: orange)
box(120, 400, 1360, 740, purple, lw: 3)
text("VPC  b3-1-vpc  ·  10.0.0.0/16", 144, 470, 26, bold: true, color: purple)
text("vpc-01c56407f06fa7ab6", 144, 506, 20, color: gray)

// Internet Gateway (VPC 경계)
box(560, 340, 400, 110, purple, fill: c(0.97, 0.95, 1.0))
text("Internet Gateway", 652, 352, 28, bold: true, color: purple)
text("b3-1-igw (igw-09f0393a13442868a)", 600, 396, 20, color: gray)

// Route Table
box(1040, 560, 400, 210, ink, fill: c(0.97, 0.97, 0.97), lw: 2)
text("Route Table  b3-1-public-rt", 1060, 576, 22, bold: true)
text("10.0.0.0/16 → local", 1060, 620, 22)
text("0.0.0.0/0  → b3-1-igw", 1060, 656, 22, bold: true, color: purple)
text("서브넷에 명시적으로 연결", 1060, 700, 20, color: gray)
text("rtb-0e8fd4f4d57971443", 1060, 732, 18, color: gray)

// Public Subnet
box(170, 560, 840, 550, green, fill: c(0.95, 0.99, 0.95), lw: 3)
text("Public Subnet  b3-1-public-subnet", 194, 576, 24, bold: true, color: green)
text("10.0.1.0/24 · ap-northeast-2a · subnet-0ff9f8733f5459e16", 194, 612, 19, color: gray)

// Security Group
box(230, 660, 720, 420, red, dashed: true, lw: 3)
text("Security Group  b3-1-web-sg", 252, 674, 21, bold: true, color: red)

// EC2
box(300, 730, 580, 190, blue, fill: c(1, 1, 1), lw: 3)
text("EC2  b3-1-web", 324, 746, 28, bold: true, color: blue)
text("t3.micro · Amazon Linux 2023 · 8GiB", 324, 790, 21)
text("Nginx:  /  ·  /health → 200 OK", 324, 826, 21)
text("퍼블릭 IP 43.203.121.126 · 사설 IP 10.0.1.139", 324, 866, 20, color: gray)

// SG 규칙
text("인바운드  HTTP 80  ← 0.0.0.0/0  (누구나)", 260, 944, 21)
text("인바운드  SSH 22   ← 내 공인 IP /32  (나만)", 260, 980, 21)
text("아웃바운드  모든 트래픽 → 0.0.0.0/0", 260, 1016, 21)
text("sg-0b65376c4e71e9d39", 260, 1048, 18, color: gray)

// 요청 흐름
arrow(760, 206, 760, 340, blue)
text("① HTTP 요청 (80)", 780, 222, 22, bold: true, color: blue)
arrow(760, 450, 760, 730, blue)
text("② IGW가 퍼블릭 IP를", 780, 470, 20, color: blue)
text("    사설 IP로 바꿔 전달", 780, 498, 20, color: blue)
text("③ SG가 80번 허용", 780, 680, 20, bold: true, color: red)

// 응답 흐름
arrow(880, 800, 1040, 680, purple, dashed: true)
ctx.setStrokeColor(purple); ctx.setLineWidth(4); ctx.setLineDash(phase: 0, lengths: [12, 8])
ctx.move(to: CGPoint(x: 1300, y: 560)); ctx.addLine(to: CGPoint(x: 1300, y: 425)); ctx.strokePath()
arrow(1300, 425, 960, 425, purple, dashed: true)
text("④ 응답은 0.0.0.0/0 → IGW 경로로", 1000, 336, 20, bold: true, color: purple)
text("    다시 인터넷으로 나감", 1000, 364, 20, color: purple)

// 각주
text("SSH(22)는 내 IP에서만 허용 · 기본 VPC와 그 IGW는 실습 대상이 아님", 60, 1192, 20, color: gray)

let out = CGImageDestinationCreateWithURL(URL(fileURLWithPath: CommandLine.arguments[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(out, ctx.makeImage()!, nil)
CGImageDestinationFinalize(out)
