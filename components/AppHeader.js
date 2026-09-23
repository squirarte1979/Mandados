'use client';
import {useRouter} from 'next/navigation';
import Brand from './Brand';
export default function AppHeader({title,back=false}){const router=useRouter();return <header className="appHeader">{back&&<button className="iconBtn" onClick={()=>router.back()} aria-label="Regresar">←</button>}<Brand compact/><div className="headerSpacer"/>{title&&<span className="headerTitle">{title}</span>}</header>}
