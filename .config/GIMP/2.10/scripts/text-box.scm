(script-fu-register
	"script-fu-title-page-kpk"                  ;function name
	"Title Page for KPK"                        ;menu label
	"Creates a title page for KPK."             ;description
	"Ole Martin Ruud"                             ;author
	"copyright 2023, Ole Martin Ruud;\
	  2009, the GIMP Documentation Team"        ;copyright notice
	"May 12, 2023"                              ;date created
	""                                          ;image type that the script works on
	SF-FILENAME    "ImageFile"     ""
	SF-STRING      "Title"         "Title"
	SF-STRING      "Date"          "Date"
	SF-STRING      "SubTitle"      "SubTitle"
	SF-FONT        "Font"          "LEMON MILK" ;a font variable
	SF-ADJUSTMENT  "Font size"     '(120 1 1000 1 10 0 1)
	                                            ;a spin-button
	SF-VALUE       "NewWidth"      "1920"       ;facebook sizes
	SF-VALUE       "NewHeight"     "1005"       ;facebook sizes
	SF-VALUE       "OffsetFactor"  "1"          ;offest factor when cropping
	SF-STRING      "NewFileNameAdd" "mod"
	SF-COLOR       "MainColor"     '(244 108 15);color variable
	SF-COLOR       "ShadowColor"   '(0 0 0)     ;color variable
	SF-FILENAME    "LogoFile"      "/home/oruud/Pictures/kpk/logo.png"
	)
	(script-fu-menu-register "script-fu-title-page-kpk" "<Image>/File/Create")

(define (replace-spaces-with-underscore str)
	(list->string
		(map
			(lambda (char)
				(if (char=? #\space char) #\_ char))
		(string->list str))))

(define (
	script-fu-title-page-kpk-defaults
		filename
		title
		date
		subtitle
		fontSize
		newWidth
		newHeight
		offsetFactor
		newFilenameAddition
	)
	(script-fu-title-page-kpk
		filename
		title
		subtitle
		date
		"LEMON MILK"
		fontSize
		newWidth
		newHeight
		offsetFactor
		newFilenameAddition
		'(244 108 15)
		'(0 0 0)
		"/home/oruud/Pictures/kpk/logo.png"
	)
)

(define (
	script-fu-title-page-kpk
		filename
		title
		subtitle
		date
		font
		fontSize
		newWidth
		newHeight
		offsetFactor
		newFilenameAddition
		mainColor
		shadowColor
		logoFile
	)
	(let* (
			(img (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
			(drawable (car (gimp-image-get-active-layer img)))
			(origWidth (car (gimp-image-width img)))
			(origHeight (car (gimp-image-height img)))
			(logoSize (* 0.25 (if (<= newWidth newHeight) newWidth newHeight)))
			(textOffset (* 0.1 (if (<= newWidth newHeight) newWidth newHeight)))
			(dateFontSize (* fontSize 0.6))
			(subTitleFontSize (* fontSize 0.5))
			(newFilename (string-append (string-downcase (replace-spaces-with-underscore title)) "_" newFilenameAddition ".jpg"))
			(titleObj)
			(dateObj)
			(subTitleObj)
			(logoObj)
		) ; end of local vars

		; (gimp-image-undo-group-start img)

		; Scale image while maintaining aspect ratio 
		; and crop image to fit into banner (take center)
		(let* (
				(widthAspect (/ newWidth origWidth))
				(heightAspect (/ newHeight origHeight))
			)
			(if (>= widthAspect heightAspect)
				(let* (
						(adjHeight (ceiling (* origHeight widthAspect)))
						(offY (floor (* offsetFactor (- (/ adjHeight 2) (/ newHeight 2)))))
					)
					(gimp-image-scale img newWidth adjHeight)
					(gimp-crop img newWidth newHeight 0 offY)
				)
				(let* (
						(adjWidth (ceiling (* origWidth heightAspect)))
						(offX (floor (* offsetFactor (- (/ adjWidth 2) (/ newWidth 2)))))
					)
					(gimp-image-scale img adjWidth newHeight)
					(gimp-crop img newWidth newHeight offX 0)
				)
			)
		)

		; Set colors
		(gimp-context-set-foreground mainColor)
		(gimp-context-set-background shadowColor)

		(let* (
				(make-shadowed-text (lambda (x y text size shadowSize)
						(if (< 0 (string-length text))
							(let*
								(
									(textObj
										(car
											(
												gimp-text-fontname
												img drawable
												x y
												text
												0
												TRUE
												size PIXELS
												font
											)
										)
									)
								)

								; Add shadow to text drawn above
								(gimp-image-select-item img 0 textObj)
								(gimp-selection-grow img shadowSize)
								(gimp-bucket-fill drawable 1 28 100 0 FALSE 0 0)
								(gimp-selection-none img)

								textObj
							)
						)
					)
				)
			)

			; Add text lines as shadowed text
			(set! titleObj (make-shadowed-text textOffset textOffset title fontSize 8))
			(set! dateObj (make-shadowed-text textOffset (apply + (list textOffset fontSize (* 0.5 dateFontSize))) date dateFontSize 6))
			(set! subTitleObj (make-shadowed-text textOffset (apply + (list textOffset fontSize (* 1.5 dateFontSize) (* 0.5 subTitleFontSize))) subtitle subTitleFontSize 5))
		)

		; Add logo as layer
		(set! logoObj (car (gimp-file-load-layer RUN-NONINTERACTIVE img logoFile)))
		(gimp-image-insert-layer img logoObj 0 -1)

		(gimp-item-transform-scale logoObj 0 0 logoSize logoSize)
		(if (>= newWidth newHeight)
			(gimp-item-transform-translate logoObj (- newWidth (* 1.5 logoSize)) (* 0.5 logoSize))
			(gimp-item-transform-translate logoObj (- newWidth (* 1.5 logoSize)) (- newHeight (* 1.5 logoSize)))
		)

		; Merge and save image
		(set! drawable (car (gimp-image-merge-visible-layers img 2)))
		(gimp-file-save RUN-NONINTERACTIVE img drawable newFilename newFilename)

		; (gimp-image-undo-group-end img)
		; (gimp-displays-flush)

		(gimp-image-delete img)
	)
)
