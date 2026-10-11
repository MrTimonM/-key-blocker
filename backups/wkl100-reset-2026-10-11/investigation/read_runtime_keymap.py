"""Read-only application-mode keymap-prefix query recovered from OWN firmware.
83 selects BC00/C400/CC00/D400. Firmware uses an 8-bit response count;
this query requests 255 data bytes. It does not claim complete 512-byte readback.
No bootloader transition, firmware unlock, erase, or configuration write.
"""
import argparse,hid,json,time,hashlib
from pathlib import Path
ROOT=Path(__file__).resolve().parent
def read_prefix(layer=0):
    ds=[d for d in hid.enumerate(0x258a,0x019d)
        if d['usage_page']==0xff02 and d['usage']==2]
    if len(ds)!=1:raise RuntimeError('Expected one WKL-100 control collection')
    h=hid.device()
    header=bytes([9,0x83,layer,0,1,0,255,0])
    try:
        h.open_path(ds[0]['path'])
        n=h.send_feature_report(header+bytes(512))
        if n!=520:raise RuntimeError('Unexpected query write length')
        time.sleep(.05)
        response=bytes(h.get_feature_report(9,520))
    finally:h.close()
    log={'query':header.hex(' '),'response_length':len(response),
         'response':response.hex(' '),'layer':layer}
    (ROOT/f'runtime-layer{layer}-prefix-query.json').write_text(json.dumps(log,indent=2))
    if response[:8]!=header or len(response)!=263:
        raise RuntimeError(f'Unexpected prefix response: {len(response)} bytes {response[:16].hex(" ")}')
    return response[8:]

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--layer',type=int,choices=range(4),default=0)
    args=parser.parse_args();data=read_prefix(args.layer)
    (ROOT/f'runtime-layer{args.layer}-prefix.bin').write_bytes(data)
    print('Length',len(data),'SHA256',hashlib.sha256(data).hexdigest(),'head',data[:32].hex(' '))
