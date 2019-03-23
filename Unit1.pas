unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
    maxpop = 100;
    maxstring = 30;
    dim = 1; {����������� ������������ ������}

type
  allele = boolean;   { ������� � ������� ������}
  chromosome = array[1..maxstring*dim] of allele;    {������� ������}
  fenotype = array[1..dim] of real;   {������� = ������ ������������ ��������� ����� � ������������ ������}
  individual = record
    chrom:chromosome; {������� = ������� ������}
    x:fenotype; {������� = ������ ������������ ��������� ����� � ������������ ������}
    fitness:real; {�������� ������� �������}
  end;
  population = array[1..maxpop] of individual;

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  xmax:fenotype=(7); {������ ������������ �������� ��� ��������� ����� � ������������ ������}
  xmin:fenotype=(0); {������ ����������� �������� ��� ��������� ����� � ������������ ������}

var
  Form1: TForm1;
  oldpop, newpop, intpop :population;     {��� ���������������� ��������� ? ������, ����� � �����-��������}
  popsize, lchrom, gen, maxgen :integer;  {���������� ����� ����������}
  pcross, pmutation, sumfitness :real;    {���������� ������������ ����������}
  nmutation, ncross :integer;             {�������������� �����}
  avg, max, min :real;                    {�������������� ������������}

implementation

{$R *.dfm}

