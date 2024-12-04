% --- File: saveAudioFile.m ---
function saveAudioFile(filePath, audioData, fs)
    audiowrite(filePath, audioData, fs);
    disp(['Saved modified file: ', filePath]);
end
