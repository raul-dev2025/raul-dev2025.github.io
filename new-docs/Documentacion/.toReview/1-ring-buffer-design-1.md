[Diseño del anillo de búfer](#i1)
[Terminología utilizada](#i2)
[El anillo de búfer genérico](#i3)

[Referencias](#i88)
[Agradecimientos](#99)



Diseño del anillo de búfer
===============



[Terminología utilizada](i2)
---------------

`tail` -- Dónde las _nuevas escrituras_, suceden en el _anillo del búfer_.
`head` -- Dónde las _nuevas lecturas_, suceden en el _anillo del búfer_.
`producer` -- La tarea de escribir dentro del _anillo del búfer_ (igual que `writer`).
`writer` -- Igual que `producer`.
`consumer` -- La tarea de escribir desde el _búfer_ (igual que `reader`).
`reader` -- Igual que `consumer`.
`reader_page` -- Una página fuera del _anillo de búfer_, únicamente utilizada -mayor-
mente, por el `reader`.
`head_page` -- Puntero a la página, que el `reader` leerá en la próxima lectura.
`tail_page` -- Puntero a la página, que el `writer` escribirá en la próxima escritura.
`commit_page` -- Puntero a la página, con la última y finalizada, escritura no anidada.
`cmpxchg` -- Transacción _atómica_ asistida por _hardware_, que lleva a cabo lo
siguiente:
* `A = B` si previamente `A == C`.
* `R = cmpxchg(A, C, B)`, está diciendo que será reemplazado `A` por `B` si, y sólo 
_si_(condicional), el _presente_ `A` es igual a `C`, se pondrá el antiguo(presente)
`A` dentro de `R`.
* `R` obtiene el anterior `A`, en _función_ de _si_ `A` es actualizado con `B` o _no_.
* Para ver si la _actualización_, fué existosa, una comparación `R == C` podrá ser
usada.

[El anillo de búfer genérico](i3)
---------------

El _anillo de búfer_ puede ser utilizado en ambos casos; en _modo sobreescritura_, o
en _modo_ `producer/consumer`.

El _modo_`producer/consumer`es donde el `producer` estaba _rellenando el búfer_, antes
de que el `consumer` pudiese _liberar_ cualquier cosa. El `producer` dejará de escribir
en el búfer. Ésto perderá los _eventos_ más recientes.

El _modo sobreescritura_, sucede si el `producer` estaba rellenando el búfer, antes de
que el `consumer`, pudiese _liberar_ nada. El `producer` sobreescribirá los datos más
antiguos. Ésto perderá los _eventos_ más antiguos.

Dos `writer`s, no pueden escribir al mismo tiempo -_en el mismo búfer por CPU_, pero
un `writer` podrá interrumpit a otro `writer`, aunque deberá finaliar la escritura,
antes de que el previo `writer` pueda continuar. Ésto es muy importante, para el
_algoritmo_, El `writer` actúa como _pila(stack)_. La forma en que trabajan las
interrupciones, refuerzan su comportamiento.

`writer1 start
 <preempted> writer2 start
 <preempted> writer3 start
 writer3 finishes
 writer2 finishes
 writer1 finishes`

Ésto es mas como un `writer` es adelantado por la _interrupción_ y también como la
interrupción hace la escritura.

Los `reader`s pueden sucederse en cualquier momento. Pero dos `reader`s, no podrán
_correr_ al mismo tiempo, ni podrá un `reader` _adelantar/interrumpir_ a otro `reader`.
Un `reader` no podrá _adelantar/interrumpir_ a un `writer`, pero podrá _leer/usar_,
desde el búfer, al mismo tiempo que el `writer` esté escribiendo. El `reader` deberá
encontrase en otro _procesador_ para hacer esto. Un `reader` podrá leer en su própio
_procesador_, y también ser adelantado por el `writer`.

Un `writer` podrá adelantar a un `reader`. pero un `reader` no puede adelantar a un
`writer`. Sin embargo, un `reader` podrá leer el búfer al mismo tiempo -en otro proce -
sador, que un `writer.

El _anillo de búfer_ está constituido por una lista de páginas agrupadas por una lista
enlazada.

En la inicialización un `reader` de página, es asignado por el `reader` que no
pertenece al _anillo de búfer_.

La `head_page`, `tail_page`, y `commit_page`, son inicializados apuntando a la
misma página.

El `reader` de página, es inicializado para tener su siguiente _puntero_ apuntando al
`head` de página y, a su _puntero_ anterior, a la página antes de `head` de página.

El `reader` una página para su própio uso. Durante el inicio, esta página es asignada,
pero no adjuntada a la lista. Cuando el `reader` quiera leer desde el búfer, si su
página está vacía -como lo está durante el inicio, intercambiará su página, con la
`head_page`. El anterior `reader` de página,se convertirá en parte del anillo de
búfer y, el `head_page` será retirado.
La página después de la inserción de página -viejo `reader_page` será la nueva
`head` de página.

Una vez la nueva página, sea entregada al `reader`, el lector hará lo que él quiera
con ella, tan pronto como el `writer` haya dejado la página.

Un ejemplo de como el `reader` de página es intercambiado: nótese que ésto no muestra
el `head` de página en el anillo de búfer, únicamente es para demostrar el intercambio.

`esquema1`

Es posible que la página intercambiada sea la página entregada y lapágina `tail`,
si lo que está en el _anillo de búfer_ es menos, que lo que está soportadom en una
página de _búfer_.

`esquema2`

En este caso, es aún válido para el _algoritmo_.
Cuando el `writer` deja la página, símplemente se va dentro del anillo de búfer, hasta
que el lector de página, apunta la siguiente localización en el _anillo de búfer_.

Los punteros principales:

* `reader` de página -- La página únicamente utilizada por el `reader` que no es parte
del _anillo de buffer_ -podría intercambiarse dentro.
* `head` de página -- la siguiente página en el _anillo de búfer_ que sea intercambiada
con el lector de página.
* `tail`de página -- La página donde toma lugar, la siguiente escritura.
* `commit` de página -- la página que terminó por última vez una escritura.

La página de `commit` sólo es actualizada por el `writer` más alejado en la pila de
`writer`s. Una escritura que adelanta a otra escritura, no moverá la página cometida.

Cuando los datos son escritos al `anillo de búfer`, es reservada una posición en el
mismo y, traspasado al `writer`. Cuando la escritura termina de escribir los datos
en esa posición, acomete la escritura.

Otra escritura -o lectura, podrá tomar lugar en cualquier momento, durante su
transacción. Si sucede otra escritura, debe finalizar antes de continuar con la 
escritura anterior.

`esquema3`

El puntero de `commit` apunta a última localización de escritura, que fué acometida
sin adelantar a otra escritura. Cuando una escritura _adelanta_ a otra, únicamente
aparecerá como pendiente, y no será _cometida_, hasta que hayan sido realizadas todas 
las escrituras.

La página de consignación(_commit_) apunta a la página donde fue realizado el último 
_commit_. La página `tail` apunta a la página con la última escritura -antes de 
acomenterla.

El orden de páginas es:

		pagina head
		pagina commit
		pagina tail
		
Escenario posible:

`esquema4`

Hay un caso especial, en el que la página `head`, pueda encontrarse detrás de la página
`commit` y de la página `tail`. Sucede cuando las páginas `commit` -y `tail`, han sido
intercambiadas con la página `reader`. Ésto es por que la página `head` es siempre
parte del _anillo de búfer_, pero la página `reader` no. Siempre que la página cometida
haya sido menos que la página cometida en el _anillo de búfer_, y un `reder` haya 
intercambiado la página, intercambiará la página `comit`.

`esquema5`

En éste caso, la página `head`, no será movida cuando `tail` y `commit` sean movidos de
vuelta a _anillo de búfer_.

El `reader` no puede cambiar a la página dentro del búfer, si la página `mcommit` 
continua en _esa_ página. Si la _lectura_, encuentra el último `commit` -_commit_ real
no pendiente o reservado, entonces no habrá nada más que leer.
El búfer es considerado _vacío_, hasta que otro _commit_ finalice.

Cuando `tail` encuentre la págian `head`, si el búfer está en modo _msobreescritura_,
la página `head`, será adelantada una vez. Si el búfer, se encuentra en modo
`producer/consumer`, la _escritura_ fallará.

Modo sobreescritura:

`esquema6`

__noata,__ la página `reader` seguirá apuntando a la página _anterior_ `head`.
Pero cuando tenga lugar un intercambio,, utilizará una página `head` más reciente.

#### "Desbloqueando" el anillo de búfer ####

La idea, detrás del _algoritmo_ de "desbloqueo(lockless)", es combinar el movimiento
del puntero de `head_page` intercambiando la página con el `reader`.
La _banderas de estado[f1]_, son colocados dentro del puntero a la página. Para hacer
ésto, cada página debe estar alineada en memoria, con _4 byttes_. Ésto permitirá a los
_2 bits_ menos significativos de la dirección, ser usados como "bandera", ya que 
siempre serán cero en la dirección. Para obtener la dirección, simplemente habrá que
desmarcar dicha _bandera_.

		MASK = ~3
		address & MASK
		
Las dos _banderas_ serán guardas, por estos dos _bits_:

	HEADER -- la página siendo apuntada, es la página `head`.
	UPDATE -- la página siendo apuntada, está siendo actualizada por el `writer` 
	-será o va a ser, la pagina `head`.
				

`esquema7`

El puntero de arriba, "-H->" tendría la bandera `HEADER` configurada. Así que la 
siguiente página es la página próxima(más cercana), para ser intercambiada por el
`reader`.

Cuando la página `tail`, encuentra el puntero `head`, utilizará `cmpxchg` para cambiar
el puntero al estado ACTUALIZAR(UPDATE):

`esquema8`

"-U->" representa al puntero en estado `UPDATE`.

Cualquier acceso al `reader`, necesitará usar algún tipo de _bloqueo_, par _serializar_
los `reader`s. Pero los `writer`s, nunca utilizarán un _bloqueo_, para escribir en el
_anillo de búfer_. Ésto significa que, no es necesario preocuparse por un único
`reader`, y las escrituras sólo adelantarán en formación de _pila(stack)_.

Cuando un `reader` intenta intercambiar la página con el _anillo de búfer_, también
usará `cmpxchg`. Si la bandera de _bit_, en el puntero de la página `head`, no tiene
configurado la bandera `HEADER`, la comparación fallará, y el `reader` necesitará
mirar a la nueva página `head` e intentarlo de nuevo.

El lector intercambia la página `reader`, cómo sigue:

`esquema9`


El lector configura el siguiente puntero de la página `reader`, cómo CABECERA(`HEADER`)
detrás de la página `head`.

`esqquema10`

Hace un `cmpxchg`(comparación/cambio?), con el puntero a laprevia página `head`,
para hacerla apuntar a la página `reader`. Nótese, que el nuevo puntero, no tiene 
la _bandera_ `HEADER` configurada. Ésta acción _atómica_, mueve la página `head` hacia
delante.

`esqquema11`

Después de ser configurada la nueva página `head`, el puntero anterior de la página
`head`, es actualizado a la página `reader`.

`esqquema12`

Otro punto importante: la página a la que vuelve a apuntar la página `reader` por su
previo puntero, -la que ahora apunta a la nueva página `head`, nunca volverá a aapuntar
a la página `reader`. Ésto es por que la página `reader` no es parte del anillo de 
búfer. Atravesar el anillo de búfer, vía _siguiente_ puntero, siempre permanecerá en el
_anillo_. Atravesar el anillo de búfer, vía _previo_ puntero, puede que no.

Nótese que la mforma de determinar una página `reader`, es simplemente examinandoel
puntero anterior de la página. Si el siguiente puntero de la página anterior, no apunta
de nuevo a la página original, entonces la página original es la página `reader`.

`esquema13`

La forma en qque la página `head`, se mueve hacia delante:

Cuando la página `tail`, enccuentra a la página `head` y, en búfer se encuentra en modo
sobreescritura, y tienen lugar otras _escrituras_, la página `head` debe moverse hacia
delante antes de que el `writer` pueda mover la página `tail`. La foma en que ésto se
realiza es permitiendo que el `writer` lleve a cabo un `cmpxchg` para convertir el 
puntero a la página `head` con la _bandera_ `HEADER`, cambiándole la _bandera_ a
`UPDATE`. Una vez esté hecho esto, el _lector_, no será capaz de intercambiar la página
`head`, desde el búfer, así como tampoco mover la página `head`, hasta que el `writer`
finalice la tarea.

Ésto elimina cualquier trabajo que el `reader` pueda tener sobre el `writer`. El
`reader` deberá _acelerar_, por esta razón el `reader` no podrá _adelantar_ al `writer`.

`esquema14`


La siguiente página, se llevará a término en la nueva página `head`.

`esquema15`

Después de haber sido configurada la nueva página `head`, podrá configurarse el
_antiguo_ puntero de la página `head` a la normalidad.

`esquema16`

Tras mover la página `head`, la página `tail` no podrá moverse adelante.

`esquema17`

Arriba se muestran actualizaciones _triviales_. A partir de ahora, se mostrarán
escenarios más complejos.

Como se indicó anteriormente, si las suficientes _escrituras_, adelantan a la primera,
la página `tail`, podrá hacer todo el camino alrededor del búfer y, _cometer_ la
página. En éste punto, se deberán realizar _escrituras_ -normalmente con algún tipo de
aviso al usuario. Pero ¿qué sucede si _lo cometido_ continuase en la págian `reader`?
La página `commit` no es parte del anillo búfer. La página `tail` debe contar con esto.

`esquema18`

Si la página `tail`, tuviese que simplemente empujar la página `head` hacia delante,
cuando el `commit` dejase la página `reader`, no apuntaría a la página correcta.

La solución a ésto, es probar si la página `commit` continua en la página `reader`,
antes de _empujar_ la página `head`. Si es así, entonces se podrá asumir que la página
`tail` _wrapped the buffer_ , y se deberán realizar nuevas _escrituras_.

Ésto no es una condición de carrera, por que la página `commit` sólo puede ser movida
por el `writer` más alejado -el `writer` adelantado.
Ésto significa que el `commit` no se moverá, hasta que el `writer` mueva la página
`tail`. El lector no puede intercambiar la página `reader` si también está siendo
utilizado por la página `commit`. El _lector_ podrá únicamente comprobar si el `commit`
está fuera de la página `commit`. Una vez la página `commit` deje la página `reader`
no volverá nunca atrás, a menos que el `reader`, haga otro intercambio con la página de
búfer, que también es la página `commit`.

#### Escrituras anidadas ####

Cuando se _empuja_ adelante la página `tail`, primero debe adelantarse la página
`head`, si ésta es la siguiente página. Si la página `head` no es la siguiente, la
página `tail` simplemente será actualizada con `cmpxchg`.

Únicamente los `writers moverán la página `tail`. Ésto se hace automáticamente para
proteger _escrituras anidadas_.

		temp_page = tail_page
		next_page = temp_page->next
		cmpxchg(tail_page, temp_page, next_page)

Arriba se muestra la actualización de la página `tail`, si aún continúa apuntando a la
página esperada. Si esto falla, se empujará adelante una _escritura anidada_, la
escritura en curso, no necesitará hacerlo.

`esquema19`

Actúa la _escrituras anidada_, moviendo la página `tail` hacia adelante.

`esquema20`

The above would fail the cmpxchg, puesto que la página `tail`, ha sido movida hacia
delante, el `writer` intentará reservar estacio otra vez, en la nueva página `tail.

Mover la página `head`, es algo más complicado.

`esquema21`

La escritura convierte el puntero de la página `head` a `UPDATE`.

`esquema22`

Si un `writer` _anidado_ adelanta aquí, verá que la página siguiente es la página
`head` también está _anidada_, lo detectará y guardará la información. La detección
consiste, de hecho, en ver la _bandera_ `UPDATE` en lugar de un puntero `HEADER` o
`NORMAL`.

El `writer` _anidado_, establecerá el nuevo puntero de la página `head`.

`esquema23`

Pero no _reseteará_ la actualización de vuelta a _lo normal_. Sólo el `writer` que 
convirtió el puntero de `HEAD` a `UPDATE` lo convertirá otra vez a `NORMAL`.

`esquema24`

Después de que el `writer` anidado termine, el más alejado de ellos, convertirá el
puntero `UPDATE` a `NORMAL`.

`esquema25`

Podría ser aún más complicado, si suceden distintas _escrituras anidadas_ y, mueven la
pámgina `tail` _por encima_ de otras páginas:

(primer `writer`)

`esquema26`

La escritura convierte el puntero de la página `head` a `UPDATE`.

`esquema27`

El siguiente `writer` _actúa_, y vé la actualización, estableciendo la nueva página
`head`.

(segundo `writer`)

`esquema28`
 
El `writer` anidado, mueve la página `tail` hacia delante. Pero no establece la
_antigua_ actualización de página a `NORMAL`, por que no es el `writer` más alejado.

(tercer `writer`)

`esquema29`

El `writer` moverá la página `head` hacia delante:

(tercer `writer`)

`esquema30`

El tercer `writer` que hizo el cambió de la _bandera_ `HEAD` a `UPDATE`, cambiará a
normal:

(tercer `writer`)

`esquema31`

Moverá entonces la página `tail`, y retornará al segundo `writer`

(segundo `writer`)

`esquema32`

El segundo `writer` fallará al mover la página `tail`, por que ya había sido movido,
así que lo intentará de nuevo, añadiendo _sus datos_ a la nueva página `tail`.
Retornará al primer `writer`.

(primer `writer`)

`esquema33`

El primer `writer`, no puede saber automáticamente si la página `tail`, fue movida
mientra actualizó a `HEAD` en la página.

(primer `writer`)

`esquema34`

Puesto que `cmpxchg` devuelve el anterior valor del puntero, el primer `writer` verá
si ha tenido éxito, al actualizar el puntero de `NORMAR` a `HEAD`.
Podrá verse, que esto aún no es suficiente. También deberá comprobar si la página
`tail` _está en su lugar_:

(primer `writer`)

`esquema35`

Si la página `tail` `!= A` y página `tail` `!= B`, entonces debe _resetear_ el puntero
de nevo a `NORMAL`. De hecho, no necesita preocuparse por `writers` _anidados_, 
significando esto, que únicamente necesita comprobarlo después de establecer el `HEAD`
de página.

(primer `writer`)

`esquema36`

puede ahora el `writer`, acutalizar la página `head`. Por esta misma razón, la página
`head` deberá permanecer en `UPDATE` y, únicamente _resetear_ el `writer` más alejado.
Previniendo esto último, que el _lector_ vea la página `head` incorrecta.

(primer `writer`)

`esquema37`


***************

[Referencias](i88)

_nota d.t._ __atómica:__ que la operación no se detendrá, hasta que haya completado.

_nota d.t._ __buffer:__ la traducción literal es _almacén_, sin embargo, es un término
muy utilizado en programación, para referirnos a una parte de la maquinaría o del
código de programa, de un computador.

[f1]_banderas de estado_, __state flags__: argumentos o parámetros. ejem. `ls -l`. Una
especie de "tecla vinculada" en éste caso al comando _listar(ls)_.

***************

[Agradecimientos](i99)


_Copyright 2009 Red Hat Inc._
 __Author:__ Steven Rostedt <srostedt@redhat.com>
__License:__ The GNU Free Documentation License, Version 1.2
 (dual licensed under the GPL v2)
__Reviewers:__ Mathieu Desnoyers, Huang Ying, Hidetoshi Seto,
	 and Frederic Weisbecker.
__Traductor:__ Heliogabalo S. J.


_Written for: 2.6.31_
