import UIKit


final class CreateEditPodcastRouter {
    
    func showSelectAlbumFrom(_ viewController: UIViewController, selectedAlbum: AlbumModel? = nil, completion: @escaping (AlbumModel) -> Void) {
        let presenter = AlbumsPresenter(selectedAlbum: selectedAlbum, completion: completion)
        let selectAlbum = AlbumsViewController(presenter: presenter)
        presenter.viewController = selectAlbum
        viewController.navigationController?.pushViewController(selectAlbum, animated: true)
    }
    
    func showSelectAudioFrom(_ viewController: UIViewController, completion: @escaping  (URL) -> Void) {
        let audioViewController = AudioViewController()
        audioViewController.completion = completion
        viewController.navigationController?.pushViewController(audioViewController, animated: true)
    }
}
