"""Controlled previously authorized 8 -> 9 test using the owner's ISP dump.
Saves the full before/after region and verifies the offline one-byte diff.
Restore sends the captured original region, not another model's defaults.
"""
import argparse, hashlib, json, time
from pathlib import Path
import hid
from read_runtime_keymap import read_prefix
ROOT=Path(__file__).resolve().parent
STAMP='20261007-202027'
SOURCE=ROOT/f'wkl100-isp-view-{STAMP}-pass1.bin'
SECOND=ROOT/f'wkl100-isp-view-{STAMP}-pass2.bin'
EXPECTED='f9a7e1b1abf47c1a9b8b545eae1a0467c5f8086f05d28fb6bf1ee096eac37a64'

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('operation',choices=['prepare','apply','restore'])
    args=parser.parse_args()
    image=SOURCE.read_bytes()
    if image!=SECOND.read_bytes() or hashlib.sha256(image).hexdigest()!=EXPECTED:
        raise RuntimeError('Source dump validation failed')
    before=image[0xbc00:0xbe00]
    if before[49*4:49*4+4]!=bytes.fromhex('00 00 00 25'):
        raise RuntimeError('Source slot 49 is not the expected 8 action')
    after=bytearray(before); after[49*4+3]=0x26
    changes=[i for i,(a,b) in enumerate(zip(before,after)) if a!=b]
    if changes!=[199]:raise RuntimeError('Unexpected offline diff')
    header=bytes.fromhex('09 03 00 00 00 00 00 00')
    (ROOT/'own-map-remap-before.bin').write_bytes(before)
    (ROOT/'own-map-remap-after.bin').write_bytes(after)
    (ROOT/'own-map-8-to-9-report.bin').write_bytes(header+after)
    (ROOT/'own-map-restore-report.bin').write_bytes(header+before)
    proof={'source':str(SOURCE),'source_sha256':EXPECTED,'region_address':'0xBC00',
           'region_size':512,'slot':49,'before':'00 00 00 25','after':'00 00 00 26',
           'region_changed_offsets':changes,'report_changed_offsets':[207],
           'operation':args.operation,'all_other_511_region_bytes_preserved':True,
           'fn_layer_written':False,'physical_confirmation':'pending'}
    if args.operation!='prepare':
        live=read_prefix(0)
        accepted=[before[:255]] if args.operation=='apply' else [before[:255],bytes(after[:255])]
        if live not in accepted:
            raise RuntimeError('Live base prefix differs from the controlled test snapshots; take a fresh backup before editing')
        proof['pre_write_live_prefix_validated']=True
        targets=[d for d in hid.enumerate(0x258a,0x019d) if d['usage_page']==0xff02 and d['usage']==2]
        if len(targets)!=1:raise RuntimeError('Ambiguous/missing WKL-100 control interface')
        device=hid.device()
        try:
            device.open_path(targets[0]['path'])
            report=header+(after if args.operation=='apply' else before)
            proof['sent_hex']=report.hex(' ')
            proof['send_result']=device.send_feature_report(report)
            time.sleep(.2)
            if proof['send_result']!=520:raise RuntimeError('Unexpected feature-report write length')
        finally:device.close()
        expected=bytes(after[:255]) if args.operation=='apply' else before[:255]
        actual=read_prefix(0)
        proof['post_write_live_prefix_matches']=actual==expected
        if actual!=expected:raise RuntimeError('Application-mode readback mismatch')
    (ROOT/f'own-map-remap-{args.operation}.json').write_text(json.dumps(proof,indent=2))
    print(args.operation, 'region diff',changes,'report diff',[207],flush=True)

if __name__=='__main__':main()
