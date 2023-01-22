//
//  ViewController.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import SwiftUI
import AVKit
import AVFoundation

private let reuseId = "reuseId"
private let headerId = "headerId"

class AnimeController: UICollectionViewController {
    //MARK: - Properties
    static let categoryHeader = "catHeader"
    
    private var searchResults = [Anime]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var imagePicker: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        controller.mediaTypes = [UTType.image.identifier]
        return controller
    }()
    
    //MARK: - Init
    init() {
        super.init(collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
            if sectionIndex == 0 {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(175)))
                item.contentInsets.top = 8
                item.contentInsets.leading = 8
                item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(175)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: AnimeController.categoryHeader, alignment: .topLeading)]
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(375)))
                item.contentInsets.top = 8
                item.contentInsets.leading = 8
                item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(375)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: AnimeController.categoryHeader, alignment: .topLeading)]
                return section
            }
        }))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        configureNavBar()
        fetchAnimeData()
    }
    
    
    //MARK: - Helpers
    private func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.2636647839, green: 0.6329405436, blue: 0.89, alpha: 1).withAlphaComponent(0.87)
        
        let nav = navigationController?.navigationBar
        nav?.barStyle = .black
        navigationItem.title = "Anime Tracer"
        nav?.standardAppearance = appearance
        nav?.compactAppearance = appearance
        nav?.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "sparkle.magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(searchButtonTapped)), UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handlePresentImagePicker))]
    }
    
    private func configureCV() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: AnimeController.categoryHeader, withReuseIdentifier: headerId)
        collectionView.backgroundColor = UIColor(patternImage: (UIImage(named: "background")?.withRenderingMode(.alwaysOriginal))!)
    }

    private func fetchAnimeData() {
        Service.shared.fetchData(withImageUrl: "https://images.plurk.com/32B15UXxymfSMwKGTObY5e.jpg") { result in
            switch result {
            case .success(let moe):
                DispatchQueue.main.async {
                    self.searchResults = moe.result
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //MARK: - Selectors
    @objc private func searchButtonTapped() {
        
    }
    
    @objc private func handlePresentImagePicker() {
        present(imagePicker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate
extension AnimeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
    }
}

//MARK: - CollectionView Methods
extension AnimeController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        view.headerOption = HeaderOptions(rawValue: indexPath.section)
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! ImageCell
        cell.anime = searchResults[indexPath.item]
        //cell.backgroundColor = .systemGroupedBackground
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.systemGreen.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 6
        cell.clipsToBounds = true
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResults.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - SwiftUI PreviewProvider
struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable{
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: AnimeController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
        typealias UIViewControllerType = UIViewController
    }
}

struct ContentView: View{
    var body: some View{
        Text("Hello World")
    }
}


