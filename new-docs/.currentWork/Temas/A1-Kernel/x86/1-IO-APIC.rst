- `IO-APIC <#i1>`__
- `Referencias y agradecimientos <#i99>`__

IO-APIC
=======

| La mayoría(todas) de placas *Intel-MP* compatibles con SMP, tienen el
  llamado ``IO-APIC``,
| que es un controlador de interrupciones *mejorado*. Permite activar el
  *enrutado* de
| interrupciones del *hardware*, sobre múltiples CPUs o, un grupo de
  CPUs.
| Sin el ``IO-APIC``, las interrupciones desde el *hardware*, serían
  entregadas a una CPU
| únicamente, desde la que arranca el sistema operativo; habitualmente
  ``CPU#0``.

| Linux soporta *todas* las variantes de placas compatibles con SMP,
  incluyendo aquellas
| con múltiples ``IO-APIC``\ s. Múltiples ``IO-APIC``\ s, son utilizadas
  en servidores de alta
| gama, para distribuir la *carga de interrupciones*.

| Son conocidas *ciertas* incompatibilidades, en placas más antiguas.
  Algunos de estos
| errores, son gestionados por el *kernel*. Si la placa compatible con
  SMP, no arranca
| *Linux*, es recomendable la lista de correo **linux-smp**, en primer
  lugar.

::

        ---------------------------->
       hell:~> cat /proc/interrupts
                  CPU0
         0:    1360293    IO-APIC-edge  timer
         1:          4    IO-APIC-edge  keyboard
         2:          0          XT-PIC  cascade
        13:          1          XT-PIC  fpu
        14:       1448    IO-APIC-edge  ide0
        16:      28232   IO-APIC-level  Intel EtherExpress Pro 10/100 Ethernet
        17:      51304   IO-APIC-level  eth0
       NMI:          0
       ERR:          0
       hell:~>
       <----------------------------

| Algunas interrupciones son listadas como ``XT PIC``, pero ésto no es
  un problema; ninguna
| de esas interrupciones fuentes IRQs denotan rendimiento crítico.

| En caso de que la placa, no haya creado una correcta *tabla mp*, podrá
  utilizarse el
| parámetro de arranque ``pirq=`` para construir a mano, las entradas
  IRQ. Nada trivial,
| puesto que no puede ser automatizado. Un ejemplo de *entrada* en
  ``/etc/lilo.conf``:

::

       append="pirq=15,11,10"
       

| Los *miembros* concretos, dependen del *sistema*, de las tarjetas PCI
  y, de las posi-
| ciones de sus zócalos. Generalmente, los zócalos de las PCI, están
  *encadenados* antes
| de ser conectados a la instalación enrutada, del conjunto de chips IRQ
  del PCI(líneas de
| entrada ``PIRQ1-4``) ``bloodyMary-bloodyMary-bloodyMary``:

::

              ,-.        ,-.        ,-.        ,-.        ,-.
    PIRQ4 ----| |-.    ,-| |-.    ,-| |-.    ,-| |--------| |
              |S|  \  /  |S|  \  /  |S|  \  /  |S|        |S|
    PIRQ3 ----|l|-. `/---|l|-. `/---|l|-. `/---|l|--------|l|
              |o|  \/    |o|  \/    |o|  \/    |o|        |o|
    PIRQ2 ----|t|-./`----|t|-./`----|t|-./`----|t|--------|t|
              |1| /\     |2| /\     |3| /\     |4|        |5|
    PIRQ1 ----| |-  `----| |-  `----| |-  `----| |--------| |
              `-'        `-'        `-'        `-'        `-'

| Cada tarjeta PCI, emite un IRQ PCI(interrupción PCI), que pueden ser
  ``INTA``, ``INTB``,
| ``INTC``, ``INTD``:

::

                              ,-.
                        INTD--| |
                              |S|
                        INTC--|l|
                              |o|
                        INTB--|t|
                              |x|
                        INTA--| |
                              `-'

| Éstas ``INTA-D`` PCI IRQs, son siempre “locales a la tarjeta”
  -específicas para la card,
| su significado *real*, depende del zócalo de la misma. Mirando al
  diagrama *encadenado*
| de la tarjeta, en el **zócalo 4**; está utilizando el ``INTA`` como
  señal en ``PIRQ4`` del
| conjunto de chips PCI. La mayoría de tarjetas, utilizan ``INTA``, ésta
  créa una distri-
| bución optima, entre las líneas PIRQ. La distribución de las fuentes
  de interrupción
| apropiadas, *no es una necesidad*. Las PCI IRQs, pueden compartirse
  sin mas. Aunque por
| rendimiento, es mejor no compartir interrupciones. El *zócalo 5* debe
  ser usado para
| video-tarjetas -como norma general, ya que no utilizan las
  interrupciones normalmente,
| tampoco están encadenadas(daisy chained).

| Así, contando con una tarjeta SCSI (IRQ11) en el *zócalo 1*, tarjeta
  Tulip (IRQ9) en
| *zócalo 2*, deberá especificarse ésta línea ``pirq=``:

::

       append="pirq=11,9"
       

| El siguiente *script*, trata de averiguar la línea ``pirq=`` por
  defecto, desde la confi-
| guración PCI:

::

       echo -n pirq=; echo `scanpci | grep T_L | cut -c56-` | sed 's/ /,/g'

..

   ver `[f1] <#f1>`__ sobre ``scanpci`` y ``lscpi`` y
   ``/proc/interrupts``

| El anterior *script* no funcionará, si fueron omitidos algunos
  zócalos, si la tarjeta
| no realiza el *encadenado(daisy chain)* por defecto o, si el
  ``IO-APIC`` tiene los pins
| ``PIRQ`` conectados de forma estraña. Ejemplo, si en el caso de arriba
  la tarjeta ``SCSI``
| (IRQ11) se encuentra en el *zócalo 3* y, el *zócalo 1* está vacio:

::

       append="pirq=0,9,11"
       

..

   El valor ``0`` es un *marcador de posición(placeholder)* genérico.
   Reservado para zócalos vacios -o IRQ, sin emitir señal.

| Generalmente, es posible encontrar la configuración correcta para
  ``pirq=``, sólo hay que
| *permutar* los números IRQ apropiadamente … probablemente tomará algún
  tiempo. Una línea ``pirq`` incorrecta, que el proceso de arranque se
  *cuelgue* o, que cierto dis-
| positivo deje de funcionar apropiadamente, *ejem. si es insertado como
  módulo*.

| Con dos *buses PCI*, podrán utilizarse **hasta** ``8`` valores
  ``pirq``, a pesar de que
| este tipo de placas, tiendan a tener una configuración *correcta*.

Habrá que estar preparado, puesto que podría ser necesario una línea
``pirq`` estraña:

::

       append="pirq=0,0,0,0,0,0,9,11"
       

| Practica una inteligente técnica de *prueba y error*, para encontrar
  la línea correcta
| ``pirq``.

| Buena suerte y si aparecen problemas no cubiertos en éste documento,
  utiliza
| éstos buzones linux-smp@vger.kernel.org linux-kernel@vger.kernel.org.

--------------

Referencias y agradecimientos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[f1] **nota:** - ``scanpci`` - ``lspci`` - ``/proc/interrupts``

**Autor:** mingo