{================================================================================}
procedure TForm1.Button1Click(Sender: TObject);
  {������������� ���������}
  function random_:real;
  begin
      random_:=random(65535)/(65535-1);
  end;

  function flip(probability:real):boolean;    {������������� ������� ? true ���� ����}
  begin
      if probability=1.0 then flip:=true else flip:=(random_<=probability);
  end;

  {��������� ����� ����� low � high}
  function rnd(low,high:integer):integer;
  var i:integer;
  begin
      if low >= high then
          i := low
      else begin
          i := trunc( random_ * (high-low+1) + low);
          if i > high then i := high;
      end;
      rnd := i;
  end;

  {================================================================================}

  {������������ ���������: decode and objfunc}
  function objfunc(x:fenotype):real;
  begin
      objfunc:= 5-24*x[1]+17*x[1]*x[1]-(11/3)*x[1]*x[1]*x[1]+(1/4)*x[1]*x[1]*x[1]*x[1];
  end;

  procedure decode(chrom:chromosome; lbits:integer; var x:fenotype);    {������������� ������ � ������ ������������ ��������� ����� � ������������ ������ - true=1, false=0}
  var i,j:integer;
      f, accum, powerof2:real;
  begin
      for i:=1 to dim do begin
          accum:=0.0; powerof2:=1; f:=1;
          for j:=1+lbits*(i-1) to lbits+lbits*(i-1) do begin
              if chrom[j] then accum := accum + powerof2;
              powerof2 := powerof2 * 2;
              f:=f*2;
          end;
          x[i]:=xmin[i]+(xmax[i]-xmin[i])*accum/(f-1);
          //writeln('x= ',x[i]:10:8)
          Memo1.Text:= Memo1.Text + 'x= ' + FloatToStrF(x[i],ffFixed,15,6) + #13#10;
      end
  end;

  {================================================================================}


  {������ �������������� �������: statistics }
  procedure statistics(popsize:integer; var max,avg,min,sumfitness:real; var pop:population); {������ ��������� ��������� }
  var j:integer;
      xMin:real;
  begin
      {������������� }
      sumfitness := pop[1].fitness;
      min := pop[1].fitness;
      max := pop[1].fitness;
      {���� ��� max, min, sumfitness }
      for j := 2 to popsize do with pop[j] do begin
          sumfitness := sumfitness + fitness;        {���������� ����� �������� ������� �����������}
          if fitness>max then max := fitness;        {����� �������� max}
          if fitness<min then begin
              min := fitness;
              xMin := x[1];
          end;        {����� �������� min}
      end;

      //writeln('min= ',min:10:8);
      //writeln('xMin= ',xMin:10:8);
      //writeln('______________________________');
      //writeln();
      Memo1.Text:= Memo1.Text + #13#10 + 'min= ' + FloatToStrF(min,ffFixed,15,6) + #13#10;
      Memo1.Text:= Memo1.Text + 'xMin= ' + FloatToStrF(xMin,ffFixed,15,6) + #13#10;

      avg := sumfitness/popsize;                    {������ ��������}
  end;

  {��������� ������������� initpop}
  procedure initpop;        {������������� ��������� ��������� ��������� �������}
  var j, j1:integer;
  begin
      Memo1.Text:= Memo1.Text +  '______________________________��������� ���������' + #13#10;
      for j := 1 to popsize do with oldpop[j] do begin
          for j1 := 1 to lchrom*dim do chrom[j1] := flip(0.5);        {������ �������}
          decode(chrom,lchrom,x);        {������������� ������}
          fitness := objfunc(x);            {���������� ��������� �������� ������� �����������}
         // writeln('fitness_initpop= ',fitness:10:8)
         Memo1.Text:= Memo1.Text + 'fitness_initpop= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
      end;
  end;

  {================================================================================}

  {3 ������������ ���������: ������ (select), ����������� (crossover) � ������� (mutation)}
  procedure select;        {��������� ������}
  var ipick:integer;

      procedure shuffle(var pop:population);    {��������� ������������� ��������� � �������� ������}
      var    i,j:integer;
          ind0:individual;
      begin
          for i := popsize downto 2 do begin
              j:= random(i-1)+1;
              ind0:=pop[i];
              pop[i]:=pop[j];
              pop[j]:=ind0;
          end;
      end;

      function select_1:integer;
      var    j1,j2,m:integer;
      begin
          if (ipick>popsize) then begin
              shuffle(oldpop);
              ipick:=1
          end;
          j1:=ipick;
          j2:=ipick+1;
          if (oldpop[j2].fitness<oldpop[j1].fitness) then    m:=j2 else m:=j1;
          ipick:=ipick+2;
          select_1:=m;
      end;

  var j:integer;
  begin
      ipick:=1;
      for j:=1 to popsize do begin
          intpop[j]:=oldpop[select_1];
      end;
      oldpop:=intpop;
  end;
  function mutation (alleleval:allele; pmutation:real; var nmutation:integer):allele;
      {������� ������ ���� � ������ (������) � ������������ pmutation, count number of mutations}
  var
      mutate:boolean;
  begin
      mutate := flip(pmutation);
      if mutate then begin
          nmutation := nmutation + 1;
          mutation := not alleleval;
      end else mutation := alleleval;
  end;
  procedure crossover(var parent1, parent2, child1, child2:chromosome; flchrom:integer; var ncross, nmutation, jcross:integer; var pcross, pmutation:real);
      {����������� 2 ������������ �����, ��������� ���������� � 2 �������-��������}
  var
      j:integer;
  begin
      if flip(pcross) then begin                {����������� ����������� � ������������ pcross}
          jcross:=rnd(1,flchrom-1);            {����������� ����� ������� � ��������� ����� 1 � l-1}
          ncross:=ncross + 1;                {����������������� �������� �����������}
      end else
          jcross:=flchrom;
      {����� ����� ������ , 1 to 1 and 2 to 2}
      for j := 1 to jcross do begin
          child1[j]:=mutation(parent1[j], pmutation, nmutation);
          child2[j]:=mutation(parent2[j], pmutation, nmutation);
      end;
      {������ ����� ������, 1 to 2 and 2 to 1}
      if jcross<>flchrom then                {�������, ���� ����� ����������� ����� flchrom--����������� �� ����������}
          for j := jcross+1 to flchrom do begin
              child1[j] := mutation(parent2[j], pmutation, nmutation);
              child2[j] := mutation(parent1[j], pmutation, nmutation);
          end;
  end;

  {================================================================================}

  procedure generation;
  {������������� ������ ��������� ��� ������ ������, ����������� � �������}
  {����: ��������������, ��� ��������� ����� ������ ������}
  var
      j, mate1, mate2, jcross:integer;
  begin
      select;
      j := 1;
      repeat
          {����������� �����, ����������� � �������, ���� ��������� �� ������������ ����� ��������� ? newpop}
          mate1:=j;
          {����� ������������ ����}
          mate2:=j+1;
          {����������� � ������� ? ������� ��������� � ��������� �����������}
          crossover(oldpop[mate1].chrom, oldpop[mate2].chrom,    newpop[j].chrom, newpop[j + 1].chrom, lchrom*dim, ncross, nmutation, jcross, pcross, pmutation);
          {������������� ������ � ���������� �����������}
          with newpop[j] do begin
              decode(chrom, lchrom,x);
              fitness := objfunc(x);
             // writeln('fitness1= ',fitness:10:8)
              Memo1.Text:= Memo1.Text + 'fitness1= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
          end;
          with newpop[j+1] do begin
              decode(chrom, lchrom,x);
              fitness := objfunc(x);
              //writeln('fitness2= ',fitness:10:8)
              Memo1.Text:= Memo1.Text + 'fitness2= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
          end;
          j := j + 2;
      until j>popsize
  end;


begin
    Memo1.Clear;
    popsize:=6;                    {������ ���������}
    lchrom:=20;                        {����� ����� �� ���� ���������� ��������}
    maxgen:=18;                    {������������ ����� ���������}
    pmutation:=0.1;                {����������� �����������}
    pcross:=0.9;                    {����������� �������}
    randomize;                        {������������� ���������� ��������� �����}
    nmutation := 0;    ncross := 0;    {������������� ���������}
    initpop;
    statistics (popsize, max, avg, min, sumfitness, oldpop);
    gen:= 0;                        {��������� �������� ��������� � 0}
    repeat {������� ������������ ����}
        gen:= gen + 1;
        Memo1.Text:= Memo1.Text + #13#10 + '______________________________��������� � ' + FloatToStr(gen) + #13#10;
        generation;
        statistics(popsize, max, avg, min, sumfitness, newpop);
        oldpop:= newpop;            {������� �� ����� ��������� }
    until (gen >= maxgen);
    //writeln('global min= ',min:10:8);
    Memo1.Text:= Memo1.Text + #13#10 + 'global min= ' + FloatToStrF(min,ffFixed,15,6) + #13#10;


end;

end.