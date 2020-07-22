//
//  MainViewPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 17.05.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import Foundation

protocol BrickListView: class {
    func show( items: [MainItem])
}

final class MainViewPresenter {

    weak var view: BrickListView?

    init(view: BrickListView) {
        self.view = view
    }

    func fetchBricks() {

        let items = [MainItem(type: .bonus),
                     MainItem(type: .mood),
                     MainItem(type: .charts),
                     // TODO: friend
//                     MainItem(type: .friend),
                     MainItem(type: .achievments),
                     MainItem(type: .special)]

//        if let date = CoreDataManager.shared.fetchMoodTime() {
//            if Calendar.current.isDateInToday(date) {
//                items.remove(at: 1)
//            }
//        }
        view?.show(items: items)
    }

}
