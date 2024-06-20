import AppMetricaCore


final class Analytic {
    
    static let shared = Analytic()
    
    enum Events: String {
        case open = "open"
        case click = "click"
    }
    
    enum Screens: String {
        case search = "search"
        case band = "band"
        case author = "author_profile"
        case audio = "create_audio"
        case podcast = "podcast"
    }
    
    enum Items: String {
        case like = "like"
        case subscribe = "subscribe"
        case auto = "auto_move"
        case dictophone = "dictophone"
        case file = "from_file"
    }
    
    private static let key = "2c8db343-7326-4fec-974f-20c0bf3eaf51"
    
    private init() {
        if let configuration = AppMetricaConfiguration(apiKey: Analytic.key) {
            AppMetrica.activate(with: configuration)
        }
        AppMetrica.reportEvent(name: "EVENT", parameters: ["application": "open"], onFailure: { error in
            print("REPORT ERROR: %@", "Проверьте соединение")
        })
    }
    
    public func report(event: Events, screen: Screens, item: Items? = nil) {
        let params : [AnyHashable : Any]
        if event != .open, let item {
            params = ["event": event.rawValue, "screen": screen.rawValue, "item": item.rawValue]
        } else {
            params = ["event": event.rawValue, "screen": screen.rawValue]
        }
        AppMetrica.reportEvent(name: "EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
