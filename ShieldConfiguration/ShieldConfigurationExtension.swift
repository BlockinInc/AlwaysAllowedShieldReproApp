import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration(
            title: ShieldConfiguration.Label(text: "Shielded by AlwaysAllowedShieldRepro", color: .label),
            subtitle: ShieldConfiguration.Label(text: application.localizedDisplayName ?? "Unknown app", color: .secondaryLabel)
        )
    }

    // Apps shielded through `applicationCategories` are routed here, so return the same configuration.
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        configuration(shielding: application)
    }
}
