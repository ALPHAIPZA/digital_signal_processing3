# digital_signal_processing3
2024_12_05 TeamProject 3조 발표
디렉토리 구조
```
최종본/
├── src/
│   ├── main.m             
│   ├── applyFIRFilter.m      
│   ├── normalizeAudioToDynamicDB.m         
│   ├── PerformFFT.m * STFT() 수행
│   ├── PerformIFFT.m
│   ├── pitchModulation.m
├── input_audio/
│   ├── example.wav 
├── output_audio/ * 1회 실행시
│   ├── example_filtered.wav
│   ├── example_filtered_pitchN.wav
│   ├── example_filtered_pitchN+Mdb_frameO_hopP.wav
end
```

#실행 방법
```
1. input_audio 폴더에 처리할 .wav파일 저장
2. main.m 실행
3. 스펙트로그램 시각화(Matlab), output_audio에 처리된 .wav파일 저장됨
