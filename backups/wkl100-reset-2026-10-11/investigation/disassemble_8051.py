"""Offline 8051 listing using Jeff Tranter's udis opcode-length table.
Reference table: https://github.com/jefftranter/udis/blob/master/8051.py
Only parses the table as data; does not execute downloaded source.
"""
import ast, argparse
from pathlib import Path
ROOT=Path(__file__).resolve().parent
tree=ast.parse((ROOT/'udis-8051.py').read_text())
node=next(n.value for n in tree.body if isinstance(n,ast.Assign)
          and any(isinstance(t,ast.Name) and t.id=='opcodeTable' for t in n.targets))
class Constants(ast.NodeTransformer):
    def visit_Name(self,node):
        if node.id in ('pcr','und'): return ast.Constant({'pcr':1,'und':2}[node.id])
        raise ValueError(node.id)
TABLE=ast.literal_eval(Constants().visit(node))

def decode(data,address):
    op=data[address]
    n,mnem,mode,*_=TABLE[op]
    raw=data[address:address+n]
    if len(raw)!=n:return n,raw.hex()
    args=raw[1:]
    if op in (2,0x12):operand=f'0x{int.from_bytes(args,"big"):04X}'
    elif op&0x1f in (1,0x11):
        operand=f'0x{((address+2)&0xf800)|((op&0xe0)<<3)|args[0]:04X}'
    elif op==0x90:operand=f'DPTR,#0x{int.from_bytes(args,"big"):04X}'
    elif op==0x85:operand=f'0x{args[1]:02X},0x{args[0]:02X}'
    else:
        parts=mode.split(',') if mode else []
        out=[];i=0
        for p in parts:
            if p in ('direct','bit'):
                out.append(f'0x{args[i]:02X}');i+=1
            elif p=='immed':out.append(f'#0x{args[i]:02X}');i+=1
            elif p=='offset':
                rel=args[i] if args[i]<128 else args[i]-256
                out.append(f'0x{(address+n+rel)&0xffff:04X}');i+=1
            else:out.append(p.upper())
        operand=','.join(out)
    return n,f'{address:04X}  {raw.hex(" "):<8}  {mnem.upper():<6} {operand}'

def listing(data,start,end):
    a=start
    while a<end:
        n,line=decode(data,a)
        yield line
        a+=n

if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('image',type=Path)
    parser.add_argument('start',type=lambda x:int(x,0))
    parser.add_argument('end',type=lambda x:int(x,0))
    args=parser.parse_args()
    print('\n'.join(listing(args.image.read_bytes(),args.start,args.end)))
