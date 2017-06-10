
(in-package :common-lisp-user)

(defpackage :cffi-portaudio
  (:nicknames :portaudio)
  (:use
   :cffi
   :common-lisp)
  (:export
   #:initialize
   #:open-default-stream
   #:float-32
   #:+frames-per-buffer-unspecified*
   #:abort-stream
   #:terminate
   #:start-stream
   #:stop-stream))
