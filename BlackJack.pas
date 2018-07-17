program BlackJack;
uses crt;
/////////////////////////////////////////////////////////////////////
type
	dekkartu=record
	nomor:integer;
	jenis:string;
end;
arr = array [1..52] of dekkartu;
arrint = array[1..52] of integer;
/////////////////////////////////////////////////////////////////////
var
	i,j,uang,arandom,taruhan,tdealer,tanda,as:integer;
	input,inputluar:string;
	dek,dekacak:arr;
	temp:arrint;
/////////////////////////////////////////////////////////////////////
	function cekangka(temp:arrint;arandom,neff:integer):boolean;//mengecek ada tidaknya arandom di temp
	var
		i:integer;found:boolean;
	begin
		i:=1;found:=false;
		while (i<=neff) and (not found) do
		begin
			if (temp[i]=arandom) then found:=true;
			i+=1;
		end;
		cekangka:=found;
	end;
/////////////////////////////////////////////////////////////////////
	procedure bacakartu(var dekacak:arr;i,as:integer);//menuliskan kartu dan mengubah nilai jack queen king jadi 10 dan as jadi 1 atau 11
	begin
		write('     ');
		if (dekacak[i].nomor=11) then begin
			writeln('Jack',' ',dekacak[i].jenis);
			dekacak[i].nomor:=10;
		end	else if (dekacak[i].nomor=12) then begin
			writeln('Queen',' ',dekacak[i].jenis);
			dekacak[i].nomor:=10;
		end else if (dekacak[i].nomor=13) then begin
			writeln('King',' ',dekacak[i].jenis);
			dekacak[i].nomor:=10;
		end else if (dekacak[i].nomor=1) then begin
			writeln('As',' ',dekacak[i].jenis);
			dekacak[i].nomor:=as;
		end else writeln(dekacak[i].nomor,' ',dekacak[i].jenis)
	end;
/////////////////////////////////////////////////////////////////////
begin
/////////////////////////////////////////////////////////////////////
	randomize;
	for i:=1 to 4 do
	begin
		for j:=1 to 13 do
		begin
			dek[(i-1)*13+j].nomor:=j;
			if (i=1) then dek[(i-1)*13+j].jenis:='Keriting'
			else if (i=2) then dek[(i-1)*13+j].jenis:='Sekop'
			else if (i=3) then dek[(i-1)*13+j].jenis:='Wajik'
			else if (i=4) then dek[(i-1)*13+j].jenis:='Hati';
		end;
	end;
/////////////////////////////////////////////////////////////////////	
	uang:=1000;
	repeat
		for i:=1 to 52 do
		begin
			repeat 
			arandom:=random(52)+1;
			until(cekangka(temp,arandom,(i-1))=false);
			temp[i]:=arandom;
		end;
		for i:=1 to 52 do dekacak[i]:=dek[temp[i]];
		ClrScr;
		i:=0;
		writeln('Jumlah uang Anda sementara : ',uang);
		repeat
			write('Masukkan jumlah taruhan : ');readln(taruhan);
			if taruhan>uang then writeln('Taruhan tidak bisa melebihi jumlah uang!');
		until(taruhan<=uang);
		repeat
			write('Hitung kartu As sebagai (1 atau 11) : ');readln(as);
			if (as<>11) and (as<>1) then writeln('Kartu As hanya dapat dihitung sebagai 1 atau 11!');
		until((as=11) or (as=1));
		ClrScr;
		writeln('Kartu Dealer : ');
		bacakartu(dekacak,1,as);
		bacakartu(dekacak,2,as);
		tdealer:=dekacak[1].nomor+dekacak[2].nomor;
		gotoXY(1,3);DelLine;InsLine; //mengubah nilai kartu tertutup siapa tau jack,queen,atau king
		writeln('     (Tertutup)');
		writeln('Kartu Anda : ');
		bacakartu(dekacak,3,as);
		bacakartu(dekacak,4,as);
		tanda:=dekacak[3].nomor+dekacak[4].nomor;
		input:='bukanbuka';
		while (lowercase(input)<>'buka') do begin
			if tanda>21 then begin //bagian ini untuk kartu total melebihi 21
				gotoXY(1,3);DelLine;InsLine; //membuka kartu tertutup
				bacakartu(dekacak,2,as);
				gotoXY(1,7+i);
				if tdealer<=21 then begin
					writeln('Wah, Anda kurang beruntung, kalah!');
					input:='buka';
					uang-=taruhan;
				end else begin
					writeln('Hasil seri!');
					input:='buka';
				end;
			end else if tanda=21 then begin //bagian ini untuk kartu total sama dengan 21
				gotoXY(1,3);DelLine;InsLine; //membuka kartu tertutup
				bacakartu(dekacak,2,as);
				gotoXY(1,7+i);
				if tdealer=21 then begin
					writeln('Hasil seri!');
					input:='buka';
				end else begin
					writeln('Selamat, Anda menang!');
					input:='buka';
					uang+=taruhan;
				end;
			end else if tanda<21 then begin //bagian ini berarti kartu total tidak melebihi 21
			readln(input);
				if (lowercase(input)='buka') then begin
					gotoXY(1,3);DelLine;InsLine; //membuka kartu tertutup
					bacakartu(dekacak,2,as);
					gotoXY(1,7+i);DelLine;writeln;
					if tdealer>21 then begin
						writeln('Selamat, Anda menang!');
						uang+=taruhan;
					end else if tanda>tdealer then begin
						writeln('Selamat, Anda menang!');
						uang+=taruhan;
					end else if tanda<tdealer then begin
						writeln('Wah, Anda kurang beruntung, kalah!');
						uang-=taruhan;
					end else begin
						writeln('Hasil seri!');
					end;
				end else if (lowercase(input)='tambah') then begin
					i+=1;
					gotoXY(1,6+i);DelLine;
					bacakartu(dekacak,(i+4),as);
					tanda+=dekacak[(i+4)].nomor;
				end;
			end;
		end;
		writeln('Total kartu Dealer : ',tdealer);
		writeln('Total kartu Anda : ',tanda);
		writeln('Sisa uang Anda : ',uang);writeln;
		if (uang>0) then begin 
			writeln('Ketik "main" untuk main lagi atau "keluar" untuk mengakhiri permainan');
			repeat
				readln(inputluar);
				if not (lowercase(inputluar)='keluar') and not (lowercase(inputluar)='main') then 
				writeln('Masukkan salah! Silahkan ketik "main" atau "keluar"');
			until((lowercase(inputluar)='keluar') or (lowercase(inputluar)='main'))
		end else writeln('Permainan berakhir, Anda kehabisan uang!');
	until((lowercase(inputluar)='keluar') or (uang<=0));
end.