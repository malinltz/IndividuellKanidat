%% Kandidat projekt , heuristik 1
clear ;
% Karta över fiktiv stad.
xled = 600;
yled = 600;
stad = zeros(xled,yled);
tid = 57600; % Antal sekunder på 16 timmar
%Skapar en matris för de 10 taxibilarna som kommer användas.
Taxibilar = zeros(10,5);
Taxibilar(:,2) = 300; % Startposition för taxibilarnar i x-led
Taxibilar(:,3) = 300; % Startposition för taxibilarnar i y-led
x=0:600;
y=0:600;

listan = xlsread('Kundlista');
[rows,columns] = size(listan);
%for i = 1:rows
%     %Beräknar avståndet från upphämtning till anlämning av varje kund
%     dist(i) = abs(listan(i,2) - listan(i,4)) + abs(listan(i,3) - listan(i,5));
%     %Beräkning av totala distansen taxin får åka enligt kundens sammarbetsvilja.
%     Totaldis(i) = (1+listan(i,6)) * dist(i); % används endast i heuristk 2.
% end
% Sorterar kundlistan efter tiden som kunderna ringer in. Ringer in först =
% kommer överst

kundlista = sortrows(listan,6);
A = zeros(1,rows); % Lägger till en nollvektor där nollan motsvarar kundens status.
kundlista = [kundlista, A',A',A',A',A']; %Kundens status motsvarar,
%0 = ej aktuell, kunden har inte ringt.
%k 1 = kunden har ringt och taxi är påväg/taxi kör kunden till kundens slutdestination.
%2 = Kunden har blivit betjänad.
%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan går mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,4); % Riktningen som taxin ska färdas i x-led.
riktning_y = zeros(10,4); % Riktningen som taxin ska färdas i y-led.

%Lägg till en till for-loop för att köra heuristiken flera gånger.
for i = 0:tid
    x = i/1800;
    if(floor(x) == x && x ~=0)
  radien= 5;
 vinkel= 0:pi/50:2*pi;
    x1 = radien.*cos(vinkel)+(Taxibilar(1,2));
    x1 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi1=plot(x1,x1,'b');
    
    x2 = radien.*cos(vinkel)+(Taxibilar(2,2));
    x2 = radien.*sin(vinkel)+(Taxibilar(2,3));
    postaxi2= plot(x2,x2,'b');
    
    x3= radien.*cos(vinkel)+(Taxibilar(3,2));
    x3 = radien.*sin(vinkel)+(Taxibilar(3,3));
    postaxi3= plot(x3,x3,'b');
    
    x4= radien.*cos(vinkel)+(Taxibilar(4,2));
    x4 = radien.*sin(vinkel)+(Taxibilar(4,3));
    postaxi4= plot(x4,x4,'b');
    
    x5= radien.*cos(vinkel)+(Taxibilar(5,2));
    x5 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi5=plot(x5,x5,'b');
    
    x6= radien.*cos(vinkel)+(Taxibilar(6,2));
    x6 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi6= plot(x6,x6,'b');
    
    x7= radien.*cos(vinkel)+(Taxibilar(7,3));
    x7 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi7=  plot(x7,x7,'b');
    
    x8= radien.*cos(vinkel)+(Taxibilar(8,3));
    x8 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi8= plot(x8,x8,'b');
    
    x9= radien.*cos(vinkel)+(Taxibilar(9,3));
    x9 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi9=  plot(x9,x9,'b');
    
    x10= radien.*cos(vinkel)+(Taxibilar(10,3));
    x10 = radien.*sin(vinkel)+(Taxibilar(1,3));
    postaxi10= plot(x1,x1,'b');
    
    y1 = (kundlista(j,1));
    y2 = (kundlista(j,2));
    y3 = (kundlista(j,3));
    y4 = (kundlista(j,4));

plot(x1,x2,'o');
hold on 
plot(y1,y2, '+')
hold on
plot(y3,y4,'*');
hold on    
plot(x,y);

%xlabel();
%ylabel();

%hold on
%plotmatrix(x1,'g');

