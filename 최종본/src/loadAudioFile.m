% --- File: src/loadAudioFile.m ---
function [audioData, fs] = loadAudioFile(filePath)
    [audioData, fs] = audioread(filePath);
    disp(['Loaded file: ', filePath]);
end
