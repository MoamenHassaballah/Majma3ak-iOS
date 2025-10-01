//
//  HomeVC.swift
//  maGmayApp
//
//  Created by ezz on 15/05/2025.
//

import UIKit
import Kingfisher
import ProgressHUD
import FSPagerView


protocol HomeVCDelegate: AnyObject {
    func didSwipeToProfile()
}

class HomeVC: UIViewController {

    @IBOutlet weak var requestMaintinceView: UIView!
    @IBOutlet weak var requestVisitUview: UIView!
//    @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var requestFirstCollectionView: UICollectionView!
    @IBOutlet weak var requestVistitsCollectionView: UICollectionView!
    @IBOutlet weak var loaderSliders: UIActivityIndicatorView!
//    @IBOutlet weak var pageControl: LocationPageControl!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var loaderMaintenanceRequests: UIActivityIndicatorView!

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pagerControl: FSPageControl!
    @IBOutlet weak var emptyStateVisitsReqLabel: UILabel!
    
    @IBOutlet weak var loaderVistisRequest: UIActivityIndicatorView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    
    
    //MARK: - vars
    var totalPage = 0
    var currentPage = 1
    var isLoading = true

    
    var totalPage2 = 0
    var currentPage2 = 1
    var isLoading2 = true
    
    var selectedIndex: Int = 0
    var timer: Timer?
    
    var currentAutoScrollIndex = 0
    
    weak var delegate: HomeVCDelegate?

    
    //MARK: - arrays
    var sliders : [SliderItem]  = []
    var maintenanceRequests : [MaintenanceRequest] = []
    var confirmedMaintenanceRequests : [MaintenanceRequest] = []
    var waitingMaintenanceRequests : [MaintenanceRequest] = []
    var canceledMaintenanceRequests : [MaintenanceRequest] = []
    var inProgressMaintenanceRequests : [MaintenanceRequest] = []
    var rejectedMaintenanceRequests : [MaintenanceRequest] = []
    var completedMaintenanceRequests : [MaintenanceRequest] = []
    var visitsRequests : [VisitRequest] = []
    
    //    var categories = ["المُعلقة","قيد التنفيذ","المكتملة","الملغاة"]
    let categoryTypes: [MaintenanceRequestsTypes] = [
        .waiting, .confirmed, .inProgress, .rejected, .completed
    ]

    lazy var categories = categoryTypes.map { $0.rawValue.loclize_ }


    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
        fetchData()
        localized()
    
    }
    
   
    @IBAction func ddiTapGoToNotifications(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "NotifcationsVC") as? NotifcationsVC
        vc?.push()
    }
    
    @IBAction func didTapGoToAllRequests(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "MaintenanceRequestsVC") as? MaintenanceRequestsVC
        vc?.push()
    }
    
    @IBAction func didToAllVisitsRequests(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "VisitRequestsVC") as? VisitRequestsVC
        vc?.push()
    }
    
    
    
}

extension HomeVC {
    func fetchData() {
        self.loaderSliders.isHidden = false
        self.loaderSliders.startAnimating()
  
        
        WebService.shared.sendRequest(url: Request.slider,
                                      method: .get,
                                      isAuth: true,
                                      responseType: SliderResponse.self) { result in
            switch result {
            case .success(let response):
                print(response.code)
                print(response.message)

                DispatchQueue.main.async {
                    self.sliders.removeAll()
                    
                    
                    for offer in response.data.offers {
                        self.sliders.append(.offer(offer))
                    }
                    
//                    for complex in response.data.complexes {
//                        self.sliders.append(.complex(complex))
//                    }
                    
                    // أضف صور المجمعات بشكل فردي
                    for complex in response.data.complexes {
                        for image in complex.images {
                            self.sliders.append(.complexImage(complex.name, image))
                        }
                    }
                    
                    self.pagerView.reloadData()
                    self.pagerControl.numberOfPages = self.sliders.count
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        if self.sliders.count > 0 {
//                            self.startAutoScroll()
//                        }
//                    }
                }
                self.loaderSliders.stopAnimating()
                self.loaderSliders.isHidden = true

            case .failure(let error):
                print(error.localizedDescription)
                self.loaderSliders.isHidden = true
                self.showErrorAlert()

            }
        }
        
        getMantanceRequests()
        getVisitsRequests()
        
        fetchUserData()
        
 
    }
    
    
    func fetchUserData(){
        
        
        
        WebService.shared.sendRequest(url: Request.getProfileData,
                                      method: .get,
                                      isAuth: true,
                                      responseType: ProfileResponse.self) { result in
            switch result {
            case .success(let success):
                let user = success.data
                self.helloLabel.text = "\("Hello".loclize_) \(user.name)"
                if let profilePic = user.profilePciture, !profilePic.isEmpty {
                    self.profileImage.kf.setImage(with: URL(string: "\(Request.baseUrl)\(profilePic)")!)
                }
//                self.nameLbl.text = user.
                
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
       
    }
    
    
    func setUpData(){
        
    }
    func localized(){
        
    }
    func setupView(){
        self.loaderSliders.isHidden = true
        self.loaderMaintenanceRequests.isHidden = true
        self.loaderSliders.hidesWhenStopped = true
        self.loaderVistisRequest.hidesWhenStopped = true
        self.loaderMaintenanceRequests.hidesWhenStopped = true
        self.loaderVistisRequest.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleMaintenanceRequestAdded), name: .maintenanceRequestAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleVisitRequestAdded), name: .visitRequestAdded, object: nil)

        setUpCollectionView()
        setShadowViews()
        setUpGestRecomigezrForViews()
        setupPagerView()
        
    }
}

