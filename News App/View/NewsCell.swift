//
//  NewsCell.swift
//  News App
//
//  Created by Erick El nino on 2022/11/14.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

struct NewsCellModel
{
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(viewModel: Article) {
        self.title = viewModel.title ?? ""
        self.subtitle = viewModel.description ?? ""
        self.imageURL = URL(string: viewModel.urlToImage ?? "")
    }
}

class NewsCell: UITableViewCell
{

    
    static let cell_ID = "UITableViewCell"
    
    private let newtitleLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    
    
    private let newsSubtitleLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 10
        return label
    }()
    
    private let newsImage: UIImageView =
    {
        let myImage = UIImageView()
        myImage.translatesAutoresizingMaskIntoConstraints = false
        myImage.clipsToBounds = true
        myImage.contentMode = .scaleAspectFill
        myImage.backgroundColor = .systemGray
        myImage.layer.cornerRadius = 5
        return myImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addtoSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addtoSubview()
    {
        let stack = UIStackView(arrangedSubviews: [newtitleLabel,newsSubtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
       
        contentView.addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stack.widthAnchor.constraint(equalToConstant: contentView.frame.width - 100).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 145).isActive = true
        
        contentView.addSubview(newsImage)
        newsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        newsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -5).isActive = true
        newsImage.leadingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 5).isActive = true
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newtitleLabel.text = nil
        newsSubtitleLabel.text = nil
        newsImage.image = nil
    }
    
    
    
    func configureCell(viewModel: NewsCellModel)
    {
        newtitleLabel.text = viewModel.title
        newsSubtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData
        {
            newsImage.image = UIImage(data: data)
        }else if let url = viewModel.imageURL
        {
            URLSession.shared.dataTask(with: url) { [weak self] (Data, _, Error) in
                guard let data = Data , Error == nil else { return }
                
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
                
            }.resume()
            
        }
    }
    
}
