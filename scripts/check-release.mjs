import {existsSync,readFileSync,statSync} from 'node:fs';
import {join} from 'node:path';
const root=process.cwd();
const required=['app/page.js','app/login/page.js','app/cuenta/page.js','app/pedidos/page.js','app/pedidos/[id]/page.js','app/admin/page.js','app/admin/reportes/page.js','app/lista-habitual/page.js','components/Brand.js','public/logo-mandados.png','supabase-schema-v7-security.sql','.gitignore','.env.example'];
let failed=false;
for(const file of required){if(!existsSync(join(root,file))){console.error('FALTA:',file);failed=true;}}
if(failed)process.exit(1);
const logo=readFileSync(join(root,'public/logo-mandados.png'));
if(logo.subarray(0,8).toString('hex')!=='89504e470d0a1a0a'||statSync(join(root,'public/logo-mandados.png')).size<10000){console.error('El logo original no es un PNG válido');failed=true;}
const page=readFileSync(join(root,'app/page.js'),'utf8');
const brand=readFileSync(join(root,'components/Brand.js'),'utf8');
const sql=readFileSync(join(root,'supabase-schema-v7-security.sql'),'utf8');
for(const [name,ok] of [['logo original',brand.includes('/logo-mandados.png')],['catálogo ilustrado',page.includes('productIcons')],['sin precios falsos',!page.includes('subtotalEstimado')],['pedidos con tickets',readFileSync(join(root,'app/admin/page.js'),'utf8').includes('order_tickets')],['protección de administrador',sql.includes('protect_profile_admin')],['permisos de pedidos',sql.includes('client orders insert')]]){console.log(`${ok?'OK':'ERROR'}: ${name}`);if(!ok)failed=true;}
if(failed)process.exit(1);
console.log('Verificación estática completada. No sustituye npm run build ni pruebas reales en Supabase.');
