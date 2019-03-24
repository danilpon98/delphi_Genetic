unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series;

const
  maxpop = 100;   {максимальный размер популяции}
  maxstring = 20;
  dim = 1;        {размерность пространства поиска}

type
  allele = boolean;                                  {позиция в битовой строке}
  chromosome = array[1..maxstring*dim] of allele;    {битовая строка}
  fenotype = array[1..dim] of real;                  {фенотип = массив вещественных координат точки в пространстве поиска}
  individual = record
    chrom:chromosome; {генотип = битовая строка}
    x:fenotype;       {фенотип = массив вещественных координат точки в пространстве поиска}
    fitness:real;     {значение целевой функции}
  end;
  population = array[1..maxpop] of individual;

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    UpDown1: TUpDown;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    UpDown2: TUpDown;
    Edit4: TEdit;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TPointSeries;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//const
  //xmax:fenotype=(7); {массив максимальных значений для координат точки в пространстве поиска}
  //xmin:fenotype=(0); {массив минимальных значений для координат точки в пространстве поиска}

var
  Form1: TForm1;
  oldpop, newpop, intpop :population;  {Три непересекающихся популяции: старая, новая и проме-жуточная}

    popsize,    {размер популяции}
    lchrom,     {число битов на один кодируемый параметр} {Пример, с 20 битами на параметр мы получаем область из 2^20 = 1048576 дискретных значений}
    gen,        {счетчик поколений}
    maxgen      {максимальное число поколений}
  :integer;     {Глобальные целые переменные}

    pcross,     {вероятность скрещивания}
    pmutation,  {вероятность мутации}
    sumfitness  {Накопление суммы значений функции пригодности для рассчета среднего}
  :real;        {глобальные вещественные переменные}

    nmutation,    {счетчик мутаций}
    ncross        {счетчик скрещиваний}
  :integer;    {Статистические целые}

  avg, max, min, bestmin, xbest, xMinS:real;{Статистические вещественные}

    xmax,   {массив максимальных значений для координат точки в пространстве поиска}
    xmin    {массив минимальных значений для координат точки в пространстве поиска}
  :fenotype;


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


  function rnd(low,high:integer):integer;   {Функция определение точки сечения в диапазоне между 1 и l-1 (Случайный выбор между low и high)}
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

  function objfunc(x:fenotype):real;  { Функция }
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
          Memo1.Text:= Memo1.Text + 'x= ' + FloatToStrF(x[i],ffFixed,15,6) + #13#10;
      end
  end;

  {================================================================================}


  {Расчет статистических величин: минимального, максимального и среднего значений целевой функции  }
  procedure statistics(popsize:integer; var max,avg,min,sumfitness:real; var pop:population); {Расчет статистик популяции }
  var j:integer;
  begin
      {Инициализация }

      sumfitness := pop[1].fitness;
      min := pop[1].fitness;
      max := pop[1].fitness;
      xMinS:= pop[1].x[1];
      {Цикл для max, min, sumfitness }
      for j := 2 to popsize do with pop[j] do begin
          sumfitness := sumfitness + fitness;        {Накопление суммы значений функции пригодности}
          if fitness>max then max := fitness;        {Новое значение max}
          if fitness<min then begin
              min := fitness;
              xMinS := x[1];
          end;        {Новое значение min}
      end;

      Memo1.Text:= Memo1.Text + #13#10 + 'min= ' + FloatToStrF(min,ffFixed,15,6) + #13#10;
      Memo1.Text:= Memo1.Text + 'xMin= ' + FloatToStrF(xMinS,ffFixed,15,6) + #13#10;

      avg := sumfitness/popsize; {Расчет среднего}
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
         Memo1.Text:= Memo1.Text + 'fitness_initpop= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
      end;
  end;

  {================================================================================}

  {3 генетических оператора: отбора (select), скрещивания (crossover) и мутации (mutation)}
  procedure select; {процедура турнирного отбора}
  var ipick:integer;

      procedure shuffle(var pop:population);    {процедура перемешивания популяции в процессе отбора.}
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

      function select_1:integer;  {осуществляет отбор наилучших особей для популяции}
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
      {мутация одного бита в строке (аллеля) с вероятностью pmutation}
      { alleleval – ген для мутации}
  var
      mutate:boolean;
  begin
      mutate := flip(pmutation);       { Мутация с вероятностью PMutation }
      if mutate then begin
          nmutation := nmutation + 1;  { Наращиваем счетчик мутаций }
          mutation := not alleleval;   { Совершаем мутацию }
      end else mutation := alleleval;  { Не делаем мутацию }
  end;

  { Процедцра скрещивания 2 родительских строк, результат помещается в 2 строках-потомках}
  { реализация одноточечного скрещивания}
  procedure crossover(var parent1, parent2, child1, child2:chromosome; flchrom:integer; var ncross, nmutation, jcross:integer; var pcross, pmutation:real);
    {parent1, parent2 – хромосомы родителей}
    {child1,child2 – хромосомы потомков}
    {flchrom – длина хромосомы (количество генов)}
    {ncross, nmutation – счетчики количества скрещиваний и мутаций}
    {jcross – точка сечения.}
  var
      j:integer;
  begin
      if flip(pcross) then begin      {Выполняется скрещивание с вероятностью pcross}
          jcross:=rnd(1,flchrom-1);   {Определение точки сечения в диапазоне между 1 и l-1}
          ncross:=ncross + 1;         {Инкрементирование счетчика скрещиваний}
      end else
          jcross:=flchrom;
      {певая часть обмена , 1 to 1 and 2 to 2}{ Обмениваем часть после точки сечения }
      for j := 1 to jcross do begin
          { Заодно и мутируем с вероятностью pmutation }
          { Первый потомок }
          child1[j]:=mutation(parent1[j], pmutation, nmutation);
          { Второй потомок }
          child2[j]:=mutation(parent2[j], pmutation, nmutation);
      end;
      {вторая часть обмена, 1 to 2 and 2 to 1}
      if jcross<>flchrom then                {пропуск, если точка скрещивания равна flchrom--скрещивание не происходит}
          for j := jcross+1 to flchrom do begin
              { Заодно и мутируем с вероятностью pmutation }
              { Первый потомок }
              child1[j] := mutation(parent2[j], pmutation, nmutation);
              { Второй потомок }
              child2[j] := mutation(parent1[j], pmutation, nmutation);
          end;
  end;

  {================================================================================}

  procedure generation;
  {Генерирование нового поколения при помощи отбора, скрещивания и мутации}
  {Прием: предполагается, что популяция имеет четный размер}
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
              Memo1.Text:= Memo1.Text + 'fitness1= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
          end;
          with newpop[j+1] do begin
              decode(chrom, lchrom,x);
              fitness := objfunc(x);
              Memo1.Text:= Memo1.Text + 'fitness2= ' + FloatToStrF(fitness,ffFixed,15,6) + #13#10;
          end;
          j := j + 2;
      until j>popsize
  end;

  procedure plotting;
  var i:fenotype;
    h:Real;
  begin
    Series1.Clear;
    h:= (xmax[1] - xmin[1])/50;
    i[1]:=xmin[1];
    while i[1]<=xmax[1] do begin
       Series1.AddXY(i[1],objfunc(i));
       i[1]:=i[1]+h;
    end;
  end;

