(script-fu-register
	"script-fu-shadow-text"                   ;function name
	"Create shadow text"                        ;menu label
	"Creates a text with shadow background."    ;description
	"Ole Martin Ruud"                           ;author
	"copyright 2023, Ole Martin Ruud;\
	  2009, the GIMP Documentation Team"        ;copyright notice
	"May 12, 2023"                              ;date created
	""                                          ;image type that the script works on
	SF-FILENAME    "ImageFile"     ""
	SF-STRING      "Text"          "Text"
	SF-VALUE       "X"             "0"
	SF-VALUE       "Y"             "0"
	SF-VALUE       "Angle"         "0"
	SF-FONT        "Font"          "LEMON MILK"
	SF-ADJUSTMENT  "Font size"     '(120 1 1000 1 10 0 1)
	SF-COLOR       "MainColor"     '(244 108 15)
	SF-COLOR       "ShadowColor"   '(0 0 0)
	)
	(script-fu-menu-register "script-fu-shadow-text" "<Image>/File/Create")

(define (
	script-fu-shadow-text-defaults
		filename
		text
		x
		y
		rotation
		fontSize
	)
	(script-fu-shadow-text
		filename
		text
		x
		y
		rotation
		"LEMON MILK"
		fontSize
		'(244 108 15)
		'(0 0 0)
	)
)

(define (
	script-fu-shadow-text
		filename
		text
		x
		y
		rotation
		font
		fontSize
		mainColor
		shadowColor
	)
	(let* (
			(img (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
			(drawable (car (gimp-image-get-active-layer img)))
			(width (car (gimp-image-width img)))
			(height (car (gimp-image-height img)))
			(logoSize (* 0.25 (if (<= width height) width height)))
			(textOffset (* 0.1 (if (<= width height) width height)))
			(pixelX (* x width))
			(pixelY (* y height))
			(shadowSize (* 0.09 fontSize))
			(textObj)
		) ; end of local vars

		; (gimp-image-undo-group-start img)

		; Set colors
		(gimp-context-set-foreground mainColor)
		(gimp-context-set-background shadowColor)

		(set! textObj
			(car
				(
					gimp-text-fontname
					img drawable
					pixelX pixelY
					text
					0
					TRUE
					fontSize PIXELS
					font
				)
			)
		)
		; Rotate text (degrees to radians)
		(gimp-item-transform-rotate textObj (* 0.01745 rotation) TRUE 0 0)

		; Add shadow to text drawn above
		(gimp-image-select-item img 0 textObj)
		(gimp-selection-grow img shadowSize)
		(gimp-bucket-fill drawable 1 28 100 0 FALSE 0 0)
		(gimp-selection-none img)

		; Merge and save image
		(set! drawable (car (gimp-image-merge-visible-layers img 2)))
		(gimp-file-save RUN-NONINTERACTIVE img drawable filename filename)

		; (gimp-image-undo-group-end img)
		; (gimp-displays-flush)

		(gimp-image-delete img)
	)
)
