"""Extract all 512-byte map banks from the owner's verified ISP-view dump.
Does not open the keyboard or send USB commands.
"""
import argparse, csv, hashlib, io, json
from pathlib import Path
from disassemble_8051 import listing
ROOT=Path(__file__).resolve().parent
NAMES={0x28:'Enter',0x29:'Escape',0x2a:'Backspace',0x2b:'Tab',0x2c:'Space',
       0x2d:'Minus',0x2e:'Equal',0x2f:'Left bracket',0x30:'Right bracket',
       0x31:'Backslash',0x33:'Semicolon',0x34:'Quote',0x35:'Backtick',
       0x36:'Comma',0x37:'Period',0x38:'Slash',0x39:'Caps Lock',0x46:'Print Screen',
       0x47:'Scroll Lock',0x48:'Pause',0x49:'Insert',0x4a:'Home',0x4b:'Page Up',
       0x4c:'Delete',0x4d:'End',0x4e:'Page Down',0x4f:'Right arrow',
       0x50:'Left arrow',0x51:'Down arrow',0x52:'Up arrow',0x64:'Non-US backslash',
       0x87:'International1'}
NAMES.update({i:chr(ord('A')+i-4) for i in range(4,30)})
NAMES.update({0x1e+i:str((i+1)%10) for i in range(10)})
NAMES.update({0x3a+i:f'F{i+1}' for i in range(12)})
MODS=['Left Ctrl','Left Shift','Left Alt','Left GUI','Right Ctrl','Right Shift','Right Alt','Right GUI']
def action(raw):
    if raw==bytes(4):return 'Zero action; behavior unverified'
    if raw==bytes.fromhex('0d 00 00 00'):return 'Fn action (preserve)'
    if raw[0]==0 and raw[2]==0:
        names=[MODS[i] for i in range(8) if raw[1]&(1<<i)]
        if raw[3]: names.append(NAMES.get(raw[3],f'HID usage 0x{raw[3]:02X}'))
        return '+'.join(names)
    return f'Internal/extended action {raw.hex(" ")} (preserve)'

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('image',type=Path)
    args=parser.parse_args()
    image=args.image.read_bytes()
    if len(image)!=65536:raise ValueError('Expected a complete 65536-byte ISP-view dump')
    if hashlib.md5(image[0xf000:]).hexdigest()!='3e0ebd0c440af5236d7ff8872343f85d':
        raise ValueError('Unexpected bootloader: recheck region assumptions')
    regions={'base':0xbc00,'base-alternate':0xbe00,'factory-base':0xc000,
             'factory-base-alternate':0xc200,'fn':0xc400,'fn-alternate':0xc600,
             'factory-fn':0xc800,'factory-fn-alternate':0xca00,
             'layer2':0xcc00,'layer2-alternate':0xce00,
             'layer3':0xd400,'layer3-alternate':0xd600}
    result={'source':str(args.image.resolve()),'source_sha256':hashlib.sha256(image).hexdigest(),
            'source_view':'ISP logical read; reset-vector bytes are remapped',
            'regions':{},'physical_slot_warning':'Action labels decode stored output actions. Physical position is separately validated; do not copy OEM app geometry.'}
    for name,address in regions.items():
        region=image[address:address+512]
        path=ROOT/f'wkl100-{name}-512.bin'
        path.write_bytes(region)
        rows=[{'slot':i,'address':f'0x{address+4*i:04X}',
               'raw':region[4*i:4*i+4].hex(' '),'action':action(region[4*i:4*i+4])}
              for i in range(128)]
        result['regions'][name]={'address':hex(address),'size':512,
            'sha256':hashlib.sha256(region).hexdigest(),'file':str(path),'slots':rows}
        output=io.StringIO(newline='');writer=csv.DictWriter(output,fieldnames=rows[0].keys())
        writer.writeheader();writer.writerows(rows)
        (ROOT/f'wkl100-{name}-slots.csv').write_text(output.getvalue())
    result['current_equals_factory']={name:image[regions[name]:regions[name]+512]==image[regions['factory-'+name]:regions['factory-'+name]+512]
                                       for name in ['base','base-alternate','fn','fn-alternate']}
    (ROOT/'wkl100-keymap.json').write_text(json.dumps(result,indent=2))
    evidence=[]
    for start,end in [(0xc09,0xc60),(0x6c21,0x6c50),(0x7bb5,0x7c41),
                      (0x9646,0x96e6),(0x79a0,0x79ef),(0x7a51,0x7a9a)]:
        evidence.extend(listing(image,start,end));evidence.append('')
    (ROOT/'wkl100-keymap-firmware-evidence.asm').write_text('\n'.join(evidence))
    own=image[0xbc00:0xbe00];reference=(ROOT/'reference-base-layer.bin').read_bytes()
    differences=[{'slot':i,'own':own[4*i:4*i+4].hex(' '),
                  'borrowed':reference[4*i:4*i+4].hex(' '),
                  'own_action':action(own[4*i:4*i+4]),'borrowed_action':action(reference[4*i:4*i+4])}
                 for i in range(128) if own[4*i:4*i+4]!=reference[4*i:4*i+4]]
    (ROOT/'wkl100-vs-phantom-map-diff.json').write_text(json.dumps(differences,indent=2))
    print('Extracted all banks. Factory comparisons:',result['current_equals_factory'])
    print('Borrowed map differs at',len(differences),'slots')
    for i in (16,22,49,55,59,74):print('Base slot',i,action(own[4*i:4*i+4]),own[4*i:4*i+4].hex(' '))

if __name__=='__main__':main()
