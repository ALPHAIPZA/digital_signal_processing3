% --- Visualization integrated into main.m ---
clc; clear; close all;

% 경로 설정
rootDir = fullfile(fileparts(mfilename('fullpath')), '..');
inputDir = fullfile(rootDir, 'input_audio');
outputDir = fullfile(rootDir, 'output_audio');
addpath(fullfile(rootDir, 'src'));

% 매개변수 설정
pitchFactor = 3.0; 
targetIncreaseDB = 10;
frameSize = 10000;
hopSize = 100;

% 입력 오디오 파일 목록 읽기
audioFiles = dir(fullfile(inputDir, '*.wav'));

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

for i = 1:length(audioFiles)
    fileName = audioFiles(i).name;
    inputPath = fullfile(inputDir, fileName);
    [audioData, fs] = audioread(inputPath);

    % Step 1: 노이즈 처리 전의 스펙트럼 확인
    [stftRaw, freqsRaw, timeRaw] = performFFT(audioData, fs, frameSize, hopSize);

    % FIR 필터를 사용하여 노이즈 제거
    filteredAudio = applyFIRFilter(audioData, fs);
    [stftFiltered, freqsFiltered, timeFiltered] = performFFT(filteredAudio, fs, frameSize, hopSize);

    % 필터링된 오디오 신호 저장
    [~, name, ~] = fileparts(fileName);
    filteredFileName = sprintf('%s_filtered.wav', name);
    filteredFilePath = fullfile(outputDir, filteredFileName);
    audiowrite(filteredFilePath, filteredAudio, fs);
    disp(['Filtered audio saved: ', filteredFileName]);

    % 필터링된 오디오 신호를 증폭
    targetDB = 20 * log10(sqrt(mean(filteredAudio .^ 2))) + targetIncreaseDB;
    normalizedFilteredAudio = normalizeAudioToDynamicDB(filteredAudio, targetDB);

    % STFT -> 피치 변환 -> ISTFT
    [stftNorm, ~, ~] = performFFT(normalizedFilteredAudio, fs, frameSize, hopSize);
    modifiedSTFT = pitchModulation(stftNorm, pitchFactor, fs);
    reconstructedAudio = performIFFT(modifiedSTFT, frameSize, hopSize);
    [stftPitchShifted, freqsPitchShifted, timePitchShifted] = performFFT(reconstructedAudio, fs, frameSize, hopSize);

    % 피치 변환된 오디오 신호 저장
    pitchShiftedFileName = sprintf('%s_filtered_pitch%.1f.wav', name, pitchFactor);
    pitchShiftedFilePath = fullfile(outputDir, pitchShiftedFileName);
    audiowrite(pitchShiftedFilePath, reconstructedAudio, fs);
    disp(['Pitch-shifted audio saved: ', pitchShiftedFileName]);

    % 최종 증폭
    finalNormalizedAudio = normalizeAudioToDynamicDB(reconstructedAudio, targetDB);
    [stftAmplified, freqsAmplified, timeAmplified] = performFFT(finalNormalizedAudio, fs, frameSize, hopSize);

    % Figure에 스펙트럼 시각화
    figure;
    subplot(2, 2, 1);
    spectrogram(audioData, hamming(frameSize), frameSize - hopSize, frameSize, fs, 'yaxis');
    title('Noise Included Spectrum');
    ylabel('Frequency (kHz)');

    subplot(2, 2, 2);
    spectrogram(filteredAudio, hamming(frameSize), frameSize - hopSize, frameSize, fs, 'yaxis');
    title('Filtered Spectrum');

    subplot(2, 2, 3);
    spectrogram(reconstructedAudio, hamming(frameSize), frameSize - hopSize, frameSize, fs, 'yaxis');
    title('Pitch Shifted Spectrum');

    subplot(2, 2, 4);
    spectrogram(finalNormalizedAudio, hamming(frameSize), frameSize - hopSize, frameSize, fs, 'yaxis');
    title('Amplified Spectrum');

    sgtitle(['Spectrogram Analysis for ', fileName]);

    % 최종 증폭된 오디오 저장
    outputFileName = sprintf('%s_filtered_pitch%.1f_%+.1fdB_frame%d_hop%d.wav', ...
                             name, pitchFactor, targetIncreaseDB, frameSize, hopSize);
    outputPath = fullfile(outputDir, outputFileName);
    audiowrite(outputPath, finalNormalizedAudio, fs);
    disp(['Processed and saved: ', outputFileName]);
end

disp('모든 오디오 파일이 성공적으로 처리되었습니다.');
