;    ▄█          ▄████████         ▄█    █▄       ▄████████  ▄█    █▄     ▄████████    ▄████████ 
;   ███         ███    ███        ███    ███     ███    ███ ███    ███   ███    ███   ███    ███ 
;   ███         ███    █▀         ███    ███     ███    ███ ███    ███   ███    ███   ███    █▀  
;   ███        ▄███▄▄▄           ▄███▄▄▄▄███▄▄   ███    ███ ███    ███  ▄███▄▄▄▄██▀  ▄███▄▄▄     
;   ███       ▀▀███▀▀▀          ▀▀███▀▀▀▀███▀  ▀███████████ ███    ███ ▀▀███▀▀▀▀▀   ▀▀███▀▀▀     
;   ███         ███    █▄         ███    ███     ███    ███ ███    ███ ▀███████████   ███    █▄  
;   ███▌    ▄   ███    ███        ███    ███     ███    ███ ███    ███   ███    ███   ███    ███ 
;   █████▄▄██   ██████████        ███    █▀      ███    █▀   ▀██████▀    ███    ███   ██████████ 
;   ▀                                                                    ███    ███              
;
;                                     ╔═╗╔╗╔╔╦╗╔═╗╦  ╔═╗╔═╗╦╔═╗
;                                     ║ ║║║║ ║ ║ ║║  ║ ║║ ╦║╠═╣
;                                     ╚═╝╝╚╝ ╩ ╚═╝╩═╝╚═╝╚═╝╩╩ ╩
;             +-----------------------------+--------------+-------------------------+
;             |           Authors           |     NIAs     |      Github Account     |
;             +-----------------------------+--------------+-------------------------+
;             | Ricardo Grande Cros         |  100386336   |      ricardograndecros  |
;             | Diego Fernandez Sebastian   |  100387203   |      dfs99              |
;             +-----------------------------+--------------+-------------------------+
;
;  from Universidad Carlos III de Madrid - November 2021
; 
; +==============================================================================================+
; |                                                                                              |
; |                                ╔═╗╔═╗╔╗╔╔═╗╔═╗╔═╗╔╦╗╔═╗╔═╗                                   |
; |                                ║  ║ ║║║║║  ║╣ ╠═╝ ║ ║ ║╚═╗                                   |
; |                                ╚═╝╚═╝╝╚╝╚═╝╚═╝╩   ╩ ╚═╝╚═╝                                   |
; |                                                                                              |
; +==============================================================================================+
;

