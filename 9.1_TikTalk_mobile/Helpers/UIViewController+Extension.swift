import UIKit


extension UIViewController {
    
    func showErrorAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Закрыть", style: .default) { _ in
            completion?()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAuthController() {
        let nc = UINavigationController(rootViewController: AuthViewController())
        present(nc, animated: true)
    }
    
}
