'use client';
import {useEffect,useState} from 'react';
import {supabase} from '../../lib/supabase';
import Brand from '../../components/Brand';

const WAIT_SECONDS=60;
export default function Login(){
 const[email,setEmail]=useState('');const[msg,setMsg]=useState('');const[busy,setBusy]=useState(false);const[remaining,setRemaining]=useState(0);
 useEffect(()=>{const until=Number(sessionStorage.getItem('mandadosEmailCooldown')||0);setRemaining(Math.max(0,Math.ceil((until-Date.now())/1000)));},[]);
 useEffect(()=>{if(!remaining)return;const timer=setTimeout(()=>setRemaining(Math.max(0,Math.ceil((Number(sessionStorage.getItem('mandadosEmailCooldown')||0)-Date.now())/1000))),1000);return()=>clearTimeout(timer)},[remaining]);
 const send=async(e)=>{e.preventDefault();if(busy||remaining)return;setBusy(true);setMsg('Solicitando tu enlace…');
 try{const{error}=await supabase.auth.signInWithOtp({email:email.trim().toLowerCase(),options:{emailRedirectTo:location.origin+'/cuenta'}});
 if(error){const rate=/rate limit|too many|429/i.test(error.message||'');if(rate){const until=Date.now()+5*60*1000;sessionStorage.setItem('mandadosEmailCooldown',String(until));setRemaining(300);setMsg('El servicio de correo alcanzó temporalmente su límite. Espera unos minutos antes de volver a intentarlo. No es necesario crear otra cuenta.');}else setMsg('No pudimos enviar el enlace. Verifica tu correo e inténtalo más tarde.');return}
 const until=Date.now()+WAIT_SECONDS*1000;sessionStorage.setItem('mandadosEmailCooldown',String(until));setRemaining(WAIT_SECONDS);setMsg('Listo. Revisa tu correo, también la carpeta de spam. Usa el enlace más reciente para entrar.');
 }catch{setMsg('No pudimos conectarnos. Revisa tu conexión e inténtalo de nuevo.')}finally{setBusy(false)}};
 return <main className="wrap narrow"><section className="hero loginHero"><Brand/><h1>Bienvenido</h1><p className="sub">Entra o crea tu cuenta con tu correo. No necesitas contraseña.</p><form onSubmit={send} className="stack"><label>Correo electrónico<input required type="email" autoComplete="email" value={email} onChange={e=>setEmail(e.target.value)} placeholder="tu@correo.com"/></label><button className="cta" disabled={busy||remaining>0}>{busy?'Enviando…':remaining?`Espera ${remaining} s para reenviar`:'Enviar enlace de acceso'}</button>{msg&&<p className="notice" role="status">{msg}</p>}</form><p className="fine">Por seguridad, no solicites varios enlaces seguidos. Tus pedidos y datos son privados.</p></section></main>}
