import Foundation
import UIKit

class StationInfoView: UIView {
        private let stationLabel = UILabel()
        private let coordinatesLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("should not be called")
        }
        
        private func setupViews() {
            stationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            stationLabel.numberOfLines = 0
            coordinatesLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            coordinatesLabel.numberOfLines = 0

            stationLabel.translatesAutoresizingMaskIntoConstraints = false
            coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(stationLabel)
            addSubview(coordinatesLabel)
        }
        
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                stationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                stationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                stationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                
                coordinatesLabel.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 10),
                coordinatesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                coordinatesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                coordinatesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
        }
        
        func configure(with viewModel: LocationInfoViewModel) {
            stationLabel.text = "Station: \(viewModel.station)"
            if let lat = viewModel.lat, let lon = viewModel.long {
                coordinatesLabel.text = "Latitude: \(lat), Longitude: \(lon)"
            }
        }
    }
