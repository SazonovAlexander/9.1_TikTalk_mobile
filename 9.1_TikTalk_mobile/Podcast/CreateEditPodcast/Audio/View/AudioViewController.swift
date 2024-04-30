import UIKit
import AVFoundation
import RangeUISlider


final class AudioViewController: UIViewController {
    
    private lazy var cutterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.text = "Обрезка"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var cutterView: RangeUISlider = {
        let slider = RangeUISlider()
        slider.rangeSelectedColor = .white
        slider.leftKnobColor = .white
        slider.rightKnobColor = .white
        slider.rangeNotSelectedColor = .gray
        slider.rightKnobWidth = 10
        slider.leftKnobWidth = 10
        slider.barHeight = 10
        return slider
    }()
    
    private lazy var fileButton: UIButton = {
        let button = BaseButtonView()
        button.config(text: "Загрузить из файла", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        return button
    }()
    
    private lazy var recordButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Диктофон", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
        return button
    }()
    
    private var isRecording: Bool = false
    
    private lazy var player = Player()
    private lazy var playerView = PlayerView(player: player)
    
    private var audioRecorder: AVAudioRecorder?
    
    private var buffer: URL?  = nil {
        didSet {
            if let buffer {
                player.setAudioFromUrl(buffer)
            }
        }
    }
    
    private lazy var saveButton: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Сохранить", backgroundColor: UIColor(named: "ButtonGreen") ?? .green)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension AudioViewController {
    
    func setup() {
        player.playerView = playerView
        setupAppearance()
        addSubviews()
        activateConstraints()
        addActions()
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.title = "Аудио"
    }
    
    func addSubviews() {
        [cutterLabel,
        cutterView,
        fileButton,
        recordButton,
        playerView,
        saveButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            cutterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cutterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cutterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cutterLabel.heightAnchor.constraint(equalToConstant: 20),
            cutterView.topAnchor.constraint(equalTo: cutterLabel.bottomAnchor, constant: 30),
            cutterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cutterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cutterView.heightAnchor.constraint(equalToConstant: 30),
            fileButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            fileButton.topAnchor.constraint(equalTo: cutterView.bottomAnchor, constant: 30),
            recordButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recordButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            recordButton.topAnchor.constraint(equalTo: fileButton.bottomAnchor, constant: 20),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.topAnchor.constraint(greaterThanOrEqualTo: playerView.bottomAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            fileButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func addActions() {
        fileButton.addTarget(self, action: #selector(Self.didTapFileButton), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(Self.recording), for: .touchUpInside)
    }
    
    @objc
    func didTapFileButton() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.mp3"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc func recording() {
        if !isRecording {
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.record, mode: .default)
                try audioSession.setActive(true)
            } catch {
                print("Ошибка настройки аудиосессии: \(error.localizedDescription)")
            }
            
            self.recordButton.config(text: "Идет запись", backgroundColor:  UIColor(named: "ButtonRed") ?? .red)
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 48000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.isMeteringEnabled = true
                audioRecorder?.updateMeters()
                audioRecorder?.record()
            } catch {
                finishRecording(success: false)
            }
        } else {
            finishRecording(success: true)
        }
        isRecording.toggle()
    }

    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        if success {
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            buffer = audioFilename
        }
        recordButton.config(text: "Диктофон", backgroundColor: UIColor(named: "ButtonGray") ?? .gray)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


extension AudioViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension AudioViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        buffer = selectedFileURL
    }
}