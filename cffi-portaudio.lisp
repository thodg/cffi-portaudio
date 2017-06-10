
(in-package :cffi-portaudio)

(define-foreign-library libportaudio
  (t (:default "libportaudio")))

(use-foreign-library libportaudio)

(defcfun ("Pa_Initialize" pa-initialize) pa-error)

(defun check-error-code (code)
  (when (not (eq :pa-no-error code))
    (error code)))

(defun initialize ()
  (check-error-code (pa-initialize)))

(defcfun ("Pa_OpenDefaultStream" pa-open-default-stream) pa-error
  (stream (:pointer (:pointer pa-stream)))
  (num-input-channels :int)
  (num-output-channels :int)
  (sample-format pa-sample-format)
  (sample-rate :double)
  (frames-per-buffer :unsigned-long)
  (stream-callback (:pointer pa-stream-callback))
  (user-data :pointer))
