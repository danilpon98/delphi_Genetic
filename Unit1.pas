unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
    maxpop = 100;
    maxstring = 30;
    dim = 1; {размерность пространства поиска}

type
  allele = boolean;   { позиция в битовой строке}
  chromosome = array[1..maxstring*dim] of allele;    {битовая строка}
  fenotype = array[1..dim] of real;   {фенотип = массив вещественных координат точки в пространстве поиска}
  individual = record
    chrom:chromosome; {генотип = битовая строка}
    x:fenotype; {фенотип = массив вещественных координат точки в пространстве поиска}
    fitness:real; {значение целевой функции}
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
  xmax:fenotype=(7); {массив максимальных значений для координат точки в пространстве поиска}
  xmin:fenotype=(0); {массив минимальных значений для координат точки в пространстве поиска}

var
  Form1: TForm1;
  oldpop, newpop, intpop :population;     {Три непересекающихся популяции ? старая, новая и проме-жуточная}
  popsize, lchrom, gen, maxgen :integer;  {Глобальные целые переменные}
  pcross, pmutation, sumfitness :real;    {глобальные вещественные переменные}
  nmutation, ncross :integer;             {Статистические целые}
  avg, max, min :real;                    {Статистические вещественные}

implementation

{$R *.dfm}

{================================================================================}
procedure TForm1.Button1Click(Sender: TObject);
  {Вероятностные процедуры}
  function random_:real;
  begin
      random_:=random(65535)/(65535-1);
  end;

  function flip(probability:real):boolean;    {подбрасывание монетки ? true если орел}
  begin
      if probability=1.0 then flip:=true else flip:=(random_<=probability);
  end;

  {Случайный выбор между low и high}
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

  {интерфейсные процедуры: decode and objfunc}
  function objfunc(x:fenotype):real;
  begin
      objfunc:= 5-24*x[1]+17*x[1]*x[1]-(11/3)*x[1]*x[1]*x[1]+(1/4)*x[1]*x[1]*x[1]*x[1];
  end;

  procedure decode(chrom:chromosome; lbits:integer; var x:fenotype);    {Декодирование строки в массив вещественных координат точки в пространстве поиска - true=1, false=0}
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


  {Расчет статистических величин: statistics }
  procedure statistics(popsize:integer; var max,avg,min,sumfitness:real; var pop:population); {Расчет статистик популяции }
  var j:integer;
      xMin:real;
  begin
      {Инициализация }
      sumfitness := pop[1].fitness;
      min := pop[1].fitness;
      max := pop[1].fitness;
      {Цикл для max, min, sumfitness }
      for j := 2 to popsize do with pop[j] do begin
          sumfitness := sumfitness + fitness;        {Накопление суммы значений функции пригодности}
          if fitness>max then max := fitness;        {Новое значение max}
          if fitness<min then begin
              min := fitness;
              xMin := x[1];
          end;        {Новое значение min}
      end;

      //writeln('min= ',min:10:8);
      //writeln('xMin= ',xMin:10:8);
      //writeln('______________________________');
      //writeln();
      Memo1.Text:= Memo1.Text + #13#10 + 'min= ' + FloatToStrF(min,ffFixed,15,6) + #13#10;
      Memo1.Text:= Memo1.Text + 'xMin= ' + FloatToStrF(xMin,ffFixed,15,6) + #13#10;

      avg := sumfitness/popsize;                    {Расчет среднего}
  end;

  {Процедура инициализации initpop}
  procedure initpop;        {Инициализация начальной популяции случайным образом}
  var j, j1:integer;
  begin
      Memo1.Text:= Memo1.Text +  '______________________________Стартовое Поколение' + #13#10;
      for j := 1 to popsize do with oldpop[j] do begin
          for j1 := 1 to lchrom*dim do chrom[j1] := flip(0.5);        {Бросок монетки}
          decode(chrom,lchrom,x);        {Декодирование строки}
          fitness := objfunc(x);            {Вычисление начальных значений функции пригодности}
         // writeln('fitness_initpop= ',fitness:10:8)
         Memo1.Text:= Memo1.Text + 'fitness_initpop= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
      end;
  end;

  {================================================================================}

  {3 генетических оператора: отбора (select), скрещивания (crossover) и мутации (mutation)}
  procedure select;        {процедура выбора}
  var ipick:integer;

      procedure shuffle(var pop:population);    {процедура перемешивания популяции в процессе отбора}
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
      {мутация одного бита в строке (аллеля) с вероятностью pmutation, count number of mutations}
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
      {Скрещивание 2 родительских строк, результат помещается в 2 строках-потомках}
  var
      j:integer;
  begin
      if flip(pcross) then begin                {Выполняется скрещивание с вероятностью pcross}
          jcross:=rnd(1,flchrom-1);            {Определение точки сечения в диапазоне между 1 и l-1}
          ncross:=ncross + 1;                {Инкрементирование счетчика скрещиваний}
      end else
          jcross:=flchrom;
      {певая часть обмена , 1 to 1 and 2 to 2}
      for j := 1 to jcross do begin
          child1[j]:=mutation(parent1[j], pmutation, nmutation);
          child2[j]:=mutation(parent2[j], pmutation, nmutation);
      end;
      {вторая часть обмена, 1 to 2 and 2 to 1}
      if jcross<>flchrom then                {пропуск, если точка скрещивания равна flchrom--скрещивание не происходит}
          for j := jcross+1 to flchrom do begin
              child1[j] := mutation(parent2[j], pmutation, nmutation);
              child2[j] := mutation(parent1[j], pmutation, nmutation);
          end;
  end;

  {================================================================================}

  procedure generation;
  {Генерирование нового поколения при помощи отбора, скрещивания и мутации}
  {Прим: предполагается, что популяция имеет четный размер}
  var
      j, mate1, mate2, jcross:integer;
  begin
      select;
      j := 1;
      repeat
          {выполняются отбор, скрещивание и мутация, пока полностью не сформируется новая популяция ? newpop}
          mate1:=j;
          {выбор родительской пары}
          mate2:=j+1;
          {скрещивание и мутация ? мутация вставлена в процедуру скрещивания}
          crossover(oldpop[mate1].chrom, oldpop[mate2].chrom,    newpop[j].chrom, newpop[j + 1].chrom, lchrom*dim, ncross, nmutation, jcross, pcross, pmutation);
          {Декодирование строки и вычисление пригодности}
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
    popsize:=6;                    {размер популяции}
    lchrom:=20;                        {число битов на один кодируемый параметр}
    maxgen:=18;                    {максимальное число поколений}
    pmutation:=0.1;                {вероятность скрещивания}
    pcross:=0.9;                    {вероятность мутации}
    randomize;                        {Инициализация генератора случайных чисел}
    nmutation := 0;    ncross := 0;    {Инициализация счетчиков}
    initpop;
    statistics (popsize, max, avg, min, sumfitness, oldpop);
    gen:= 0;                        {Установка счетчика поколений в 0}
    repeat {Главный итерационный цикл}
        gen:= gen + 1;
        Memo1.Text:= Memo1.Text + #13#10 + '______________________________Поколение № ' + FloatToStr(gen) + #13#10;
        generation;
        statistics(popsize, max, avg, min, sumfitness, newpop);
        oldpop:= newpop;            {переход на новое поколение }
    until (gen >= maxgen);
    //writeln('global min= ',min:10:8);
    Memo1.Text:= Memo1.Text + #13#10 + 'global min= ' + FloatToStrF(min,ffFixed,15,6) + #13#10;


end;

end.
