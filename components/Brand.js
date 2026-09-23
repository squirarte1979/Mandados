'use client';
import Image from 'next/image';
// Siempre usa el archivo original del proyecto: sin recortes ni reinterpretaciones.
export default function Brand({compact=false}){
  return <Image className={compact?'brandLogo brandLogoCompact':'brandLogo'} src="/logo-mandados.png" alt="Mandados Quirarte Araiza" width={520} height={390} priority />;
}
