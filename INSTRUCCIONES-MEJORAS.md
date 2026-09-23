# Versión de revisión — Mandados Quirarte Araiza

## Cambios incluidos
- Acceso por correo: botón bloqueado durante el envío, espera entre solicitudes y mensajes comprensibles en español. Esto **no elimina** el límite de correos de Supabase: para uso real hay que configurar SMTP propio o revisar el plan/límites del proyecto.
- Catálogo: tarjetas visuales, filtros por categoría, contador de productos y ajustes para celular. **Las imágenes actuales son ilustraciones mediante emojis, no fotografías**. Para las fotos finales se requieren imágenes con derechos de uso o fotos propias; no se añadieron enlaces externos que puedan fallar.
- Migración de seguridad `supabase-schema-v7-security.sql`: impide que el cliente se otorgue permisos de administrador y limita cambios a pedidos y productos.

## Antes de publicar
1. Conserva un respaldo del proyecto y de la base de datos.
2. Instala dependencias y prueba `npm run build`.
3. Prueba el inicio de sesión y un pedido de principio a fin en una instancia de pruebas.
4. Ejecuta **solo** `supabase-schema-v7-security.sql` en Supabase SQL Editor tras revisar el respaldo y confirmar que ya se aplicaron los esquemas anteriores hasta v6. El archivo SQL no se ejecuta automáticamente al subir el ZIP.
5. Revisa que tu usuario administrador siga teniendo `is_admin=true` asignado desde SQL Editor.
6. Prueba captura y eliminación de tickets, estados, lista habitual, historial y un pedido nuevo.
7. Solo después integra los cambios en la rama principal para publicar en Vercel.

**Importante:** esta entrega es una versión de revisión de código. No se ha probado contra tu proyecto Supabase real ni se ha publicado.

## Segunda revisión: catálogo y validación
- Se añadió búsqueda de productos y opción de pasar un producto no encontrado a «Otros».
- Las tarjetas seleccionadas se distinguen visualmente y las cantidades usan controles numéricos.
- Antes de enviar se revisan cantidades inválidas y productos de «Otros» sin nombre.
- **Fotografías:** esta revisión no incluye fotos de terceros: no se contó con imágenes autorizadas ni con acceso de descarga fiable. Los íconos existentes se mantienen temporalmente.
- **Pendiente de verificar:** compilación en un entorno con dependencias instaladas, pruebas reales de Supabase y revisión visual en teléfono.

## Tercera revisión: borradores y protección contra pedidos duplicados
- El mandado se guarda automáticamente en el almacenamiento local del navegador mientras se prepara. No se sincroniza entre dispositivos y se borra al enviar correctamente.
- Al volver a entrar se recupera el borrador; una lista habitual o un pedido repetido tiene prioridad sobre el borrador anterior.
- Se rechazan cantidades negativas o iguales a cero cuando están escritas.
- Si falla el guardado de productos y tampoco se puede deshacer el pedido, se muestra una advertencia para evitar enviarlo de nuevo a ciegas.
- Se intentó instalar las dependencias para compilar, pero el comando excedió el tiempo disponible. **No se certifica una compilación ni pruebas reales de Supabase.**
- El envío de correo sigue sujeto a los límites de Supabase; configurar SMTP es una tarea separada.

## Cuarta revisión: revisión rápida del mandado
- Filtro «Ver solo mis productos» para comprobar lo que se ha agregado, sin recorrer todo el catálogo.
- Botón «Mostrar todo» para restablecer búsqueda, categoría y filtro.
- Cada producto adicional se puede eliminar individualmente.
- «Vaciar mandado» solicita confirmación antes de borrar la selección.
- Mensajes de error anunciados para tecnologías de asistencia y foco visible en botones.
- **Esta versión no se ha publicado ni probado contra Supabase real.** No se incluyen fotografías definitivas.
