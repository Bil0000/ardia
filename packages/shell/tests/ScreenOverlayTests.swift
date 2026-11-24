import XCTest
@testable import ArdiaUpdaterCore

final class ScreenOverlayTests: XCTestCase {
  let display = CGRect(x: 0, y: 0, width: 1920, height: 1080)
  let ardia = CGRect(x: 0, y: 120, width: 1000, height: 700)
  let edge = CGPoint(x: 1, y: 400)

  func over(_ bounds: CGRect, layer: Int, fromSlack: Bool = false) -> Bool {
    ScreenOverlay(bounds: bounds, layer: layer, fromSlack: fromSlack).passesOver(edge, displays: [display], windows: [ardia], margin: 24)
  }

  func testAScreenShareBorderAroundTheDisplayIsPassedThrough() {
    XCTAssertTrue(over(display, layer: 1000))
  }

  func testSlacksBorderAroundASharedArdiaWindowIsPassedThrough() {
    XCTAssertTrue(over(ardia.insetBy(dx: -4, dy: -4), layer: 0, fromSlack: true))
  }

  func testAnOrdinaryWindowOverTheEdgeStillBlocks() {
    XCTAssertFalse(over(CGRect(x: 0, y: 0, width: 200, height: 1080), layer: 1000))
    XCTAssertFalse(over(display, layer: 0))
    XCTAssertFalse(over(ardia.insetBy(dx: -4, dy: -4), layer: 0))
    XCTAssertFalse(over(CGRect(x: 0, y: 0, width: 1200, height: 1080), layer: 0, fromSlack: true))
  }

  func testAnOverlayThatMissesThePointerIsNotPassedThrough() {
    XCTAssertFalse(over(CGRect(x: 1920, y: 0, width: 1920, height: 1080), layer: 1000))
    XCTAssertFalse(over(display.insetBy(dx: 8, dy: 8), layer: 1000))
  }
}
