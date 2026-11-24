import Foundation

struct ScreenOverlay {
  static let menuBarLayer = 24
  static let slackBundle = "com.tinyspeck.slackmacgap"

  let bounds: CGRect
  let layer: Int
  let fromSlack: Bool

  func passesOver(_ point: CGPoint, displays: [CGRect], windows: [CGRect], margin: CGFloat) -> Bool {
    guard bounds.contains(point) else { return false }
    let rings = { (frame: CGRect) in frame.contains(point) && bounds.contains(frame.insetBy(dx: margin, dy: margin)) }
    if layer > Self.menuBarLayer { return displays.contains(where: rings) || windows.contains(where: rings) }
    return fromSlack && windows.contains { rings($0) && $0.insetBy(dx: -margin, dy: -margin).contains(bounds) }
  }
}
