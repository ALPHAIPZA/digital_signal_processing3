% --- File: src/performIFFT.m ---
function audioData = performIFFT(modifiedSTFT, frameSize, hopSize)
    % 역 단시간 푸리에 변환(ISTFT) 수행
    % 입력:
    %   - modifiedSTFT: 수정된 STFT 행렬
    %   - frameSize: ISTFT를 위한 윈도우 크기
    %   - hopSize: ISTFT를 위한 홉 크기
    % 출력:
    %   - audioData: 시간 도메인으로 복원된 신호

    [numFreqs, numFrames] = size(modifiedSTFT);
    window = hamming(frameSize); % 해밍 윈도우

    % 출력 신호 초기화
    outputLength = (numFrames - 1) * hopSize + frameSize;
    audioData = zeros(outputLength, 1);
    windowSum = zeros(outputLength, 1);

    % ISTFT 계산 (프레임별 오버랩-합산 방식)
    for frameIdx = 1:numFrames
        % 각 프레임에 대해 역 FFT 수행
        frame = modifiedSTFT(:, frameIdx);
        timeFrame = real(ifft([frame; conj(flipud(frame(2:end-1)))])); % 대칭성 활용한 IFFT

        % 윈도우를 적용한 프레임을 출력 신호에 추가
        startIdx = (frameIdx - 1) * hopSize + 1;
        endIdx = startIdx + frameSize - 1;
        audioData(startIdx:endIdx) = audioData(startIdx:endIdx) + (timeFrame .* window);
        windowSum(startIdx:endIdx) = windowSum(startIdx:endIdx) + window;
    end

    % 윈도우 합으로 신호를 정규화
    audioData = audioData ./ (windowSum + eps);

    disp('ISTFT가 성공적으로 수행되었습니다.');
end
