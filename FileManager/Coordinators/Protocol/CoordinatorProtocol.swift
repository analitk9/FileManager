//
//  CoordinatorProtocol.swift
//  FileManager
//
//  Created by Denis Evdokimov on 5/4/22.
//

protocol Coordinator: AnyObject {
    func start()
}

protocol FinishingCoordinator: Coordinator {
    var onFinish: (() -> Void)? { get set }
}
