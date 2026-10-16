(sdegeo:create-rectangle (position 0 0 0) (position 60 0.09 0) "AluminumOxide" "Al2O3")

(sdegeo:create-rectangle (position (- 30 @L_R@) 0.09 0) (position 55 (+ 0.09 0.015) 0 ) "WSe2" "WSe2_channel")
(sdegeo:create-rectangle (position 30 0.09 0) (position 30.0005 (+ 0.09 0.01) 0 ) "WSe2" "WSe2_channel2")
(sdegeo:create-rectangle (position (- 30 @L_R@) (+ 0.09 0.005) 0) (position 30 (+ 0.09 0.005 0.005 0.0005) 0 ) "WSe2" "WSe2_channel3")
(sdegeo:create-rectangle (position 55 0.09 0) (position 60 (+ 0.09 0.005) 0) "WSe2" "WSe2_D")
(sdegeo:create-rectangle (position 30.005 (+ 0.09 0.005) 0) (position 55 (+  0.09 0.02) 0 ) "WSe2" "WSe2_channelc")
(sdegeo:delete-region (find-region-id "WSe2_channelc"))

(sdegeo:create-rectangle (position 0 0.09 0) (position 5 (+ 0.09 0.01)  0) "aIGZO" "IGZO_S")
(sdegeo:create-rectangle (position 5 0.09 0) (position 30 (+ 0.09 0.01) 0) "aIGZO" "IGZO_channel")

(sdegeo:define-contact-set "sss" 0.001 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "ddd" 0.001 (color:rgb 1 0 1) "##")
(sdegeo:define-contact-set "ggg" 0.001 (color:rgb 1 1 0) "##")

(sdegeo:set-current-contact-set "ddd")
(sdegeo:set-contact (list (car (find-edge-id (position 57.5 0.095 0)))) "ddd")
(sdegeo:set-current-contact-set "sss")
(sdegeo:set-contact (list (car (find-edge-id (position 2.5 0.1 0)))) "sss")
(sdegeo:set-current-contact-set "ggg")
(sdegeo:set-contact (list (car (find-edge-id (position 30 0 0)))) "ggg")

(sdeio:save-tdr-bnd (get-body-list) "n@node@_bnd.tdr")
