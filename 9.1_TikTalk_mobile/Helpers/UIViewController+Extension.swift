import UIKit


extension UIViewController {
    
    func showErrorAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Закрыть", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}
