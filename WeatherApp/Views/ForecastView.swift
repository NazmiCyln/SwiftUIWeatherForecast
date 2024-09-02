//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Nazmi Ceylan on 2.09.2024.
//

import SDWebImageSwiftUI
import SwiftUI

struct ForecastView: View {
    @StateObject private var viewModel = ForecastListViewModel()

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Picker("Title", selection: $viewModel.systen) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(.palette)
                    .frame(width: 100)
                    .padding(.bottom)

                    HStack {
                        TextField("Enter Location", text: $viewModel.location, onCommit: {
                            viewModel.getWeatherForecast()
                        })
                        .textFieldStyle(.roundedBorder)
                        .overlay (
                            Button(
                                action: {
                                    viewModel.location = ""
                                    viewModel.getWeatherForecast()
                                },
                                label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.gray)
                                }
                            )
                            .padding(.horizontal),
                        alignment: .trailing
                        )

                        Button(
                            action: {
                                viewModel.getWeatherForecast()
                            },
                            label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.title)
                            }
                        )
                    }


                    List(viewModel.forecasts, id: \.day) { day in

                        VStack(alignment: .leading) {
                            Text(day.day)
                                .fontWeight(.bold)

                            HStack(alignment: .center){
                                WebImage(url: day.weatherIconUrl)
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFit()
                                    .frame(width: 75)

                                VStack(alignment: .leading){
                                    Text(day.overview)
                                        .font(.title2)
                                    HStack {
                                        Text(day.high)
                                        Text(day.low)
                                    }

                                    HStack {
                                        Text(day.clouds)
                                        Text(day.pop)
                                    }

                                    Text(day.humidity)
                                }
                            }
                        }


                    }
                    .listStyle(.plain)

                }
                .padding()
                .navigationTitle("Weather")
                .alert("Error", isPresented: $viewModel.isError) {
                    Button("OK") {}
                } message: {
                    Text("\($viewModel.appError.wrappedValue?.errorString ?? "")")
                }

            }
            if viewModel.isLoading {
                ZStack {
                    Color(.white)
                        .opacity(0.3)
                        .ignoresSafeArea()

                    ProgressView("Fetching Weather")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: 10)
                }
            }
        }
    }
}

#Preview {
    ForecastView()
}
