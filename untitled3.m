         s = 1;
            stracka = 0;
            for k = 1:10
                if (Taxibilar(k,1) == 0) % Tilldelar en taxi ett jobb om taxin är ledig
                     riktning_x(k,1) = (kundlista(j,1) - Taxibilar(k,2));
                     riktning_y(k,1) = (kundlista(j,2) - Taxibilar(k,3));
                     
                     stracka(s,1) = abs(riktning_x(k,1)) + abs(riktning_y(k,1));
                     stracka(s,2) = k;
         
                     s = s +1;
                end
            end
                    valAvBil = min(stracka);
                    A = valAvBil(1,2);
                    
                    pause
                    