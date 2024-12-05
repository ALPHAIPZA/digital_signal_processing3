% --- File: src/performFFT.m ---
function [stftData, freqs, timeVec] = performFFT(audioData, fs, frameSize, hopSize)
    % 단시간 푸리에 변환(STFT) 수행
    % 입력:
    %   - audioData: 시간 도메인의 오디오 신호
    %   - fs: 샘플링 주파수 (Hz)
    %   - frameSize: STFT를 위한 윈도우 크기
    %   - hopSize: STFT를 위한 홉 크기
    % 출력:
    %   - stftData: STFT 행렬 (복소수 값)
    %   - freqs: 주파수 배열 (Hz)
    %   - timeVec: 시간 벡터 (초)

    % 해밍 윈도우 적용
    window = hamming(frameSize);

    % STFT 계산
    [stftData, freqs, timeVec] = spectrogram(audioData, window, frameSize - hopSize, frameSize, fs);

    % STFT 행의 크기가 frameSize / 2 + 1과 일치하는지 확인
    expectedRows = frameSize / 2 + 1;
    if size(stftData, 1) < expectedRows
        % 예상보다 적은 경우, 행을 0으로 패딩
        padRows = expectedRows - size(stftData, 1);
        stftData = [stftData; zeros(padRows, size(stftData, 2))];
    elseif size(stftData, 1) > expectedRows
        % 예상보다 많은 경우, 초과된 행을 잘라냄
        stftData = stftData(1:expectedRows, :);
    end

    disp('STFT가 성공적으로 수행되었습니다.');
end
