import ddf.minim.*;                    //import bibliotek potrzebnych do działania wizualizatora
import ddf.minim.analysis.*;

Minim minim;                           //inicjalizacja biblioteki minim
AudioPlayer song;                      //inicjalizacja odtwarzacza audio
BeatDetect beat;                       //inicjalizacja wykrywania dźwięków   

String songPath = "song.mp3";          //zmienna przechowująca nazwę pliku muzycznego używanego do wizualizacji
float movieFPS = 30;                   //pozadana ilosc klatek na sekunde w animacji 
float radius = 100;                    //promien kół rysowanych w wizualizacji

void setup()
{  
  background(0);
  size(700, 700);                       //ustawienie rozmiaru okna 
  minim = new Minim(this);              //stworzenie instancji biblioteki minim
  song = minim.loadFile(songPath);      //ładowanie utworu
  beat = new BeatDetect();              //stworzenie instancji wykrywania dźwięków
  frameRate(movieFPS);                  //ustalenie ilości klatek na sekundę w wizualizacji    
}

void draw()
{
  
   beat.detect(song.mix);                                            //aktywacja wykrywania dźwięków
   float a = map(radius, 20, 100, 0, 60);                            //zmienna przypisująca zmianę koloru tła do zmiany promienia koła
   fill(a, 100);                                                     //ustawienie koloru tła      
   noStroke();                                                       //wyłączenie linii obwodzących kwadrat   
   rect(0, 0, width, height);                                        //rysowanie kwadratu, będacego tłem całej wizualizacji.  
    
   stroke(#d4ff00);                                                  //ustawienie koloru "linii" 
   fill(#d4ff00);                                                    //ustawienie wypełnienia linii
   for(int i = 0; i < song.bufferSize() - 1; i++)                    //pętla tworząca cztery linie złożone z będących blisko siebie elips
    {
      ellipse(i*8, 100 + song.left.get(i)*100, 5, 1);               //linia górna pozioma
      ellipse(100 + song.left.get(i)*100, i*8, 1, 5);               //linia lewa pionowa
      ellipse(i*8, height - 100 + song.right.get(i)*100, 5, 1);    //linia dolna pozioma
      ellipse(width - 100 + song.right.get(i)*100, i*8, 1, 5);     //linia prawa pionowa
    }
  
  if ( beat.isOnset() ) radius = 100;                               //jeśli wykryto dźwięk, promień zmienia się 
  radius *= .85;                                                    //zmiana wielkości promienia, gdy nie wykryto żadnego dźwięku
  if (radius < 20) radius = 20;                                     //promień kół nie może być mniejszy niż 20 pikseli
  float b = map(radius, 20, 100, 60, 255);                          //ustalenie przeźroczystości kół w zależności od ich promieni
  
  
  fill(#fff200,b);                                                  //ustalenie koloru większych kół
  noStroke();                                                       //wyłączenie linii obwodzących większe koła
  ellipse(width/2, height/2, 4*radius, 4*radius);                   //rysowanie środkowego większego koła
  ellipse(0,0, radius, radius);                                     //rysowanie większego koła w lewym górnym rogu
  ellipse(width,0,radius,radius);                                   //rysowanie większego koła w prawym górnym rogu
  ellipse(0, width, radius, radius);                                //rysowanie większego koła w lewym dolnym rogu
  ellipse(height, width, radius, radius);                           //rysowanie większego koła w prawym dolnym rogu
  
  fill(#0026ff, b);                                                 //ustalenie koloru mniejszych kół
  noStroke();                                                       //wyłączenie linii obwodzących mniejsze koła                  
  ellipse(width/2, height/2, 2*radius, 2*radius);                   //rysowanie środkowego mniejszego koła
  ellipse(0, 0, radius/2,radius/2);                                 //rysowanie mniejszego koła w prawym dolnym rogu
  ellipse(width,0,radius/2,radius/2);                               //rysowanie mniejszego koła w prawym górnym rogu
  ellipse(0, width, radius/2, radius/2);                            //rysowanie mniejszego koła w lewym dolnym rogu
  ellipse(height, width, radius/2, radius/2);                       //rysowanie mniejszego koła w prawym dolnym rogu

  if(song.isPlaying())                                                   //sprawdzanie, czy utwór jest odtwarzany
  saveFrame("frames/klatka-#####.tga");                             //jeśli tak, to zostaje zapisana klatka animacji
}


void keyPressed()     //metoda pozwalajaca na wyjscie z aplikacji
{
  if (key == ESC)    //po naciśnięciu klawisza escape, aplikacja zostanie zamknięta
     {
      song.pause();                    //zatrzymanie odtwarzania utworu
      exit();                          //wyjście z aplikacji    
     }
  if (key == ' ')    //po naciśnięciu klawisza spacja, utwór zaczyna być odtwarzany
    {
      song.play();                          //rozpoczęcie odtwarzania piosenki
    }
}