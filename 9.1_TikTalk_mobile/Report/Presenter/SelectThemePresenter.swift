import Foundation


final class SelectThemePresenter {
    
    private var themes: [String]
    private var selectedTheme: String?
    private var completion: (String) -> Void
    
    init(themes: [String], selectedTheme: String?, completion: @escaping (String) -> Void) {
        self.themes = themes
        self.selectedTheme = selectedTheme
        self.completion = completion
    }
    
    func getThemes() -> [String]{
        themes
    }
    
    func selectedTheme(_ theme: String) {
        selectedTheme = theme
    }
    
    func selectedThemeIndex() -> Int? {
        if let selectedTheme {
            return themes.firstIndex(of: selectedTheme)
        }
        return nil
    }
    
    func closeViewController() {
        if let selectedTheme {
            completion(selectedTheme)
        }
    }
}
