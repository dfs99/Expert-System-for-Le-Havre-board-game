


; la relacion puede ser una clase

(defclass PARTIDA
    (is-a USER)
    (role concrete)
    
    (slot oferta_francos (type INTEGER) (create-accessor read-write))
    (slot oferta_pescado (type INTEGER)(create-accessor read-write))  
    (slot oferta_madera (type INTEGER) (create-accessor read-write))
    (slot oferta_arcilla (type INTEGER) (create-accessor read-write))
    (slot oferta_hierro (type INTEGER) (create-accessor read-write))
    (slot oferta_trigo (type INTEGER) (create-accessor read-write))
    (slot oferta_ganado (type INTEGER) (create-accessor read-write))
)


(defclass RONDA
    (is-a USER)
    (role concrete)
    (slot nombre_ronda (type SYMBOL) 
        (allowed-value RONDA_1, RONDA_2, RONDA_3, RONDA_4, RONDA_5, RONDA_6, RONDA_7, RONDA_8, RONDA_EXTRA_FINAL)
        (create-accessor read-write)
    )

    ; representarlo como una relación?
    (slot numero_fase (type INTEGER) (create-accessor read-write))
    (slot coste_comida (type INTEGER) (create-accessor read-write))
    (slot hay_cosecha (type SYMBOL) (allowed-value TRUE, FALSE) (default FALSE) (create-accessor read-write))

)

(defclass JUGADOR
    (is-a USER)
    (role concrete)
    
    (slot nombre (type STRING) (create-accessor read-write))
    (slot numero_creditos (type INTEGER) (create-accessor read-write) (default 0))
    (slot numero_bonus_martillo (type INTEGER) (create-accessor read-write) (default 0))
    (slot numero_bonus_pescador(type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_francos (type INTEGER) (create-accessor read-write))
    (slot unidades_pescado (type INTEGER) (create-accessor read-write))
    (slot unidades_madera (type INTEGER) (create-accessor read-write))
    (slot unidades_arcilla (type INTEGER) (create-accessor read-write))
    (slot unidades_hierro (type INTEGER) (create-accessor read-write))
    (slot unidades_trigo (type INTEGER) (create-accessor read-write))
    (slot unidades_ganado (type INTEGER) (create-accessor read-write))
    (slot unidades_carbon (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_piel (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_pescado_ahumado (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_carbon_vegetal (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_ladrillos (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_acero (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_pan (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_carne (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_coque (type INTEGER) (create-accessor read-write) (default 0))
    (slot unidades_cuero (type INTEGER) (create-accessor read-write) (default 0))
)


(defclass CARTA
    (is-a USER)
    (role abstract)
    (slot tipo
        (type SYMBOL)
        (allowed-value ECONOMICO, CONSTRUCCION, INDUSTRIAL, BARCO, OTRO)
        (create-accessor read-write)
    )

    (slot nombre (type STRING))
    (slot coste_compra (type INTEGER) )
    (slot valor_proporciona (type INTEGER))
)

(defclass BARCO
    (is-a CARTA)
    (role concrete)

    (slot tipo (source-composite) (default BARCO))
    (slot nombre (source-composite))
    (slot coste_compra (source-composite))
    (slot valor_proporciona (source-composite))
    (slot tipo_barco (type SYMBOL)
        (allowed-value MADERA, HIERRO, ACERO, LUJO)
        (create-accessor read-write)
    )
    (slot comida_genera (type INTEGER))
    (slot num_recursos_necesarios (type INTEGER))
    (slot tipo_recurso (type SYMBOL) (allowed-value MADERA, HIERRO, ACERO))
    (slot num_energia_necesaria (type INTEGER))
)

(defclass EDIFICIO_GENERADOR
    (is-a CARTA)
    (role concrete)

)

(defclass EDIFICIO_TRANSFORMADOR
    (is-a CARTA)
    (role concrete)
    
)

(defclass EDIFICIO_CONSTRUCTOR
    (is-a CARTA)
    (role concrete)
    
)