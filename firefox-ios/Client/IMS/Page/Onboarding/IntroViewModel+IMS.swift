// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import Shared
import Common


extension IntroViewModel {
    @_dynamicReplacement(for: setupViewControllerDelegates(with:for:))
    func ims_setupViewControllerDelegates(with delegate: OnboardingCardDelegate, for window: WindowUUID) {
        availableCards.removeAll()
        cardModels.forEach { cardModel in
            if cardModel.cardType == .multipleChoice {
            availableCards.append(OnboardingMultipleChoiceCardViewController(
                viewModel: cardModel,
                delegate: delegate,
                windowUUID: window))
            } else if cardModel.cardType == .imsBasic {
                availableCards.append(IMSOnboardingCardViewController(
                    viewModel: cardModel,
                    delegate: delegate,
                    windowUUID: window))
            } else {
                availableCards.append(OnboardingBasicCardViewController(
                    viewModel: cardModel,
                    delegate: delegate,
                    windowUUID: window))
            }
        }
    }
}
