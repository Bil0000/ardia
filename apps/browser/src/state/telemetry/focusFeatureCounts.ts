import { takeChromeSettingsOpens } from "./chromeSettingsOpens";
import { takePageFocusReturns } from "./pageFocusReturns";
import { takeHiddenElementCounts } from "./hiddenElementCounts";
import { takeMinimalismCounts } from "./minimalismCounts";
import { takeReaderCounts } from "./readerCounts";

export function takeFocusFeatureCounts() {
  return { ...takeMinimalismCounts(), ...takeReaderCounts(), ...takeHiddenElementCounts(), ...takeChromeSettingsOpens(), ...takePageFocusReturns() };
}
