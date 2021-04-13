//
//  HistoryHistoryViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Lottie
import SharedFilesModule
import UIKit

class HistoryViewController: UIViewController {
    var output: HistoryViewOutput!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var fullLoadingView: UIView!
    @IBOutlet weak var fullLoadingLoaderContainer: UIView!
    @IBOutlet weak var fullLoadingLabel: UILabel!
    @IBOutlet weak var emptyIconImage: UIImageView!
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySubtitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var interactiveHeaderView: InteractiveHeaderView!
    
    private var loader = AnimationView()
    private let refreshControl = UIRefreshControl()
    weak var loaderCell: LoaderFooterCell?

    let topConstraintRange = (CGFloat(ContainerOffsetsConstant.topOffset)..<CGFloat(ContainerOffsetsConstant.boottomOffset))
    var topOffset: CGFloat = ContainerOffsetsConstant.boottomOffset
    var oldContentOffset = CGPoint.zero
    var emptyLoader = AnimationView()
    let cellHeight: CGFloat = 62
    var shoudShowLoadingCell = false
    var isLoading = false
    var responce: PagedResponse<EthHistoryModel>?
    private let gradientHeight: CGFloat = 20
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setFullLoadingStateState()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loader.play()
        loaderCell?.refreshLoader()
        emptyLoader.play()
    }
    
    // MARK: Configuration
    
    private func config() {
        configBackground()
        configColors()
        configFonts()
        configLocalization()
        configEmptyLoader()
        configRefreshControl()
        configTableView()
        configTopGradientView()
        configBottomGradientView()
        configInteractiveView()
    }
    
    private func configColors() {
        emptyTitle.textColor = R.color.dark()
        emptySubtitle.textColor = R.color.gray1()
        fullLoadingLabel.textColor = R.color.gray1()
    }
    
    private func configEmptyLoader() {
        if let bundle = Bundle(identifier: Constants.bundleIdentifier) {
            let animation = Animation.named(Constants.LottieConstants.grayLoader,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: nil)
            
            emptyLoader.animation = animation
        }
        fullLoadingLoaderContainer.addSubview(emptyLoader)
        emptyLoader.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(fullLoadingLoaderContainer)
        }
        emptyLoader.contentMode = .scaleAspectFit
        emptyLoader.loopMode = .loop
    }
    
    private func configRefreshControl() {
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(actionRefreshHistory(_:)), for: .valueChanged)
        
        let animationView = loader
        refreshControl.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.bottom.equalTo(refreshControl)
            make.centerX.equalTo(refreshControl)
            make.width.equalTo(30)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        if let bundle = Bundle(identifier: Constants.bundleIdentifier) {
            let animation = Animation.named(Constants.LottieConstants.grayLoader,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: nil)
            animationView.animation = animation
        }
        animationView.play()
    }
    
    private func configLocalization() {
        interactiveHeaderView.title = R.string.localization.mainFlowHistoryTitle()
        emptyTitle.text = R.string.localization.mainFlowHistoryNoTxTitle()
        emptySubtitle.text = R.string.localization.mainFlowHistoryNoTxSubtitle()
        fullLoadingLabel.text = R.string.localization.mainFlowHistoryLoadingTitle()
    }
    
    private func configFonts() {
        emptyTitle.font = R.font.poppinsMedium(size: 22)
        emptySubtitle.font = R.font.poppinsMedium(size: 16)
        fullLoadingLabel.font = R.font.poppinsRegular(size: 16)
    }
    
    private func configBackground() {
        backgroundView.layer.cornerRadius = 24
        backgroundView.backgroundColor = R.color.gray2()
        emptyView.backgroundColor = R.color.gray2()
        shadowView.layer.shadowColor = R.color.gray2()?.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.masksToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: backgroundView.bounds,
            cornerRadius: 25
            ).cgPath
    }
    
    private func configTableView() {
        tableView.register(R.nib.loaderFooterCell)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = cellHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = cellHeight
    }

    private func configTopGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = topGradientView.bounds
        topGradientView.layer.mask = gradient
        topGradientView.alpha = 0
    }

    private func configBottomGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = bottomGradientView.bounds
        bottomGradientView.layer.mask = gradient
    }
    
    private func configInteractiveView() {
        interactiveHeaderView.onTap = { [weak self] in
            self?.output.presentCurrencySnackBar()
        }
    }
    
    // MARK: Config Cell
    
    private func configCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let model = responce?.data[safe: indexPath.row]  else {
            return UITableViewCell()
        }
        
        guard let cell = configCell(tableView: tableView, indexPath: indexPath, model: model)  else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    private func configCell(tableView: UITableView, indexPath: IndexPath, model: EthHistoryModel) -> UITableViewCell? {
        if model.isReceiving {
            return configReceiveCell(tableView: tableView, indexPath: indexPath, model: model)
        } else {
            return configSendCell(tableView: tableView, indexPath: indexPath, model: model)
        }
    }
    
    private func configSendCell(tableView: UITableView, indexPath: IndexPath, model: EthHistoryModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.universalHistoryCellIdentifire,
                                                       for: indexPath) else {
                                                        return nil
        }
        
        cell.mainTextLabel.text = R.string.localization.historyListScreenSend()
        cell.valueLabel.attributedText = model.amountFormatted
        cell.dateLabel.text = model.date
        cell.typeImage.image = R.image.send()
        cell.rateLabel.text = model.rate
        
        return cell
    }
    
    private func configReceiveCell(tableView: UITableView, indexPath: IndexPath, model: EthHistoryModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.universalHistoryCellIdentifire,
                                                       for: indexPath) else {
                                                        return nil
        }

        cell.mainTextLabel.text = R.string.localization.historyListScreenReceived()
        cell.valueLabel.attributedText = model.amountFormatted
        cell.dateLabel.text = model.date
        cell.typeImage.image = R.image.receive()
        cell.rateLabel.text = model.rate
        
        return cell
    }
    
    // MARK: – Private
    
    private func isLoadingIndex(index: IndexPath) -> Bool {
        if shoudShowLoadingCell {
            let numberOfStorageObjects = responce?.data.count ?? 0
            return numberOfStorageObjects == index.row && index.row != 0
        }
        
        return false
    }
    
    private func updateHistory(response: PagedResponse<EthHistoryModel>) {
        tableView.isHidden = false
        
        self.responce = response
        
        if responce?.isFull == true {
            shoudShowLoadingCell = false
        } else {
            shoudShowLoadingCell = true
        }
        isLoading = false
        tableView.reloadData()
        if refreshControl.isRefreshing == true {
             DispatchQueue.main.async {
                 self.refreshControl.endRefreshing()
             }
         }
    }
    
    // MARK: Actions
    
    @IBAction func actionRetry(_ sender: Any) {
        output.actionRetryLoadHistory()
    }
    
    @objc
    private func actionRefreshHistory(_ sender: Any) {
        loader.play()
        output.refreshHistory()
    }
}

