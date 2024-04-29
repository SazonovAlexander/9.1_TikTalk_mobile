import Foundation


struct Mocks {
    
    private static let authorId = UUID()
    private static let podcastId = UUID()
    private static let albumId = UUID()
    
    static let podcast = PodcastModel(
        id: podcastId,
        name: "1232432",
        authorId: authorId,
        description: "12312312321",
        albumId: albumId,
        logoUrl: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
        audioUrl: "https://www.mfiles.co.uk/mp3-downloads/frederic-chopin-piano-sonata-2-op35-3-funeral-march.mp3",
        countLike: 12421,
        isLiked: true
    )
    
    static let themes = [
        "Тема 1",
        "Тема 2",
        "Тема 3",
        "Тема 4",
        "Тема 5",
        "Тема 6",
        "Тема 7",
        "Тема 8",
    ]
    
    static let author = AuthorModel(id: authorId, name: "Алексей Петрович", avatarUrl: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060", isSubscribe: false, albums: [albumId, albumId, albumId])
    
    static let album = AlbumModel(id: albumId, authorId: authorId, name: "12421432432", description: "1231231221312", podcasts: [podcastId, podcastId, podcastId])
}
