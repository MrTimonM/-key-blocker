# RGB effect catalog

Extracted from the installed LEOBOG K81 English text.xml and KB.ini. Driver labels are candidates for WKL-100, whose USB identity differs. Neither completeness nor the name-to-wire-selector mapping is verified.

| Driver label index | Name |
| --- | --- |
| 1 | Fixed on |
| 2 | Respire |
| 3 | Rainbow |
| 4 | Flash away |
| 5 | Raindrops |
| 6 | Rainbow wheel |
| 7 | Ripples shining |
| 8 | Stars twinkle |
| 9 | Shadow disappear |
| 10 | Retro snake |
| 11 | Neon stream |
| 12 | Reaction |
| 13 | Sine wave |
| 14 | Retinue scanning |
| 15 | Rotating windmill |
| 16 | Colorful waterfall |
| 17 | Blossoming |
| 18 | Rotating storm |
| 19 | Self-define |
| 20 | OFF |

KB.ini has 20 LedOpt rows, with the comment `hw effect speed light direct random color`. First/second columns differ (row 2: 2,3; row 3: 3,2; row 11: 11,7). Do not equate label suffixes or UI rows with the WKL-100 selector without tracing conversion. Raw rows are preserved in rgb-effect-catalog.json.

The driver lists speed and brightness options 0-4. WKL-100 field offsets and behavior remain unverified. Only selector values 3 and 11 have been confirmed by readback and visible observation; descriptive names have not been confirmed. No USB commands were sent during this extraction.
