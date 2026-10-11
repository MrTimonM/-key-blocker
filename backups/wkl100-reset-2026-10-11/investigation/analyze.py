from pathlib import Path
import pefile,capstone,hashlib,json,re
root=Path(r'C:\Users\Mahedi\Documents\K81-USB-Debug')
p=Path(r'C:\Program Files (x86)\LEOBOG\K81\OemDrv.exe')
b=p.read_bytes(); pe=pefile.PE(data=b); base=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32); md.detail=True; md.skipdata=True
imports={i.address:i.name.decode() if i.name else str(i.ordinal) for d in pe.DIRECTORY_ENTRY_IMPORT for i in d.imports}
ins=[]
for s in pe.sections:
 if s.Characteristics & 0x20000000: ins+=list(md.disasm(s.get_data(),base+s.VirtualAddress))
(root/'disassembly.txt').write_text('\n'.join(f'{i.address:08x} {i.mnemonic:8} {i.op_str}' for i in ins))
strings={}
for m in re.finditer(rb'(?:[ -~]\x00){5,}',b):
 try: strings[base+pe.get_rva_from_offset(m.start())]=m.group().decode('utf-16le')
 except: pass
for m in re.finditer(rb'[ -~]{5,}',b):
 try: strings[base+pe.get_rva_from_offset(m.start())]=m.group().decode()
 except: pass
targets={a:s for a,s in strings.items() if any(x in s for x in ['SetLED','SetLed','SendCommand','GetPassword','SendMusicData','FindHIDDevice','SendSysParam'])}
xrefs=[]
for k,i in enumerate(ins):
 label=None
 for op in (i.operands if i.id else []):
  if op.type==capstone.x86.X86_OP_MEM and op.mem.disp in imports and imports[op.mem.disp] in ['HidD_SetFeature','HidD_GetFeature','WriteFile','ReadFile']: label=imports[op.mem.disp]
  if op.type==capstone.x86.X86_OP_IMM and op.imm in targets: label=targets[op.imm]
 if label:
  xrefs.append({'address':hex(i.address),'target':label})
  if 'HidD_' in label or label in targets.values():
   print('\nTARGET',label,'at',hex(i.address))
   for j in ins[max(0,k-15):k+8]: print(f'{j.address:08x} {j.mnemonic:8} {j.op_str}')
summary={'exe':str(p),'sha256':hashlib.sha256(b).hexdigest(),'image_base':hex(base),'machine':hex(pe.FILE_HEADER.Machine),'imports':imports,'xrefs':xrefs}
(root/'static-analysis.json').write_text(json.dumps(summary,indent=2))
print('SHA256',summary['sha256'])

