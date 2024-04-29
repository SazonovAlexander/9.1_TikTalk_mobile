import AppMetricaCore


final class Analytic {
    
    static let shared = Analytic()
    
    private static let key = "2c8db343-7326-4fec-974f-20c0bf3eaf51"
    
    private init() {
        if let configuration = AppMetricaConfiguration(apiKey: Analytic.key) {
            AppMetrica.activate(with: configuration)
        }
    }
}
