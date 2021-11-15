import ModernRIBs
import Combine
import Foundation

protocol TransportHomeRouting: ViewableRouting {
    func attachTopup()
    func detachTopup()
}

protocol TransportHomePresentable: Presentable {
  var listener: TransportHomePresentableListener? { get set }
    func setSuperPayBalance(_ balance: String)
}

protocol TransportHomeListener: AnyObject {
  func transportHomeDidTapClose()
}

protocol TransportHomeInteractorDependency {
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class TransportHomeInteractor: PresentableInteractor<TransportHomePresentable>, TransportHomeInteractable, TransportHomePresentableListener {
  
  weak var router: TransportHomeRouting?
  weak var listener: TransportHomeListener?
  
    private var cancellable: Set<AnyCancellable>
    
    private let ridePrice: Double = 10000
    private let dependency: TransportHomeDependency
  
    init(presenter: TransportHomePresentable, dependency: TransportHomeDependency) {
        self.dependency = dependency
        self.cancellable = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.superPayRepository.balance
        .receive(on: DispatchQueue.main)
        .sink { [weak self] balance in
            if let text = Formatter.balanceFormatter.string(from: NSNumber(value: balance)) {
                self?.presenter.setSuperPayBalance(text)
            }
        }.store(in: &cancellable)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didTapBack() {
    listener?.transportHomeDidTapClose()
  }
    
    func didTapRideConfirm() {
        if dependency.superPayRepository.balance.value < ridePrice {
            router?.attachTopup()
        } else {
            
        }
    }
    
    func topupDidClose() {
        router?.detachTopup()
    }
    
    func topupDidFinish() {
        router?.detachTopup()
    }
}
