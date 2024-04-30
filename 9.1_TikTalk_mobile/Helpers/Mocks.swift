import Foundation


struct Mocks {
    
    private static let authorId = UUID()
    private static let podcastId = UUID()
    private static let podcastId1 = UUID()
    private static let albumId = UUID()
    private static let profileId = UUID()
    
    static let podcast = PodcastModel(
        id: podcastId,
        name: "Смертные грехи",
        authorId: authorId,
        description: "Загробный мир Данте ближе, чем мы думаем. Как мы падаем в пучину хаоса, даже не осознавая этого.",
        albumId: albumId,
        logoUrl: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
        audioUrl: "https://www.mfiles.co.uk/mp3-downloads/frederic-chopin-piano-sonata-2-op35-3-funeral-march.mp3",
        countLike: 12421,
        isLiked: true
    )
    
    static let podcast1 = PodcastModel(
        id: podcastId1,
        name: "Воронеж",
        authorId: authorId,
        description: "Мои впечатления и сводка интереснех мест из 30 километрового похода по окрестностям города. Попробуйте угадать каких животных нам удалось встретить.",
        albumId: albumId,
        logoUrl: "https://img.freepik.com/free-photo/beautiful-kitten-with-colorful-clouds_23-2150752964.jpg?size=626&ext=jpg&ga=GA1.1.1127989224.1714388347&semt=ais",
        audioUrl: "https://drive.usercontent.google.com/u/0/uc?id=1H6WBaOQLgQsrYrWazeCAcypHBu6aFiVb&export=download",
        countLike: 3,
        isLiked: false
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
    
    static let author = AuthorModel(id: authorId, name: "GreenSlave", avatarUrl: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060", isSubscribe: false, albums: [albumId, albumId, albumId])
    
    static let album = AlbumModel(id: albumId, authorId: authorId, name: "Наша планета", description: "В наше время немалое внимание уделяется заботе о сохранении живой природы, вот и сегодня мне пришла в голову мысль высказать свое отношение к этому вопросу.", podcasts: [podcastId, podcastId, podcastId])
    
    static let profile = ProfileModel(
        id: profileId,
        name: "Сергей",
        avatarUrl: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st=1714386416~exp=1714390016~hmac=f12b0fc908b3809fd673437113008bef623f25e9026bcc191967899da985e9c4&w=1060",
        subscriptions: [authorId],
        liked: [podcastId, podcastId1, podcastId1, podcastId1],
        albums: [albumId, albumId]
    )
}
