
(in-package :cffi-portaudio)

(include "portaudio.h")

(ctype pa-error "PaError")

(cenum pa-error-code
  ((:pa-no-error "paNoError"))
  ((:pa-not-initialized "paNotInitialized")))

(constant (+pa-frames-per-buffer-unspecified+ "paFramesPerBufferUnspecified"))

(ctype pa-time "PaTime")

(cstruct pa-stream-callback-time-info "PaStreamCallbackTimeInfo"
  (input-buffer-adc-time "inputBufferAdcTime" :type pa-time)
  (current-time "currentTime" :type pa-time)
  (ouput-buffer-dac-time "outputBufferDacTime" :type pa-time))

(ctype pa-stream-callback-flags "PaStreamCallbackFlags")

(ctype pa-sample-format "PaSampleFormat")

(constant (+pa-float-32+ "paFloat32"))
(constant (+pa-int-32+ "paInt32"))
(constant (+pa-int-24+ "paInt24"))
(constant (+pa-int-16+ "paInt16"))
(constant (+pa-int-8+ "paInt8"))
(constant (+pa-uint-8+ "paUInt8"))
(constant (+pa-custom-format+ "paCustomFormat"))
(constant (+pa-non-interleaved+ "paNonInterleaved"))

(ctype pa-device-index "PaDeviceIndex")

(ctype pa-stream-flags "PaStreamFlags")

(cstruct pa-stream-parameters "PaStreamParameters"
  (device "device" :type pa-device-index)
  (channel-count "channelCount" :type :int)
  (sample-format "sampleFormat" :type pa-sample-format)
  (suggested-latency "suggestedLatency" :type :double)
  (host-api-specific-stream-info "hostApiSpecificStreamInfo" :type :pointer))
