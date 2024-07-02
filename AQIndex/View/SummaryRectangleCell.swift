import UIKit

class SummaryRectangleCell: UITableViewCell {

    static let reuseIdentifier = "SummaryRectangleCell"
    
    private let rectangleView = SummaryRectangleView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("should not be called")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(rectangleView)
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            rectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            rectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rectangleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(with viewModel: DaySummaryViewModel) {
        rectangleView.configure(with: viewModel)
    }
}

class SummaryRectangleView: UIView {
    
    private struct Constants {
        static let pm25prefix = "pm25: "
    }
    
    private let numberLabel = UILabel()
    private let dateLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberLabel)
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
                
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
        
    func configure(with viewModel: DaySummaryViewModel) {
        numberLabel.text = SummaryRectangleView.Constants.pm25prefix + viewModel.pm25
        dateLabel.text = viewModel.date
        dateLabel.textColor = viewModel.styling.textColor

        backgroundColor = viewModel.styling.backgroundColor
        numberLabel.textColor = viewModel.styling.textColor
        let icon = UIImage(systemName: viewModel.styling.iconName)
        iconImageView.tintColor = viewModel.styling.textColor
        iconImageView.image = icon
    }
}