grid minor
grid on
        pause
    end
    for j = 1:rows
        if (kundlista(j,8) == -1)
             for k = 1:10
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin är ledig
                    Taxibilar(k,4) = Taxibilar(k,4) + 1; % Counter, för hur många körningar varje taxibil tar på sig.
                    disp(['Taxibil nr: ',num2str(k),' betjänar kund nr: ', num2str(j)])
                    Taxibilar(k,1) = 1; % Sätter taxibilens status till 2.
                    Taxibilar(k,5) = 0; % Återställer tiden för kunden att ta sig in/ut ur bilen.
                    % Beräknar riktningen taxin ska färdas för att hämta upp en kund.
                    riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                    riktning_x(k,2) = riktning_x(k,1)/abs(riktning_x(k,1));
                    riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                    riktning_y(k,2) = riktning_y(k,1)/abs(riktning_y(k,1));
                    % Beräknar riktningen taxin ska färdas för att lämna av en kund.
                    riktning_x(k,3) = (kundlista(j,3) - kundlista(j,1));
                    riktning_x(k,4) = riktning_x(k,3)/abs(riktning_x(k,3));
                    riktning_y(k,3) = (kundlista(j,4) - kundlista(j,2));
                    riktning_y(k,4) = riktning_y(k,3)/abs(riktning_y(k,3));
                    kundlista(j,8) = 1;% Taxibil skickas till en kund
                    kundlista(j,12) = k;
                    break % Avbryter loopen när en taxi tilldelas en kund.
                else 
                    kundlista(j,9) = kundlista(j,9) + 1;
                end
             end
        end
        
        if (klockan == kundlista(j,6)) % Kund ringer in

            for k = 1:10
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin är ledig
                    Taxibilar(k,4) = Taxibilar(k,4) + 1; % Counter, för hur många körningar varje taxibil tar på sig.
                    disp(['Taxibil nr: ',num2str(k),' betjänar kund nr: ', num2str(j)])
                    Taxibilar(k,1) = 1; % Sätter taxibilens status till 2.
                    Taxibilar(k,5) = 0; % Återställer tiden för kunden att ta sig in/ut ur bilen.
                    % Beräknar riktningen taxin ska färdas för att hämta upp en kund.
                    riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                    riktning_x(k,2) = riktning_x(k,1)/abs(riktning_x(k,1));
                    riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                    riktning_y(k,2) = riktning_y(k,1)/abs(riktning_y(k,1));
                    % Beräknar riktningen taxin ska färdas för att lämna av en kund.
                    riktning_x(k,3) = (kundlista(j,3) - kundlista(j,1));
                    riktning_x(k,4) = riktning_x(k,3)/abs(riktning_x(k,3));
                    riktning_y(k,3) = (kundlista(j,4) - kundlista(j,2));
                    riktning_y(k,4) = riktning_y(k,3)/abs(riktning_y(k,3));
                    kundlista(j,8) = 1;% Taxibil skickas till en kund
                    kundlista(j,12) = k;
                    break % Avbryter loopen när en taxi tilldelas en kund.
                else
                    kundlista(j,8) = -1;
                end
            end
        end

        %Beräknar hur taxibilarna färdas då de ska till en kund.
        
        for k = 1:10
            if (Taxibilar(k,1) == 1 && kundlista(j,8) == 1 && kundlista(j,12) == k)
                if (Taxibilar(k,5) == 100) % Extra tid för att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,1)) % kollar att taxin har "rätt" värde i x-led
                        Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,2));
                    end
                    if(Taxibilar(k,2) == kundlista(j,1) && Taxibilar(k,3) ~= kundlista(j,2))
                        Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,2));
                    end
                    if(Taxibilar(k,2) == kundlista(j,1) && Taxibilar(k,3) == kundlista(j,2))
                        Taxibilar(k,1) = 2; %Kunden har plockats upp
                        Taxibilar(k,5) = 0;
                        kundlista(j,8) = 2;
                        kundlista(j,10) = klockan; %Sparar tiden då kunden blir upplockad
                 %       disp(['Taxibil nr: ',num2str(k),' har hämtat upp kund nr: ',num2str(j)])
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % Räknar tiden för kunden att ta sig
                end
            end
            if (Taxibilar(k,1) == 2 && kundlista(j,8) == 2 && kundlista(j,12) == k)  %Om kunden har plockats upp
                if (Taxibilar(k,5) == 100) % Extra tid för att kunde ska ta sig in i taxin.
                    if(Taxibilar(k,2) ~= kundlista(j,3)) % kollar att taxin har "rätt" värde i x-led
                        Taxibilar(k,2) = Taxibilar(k,2) + (riktning_x(k,4));
                        
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) ~= kundlista(j,4))
                        Taxibilar(k,3) = Taxibilar(k,3) + (riktning_y(k,4));
                        
                    end
                    if(Taxibilar(k,2) == kundlista(j,3) && Taxibilar(k,3) == kundlista(j,4)) % kollar att bilen är framme vid kundens slutdestionation
                        Taxibilar(k,1) = 0; %Kunden har lämnats av
                        Taxibilar(k,5) = 0;
                        kundlista(j,8) = 3;
                        kundlista(j,11) = klockan; %Sparar tiden då kunden blir avlämnad
                  %      disp(['Taxibil nr: ',num2str(k),' har lämnat upp kund nr: ',num2str(j)])
                    end
                else
                    Taxibilar(k,5) = Taxibilar(k,5) + 1; % Räknar tiden för kunden att ta sig
                end
            end
        end

    end
    klockan = klockan +1; 

end

