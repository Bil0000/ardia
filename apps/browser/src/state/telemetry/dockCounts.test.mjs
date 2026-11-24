import assert from "node:assert/strict";
import { test } from "node:test";

const { FRAME_UNDER_OLD_PEEK_GAP, noteSidebarPeekFrame, takeDockCounts } = await import("./dockCounts.ts");

test("a peek on a frame thinner than the old 4 pt peek gap is counted, and the count resets once taken", () => {
  takeDockCounts();
  for (const inset of [0, 1, 2, 3, FRAME_UNDER_OLD_PEEK_GAP, 9, 12]) noteSidebarPeekFrame(inset);
  assert.equal(takeDockCounts().sidebar_thin_frame_peeks, 4);
  assert.equal(takeDockCounts().sidebar_thin_frame_peeks, 0);
});

test("a peek whose slide passed its final width counts only under the consent period it started in, and the count resets once taken", async () => {
  const { noteSidebarPeekPastTarget } = await import("./dockCounts.ts");
  const { consentToken, setConsentPeriod } = await import("./consentPeriod.ts");
  takeDockCounts();
  setConsentPeriod(true, "peek-on");
  const started = consentToken();
  noteSidebarPeekPastTarget(started);
  noteSidebarPeekPastTarget(null);
  setConsentPeriod(true, "peek-next");
  noteSidebarPeekPastTarget(started);
  setConsentPeriod(false, null);
  assert.equal(takeDockCounts().sidebar_peeks_past_target, 1);
  assert.equal(takeDockCounts().sidebar_peeks_past_target, 0);
});

test("a peek opened through another app's screen sharing border is counted, and the count resets once taken", () => {
  takeDockCounts();
  noteSidebarPeekFrame(9, true);
  noteSidebarPeekFrame(9, false);
  noteSidebarPeekFrame(9, true);
  assert.equal(takeDockCounts().sidebar_edge_reveals_through_overlay, 2);
  assert.equal(takeDockCounts().sidebar_edge_reveals_through_overlay, 0);
});
