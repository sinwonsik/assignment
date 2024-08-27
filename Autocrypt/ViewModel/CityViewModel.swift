//
//  CityViewModel.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/24/24.
//

import Foundation
import Combine

class CityViewModel: ObservableObject {
    
    // MARK: - Published 프로퍼티
    @Published var cities: [City] = []
    @Published var searchText: String = ""
    
    // MARK: - 내부에서 사용하는 프로퍼티
    private var cancellables = Set<AnyCancellable>()
    private let batchSize = 10

    // 모든 도시 데이터를 저장하는 배열
    private var allCities: [City] = [] {
        didSet {
            updateFilteredResults()
        }
    }

    // 필터링된 도시 결과를 저장하는 배열
    var filteredResults: [City] = []

    // 필터링된 도시 목록을 반환하는 프로퍼티
    var filteredCities: [City] {
        return cities
    }

    // MARK: - 초기화 메서드
    init() {
        loadCities()
        setupSearchTextDebounce()
    }
    
    // MARK: - 데이터 로드 메서드
    
    // JSON 파일에서 도시 데이터를 로드하는 메서드
    func loadCities() {
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
            print("City list JSON 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.allCities = try decoder.decode([City].self, from: data)
            self.filteredResults = self.allCities
            loadMoreCities()
        } catch {
            print("도시 데이터를 로드하는 중 오류 발생: \(error)")
        }
    }

    // 더 많은 도시 데이터를 로드하는 메서드
    func loadMoreCities() {
        guard cities.count < filteredResults.count else { return }

        let nextBatch = filteredResults[cities.count..<min(cities.count + batchSize, filteredResults.count)]
        cities.append(contentsOf: nextBatch)
    }

    // MARK: - 검색어 처리 메서드
    
    // 검색어 입력이 변경될 때 호출되는 메서드
    private func setupSearchTextDebounce() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.updateFilteredResults()
            }
            .store(in: &cancellables)
    }

    // 필터링된 도시 결과를 업데이트하는 메서드
    private func updateFilteredResults() {
        guard !searchText.isEmpty else {
            filteredResults = allCities
            loadMoreCities()
            return
        }
        
        filteredResults = allCities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        cities.removeAll()
        loadMoreCities()
    }
}
