// Physical legends from the owner's recovered factory map, not a remapped live map.
// Tuple: label, matrix/color slot, key width. LCD and knob aren't color targets.
export const ROWS=[
  [['Esc',0],...Array.from({length:12},(_,i)=>['F'+(i+1),(i+1)*6]),['End',94]],
  [['`',1],...Array.from({length:9},(_,i)=>[String(i+1),7+i*6]),['0',61],['−',67],['=',73],['Backspace',79,2],['Del',91]],
  [['Tab',2,1.5],['Q',8],['W',14],['E',20],['R',26],['T',32],['Y',38],['U',44],['I',50],['O',56],['P',62],['[',68],[']',74],['\\',80,1.5],['PgUp',92]],
  [['Caps',3,1.75],['A',9],['S',15],['D',21],['F',27],['G',33],['H',39],['J',45],['K',51],['L',57],[';',63],["'",69],['Enter',81,2.25],['PgDn',93]],
  [['Shift',4,2.25],['Z',10],['X',16],['C',22],['V',28],['B',34],['N',40],['M',46],[',',52],['.',58],['/',64],['Shift',82,2.75],['↑',88]],
  [['Ctrl',5,1.25],['Win',11,1.25],['Alt',17,1.25],['Space',35,6.25],['Alt',53],['Fn',59],['Ctrl',65],['←',83],['↓',89],['→',95]]
];
export const KEYS=ROWS.flat().map(([label,slot,width=1])=>({label,slot,width}));
