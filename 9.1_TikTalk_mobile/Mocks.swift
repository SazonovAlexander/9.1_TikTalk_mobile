import Foundation


struct Mocks {
    
    static let podcast = PodcastModel(
        id: UUID(),
        name: "1232432",
        authorId: UUID(),
        description: "12312312321",
        albumId: UUID(),
        logoUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fru.freepik.com%2Fphotos%2F%25D0%25BA%25D1%2580%25D0%25B0%25D1%2581%25D0%25B8%25D0%25B2%25D1%258B%25D0%25B5-%25D0%25BA%25D0%25B0%25D1%2580%25D1%2582%25D0%25B8%25D0%25BD%25D0%25BA%25D0%25B8&psig=AOvVaw2BcdUWw14Um6MAk-MEfPb-&ust=1714422510735000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCMjBo9ff5YUDFQAAAAAdAAAAABAE",
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
    
}
