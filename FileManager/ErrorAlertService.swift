import UIKit

class ErrorAlertService {
 
    func createAlert(_ message: String)-> UIAlertController {
        let alertVC = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let button1 = UIAlertAction(title: "ОК", style: .default)
   
        alertVC.addAction(button1)

        return alertVC
    }
}
