
(in-package :cffi-portaudio)

(include "portaudio.h")

(ctype pa-error "PaError")

(cenum pa-error-code
  ((:pa-no-error "paNoError"))
  ((:pa-not-initialized "paNotInitialized")))

(ctype pa-stream "PaStream")

(ctype pa-sample-format "PaSampleFormat")

(constant (+float-32+ "paFloat32"))
(constant (+int-32+ "paInt32"))
(constant (+int-24+ "paInt24"))
(constant (+int-16+ "paInt16"))
(constant (+int-8+ "paInt8"))
(constant (+uint-8+ "paUInt8"))
(constant (+custom-format+ "paCustomFormat"))
(constant (+non-interleaved+ "paNonInterleaved"))
