//
//  SearchView.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/24/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = CityViewModel()
    @Binding var searchText: String
    @Binding var selectedCity: City?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        contentView
            .onDisappear {
                print("SearchView has disappeared")
            }
    }

    // MARK: - 콘텐츠 뷰
    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            searchBar
            if viewModel.filteredCities.isEmpty {
                EmptyStateView(message: "'\(viewModel.searchText)'에 대한 결과가 없습니다.")
            } else {
                cityList
            }
        }
        .frame(maxHeight: .infinity)
        .foregroundColor(Color.white)
        .background(Color(red: 86 / 255, green: 132 / 255, blue: 172 / 255))
    }

    // MARK: - 검색 바
    @ViewBuilder
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(8)
        }
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
    
    // MARK: - 도시 리스트
    @ViewBuilder
    private var cityList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.filteredCities) { city in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.headline)
                            Text(city.country)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color(red: 86 / 255, green: 132 / 255, blue: 172 / 255))
                    .onTapGesture {
                        handleCitySelection(city)
                    }
                    
                    Divider()
                        .frame(height: 0.5)
                        .background(Color.white)
                }
                
                if viewModel.cities.count < viewModel.filteredResults.count {
                    ProgressView()
                        .onAppear {
                            viewModel.loadMoreCities()
                        }.padding()
                }
            }
            .padding(.horizontal)
        }.scrollDismissesKeyboard(.immediately)
    }

    // MARK: - 도시 선택 핸들러
    private func handleCitySelection(_ city: City) {
        selectedCity = city
        searchText = city.name
        presentationMode.wrappedValue.dismiss()
    }

}
