
(in-package :cffi-portaudio)

(define-foreign-library libportaudio
  (t (:default "libportaudio")))

(use-foreign-library libportaudio)

(defcfun ("Pa_GetErrorText" pa-get-error-text) :string
  (error-code pa-error))

(define-condition portaudio-error (error)
  ((code :initarg :code
	 :reader error-code
	 :type fixnum))
  (:report (lambda (condition stream)
	     (let ((error-code (error-code condition)))
	       (format stream "PortAudio error ~A ~A"
		       error-code
		       (pa-get-error-text error-code)))))
  (:documentation "An error that is signalled when PortAudio returns
an error code."))

(defun check-error-code (code)
  (when (< code 0)
    (error 'portaudio-error :code code))
  code)

(defcfun ("Pa_Initialize" pa-initialize) pa-error)

(defun initialize ()
  (check-error-code (pa-initialize)))

(defcfun ("Pa_Terminate" pa-terminate) pa-error)

(defun terminate ()
  (check-error-code (pa-terminate)))

(defcfun ("Pa_OpenStream" pa-open-stream) pa-error
  (stream (:pointer :pointer))
  (input-parameters (:pointer (:struct pa-stream-parameters)))
  (output-parameters (:pointer (:struct pa-stream-parameters)))
  (sample-rate :double)
  (frames-per-buffer :unsigned-long)
  (stream-flags pa-stream-flags)
  (stream-callback :pointer)
  (user-data :pointer))

(defun open-stream (stream* input-parameters output-parameters
		    sample-rate frames-per-buffer stream-flags
		    stream-callback user-data)
  (check-error-code (pa-open-stream stream* input-parameters output-parameters
				    sample-rate frames-per-buffer stream-flags
				    stream-callback user-data)))

(defcfun ("Pa_OpenDefaultStream" pa-open-default-stream) pa-error
  (stream (:pointer :pointer))
  (num-input-channels :int)
  (num-output-channels :int)
  (sample-format pa-sample-format)
  (sample-rate :double)
  (frames-per-buffer :unsigned-long)
  (stream-callback :pointer)
  (user-data :pointer))

(defun open-default-stream (stream num-input-channels num-output-channels
			    sample-format sample-rate frames-per-buffer
			    stream-callback user-data)
  "Creates an audio stream on the default device."
  (check-error-code (pa-open-default-stream stream
					    num-input-channels
					    num-output-channels
					    sample-format
					    sample-rate
					    frames-per-buffer
					    stream-callback
					    user-data)))

(defcfun ("Pa_CloseStream" pa-close-stream) pa-error
  (stream :pointer))

(defun close-stream (stream)
  (check-error-code (pa-close-stream stream)))

(defcfun ("Pa_StartStream" pa-start-stream) pa-error
  (stream :pointer))

(defun start-stream (stream*)
  (check-error-code (pa-start-stream stream*)))

(defcfun ("Pa_StopStream" pa-stop-stream) pa-error
  (stream :pointer))

(defun stop-stream (stream)
  (check-error-code (pa-stop-stream stream)))

(defcfun ("Pa_AbortStream" pa-abort-stream) pa-error
  (stream :pointer))

(defun abort-stream (stream)
  (check-error-code (pa-abort-stream stream)))

(defcfun ("Pa_IsStreamStopped" pa-is-stream-stopped) pa-error
  (stream :pointer))

(defun is-stream-stopped (stream)
  (check-error-code (pa-is-stream-stopped stream)))

(defcfun ("Pa_IsStreamActive" pa-is-stream-active) pa-error
  (stream :pointer))

(defun is-stream-active (stream)
  (check-error-code (pa-is-stream-active stream)))

(defcallback cb :int ((input :pointer)
		      (output :pointer)
		      (frame-count :unsigned-long)
		      (time-info (:pointer (:struct pa-stream-callback-time-info)))
		      (status-flags pa-stream-callback-flags)
		      (user-data :pointer))
  (declare (ignore input time-info status-flags user-data))
  (print "callback")
  (force-output)
  #+nil(dotimes (i frame-count)
	 (setf (mem-aref output :float i) (cos i)))
  0)

(defun stream-parameters (params
			  &key (device 0) (channel-count 2)
			    (sample-format +pa-float-32+)
			    (suggested-latency 0.1d0)
			    (host-api-specific-stream-info (null-pointer)))
  (flet ((set-slot (slot value)
	   (setf (foreign-slot-value params
				     '(:struct pa-stream-parameters)
				     slot)
		 value)))
    (set-slot 'device device)
    (set-slot 'channel-count channel-count)
    (set-slot 'sample-format sample-format)
    (set-slot 'suggested-latency suggested-latency)
    (set-slot 'host-api-specific-stream-info host-api-specific-stream-info)))

(defun test (&optional (rate 48000) (latency 0.005) (flags 0))
  (initialize)
  (with-foreign-objects ((stream* :pointer)
			 (input-params '(:struct pa-stream-parameters))
			 (output-params '(:struct pa-stream-parameters)))
    (setf (mem-ref stream* :pointer) (null-pointer))
    (print (mem-ref stream* :pointer))
    #+nil(open-default-stream stream* 0 2 +pa-float-32+
			      (coerce rate 'double-float)
			      (floor (* rate latency) 1000)
			      (callback cb)
			      (null-pointer))
    (stream-parameters input-params)
    (stream-parameters output-params)
    (open-stream stream* (null-pointer) output-params
		 (coerce rate 'double-float)
		 (floor (* rate latency))
		 flags
		 (get-callback 'cb)
		 (null-pointer))
    (let ((stream (mem-ref stream* :pointer)))
      (print stream)
      (start-stream stream)
      (sleep 10)
      (abort-stream stream)))
  (terminate))

;(test)