extension HomeVC {
    
    @objc func handleMaintenanceRequestAdded(){
        self.maintenanceRequests.removeAll()
        self.confirmedMaintenanceRequests.removeAll()
        self.waitingMaintenanceRequests.removeAll()
        self.rejectedMaintenanceRequests.removeAll()
        self.inProgressMaintenanceRequests.removeAll()
        self.completedMaintenanceRequests.removeAll()
        getMantanceRequests()
        self.requestFirstCollectionView.delegate = self
    }
    
    @objc func handleVisitRequestAdded(){
        self.visitsRequests.removeAll()
        getVisitsRequests()
    }
    
    
    func getMantanceRequests(currentPage:Int = 1){
        self.emptyStateLabel.isHidden = true
        self.loaderMaintenanceRequests.startAnimating()
        self.loaderMaintenanceRequests.isHidden = false

        
        WebService.shared.sendRequest(
            url: Request.maintenanceRequests + "page=\(self.currentPage)&per_page=10",
            method: .get,
            isAuth: true,
            responseType: MaintenanceRequestsResponse.self) { result in
                switch result {
                case .success(let data):
                    let maintenanceRequests = data.data!.maintenanceRequests!
//                    print("COUNT =====\(maintenanceRequests.count)" )
//                    print(data.code)
//                    print(data.message)
//                    print(data.data!.meta!.currentPage)
//                    print(data.data!.meta!.totalPages)
                    self.currentPage = data.data!.meta!.currentPage!
                    self.totalPage   = data.data!.meta!.totalPages!
                    self.isLoading = false
                    for request in maintenanceRequests {
//                        print(request.title)
                        
                        if request.status == MaintenanceRequestsTypes.confirmed.rawValue {
                            self.confirmedMaintenanceRequests.append(request)
                        }else if request.status == MaintenanceRequestsTypes.waiting.rawValue {
                            self.waitingMaintenanceRequests.append(request)
                        }else if request.status == MaintenanceRequestsTypes.cancel.rawValue {
                            self.rejectedMaintenanceRequests.append(request)
                        }else if request.status == MaintenanceRequestsTypes.inProgress.rawValue {
                            self.inProgressMaintenanceRequests.append(request)
                        }else if request.status == MaintenanceRequestsTypes.completed.rawValue {
                            self.completedMaintenanceRequests.append(request)
                        }
                    }
                    // ✅ Set default displayed list and selected category
                    self.maintenanceRequests += self.waitingMaintenanceRequests
                    self.selectedIndex = 0
                    DispatchQueue.main.async {
                         self.loaderMaintenanceRequests.stopAnimating()
                         self.requestFirstCollectionView.isHidden = false
                         self.categoriesCollectionView.reloadData()
                         self.requestFirstCollectionView.reloadData()
                         self.updateEmptyStateView()
                     }

                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.loaderMaintenanceRequests.stopAnimating()
                        self.requestFirstCollectionView.isHidden = false
                        self.updateEmptyStateView()
//                        self.showErrorAlert()
                        ProgressHUD.failed(error.localizedDescription) // أو أي أداة عرض تنبيهات تستخدمها
                    }

                }
            }
    }
    
    
    func getVisitsRequests(currentPage:Int = 1){
        self.emptyStateVisitsReqLabel.isHidden = true
        self.loaderVistisRequest.startAnimating()
        self.loaderVistisRequest.isHidden = false
        
        WebService.shared.sendRequest(
            url: Request.visitRequests + "page=\(self.currentPage2)&per_page=10",
            method: .get,
            isAuth: true,
            responseType: VisitRequestsResponse.self) { result in
                switch result {
                case .success(let data):
                    let visitRequests = data.data.visitRequests
                    print(visitRequests.count)
                    print(data.code)
                    print(data.message)
                    self.currentPage2 = data.data.meta.currentPage!
                    self.totalPage2   = data.data.meta.totalPages!
                    self.isLoading2 = false
                    
                    self.visitsRequests += visitRequests

                    DispatchQueue.main.async {
                         self.loaderVistisRequest.stopAnimating()
                         self.requestVistitsCollectionView.isHidden = false
//                        self.loaderVistisRequest.isHidden = true
//                         self.categoriesCollectionView.reloadData()
                         self.requestVistitsCollectionView.reloadData()
                         self.updateEmptyStateForVisitReq()
                     }

                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.loaderVistisRequest.stopAnimating()
                        self.requestVistitsCollectionView.isHidden = false
                        self.updateEmptyStateForVisitReq()
                        self.showErrorAlert()
//                        ProgressHUD.failed("حصل خطأ في جلب ") // أو أي أداة عرض تنبيهات تستخدمها
                    }

                }
            }
        
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "mistake".loclize_,
            message: "An error occurred while loading data.\nPlease check your internet connection and try again.".loclize_,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry".loclize_, style: .default, handler: { _ in
            self.fetchData() // أو اسم دالة التحميل الخاصة بك
        }))
        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel))
        present(alert, animated: true)
    }

    
    func setUpCollectionView() {
//        offersCollectionView.delegate = self
//        offersCollectionView.dataSource = self
//        offersCollectionView.isPagingEnabled = true
//        offersCollectionView.showsHorizontalScrollIndicator = false
//
//        if let layout = offersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.minimumLineSpacing = 0
//            layout.sectionInset = .zero
//        }
//
//        pageControl.numberOfPages = sliders.count
//        
        //for categories Collection View
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self


        
        if let layout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 5
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        //request Collection View
        requestFirstCollectionView.delegate = self
        requestFirstCollectionView.dataSource = self
        requestFirstCollectionView.register(UINib(nibName: "RequestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestCollectionViewCell")
        
        if let layout = requestFirstCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
//            layout.minimumLineSpacing = 5
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            
            layout.minimumLineSpacing = 0
              layout.sectionInset = .zero
        }
        
        
        //request Collection View
        requestVistitsCollectionView.delegate = self
        requestVistitsCollectionView.dataSource = self
        requestVistitsCollectionView.register(UINib(nibName: "RequestVisitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestVisitCollectionViewCell")
        
        if let layout = requestVistitsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
              layout.sectionInset = .zero
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        loaderMaintenanceRequests.center = requestFirstCollectionView.center
        loaderMaintenanceRequests.hidesWhenStopped = true
        
        
        
        
    }
    
    func setupPagerView(){
    
        pagerView.delegate = self
        pagerView.dataSource = self
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerControl.contentHorizontalAlignment  = .center
        self.pagerView.automaticSlidingInterval = 3
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
//        let inset: CGFloat = 30 // adjust as needed
//        let width = pagerView.frame.width
//        let height = pagerView.frame.height
//        
//        self.pagerView.itemSize = CGSize(width: width + 15, height: height)
        self.pagerView.cornerRadius = 0

        pagerView.isInfinite = true
        pagerView.interitemSpacing = 0
//        self.pagerControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
//        self.pagerControl.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 45, height: 5), cornerRadius: 20), for: .selected)
//        self.pagerControl.itemSpacing = 20
//        self.pagerControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.pagerControl.setImage(UIImage(named:"pageCircle"), for: .normal)
        self.pagerControl.setImage(UIImage(named:"locationArrow"), for: .selected)
        self.pagerControl.itemSpacing = 20
    
    }
    
    func setShadowViews() {
         let views = [requestMaintinceView, requestVisitUview]
         views.forEach { view in
             view?.layer.shadowColor = UIColor.black.cgColor
             view?.layer.shadowOpacity = 0.1
             view?.layer.shadowOffset = CGSize(width: 0, height: 4)
             view?.layer.shadowRadius = 8
             view?.layer.cornerRadius = 20
             view?.layer.masksToBounds = false
         }
     }
    
    func setUpGestRecomigezrForViews(){
       let tapVisit = UITapGestureRecognizer(target: self, action: #selector(didTapRequestVisit))
       requestVisitUview.addGestureRecognizer(tapVisit)

       requestVisitUview.isUserInteractionEnabled = true
       
       
       let tapMaintince  = UITapGestureRecognizer(target: self, action: #selector(didTapRequestMaintince))
       
       requestMaintinceView.addGestureRecognizer(tapMaintince)
       requestMaintinceView.isUserInteractionEnabled = true
        
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(didTapGoProfilePage))
        profileImage.addGestureRecognizer(tapProfile)
        profileImage.isUserInteractionEnabled = true
        
        
        
   }
    
    func cancelMaintenanceRequest(id: Int) {
        ProgressHUD.progress("loading..".loclize_, 0)
        
        WebService.shared.sendRequest(
            url: "\(Request.maintenanceRequests2)/\(id)/cancel",
            params: [:],
            method: .put,
            isAuth: true,
            responseType: String.self
        ) { result in
            
            ProgressHUD.dismiss{
                self.maintenanceRequests.removeAll()
                self.waitingMaintenanceRequests.removeAll()
                self.getMantanceRequests()
            }
        }
        
    }
    
    func cancelVisitRequest(id: Int) {
        ProgressHUD.progress("loading..".loclize_, 0)
        
        WebService.shared.sendRequest(
            url: "\(Request.AddvisitRequests)/\(id)/cancel",
            params: [:],
            method: .put,
            isAuth: true,
            responseType: String.self
        ) { result in
            
            ProgressHUD.dismiss{
                self.visitsRequests.removeAll()
                self.getVisitsRequests()
            }
        }
    }
    

    
    //MARK: - TapGestureRecognizer for views...
    
    @objc func didTapRequestVisit(sender:UITapGestureRecognizer){
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "AddVisitRequestVC") as? AddVisitRequestVC
        vc?.push()
    }
    
    
    @objc func didTapRequestMaintince(sender : UITapGestureRecognizer){
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "AddMaintenanceRequestVC") as? AddMaintenanceRequestVC
        vc?.push()
    }
    
    @objc func didTapGoProfilePage(){
        delegate?.didSwipeToProfile()
    }
    
    func updateEmptyStateView(){
        emptyStateLabel.isHidden = !self.maintenanceRequests.isEmpty
    }
    
    func updateEmptyStateForVisitReq(){
        emptyStateVisitsReqLabel.isHidden = !self.visitsRequests.isEmpty

    }
}


    //MARK: - Enums
