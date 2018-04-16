%% Kandidat projekt , heuristik 1

% Karta över fiktiv stad.
xled = 60;
yled = 60; 
stad = zeros(xled,yled); 
tid = 57600; % Antal sekunder på 16 timmar 
%Skapar en matris för de 10 taxibilarna som kommer användas.
Taxibilar = zeros(10,4); 
Taxibilar(:,2) = 30; % Startposition för taxibilarnar i x-led
Taxibilar(:,3) = 30; % Startposition för taxibilarnar i y-led

listan = xlsread('Kundlista');
[rows,columns] = size(listan);

for i = 1:rows
    %Beräknar avståndet från upphämtning till anlämning av varje kund
   dist(i) = abs(listan(i,2) - listan(i,4)) + abs(listan(i,3) - listan(i,5)); 
   %Beräkning av totala distansen taxin får åka enligt kundens sammarbetsvilja.
   Totaldis(i) = (1+listan(i,6)) * dist(i);
end

% Sorterar kundlistan efter tiden som kunderna ringer in. Ringer in först =
% kommer överst 
kundlista = sortrows(listan,6);
A = zeros(1,rows); % Lägger till en nollvektor där nollan motsvarar kundens status.
kundlista = [kundlista, A']; %Kundens status motsvarar, 
%0 = ej aktuell, unden har inte ringt.
%k 1 = kunden har ringt och taxi är påväg/taxi kör kunden till kundens slutdestination.
%2 = Kunden har blivit betjänad. 

%bagtid = 12; % Tiden i sekunder att färdas 100m, mellan 2 noder (hastighet = 8.33m/s)
%plats_taxi = 4; % Antalet platser i taxibilen.
klockan = 0; % klockan går mellan 0 och 57600 sekunder (16 timmar).
riktning_x = zeros(10,1); % Riktningen som taxin ska färdas i x-led.
riktning_y = zeros(10,1); % Riktningen som taxin ska färdas i y-led.
for i = 0:tid
    for j = 1:rows
    if (klockan == kundlista(j,6)) % Kund ringer in 
        kundlista(j,8) = kundlista(j,8) + 1;
        if(1 == kundlista(j,8))
          for k = 1:10
                if (Taxibilar(k,1) == 0)    % Tilldelar en taxi ett jobb
            Taxibilar(k,1) = Taxibilar(k,1) + 1;
            % Beräknar riktningen taxin ska färdas för att hämta upp en %kund.
            riktning_x(k,1) = riktning_x(k,1) + (Taxibilar(k,2) - kundlista(k,2));
            riktning_y(k,1) = riktning_x(k,1) + (Taxibilar(k,3) - kundlista(k,3));
                break % Avbryter loopen när en taxi tilldelas en kund.
                end
            end
            
        end
    end
    %Beräknar hur taxibilarna färdas då de ska till en kund.
    for k = 1:10
        if (Taxibilar(k,1) == 1)
        %    Taxibilar(k,1) == 
        end 
    end
    end 
    klockan = klockan +1;
end

%% Kan möligvis användas 
for i = 1:10
    if Taxibilar(i,1) == 0 % ledig.
     
    end 

    if Taxibilar(i,1) == 1 % påväg till kund.
    
    end

    if Taxibilar(i,1) == 2 % plockat upp först kund.
    
    end 

    if Taxibilar(i,1) == 4 % Rast. 
    
    end 
end 