[Empleo de RCU, para proteger listas enlazadas](#i1)
[Sumario](#i2)
[Referencias y agradecimientos](#i99)
---


### [Empleo de RCU, para proteger listas enlazadas](i1) ###

[f1](#f1)
Una de las mejores aplicaciones de RCU, consiste en la protección de la mayoría de listas enlazadas -`struct` `list_head` en `list.h`. La ventaja de esta aproximación, es que todas las barreras de memoria, son incluidas de forma automática, en la lista de macros. Este documento describe distintas aplicaciones RCU, empezando por la que mejor se adapta.

Ejemplo 1: ciclo de lectura, tomado desde fuera del bloqueo, _actualizaciones fuera de lugar_.

Las mejores aplicaciones en estos casos, donde si el bloqueo de _lectura-escritura_ es utilizado, el bloqueo en el ciclo de lectura, será desestimado antes de tomar una acción basada en los resultados de la búsqueda. El ejemplo más representativo, es la _tabla de ruta_. Por que la tabla de ruta, sigue el estado del _equipo_ fuera de la computadora; contendrá los datos que quedaron fuera.
A pesar de esto, una vez la ruta ha sido computada, no hay necesidad de mantener la tabla de ruta estática, durante la transmisión del paquete. Después de todo, es posible mantener la tabla de ruta estática, todo lo necesario, pero no será posible guardar la _Internet_ externa, del cambio. Es el estado de la _Internet_ externa lo que importa. En adición, las entradas de ruta son habitualmente añadidas o retiradas, en lugar de ser modificadas _in situ_.

Un ejemplo exclarecedor del empleo de RCU, podrá encontrarse mediante el soporte de auditoría a la _llamada de sistema_. Por ejemplo, la implementación de un bloqueo _lectura-escritura_ de `audit_filter_task()`, podría ser como sigue:

		static enum audit_state audit_filter_task(struct task_struct *tsk)
		{
			struct audit_entry *e;
			enum audit_state   state;

			read_lock(&auditsc_lock);
			/* Note: audit_netlink_sem held by caller. */
			list_for_each_entry(e, &audit_tsklist, list) {
				if (audit_filter_rules(tsk, &e->rule, NULL, &state)) {
					read_unlock(&auditsc_lock);
					return state;
				}
			}
			read_unlock(&auditsc_lock);
			return AUDIT_BUILD_CONTEXT;
		}

La lista aquí, es buscada através del bloqueo, pero el bloqueo es desestimado antes del correspondiente valor de retorno. En el tiempo en que el valor es aceptado, la lista podría haber sido modificada. Esto tiene sentido, al apagar la _auditoría_; es correcto auditar ciertas _llamadas de sistema_.

Significa que RCU, puede ser aplicado en el ciclo de lectura, como sigue:

		static enum audit_state audit_filter_task(struct task_struct *tsk)
		{
			struct audit_entry *e;
			enum audit_state   state;

			rcu_read_lock();
			/* Note: audit_netlink_sem held by caller. */
			list_for_each_entry_rcu(e, &audit_tsklist, list) {
				if (audit_filter_rules(tsk, &e->rule, NULL, &state)) {
					rcu_read_unlock();
					return state;
				}
			}
			rcu_read_unlock();
			return AUDIT_BUILD_CONTEXT;
		}

Las llamadas `read_lock()` y `read_unlock()` han sido convertidas a `rcu_read_lock()` y `rcu_read_unlock()`, respectivamente, la `list_for_each_entry()` ha sido convertida a `list_for_each_entry_rcu()`. La macro `_rcu()` de primitivas transversales, inserta la barrera de memoria en el ciclo de lectura, que es requerida en _DEC Alpha CPUs_.

Los cambios en el ciclo de actualización son esclarecedores. Un bloqueo _lectura-escritura_, podría utilizarse como sigue, para el borrado de una inserción:

		static inline int audit_del_rule(struct audit_rule *rule,
						 struct list_head *list)
		{
			struct audit_entry  *e;

			write_lock(&auditsc_lock);
			list_for_each_entry(e, list, list) {
				if (!audit_compare_rule(rule, &e->rule)) {
					list_del(&e->list);
					write_unlock(&auditsc_lock);
					return 0;
				}
			}
			write_unlock(&auditsc_lock);
			return -EFAULT;		/* No matching rule */
		}

		static inline int audit_add_rule(struct audit_entry *entry,
						 struct list_head *list)
		{
			write_lock(&auditsc_lock);
			if (entry->rule.flags & AUDIT_PREPEND) {
				entry->rule.flags &= ~AUDIT_PREPEND;
				list_add(&entry->list, list);
			} else {
				list_add_tail(&entry->list, list);
			}
			write_unlock(&auditsc_lock);
			return 0;
		}

A continuación, las equivalencias RCU para estas dos funciones:

		static inline int audit_del_rule(struct audit_rule *rule,
						 struct list_head *list)
		{
			struct audit_entry  *e;

			/* Do not use the _rcu iterator here, since this is the only
			 * deletion routine. */
			list_for_each_entry(e, list, list) {
				if (!audit_compare_rule(rule, &e->rule)) {
					list_del_rcu(&e->list);
					call_rcu(&e->rcu, audit_free_rule);
					return 0;
				}
			}
			return -EFAULT;		/* No matching rule */
		}

		static inline int audit_add_rule(struct audit_entry *entry,
						 struct list_head *list)
		{
			if (entry->rule.flags & AUDIT_PREPEND) {
				entry->rule.flags &= ~AUDIT_PREPEND;
				list_add_rcu(&entry->list, list);
			} else {
				list_add_tail_rcu(&entry->list, list);
			}
			return 0;
		}

Normalmente, la `write_lock()` y `write_unlock()` serán reemplazadas por `spin_lock()` y `spin_unlock()`, pero en tal caso, todas la _llamadas_ mantedrán `audit_netlink_sem`, por lo que no serán necesarios bloqueos adicionales. `auditsc_lock` podrá, por lo tanto, ser eliminado, ya que RCU _elimina_ la necesidad de que los _escritores_ excluyan a _lectores_.
Llamadas `write_lock()` serán convertidas en llamadas `spin_lock()`.

Las primitivas `list_del()`, `list_add()`, y `list_add_tail()`, han sido reemplazadas por `list_del_rcu()`, `list_add_rcu()`, y `list_add_tail_rcu()`. La lista manipuladora de primitivas `_rcu()`, añade barreras de memoria necesarias, en CPUs _débilmente_ ordenadas -la mayoría de ellas. La primitiva `list_del_rcu()` omite el puntero que "envenena", el código de depuración asistida, que de otra forma ocasionaría a _lectores_ concurrentes, un fallo espectacular.

Cuando _lectores_, pueden tolerar datos excedidos y las entradas, son tanto añadidas como borradas, sin una modificación en el lugar, resulta fácil el uso de RCU.

Ejemplo 2: manipulado de actualizaciones _in situ_.

El código de auditoría para las llamadas de sistema, no actualiza las reglas de auditoría en su loacalización. Aunque si lo hacen, el código de bloqueo de _lector-escritor_ podría ser parecido a lo siguiente. Al campo `field_count` únicamente le está permitido decrecer, de cualquier otra forma, los campos añadidos deberá ser definidos:

		static inline int audit_upd_rule(struct audit_rule *rule,
						 struct list_head *list,
						 __u32 newaction,
						 __u32 newfield_count)
		{
			struct audit_entry  *e;
			struct audit_newentry *ne;

			write_lock(&auditsc_lock);
			/* Note: audit_netlink_sem held by caller. */
			list_for_each_entry(e, list, list) {
				if (!audit_compare_rule(rule, &e->rule)) {
					e->rule.action = newaction;
					e->rule.file_count = newfield_count;
					write_unlock(&auditsc_lock);
					return 0;
				}
			}
			write_unlock(&auditsc_lock);
			return -EFAULT;		/* No matching rule */
		}

La versión RCU, crea una copia, actualiza la copia. Luego reemplaza la entrada _antigua_ con la entrada actualizada. La secuencia de acciones, permite lecturas concurrentes, mientras se lleva a cabo una actualización efectiva. Es lo que da nombre a RCU; _read-copy update_. El código RCU, es como sigue:

		static inline int audit_upd_rule(struct audit_rule *rule,
						 struct list_head *list,
						 __u32 newaction,
						 __u32 newfield_count)
		{
			struct audit_entry  *e;
			struct audit_newentry *ne;

			list_for_each_entry(e, list, list) {
				if (!audit_compare_rule(rule, &e->rule)) {
					ne = kmalloc(sizeof(*entry), GFP_ATOMIC);
					if (ne == NULL)
						return -ENOMEM;
					audit_copy_rule(&ne->rule, &e->rule);
					ne->rule.action = newaction;
					ne->rule.file_count = newfield_count;
					list_replace_rcu(&e->list, &ne->list);
					call_rcu(&e->rcu, audit_free_rule);
					return 0;
				}
			}
			return -EFAULT;		/* No matching rule */
		}

De nueve, es asumido que la llamada mantiene `audit_netlink_sem`. Normalmente, el bloqueo _lector-escritor_, sería convertido en un _acelerador de bloqueo_, con esta suerte de códgo.

Ejemplo 3: Eliminación de datos excedidos.

Los ejemplos de auditoría -arriba, toleran la excedencia de datos, como la mayoría de algoritmos, que siguen el estado externo. Por que hay _una espera_, desde el momento en que _estado externo_ cambia, antes que Linux, advierta el cambio; la excedencia adicional inducida en RCU, no es ningún problema.

En cualquier caso, existen muchos ejemplos donde los datos excedidos, no son tolerados.
Un ejemplo en el kernel de Linux, es el Sistema V IPC. Ver la función `ipc_lock()` en `/ipc/util.c`. Este código comprueba una opción de _borrado_, bajo una entrada _individual?_ del acelerador de bloqueo y, si la opción _borrado_, es configurada, significa que la entrada no existe. 
Para que esto sea de ayuda, la función de busqueda debe retornar, manteniento el acelerador de bloqueo selectivo, como `ipc_lock()` de hecho lo hace.

_Pregunta rápida_: ¿Por qué la función de búsqueda, necesita retornar, manteniento el acelerador de bloqueo selectivo, con la técnica de la opción de _borrado_, par que sea de ayuda?

Si el módulo de auditoría de la llamada de sistema, tuviese la necesidad de rechazar los datos excedidos, para conseguirlo, debería añadir la opción _borrado_ y un  acelerador de bloqueo, bloqueado, a la estructura `audit_entry` y, modificar `audit_filter_task()`, como sigue:

		static enum audit_state audit_filter_task(struct task_struct *tsk)
		{
			struct audit_entry *e;
			enum audit_state   state;

			rcu_read_lock();
			list_for_each_entry_rcu(e, &audit_tsklist, list) {
				if (audit_filter_rules(tsk, &e->rule, NULL, &state)) {
					spin_lock(&e->lock);
					if (e->deleted) {
						spin_unlock(&e->lock);
						rcu_read_unlock();
						return AUDIT_BUILD_CONTEXT;
					}
					rcu_read_unlock();
					return state;
				}
			}
			rcu_read_unlock();
			return AUDIT_BUILD_CONTEXT;
		}


> __Nota__: este ejemplo asume que la entradas, son añadidas y borradas, únicamente.
> Es necesario un mecanismo adicional, capaz de trabajar correctamente con acciones de actualización, llevadas a cabo por `audit_upd_rule()`. Por éste motivo?, `audit_upd_rule()` tendría la necesidad de barreras adicionales, para asegurar que `list_add_rcu()`, fuese realmente ejecutado antes que `list_del_rcu()`.

La función `audit_del_rule()` tendría que establecer la opción _borrado_, bajo el _acelerador de bloqueo_, como sigue:

		static inline int audit_del_rule(struct audit_rule *rule,
						 struct list_head *list)
		{
			struct audit_entry  *e;

			/* Do not need to use the _rcu iterator here, since this
			 * is the only deletion routine. */
			list_for_each_entry(e, list, list) {
				if (!audit_compare_rule(rule, &e->rule)) {
					spin_lock(&e->lock);
					list_del_rcu(&e->list);
					e->deleted = 1;
					spin_unlock(&e->lock);
					call_rcu(&e->rcu, audit_free_rule);
					return 0;
				}
			}
			return -EFAULT;		/* No matching rule */
		}


### [Sumario](i2) ###

La mayoría de lecturas basadas en listas de estructura de datos, que toleran el exceso de datos excedidos, transigen con el uso de RCU. El caso más simple, es donde las entradas son tanto añadidas como borradas de la estructura de datos -o modificadas de forma atómica, en el lugar. Pero modificaciones _no atómicas_, podrán ser gestionadas por medio de una copia, actualizando la copia y, reemplazando entonces, el original con la copia.
Si los datos excedidos, no pudiesen ser tolerados, entonces la opción _borrado_, podría utilizarse en conjunción con el acelerador de bloqueo por entrada, con objeto de permitir a la función de búsqueda, rechazar datos recientemente borrados.

Respuesta a la _pregunta rápida_
¿Por qué la función de búsqueda, necesita retornar, manteniento el acelerador de bloqueo selectivo, con la técnica de la opción de _borrado_, par que sea de ayuda?

Si la función de búsqueda, deshecha el bloqueo por entrada antes de retornar, entonces la llamada procesará los datos escedidos en cualquier caso. Si realmente es correcto procesar los datos excedidos, entonces no hay necesidad de la opción _borrado_. Si representa un problema su procesado, será necesario mantener un bloqueo por entrada, en todo el código que utilize los valores de retorno.


### [Referencias y agradecimientos](i99) ###

> [f1](f1) __n. de t.__: el presente documento es objeto de estudio, cualquier daño o perjudicio derivado de la __mala interpretación__ del mismo, eximirá al autor de consecuencias adversas. Peligro. Seguir leyendo bajo su própia responsabilidad.

Atómicas, no divisibles, que no podrán ser pausadas hasta su finalización.
