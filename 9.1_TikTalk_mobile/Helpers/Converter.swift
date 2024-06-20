import AVFoundation

final class AVAudioFileConverter {

  var rwAudioSerializationQueue: DispatchQueue!
  var asset:AVAsset!
  var assetReader:AVAssetReader!
  var assetReaderAudioOutput:AVAssetReaderTrackOutput!
  var assetWriter:AVAssetWriter!
  var assetWriterAudioInput:AVAssetWriterInput!
  var outputURL:URL
  var inputURL:URL

  init?(inputFileURL: URL, outputFileURL: URL) {
    inputURL = inputFileURL
    outputURL = outputFileURL

    if (FileManager.default.fileExists(atPath: inputURL.absoluteString)) {
      print("Input file does not exist at file path \(inputURL.absoluteString)")
      return nil
    }
  }

    func convert(group: DispatchGroup) {
    let rwAudioSerializationQueueDescription = " rw audio serialization queue"
    // Create the serialization queue to use for reading and writing the audio data.
    rwAudioSerializationQueue = DispatchQueue(label: rwAudioSerializationQueueDescription)
    assert(rwAudioSerializationQueue != nil, "Failed to initialize Dispatch Queue")

    asset = AVAsset(url: inputURL)
    assert(asset != nil, "Error creating AVAsset from input URL")
    print("Output file path -> ", outputURL.absoluteString)

    asset.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: {
      var success = true
      var localError:NSError?
      success = (self.asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded)
      // Check for success of loading the assets tracks.
      if (success) {
        // If the tracks loaded successfully, make sure that no file exists at the output path for the asset writer.
        let fm = FileManager.default
        let localOutputPath = self.outputURL.path
        if (fm.fileExists(atPath: localOutputPath)) {
          do {
            try fm.removeItem(atPath: localOutputPath)
            success = true
          } catch {
            print("Error trying to remove output file at path -> \(localOutputPath)")
          }
        }
      }

      if (success) {
        success = self.setupAssetReaderAndAssetWriter()
      } else {
        print("Failed setting up Asset Reader and Writer")
      }
      if (success) {
        success = self.startAssetReaderAndWriter(group: group)

          
        return
      } else {
        print("Failed to start Asset Reader and Writer")
      }

    })
  }

  func setupAssetReaderAndAssetWriter() -> Bool {
    do {
      assetReader = try AVAssetReader(asset: asset)
    } catch {
      print("Error Creating AVAssetReader")
    }

    do {
      assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: AVFileType.m4a)
    } catch {
      print("Error Creating AVAssetWriter")
    }

    var assetAudioTrack:AVAssetTrack? = nil
    let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)

    if (audioTracks.count > 0) {
      assetAudioTrack = audioTracks[0]
    }

    if (assetAudioTrack != nil) {

      let decompressionAudioSettings:[String : Any] = [
        AVFormatIDKey:Int(kAudioFormatLinearPCM)
      ]

      assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack!, outputSettings: decompressionAudioSettings)
      assert(assetReaderAudioOutput != nil, "Failed to initialize AVAssetReaderTrackOutout")
      assetReader.add(assetReaderAudioOutput)

      var channelLayout = AudioChannelLayout()
      memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size);
      channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;

      let outputSettings:[String : Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVEncoderBitRateKey: 96000,
        AVNumberOfChannelsKey: 2,
        AVChannelLayoutKey: NSData(bytes:&channelLayout, length:MemoryLayout<AudioChannelLayout>.size)]

      assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
      assert(rwAudioSerializationQueue != nil, "Failed to initialize AVAssetWriterInput")
      assetWriter.add(assetWriterAudioInput)

    }
    return true
  }

    func startAssetReaderAndWriter(group: DispatchGroup) -> Bool {
    assetWriter.startWriting()
    assetReader.startReading()
    assetWriter.startSession(atSourceTime: CMTime.zero)

    assetWriterAudioInput.requestMediaDataWhenReady(on: rwAudioSerializationQueue, using: {

      while(self.assetWriterAudioInput.isReadyForMoreMediaData ) {
        var sampleBuffer = self.assetReaderAudioOutput.copyNextSampleBuffer()
        if(sampleBuffer != nil) {
          self.assetWriterAudioInput.append(sampleBuffer!)
          sampleBuffer = nil
        } else {
          self.assetWriterAudioInput.markAsFinished()
          self.assetReader.cancelReading()
          self.assetWriter.finishWriting {
              group.leave()
              BlockingProgressHUD.dismiss()
          }
          break
        }
      }
    })
    return true
  }
}