enum MaintenanceRequestsTypes : String {
//    ["waiting", "confirmed", "in_progress",  "rejected", "completed"]
    case waiting = "waiting"
    case confirmed = "confirmed"
    case cancel = "cancel"
    case inProgress = "in_progress"
    case rejected = "rejected"
    case completed = "completed"
}

enum SliderItem {
    case offer(OfferModel)
    case complexImage(String, ImageModel)
}



    //MARK: - CollectionViews

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
//        case self.offersCollectionView:
//            return sliders.count
        case categoriesCollectionView:
            return categories.count
        case requestFirstCollectionView :
            return maintenanceRequests.count
        case requestVistitsCollectionView:
            return visitsRequests.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCell.identifier, for: indexPath) as! StatusCell

            let item = categories[indexPath.row]
            cell.configure(text: item, selected: indexPath.item == selectedIndex)
            return cell
        case requestFirstCollectionView:
            let item = maintenanceRequests[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  RequestCollectionViewCell.identifier, for: indexPath) as! RequestCollectionViewCell
            cell.onCancelRequest = {
                self.cancelMaintenanceRequest(id: item.id!)
            }
            cell.configure(object: item)
            return cell
            
        case requestVistitsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestVisitCollectionViewCell", for: indexPath) as! RequestVisitCollectionViewCell
            let visit = visitsRequests[indexPath.item]
            cell.onCancelRequest = {
                self.cancelVisitRequest(id: visit.id)
            }
            cell.configure(with: visit)
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoriesCollectionView {
            selectedIndex = indexPath.item
            
            let selectedType = categoryTypes[indexPath.item]

            switch selectedType {
            case .waiting:
                maintenanceRequests = waitingMaintenanceRequests
            case .confirmed:
                maintenanceRequests = confirmedMaintenanceRequests
            case .inProgress:
                maintenanceRequests = inProgressMaintenanceRequests
            case .rejected:
                maintenanceRequests = rejectedMaintenanceRequests
            case .completed:
                maintenanceRequests = completedMaintenanceRequests
            default:
                maintenanceRequests = []
            }
            
            requestFirstCollectionView.reloadData()
            categoriesCollectionView.reloadData()
            self.updateEmptyStateView()
        } else if collectionView == self.requestFirstCollectionView {
            let selectedRequest = maintenanceRequests[indexPath.item]
            
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "MaintenanceRequestDetailsVC") as? MaintenanceRequestDetailsVC
            vc?.request = selectedRequest
            vc?.push()
        } else if collectionView == self.requestVistitsCollectionView {
            let selectedRequest = visitsRequests[indexPath.item]
            
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "VisitRequestDetailsVC") as? VisitRequestDetailsVC
            vc?.visitObj = selectedRequest
            vc?.push()
        }

    }
    
    

}

