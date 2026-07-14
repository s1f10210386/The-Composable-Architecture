//
//  CounterFeature.swift
//  The-Composable-Architecture
//
//  Created by 金澤帆高 on 2026/07/14.
//

import ComposableArchitecture
import SwiftUI

@Reducer
nonisolated struct CounterFeature {
  @ObservableState
  struct State: Equatable {
    var count = 0
    var numberFact: String?
    var isLoading = false
  }

  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case numberFactButtonTapped
    case numberFactResponse(String)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        state.numberFact = nil
        return .none

      case .incrementButtonTapped:
        state.count += 1
        state.numberFact = nil
        return .none

      case .numberFactButtonTapped:
        state.numberFact = nil
        state.isLoading = true
        return .run { [count = state.count] send in
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(count)_(number)")!)
          let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
          let fact = json?["extract"] as? String ?? "No fact found."
          await send(.numberFactResponse(fact))
        }

      case let .numberFactResponse(fact):
        state.numberFact = fact
        state.isLoading = false
        return .none
      }
    }
  }
}

struct CounterView: View {
  let store: StoreOf<CounterFeature>
  
  var body: some View {
    VStack {
      Text("\(store.count)")
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      HStack {
        Button("-") {
          store.send(.decrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
        
        Button("+") {
          store.send(.incrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      }
        Button("Number Fact") {
          store.send(.numberFactButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)

        if store.isLoading {
          ProgressView()
        } else if let numberFact = store.numberFact {
          Text(numberFact)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
        }
    }
  }
}

#Preview {
  CounterView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
    }
  )
}