begin
    Memo1.Clear;
    xmax[1]:=StrToFloat(Edit3.Text);
    xmin[1]:=StrToFloat(Edit2.Text);
    plotting; {построение графика}
    popsize:=StrToInt(Edit1.Text);  {размер популяции}
    lchrom:=20;                     {число битов на один кодируемый параметр}
    maxgen:=StrToInt(Edit4.Text);   {максимальное число поколений}
    pmutation:=0.1;                 {вероятность мутации}
    pcross:=0.9;                    {вероятность скрещивания}
    randomize;                      {Инициализация генератора случайных чисел}
    nmutation := 0;    ncross := 0; {Инициализация счетчиков}
    initpop;
    statistics (popsize, max, avg, min, sumfitness, oldpop);
    bestmin:= min;
    gen:= 0;                        {Установка счетчика поколений в 0}
    ProgressBar1.Max:= maxgen;
    repeat {Главный итерационный цикл}
        gen:= gen + 1;
        ProgressBar1.Position := gen;
        Memo1.Text:= Memo1.Text + #13#10 + '______________________________Поколение № ' + FloatToStr(gen) + #13#10;
        generation;
        statistics(popsize, max, avg, min, sumfitness, newpop);
        if min < bestmin then begin
          bestmin := min;
          xbest:= xMinS;
        end;
        oldpop:= newpop;  {переход на новое поколение }
    until (gen >= maxgen);

    Memo1.Text:= Memo1.Text + #13#10 + 'Best min= ' + FloatToStrF(bestmin,ffFixed,15,6) + #13#10;
    Memo1.Text:= Memo1.Text + 'Best x= ' + FloatToStrF(xbest,ffFixed,15,6) + #13#10;

end;

end.