extension Notification.Name {
    static let maintenanceRequestAdded = Notification.Name("maintenanceRequestAdded")
    
    static let visitRequestAdded = Notification.Name("visitRequestAdded")
}


extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == offersCollectionView {
//            
//     
//        let width = collectionView.frame.width
//        let height = collectionView.frame.height
//        return CGSize(width: width, height: height)
//        }
         if collectionView == categoriesCollectionView {
            let text = categories[indexPath.item]
            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
            let textWidth = (text as NSString).size(withAttributes: [.font: font]).width + 32
            return CGSize(width: textWidth, height: 40)
        }else{
            let width = collectionView.frame.width
            _ = collectionView.frame.height
            return CGSize(width: width, height: 100)
        }
    }

     
}

extension HomeVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
//        currentAutoScrollIndex = page
//        currentIndex = page // لتحديث PageControl
//    
    
        if scrollView == self.requestFirstCollectionView {
            if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= (scrollView.contentSize.width)) {
                
                if !isLoading {
                    
                    if self.currentPage < self.totalPage {
                        self.currentPage += 1
                        self.getMantanceRequests(currentPage:  self.currentPage)
                        self.isLoading = true
                    }else{
                        print("stop")
                    }
                    
                }
            }
        }
        
        if scrollView == self.requestVistitsCollectionView {
            if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= (scrollView.contentSize.width)) {
                
                if !isLoading2 {
                    
                    if self.currentPage2 < self.totalPage2 {
                        self.currentPage2 += 1
                        self.getVisitsRequests(currentPage: self.currentPage2)
                        self.isLoading2 = true
                    }else{
                        print("stop")
                    }
                    
                }
            }
            
        }
    }
}
extension HomeVC : FSPagerViewDataSource , FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.sliders.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let placeholderImage = UIImage(named: "default-featured-image") // Add this image to your Assets

        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        //            let item = sliders[indexPath.row]
        switch sliders[index] {
        case .offer(let offer):
            
            cell.imageView?.contentMode = .scaleAspectFill
            if let url = URL(string: offer.imageUrl) {
                cell.imageView?.kf.setImage(
                    with: url,
                    placeholder: placeholderImage,
                    options: nil,
                    completionHandler: { result in
                        switch result {
                        case .success(let value):
                            print("Loaded image: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Image load failed: \(error.localizedDescription)")
                            cell.imageView?.image = placeholderImage
                        }
                    }
                )
            } else {
                cell.imageView?.image = placeholderImage
            }
            
            cell.textLabel?.text = offer.title
            cell.descriptionLabel?.text = offer.description
        case .complexImage(let complexName, let complex):
            
            cell.imageView?.contentMode = .scaleAspectFill
            if let url = URL(string: complex.imageUrl) {
                cell.imageView?.kf.setImage(
                    with: url,
                    placeholder: placeholderImage,
                    options: nil,
                    completionHandler: { result in
                        switch result {
                        case .success(let value):
                            print("Loaded image: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Image load failed: \(error.localizedDescription)")
                            cell.imageView?.image = placeholderImage
                        }
                    }
                )
            } else {
                cell.imageView?.image = placeholderImage
            }
            
            cell.textLabel?.text = complexName
        }

        
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        // all time in show or move to cell we need to update index for pager
        self.pagerControl.currentPage = index
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "OfferDetailsVC") as? OfferDetailsVC
        
        switch sliders[index] {
        case .offer(let offer):
            vc?.imageUrl = offer.imageUrl
            vc?.titleString = offer.title
            vc?.descriptionString = offer.description
        case .complexImage(let complexName, let complex):
            vc?.imageUrl = complex.imageUrl
            vc?.titleString = complexName
        }
        
        vc?.push()
    }
    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        let broswer = MWPhotoBrowser()
//        broswer.displayActionButton = true
//        broswer.displayNavArrows = false
//        broswer.displaySelectionButtons = false
//        broswer.zoomPhotosToFill = true
//        broswer.alwaysShowControls = false
//        broswer.enableGrid = true
//        broswer.startOnGrid = false
//        broswer.autoPlayOnAppear = true
//        broswer.setCurrentPhotoIndex(UInt(index))
//        broswer.delegate = self
//        broswer.push()
//        
//        
//    }
    
}