//swiftlint:enable type_body_length

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfStorageObjects = responce?.data.count ?? 0
        return (shoudShowLoadingCell && numberOfStorageObjects > 0) ? numberOfStorageObjects + 1 : numberOfStorageObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndex(index: indexPath) {
            let cell: LoaderFooterCell! = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.loaderFooterCell, for: indexPath)
            loaderCell = cell
            return cell
        } else {
            return configCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard tableView.cellForRow(at: indexPath) is HostoryItemCell else {
            return
        }
        guard let responce = responce else {
            return
        }
        output.actionSelectTransaction(item: responce.data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let responce = responce else {
            return
        }
        
        guard responce.isFull == false else {
            return
        }
        
        guard isLoading == false else {
            return
        }
        
        if let _ = cell as? LoaderFooterCell, isLoadingIndex(index: indexPath) {
            isLoading = true
            output.loadMoreHistory()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        //we compress the top view
        if delta > 0 && topOffset > topConstraintRange.lowerBound && scrollView.contentOffset.y > 0 {
            let value = topOffset - delta
            scrollView.contentOffset.y -= delta
            //coz of refresh controll we need to prevent scrolling if content size is less then table view height
            if tableView.contentSize.height > tableView.frame.height {
                output.offsetDidChangeAction(offset: value)
            }
        }
        
        //we expand the top view
        if delta < 0 && topOffset < topConstraintRange.upperBound && scrollView.contentOffset.y < 0 {
            let value = topOffset - delta
            scrollView.contentOffset.y -= delta
            output.offsetDidChangeAction(offset: value)
        }
        
        oldContentOffset = scrollView.contentOffset

        let bottomOffset = tableView.contentOffset.y + tableView.frame.height
        let diff = tableView.contentSize.height - bottomOffset

        topGradientView.alpha = tableView.contentOffset.y / gradientHeight
        bottomGradientView.alpha = diff / gradientHeight
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        output.actionEndDragging()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        output.actionEndDragging()
    }
}

// MARK: - HistoryViewInput

extension HistoryViewController: HistoryViewInput {
    func setupViewInsets(insets: CGFloat) {
        tableView.contentInset = UIEdgeInsets(top: insets, left: 0, bottom: 0, right: 0)
    }
    
    func setupTopOffset(offset: CGFloat) {
        topOffset = offset
    }
    
    func setEmptyState(shouldHideHeader: Bool) {
        emptyView.isHidden = false
        tableView.isHidden = true
        interactiveHeaderView.isHidden = shouldHideHeader
        fullLoadingView.isHidden = true
    }
    
    func setFillState() {
        emptyView.isHidden = true
        tableView.isHidden = false
        interactiveHeaderView.isHidden = false
        fullLoadingView.isHidden = true
    }
    
    func setFullLoadingStateState() {
        emptyView.isHidden = true
        tableView.isHidden = true
        interactiveHeaderView.isHidden = true
        fullLoadingView.isHidden = false
        emptyLoader.play()
    }
    
    func setupState(state: HistoryState) {
        switch state {
        case .loading:
            setFullLoadingStateState()
            
        case .errorLoading:
            setEmptyState(shouldHideHeader: false)
            
        case .empty(let shouldHideHeader):
            setEmptyState(shouldHideHeader: shouldHideHeader)
            
        case .loaded(let responce):
            setFillState()
            updateHistory(response: responce)
        }
    }
    
    func setupNewTransactions(responce: PagedResponse<EthHistoryModel>) {
        setFillState()
        
        if var currentResponce = self.responce {
            for transaction in responce.data {
                currentResponce.data.insert(transaction, at: 0)
            }
            self.responce = currentResponce
        } else {
            self.responce = responce
        }
        
        var indexPaths = [IndexPath]()
        for index in 0..<responce.data.count {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        
        tableView.reloadData()
    }
    
    func setupHeaderState(hasToken: Bool) {
        if !hasToken {
            interactiveHeaderView.setHeaderState()
        }
    }
    
    func setupInteractiveState(state: WalletTokenState) {
        interactiveHeaderView.setDefaultState()
        switch state {
        case .currency:
            interactiveHeaderView.title = R.string.localization.mainFlowHistoryTitleEth()
            
        case .token:
            interactiveHeaderView.title = R.string.localization.mainFlowHistoryTitleToken()
            
        case .onlyCurrency:
            interactiveHeaderView.title = R.string.localization.mainFlowHistoryTitle()
        }
    }
}
