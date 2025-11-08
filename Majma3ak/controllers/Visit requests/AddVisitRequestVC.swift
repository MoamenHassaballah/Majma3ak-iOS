import UIKit
import Alamofire
import ProgressHUD

class AddVisitRequestVC: UIViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton! // <-- Connect this from Storyboard
    @IBOutlet weak var loaderAddMaintanceReq: UIActivityIndicatorView!
    
    
    
    private var datePicker: UIDatePicker?
    private var toolbar: UIToolbar?
    private var isPickingDate = true // To track which type is being picked
    
    @IBOutlet weak var VisitorNametxt: UITextField!
    @IBOutlet weak var VisitorPhonetxt: UITextField!
    
    @IBOutlet weak var descrptionProblemtxt: UITextView!
    
    @IBOutlet weak var sendRequestBtn: UIButton!
    
    private var selectedTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpview()
        setupdata()
        fetchdata()
        localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isHiddenNavigation = false
        self.navigationItem.hidesBackButton = true
        
        
    }
    
    
    @IBAction func didBackButton(_ sender: Any) {
        pop()
    }
    
    
    
    @IBAction func showDatePicker(_ sender: UIButton) {
        isPickingDate = true
        showPicker(title: "Select Date", mode: .date)
    }
    
    @IBAction func showTimePicker(_ sender: UIButton) {
        isPickingDate = false
        showPicker(title: "Select Time", mode: .time)
    }
    
    @IBAction func sendRequestButtonTapped(_ sender: UIButton) {
        
        
        
        guard let visitorName = VisitorNametxt.text, !visitorName.isEmpty else {
            ProgressHUD.image("visitor_name_required".loclize_, image: UIImage(systemName: "person.fill"))
            return
        }

        
        guard let visitorPhone = VisitorPhonetxt.text , !visitorPhone.isEmpty else {
            ProgressHUD.image("visitor_phone_required".loclize_, image: UIImage(systemName: "phone.badge.exclamationmark"))
            return
        }
        
        guard let dateTitle = dateButton.title(for: .normal), dateTitle != "Select Date" else {
            ProgressHUD.image("select_date_required".loclize_, image: UIImage(systemName: "calendar"))
            return
        }

        // تحقق أن التاريخ ليس قبل اليوم
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let selectedDate = dateFormatter.date(from: dateTitle), selectedDate < Date() {
            ProgressHUD.image("التاريخ يجب أن يكون اليوم أو بعده", image: UIImage(systemName: "calendar.badge.exclamationmark"))
            return
        }

        
        guard let timeTitle = timeButton.title(for: .normal), timeTitle != "Select Time" else {
            ProgressHUD.image("select_time_required".loclize_ , image: UIImage(systemName: "clock"))
            return
        }
        
        
        
        // ✅ إذا وصلنا هنا، فكل المدخلات سليمة
        print("📆 Date:", dateTitle)
        print("⏰ Time:", selectedTime)
        print("🙍‍♂️ Visitor Name:", visitorName)
        print("📝 Description:", description)
        
        sentVisitRequest(visiterName: visitorName,
                         visiterPhone: visitorPhone,
                         visitTime:selectedTime,
                         visitDate: dateTitle)
    }
}

//MARK: - Main Functions
extension AddVisitRequestVC {
    func setUpview(){
        self.loaderAddMaintanceReq.isHidden = true
//        VisitorNametxt.delegate  = self
//        VisitorPhonetxt.delegate = self
        VisitorNametxt.returnKeyType = .next
        VisitorPhonetxt.returnKeyType = .done
//        descrptionProblemtxt.delegate = self
        
        setupTextViews()
    }
    
    func setupdata(){
        
    }
    func localized(){
        
    }
    func fetchdata(){
        
    }
}

//MARK: - Others Functions

extension AddVisitRequestVC {
    
    private func showPicker(title: String, mode: UIDatePicker.Mode) {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = mode
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        }
        datePicker?.locale = Locale(identifier: "en_US") // ✅ This line forces 12-hour
        
        toolbar = UIToolbar()
        toolbar?.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicking))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar?.setItems([flexSpace, doneButton], animated: false)
        
        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        if let picker = datePicker {
            alert.view.addSubview(picker)
            picker.frame = CGRect(x: 0, y: 30, width: alert.view.frame.width - 20, height: 200)
        }
        
        if let tool = toolbar {
            alert.view.addSubview(tool)
            tool.frame = CGRect(x: 0, y: 0, width: alert.view.frame.width - 20, height: 44)
        }
        
        present(alert, animated: true)
    }
    
    @objc func donePicking() {
        guard let selected = datePicker?.date else { return }

        if isPickingDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "yyyy-MM-dd" // ✅ السيرفر يطلبه هكذا
            let dateString = formatter.string(from: selected)
            dateButton.setTitle(dateString, for: .normal)
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "HH:mm:ss" // 24-hour format with seconds
//            formatter.dateFormat = "H:mm"   // ✅ السيرفر يريد بصيغة 24 ساعة
            let timeString = formatter.string(from: selected)
            timeButton.setTitle(timeString, for: .normal)
            
            
            let serverFormatter = DateFormatter()
            serverFormatter.locale = Locale(identifier: "en_US")
            serverFormatter.dateFormat = "HH:MM"
            selectedTime = serverFormatter.string(from: selected)
        }

        dismiss(animated: true)
    }

    
    func sentVisitRequest(visiterName : String , visiterPhone : String , visitTime : String , visitDate : String ) {
        print("Visit Time: \(visitTime)")
        loaderAddMaintanceReq.isHidden = false
        loaderAddMaintanceReq.startAnimating()
        sendRequestBtn.setTitle("", for: .normal)

        let url = Request.AddvisitRequests

        
        
        WebService.shared.sendRequest(url: url,
                                      params: [
                                        "visiter_name":visiterName,
                                        "visiter_phone":visiterPhone,
                                        "visit_time":visitTime,
                                        "visit_date":visitDate
                                      ],
                                      method: .post, isAuth: true,
                                      responseType: AddVisitRequestResponse.self) { result in
            switch result {
            case .success(let success):
                print(success.code)
                print(success.message)
                self.loaderAddMaintanceReq.stopAnimating()
                self.loaderAddMaintanceReq.isHidden = true
                self.sendRequestBtn.setTitle("send Request".loclize_, for: .normal)
                ProgressHUD.succeed("Visit request added in success".loclize_)
                NotificationCenter.default.post(name: .visitRequestAdded, object: nil)
                self.pop()
            case .failure(let error):
                print("❌ Error:", error.localizedDescription)
                ProgressHUD.failed("Visit request failed to send".loclize_)
            }
        }
    }

    
}



extension AddVisitRequestVC: UITextViewDelegate, UITextFieldDelegate {
    public func setupTextViews() {
        view.subviews.forEach { setReturnHandler(for: $0) }
    }

    private func setReturnHandler(for view: UIView) {
        if let textView = view as? UITextView {
            textView.delegate = self
        } else {
            view.subviews.forEach { setReturnHandler(for: $0) }
        }
        
        if let textField = view as? UITextField {
            textField.delegate = self
            textField.returnKeyType = .done
        } else {
            view.subviews.forEach { setReturnHandler(for: $0) }
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
