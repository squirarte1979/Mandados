'use client';
import Image from 'next/image';
export default function Brand({compact=false}){
  if(compact) return <div className="brandCompact"><div className="cartMark"><Image src="/logo-mandados.png" alt="Mandados" width={240} height={180} priority /></div><strong>MANDADOS</strong></div>;
  return <Image className="brandLogo" src="/logo-mandados.png" alt="Mandados Quirarte Araiza" width={520} height={390} priority />;
}