(defclass RECURSO
    (is-a USER)
    (role concrete)
    (slot nombre (type SYMBOL)
        (allowed-values FRANCO MADERA PESCADO ARCILLA HIERRO GRANO GANADO CARBON PIEL
            PESCADO_AHUMADO CARBON_VEGETAL LADRILLOS ACERO PAN CARNE COQUE CUERO)
        (access initialize-only) (create-accessor read-write))
    (slot valor_unitario_en_compañia_naviera (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass RECURSO_ALIMENTICIO
    (is-a RECURSO)
    (role concrete)
    (slot comida_genera (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass BONUS
    (is-a USER)
    (role concrete)
    (slot nombre (type SYMBOL)
        (allowed-values PESCADOR MARTILLO) (access initialize-only) (create-accessor read-write))
)

(defclass MAZO
    (is-a USER)
    (slot id_mazo (type INTEGER) (access read-write) (create-accessor read-write))
    (slot numero_cartas_en_mazo (type INTEGER) (access read-write) (create-accessor read-write))
)

(defclass RONDA
    (is-a USER)
    (role concrete)
    (slot nombre_ronda (type SYMBOL) 
        (allowed-values RONDA_1 RONDA_2 RONDA_3 RONDA_4 RONDA_5 RONDA_6 RONDA_7 RONDA_8 RONDA_EXTRA_FINAL)
        (access initialize-only) (create-accessor read-write))
    (slot coste_comida (type INTEGER) (access initialize-only) (create-accessor read-write))
    (slot hay_cosecha (type SYMBOL) (allowed-values TRUE FALSE) (access initialize-only) (create-accessor read-write))
)

(defclass PARTICIPANTE
    (is-a USER)
    (role concrete)
    (slot nombre (type STRING) (access initialize-only) (create-accessor read-write))
)

(defclass JUGADOR
    (is-a PARTICIPANTE)
    (role concrete)
    (slot deudas (type INTEGER)(default 0)(access read-write) (create-accessor read-write))
    (slot num_barcos (type INTEGER) (default 0) (access read-write) (create-accessor read-write))
    (slot capacidad_envio (type INTEGER) (default 0) (access read-write) (create-accessor read-write))
    (slot demanda_comida_cubierta (type INTEGER) (default 0) (access read-write) (create-accessor read-write))
    (slot riqueza (type INTEGER) (default 2) (access read-write) (create-accessor read-write))
)

(defclass CARTA
    (is-a USER)
    (role concrete)
    (slot nombre (type STRING) (access initialize-only) (create-accessor read-write))
    (slot tipo (type SYMBOL)(allowed-values BASICO INDUSTRIAL COMERCIAL BARCO NINGUNO))
    (slot valor (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass CARTA_EDIFICIO_GENERADOR
    (is-a CARTA)
    (slot numero_recursos_salida (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass CARTA_BANCO
    (is-a CARTA)
    (role concrete)
    (slot tipo (default COMERCIAL))
    (slot coste (type INTEGER) (access initialize-only) (create-accessor read-write))
)

; IMPORTANTE: el barco lujoso, al no reducir la comida necesaria al final de ronda 
; ni poderse comprar con francos (coste), es sencillamente una instancia de la 
; clase carta. 
(defclass BARCO
    (is-a CARTA)
    (role concrete)
    (slot tipo (default BARCO))
    (slot coste (type INTEGER) (access initialize-only) (create-accessor read-write))
    (slot uds_comida_genera (type INTEGER) (access initialize-only) (create-accessor read-write))
    (slot capacidad_envio (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass LOSETA
    (is-a USER)
    (role concrete)
    (slot posicion (type INTEGER) (access initialize-only) (create-accessor read-write))
    (slot visibilidad (type SYMBOL)
        (allowed-values TRUE FALSE)
        (default FALSE)
        (access read-write) (create-accessor read-write))
    (slot intereses (type SYMBOL)
        (allowed-values TRUE FALSE)
        (default FALSE)
        (access initialize-only) (create-accessor read-write))
)

; +==============================================================================================+
; |                                                                                              |
; |                                 ┬─┐┌─┐┬  ┌─┐┌─┐┬┌─┐┌┐┌┌─┐┌─┐                                 |
; |                                 ├┬┘├┤ │  ├─┤│  ││ ││││├┤ └─┐                                 |
; |                                 ┴└─└─┘┴─┘┴ ┴└─┘┴└─┘┘└┘└─┘└─┘                                 |
; |                                                                                              |
; +==============================================================================================+


(defclass PARTICIPANTE_TIENE_RECURSO
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot tipo (type SYMBOL)(allowed-values COMIDA DINERO OTRO)(access initialize-only) (create-accessor read-write))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCO MADERA PESCADO ARCILLA HIERRO GRANO GANADO CARBON PIEL
            PESCADO_AHUMADO CARBON_VEGETAL LADRILLOS ACERO PAN CARNE COQUE CUERO)
        (access initialize-only) (create-accessor read-write))
    (slot cantidad (type INTEGER) (access read-write) (create-accessor read-write))
)

(defclass PARTICIPANTE_TIENE_CARTA
    (is-a USER)
    (slot nombre_jugador (type STRING)(access read-write) (create-accessor read-write))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
)

(defclass JUGADOR_TIENE_BONUS
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot tipo (type SYMBOL) (allowed-values PESCADOR MARTILLO) (access initialize-only) (create-accessor read-write))
    (slot cantidad (type INTEGER) (access read-write) (create-accessor read-write))
)

(defclass JUGADOR_ESTA_EDIFICIO
    (is-a USER)
    (slot nombre_edificio (type STRING) (default "")(access read-write)(create-accessor read-write))
    (slot nombre_jugador (type STRING) (default "")(access read-write)(create-accessor read-write))
)

(defclass JUGADOR_HA_USADO_EDIFICIO
    (is-a USER)
    (slot nombre_edificio (type STRING) (default "")(access read-write)(create-accessor read-write))
    (slot nombre_jugador (type STRING) (default "")(access read-write)(create-accessor read-write))
)

(defclass JUGADOR_ESTA_EN_LOSETA
    (is-a USER)
    (slot posicion (type INTEGER) (access read-write) (create-accessor read-write))
    (slot nombre_jugador (type STRING) (access initialize-only) (create-accessor read-write))
)

(deftemplate OFERTA_RECURSO
    (slot recurso (type SYMBOL)
        (allowed-values FRANCO MADERA PESCADO ARCILLA HIERRO GRANO GANADO))
    (slot cantidad (type INTEGER))
)

(defclass LOSETA_TIENE_RECURSO
    (is-a USER)
    (slot posicion (type INTEGER) (access initialize-only) (create-accessor read-write))
    (slot recurso (type SYMBOL) (access initialize-only) (create-accessor read-write))
    (slot cantidad (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass CARTA_TIENE_BONUS
    (is-a USER)
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
    (slot bonus (type SYMBOL) (allowed-values PESCADOR MARTILLO) (access initialize-only) (create-accessor read-write))
)

(defclass CARTA_PERTENECE_A_MAZO
    (is-a USER)
    (role concrete)
    (slot id_mazo (type INTEGER) (access initialize-only) (create-accessor read-write))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
    (slot posicion_en_mazo (type INTEGER)(access read-write) (create-accessor read-write))
)

(defclass COSTE_ENTRADA_CARTA
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot tipo (type SYMBOL)
        (allowed-values COMIDA DINERO)
        (access initialize-only) (create-accessor read-write))
    (slot cantidad (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass EDIFICIO_INPUT
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCO MADERA PESCADO ARCILLA HIERRO GRANO GANADO CARBON PIEL
            PESCADO_AHUMADO CARBON_VEGETAL LADRILLOS ACERO PAN CARNE COQUE CUERO)
        (access initialize-only) (create-accessor read-write))
    (slot cantidad_maxima (type INTEGER)(access initialize-only)(create-accessor read-write)) 
)

(defclass EDIFICIO_OUTPUT
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCO MADERA PESCADO ARCILLA HIERRO GRANO GANADO CARBON PIEL
            PESCADO_AHUMADO CARBON_VEGETAL LADRILLOS ACERO PAN CARNE COQUE CUERO)
        (access initialize-only) (create-accessor read-write))
    (slot cantidad_min_generada_por_unidad (type FLOAT) (access initialize-only) (create-accessor read-write))
)

(defclass CARTA_OUTPUT_BONUS
    (is-a USER)
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
    (slot bonus (type SYMBOL) (allowed-values PESCADOR MARTILLO) (access initialize-only) (create-accessor read-write))
    (slot cantidad_maxima_permitida (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(defclass COSTE_CONSTRUCCION_CARTA
    (is-a USER)
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
    (slot cantidad_madera (type INTEGER) (access initialize-only) (create-accessor read-write) (default 0))
    (slot cantidad_arcilla (type INTEGER) (access initialize-only) (create-accessor read-write) (default 0))
    (slot cantidad_ladrillo (type INTEGER) (access initialize-only) (create-accessor read-write) (default 0))
    (slot cantidad_hierro (type INTEGER) (access initialize-only) (create-accessor read-write) (default 0))
    (slot cantidad_acero (type INTEGER) (access initialize-only) (create-accessor read-write) (default 0))   
)

(defclass RONDA_INTRODUCE_BARCO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
)

(defclass RONDA_ASIGNA_EDIFICIO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL)
    (allowed-values RONDA_1 RONDA_3 RONDA_5 RONDA_7)
        (access initialize-only) (create-accessor read-write))
    (slot id_mazo (type INTEGER) (access initialize-only) (create-accessor read-write))
)

(deftemplate BARCO_DISPONIBLE
    (slot nombre_barco (type STRING) (default ?NONE))    
)

(deftemplate CONTADOR_COMPAÑIA_NAVIERA 
    (slot nombre (type STRING))
    (slot prioridad (type INTEGER))
)


; =======================================================================================================
; =======================================================================================================

; Relajamiento de los Costes de Energía
; (defclass COSTE_ENERGIA
;     (is-a USER)
;     (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read-write))
;     (slot coste_unitario (type SYMBOL) (allowed-values TRUE FALSE) (access initialize-only) (create-accessor read-write))
;     (slot cantidad (type FLOAT) (access initialize-only) (create-accessor read-write))
; )

; existen edificios donde el coste de energía es unitario y otros en donde no.
; Definimos coste unitario como aquel coste energético que precisa una unidad de recurso para producir otra.
; Por ejemplo, en el ahumador, independientemente del nº de pescados, siempre te costará 1. No es el caso de 
; la fabrica de ladrillos, donde cada arcilla necesitará 0.5

; Panaderia => 0.5 energia por grano                x
; Ahumador => 1 energia en total  => por 6 peces    x
; compañia naviera => 3 por barco  
; siderurgia => 5 energia por acero (1, 1) : otro caso  x
; fabrica ladrillos => 0.5 energía por arcilla      x

; Energia proporcionada por cada recurso
; madera => 1
; carbon vegetal => 3
; carbon => 3
; coque => 10