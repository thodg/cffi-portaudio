
(in-package :common-lisp-user)

(defpackage :cffi-portaudio.system
  (:use :common-lisp :asdf))

(in-package :cffi-portaudio.system)

(defsystem :cffi-portaudio
  :defsystem-depends-on ("cffi-grovel")
  :depends-on ("cffi")
  :components
  ((:file "package")
   (:cffi-grovel-file "grovel-portaudio" :depends-on ("package"))
   (:file "cffi-portaudio" :depends-on ("grovel-portaudio"))))
