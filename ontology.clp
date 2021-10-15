


; la relacion puede ser una clase

(defclass PARTIDA
    (is-a USER)
    (role concrete)
    (slot num_jugadores
        (type INTEGER)
        (create-accessor read-write)
    )

    (slot ronda_actual
        (type INTEGER)
        (create-accessor read-write)
    )

    (slot numero_rondas_totales
        (type INTEGER)
        (create-accessor read-write)
    )

    (slot turno
        (type STRING)
        (create-accessor read-write)
    )



)

(defclass CARTA
    (is-a USER)
    (role abstract)
    (slot tipo
        (type SYMBOL)
        (allowed-value ECONOMICO, CONSTRUCCION, INDUSTRIAL, BARCO, OTRO)
        (create-accessor read-write)
    )
    (slot nombre
        (type STRING))

    (slot coste
        (type INTEGER))

    (slot valor
        (type INTEGER))
)

(defclass BARCO