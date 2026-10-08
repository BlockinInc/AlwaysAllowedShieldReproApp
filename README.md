# AlwaysAllowedShieldRepro

Minimal sample that reproduces an iOS 27 regression: apps listed in **Screen Time > Always Allowed** are shielded by `ManagedSettingsStore().shield.applicationCategories = .all()`. On iOS 26.7.1 those apps were excluded from the shield.

## Before building

In **Signing & Capabilities**, select your own development team for both targets:

- `AlwaysAllowedShieldRepro` (app)
- `ShieldConfiguration` (Shield Configuration extension)

The bundle identifiers become unique automatically (`Configuration/SampleCode.xcconfig` appends your team ID). Both targets use the `com.apple.developer.family-controls` entitlement.

## Environment

| iOS | Result |
| --- | --- |
| iOS 27.0.1 | Reproduces |
| iOS 27.2 Beta 3 | Reproduces |
| iOS 26.7.1 | Works as expected |

Deployment target is iOS 26.0 so the same build runs on both versions.

## Steps to reproduce

1. Open **Settings > Screen Time > Always Allowed** and add **Photos**.
2. Launch the app and tap **Request Authorization**.
3. Tap **Start Shield**.
4. Go back to the Home Screen and tap **Photos**.

## Expected result

Photos is not shielded.

## Actual result

Photos is shielded with the title "Shielded by AlwaysAllowedShieldRepro".

## Comparison with legacy Screen Time

If an iOS 26 or earlier device is signed in to the same Apple Account, legacy Screen Time is active, and Photos is **not** shielded even on iOS 27.

## Logs

The app logs each Start / Stop with an ISO 8601 timestamp (also shown on screen) to correlate with a sysdiagnose:

- Subsystem: `com.example.AlwaysAllowedShieldRepro`
- Category: `Shield`

## License

MIT. See [LICENSE](LICENSE).
