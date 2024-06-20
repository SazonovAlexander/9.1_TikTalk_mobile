import UIKit
import ProgressHUD


final class BlockingProgressHUD {
    
    static func show() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
            ProgressHUD.animate(interaction: false)
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}
