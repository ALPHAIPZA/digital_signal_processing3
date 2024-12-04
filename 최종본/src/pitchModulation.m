% --- File: src/pitchModulation.m ---
function modifiedSTFT = pitchModulation(stftData, pitchFactor, fs)
    % STFT를 사용하여 피치 변조 수행
    % 입력:
    %   - stftData: STFT 행렬 (복소수 값)
    %   - pitchFactor: 피치 변조 계수 (예: 1.2는 20% 증가)
    %   - fs: 샘플링 주파수 (Hz)
    % 출력:
    %   - modifiedSTFT: 피치 변조 후의 STFT 행렬

    [numFreqs, numFrames] = size(stftData);
    modifiedSTFT = zeros(size(stftData)); % 출력 STFT 초기화

    for frameIdx = 1:numFrames
        % 단일 프레임 추출 및 크기/위상 분리
        frame = stftData(:, frameIdx);
        mag = abs(frame); % 크기 스펙트럼
        phase = angle(frame); % 위상 스펙트럼

        % 원래 주파수 인덱스
        originalIndices = (1:numFreqs).';

        % 스케일된 주파수 인덱스
        scaledIndices = originalIndices / pitchFactor;

        % 스케일된 인덱스가 범위를 벗어나지 않도록 보정
        scaledMagnitudes = interp1(originalIndices, mag, scaledIndices, 'linear', 0);

        % 크기가 원래 프레임 크기와 일치하도록 조정
        if length(scaledMagnitudes) < numFreqs
            % 부족하면 0으로 패딩
            scaledMagnitudes = [scaledMagnitudes; zeros(numFreqs - length(scaledMagnitudes), 1)];
        elseif length(scaledMagnitudes) > numFreqs
            % 초과하면 자르기
            scaledMagnitudes = scaledMagnitudes(1:numFreqs);
        end

        % 스케일된 크기를 원래 위상과 결합
        modifiedFrame = scaledMagnitudes .* exp(1i * phase);

        % 출력 STFT 행렬에 저장
        modifiedSTFT(:, frameIdx) = modifiedFrame;
    end

    disp(['피치 변조가 적용되었습니다. 피치 계수: ', num2str(pitchFactor)]);
end
