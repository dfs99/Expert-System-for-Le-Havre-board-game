(defrule ACTUALIZAR_MAZO_3
	(object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion_en_mazo ?))
	?actualizacion_sobre_carta <- (carta_actualizada ?nombre_carta ?id)
    (not (actualizar_mazo ?id))
	=>
	(retract ?actualizacion_sobre_carta)
	(printout t"actualizando mazo..." crlf)
)

(defrule ACTUALIZAR_MAZO_1
	?carta_mazo1 <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta1) (posicion_en_mazo ?pos1))
	(test (> ?pos1 2))
	(actualizar_mazo ?id)
    (not (carta_actualizada ?nombre_carta1 ?id))
    =>
    (modify-instance ?carta_mazo1(posicion_en_mazo (- ?pos1 1)))
	(assert (carta_actualizada ?nombre_carta1 ?id))
    (printout t"El mazo <" ?id "> ha actualizado la posición de la carta <" ?nombre_carta1 ">, ahora se encuentra en la posción <" (- ?pos1 1) ">." crlf)
)


(defrule ACTUALIZAR_MAZO_2
	?carta_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion_en_mazo ?pos))
	(test (> ?pos 1))
	?actualizar <- (actualizar_mazo ?id)
	(not (carta_actualizada ?nombre_carta ?id))
	=>
	(modify-instance ?carta_mazo (posicion_en_mazo (- ?pos 1)))
	(retract ?actualizar)
	(printout t"El mazo <" ?id "> ha actualizado la posición de la carta <" ?nombre_carta ">, ahora se encuentra en la posción <" (- ?pos 1) ">." crlf)
)


;1	2	2			1
;2	3	2	(act)	2
;3	4	3	(act)	3
;4	5	4	(act)	4
;5