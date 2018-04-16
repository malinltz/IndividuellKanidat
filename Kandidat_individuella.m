%% Kandidat projekt , heuristik 1

% Karta �ver fiktiv stad.
xled = 60;
yled = 60; 
stad = zeros(xled,yled); 
tid = 57600; % Antal sekunder p� 16 timmar 
%Skapar en matris f�r de 10 taxibilarna som kommer anv�ndas.
Taxibilar = zeros(10,4); 
Taxibilar(:,2) = 30; % Startposition f�r taxibilarnar i x-led
Taxibilar(:,3) = 30; % Startposition f�r taxibilarnar i y-led

listan = xlsread('Kundlista');
[rows,columns] = size(listan);

for i = 1:rows
    %Ber�knar avst�ndet fr�n upph�mtning till anl�mning av varje kund
   dist(i) = abs(listan(i,2) - listan(i,4)) + abs(listan(i,3) - listan(i,5)); 
   %Ber�kning av totala distansen taxin f�r �ka enligt kundens sammarbetsvilja.
   Totaldis(i) = (1+listan(i,6)) * dist(i);
end

% Sorterar kundlistan efter tiden som kunderna ringer in. Ringer in f�rst =
% kommer �verst 
kundlista = sortrows(listan,6);
A = zeros(1,rows); % L�gger till en nollvektor d�r nollan motsvarar kundens status.
kundlista = [kundlista, A']; %Kundens status motsvarar, 
%0 = ej aktuell, unden har inte ringt.
%k 1 = kunden har ringt och taxi �r p�v�g/taxi k�r kunden till kundens slutdestination.
%2 = Kunden har blivit betj�nad. 

%bagtid = 12; % Tiden i sekunder att f�rdas 100m, mellan 2 noder (hastighet = 8.33m/s)
%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan g�r mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,1); % Riktningen som taxin ska f�rdas i x-led.
riktning_y = zeros(10,1); % Riktningen som taxin ska f�rdas i y-led.
for i = 0:tid
    for j = 1:rows
    if (klockan == kundlista(j,6)) % Kund ringer in 
        kundlista(j,8) = kundlista(j,8) + 1;
        if(1 == kundlista(j,8))
          for k = 1:10
                if (Taxibilar(k,1) == 0)    % Tilldelar en taxi ett jobb
            Taxibilar(k,1) = Taxibilar(k,1) + 1;
            % Ber�knar riktningen taxin ska f�rdas f�r att h�mta upp en %kund.
            riktning_x(k,1) = riktning_x(k,1) + (Taxibilar(k,2) - kundlista(k,2));
            riktning_y(k,1) = riktning_x(k,1) + (Taxibilar(k,3) - kundlista(k,3));
                break % Avbryter loopen n�r en taxi tilldelas en kund.
                end
            end
            
        end
    end
    %Ber�knar hur taxibilarna f�rdas d� de ska till en kund.
    for k = 1:10
        if (Taxibilar(k,1) == 1)
        %    Taxibilar(k,1) == 
        end 
    end
    end 
    klockan = klockan +1;
end

%% Kan m�ligvis anv�ndas 
for i = 1:10
    if Taxibilar(i,1) == 0 % ledig.
     
    end 

    if Taxibilar(i,1) == 1 % p�v�g till kund.
    
    end

    if Taxibilar(i,1) == 2 % plockat upp f�rst kund.
    
    end 

    if Taxibilar(i,1) == 4 % Rast. 
    
    end 
end 