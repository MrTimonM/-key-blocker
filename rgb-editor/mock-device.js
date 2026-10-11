// Test-only firmware simulator. Never used by app.js or served by server.js.
export function createDevice({includeId=false,padded=false}={}) {
  const custom=new Uint8Array(512);custom.fill(77,378);
  const base=Uint8Array.from({length:512},(_,i)=>i%256);
  const settings=new Uint8Array(128);settings[10]=3;settings[15]=4;
  const device={vendorId:0x258a,productId:0x019d,productName:'WKL-100',opened:false,
    collections:[{usagePage:0xff02,usage:2,featureReports:[{reportId:9,items:[{reportSize:8,reportCount:519}]}]}],
    custom,base,settings,calls:[],pointer:0,header:null,corruptOnce:false,
    async open(){this.opened=true;this.calls.push(['open']);},
    async close(){this.opened=false;this.calls.push(['close']);},
    async sendFeatureReport(id,data){
      if(id!==9||data.length!==519)throw new Error('Incorrect WebHID framing');
      const d=Uint8Array.from(data);this.calls.push(['send',d[0],[...d.slice(0,7)]]);this.header=d.slice(0,7);
      if(d[0]===0x84)this.pointer=0xa400;
      else if(d[0]===0x85)this.pointer=((0xdc+2*d[4])&255)*256;
      else if(d[0]===0x83&&d[1]===0)this.pointer=0xbc00;
      else if(d[0]===0x83&&d[1]===4){} // Continuation.
      else if(d[0]===6){this.custom.set(d.slice(7,385));this.justWrote=true;}
      else if(d[0]===4)this.settings.set(d.slice(7,135));
      else throw new Error('Unexpected device command');
    },
    async receiveFeatureReport(id){
      if(id!==9)throw new Error('Unexpected report');
      const count=this.header[5];
      let source,offset;
      if(this.pointer>=0xac00&&this.pointer<0xae00){source=this.custom;offset=this.pointer-0xac00;}
      else if(this.pointer>=0xbc00&&this.pointer<0xbe00){source=this.base;offset=this.pointer-0xbc00;}
      else if(this.pointer===0xa400){source=this.settings;offset=0;}
      else throw new Error('Read outside allowed test regions');
      const response=new Uint8Array((padded?519:7+count)+(includeId?1:0));
      let start=0;if(includeId){response[0]=9;start=1;}
      response.set(this.header,start);response.set(source.slice(offset,offset+count),start+7);
      if(this.corruptOnce&&this.justWrote&&source===this.custom){response[start+7]^=1;this.corruptOnce=false;this.justWrote=false;}
      // Three reads may reach beyond a sector; the final one is truncated by
      // the caller. Only bytes through the end of the tested region matter.
      this.pointer+=Math.floor((count-1)/8)*8;
      this.calls.push(['receive']);return new DataView(response.buffer);
    }
  };
  return device;
}
