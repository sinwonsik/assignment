//
//  MainView.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import SwiftUI
import MapKit
import Combine

struct MainView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showSearchView = false
    @State private var searchText: String = ""
    @State private var selectedCity: City? = nil

    var body: some View {
        contentView
            .onAppear {
                if selectedCity == nil {
                    if let location = locationManager.location {
                        viewModel.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    } else {
                        viewModel.fetchWeather(lat: viewModel.fixedLatitude, lon: viewModel.fixedLongitude)
                    }
                }
            }
            .onChange(of: selectedCity) { newCity in
                if let newCity = newCity {
                    viewModel.fetchWeather(lat: newCity.coord.lat, lon: newCity.coord.lon)
                }
            }
            .fullScreenCover(isPresented: $showSearchView) {
                SearchView(searchText: $searchText, selectedCity: $selectedCity)
            }
    }
    
    // MARK: - 콘텐츠 뷰
    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                searchBar
                if let weather = viewModel.weather {
                    currentWeatherSection
                    hourlyForecastSection(weather: weather)
                    dailyForecastSection(weather: weather)
                    mapSection
                    additionalInfoSection(weather: weather)
                } else {
                    Text("Loading weather data...")
                }
            }
            .padding(.top)
        }
        .foregroundColor(Color.white)
        .background(Color(red: 0.5, green: 0.7, blue: 0.9).edgesIgnoringSafeArea(.all))
    }

    // MARK: - 검색 바
    @ViewBuilder
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                if isEditing {
                    KeyboardHelpers.hideKeyboard()
                    withAnimation {
                        showSearchView = true
                    }
                }
            })
            .textFieldStyle(PlainTextFieldStyle())
            .padding(8)
        }
        .background(Color.white.opacity(0.3))
        .cornerRadius(10)
        .padding()
    }

    // MARK: - 현재 날씨 섹션
    @ViewBuilder
    private var currentWeatherSection: some View {
        VStack(spacing: 8) {
            Text(selectedCity?.name ?? locationManager.locality ?? "Loading...")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.currentTemperature)
                .font(.system(size: 72))
                .fontWeight(.bold)
            Text(viewModel.currentWeatherDescription)
                .font(.title)
            
            Text("최고: \(viewModel.maxTemperature) | 최저: \(viewModel.minTemperature)")
                .font(.body)
        }
    }

    // MARK: - 시간별 예보 섹션
    @ViewBuilder
    private func hourlyForecastSection(weather: WeatherResponse) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("돌풍의 풍속은 최대 \(Int(weather.current.wind_speed)) m/s입니다.")
                .font(.headline)
                .padding()

            Divider()
                .frame(height: 0.5)
                .background(Color.white)
                .padding(.horizontal, 15)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.filteredHourlyWeather, id: \.dt) { hour in
                        VStack {
                            Text(Date(timeIntervalSince1970: TimeInterval(hour.dt)).toAmPmTime())
                                .font(.system(size: 16))
                            WeatherIconView(iconName: hour.weather.first?.localIconName())
                            Text("\(Int(hour.temp))°")
                                .font(.system(size: 22))
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(red: 78/255, green: 117/255, blue: 175/255))
        .cornerRadius(20)
        .padding()
    }

    // MARK: - 일별 예보 섹션
    @ViewBuilder
    private func dailyForecastSection(weather: WeatherResponse) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("5일간의 일기예보")
                .font(.footnote)
                .padding(.bottom, 15)

            ForEach(weather.daily.prefix(5), id: \.dt) { day in
                HStack {
                    Text(Date(timeIntervalSince1970: TimeInterval(day.dt)).toDayOfWeek())
                        .frame(width: 40, alignment: .leading)
                    Spacer()
                    WeatherIconView(iconName: day.weather.first?.localIconName())
                    Spacer()
                    Text("최소: \(day.temp.minInt)°")
                        .font(.body)
                    +
                    Text("  최대: \(day.temp.maxInt)°")
                        .font(.body.weight(.bold))
                }
                .background(Divider().background(Color.white), alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top)
        .background(Color(red: 78/255, green: 117/255, blue: 175/255))
        .cornerRadius(20)
        .padding([.leading, .trailing])
    }

    // MARK: - 지도 섹션
    @ViewBuilder
    private var mapSection: some View {
        VStack(alignment: .leading) {
            Text("강수량")
                .font(.headline)
                .padding(.leading)

            if let selectedCity = selectedCity {
                MapView(latitude: selectedCity.coord.lat, longitude: selectedCity.coord.lon, temperature: viewModel.currentTemperature)
                    .frame(height: 300)
                    .cornerRadius(20)
                    .padding([.leading, .trailing])
            } else if let location = locationManager.location {
                MapView(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, temperature: viewModel.currentTemperature)
                    .frame(height: 300)
                    .cornerRadius(20)
                    .padding([.leading, .trailing])
            } else {
                Text("위치를 가져오는 중입니다...")
                    .font(.caption)
                    .padding()
            }
        }
    }

    // MARK: - 추가 정보 섹션
    @ViewBuilder
    private func additionalInfoSection(weather: WeatherResponse) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                CustomRoundedRectangle(title: "습도", value: "\(weather.current.humidity)%")
                CustomRoundedRectangle(title: "구름", value: "\(weather.current.clouds)%")
            }
            .frame(height: 150)
            
            HStack(spacing: 16) {
                CustomRoundedRectangle(title: "바람 속도", value: "\(weather.current.wind_speed) m/s", unit: "강풍: \(weather.current.wind_speed)m/s")
                CustomRoundedRectangle(title: "기압", value: "\(weather.current.pressure) hPa", unit: "hPa")
            }
            .frame(height: 150)
        }
        .padding([.leading, .trailing])
    }
}

